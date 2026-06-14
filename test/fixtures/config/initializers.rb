# frozen_string_literal: true

Bridgetown.configure do |config|
  init :"bridgetown-sasso" do
    entrypoints({ "index.scss" => "css/main.css" })
    style :expanded
  end
end
