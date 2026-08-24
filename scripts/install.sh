#!/usr/bin/env bash
# Downloads a plugcheck release binary for the current platform and adds it
# to PATH for subsequent steps.
set -euo pipefail

version="${1:-}"
if [[ -z "$version" ]]; then
  echo "usage: install.sh <version>" >&2
  exit 1
fi

repo="Zc-scarecrow/plugcheck"

# Map the runner platform to a plugcheck release target.
case "$(uname -s)" in
  Linux)
    target="x86_64-unknown-linux-gnu"
    ;;
  Darwin)
    case "$(uname -m)" in
      arm64) target="aarch64-apple-darwin" ;;
      *) target="x86_64-apple-darwin" ;;
    esac
    ;;
  MINGW* | MSYS* | CYGWIN*)
    target="x86_64-pc-windows-msvc"
    ;;
  *)
    echo "unsupported platform: $(uname -s)" >&2
    exit 1
    ;;
esac

case "$target" in
  *windows*) ext="zip" ;;
  *) ext="tar.gz" ;;
esac

asset="plugcheck-${target}.${ext}"
url="https://github.com/${repo}/releases/download/${version}/${asset}"
dest="${RUNNER_TEMP:-${TMPDIR:-/tmp}}"

echo "::group::Downloading plugcheck ${version} (${target})"
mkdir -p "${dest}/plugcheck"
if [[ "$ext" == "zip" ]]; then
  curl -fsSL "$url" -o "${dest}/plugcheck.zip"
  unzip -o -q "${dest}/plugcheck.zip" -d "${dest}/plugcheck"
else
  curl -fsSL "$url" | tar -xz -C "${dest}/plugcheck"
fi
chmod +x "${dest}/plugcheck/plugcheck" 2>/dev/null || true
echo "${dest}/plugcheck" >> "$GITHUB_PATH"
echo "::endgroup::"

"${dest}/plugcheck/plugcheck" --version
