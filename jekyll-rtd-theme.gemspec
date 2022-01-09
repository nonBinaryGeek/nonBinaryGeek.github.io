Gem::Specification.new do |spec|
  spec.name          = "jekyll-rtd-theme"
  spec.version       = "2.0.10"
  spec.authors       = ["nonBinaryGeek"]
  spec.email         = ["admin@catpalace.ca"]

  spec.summary       = "Just another documentation theme compatible with GitHub Pages"
  spec.license       = "MIT"
  spec.homepage      = "https://github.com/nonBinaryGeel/nonbinarygeek.github.io"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "github-pages", "~> 209"
end
