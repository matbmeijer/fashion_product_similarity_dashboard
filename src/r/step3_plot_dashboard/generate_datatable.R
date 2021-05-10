generate_datatable <- function(matrix,
                               df,
                               max_sample_size = 500,
                               write_path = NULL,
                               verbose = TRUE){
  if(verbose){
    message(sprintf("Function '%s' started", "generate_datatable()"))
  }

  matrix <- load_memory_or_disk_rds(matrix)
  df <- load_memory_or_disk_rds(df)

  html <- "<div class='hover01 column'><div><figure><img src='%s'></figure><span class='textbox'>%s-%s</span></div></div>"

  html_df <- df %>% mutate(html_base = sprintf(html, image_urls, ids, color)) %>% select(style_color, html_base)

  matrix <- matrix %>% inner_join(html_df, by="style_color")

  dashboard_df <- matrix %>% select(html_base, X1, X2, X3, X4, X5, distance)
  dashboard_df$X1 <- dashboard_df$html_base[dashboard_df$X1]
  dashboard_df$X2 <- dashboard_df$html_base[dashboard_df$X2]
  dashboard_df$X3 <- dashboard_df$html_base[dashboard_df$X3]
  dashboard_df$X4 <- dashboard_df$html_base[dashboard_df$X4]
  dashboard_df$X5 <- dashboard_df$html_base[dashboard_df$X5]

  #dashboard_df <- dashboard_df %>% arrange(distance)
  dashboard_df$distance <- NULL

  if(nrow(dashboard_df) > max_sample_size){
    dashboard_df <- dashboard_df[sample(x = 1:nrow(dashboard_df), size = max_sample_size),]
  }

  sketch <- htmltools::withTags(table(
    class = 'display',
    thead(
      tr(
        th(rowspan = 2, 'Base Style-Color'),
        th(colspan = 5, 'Style Color by Similarity')
      ),
      tr(
        lapply(1:5, th)
      )
    )
  ))

  tbl <- DT::datatable(
    dashboard_df,
    container = sketch,
    escape = FALSE,
    rownames = FALSE,
    extensions = c('Buttons'),
    options = list(

      scrollY = "600px",
      dom = 'Bfrtip',
      buttons = list(list(extend='excel', filename="ImageSimilarity"), list(extend='pdf', filename = "ImageSimilarity"))
    ),
    fillContainer = TRUE
  )


  if(!is.null(write_path)){
    saveRDS(object = tbl, file = write_path)
    message(sprintf("Saved file at '%s'", write_path))
  } else {
    return(tbl)
  }
  if(verbose){
    message(sprintf("Function '%s' ended", "generate_datatable()"))
  }

}




