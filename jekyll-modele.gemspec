Gem::Specification.new do |spec|
  spec.name          = "jekyll-modele"
  spec.version       = "1.0.2"
  spec.authors       = ["nonBinaryGeek"]
  spec.email         = ["admin@catpalace.ca"]

  spec.summary       = "Modèle basique d'un site offrant de la documentation"
  spec.license       = "MIT"
  spec.homepage      = "https://github.com/nonBinaryGeek/jekyll-modele"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|_layouts|_includes|_sass|LICENSE|README)!i) }

  spec.add_runtime_dependency "github-pages", "~> 209"
end
