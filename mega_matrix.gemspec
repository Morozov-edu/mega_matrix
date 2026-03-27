# frozen_string_literal: true

require_relative "lib/mega_matrix/version"

Gem::Specification.new do |spec|
  spec.name = "mega_matrix"
  spec.version = MegaMatrix::VERSION
  spec.authors       = [
    "Morozov Yuriy",
    "Pavlenko Mikhail",
    "Movsesyan Anatoliy",
    "Grigoryan Artyom",
    "Arutyunyan David"
  ]
 
  spec.email         = [
    "iumo@sfedu.ru",
    "mipa@sfedu.ru",
    "amovsesian@sfedu.ru"
  ]

spec.summary = "Ruby library for matrix operations"
  spec.description = "MegaMatrix is a Ruby library that provides basic matrix operations such as addition, subtraction, scalar multiplication, and matrix multiplication."
  spec.homepage = "https://example.com"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2.0"

  spec.homepage = "https://github.com/Morozov-edu/mega_matrix"
  spec.metadata = {
    "homepage_uri"     => spec.homepage,
    "source_code_uri"  => "https://github.com/Morozov-edu/mega_matrix",
    "changelog_uri"    => "https://github.com/Morozov-edu/mega_matrix/blob/main/CHANGELOG.md",
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
