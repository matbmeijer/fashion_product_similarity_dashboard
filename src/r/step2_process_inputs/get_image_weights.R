obtain_alogrithm_weights <- function(img_url, algorithm_notop, img_height, img_width){
  img <- keras::image_load(img_url, grayscale = FALSE, target_size = c(img_height,img_width))
  img_array <- keras::image_to_array(img)
  dim(img_array) <- c(1, dim(img_array))
  img_array <- keras::imagenet_preprocess_input(img_array)
  features <-  predict(algorithm_notop, img_array)
  return(t(matrix(as.numeric(features))))
}

get_image_weights <- function(df,
                              img_width,
                              img_height,
                              type = "vgg16",
                              write_path = NULL,
                              verbose = TRUE){
  if(verbose){
    message(sprintf("Function '%s' started", "get_image_weights()"))
  }


  df <- load_memory_or_disk_rds(df)

  df <- df %>% filter(file.exists(local_img_directory))

  if(type == "vgg16"){
    vgg16_notop = keras:::keras$applications$vgg16$VGG16(include_top = FALSE,
                                                         weights = 'imagenet',
                                                         input_tensor = NULL,
                                                         input_shape = NULL,
                                                         pooling = "avg")
  }



  useful_available_img_files <- df$local_img_directory
  algoritm_img_weights <- matrix(nrow = length(useful_available_img_files), ncol = 512)
  img_obs <- length(useful_available_img_files)

  for(i in seq_along(useful_available_img_files)){
    message(sprintf("%s  - weights for %s Image named %s calculated\n",scales::label_percent()(i/img_obs), i, basename(useful_available_img_files[i])))
    algoritm_img_weights[i,] <- tryCatch(obtain_alogrithm_weights(img_url = useful_available_img_files[i],
                                                                  algorithm_notop = vgg16_notop,
                                                                  img_height = img_height,
                                                                  img_width=img_width), error = function(e) return(NA))
  }

  rownames(algoritm_img_weights) <- df$style_color
  if(!is.null(write_path)){
    saveRDS(object = algoritm_img_weights, file = write_path)
    message(sprintf("Saved file at '%s'", write_path))
  } else {
    return(algoritm_img_weights)
  }
  if(verbose){
    message(sprintf("Function '%s' ended", "get_image_weights()"))
  }

}




