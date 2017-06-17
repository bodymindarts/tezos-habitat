pkg_name=tezos
pkg_origin=misthosio
pkg_description="A self-amending cryptographic ledger"
pkg_upstream_url="github.com/tezos/tezos"
# pkg_license=('Apache-2.0')
pkg_dirname="tezos-src"
pkg_deps=(
  core/gcc-libs
  core/glibc
  core/gmp/6.1.0/20170513202112
  core/libev
  core/libsodium
  core/openssl
  core/zlib
  misthosio/leveldb
  misthosio/snappy
)
pkg_build_deps=(core/coreutils core/diffutils misthosio/opam core/camlp4 core/perl)
pkg_bin_dirs=(bin)

pkg_version() {
  cat "${PLAN_CONTEXT}/../tezos-src/scripts/alphanet_version"
}

do_download() {
  return 0
}

do_verify() {
  return 0
}

do_begin() {
  if [[ -f "${PLAN_CONTEXT}/../tezos-src/scripts/alphanet_version" ]]; then
    update_pkg_version
  else
    build_line "It looks like the source code of tezos has not been extracted from the alphanet container. Please run bin/extract_alphanet_source and try again."
    exit 1
  fi
}

do_prepare() {
  mkdir -p "${HAB_CACHE_SRC_PATH}/${pkg_dirname}"
  cp -r "${PLAN_CONTEXT}/../tezos-src/*" "${HAB_CACHE_SRC_PATH}/${pkg_dirname}"

  opam init --no-setup --root=${HAB_CACHE_SRC_PATH}/opam/${pkg_name}
  eval `opam config env --root=${HAB_CACHE_SRC_PATH}/opam/${pkg_name}`

  CPATH="$(pkg_path_for zlib)/include:$(pkg_path_for libev)/include:$(pkg_path_for libsodium)/include:$(pkg_path_for leveldb)/include:$(pkg_path_for snappy)/include"
  export CPATH
  build_line "Setting CPATH=$CPATH"

  LIBRARY_PATH="$(pkg_path_for zlib)/lib:$(pkg_path_for libev)/lib:$(pkg_path_for libsodium)/lib:$(pkg_path_for leveldb)/lib:$(pkg_path_for snappy)/lib"
  export LIBRARY_PATH
  build_line "Setting LIBRARY_PATH=$LIBRARY_PATH"

  if [[ ! -r /usr/bin/env ]]; then
    ln -sv "$(pkg_path_for coreutils)/bin/env" /usr/bin/env
  fi

  opam install --yes ocamlfind 
  if [[ ! -r $(ocamlfind query -format %d camlp4) ]]; then
    ln -s $(pkg_path_for camlp4)/lib/camlp4 $(ocamlfind query -format %d camlp4)
  fi

  sed -i'' 's/opam install tezos-deps/opam install --yes tezos-deps/' scripts/install_build_deps.sh
  sed -i'' 's/opam pin add typerex-build/opam pin --yes add typerex-build/' scripts/install_build_deps.sh
  sed -i'' '/opam pin --yes add typerex-build/a opam pin --yes add ezjsonm 0.4.3' scripts/install_build_deps.sh
}

do_build() {
  make build-deps
  make
}

do_install() {
  cp ./tezos-{client,node,protocol-compiler} ${pkg_prefix}/bin
}

do_strip() {
  return 0
}
