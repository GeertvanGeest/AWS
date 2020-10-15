## Choose an existing ubuntu AMI
Use ubuntu version 20

## Install miniconda3
Download bash script [here](https://docs.conda.io/en/latest/miniconda.html).

```sh
sudo bash Miniconda3-latest-Linux-x86_64.sh
```

Install at `/opt/miniconda3`

### Multi-user access to conda

Based on [this tutorial](https://docs.anaconda.com/anaconda/install/multi-user/)

```sh
sudo group add condausers
sudo chgrp -R condausers /opt/miniconda3
sudo chmod 770 -R /opt/miniconda3
```

To get conda as environmental variable, users should run this at first login:

```sh
/opt/miniconda3/bin/conda init
```

## Install RStudio server
Based on [this documentation](https://rstudio.com/products/rstudio/download-server/debian-ubuntu/)

```sh
sudo apt-get install r-base
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
## Install jupyterhub

Install npm first:

```sh
sudo apt install npm
```

And install pip for native python3:

```sh
sudo apt-get install python3-pip
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
