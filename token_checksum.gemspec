# frozen_string_literal: true

require_relative "lib/token_checksum/version"

Gem::Specification.new do |spec|
  spec.name = "token_checksum"
  spec.version = TokenChecksum::VERSION
  spec.authors = ["Garen J. Torikian"]
  spec.email = ["gjtorikian@users.noreply.github.com"]

  spec.summary = "A token generator with an identifiable prefix and a 32-bit checksum suffix."
  spec.homepage = "https://github.com/gjtorikian/token_checksum"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0", "< 4.0"

  spec.metadata["homepage_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    %x(git ls-files -z).split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency("securecompare", "~> 1.0")

  spec.add_development_dependency("debug") if "#{RbConfig::CONFIG["MAJOR"]}.#{RbConfig::CONFIG["MINOR"]}".to_f >= 3.1
end
