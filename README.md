# dokku-monorepo

Dokku plugin for monorepo setups.

This plugin is a fork of the [dokku-monorepo](https://github.com/sebastian/dokku-monorepo) plugin.
This plugin differs from the original in one significant way.
Whereas the original assumes that each sub-directory can be independently deployed,
this version caters to a setup where each directory:

1. Is deployed using `Dockerfile`
2. Need the root folder to be used as the `context` sent to docker in order to access shared folders and files.

## Install

```
dokku plugin:install https://github.com/sebastian/dokku-monorepo
```

## Usage

```
$ ls
.dokku-monorepo
myapp1
myapp2
```

The file .dokku-monorepo contains paths for applications to be deployed:

```
first=myapp1
second=myapp2/backend
```

The part before `=` is used to identify the dokku application. For example, here:

```
$ git remote -v
first             dokku@dokku.me:example-first
first-staging     dokku@dokku.me:example-first-staging
second            dokku@dokku.me:example-second
```

the `example-first` and `example-staging-first` applications would be deployed from the `myapp1` folder.

Each of these app folders should contain a `Dockerfile` that will be copied to the root folder
by this plugin at the time of the deployment.
Optionally they can also contain a `.dockerignore` file named `Dockerfile.dockerignore`.
If it exists it will also be copied to the top-level directory.

When you push the code to an application's remote, the folder gets detected for you:

```
$ git push first
Counting objects: 253, done.
Writing objects: 100% (253/253), 38.27 KiB | 0 bytes/s, done.
Total 253 (delta 117), reused 233 (delta 109)
=====> Monorepo detected
=====> Building using Dockerfile from ./WaterCooler
-----> Cleaning up...
-----> Building watercooler from dockerfile...
       ...
```

It's that easy!

### Local usage

If you want to experiment with building the Dockerfile locally as well, then
you can copy the `build-local.sh` to the root folder of your application.
It can be invoked as `./build-local.sh first` to build the example application
used above, located at `myapp1`.
