# asdf-alias [![Build](https://github.com/andrewthauer/asdf-alias/actions/workflows/build.yml/badge.svg)](https://github.com/andrewthauer/asdf-alias/actions/workflows/build.yml) [![Lint](https://github.com/andrewthauer/asdf-alias/actions/workflows/lint.yml/badge.svg)](https://github.com/andrewthauer/asdf-alias/actions/workflows/lint.yml)

[asdf-alias](https://github.com/andrewthauer/asdf-alias) is a version alias
manager plugin for the [asdf version manager](https://asdf-vm.com).

## Install

Plugin:

```shell
asdf plugin add asdf-alias
# or
asdf plugin add alias https://github.com/andrewthauer/asdf-alias.git
```

## Use

asdf alias <plugin> <name> [<version> | --auto | --remove]"
asdf alias <plugin> --auto"
asdf alias <plugin> [--list]"

```sh
asdf alias java 11.0 adopt-openjdk-11.0
asdf alias java 11.0 --remove
asdf alias java --auto
asdf alias java --list
asdf alias java --remove
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

## Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/andrew-thauer/asdf-alias/graphs/contributors)!

## License

See [LICENSE](LICENSE) © [Andrew Thauer](https://github.com/andrewthauer/)
