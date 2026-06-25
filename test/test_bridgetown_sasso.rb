# frozen_string_literal: true

require_relative "helper"

class TestBridgetownSasso < Bridgetown::TestCase
  def setup
    Bridgetown.reset_configuration!
    @config = Bridgetown.configuration(
      "root_dir"    => root_dir,
      "source"      => source_dir,
      "destination" => dest_dir,
      "quiet"       => true
    )
    @config.run_initializers! context: :static
    @site = Bridgetown::Site.new(@config)
    @site.process
  end

  describe "bridgetown-sasso" do
    before { @css = File.read(dest_dir("css", "main.css")) }

    it "writes the compiled CSS to the configured output path" do
      assert File.file?(dest_dir("css", "main.css")), "expected output/css/main.css to exist"
    end

    it "resolves variables and unit math (sasso compiled the SCSS)" do
      assert_includes @css, "color: #3366cc;"
      assert_includes @css, "width: 16px;"
    end

    it "flattens nesting and resolves the parent selector" do
      assert_includes @css, ".card .title {"
      assert_includes @css, ".card:hover {"
    end

    it "hoists @at-root to the top level (byte-exact dart-sass behavior)" do
      # `.footer` must NOT be nested under `.card`
      assert_match(%r{^\.footer \{}, @css)
    end

    it "matches a standalone sasso compile byte-for-byte" do
      reference = ::Sasso.compile(source_dir("_css", "index.scss"), style: :expanded)
      # The build artifact is the library output plus the conventional trailing
      # newline the builder adds (sasso >= 0.2.7's library API omits it).
      assert_equal "#{reference}\n", @css
    end
  end
end
