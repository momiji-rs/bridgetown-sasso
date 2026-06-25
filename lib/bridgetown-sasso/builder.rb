# frozen_string_literal: true

require "fileutils"
require "sasso"

module BridgetownSasso
  # Compiles the configured SCSS entrypoints with the pure-Rust `sasso` compiler
  # after each build and writes the resulting CSS into the site's output
  # directory. Runs in-process — no Node, no Dart, no subprocess.
  class Builder < Bridgetown::Builder
    def build
      # Compile after the site is written, so the CSS lands in the output dir
      # (and survives that build's cleanup); a watch rebuild regenerates it.
      hook :site, :post_write do
        compile_all
      end
    end

    def compile_all
      style = resolved_style
      Array(entrypoints).each do |source, output|
        src = site.in_source_dir(styles_dir, source.to_s)
        unless File.file?(src)
          Bridgetown.logger.warn("bridgetown-sasso:", "entrypoint not found: #{src}")
          next
        end
        # `Sasso.compile` already searches the entry file's own directory for
        # relative `@use`/`@import`; `load_paths` adds any extra dirs.
        css = ::Sasso.compile(src, style: style, load_paths: extra_load_paths)
        dest = site.in_dest_dir(output.to_s)
        FileUtils.mkdir_p(File.dirname(dest))
        # sasso >= 0.2.7's library API omits the trailing newline; a built CSS
        # artifact conventionally ends with one (and dart-sass's CLI writes it).
        File.write(dest, "#{css}\n")
        Bridgetown.logger.info("bridgetown-sasso:", "#{source} -> #{output} (#{style})")
      end
    end

    private

    # Bridgetown's resolved config exposes nested values as a plain Hash; read
    # defensively (symbol or string keys) so we don't depend on method access.
    def config
      site.config[:bridgetown_sasso] || site.config["bridgetown_sasso"] || {}
    end

    def cfg(key, default)
      value = config[key]
      value = config[key.to_s] if value.nil?
      value.nil? ? default : value
    end

    def entrypoints
      cfg(:entrypoints, { "index.scss" => "css/main.css" })
    end

    def styles_dir
      cfg(:styles_dir, "_css").to_s
    end

    def extra_load_paths
      Array(cfg(:load_paths, [])).map(&:to_s)
    end

    # nil -> :compressed in production, :expanded otherwise; a forced value wins.
    def resolved_style
      forced = cfg(:style, nil)
      return forced.to_sym if forced

      production? ? :compressed : :expanded
    end

    def production?
      (ENV["BRIDGETOWN_ENV"] || ENV["RACK_ENV"] || "development").to_s == "production"
    end
  end
end
