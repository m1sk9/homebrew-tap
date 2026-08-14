# homebrew-tap

A third-party [Homebrew](https://brew.sh) Tap for distributing m1sk9's artifacts.

## Usage

```console
$ brew tap m1sk9/tap
$ brew install m1sk9/tap/strays
```

Or without tapping first:

```console
$ brew install m1sk9/tap/strays
```

## Formulae

| Formula  | Description                                                    | Upstream                                    |
| -------- | -------------------------------------------------------------- | ------------------------------------------- |
| `strays` | TUI for centralized management of LLM agents running on machines | [m1sk9/strays](https://github.com/m1sk9/strays) |

Formulae are built from source. This tap ships no bottles, so `brew install`
compiles the Rust toolchain output on the installing machine.

## CI / CD

### `Test` (`.github/workflows/tests.yaml`)

Runs `brew test-bot` on `ubuntu-24.04`, `macos-15` (Apple Silicon) and
`macos-15-intel`.

- Every push and pull request: `--only-tap-syntax` (`brew style` + `brew audit`).
- Pull requests only: `--only-formulae`, which builds, tests and audits the
  formulae changed by that pull request on each platform.

### `Publish` (`.github/workflows/publish.yaml`)

Bumps a formula to a new upstream release and opens a pull request for it, so
the build verification above gates the change before it reaches `main`.

Triggered either by `repository_dispatch` of type `publish` from an upstream
release workflow, or manually:

```console
$ gh workflow run publish.yaml -f formula=strays -f tag=v0.1.0
```

The workflow rewrites only the `url` and `sha256` lines of
`Formula/<formula>.rb`, then opens a pull request and enables auto-merge on it.

## Setup

### Repository secrets

`Publish` authenticates as a GitHub App instead of `GITHUB_TOKEN`, because
pushes made with `GITHUB_TOKEN` do not trigger workflows — the bump pull request
would never get its build verification.

| Secret        | Description                                                  |
| ------------- | ------------------------------------------------------------ |
| `CLIENT_ID`   | Client ID of a GitHub App installed on this repository        |
| `PRIVATE_KEY` | Private key of that App                                       |

The App needs `contents: write` and `pull requests: write` on this repository.

### Repository settings

Enable **Allow auto-merge** so bump pull requests merge once `Test` passes.
Without it the workflow still opens the pull request and leaves a warning.

### Upstream release workflow

Add a job like this to the upstream repository's release workflow to publish
automatically. `strays` already produces `release_created`; `tag_name` has to be
added to the `release-please` job outputs.

```yaml
  notify-tap:
    needs: release-please
    if: needs.release-please.outputs.release_created
    runs-on: ubuntu-24.04
    steps:
      - name: Get token
        id: tap-token
        uses: actions/create-github-app-token@v3
        with:
          client-id: ${{ secrets.CLIENT_ID }}
          private-key: ${{ secrets.PRIVATE_KEY }}
          owner: m1sk9
          repositories: homebrew-tap
          skip-token-revoke: true

      - name: Dispatch to homebrew-tap
        env:
          GH_TOKEN: ${{ steps.tap-token.outputs.token }}
          TAG: ${{ needs.release-please.outputs.tag_name }}
        run: |
          gh api repos/m1sk9/homebrew-tap/dispatches \
            -f event_type=publish \
            -f "client_payload[formula]=strays" \
            -f "client_payload[tag]=${TAG}"
```

## Adding a formula

1. Add `Formula/<name>.rb` pointing at the upstream release tarball.
2. Keep the `url` line as `  url "<...>/<tag>.tar.gz"` on a single line —
   `Publish` substitutes the last path segment of that url.
3. Open a pull request; `Test` builds and tests it on every platform.

## License

MIT
