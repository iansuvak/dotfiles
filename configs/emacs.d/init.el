;;; dotEmacs --- My emacs config

;;; Avoid compiler warnings about assigning free variables.
(defvar straight-use-package-by-default)

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

;; Install use-package
(straight-use-package 'use-package)
;; Configure use-package to use straight.el by default

;; Force use-package to use straight.el to automatically install missing packages
(setq straight-use-package-by-default t)


;;; General settings to remove GUI cruft

(setq inhibit-splash-screen t
      inhibit-startup-message t
      inhibit-startup-echo-area-message t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(show-paren-mode 1)

;(setq visual-line-fringe-indicators '(left-curly-arrow right-curly-arrow))
(visual-line-mode 1)

;;; EVIL

(straight-use-package 'evil)

(straight-use-package 'evil-leader)
(global-evil-leader-mode)
(evil-mode 1)


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

(use-package evil-surround
    :demand t
    :config
    (global-evil-surround-mode 1))

;;; Helm
(use-package helm
    :demand t
    :config
    (setq helm-buffers-fuzzy-matching t)
    (helm-mode 1))
;;; Projectile
(use-package projectile
    :demand t
    :config
    (defvar projectile-enable-caching t)
    (projectile-global-mode))
(use-package helm-projectile
    :demand t
    :config
    (define-key evil-normal-state-map (kbd "C-p") 'helm-projectile)
    (define-key evil-normal-state-map (kbd "-") 'helm-find-files))


;;; Org-Roam
(setq org-roam-v2-ack t)
(use-package org-roam
      :ensure t
      :config (visual-line-mode)
      (org-roam-db-autosync-mode)
      (add-to-list 'display-buffer-alist
             '("\\*org-roam\\*"
               (display-buffer-in-direction)
               (direction . right)
               (window-width . 0.33)
               (window-height . fit-window-to-buffer)))
      :custom
      (org-roam-directory "~/Dropbox/org/roam")
      (org-roam-dailies-directory "daily/")
      (org-roam-dailies-capture-templates
      '(("d" "default" entry
         "* %?"
         :target (file+head "%<%Y-%m-%d>.org"
                            "#+title: %<%Y-%m-%d>\n"))))
      (doom-themes-org-config)
      :bind  ("C-c n l" . org-roam-buffer-toggle)
             ("C-c n t" . org-roam-dailies-goto-today)
             ("C-c n f" . org-roam-node-find)
             ("C-c n i" . org-roam-node-insert)
             ("C-c n g" . org-roam-show-graph)
             ("C-c n c" . org-roam-capture)
      )

;;; Doom Theme

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

;;; Misc packages
(use-package auto-complete
    :demand t
    :config
    (global-auto-complete-mode t))
(use-package all-the-icons)
(use-package neotree
    :demand t
    :config
    (add-hook 'neotree-mode-hook
          (lambda ()
            (define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
            (define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
            (define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter))))
