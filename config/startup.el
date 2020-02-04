;;; startup --- Startup settings and built in package setup
;;; Commentary:
;;; Code:

(defvar file-name-handler-alist-original file-name-handler-alist)


(when (memq window-system '(mac ns x))
  (setq mac-option-modifier 'meta)
  (setq mac-command-modifier 'super))

(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6
      file-name-handler-alist nil
      site-run-file nil)

(defvar fp/gc-cons-threshold 20000000)

(add-hook 'emacs-startup-hook #'(lambda ()
                                  (setq gc-cons-threshold fp/gc-cons-threshold
                                        gc-cons-percentage 0.1
                                        file-name-handler-alist file-name-handler-alist-original)))

(add-hook 'minibuffer-setup-hook #'(lambda ()
                                     (setq gc-cons-threshold most-positive-fixnum)))

(add-hook 'minibuffer-exit-hook #'(lambda ()
                                    (garbage-collect)
                                    (setq gc-cons-threshold fp/gc-cons-threshold)))

(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("org"   . "https://orgmode.org/elpa/"))
(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

(use-package emacs
  :preface
  (defvar fp/indent-width 4)
  :config
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (global-hl-line-mode t)

  (fset 'yes-or-no-p 'y-or-n-p)

  (setq default-directory "~/")
  (setq ring-bell-function 'ignore)
  (setq-default line-spacing 3
                indent-tabs-mode nil
                tab-width fp/indent-width))


(use-package "startup"
  :ensure nil
  :custom
  (inhibit-startup-screen t))

(use-package cus-edit
  :ensure nil
  :custom
  (custom-file "~/.emacs.d/custom.el"))

(use-package scroll-bar
  :ensure nil
  :config
  (scroll-bar-mode -1))

(use-package simple
  :ensure nil
  :config
  (column-number-mode +1))

(use-package delsel
  :ensure nil
  :config
  (delete-selection-mode +1))

(use-package files
  :ensure nil
  :custom
  (confirm-kill-processes nil)
  (make-backup-files nil))

(use-package autorevert
  :ensure nil
  :custom
  (auto-revert-interval 2)
  (auto-revert-check-vc-info t)
  (global-auto-revert-non-file-buffers t)
  (auto-revert-verbose nil)
  :config
  (global-auto-revert-mode +1))

(use-package eldoc
  :ensure nil
  :custom
  (eldoc-idle-delay 0.4))

(use-package js
  :ensure nil
  :mode ("\\.jsx?\\'" . js-mode)
  :custom
  (js-indent-level fp/indent-width)
  :config
  (add-hook 'flycheck-mode-hook
            #'(lambda ()
                (let* ((root (locate-dominating-file
                              (or (buffer-file-name) default-directory)
                              "node_modules"))
                       (eslint
                        (and root
                             (expand-file-name "node_modules/.bin/eslint"
                                               root))))
                  (when (and eslint (file-executable-p eslint))
                    (setq-local flycheck-javascript-eslint-executable eslint))))))

(use-package cc-vars
  :ensure nil
  :custom
  (c-default-style '((java-mode . "java")
                     (awk-mode  . "awk")
                     (other     . "k&r")))
  :config
  (setq-default c-basic-offset fp/indent-width))

(use-package prolog
  :ensure nil
  :mode (("\\.pl\\'" . prolog-mode))
  :custom
  (prolog-indent-width fp/indent-width))

(use-package python
  :ensure nil
  :custom
  (python-indent-offset fp/indent-width)
  (python-shell-interpreter "python3"))

(use-package mwheel
  :ensure nil
  :custom
  (mouse-wheel-scroll-amount '(1 ((shift) . 1)))
  (mouse-wheel-progressive-speed nil))

(use-package paren
  :ensure nil
  :init
  (setq show-paren-delay 0)
  :config
  (show-paren-mode +1))

(use-package frame
  :ensure nil
  :custom
  (initial-frame-alist '((fullscreen . maximized)))
  :config
  (blink-cursor-mode -1))

(use-package ediff
  :ensure nil
  :custom
  (ediff-split-window-function #'split-window-horizontally))

(use-package elec-pair
  :ensure nil
  :hook (prog-mode . electric-pair-mode))

(use-package whitespace
  :ensure nil
  :hook (before-save . whitespace-cleanup))

(use-package dired
  :ensure nil
  :custom
  (delete-by-moving-to-trash t)
  :config
  (put 'dired-find-alternate-file 'disabled nil))

(use-package saveplace
  :ensure nil
  :config
  (save-place-mode +1))

(use-package display-line-numbers
  :ensure nil
  :hook (prog-mode . display-line-numbers-mode)
  :config
  (setq-default display-line-numbers-width 3))

(provide 'startup)
;;; startup.el ends here
