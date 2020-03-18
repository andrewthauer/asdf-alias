# Contributing

Testing Locally:

```shell
asdf plugin test <plugin-name> <plugin-url> [--asdf-tool-version <version>] [--asdf-plugin-gitref <git-ref>] [test-command*]

#
asdf plugin test alias https://github.com/andrewthauer/asdf-alias.git "asdf alias"
```

Tests are automatically run in GitHub Actions on push and PR.
