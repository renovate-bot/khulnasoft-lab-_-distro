# distro-wrapper

## What it does

`distro-wrapper` generates `config.json` using `setup` command and execute provided command.

## How to test distro-wrapper

```bash
DISTRO_DB_DIALECT=bolt \
DISTRO_CONFIG_PATH=/tmp/distro \
DISTRO_DB_HOST=/tmp/distro \
./distro-wrapper ../../../bin/distro server --config /tmp/distro/config.json
```
