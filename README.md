# bridgetown-sasso

Compile **Sass/SCSS in [Bridgetown](https://www.bridgetownrb.com)** with
[**sasso**](https://github.com/momiji-rs/sasso-ruby) — a pure-Rust,
zero-dependency, byte-for-byte [dart-sass](https://sass-lang.com) alternative.

Compilation runs **in-process during the build** — no Node toolchain, no Dart
VM, no subprocess. Bridgetown's default frontend has no native Sass step; this
plugin gives you one without pulling in `node` + esbuild + the `sass` npm.

- **No Node.** Compile Sass with zero JavaScript tooling.
- **In-process.** No process spawn per build — sasso is a native Ruby gem.
- **Byte-for-byte dart-sass.** Same CSS as `dart-sass`, just faster.

## Installation

```ruby
# Gemfile
gem "bridgetown-sasso"
```

```sh
bundle install
```

Then enable it in `config/initializers.rb`:

```ruby
Bridgetown.configure do |config|
  init :"bridgetown-sasso"
end
```

Put your entrypoint (and its partials) under `src/_css/` — the leading
underscore keeps Bridgetown from publishing the raw `.scss`. The default
entrypoint is `src/_css/index.scss`, compiled to `output/css/main.css`. Link it
from your layout:

```html
<link rel="stylesheet" href="/css/main.css">
```

Or scaffold everything in one step:

```sh
bin/bridgetown apply https://github.com/momiji-rs/bridgetown-sasso
```

## Configuration

All optional (defaults shown):

```ruby
init :"bridgetown-sasso" do
  # <source under src/<styles_dir>> => <output under the site output dir>
  entrypoints({ "index.scss" => "css/main.css" })

  # Dir under src/ holding the entrypoints + their partials. Underscore-prefixed
  # so Bridgetown does not publish the raw .scss.
  styles_dir "_css"

  # nil = :compressed in production (BRIDGETOWN_ENV=production), :expanded else.
  # Or force :expanded / :compressed.
  style nil

  # Extra @use/@import dirs. The entrypoint's own directory is always searched
  # first, so sibling partials (e.g. _buttons.scss) need no configuration.
  load_paths []
end
```

Multiple entrypoints are supported — list each one:

```ruby
entrypoints({ "index.scss" => "css/main.css", "admin.scss" => "css/admin.css" })
```

## Performance

`sasso` compiles the same CSS as dart-sass, byte-for-byte, but much faster — and
without any Node runtime. Benchmarked on an Apple M2 Max, all engines dart-sass
1.101, against the Node frontend's default Sass engine (`sass`, dart2js):

**In-process** (how this plugin compiles — inside the Ruby build process):

| workload | bridgetown-sasso | Node `sass` (dart2js) |
|----------|------------------|-----------------------|
| ~360 rules  | **1.2 ms** | 8.0 ms (**6.4× slower**) |
| ~3000 rules | **9.9 ms** | 71.5 ms (**7.2× slower**) |

**Cold per-build** (a one-shot `bridgetown build` / deploy, including runtime
startup):

| workload | bridgetown-sasso | dart-sass (native) | Node `sass` (dart2js) |
|----------|------------------|--------------------|-----------------------|
| ~360 rules  | **3.0 ms** | 27.5 ms (9×) | 185 ms (**63× slower**) |
| ~3000 rules | **10.9 ms** | 64.2 ms (6×) | 348 ms (**32× slower**) |

Output is byte-identical to dart-sass, so this is pure speedup with no behavior
change. (Synthetic workloads exercising variables, nesting, `&`, unit math,
color functions, and `@at-root`; ratios are the takeaway, absolute numbers are
machine-specific.)

## How it fits the build

The plugin registers a Bridgetown builder that, after each build, compiles every
configured entrypoint with `Sasso.compile` and writes the CSS into the site
output directory. `bin/bridgetown build` and `bridgetown serve` (watch) both
regenerate it. Because the CSS is produced in-process, there is no Node
dependency for Sass at all.

## License

MIT, matching the Sass ecosystem. (The core `sasso` compiler crate is dual
MIT OR Apache-2.0.)
