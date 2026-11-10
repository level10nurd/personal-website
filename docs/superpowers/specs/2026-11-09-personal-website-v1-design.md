# Personal website v1: About + Contact, published from Org with Emacs

Approved 2026-11-09. This is the design that v1 was built from.

## Decisions

- **Purpose:** professional presence. About, Timeline, Contact carry the weight; Blog is secondary.
- **v1 scope:** a single About page with a Contact section. Timeline, Resources, Blog come later.
- **Hosting:** GitHub Pages at `daltonjallen.com` (CNAME shipped from `static/`).
- **Publish config:** a self-contained `publish.el` in the repo, runnable with `emacs --batch`
  and loadable interactively from Doom Emacs.
- **Deploy:** a GitHub Action builds with Emacs and deploys `public/`. Generated HTML is never committed.
- **Approach:** vanilla `ox-html` configured in `publish.el` plus hand-written CSS. No derived
  backend, no third-party static site generator, no packages beyond built-in Org.
- **Design:** spreadsheet grid chrome, light touch, pure CSS.

Hard constraints: authored in Org, published by Emacs, static, no JavaScript, keep it simple.

## Layout

```
publish.el                    org-publish config: projects "content", "static", "site"
Makefile                      publish / serve / check / clean
content/index.org             About page with a Contact section (CUSTOM_ID: contact)
static/style.css              all styling
static/CNAME                  daltonjallen.com
public/                       generated output, gitignored
.github/workflows/publish.yml build with Emacs 30.1, deploy to GitHub Pages
```

## publish.el behavior

- Disables TOC, section numbers, author/date/email/creator, timestamp, default CSS, inline
  scripts, and the validation link. Output is HTML5 (`:html-html5-fancy t`,
  `:html-container "section"`) with `org-html-divs` set so the wrappers are
  `<header id="preamble">`, `<main id="content">`, `<footer id="postamble">`.
- `:html-head` links `/style.css`. Org emits charset and viewport itself.
- `:html-preamble` and `:html-postamble` are plain HTML strings holding the formula bar and
  the sheet tabs. They contain no `%` characters because Org runs them through `format-spec`.
- Timestamps are disabled so every run rebuilds everything.

## Design: spreadsheet chrome, light touch

1. **Row-number gutter.** `main#content` is the counter scope. Each top-level block
   (title, paragraphs, lists, headlines, headline-body blocks, and each `dt` in the contact
   list) increments a `row` counter rendered in a `::before` pseudo-element positioned in a
   3rem gutter on the left of the content column. Hidden below 40rem viewport width.
2. **Formula bar header.** A thin full-width bar: a bordered cell reference `A1`, an italic
   `fx`, and the site name linking to `/`. The page title (`h1.title`) is cell A1 and gets the
   accent "selected cell" border.
3. **Sheet tabs footer.** A tab strip: `About` active with accent underline, `Contact`
   linking to `#contact`. New pages become new tabs.

Typography: system sans for prose, system monospace for gutter and cell references,
`tabular-nums` on the body, max width 65ch. One accent color (spreadsheet green) for the
active tab, links, the A1 border, and `:focus-visible` outlines. Dark mode via
`prefers-color-scheme`. Explicitly excluded: column letters, visible grid lines, green-bar banding.

## Build, preview, deploy, verify

- `make publish` runs Emacs in batch and writes `public/`.
- `make serve` serves `public/` with Python's http.server on port 8000.
- `make check` fails if `index.html`, `style.css`, or `CNAME` is missing from `public/`, or if
  any `<script` string appears in the output. This enforces the no-JavaScript spec.
- The workflow runs `make check` with `purcell/setup-emacs` (Emacs 30.1) and deploys with
  `actions/upload-pages-artifact` + `actions/deploy-pages` on pushes to `master`.
- One-time manual steps: repo Settings → Pages → Source: GitHub Actions; confirm the custom
  domain; point DNS for `daltonjallen.com` at GitHub Pages.

## Out of scope for v1

Timeline, Resources, Blog, RSS, web fonts, analytics, any JavaScript.
