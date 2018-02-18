# Preliminary warning

Cryptcheck relies on compiling a very unsecure version of OpenSSL.
When manipulating such library, you need to be sure of what you are doing to
never deploy it on a production grade system.
Particularly, be sure to never hit `make install` during a manual build.

Build process can be quiet hard, because relying on number of tricks to be able
to use this weakened library not globally install on your system.
`LD_LIBRARY_PATH`, `C_INCLUDE_PATH`, `LIBRARY_PATH` and other environment
variables are used to inject what is needed during build process and at runtime
to override system headers and libraries.

Build process is at this time not garanteed to be reproductible.
Because of above tricks, error can happen and you need to understand GNU
internals and debug tools like `strace` to spot the cause of the trouble and to
fix it.
Given Makefiles are more generic guidelines and build recipes than fully
automated build.

# How to hack

## Setup rbenv

Because of the need of a weakened Ruby build, you need
[`rbenv`](https://github.com/rbenv/rbenv) on your system to isolate this Ruby
version from your eventual system version.

See there readme and wiki for setup process.
TL;DR;

```bash
export RBENV_ROOT="${HOME}/.rbenv"
export PATH="${RBENV_ROOT}/bin:${PATH}"
apt install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

git clone https://github.com/rbenv/rbenv "${RBENV_ROOT}"

mkdir -p "${RBENV_ROOT}/plugins"
git clone https://github.com/rbenv/ruby-build "${RBENV_ROOT}/plugins/ruby-build"

eval "$(rbenv init -)"
```

## Build the engine

Goal is to build the weakened OpenSSL library, then a custom Ruby version based
on it.

```bash
git clone https://git.imirhil.fr/aeris/cryptcheck
cd cryptcheck
make
make install-rbenv-cryptcheck
```

## Setup the front-end

```bash
git clone https://git.imirhil.fr/aeris/cryptcheck-rails
cd cryptcheck-rails
rbenv local 2.3.3-cryptcheck
export LD_LIBRARY_PATH=../cryptcheck/lib
bundle install
```

## Mongo & Redis

You need a [MongoDB](https://www.mongodb.com/) and a [Redis](https://redis.io/)
server.

```bash
apt install -y mongodb-server redis-server
```

# Launch CryptCheck

## Launch the front-end

```bash
export LD_LIBRARY_PATH=../cryptcheck/lib
bin/guard -i
```

## Launch the worker

```bash
export LD_LIBRARY_PATH=../cryptcheck/lib
bin/sidekiq
```
