# tezos-habitat

This repository contains [Habitat](https://www.habitat.sh/) packages of the [tezos](https://github.com/tezos/tezos) binaries and individual componants you may want to run.

## Installing

The easiest way for you to install the tezos binaries on your Linux-based OS is via Habitat. (If you are on a mac you cannot use the packages directly but they are still usefull via docker exported versions.)

To install Habitat either download the cli [from the website](https://www.habitat.sh/docs/get-habitat/) or run:
```
$ curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash
$ hab -V
hab 0.24.1/20170522075711
```

then use Habitat to install the misthosio/tezos package and symlink it to your /bin directory:
```
$ sudo hab pkg install misthosio/tezos
$ sudo hab pkg binlink misthosio/tezos
$ which tezos-node
/bin/tezos-node
```

## Running a node

if you don't just want the binaries but also want to run a node you can:
```
$ sudo hab start misthosio/tezos-node
```

or if you want to run it as a docker container you can export the Habitat package via:

```
$ hab pkg export docker misthosio/tezos-node
$ docker images
REPOSITORY                 TAG                         IMAGE ID            CREATED             SIZE
misthosio/tezos-node       2017-06-06-20170621062158   b7cc6d204770        24 hours ago        446 MB
misthosio/tezos-node       latest                      b7cc6d204770        24 hours ago        446 MB
```

or simply pull the pre-exported image:
```
$ docker pull misthosio/tezos-node
$ docker run misthosio/tezos-node
```

## Running the baker / endorser

The tezos-{baker,endorser} packages will allow you to bake and endorse blocks respectively. They require a running tezos-node that they can bind to to function correctly. (Check out the [Habitat docs](https://www.habitat.sh/docs/overview/) to find out more about [runtime bindings](https://www.habitat.sh/docs/run-packages-binding/))

If you are already running a tezos-node locally you can open a new terminal and run:
```
$ sudo hab load misthosio/tezos-baker --bind node:tezos-node.default
```
to start the baker.

The baker and endorser will create their own wallet on initialization, but you can also pass in the keys of a wallet you own and have delegated stake to if you want to post bond and collect rewards of baking / endorsing

```
$ cat keys.toml
wallet_secret_key="<your_secret_key>"
wallet_public_key="<your_public_key>"
$ sudo HAB_TEZOS_BAKER=$(cat keys.toml) hab load misthosio/tezos-baker -bind node:tezos-node.default
```

Alternatively you can simply run the node, baker and endorser together using [the docker-compose file](./docker-compose.yml) from the repo root.

```
$ export DELEGATE_SECRET_KEY="<your_secret_key>"
$ export DELEGATE_PUBLIC_KEY="<your_public_key>"
$ docker-compose pull
$ docker-compose up
```

## Building the packages

If you want to build the packages yourself you will first need to extract the latest source code via:
```
$ ./bin/extract_alphanet_source
```
and then build the packages by entering the Habitat studio:

```
$ hab studio enter
[1][default:/src:0]# build tezos
[2][default:/src:0]# build tezos-node
(...)
[5][default:/src:0]# exit
$ ls -al results
total 29920
drwxr-xr-x@  7 jcarter  staff       238 Jun 21 08:22 .
drwxr-xr-x  16 jcarter  staff       544 Jun 22 09:07 ..
-rw-r--r--@  1 jcarter  staff       397 Jun 21 08:22 last_build.env
-rw-r--r--@  1 jcarter  staff  15299386 Jun 21 08:21 misthosio-tezos-2017-06-06-20170621061141-x86_64-linux.hart
-rw-r--r--@  1 jcarter  staff      2890 Jun 21 08:22 misthosio-tezos-baker-2017-06-06-20170621062210-x86_64-linux.hart
-rw-r--r--@  1 jcarter  staff      2874 Jun 21 08:22 misthosio-tezos-endorser-2017-06-06-20170621062212-x86_64-linux.hart
-rw-r--r--@  1 jcarter  staff      3894 Jun 21 08:22 misthosio-tezos-node-2017-06-06-20170621062158-x86_64-linux.hart
```

you may have to initialize your hab cli first via:
```
$ hab cli setup
```
