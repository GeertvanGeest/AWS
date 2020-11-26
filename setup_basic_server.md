# Set up basic AWS server

## Choose an existing ubuntu AMI

This tutorial is written for an image based on ubuntu version 20

## Install miniconda3
Download bash script [here](https://docs.conda.io/en/latest/miniconda.html).

```sh
sudo bash Miniconda3-latest-Linux-x86_64.sh
```

Install at `/opt/miniconda3`

### Multi-user access to conda

Based on [this tutorial](https://docs.anaconda.com/anaconda/install/multi-user/)

```sh
sudo groupadd condausers
sudo chgrp -R condausers /opt/miniconda3
sudo chmod 770 -R /opt/miniconda3 # if condausers can install in /opt
sudo chmod 750 -R /opt/miniconda3 # if condausers can install in ~
```

To get conda as environmental variable, users should run this at first login:

```sh
/opt/miniconda3/bin/conda init
```

### Create a general environment

Here's an example for installing a range of tools in an environment names `ngs`.

```sh
sudo su -

conda create \
-y \
-c bioconda \
--name ngs \
samtools minimap2 trimmomatic fastqc bowtie2 entrez-direct sra-tools
```

## Install RStudio server
Based on [this documentation](https://rstudio.com/products/rstudio/download-server/debian-ubuntu/)
Below you install version 4.0 on Ubuntu 20 (focal). Find the repositories for other packages/ubuntu distributions here: [https://cran.r-project.org/bin/linux/ubuntu/README.html](https://cran.r-project.org/bin/linux/ubuntu/README.html).

```sh
sudo apt update
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
sudo add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
sudo apt install r-base
```

For ubuntu version 20:

```sh
sudo apt-get install gdebi-core
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.3.1093-amd64.deb
sudo gdebi rstudio-server-1.3.1093-amd64.deb
```

Approach RStudio server through:

```sh
[AWS_IP]:8787
```

### Installing R packages available to all users

Use `sudo su -` to install packages in `/usr/local/lib/R/site-library`:

```sh
sudo su -
R
```

```r
install.packages("my_package")
```

## Install jupyterhub

Install npm first:

```sh
sudo apt install npm
```

And install pip for native python3:

```sh
sudo apt-get install python3-pip # don't think this is required
```

And then jupyterhub, configurable-http-proxy and notebook:
```sh
sudo python3 -m pip install jupyterhub
sudo npm install -g configurable-http-proxy
sudo python3 -m pip install notebook  
```

Run it for all users with:
```sh
sudo jupyterhub
```

Approach it from port 8000:

```sh
[AWS_IP]:8000
```

### Installing python packages

Everyone added to condausers can install packages with pip, e.g.:

```sh
pip install pandas
```

or, install a conda environment, and make a new kernel in a home directory (more info [here](https://ipython.readthedocs.io/en/stable/install/kernel_install.html); this should be run by all users):

```sh
python \
-m ipykernel install \
--user --name [CONDA_ENV] \
--display-name "Python ([CONDA_ENV])"
```
