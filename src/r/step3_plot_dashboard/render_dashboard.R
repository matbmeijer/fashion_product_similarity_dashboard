render_dashboard <- function(rmd_file,
                             dashboard_dir,
                             favicon,
                             logo,
                             css,
                             datatable_directory,
                             verbose = TRUE){

  if(verbose){
    message(sprintf("Function '%s' started", "render_dashboard()"))
  }

  render(input=rmd_file,
         output_dir = dirname(dashboard_dir),
         output_file = basename(dashboard_dir),
         encoding = "UTF-8",
         flex_dashboard(
           self_contained = TRUE,
           favicon = favicon,
           logo = logo,
           css = css,
           params = list(directory = datatable_directory),
           navbar = list(
             list(title="Github", icon="fa-github",
                  href="https://github.com/matbmeijer",
                  target="Github")
           )
         )
  )

  if(verbose){
    message(sprintf("Function '%s' ended", "render_dashboard()"))
  }

}
