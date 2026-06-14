# frozen_string_literal: true

# Run with:  bin/bridgetown apply https://github.com/momiji-rs/bridgetown-sasso
#
# Adds the gem, registers the initializer, and scaffolds a starter entrypoint.

add_gem "bridgetown-sasso"

add_initializer :"bridgetown-sasso" do
  <<~RUBY
    do
      # entrypoints({ "index.scss" => "css/main.css" })
      # style :compressed   # default: :compressed in production, :expanded else
      # load_paths []
    end
  RUBY
end

create_file "src/_css/index.scss" do
  <<~SCSS
    @use "sass:color";

    $brand: #3366cc;

    body {
      color: $brand;
      a { color: color.adjust($brand, $lightness: -10%); }
    }
  SCSS
end

say_status :bridgetown_sasso,
           %(Link the compiled CSS in your layout: <link rel="stylesheet" href="/css/main.css">, then `bin/bridgetown build`.),
           :green
