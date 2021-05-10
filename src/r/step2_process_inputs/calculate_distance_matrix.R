calculate_distance_matrix <- function(matrix,
                                      write_path = NULL,
                                      verbose = TRUE){
  if(verbose){
    message(sprintf("Function '%s' started", "calculate_distance_matrix()"))
  }

  matrix <- load_memory_or_disk_rds(matrix)
  style_color <- rownames(matrix)
  distance <- get.knn(matrix, k = 5)

  index_df <- data.frame(distance$nn.index)
  index_df$style_color <- style_color
  index_df$distance <- rowSums(distance$nn.dist)



  if(!is.null(write_path)){
    saveRDS(object = index_df, file = write_path)
    message(sprintf("Saved file at '%s'", write_path))
  } else {
    return(index_df)
  }
  if(verbose){
    message(sprintf("Function '%s' ended", "calculate_distance_matrix()"))
  }

}




