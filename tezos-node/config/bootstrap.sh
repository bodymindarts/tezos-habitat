#!/bin/bash

rm -rf ~/.tezos-client
tezos-client -block genesis \
  activate protocol ProtoALphaALphaALphaALphaALphaALphaALphaALphaDdp3zK \
  with fitness 4 \
  and key edskRhxswacLW6jF6ULavDdzwqnKJVS4UcDTNiCyiH6H8ZNnn2pmNviL7pRNz9kRxxaWQFzEQEcZExGHKbwmuaAcoMegj5T99z
tezos-client -block head \
  add public key bootstrap1 \
  edpkuBknW28nW72KG6RoHtYW7p12T6GKc7nAbwYX5m8Wd9sDVC9yav
tezos-client -block head \
  add secret key bootstrap1 \
  edskRuR1azSfboG86YPTyxrQgosh5zChf5bVDmptqLTb5EuXAm9rsnDYfTKhq7rDQujdn5WWzwUMeV3agaZ6J2vPQT58jJAJPi
tezos-client gen keys lol
tezos-client originate free account aaa for lol
tezos-client originate free account bbb for lol
sleep 5
tezos-client mine for bootstrap1
tezos-client originate free account ccc for lol
tezos-client rpc call /blocks/head/proto/operations with {}
tezos-client rpc call /blocks/prevalidation/pending_operations with {}
sleep 1

COUNTER=100

until [ $COUNTER -lt 0 ]; do
  tezos-client mine for bootstrap1 -max-priority 1000
  tezos-client endorse for bootstrap1
  tezos-client rpc call /blocks/head/proto/operations with {}
  tezos-client rpc call /blocks/prevalidation/pending_operations with {}
  sleep 1
  let COUNTER-=1
done
