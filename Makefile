# Build, preview, and verify the site. Requires GNU make 3.82+ and Emacs.
.RECIPEPREFIX = >
EMACS ?= emacs
PORT  ?= 8000

.PHONY: publish serve check clean

publish:
> $(EMACS) --batch -Q -l publish.el -f site-publish

serve: publish
> python3 -m http.server -d public $(PORT)

# Enforces the spec: output exists, custom domain ships, and no JavaScript anywhere.
check: publish
> test -f public/index.html
> test -f public/style.css
> test -f public/CNAME
> ! grep -ril "<script" public/

clean:
> rm -rf public .org-timestamps
