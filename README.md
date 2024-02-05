# WSL Kernel Build

This repository has been set up to run automatic kernel builds for the [Windows
Subsystem for Linux (WSL)][1], specifically aiming to track down its issue
microsoft/WSL#8696 / microsoft/WSL#6982.

We have a [Dockerfile][2] for a container to run the builds in. It has been
set up according to the [WSL Kernel build documentation][3]. The built image
is available [on Docker Hub][4].

The [WSL2-Linux-Kernel][5] repository is contained here as a Git submodule. A
pushed change to its revision triggers a [workflow here][6] building the kernel
on this specific codebase, which then will be tagged and provided as a
[release][7]. Since we're building upstream kernel versions, which do not
include the WSL kernel config, we're using the
[WSL kernel config from the`linux-msft-5.4.91` tag][8] for all builds.


We're trying to use [`git-bisect`][9] to find the commit introducing the
beforementioned issue.
Since the issue does not appear instantly, but needs some inconsistent time
until it pops up, people are invited to help testing the built kernel images in
their environments. Please follow carlfriedrich/wsl-kernel-build#1 in this
repository for the progress of the bisection.

To use a custom kernel, add the following lines to your `.wslconfig` file:

```ini
[wsl2]
kernel=C:\\Path\\To\\Kernel\\bzImage-5.4.0-microsoft-standard-WSL2
```

The `.wslconfig` file is located in your `%UserProfile%` directory (usually
something like `C:\Users\your_user_name`) and can be created if it does not
exist. Afterwards, shut down WSL and restart it using either Command Promt or
PowerShell:

```shell
wsl --shutdown
wsl
```

Verify that the configured kernel is used within WSL:

```shell
$ uname --kernel-release
5.4.0-microsoft-standard-WSL2
```

Please note that the kernel version string is formatted differently than the git
tag it was created from due to the [implementation of the kernel version][10].

### Manual kernel build

In case you want to manually build a WSL kernel, you can do so as follows:

```shell
git clone https://github.com/microsoft/WSL2-Linux-Kernel.git
git checkout v5.4
git show linux-msft-5.4.91:Microsoft/config-wsl > .config
docker run --rm --hostname wsl-kernel-build \
    -u $(id -u ${USER}):$(id -g ${USER}) \
    -v $(pwd):/src \
    carlfriedrich/wsl-kernel-build \
    bash -c "make -j 32 CONFIG_LOCALVERSION_AUTO=y KCONFIG_CONFIG=.config"
```

If you want to build another version, make sure to clean the build tree before
checking out a new version:

```shell
git reset HEAD --hard
git clean -dfx
```

[1]: https://github.com/microsoft/WSL
[2]: Dockerfile
[3]: https://github.com/microsoft/WSL2-Linux-Kernel/tree/linux-msft-wsl-5.15.57.1?tab=readme-ov-file#build-instructions
[4]: https://hub.docker.com/repository/docker/carlfriedrich/wsl-kernel-build
[5]: https://github.com/microsoft/WSL2-Linux-Kernel
[6]: https://github.com/carlfriedrich/wsl-kernel-build/actions
[7]: https://github.com/carlfriedrich/wsl-kernel-build/releases
[8]: https://github.com/microsoft/WSL2-Linux-Kernel/blob/linux-msft-5.4.91/Microsoft/config-wsl
[9]: https://git-scm.com/docs/git-bisect
[10]: https://github.com/microsoft/WSL2-Linux-Kernel/blob/linux-msft-wsl-5.15.y/scripts/setlocalversion#L60-L64
