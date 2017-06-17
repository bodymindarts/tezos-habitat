# Building tezos

to build this plan you will need to install habitat via:
```
$ curl https://raw.githubusercontent.com/habitat-sh/habitat/master/components/hab/install.sh | sudo bash
```

set up an origin key that will work for local builds:
```
hab origin key generate bodymindarts
```

then in this directory run:
```
$ HAB_ORIGIN=bodymindarts hab studio enter
[1][default:/src:0]# build
(...)
[2][default:/src:0]# hab pkg export docker bodymindarts/tezos
```
