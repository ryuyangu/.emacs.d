;;; rk-magit.el --- Configuration for magit.  -*- lexical-binding: t; -*-

;; Copyright (C) 2017 Raghuvir Kasturi

;; Author: Raghuvir Kasturi <raghuvir.kasturi@gmail.com>

;;; Commentary:

;;; Code:

(eval-when-compile
  (require 'use-package))

(require 'spacemacs-keys)
(require 'evil-transient-state)

(autoload 'evil-define-key "evil-core")

(use-package with-editor
  :straight t
  :commands (with-editor-finish
             with-editor-cancel)
  :config
  (progn
    (spacemacs-keys-set-leader-keys-for-minor-mode 'with-editor-mode
      "c" #'with-editor-finish
      "k" #'with-editor-cancel)))

(use-package magit
  :straight t
  :defer t
  :commands (magit-status magit-blame magit-branch-and-checkout)
  :functions (magit-display-buffer-fullframe-status-v1)
  :preface
  (evil-transient-state-define git-blame
    :title "Git Blame Transient State"
    :doc "
Press [_b_] again to blame further in the history, [_q_] to go up or quit."
    :on-enter (unless (bound-and-true-p magit-blame-mode)
                (call-interactively 'magit-blame))
    :on-exit (magit-blame-quit)
    :foreign-keys run
    :bindings
    ("b" magit-blame)
    ("q" nil :exit t))
  :init
  (progn
    (spacemacs-keys-set-leader-keys
      "gs" #'magit-status
      "gb" #'git-blame-transient-state/body))
  :config
  (progn
    (evil-define-key 'normal magit-refs-mode-map (kbd ".") #'magit-branch-and-checkout)
    (setq magit-log-section-commit-count 0)
    (setq magit-display-buffer-function #'magit-display-buffer-fullframe-status-v1)))

(use-package git-commit-jira-prefix
  :hook (git-commit-setup . git-commit-jira-prefix-insert))

(use-package evil-magit
  :straight t
  :after magit
  :config
  (progn
    (evil-define-key 'normal magit-mode-map (kbd "C-u") #'evil-scroll-page-up)
    (evil-define-key 'visual magit-mode-map (kbd "C-u") #'evil-scroll-page-up)
    (evil-define-key 'normal magit-mode-map (kbd "C-d") #'evil-scroll-page-down)
    (evil-define-key 'normal magit-mode-map (kbd "C-d") #'evil-scroll-page-down)))

(use-package git-timemachine
  :straight (:host gitlab :repo "pidu/git-timemachine" :branch "master")
  :defer t
  :commands
  (git-timemachine
   git-timemachine-show-current-revision
   git-timemachine-show-nth-revision
   git-timemachine-show-previous-revision
   git-timemachine-show-next-revision
   git-timemachine-show-previous-revision
   git-timemachine-kill-revision
   git-timemachine-quit)
  :preface
  (evil-transient-state-define time-machine
    :title "Git Timemachine Transient State"
    :doc "
[_p_/_N_] previous [_n_] next [_c_] current [_g_] goto nth rev [_Y_] copy hash [_q_] quit"
    :on-enter (unless (bound-and-true-p git-timemachine-mode)
                (call-interactively 'git-timemachine))
    :on-exit (when (bound-and-true-p git-timemachine-mode)
               (git-timemachine-quit))
    :foreign-keys run
    :bindings
    ("c" git-timemachine-show-current-revision)
    ("g" git-timemachine-show-nth-revision)
    ("p" git-timemachine-show-previous-revision)
    ("n" git-timemachine-show-next-revision)
    ("N" git-timemachine-show-previous-revision)
    ("Y" git-timemachine-kill-revision)
    ("q" nil :exit t))
  :init
  (spacemacs-keys-set-leader-keys
    "gt" #'time-machine-transient-state/body))

(use-package diff-hl
  :straight t
  :after magit
  :preface
  (progn
    (defun rk-magit--diff-hl-mode-on ()
      (diff-hl-mode -1))

    (defun rk-magit--diff-hl-mode-off ()
      (diff-hl-mode +1)))
  :init
  (progn
    (evil-transient-state-define git-hunks
      :title "Git Hunk Transient State"
      :doc "
[_p_/_N_] previous [_n_] next [_g_] goto [_x_] revert [_q_] quit"
      :foreign-keys run
      :bindings
      ("n" diff-hl-next-hunk)
      ("N" diff-hl-previous-hunk)
      ("p" diff-hl-previous-hunk)
      ("g" diff-hl-diff-goto-hunk)
      ("x" diff-hl-revert-hunk)
      ("q" nil :exit t))

    (spacemacs-keys-set-leader-keys "g." 'git-hunks-transient-state/body))
  :config
  (progn
    (add-hook 'iedit-mode-hook #'rk-magit--diff-hl-mode-on)
    (add-hook 'iedit-mode-end-hook #'rk-magit--diff-hl-mode-off)
    (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh)
    (global-diff-hl-mode)))

(provide 'rk-magit)

;;; rk-magit.el ends here
