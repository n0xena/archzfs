# For build.sh
mode_name="utils"
mode_desc="Select and use the utils packages"

# version
pkgrel="3"

# Version for GIT packages
pkgrel_git="2"
zfs_git_commit=""
zfs_git_url="https://github.com/zfsonlinux/zfs.git"

# Version for RC packages
pkgrel_rc="1"

header="\
# Maintainer: Jan Houben <jan@nexttrex.de>
# Contributor: Jesus Alvarez <jeezusjr at gmail dot com>
#
# This PKGBUILD was generated by the archzfs build scripts located at
#
# http://github.com/archzfs/archzfs
#"

update_utils_pkgbuilds() {
    pkg_list=("zfs-utils")
    archzfs_package_group="archzfs-linux"
    zfs_pkgver=${zol_version}
    zfs_pkgrel=${pkgrel}
    zfs_utils_pkgname="zfs-utils"
    # Paths are relative to build.sh
    zfs_utils_pkgbuild_path="packages/${kernel_name}/${zfs_utils_pkgname}"
    zfs_src_target="https://github.com/zfsonlinux/zfs/releases/download/zfs-\${pkgver}/zfs-\${pkgver}.tar.gz"
    zfs_workdir="\${srcdir}/zfs-\${pkgver}"
    zfs_utils_replaces='replaces=("zfs-utils-linux" "zfs-utils-linux-lts" "zfs-utils-common")'
}

# update_utils_rc_pkgbuilds() {
#     pkg_list=("zfs-utils-rc")
#     archzfs_package_group="archzfs-linux-rc"
#     zfs_pkgver=${zol_rc_version/-/_}
#     zfs_pkgrel=${pkgrel_rc}
#     zfs_utils_pkgname="zfs-utils-rc"
#     zfs_src_hash=${zfs_rc_src_hash}
#     # Paths are relative to build.sh
#     zfs_utils_pkgbuild_path="packages/${kernel_name}/${zfs_utils_pkgname}"
#     zfs_src_target="https://github.com/zfsonlinux/zfs/releases/download/zfs-\${pkgver/_/-}/zfs-\${pkgver/_/-}.tar.gz"
#     zfs_workdir="\${srcdir}/zfs-\${pkgver/_rc*/}"
# }

update_utils_git_pkgbuilds() {
    pkg_list=("zfs-utils-git")
    archzfs_package_group="archzfs-linux-git"
    zfs_pkgver="" # Set later by call to git_calc_pkgver
    zfs_pkgrel=${pkgrel_git}
    zfs_utils_pkgname="zfs-utils-git"
    zfs_utils_pkgbuild_path="packages/${kernel_name}/${zfs_utils_pkgname}"
    zfs_src_hash="SKIP"
    zfs_makedepends="\"git\""
    zfs_workdir="\${srcdir}/zfs"

    zfs_utils_replaces='replaces=("spl-utils-common-git" "zfs-utils-common-git")'

    if have_command "update"; then
        git_check_repo
        git_calc_pkgver
    fi
    zfs_set_commit="_commit='${latest_zfs_git_commit}'"
    zfs_src_target="git+${zfs_git_url}#commit=\${_commit}"
}
