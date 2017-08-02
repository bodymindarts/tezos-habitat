# pkg_description="Some description."
# pkg_upstream_url="http://example.com/project-name"
pkg_name=tezos-endorser
pkg_origin=misthosio
pkg_version="2017-08-01"
# pkg_license=('Apache-2.0')
pkg_deps=(misthosio/tezos core/iana-etc)
pkg_bin_dirs=(bin)
pkg_svc_user=root
pkg_svc_group=root

pkg_binds_optional=(
  [node]="rpc_port"
)


do_download() {
  return 0
}

do_verify() {
  return 0
}

do_build() {
  return 0
}

do_install() {
  return 0
}

