;;; rk-header-line-format.el --- Functions for constructing the header line format string.  -*- lexical-binding: t; -*-

;; Copyright (C) 2017 Raghuvir Kasturi

;; Author: Raghuvir Kasturi <raghuvir.kasturi@gmail.com>

;;; Commentary:

;;; Code:

(require 'dash)
(require 's)
(require 'subr-x)
(require 'rk-theme-base)

(autoload 'all-the-icons-icon-for-mode "all-the-icons")
(autoload 'all-the-icons-icon-for-file "all-the-icons")
(autoload 'all-the-icons-octicon "all-the-icons")
(autoload 'all-the-icons-fileicon "all-the-icons")
(autoload 'magit-get-current-branch "magit-git")
(autoload 'projectile-project-p "projectile")

(defconst rk-header-line-format--derived-modes
  '(rk-web-js-mode rk-web-css-mode rk-web-typescript-mode rk-web-html-mode rk-web-json-mode)
  "Derived modes.")

;;; Faces

(defgroup rk-header-line-format nil
  "Utilities for constructing the header line."
  :group 'themes
  :prefix "rk-header-line-format-")

(defface rk-header-line-format-nonemphased-element
  '((t
     (:inherit header-line)))
  "Face for non-emphasised elements in the header line."
  :group 'rk-header-line-format)

(defface rk-header-line-format-accent-element
  `((t
     (:inhert header-line :foreground ,rk-theme-base-yellow)))
  "Face for accented elements in the header line."
  :group 'rk-header-line-format)

(defface rk-header-line-format-project-name
  '((t
     (:inherit header-line)))
  "Face for project name in header line."
  :group 'rk-header-line-format)

(defface rk-header-line-format-branch-name
  '((t
     (:inherit header-line)))
  "Face for git branch in header line."
  :group 'rk-header-line-format)

(defface rk-header-line-format-host-name
  '((t
     (:inherit header-line)))
  "Face for host-name in header line."
  :group 'rk-header-line-format)

;;; Helper for testing if window selected.

(defvar rk-header-line-format--window-for-redisplay nil
  "The window currently being redisplayed.")

(defun rk-header-line-format--set-window-for-redisplay (_)
  (when (not (minibuffer-window-active-p (frame-selected-window)))
    (setq rk-header-line-format--window-for-redisplay (selected-window))))

(add-function :before pre-redisplay-function #'rk-header-line-format--set-window-for-redisplay)

(defun rk-header-line-format--window-selected? ()
  (eq rk-header-line-format--window-for-redisplay (get-buffer-window)))

;;; Cache variable lookups to improve speed

(defconst rk-header-line-format--cache-duration-seconds 10)

(defun rk-header-line-format--make-cache-key ()
  (cons (current-time) default-directory))

(defun rk-header-line-format--cache-expired? (key)
  (-let* (((time . key-directory) key)
          (expiry-time (time-add time rk-header-line-format--cache-duration-seconds)))

    (or (time-less-p expiry-time (current-time))
        (not (equal default-directory key-directory)))))

;; Cache the git branch.

(defvar-local rk-header-line-format--branch nil
  "A cons of (cache-key . branch-name) or nil")

(defun rk-header-line-format--update-branch ()
  (let ((key (rk-header-line-format--make-cache-key))
        (branch (magit-get-current-branch)))
    (setq rk-header-line-format--branch (cons key branch))
    branch))

(defun rk-header-line-format--current-branch ()
  (require 'magit)
  (-if-let ((key . branch) rk-header-line-format--branch)
      (cond
       ((rk-header-line-format--cache-expired? key)
        (rk-header-line-format--update-branch))
       (t
        branch))
    (rk-header-line-format--update-branch)))

;; Cache the projectile project.
;;
;; Projectile maintains its own cache of project info, but it still does file IO
;; as part of its checks.

(defvar-local rk-header-line-format--project nil
  "A cons of (cache-key . project-name) or nil")

(defun rk-header-line-format--update-project ()
  (let ((key (rk-header-line-format--make-cache-key))
        (project (projectile-project-p)))
    (setq rk-header-line-format--project (cons key project))
    project))

(defun rk-header-line-format--current-project ()
  (-if-let ((key . project) rk-header-line-format--project)
      (cond
       ((rk-header-line-format--cache-expired? key)
        (rk-header-line-format--update-project))
       (t
        project))
    (rk-header-line-format--update-project)))

;;; Construction functions

(defun rk-header-line-format--nonemphasised (str)
  (propertize str 'face 'rk-header-line-format-nonemphased-element))

(defun rk-header-line-format--access-mode-info ()
  (let ((str (concat
              (if (and (buffer-file-name) (file-remote-p (buffer-file-name))) "@" "")
              (if buffer-read-only "%" "")
              (if (buffer-modified-p) "*" ""))))
    (propertize (s-pad-right 2 " " str) 'face 'rk-header-line-format-accent-element)))

(defun rk-header-line-format--project-info ()
  (let* ((project (rk-header-line-format--current-project))
         (project (when project (directory-file-name project)))
         (project-root-name (when project (file-name-nondirectory project)))
         (branch (when project (rk-header-line-format--current-branch)))
         (subdir (when project (s-chop-prefix project (directory-file-name (file-truename default-directory))))))
    (cond
     ((and project branch)
      (concat (rk-header-line-format--nonemphasised " (")
              (propertize project-root-name 'face 'rk-header-line-format-project-name)
              (rk-header-line-format--nonemphasised subdir)
              (rk-header-line-format--nonemphasised " on ")
              (all-the-icons-octicon "git-branch" :v-adjust 0.1 :height 0.9)
              " "
              (propertize branch 'face 'rk-header-line-format-branch-name)
              (rk-header-line-format--nonemphasised ") ")))
     (project
      (concat (rk-header-line-format--nonemphasised " (in ")
              (propertize project-root-name 'face 'rk-header-line-format-project-name)
              (rk-header-line-format--nonemphasised ") ")))
     (t
      ""))))

(defun rk-header-line-format--host-info ()
  (concat
   (rk-header-line-format--nonemphasised " (at ")
   (propertize (and (boundp 'tramp-current-host) tramp-current-host) 'face 'rk-header-line-format-host-name)
   (rk-header-line-format--nonemphasised ") ")))

(defun rk-header-line-format--context-info ()
  (cond
   ((not (rk-header-line-format--window-selected?))
    "")
   ((file-remote-p default-directory)
    "")
   (t
    (rk-header-line-format--project-info))))

(defun rk-header-line-format--major-mode-icon ()
  (-let* ((mode major-mode)
          (is-derived-mode-p (-contains-p rk-header-line-format--derived-modes mode))
          (fn (if is-derived-mode-p #'all-the-icons-icon-for-file #'all-the-icons-icon-for-mode))
          (fn-args (if is-derived-mode-p (buffer-name) mode))
          (height 0.8)
          (v-adjust (if is-derived-mode-p 0.05 (if (eq mode 'emacs-lisp-mode) -0.1 0.05))))
    (concat (funcall fn fn-args :height height :v-adjust v-adjust) " ")))

(defun rk-header-line-format--major-mode-info ()
  (cond
   ((eq major-mode 'turn-on-evil-mode)
    "")
   (t
    (rk-header-line-format--major-mode-icon))))

(defun rk-header-line-format--buffer-name ()
  (if (rk-header-line-format--window-selected?)
      (buffer-name)
    (propertize (buffer-name) 'face 'rk-header-line-format-nonemphased-element)))

(defun rk-header-line-format--line-info ()
  (let ((str "%2l"))
    (if (rk-header-line-format--window-selected?)
        str
      (propertize str 'face 'rk-header-line-format-nonemphased-element))))

(defconst rk-header-line-format
  '(
    ;; Print error on low memory
    "%e"
    " "

    ;; Emacsclient info
    mode-line-client

    ;; Major mode icon
    (:eval (rk-header-line-format--major-mode-info))

    ;; Current line, padded
    (:eval (rk-header-line-format--line-info))
    "  "
    (:propertize "%6p " face rk-header-line-format-nonemphased-element)

    ;; Modification indicator.
    (:eval (rk-header-line-format--access-mode-info))

    ;; Buffer name, with braces on recursive edit
    "  %[" (:eval (rk-header-line-format--buffer-name)) "%] "

    (:eval (rk-header-line-format--context-info))))

(provide 'rk-header-line-format)

;;; rk-header-line-format.el ends here
