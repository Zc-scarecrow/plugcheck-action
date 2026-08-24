# plugcheck-action

Validate [Agent Plugins 1.0](https://agent-plugins.org) packages in your CI
with [plugcheck](https://github.com/Zc-scarecrow/plugcheck) — a single-file,
dependency-free validator.

```yaml
name: Validate plugin

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: Zc-scarecrow/plugcheck-action@v1
        with:
          path: . # directory containing plugin.json
```

On every push and pull request the action downloads the plugcheck binary and
checks the plugin: manifest schema, name rules, MCP configuration, and skills.
A broken plugin fails the build with a human-readable report.

## Inputs

| Input     | Default | Description                                              |
| --------- | ------- | -------------------------------------------------------- |
| `path`    | `.`     | Path to the plugin directory to validate                 |
| `version` | `v0.1.0`| plugcheck release tag to download                        |
| `format`  | `human` | Output format: `human` or `json`                         |
| `args`    | ``      | Extra arguments passed to plugcheck                      |

## Examples

### Pin a version

```yaml
- uses: Zc-scarecrow/plugcheck-action@v1
  with:
    version: v0.1.0
    path: my-plugin
```

### JSON output for tooling

```yaml
- uses: Zc-scarecrow/plugcheck-action@v1
  with:
    format: json
```

### Multi-platform matrix

```yaml
jobs:
  validate:
    strategy:
      matrix:
        os: [ubuntu-latest, macos-latest, windows-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: actions/checkout@v4
      - uses: Zc-scarecrow/plugcheck-action@v1
```

## Requirements

- A `plugin.json` manifest in the validated directory (see the
  [Agent Plugins 1.0 spec](https://agent-plugins.org))
- The plugcheck release for your platform must exist for the requested
  `version`

## License

[MIT](LICENSE)
