## Set up docker on Ubuntu

Followed instruction [here](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository)

Set up the repository:

```sh
sudo apt-get update

sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

Installation:

```sh
sudo apt-get install docker-ce docker-ce-cli containerd.io
```

Start Docker:

```sh
sudo service docker start
```

Add ubuntu to docker users:

```sh
sudo usermod -a -G docker ubuntu
```
