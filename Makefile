DEBUG=JEKYLL_GITHUB_TOKEN=blank PAGES_API_URL=http://0.0.0.0
ALIAS=jekyll-modele
help:
	@echo "HomePage: https://github.com/nonBinaryGeek/${ALIAS}\n"
	@echo "Usage:"
	@echo "    make [subcommand]\n"
	@echo "Subcommands:"
	@echo "    checkout  Reset the theme minified css and script to last commit"
	@echo "    install   Install the theme dependencies"
	@echo "    clean     Clean the workspace"
	@echo "    status    Display status before push"
	@echo "    theme     Make theme as gem and install"
	@echo "    build     Build the test site"
	@echo "    server    Make a livereload jekyll server to development"

checkout:
	@git checkout _config.yml
	@git checkout assets/js/theme.min.js
	@git checkout assets/css/theme.min.css

install:
	@gem install jekyll bundler
	@bundle install

clean:
	@bundle exec jekyll clean

status: format clean checkout
	@git status

build:
	@bundle exec jekyll build

server:
	@bundle exec jekyll serve