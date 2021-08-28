;;·disable·to·menu·bar
(menu-bar-mode -1)

;;·load·theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/plugins")
(load-theme 'dracula t)

;;·disable·backups and autosave
(setq backup-inhibited t)
(setq auto-save-default nil)

;;·line·and·column·numbers in prog mode
(column-number-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;;·disable·tabs and set·default·tab·width
(setq-default indent-tabs-mode nil)
(setq tab-width 2)

;; show invisible characters
(progn
  (setq whitespace-style (quote (face spaces tabs newline space-mark tab-mark newline-mark)))
  (setq whitespace-display-mappings
        '(
          (space-mark 32 [183] [46])
          (newline-mark 10 [172 10])
          (tab-mark 9 [8594 9] [92 9])
          )))
(add-hook 'prog-mode-hook 'whitespace-mode)

;;·initiate·evil·mode
(add-to-list 'load-path "~/.emacs.d/evil")
(require 'evil)
(evil-mode 1)

;; initialize package sources
(require 'package)
(add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/") t)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

(package-initialize)
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; https://github.com/DarthFennec/highlight-indent-guides
(use-package highlight-indent-guides
  :ensure t
  :diminish highlight-indent-guides-mode
  :config
  (setq highlight-indent-guides-method 'character)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

;; https://github.com/Fanael/rainbow-delimiters
(use-package rainbow-delimiters
  :init
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))
