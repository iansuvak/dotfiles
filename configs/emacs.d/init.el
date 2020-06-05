;;; dotEmacs --- My emacs config

;;; Avoid compiler warnings about assigning free variables.
(defvar package-list)
(defvar package-archives)
(defvar package-archive-enable-alist)
(defvar evil-normal-state-map)
(defvar evil-normal-state-local-map)
(defvar org-mode-map)
(defvar org-agenda-files)
(defvar org-todo-keywords)
(defvar org-capture-templates)

;;; List the packages you want.
(setq package-list '(ag
                     all-the-icons
                     auto-complete
                     base16-theme
                     color-theme-approximate
                     color-theme-sanityinc-tomorrow
                     doom-themes
                     evil-indent-textobject
                     evil-leader
                     evil-mc
                     evil-surround
                     fill-column-indicator
                     fiplr
                     flycheck-pyflakes
                     flycheck
                     grizzl
                     gtags
                     helm-projectile
                     helm
                     helm-core
                     highlight-symbol
                     magit-svn
                     magit
                     magit-popup
                     git-commit
                     ghub
                     markdown-mode+
                     markdown-preview-eww
                     markdown-preview-mode
                     markdown-mode
                     memoize
                     mustache
                     ht
                     dash
                     mustache-mode
                     neotree
                     notify
                     org-journal
                     php-extras
                     php-mode
                     popup
                     powerline-evil
                     powerline
                     evil
                     goto-chg
                     projectile
                     pkg-info
                     epl
                     s
                     twilight-anti-bright-theme
                     twilight-bright-theme
                     undo-tree
                     web-server
                     websocket
                     window-numbering
                     with-editor
                     async
                     yasnippet
                     zenburn-theme))
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;; List the repositories containing them.
;; For the record, I want to allow any package from ELPA or MELPA, but only the
;; ones from Marmalade that I absolutely need to have and am willing to put up
;; with potentially old releases. So leave it like this until I find the ones
;; that can't be found, then slowly add those to package-archive-enable-alist.
(setq package-archives '(("elpa" .      "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" .     "http://melpa.milkbox.net/packages/")))
(setq package-archive-enable-alist '(("marmalade" gtags)))

;;; Activate all the packages (in particular autoloads).
(package-initialize)

(require 'use-package)

;;; Fetch the list of packages available.
(unless (file-exists-p package-user-dir)
  (package-refresh-contents))

;;; Install the missing packages.
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(show-paren-mode 1)

;(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(visual-line-mode 1)

;;; Turn off scroll bar mode if it exists (GUI only)
(when (boundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;;; Evil leader must be loaded before evil (as documented).
(global-evil-leader-mode)
;;; Always use evil mode.
(evil-mode 1)
(global-auto-complete-mode t)

;;; Seamlessly degrade color themes to terminal colors.
;(autoload 'color-theme-approximate-on "color-theme-approximate")
;(color-theme-approximate-on)

;; DOOM themes
(require 'doom-themes)

;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
      doom-themes-enable-italic t) ; if nil, italics is universally disabled

;; Load the theme (doom-one, doom-molokai, etc); keep in mind that each theme
;; may have their own settings.
(load-theme 'doom-one t)

;; Enable flashing mode-line on errors
(doom-themes-visual-bell-config)

;; Enable custom neotree theme (all-the-icons must be installed!)
(doom-themes-neotree-config)
;; or for treemacs users
(setq doom-themes-treemacs-theme "doom-colors") ; use the colorful treemacs theme
(doom-themes-treemacs-config)

;; Corrects (and improves) org-mode's native fontification.
(doom-themes-org-config)

(defvar show-paren-delay 0
  "Delay (in seconds) before matching paren is highlighted.")
(setq-default left-fringe-width 10)
(defvar projectile-enable-caching t
  "Tell Projectile to cache project file lists.")

(defvar backup-dir "~/.emacs.d/backups/")
(setq backup-directory-alist (list (cons "." backup-dir)))
(setq make-backup-files nil)

(setq-default highlight-symbol-idle-delay 1.5)
(setq-default fci-rule-character 9474)
(setq-default fci-rule-character-color "color-52")

(powerline-evil-vim-color-theme)

;;; YAsnippet
(require 'yasnippet)
;(setq-default yas-snippet-dirs '("~/.emacs.d/snippets"
;                                 "~/.emacs.d/remote-snippets"))
;(yas-global-mode 1)
;(define-key yas-minor-mode-map (kbd "<tab>") nil)
;(define-key yas-minor-mode-map (kbd "TAB") nil)
;(define-key yas-minor-mode-map (kbd "C-l") 'yas-expand)
;
;(setq yas-prompt-functions '(yas-completing-prompt
;                             yas-ido-prompt
;                             yas-dropdown-prompt))

;;;Neotree
(require 'neotree)
(add-hook 'neotree-mode-hook
          (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;;;Multiple Cursors
(require 'evil-mc)
(global-evil-mc-mode 0)
(evil-define-key 'visual evil-mc-key-map
  "A" #'evil-mc-make-cursor-in-visual-selection-end
  "I" #'evil-mc-make-cursor-in-visual-selection-beg)
;(require 'multiple-cursors)
;(define-key mc/keymap (kbd "C-n") 'mc/edit-lines)


(add-hook 'after-init-hook 'global-flycheck-mode)
(defvar flycheck-xml-parser)
(defvar flycheck-check-syntax-automatically)
(defvar flycheck-disabled-checkers)
(defvar flycheck-phpcs-standard)
(defvar flycheck-idle-change-delay )
(defvar flycheck-display-errors-function)
;; Override default flycheck triggers
(setq flycheck-xml-parser 'flycheck-parse-xml-region)
(setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
      flycheck-idle-change-delay 0.8
      flycheck-disabled-checkers '(php-phpmd)
      flycheck-phpcs-standard "/home/isuvak/code/data-local/non-web/standardscheck/CSNStores")

(setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list)

(projectile-global-mode)

(evil-add-hjkl-bindings ag-mode-map 'normal
  "n"   'evil-search-next
  "N"   'evil-search-previous
  "RET" 'compile-goto-error)
(evil-add-hjkl-bindings occur-mode-map 'emacs
  (kbd "/")       'evil-search-forward
  (kbd "n")       'evil-search-next
  (kbd "N")       'evil-search-previous
  (kbd "C-d")     'evil-scroll-down
  (kbd "C-u")     'evil-scroll-up
  (kbd "C-w C-w") 'other-window)
(evil-add-hjkl-bindings org-agenda-mode-map 'emacs
  "RET" 'org-agenda-switch-to)

;;; Settings for evil-mode.
(setq evil-want-C-u-scroll t)
(setq evil-leader/in-all-states 1)
(setq-default evil-want-C-i-jump nil)

;;; Use Helm all the time.
(setq helm-buffers-fuzzy-matching t)
(helm-mode 1)

;;; Use evil surround mode in all buffers.
(global-evil-surround-mode 1)

;;; Use spaces instead of tabs.
(setq-default indent-tabs-mode nil)
;;; Don't actually use VC, because it slows down loading.
(eval-after-load "vc" '(setq vc-handled-backends nil))
;;; Follow symlinks to version-controlled files without argument. Just do it.
(setq vc-follow-symlinks t)
;;; Don't warn me when files are big. It's fine.
(setq large-file-warning-threshold nil)
;;; Never "sensibly" split windows vertically.
(setq split-width-threshold nil)

(defun switch-to-previous-buffer ()
  "Switch to previously open buffer.
Repeated invocations toggle between the two most recently open buffers."
  (interactive)
  (switch-to-buffer (other-buffer (current-buffer) 1)))


(defun selective-display-increase ()
  (interactive)
  (set-selective-display
   (if selective-display (+ selective-display 1) 1)))

(defun selective-display-decrease ()
  (interactive)
  (when selective-display
    (set-selective-display
     (if (< (- selective-display 1) 1)
         nil
       (- selective-display 1)))))

;;; Give me more awesome key bindings that I miss from Vim.
(define-key evil-normal-state-map (kbd "C-p") 'helm-projectile)
(define-key evil-normal-state-map (kbd "-") 'helm-find-files)

;; Org mode section
(setq org-todo-keywords
      '((sequence "TODO" "IN-PROGRESS" "WAITING" "|" "DONE" "CANCELLED")))
(setq org-agenda-files '("~/Dropbox/org/"))
(evil-define-key 'normal org-mode-map (kbd "TAB") 'org-cycle)
(evil-define-key 'normal org-mode-map (kbd "C-\\") 'org-insert-heading)
(evil-define-key 'insert org-mode-map (kbd "C-\\") 'org-insert-heading)
(defun pop-to-org-agenda (split)
  "Visit the org agenda, in the current window or a SPLIT."
  (interactive "P")
  (org-agenda-list)
  (when (not split)
    (delete-other-windows)))
(define-key global-map (kbd "C-c t a") 'pop-to-org-agenda)
(setq org-capture-templates
      '(("a" "My TODO task format." entry
         (file "~/Dropbox/org/todo.org")
         "* TODO %?
SCHEDULED: %t")))

(defun org-task-capture ()
  "Capture a task with my default template."
  (interactive)
  (org-capture nil "a"))
(define-key global-map (kbd "C-c c") 'org-task-capture)

(require 'org-journal)
(setq org-journal-dir "~/Dropbox/org/journal")
(setq org-journal-file-format "%Y%m%d.org")

(use-package org-roam
      :after org
      :hook 
      ((org-mode . org-roam-mode)
       (after-init . org-roam--build-cache-async) ;; optional!
       )
      :straight (:host github :repo "jethrokuan/org-roam" :branch "develop")
      :config (visual-line-mode)
      :custom
      (org-roam-directory "~/Dropbox/org/roam")
      :bind
      ("C-c n l" . org-roam)
      ("C-c n t" . org-roam-today)
      ("C-c n f" . org-roam-find-file)
      ("C-c n i" . org-roam-insert)
      ("C-c n g" . org-roam-show-graph))


;;; Configure evil-leader
(evil-leader/set-leader "\\")
(evil-leader/set-key
  "\\"  'switch-to-previous-buffer
  "aa" 'align-regexp
  "b"  'helm-mini
  "c"  'comment-or-uncomment-region
  "B"  'magit-blame-mode
  "d"  (lambda () (interactive) (evil-ex-call-command nil "bdelete" nil))
  "D"  'open-current-line-in-codebase-search
  "f"  'helm-semantic-or-imenu
  "g"  'magit-status
  "l"  'whitespace-mode
  "n"  'neotree-toggle
  "o"  'delete-other-windows
  "q"  'kill-other-buffers
  "p"  'helm-projectile-switch-project
  "s"  'ag-project           ;; "search"
  "r"  'font-lock-fontify-buffer
  "S"  'delete-trailing-whitespace
  "t"  'gtags-reindex
  "T"  'gtags-find-tag
  "w"  'save-buffer
  "x"  'helm-M-x)

;; Exclude Evil from modes it doesn't play nice with
(add-hook 'term-mode-hook 'evil-emacs-state)

;;; Set up relative line numbering to mimic `:set number relativenumber`.
(global-linum-mode t)
(add-hook 'linum-before-numbering-hook 'my-linum-get-format-string)

;;; Stuff for line numbers.
(defun my-linum-get-format-string ()
  (let* ((width (max 4 (1+ (length (number-to-string
                             (count-lines (point-min) (point-max)))))))
         (format (concat "%" (number-to-string width) "d ")))
    (setq my-linum-format-string format)))

(defvar my-linum-current-line-number 0)

(setq linum-format 'my-linum-relative-line-numbers)

(defun my-linum-relative-line-numbers (line-number)
  (let* ( (offset (abs (- line-number my-linum-current-line-number)))
          (linum-display-value (if (= 0 offset)
           my-linum-current-line-number
           offset))
        )
    (propertize (format my-linum-format-string linum-display-value) 'face 'linum)))

(defadvice linum-update (around my-linum-update)
  (let ((my-linum-current-line-number (line-number-at-pos)))
    ad-do-it))
(ad-activate 'linum-update)

;;; Provide a style based on "php" that changes a couple of indent behaviors.
(c-add-style "wf-php"
             '("php"
               (c-basic-offset . 2)
               (c-offsets-alist . ((arglist-intro . my-php-lineup-arglist-intro)
                                   (arglist-close . my-php-lineup-arglist-close)
                                   (arglist-cont-nonempty . my-php-lineup-arglist-cont-nonempty)))))

 (defun kill-other-buffers ()
         "Kill all other buffers."
         (interactive)
         (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

;;; Configure things for PHP usage.
(defun configure-php-mode ()
  (require 'newcomment)
  (setq comment-auto-fill-only-comments 1)
  (setq auto-fill-function 'do-auto-fill)

  (c-set-style "wf-php")
  (turn-on-eldoc-mode)
  (highlight-symbol-mode)

  (turn-on-auto-fill)
  (set-fill-column 120)
  (turn-on-fci-mode)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace)
  (add-hook 'before-save-hook 'delete-trailing-whitespace)
  (gtags-mode t)

  (define-key evil-normal-state-map (kbd "_") 'selective-display-decrease)
  (define-key evil-normal-state-map (kbd "+") 'selective-display-increase))

(add-hook 'php-mode-hook 'configure-php-mode)

;;; Emacs Lisp mode:
(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (turn-on-eldoc-mode)
            (highlight-symbol-mode)))

;;; SH mode:
(add-hook 'sh-mode-hook (lambda ()
                          (setq sh-basic-offset 2)
                          (setq sh-indentation 2)))

;;; Javascript mode:
(add-hook 'javascript-mode-hook (lambda ()
                                  (message "IAM RUNNIGN IN UR HOOKS")
                                  (set-fill-column 120)
                                  (turn-on-auto-fill)))
(setq js-indent-level 2)

;;; Markdown mode:
(add-hook 'markdown-mode-hook (lambda ()
                                (set-fill-column 80)
                                (turn-on-auto-fill)
                                (turn-on-fci-mode)
                                (flyspell-mode)))

(add-hook 'flycheck-mode-hook
          (lambda ()
            (evil-define-key 'normal flycheck-mode-map (kbd "]e") 'flycheck-next-error)
            (evil-define-key 'normal flycheck-mode-map (kbd "[e") 'flycheck-previous-error)))

;;; PATH Fixes
(defun set-exec-path-from-shell-PATH ()
  "Sets the exec-path to the same value used by the user shell"
  (let ((path-from-shell
         (replace-regexp-in-string
          "[[:space:]\n]*$" ""
          (shell-command-to-string "$SHELL -l -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

;; call function now
(set-exec-path-from-shell-PATH)

(defun helm-project-files ()
  (interactive)
  (helm-other-buffer '(helm-c-source-projectile-files-list) "*Project Files*"))

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

(set-frame-font "InconsolataG for Powerline-12" nil t)
;; Don't litter my init file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(provide 'init)
(put 'downcase-region 'disabled nil)
