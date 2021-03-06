;; Temporarily up GC limit to speed up start up
(setq gc-cons-threshold 100000000)
(run-with-idle-timer
 5 nil
 (lambda ()
   (setq gc-cons-threshold 1000000)
   (message "gc-cons-threshold restored to %S"
            gc-cons-threshold)))

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Debug package loads
(setq use-package-verbose t)

(setq use-package-always-ensure t)

(eval-when-compile
  (require 'use-package))

(require 'bind-key)
(require 'diminish)
(require 'cl)

;; UTF-8 Thanks
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; File paths
(defvar grass/dotfiles-dir (file-name-directory load-file-name)
  "The root dir of my Emacs config.")
(defvar grass/config-dir (expand-file-name "grass" grass/dotfiles-dir)
  "The directory containing configuration files.")
(defvar grass/snippets-dir (expand-file-name "snippets" grass/dotfiles-dir)
  "A house for snippets.")
(defvar grass/savefile-dir (expand-file-name "savefile" grass/dotfiles-dir)
  "This folder stores all the automatically generated save/history-files.")
(defvar grass/undo-dir (expand-file-name "undo" grass/dotfiles-dir)
  "Undo files.")

;; Ensure savefile directory exists
(unless (file-exists-p grass/savefile-dir)
  (make-directory grass/savefile-dir))

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file)

;; Set up load paths
(add-to-list 'load-path grass/config-dir)
(add-to-list 'load-path (expand-file-name "site-lisp" grass/dotfiles-dir))

(require 'cl)

(setq user-full-name "Ray Grasso"
      user-mail-address "ray.grasso@gmail.com")

(use-package server
  :disabled t
  :if window-system
  :config
  (unless (server-running-p)
    (server-start)))

(require 'grass-osx)
(require 'grass-ui)
(require 'grass-editor)
(require 'grass-evil)
(require 'grass-multiple-cursors)
(require 'grass-ido)
(require 'grass-extensions)
(require 'grass-helm)
(require 'grass-projectile)
(require 'grass-orgmode)
(require 'grass-ruby)
(require 'grass-js)
(require 'grass-coffee)
(require 'grass-webmode)
(require 'grass-markdown)
(require 'grass-haskell)
(require 'grass-lisp)
