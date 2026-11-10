;;; publish.el --- org-publish configuration for daltonjallen.com  -*- lexical-binding: t; -*-

;; Usage:
;;   Batch:        emacs --batch -Q -l publish.el -f site-publish
;;   Interactive:  M-x load-file RET publish.el RET, then M-x org-publish RET site RET
;;
;; Uses only built-in Org. Output goes to public/, which is gitignored.

(require 'ox-publish)

(defconst site-root
  (file-name-directory (or load-file-name buffer-file-name))
  "Directory containing publish.el; all paths are resolved from here.")

(defun site-path (rel)
  "Return REL resolved against `site-root'."
  (expand-file-name rel site-root))

;; Always rebuild. Timestamp caching is a footgun in CI and the site is tiny.
(setq org-publish-use-timestamps-flag nil
      org-publish-timestamp-directory (site-path ".org-timestamps/"))

;; Use semantic wrappers: <header>, <main>, <footer>.
(setq org-html-divs
      '((preamble  "header" "preamble")
        (content   "main"   "content")
        (postamble "footer" "postamble")))

(defconst site-html-head
  (concat
   "<link rel=\"stylesheet\" href=\"/style.css\">\n"
   "<link rel=\"icon\" href=\"/favicon.svg\" type=\"image/svg+xml\">\n"
   "<link rel=\"icon\" href=\"/favicon.png\" sizes=\"32x32\" type=\"image/png\">\n"
   "<link rel=\"apple-touch-icon\" href=\"/apple-touch-icon.png\">")
  "Extra <head> content. Org adds charset, viewport, title, and generator itself.")

;; The header reads like a spreadsheet formula bar: the name box (A1 is the
;; page title), the fx label, and the "formula" (the site name). Below it, a
;; column header strip: a corner cell above the row-number gutter, then
;; column A, which holds the page.
(defconst site-preamble
  (concat
   "<nav class=\"formula-bar\" aria-label=\"Site\">\n"
   "  <span class=\"cell-ref\" aria-hidden=\"true\">A1</span>\n"
   "  <span class=\"fx\" aria-hidden=\"true\">fx</span>\n"
   "  <a class=\"formula\" href=\"/\">Dalton Allen</a>\n"
   "</nav>\n"
   "<div class=\"col-head\" aria-hidden=\"true\">\n"
   "  <span class=\"corner\"></span>\n"
   "  <span class=\"col is-active\">A</span>\n"
   "</div>")
  "HTML for the site header.")

;; The footer is a strip of sheet tabs, pinned to the bottom of the window by
;; the stylesheet. New pages become new tabs; the "+" is decoration only.
(defconst site-postamble
  (concat
   "<nav class=\"sheet-tabs\" aria-label=\"Pages\">\n"
   "  <a class=\"tab is-active\" href=\"/\" aria-current=\"page\">About</a>\n"
   "  <a class=\"tab\" href=\"#contact\">Contact</a>\n"
   "  <span class=\"tab tab-new\" aria-hidden=\"true\">+</span>\n"
   "</nav>")
  "HTML for the site footer.")

(setq org-publish-project-alist
      `(("content"
         :base-directory ,(site-path "content/")
         :base-extension "org"
         :publishing-directory ,(site-path "public/")
         :publishing-function org-html-publish-to-html
         :recursive t
         ;; Content options
         :with-toc nil
         :section-numbers nil
         :with-author nil
         :with-date nil
         :with-email nil
         :with-creator nil
         :time-stamp-file nil
         ;; HTML options
         :html-doctype "html5"
         :html-html5-fancy t
         :html-container "section"
         :html-head-include-default-style nil
         :html-head-include-scripts nil
         :html-validation-link nil
         :html-head ,site-html-head
         :html-preamble ,site-preamble
         :html-postamble ,site-postamble)
        ("static"
         :base-directory ,(site-path "static/")
         :base-extension "css\\|png\\|jpg\\|svg\\|ico\\|txt"
         :include ("CNAME")
         :publishing-directory ,(site-path "public/")
         :publishing-function org-publish-attachment
         :recursive t)
        ("site" :components ("content" "static"))))

(defun site-publish ()
  "Publish the whole site, forcing a rebuild of every file."
  (org-publish "site" t))

(provide 'publish)
;;; publish.el ends here
