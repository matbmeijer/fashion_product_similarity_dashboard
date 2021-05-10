process_current_style_colors <- function(df,
                                         home_path,
                                         image_folder,
                                         write_path = NULL,
                                         verbose = TRUE){
  if(verbose){
    message(sprintf("Function '%s' started", "process_current_style_colors()"))
  }

  df <- load_memory_or_disk_rds(df)

  df <- df %>%
    mutate(style_color_details = gsub("\\.jpg$", "", basename(image_urls)))

  # Could have been done with purrr, but chose to not include the dependency
  ids <- unlist(lapply(strsplit(df$style_color_details, split = "-"), head, 1))
  color <- unlist(lapply(lapply(strsplit(df$style_color_details, split = "-"), head, 2), tail, 1))

  df$ids <- ids
  df$color <- color

  df <- df %>%
    mutate(local_img_directory = file.path(home_path, image_folder, sprintf("%s_%s.jpg", ids, color)),
           style_color = paste0(ids, "_", color))


  if(!is.null(write_path)){
    saveRDS(object = df, file = write_path)
    message(sprintf("Saved file at '%s'", write_path))
  } else {
    return(df)
  }
  if(verbose){
    message(sprintf("Function '%s' ended", "process_current_style_colors()"))
  }
}
