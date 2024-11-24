# For build.sh
mode_name="lts"
package_base="linux-lts"
mode_desc="Select and use the packages for the linux-lts kernel"

# pkgrel for LTS packages
pkgrel="1"

# pkgrel for GIT packages
pkgrel_git="1"
zfs_git_commit=""
zfs_git_url="https://github.com/openzfs/zfs.git"

# Version for RC packages
pkgrel_rc="1"

header="\
# Maintainer: Jan Houben <jan@nexttrex.de>
# Contributor: Jesus Alvarez <jeezusjr at gmail dot com>
#
# This PKGBUILD was generated by the archzfs build scripts located at
#
# http://github.com/archzfs/archzfs
#
# ! WARNING !
#
# The archzfs packages are kernel modules, so these PKGBUILDS will only work with the kernel package they target. In this
# case, the archzfs-linux-lts packages will only work with the default linux-lts package! To have a single PKGBUILD target
# many kernels would make for a cluttered PKGBUILD!
#
# If you have a custom kernel, you will need to change things in the PKGBUILDS. If you would like to have AUR or archzfs repo
# packages for your favorite kernel package built using the archzfs build tools, submit a request in the Issue tracker on the
# archzfs github page.
#"

get_kernel_options() {
    msg "Checking the online package database for the latest x86_64 linux-lts kernel version..."
    if ! get_webpage "https://www.archlinux.org/packages/core/x86_64/linux-lts/" "(?<=<h2>linux-lts )[\d\w\.-]+(?=</h2>)"; then
        exit 1
    fi
    kernel_version=${webpage_output}
    kernel_version_full=$(kernel_version_full ${kernel_version})
    kernel_version_pkgver=$(kernel_version_no_hyphen ${kernel_version})
    kernel_version_major=${kernel_version%-*}
    kernel_mod_path="${kernel_version_full}-lts"
    linux_depends="\"linux-lts=\${_kernelver}\""
    linux_headers_depends="\"linux-lts-headers=\${_kernelver}\""
}

update_linux_lts_pkgbuilds() {
    get_kernel_options
    pkg_list=("zfs-linux-lts")
    archzfs_package_group="archzfs-linux-lts"
    zfs_pkgver=${openzfs_version}
    zfs_pkgrel=${pkgrel}
    zfs_conflicts="'zfs-linux-lts-git' 'zfs-linux-lts-rc' 'spl-linux-lts'"
    zfs_pkgname="zfs-linux-lts"
    zfs_utils_pkgname="zfs-utils=\${_zfsver}"
    # Paths are relative to build.sh
    zfs_pkgbuild_path="packages/${kernel_name}/${zfs_pkgname}"
    zfs_src_target="https://github.com/openzfs/zfs/releases/download/zfs-\${_zfsver}/zfs-\${_zfsver}.tar.gz"
    zfs_workdir="\${srcdir}/zfs-\${_zfsver}"
    zfs_replaces='replaces=("spl-linux-lts")'
}

update_linux_lts_rc_pkgbuilds() {
    get_kernel_options
    pkg_list=("zfs-linux-lts-rc")
    archzfs_package_group="archzfs-linux-lts-rc"
    zfs_pkgver=${openzfs_rc_version/-/_}
    zfs_pkgrel=${pkgrel_rc}
    zfs_conflicts="'zfs-linux-lts' 'zfs-linux-lts-git' 'spl-linux-lts'"
    zfs_pkgname="zfs-linux-lts-rc"
    zfs_utils_pkgname="zfs-utils-rc=\${_zfsver}"
    zfs_src_hash=${zfs_rc_src_hash}
    # Paths are relative to build.sh
    zfs_pkgbuild_path="packages/${kernel_name}/${zfs_pkgname}"
    zfs_src_target="https://github.com/openzfs/zfs/releases/download/zfs-\${_zfsver/_/-}/zfs-\${_zfsver/_/-}.tar.gz"
    zfs_workdir="\${srcdir}/zfs-\${_zfsver/_rc*/}"
}

#update_linux_lts_git_pkgbuilds() {
#    get_kernel_options
#    pkg_list=("zfs-linux-lts-git")
#    archzfs_package_group="archzfs-linux-lts-git"
#    zfs_pkgver="" # Set later by call to git_calc_pkgver
#    zfs_pkgrel=${pkgrel_git}
#    zfs_conflicts="'zfs-linux-lts' 'spl-linux-lts-git' 'spl-linux-lts'"
#    zfs_pkgname="zfs-linux-lts-git"
#    zfs_pkgbuild_path="packages/${kernel_name}/${zfs_pkgname}"
#    zfs_replaces='replaces=("spl-linux-lts-git")'
#    zfs_src_hash="SKIP"
#    zfs_makedepends="\"git\""
#    zfs_workdir="\${srcdir}/zfs"
#    if have_command "update"; then
#        git_check_repo
#        git_calc_pkgver
#    fi
#    zfs_utils_pkgname="zfs-utils-git=\${_zfsver}"
#    zfs_set_commit="_commit='${latest_zfs_git_commit}'"
#    zfs_src_target="git+${zfs_git_url}#commit=\${_commit}"
#}
