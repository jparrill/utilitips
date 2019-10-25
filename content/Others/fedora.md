+++
title = "Fedora OS"
weight = 63
+++

- Get packages installed by user
```shell
dnf repoquery --qf '%{name}' --userinstalled \\n | grep -v -- '-debuginfo$' \\n | grep -v '^\(kernel-modules\|kernel\|kernel-core\|kernel-devel\)$' > pkgs_a.lst
```