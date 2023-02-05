;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Dougie Peart"
      user-mail-address "contact@dougiepeart.co.uk")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/docs/org/")
(setq org-roam-directory "~/docs/org/brain")
(setq org-roam-capture-templates
      '(("m" "main" plain
	 "%?"
	 :target (file+head "main/${slug}.org"
			    "#+title: ${title}\n")
	 :immediate-finish t
	 :unarrowed t)
        ("b" "Books")
	("bf" "Fiction Book" plain
	 (file "~/docs/org/brain/templates/BookNoteTemplateFiction.org")
	 :target
	 (file+head "books/${slug}.org"
		    "#+title: ${title}\n")
	 :unarrowed t)
	("bn" "Non-Fiction Book" plain
	 (file "~/docs/org/brain/templates/BookNoteTemplateNonFiction.org")
	 :target
	 (file+head "books/${slug}.org"
		    "#+title: ${title}\n")
	 :unarrowed t)
	("bi" "Book Index" plain
	 (file "~/docs/org/brain/templates/BookNoteTemplateIndex.org")
	 :target
	 (file+head "books/${slug}.org"
		    "#+title: ${title}\n")
	 :unarrowed t)))

(after! org
 (setq org-agenda-files
 	'("~/docs/org/gtd.org"
 	  "~/docs/org/kanban.org"
 	  "~/docs/org/projects.org"
 	  "~/docs/org/habits.org"
 	  "~/docs/org/agenda.org"
 	  "~/docs/org/reading.org"
 	  "~/docs/org/personal/birthdays.org")))

(after! org
 (setq org-todo-keywords
     '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
       (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "|" "COMPLETED(c)" "CANC(k@)")
       (sequence "EVENT(e)" "|" "CANC(k@")
       (sequence "FITNESS(f)" "|" "CANC(k@")
       (sequence "TO-READ(tr)" "READING(cr)" "|" "READ(rr)"))))

(after! org
   (setq org-todo-keyword-faces
 	'(("TODO" . "orange")
 	  ("EVENT" . "yellow")
 	  ("READING" . "purple")
 	  ("FITNESS" . "red")
 	  )))

(after! org
   (setq org-refile-targets
     '(("archive.org" :maxlevel . 1)
       ("kanban.org" :maxlevel . 2)
       ("projects.org" :maxlevel . 2)
       ("agenda.org" :maxlevel . 1)
       ("reading.org" :maxlevel . 1)
       ("gtd.org" :maxlevel . 1)))
   ;; Save org buffers after a refile
   (advice-add 'org-refile :after 'org-save-all-org-buffers))

(after! org
  (setq org-tag-alist
     '((:startgroup)
        ; Put mutually exclusive tags here
        (:endgroup)
        ("@errand" . ?E)
        ("@home" . ?H)
        ("@office" . ?O)
        ("email" . ?o)
        ("work" . ?w)
        ("agenda" . ?a)
        ("planning" . ?p)
        ("documentation" . ?d)
        ("project" . ?z)
        ("event" . ?e)
        ("life" . ?l)
        ("homelab" . ?h))))

(after! org
     ;; Configure custom agenda views
   (setq org-agenda-custom-commands
    '(("d" "Dashboard"
      ((agenda "" ((org-deadline-warning-days 7)))
       (todo "ACTIVE"
         ((org-agenda-overriding-header "Active Tasks")))
       (todo "EVENT"
         ((org-agenda-overriding-header "Events")))
       (todo "READING"
         ((org-agenda-overriding-header "Currently Reading")))
       (todo "ACTIVE"
 	((org-agenda-overriding-header "Active Projects")))))

     ("n" "Next Tasks"
      ((todo "NEXT"
         ((org-agenda-overriding-header "Next Tasks")))))

     ("I" "Task Inbox"
      ((todo "TODO"
 	    ((org-agenda-overriding-header "Task Inbox")))))

     ("W" "Work Tasks" tags-todo "+work-email")

     ("o" "Office Tasks" tags-todo "@office")
     ("l" "Life Tasks" tags-todo "life")
     ("p" "Projects Tasks" tags-todo "project")

     ;; Low-effort next actions
     ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
      ((org-agenda-overriding-header "Low Effort Tasks")
       (org-agenda-max-todos 20)
       (org-agenda-files org-agenda-files)))

     ("w" "Workflow Status"
       ((todo "PLAN"
             ((org-agenda-overriding-header "In Planning")
              (org-agenda-todo-list-sublevels nil)
              (org-agenda-files org-agenda-files)))
       (todo "BACKLOG"
             ((org-agenda-overriding-header "Project Backlog")
              (org-agenda-todo-list-sublevels nil)
              (org-agenda-files org-agenda-files)))
       (todo "READY"
             ((org-agenda-overriding-header "Ready for Work")
              (org-agenda-files org-agenda-files)))
       (todo "ACTIVE"
             ((org-agenda-overriding-header "Active Projects")
              (org-agenda-files org-agenda-files)))
       (todo "WAIT"
             ((org-agenda-overriding-header "Waiting on External")
              (org-agenda-files org-agenda-files)))
       (todo "REVIEW"
             ((org-agenda-overriding-header "In Review")
              (org-agenda-files org-agenda-files)))
       (todo "COMPLETED"
             ((org-agenda-overriding-header "Completed Projects")
              (org-agenda-files org-agenda-files)))
       (todo "CANC"
             ((org-agenda-overriding-header "Cancelled Projects")
              (org-agenda-files org-agenda-files))))))))

(after! org
   (setq org-capture-templates
     `(("t" "Tasks / Projects Inbox")
       ("tt" "Task" entry (file+olp "~/docs/org/kanban.org" "INBOX")
            "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)
;       ("tn" "Next Task" entry (file+olp "~/docs/org/gtd.org" "Next")
;            "* NEXT %?\n  %U\n  %a\n  %i" :empty-lines 1)
;       ("tp" "Project" entry (file+olp "~/docs/org/projects.org" "Inbox")
;            "* TODO %?\n  %U\n  %a\n  %i" :empty-lines 1)

       ("e" "Events")
       ("ep" "Personal Event" entry (file+olp "~/docs/org/agenda.org" "Personal")
 		"* EVENT %?\nSCHEDULED: <%<%Y-%m-%d %a>>")
       ("ew" "Work Event" entry (file+olp "~/docs/org/agenda.org" "Work")
 	"* EVENT %?\nSCHEDULED: <%<%Y-%m-%d %a>>" :empty-lines 1))))

(after! org
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(after! org
  (setq jiralib-url "https://blackarrowgroup.atlassian.net"))

;; Update elfeed on open
(add-hook! 'elfeed-search-mode-hook #'elfeed-update)

;;(let ((org-super-agenda-groups
;;       '((:log t)  ; Automatically named "Log"
;;         (:name "Schedule"
;;                :time-grid t)
;;         (:name "Today"
;;                :scheduled today)
;;         (:habit t)
;;         (:name "Due today"
;;                :deadline today)
;;         (:name "Overdue"
;;                :deadline past)
;;         (:name "Due soon"
;;                :deadline future)
;;         (:name "Unimportant"
;;                :todo ("SOMEDAY" "MAYBE" "CHECK" "TO-READ" "TO-WATCH")
;;                :order 100)
;;         (:name "Waiting..."
;;                :todo "WAIT"
;;                :order 98)
;;         (:name "Scheduled earlier"
;;                :scheduled past))))
;;  (org-agenda-list))

(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
;;example
;;(map! (:leader
;;        (:desc "search" :prefix "/"
;;          :desc "Swiper"                :nv "/" #'swiper
;;          :desc "Imenu"                 :nv "i" #'imenu
;;          :desc "Imenu across buffers"  :nv "I" #'imenu-anywhere
;;          :desc "Online providers"      :nv "o" #'+jump/online-select)));
;;
;;


(map! :leader
      (
        :desc "Swiper" "/" #'swiper
        :desc "Deft Find" "ff" #'deft-find-file
              ))

;; Deft
(setq deft-directory "~/docs")
(setq deft-recursive t)

;; ox-hugo settings
(with-eval-after-load 'ox
  (require 'ox-hugo))

(setq vterm-shell "/usr/bin/zsh")

;; Beancount-mode
(add-to-list 'load-path "/path/to/beancount-mode/")
(require 'beancount)
(add-to-list 'auto-mode-alist '("\\.beancount\\'" . beancount-mode))

;; chatgpt
(use-package! chatgpt
  :defer t
  :config
  (unless (boundp 'python-interpreter)
    (defvaralias 'python-interpreter 'python-shell-interpreter))
  (setq chatgpt-repo-path (expand-file-name "straight/repos/ChatGPT.el/" doom-local-dir))
  (set-popup-rule! (regexp-quote "*ChatGPT*")
    :side 'bottom :size .5 :ttl nil :quit t :modeline nil)
  :bind ("C-c q" . chatgpt-query))

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
