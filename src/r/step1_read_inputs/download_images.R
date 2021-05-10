download_images <- function(df,
                            sequence = 20,
                            sys_sleep = 1,
                            verbose = TRUE){
  if(verbose){
    message(sprintf("Function '%s' started", "download_images()"))
  }

  df <- load_memory_or_disk_rds(df)


  df <- df %>% filter(!file.exists(local_img_directory))

  urls <- df$image_urls
  destfiles <- df$local_img_directory

  url_list <- split(urls, floor(seq_along(urls) / sequence))
  destfiles_list <- split(destfiles, floor(seq_along(destfiles) / sequence))
  for(i in seq_along(url_list)){
    print(i)
    try(utils::download.file(url = url_list[[i]],
                             destfile = destfiles_list[[i]],
                             mode = 'wb',
                             method = "libcurl",
                             cacheOK = FALSE,
                             quiet = FALSE))
    Sys.sleep(sys_sleep)
  }


  if(verbose){
    message(sprintf("Function '%s' ended", "download_images()"))
  }
}
