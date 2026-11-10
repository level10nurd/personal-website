# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project status

Personal website for Dalton Allen, published at daltonjallen.com. v1 is a single
About page with a Contact section. `README.org` holds the original design
research and content ideas; `docs/superpowers/specs/` holds the approved design.

## Layout

- `content/*.org` — the site's pages. `content/index.org` is the About page.
- `static/` — copied verbatim into the output: `style.css`, `CNAME`.
- `publish.el` — the whole `org-publish` configuration. Built-in Org only, no packages.
- `Makefile` — `publish`, `serve`, `check`, `clean`.
- `public/` — generated output. Gitignored; never commit it.
- `.github/workflows/publish.yml` — builds with Emacs on push to `master` and deploys to GitHub Pages.

## Commands

```
make publish   # emacs --batch -Q -l publish.el -f site-publish  → public/
make serve     # publish, then serve public/ at http://localhost:8000
make check     # publish, then fail if index.html/style.css/CNAME are missing or any <script> exists
make clean     # remove public/ and .org-timestamps/
```

Interactive, from a running Emacs: `M-x load-file RET publish.el RET`, then
`M-x org-publish RET site RET`. Batch runs use Emacs's built-in Org; CI pins
Emacs 30.1, so keep `publish.el` free of Org features newer than that.

## Specs (from README.org)

These constraints shape all implementation work:

- **Authored in Emacs Org mode and published with Emacs** (`org-publish`). Content
  lives in `.org` files; HTML is generated output, not hand-written source.
- **Static site, no JavaScript.** `make check` enforces this mechanically.
- **Keep it simple.** Reference points for "simple": stefanzweifel.dev/about,
  ethanchng.com, julienblanchard.com.
- **Design reflects the author's domain** (accounting / spreadsheets) with a light
  touch, not a gimmick. v1 uses three CSS-only motifs: a row-number gutter, a
  formula-bar header, and sheet-tab navigation in the footer. Column letters,
  visible grid lines, and green-bar banding were considered and rejected.

## Working in this repo

- `README.org` is an org-roam node (it has an `:ID:` property). Preserve the
  `:PROPERTIES:` drawer and `#+title:` line when editing it.
- Prefer Org mode primitives over importing a JS/CSS toolchain.
- The HTML structure the CSS targets comes from `ox-html` with `:html-html5-fancy t`
  and `:html-container "section"`: `<main id="content">`, title in `main > header > h1.title`,
  body paragraphs directly under `main`, headlines as `section.outline-2 > h2`,
  headline bodies in `.outline-text-2`. Check `public/index.html` before changing selectors.
- New pages become new sheet tabs: add a `.org` file under `content/` and a tab in
  `site-postamble` in `publish.el`. Give headlines you link to a `:CUSTOM_ID:` for stable anchors.
- Planned but not built: Timeline, Resources, Blog (see README.org).
