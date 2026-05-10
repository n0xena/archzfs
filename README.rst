====================================
Zettabyte File System for Arch Linux
====================================

Welcome to the archzfs project. This repo contains everything used to deploy ZFS to Arch Linux.

--------
Overview
--------

This repo is for personal use only as it was started in 2024 due to archzfs maintainer minextu had little time to keep the buildbot up and running. This is simply my way to provide something back to both zfs and arch - don't know if anyone even use my builds. If so: Thank you!

for tests under arch:

bc cpio fio inetutils sysstat jq smbclient pax python rsync xxhash nfs-utils lsscsi xfsprogs parted perf which libaio pamtester

also: libaio must be installed on build system to build mmap_libaio

pamtester is from aur

--------
Licenses
--------

The license of the Arch Linux package sources is MIT.

The license of ZFS is CDDL.

The license of SPL is LGPL.

.. _wiki: https://github.com/archzfs/archzfs/wiki
