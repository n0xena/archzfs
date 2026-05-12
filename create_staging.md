from https://github.com/openzfs/zfs/pull/18462 pointing to https://github.com/tonyhutter/zfs/tree/zfs-2.4.2-staging clone that branch

rename `zfs` to `zfs-2.4.2-staging`

pack with `tar -cf zfs-2.4.2-staging.tar zfs-2.4.2-staging`

gzip `gzip zfs-2.4.2-staging.tar`

copy kernel and utils to new folder but use these pkgbuild

```
pkgbase="zfs-linux"
pkgname=("zfs-linux" "zfs-linux-headers")
_zfsver="2.4.2_staging"
_kernelver="7.0.5.arch1-1"
_kernelver_full="7.0.5.arch1-1"
_extramodules="${_kernelver_full/.arch/-arch}"

pkgver="${_zfsver}_$(echo ${_kernelver} | sed s/-/./g)"
pkgrel=1
makedepends=("linux-headers=${_kernelver}")
arch=("x86_64")
url="https://openzfs.org/"
source=("zfs-${_zfsver/_/-}.tar.gz")
sha256sums=("SKIP")
license=("CDDL")
depends=("kmod" "zfs-utils=${_zfsver}" "linux=${_kernelver}")
prepare() {
    cd "${srcdir}/zfs-${_zfsver/_/-}"
    sed -ri 's|(KERNELRELEASE=@LINUX_VERSION@)|\1 DEPMOD=/doesnt/exist|' module/Makefile.in
}

build() {
    cd "${srcdir}/zfs-${_zfsver/_/-}"
    ./autogen.sh
    ./configure --prefix=/usr --sysconfdir=/etc --sbindir=/usr/bin --libdir=/usr/lib \
                --datadir=/usr/share --includedir=/usr/include --with-udevdir=/usr/lib/udev \
                --libexecdir=/usr/lib --with-config=kernel \
                --with-linux=/usr/lib/modules/${_extramodules}/build \
                --with-linux-obj=/usr/lib/modules/${_extramodules}/build
    make
}

package_zfs-linux() {
    pkgdesc="Kernel modules for the Zettabyte File System."
    install=zfs.install
    provides=("zfs" "spl")
    groups=("archzfs-linux")
    conflicts=("zfs-dkms" "zfs-dkms-git" "zfs-dkms-rc" "spl-dkms" "spl-dkms-git" 'zfs-linux-git' 'zfs-linux-rc' 'spl-linux')
    replaces=("spl-linux")
    cd "${srcdir}/zfs-${_zfsver/_/-}"
    mkdir -p "${pkgdir}"/usr/share/zfs
    make DESTDIR="${pkgdir}" INSTALL_MOD_PATH=${pkgdir}/usr INSTALL_MOD_STRIP=1 install
    rm -r "${pkgdir}"/usr/share/zfs
    # Remove src dir
    rm -r "${pkgdir}"/usr/src
}

package_zfs-linux-headers() {
    pkgdesc="Kernel headers for the Zettabyte File System."
    provides=("zfs-headers" "spl-headers")
    conflicts=("zfs-headers" "zfs-dkms" "zfs-dkms-git" "zfs-dkms-rc" "spl-dkms" "spl-dkms-git" "spl-headers")
    cd "${srcdir}/zfs-${_zfsver/_/-}"
    mkdir -p "${pkgdir}"/usr/share/zfs
    make DESTDIR="${pkgdir}" install
    rm -r "${pkgdir}"/usr/share/zfs
    rm -r "${pkgdir}/lib"
    # Remove reference to ${srcdir}
    sed -i "s+${srcdir}++" ${pkgdir}/usr/src/zfs-*/${_extramodules}/Module.symvers
}
```

```
pkgname="zfs-utils"

pkgver=2.4.2_staging
pkgrel=1
pkgdesc="Kernel module support files for the Zettabyte File System."
makedepends=("python" "python-setuptools" "python-cffi")
optdepends=("python: pyzfs and extra utilities", "python-cffi: pyzfs")
arch=("x86_64")
url="http://openzfs.org/"
source=("zfs-${pkgver/_/-}.tar.gz"
        "zfs-utils.initcpio.install"
        "zfs-utils.initcpio.hook"
        "zfs-utils.initcpio.zfsencryptssh.install")
sha256sums=("SKIP"
            "d19476c6a599ebe3415680b908412c8f19315246637b3a61e811e2e0961aea78"
            "569089e5c539097457a044ee8e7ab9b979dec48f69760f993a6648ee0f21c222"
            "93e6ac4e16f6b38b2fa397a63327bcf7001111e3a58eb5fb97c888098c932a51")
license=("CDDL")
groups=("archzfs-linux")
provides=("zfs-utils" "spl-utils")
install=zfs-utils.install
conflicts=("zfs-utils" "spl-utils")
replaces=("zfs-utils-linux" "zfs-utils-linux-lts" "zfs-utils-common")
backup=('etc/zfs/zed.d/zed.rc' 'etc/default/zfs' 'etc/modules-load.d/zfs.conf' 'etc/sudoers.d/zfs')

build() {
    cd "${srcdir}/zfs-${pkgver/_/-}"
    ./autogen.sh
    ./configure --prefix=/usr --sysconfdir=/etc --sbindir=/usr/bin --with-mounthelperdir=/usr/bin \
                --libdir=/usr/lib --datadir=/usr/share --includedir=/usr/include \
                --with-udevdir=/usr/lib/udev --libexecdir=/usr/lib \
                --with-config=user --enable-systemd --enable-pyzfs \
                --with-zfsexecdir=/usr/lib/zfs --localstatedir=/var
    make
}

package() {
    cd "${srcdir}/zfs-${pkgver/_/-}"
    make DESTDIR="${pkgdir}" install
    # Remove uneeded files
    rm -r "${pkgdir}"/etc/init.d
    rm -r "${pkgdir}"/usr/share/initramfs-tools
    rm -r "${pkgdir}"/usr/lib/modules-load.d
    # Autoload the zfs module at boot
    mkdir -p "${pkgdir}/etc/modules-load.d"
    printf "%s\n" "zfs" > "${pkgdir}/etc/modules-load.d/zfs.conf"
    # fix permissions
    chmod 750 ${pkgdir}/etc/sudoers.d
    chmod 440 ${pkgdir}/etc/sudoers.d/zfs
    # Install the support files
    install -D -m644 "${srcdir}"/zfs-utils.initcpio.hook "${pkgdir}"/usr/lib/initcpio/hooks/zfs
    install -D -m644 "${srcdir}"/zfs-utils.initcpio.install "${pkgdir}"/usr/lib/initcpio/install/zfs
    install -D -m644 "${srcdir}"/zfs-utils.initcpio.zfsencryptssh.install "${pkgdir}"/usr/lib/initcpio/install/zfsencryptssh
    install -D -m644 contrib/bash_completion.d/zfs "${pkgdir}"/usr/share/bash-completion/completions/zfs
}
```

to get tests done make sure to install libaio in build system to get mmap_libaio build

test system requires these arch packages: `bc cpio fio inetutils sysstat jq smbclient pax python rsync xxhash nfs-utils lsscsi xfsprogs parted perf which libaio ksh python-cffi words` with `pamtester` from AUR

should result in test start with nothing missing

nfs-server has to be started before test run
