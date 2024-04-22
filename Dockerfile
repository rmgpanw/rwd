FROM rocker/geospatial:4.3

# Install system dependencies
# RUN apt-get update && apt-get install -y --no-install-recommends \
#     software-properties-common \
#     && add-apt-repository ppa:marutter/rrutter4.0 \
#     && apt-get update && apt-get install -y --no-install-recommends \
#     libxml2-dev \
#     libssl-dev \
#     libcurl4-openssl-dev \
#    libmariadbclient-dev \
#     && rm -rf /var/lib/apt/lists/*

# Install remotes R package
RUN R -e 'install.packages("remotes")'

# Copy the r_packages.txt file to the image working directory
COPY r_packages.txt /

# Install system dependencies for the specified R packages
RUN Rscript -e 'args <- readLines("r_packages.txt"); writeLines(remotes::system_requirements("ubuntu", "20.04", package = args))' | \
    while read -r cmd; do \
    echo $cmd && eval sudo $cmd; \
    done

# Continue with other steps to install and configure the specified R packages

# For example:
# RUN R -e 'remotes::install_cran(c("nanonext", "devtools", "tidyverse"))'
RUN Rscript -e 'install.packages(readLines("r_packages.txt"))'
RUN Rscript -e 'devtools::install_github("rmgpanw/ourproj")'
RUN Rscript -e 'devtools::install_gitlab("abolvera/eyescreenr")'
RUN Rscript -e 'devtools::install_github("rmgpanw/codemapper@dev_sct_trud")'
RUN Rscript -e 'devtools::install_github("rmgpanw/ukbwranglr")'

# Set the entry point or command if required
# ENTRYPOINT ["R"]
