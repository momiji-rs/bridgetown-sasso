# frozen_string_literal: true

require "bridgetown"
require "bridgetown-sasso/version"
require "bridgetown-sasso/builder"

# Bridgetown plugin: compile Sass/SCSS with the pure-Rust, zero-dependency
# `sasso` compiler (a byte-for-byte dart-sass alternative) — no Node, no Dart,
# no subprocess; compilation happens in-process during the Bridgetown build.
#
# Enable it from a site's `config/initializers.rb`:
#
#   Bridgetown.configure do |config|
#     init :"bridgetown-sasso"
#   end
#
# and configure (all optional; defaults shown):
#
#   init :"bridgetown-sasso" do
#     # entrypoints: <source under source_dir/styles_dir> => <output under dest>
#     entrypoints({ "index.scss" => "css/main.css" })
#     styles_dir "_css"   # holds the entrypoints + their partials (underscore =
#                         # not published by Bridgetown as raw files)
#     style nil           # nil = :compressed in production, :expanded otherwise;
#                         # or force :expanded / :compressed
#     load_paths []       # extra @use/@import dirs (the entrypoint's own dir is
#                         # always searched first)
#   end
Bridgetown.initializer :"bridgetown-sasso" do |config|
  config.bridgetown_sasso ||= {}
  config.bridgetown_sasso.entrypoints ||= { "index.scss" => "css/main.css" }
  config.bridgetown_sasso.styles_dir  ||= "_css"
  config.bridgetown_sasso.style       ||= nil
  config.bridgetown_sasso.load_paths  ||= []

  config.builder BridgetownSasso::Builder
end
