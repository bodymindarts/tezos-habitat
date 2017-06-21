# pkg_description="Some description."
# pkg_upstream_url="http://example.com/project-name" 
pkg_name=tezos-node
pkg_origin=misthosio
pkg_version="2017-06-06"
# pkg_license=('Apache-2.0')
pkg_deps=(misthosio/tezos core/iana-etc core/git)
pkg_bin_dirs=(bin)
pkg_svc_user=root
pkg_svc_group=root

pkg_exports=(
  [net_port]=net_port
  [rpc_port]=rpc_port
)
pkg_exposes=(net_port rpc_port)

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
