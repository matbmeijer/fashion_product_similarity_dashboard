get_current_style_colors<- function(list_url = 'https://www.c-and-a.com/es/es/shop/mujer-categorias?pagenumber=%s&popImageType=still&pagesize=240',
                                    brand = 'C&A',
                                    sys_sleep = 2,
                                    write_path = NULL,
                                    verbose = TRUE){
  if(verbose){
    message(sprintf("Function '%s' started", "get_current_style_colors()"))
  }


  eCaps <- list(chromeOptions = list(
    excludeSwitches = list('enable-automation')
  ))

  port <- 8080L
  rD <- rsDriver(port = port,
                 #browser = "chrome",
                 chromever = "89.0.4389.23",
                 #platform = "WINDOWS",
                 extraCapabilities = eCaps,
                 verbose = TRUE,
                 check = TRUE) # runs a chrome browser, wait for necessary files to download

  remDr <- rD$client
  remDr$setWindowSize(width = 1280, height=800)

  remDr$setTimeout(type = "implicit", milliseconds = 3000)


  # Get to url and accept cookies
  url <- sprintf(list_url, 1)

  remDr$navigate(url)
  accept_cookies <- remDr$findElement(using = "xpath", '//*[@id="onetrust-accept-btn-handler"]')
  accept_cookies$clickElement()


  # Find number of pages
  html <- remDr$getPageSource()
  number_of_pages <- html[[1]] %>% read_html() %>%
    html_nodes(xpath="//li[@class='js-view-click']")


  pages <- c()
  for(number_of_page in number_of_pages){
    attributes <- number_of_page %>% html_attrs()
    pages <- c(pages, as.integer(attributes[names(attributes) == "data-value"]))
  }

  max_pages <- max(pages)


  # Loop through number of pages
  style_color_image_urls <- c()
  product_urls <- sprintf("https://www.c-and-a.com/es/es/shop/mujer-categorias?pagenumber=%s&popImageType=still&pagesize=240", 1:max_pages)

  for(product_url in product_urls){
    remDr$navigate(product_url)
    Sys.sleep(sys_sleep)
    html <- remDr$getPageSource()

    data_nodes <- html[[1]] %>% read_html() %>%
      html_nodes(xpath="//ul[@class='color-list']")

    for(style in data_nodes){
      style_attrs <- style %>% html_children() %>% html_attrs()
      for(style_color in style_attrs){
        style_color_filter <- names(style_color) == "data-normal-source-sm"
        if(any(style_color_filter)){
          style_color_image_url <- strsplit(style_color[style_color_filter], split = ", ")[[1]][1]
          style_color_image_urls <- c(style_color_image_urls, style_color_image_url)
        }
      }
    }
  }


  df <- data.frame(image_urls = style_color_image_urls, brand = "C&A", stringsAsFactors = FALSE)

  remDr$close()
  rD$server$stop()

  rm(rD)
  gc()

  system("taskkill /im java.exe /f", intern=FALSE, ignore.stdout=FALSE)


  if(!is.null(write_path)){
    saveRDS(object = df, file = write_path)
    message(sprintf("Saved file at '%s'", write_path))
  } else {
    return(df)
  }
  if(verbose){
    message(sprintf("Function '%s' ended", "get_current_style_colors()"))
  }
}
