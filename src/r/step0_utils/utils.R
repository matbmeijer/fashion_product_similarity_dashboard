#join by range by @WiWeber
range_join <- function(x, y, value, left, right){
  x_result <- tibble()
  for (y_ in split(y, 1:nrow(y)))
    x_result <-  x_result %>% dplyr::bind_rows(x[x[[value]] >= y_[[left]] & x[[value]] < y_[[right]],] %>% cbind(y_))
  return(x_result)
}

palette_v2<-function(){
  return(c(rgb(54, 37, 167, maxColorValue = 255),
           rgb(217, 36, 104, maxColorValue = 255),
           rgb(255, 51, 30, maxColorValue = 255),
           rgb(255, 212, 0, maxColorValue = 255),
           rgb(101, 125, 212, maxColorValue = 255),
           rgb(8, 126, 139, maxColorValue = 255),
           rgb(211, 211, 211, maxColorValue = 255),
           rgb(0,0,255, maxColorValue = 255),
           rgb(138,43,226, maxColorValue = 255))
  )
}

na_if_null <- function(x){
  if(is.null(x)){
    x <- NA
  }
  return(x)
}


# Define if read or present
load_memory_or_disk_rds <- function(x){
  if(is.character(x) && file.exists(x)){
    x <- readRDS(x)
  }
  return(x)
}

# Define if read or present
load_memory_or_disk_csv <- function(x, sep=","){
  if(is.character(x) && file.exists(x)){
    if(sep == ","){
      x <- read.csv(x)
    } else{
      x <- read.csv2(x)
    }

  }
  return(x)
}



# Concatonate formula
conc<-function(x, y=",", decr=FALSE, unique=TRUE){
  x<-sort(unique(x), decreasing = decr)
  return(paste0(x, collapse = y))
}

# Help function - Divider function for formatting
div<-function(x, n=80){
  if(nchar(x)>0){
    x<-paste0(" ", paste(trimws(x), collapse = " "), " ")
  }
  m<-floor((n-nchar(x))/2)
  ret<-paste0(paste0(rep("#", m), collapse = ""), x, paste0(rep("#", n-m-nchar(x)), collapse = ""))
  writeClipboard(ret)
  return(cat(ret))
}
