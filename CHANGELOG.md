# Changelog

All notable changes to **bridgetown-sasso** are documented here.
The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.1.0] - 2026-06-14

Initial release. Requires the `sasso` gem **>= 0.2.0** and Bridgetown **>= 2.0**.

### Added

- Bridgetown plugin that compiles configured Sass/SCSS entrypoints with the
  pure-Rust `sasso` compiler in-process (no Node, no Dart, no subprocess) and
  writes the CSS into the site output.
- Enable with `init :"bridgetown-sasso"`; configure `entrypoints`, `styles_dir`,
  `style`, and `load_paths`.
- `bridgetown.automation.rb` for `bin/bridgetown apply`.
