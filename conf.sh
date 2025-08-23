# OpenZFS stable version
#
# FIXME: reset all kernel configs set to pkgrel=1 when this changes
#
openzfs_version="2.3.3"
openzfs_rc_version="2.4.0-rc1"

# The OpenZFS source hashes are from github.com/openzfs/zfs/releases
zfs_src_hash="844122118f0ea81205a01753bbcb1315330f8967c1f866dcd10155273131f071"
zfs_rc_src_hash="0068102a4162d7445b80218b882ff54e1acf3cfbeef909d53bd984ddcd9339b1"

zfs_initcpio_install_hash="d19476c6a599ebe3415680b908412c8f19315246637b3a61e811e2e0961aea78"
zfs_initcpio_hook_hash="569089e5c539097457a044ee8e7ab9b979dec48f69760f993a6648ee0f21c222"
zfs_initcpio_zfsencryptssh_install="93e6ac4e16f6b38b2fa397a63327bcf7001111e3a58eb5fb97c888098c932a51"

# Used to run mkaurball and mksrcinfo with lower privledges
makepkg_nonpriv_user="main"
