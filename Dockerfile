FROM rocker/geospatial:4.4

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

# Install system dependencies for Python
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    software-properties-common \
    build-essential \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    curl \
    git \
    gnupg \
    && rm -rf /var/lib/apt/lists/*

# Add the DeadSnakes PPA and its GPG key
# RUN curl -fsSL https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu/gpgkey | gpg --dearmor -o /etc/apt/trusted.gpg.d/deadsnakes-archive.gpg && \
# echo "deb https://ppa.launchpadcontent.net/deadsnakes/ppa/ubuntu jammy main" > /etc/apt/sources.list.d/deadsnakes-ppa.list

# Install Python 3.12 and its dependencies
RUN add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.12 python3.12-venv python3.12-dev python3-pip \
    python3.12-distutils python3-apt

# Set Python 3.12 as default
RUN ln -sf /usr/bin/python3.12 /usr/bin/python3

# Download and install pip directly
RUN curl -fsSL https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py

# Copy and install Python dependencies from requirements.txt (project-specific)
COPY requirements.txt /
RUN pip3 install --no-cache-dir --ignore-installed -r /requirements.txt

# Expose ports for JupyterLab and RStudio Server
EXPOSE 8787 8888
