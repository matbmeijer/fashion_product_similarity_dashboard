home_path <<- here::here()

source(file.path(home_path, "init.R"))

# Start logging
loggit::set_logfile(sprintf(scripts$log$log_file, format(Sys.Date(), "%Y%m%d")))

get_current_style_colors(write_path = scripts$rds$raw$current_style_colors)

process_current_style_colors(df = scripts$rds$raw$current_style_colors,
                             home_path = home_path,
                             image_folder = scripts$folders$images,
                             write_path =  scripts$rds$silver$current_style_colors)

download_images(df = scripts$rds$silver$current_style_colors)

get_image_weights(df = scripts$rds$silver$current_style_colors,
                  img_width = ceiling(235/2),
                  img_height = ceiling(353/2),
                  type = "vgg16",
                  write_path = scripts$rds$silver$image_weights)

calculate_distance_matrix(matrix = scripts$rds$silver$image_weights,
                          write_path = scripts$rds$silver$distance_matrix)


generate_datatable(matrix = scripts$rds$silver$distance_matrix,
                   df = scripts$rds$silver$current_style_colors,
                   max_sample_size = 500,
                   write_path = scripts$rds$silver$dashboard_datatable)


render_dashboard(rmd_file = file.path(home_path, scripts$rmd$html_dashboard),
                 dashboard_dir = file.path(home_path, scripts$html$gold$dashboard_html),
                 favicon = file.path(home_path, scripts$ressources$favicon),
                 logo = file.path(home_path, scripts$ressources$logo),
                 css = file.path(home_path, scripts$ressources$css),
                 datatable_directory = file.path(home_path, scripts$rds$silver$dashboard_datatable))

message("Process 'Image Similarity Analysis' ended.")

# Remove and recycle
rm(list = ls())
gc()
