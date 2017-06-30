# pkg_description="Some description."
# pkg_upstream_url="http://example.com/project-name"
pkg_name=tezos
pkg_origin=misthosio
pkg_version="2017-06-30"
# pkg_license=('Apache-2.0')
pkg_source="nofile.tgz"
pkg_shasum="TODO"
pkg_dirname="tezos-${pkg_version}"
pkg_deps=(
  core/gcc-libs
  core/glibc
  core/gmp/6.1.0/20170513202112
  core/leveldb
  core/libev
  core/libsodium
  core/openssl
  core/snappy
  core/zlib
)
pkg_build_deps=(core/coreutils core/diffutils misthosio/opam core/camlp4 core/perl)
pkg_bin_dirs=(bin)

do_download() {
  return 0
}

do_verify() {
  return 0
}

do_unpack() {
  return 0
}

do_begin() {
  version_file="${PLAN_CONTEXT}/../tezos-src/scripts/alphanet_version"
  if [[ -f "${version_file}" ]]; then
    if [[ "$(cat ${version_file})" != "${pkg_version}" ]]; then
      build_line "It looks like the extracted src code does not match the expected version."
      build_line "scripts/alphanet_version: $(cat ${version_file})"
      build_line "pkg_version:              ${pkg_version}"
      build_line "Perhaps pkg_version needs to be updated in the plan."
      exit 1
    fi
  else
    build_line "The tezos source code could not be found. Please extract it by running bin/extract_alphanet_source before trying to build this plan"
    exit 1
  fi
}

do_prepare() {
  cp -r "${PLAN_CONTEXT}/../tezos-src/src" "${HAB_CACHE_SRC_PATH}/${pkg_dirname}"
  cp -r "${PLAN_CONTEXT}/../tezos-src/Makefile" "${HAB_CACHE_SRC_PATH}/${pkg_dirname}"
  cp -r "${PLAN_CONTEXT}/../tezos-src/scripts" "${HAB_CACHE_SRC_PATH}/${pkg_dirname}"

  cd "${HAB_CACHE_SRC_PATH}/${pkg_dirname}"

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
  cd "${HAB_CACHE_SRC_PATH}/${pkg_dirname}"
  make build-deps
  make
}

do_install() {
  cd "${HAB_CACHE_SRC_PATH}/${pkg_dirname}"
  cp ./tezos-{client,node,protocol-compiler} ${pkg_prefix}/bin
}

do_strip() {
  return 0
}
