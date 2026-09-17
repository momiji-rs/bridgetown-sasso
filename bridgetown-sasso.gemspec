# frozen_string_literal: true

require_relative "lib/bridgetown-sasso/version"

Gem::Specification.new do |spec|
  spec.name     = "bridgetown-sasso"
  spec.version  = BridgetownSasso::VERSION
  spec.author   = "momiji-rs"
  spec.summary  = "Compile Sass/SCSS in Bridgetown with the pure-Rust sasso compiler — no Node, no Dart"
  spec.description = "A Bridgetown plugin that compiles your Sass/SCSS entrypoints with sasso, a " \
                     "pure-Rust, zero-dependency, byte-for-byte dart-sass alternative. Compilation " \
                     "runs in-process during the build (no Node toolchain, no Dart VM, no subprocess)."
  spec.homepage = "https://github.com/momiji-rs/bridgetown-sasso"
  spec.license  = "MIT"

  spec.metadata = {
    "homepage_uri"    => spec.homepage,
    "source_code_uri" => spec.homepage,
    "changelog_uri"   => "#{spec.homepage}/blob/main/CHANGELOG.md",
    "rubygems_mfa_required" => "true",
  }

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|script|spec|features)/}) || f.match(%r{^\.})
  end
  spec.require_paths = ["lib"]

  # Follows the `sasso` engine gem, which dropped Ruby 3.1 in 0.14.0 (3.1 left
  # security maintenance in March 2025). A 3.1 install could not resolve the
  # dependency below in any case.
  spec.required_ruby_version = ">= 3.2.0"

  spec.add_dependency "bridgetown", ">= 2.0"
  # The compiler engine gem. From 0.14.0 its version tracks the core compiler
  # crate it bundles, so this floor names the compiler too: 0.14.0 carries core
  # 0.14.0 (dart-sass 1.104.1 parity), where 0.2.7 carried core 0.6.3 (1.101.0).
  # `< 1` allows the rest of the 0.x line — this plugin uses one method of it.
  spec.add_dependency "sasso", ">= 0.14.0", "< 1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.0"
  spec.add_development_dependency "rake", ">= 13.0"
  spec.add_development_dependency "rubocop-bridgetown", "~> 0.3"
end
