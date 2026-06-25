# Changelog

All notable changes to **bridgetown-sasso** are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.1.2] - 2026-06-25

Now requires the `sasso` gem **>= 0.2.7** (was `>= 0.2.3`), whose library API
omits the trailing newline (adopting core sasso 0.6.3, byte-for-byte dart-sass
parity). The builder re-adds the conventional trailing newline when writing a
build artifact, so compiled `.css` files end with a single newline like
dart-sass's CLI — for both expanded and compressed output.

## [0.1.1] - 2026-06-15

Now requires the `sasso` gem **>= 0.2.3**, which brings two dart-sass parity
fixes contributed upstream by [@shyim](https://github.com/shyim):

### Changed

- Bump the `sasso` runtime dependency floor to **>= 0.2.3** (was `>= 0.2.0`).

### Fixed (via `sasso` >= 0.2.3)

- `!default` no longer evaluates its right-hand side when the variable is already
  set, fixing a spurious "incompatible units" error in Bootstrap-on-Shopware
  setups.
- Legacy `rgb()` / `hsl()` preserve the caller's `rgba` / `hsla` spelling in
  special-value passthroughs (e.g. `rgba(var(--bs-body-color-rgb), …)`), which
  Bootstrap relies on.

## [0.1.0] - 2026-06-14

Initial release. Requires the `sasso` gem **>= 0.2.0** and Bridgetown **>= 2.0**.

### Added

- Bridgetown plugin that compiles configured Sass/SCSS entrypoints with the
  pure-Rust `sasso` compiler in-process (no Node, no Dart, no subprocess) and
  writes the CSS into the site output.
- Enable with `init :"bridgetown-sasso"`; configure `entrypoints`, `styles_dir`,
  `style`, and `load_paths`.
- `bridgetown.automation.rb` for `bin/bridgetown apply`.
