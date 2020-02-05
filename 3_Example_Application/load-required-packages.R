
# Author: Martin Papenber
# Year: 2020

# Execute the code from top to bottom to ensure that 
# all packages are installed to reproduce the examples 
# from the manuscript

if (!require("anticlust")) {
  if (!requireNamespace("remotes")) {
    install.packages("remotes")
  }
  remotes::install_github("m-Py/anticlust")
}

if (!requireNamespace("psych")) {
  install.packages("psych")
}
