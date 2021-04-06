<div align="center">

# asdf-alias ![Build](https://github.com/andrewthauer/asdf-alias/workflows/Build/badge.svg) ![Lint](https://github.com/andrewthauer/asdf-alias/workflows/Lint/badge.svg)

[asdf-alias](https://github.com/andrewthauer/asdf-alias) is a version alias
manager plugin for the [asdf version manager](https://asdf-vm.com).

</div>

## Contents

- [Install](#install)
- [Usage](#usage)
- [Contributing](#contributing)
- [License](#license)

## Install

```shell
asdf plugin add alias
# or
asdf plugin add https://github.com/andrewthauer/asdf-alias.git
```

## Usage

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

## Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/andrew-thauer/asdf-alias/graphs/contributors)!

## License

See [LICENSE](LICENSE) © [Andrew Thauer](https://github.com/andrewthauer/)
