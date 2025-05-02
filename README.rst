====================================
Zettabyte File System for Arch Linux
====================================

Welcome to the archzfs project. This repo contains everything used to deploy ZFS to Arch Linux.

--------
Overview
--------

This repo is for personal use only as it was started in 2024 due to archzfs maintainer minextu had little time to keep the buildbot up and running. Since the project got a new push and is now up to speed again. With release of 2.3.0 there're currently no RC builds or unsupported newer kernel versions so any build here would be redundant. With Linux 6.12 become the new LTS and the projects focus is "support stable as both latest ZFS release + latest Linux LTS" ZFS-2.3.0 for Linux-6.12 LTS is the current stable.

// I'll keep the RC configs and --enable-linux-experimental in place for future versions and will provide builds.

Due to required updates for 6.15 I withdraw the experimental flag and will only provide 6.14 builds - please refer to upstream archzfs repo instead.
If you want to build 6.15 do so on your own risk and keep a look at https://github.com/openzfs/zfs/pull/17229

--------
Licenses
--------

The license of the Arch Linux package sources is MIT.

The license of ZFS is CDDL.

The license of SPL is LGPL.

.. _wiki: https://github.com/archzfs/archzfs/wiki
