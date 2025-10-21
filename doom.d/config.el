;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Brooklyn Zelenka"
      user-mail-address "hello@brooklynzelenka.com")

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
;;;;;;;;; BROOKE'S CUTSOM THEMES
(add-to-list 'custom-theme-load-path "~/.doom.d/themes/")
;; (setq doom-theme 'doom-solarized-twilight)
;; (setq doom-theme 'doom-fairy-floss)
;; (setq doom-theme 'doom-moonlight)
;; (setq doom-theme 'doom-molokai)
(setq doom-theme 'doom-dracula)

;; (setq catppuccin-flavor 'latte)
;; (setq doom-theme 'catppuccin)

(setq doom-themes-enable-bold t    ;; Enable bold fonts
      doom-themes-enable-italic t) ;; Enable italic fonts
(add-hook! 'doom-load-theme-hook
  (set-face-attribute 'font-lock-keyword-face nil :slant 'italic);; Cursive for some fonts; else use 'italic
  (set-face-attribute 'font-lock-comment-face nil :slant 'italic :weight 'light)
  (set-face-attribute 'font-lock-doc-face nil :slant 'italic)
  (set-face-attribute 'font-lock-doc-markup-face nil :slant 'normal :weight 'normal))
(set-face-background 'default "unspecified-bg") ;; disable background colour for transparency

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
;; 
;; ;; If you use `org' and don't want your org files in the default location below,
;; ;; change `org-directory'. It must be set before org loads!
;; (setq org-directory "~/org/")

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
;; accept completion from copilot and fallback to company
;;
(use-package! copilot
  :defer t
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(display-battery-mode 1)
;; (use-package! obsidian
;;   :ensure t
;;   ;; :demand t
;;   ;; :config (global-obsidian-mode t)
;;   ;; (obsidian-backlinks-mode t)
;;   ;; :custom
;;   ;; (obsidian-directory "~/Documents/Notes/notes/content")  ;; This is where your Obsidian notes are located
;;   ;; (markdown-enable-wiki-links t)
;;
;;   ;; Optional: Enable Obsidian mode in Markdown files automatically
;;   (add-hook 'markdown-mode-hook 'obsidian-mode)
;;
;;   ;; Add a hook to enable obsidian-mode only in the correct directory
;;   (add-hook 'find-file-hook 'my/enable-obsidian-if-in-vault)
;;
;;   ;; Keybindings (optional, using Doom leader key)
;;   (map! :leader
;;         :prefix "n"  ;; "n" for notes
;;         :desc "Obsidian follow link" "f" #'obsidian-follow-link
;;         :desc "Obsidian back link" "b" #'obsidian-backlink
;;         :desc "Obsidian new note" "n" #'obsidian-new))
;;
;; ;; (use-package! eldoc-box
;; ;;   :hook (lsp-mode . eldoc-box-hover-mode))
;; ;;
;; ;; (after! eldoc
;; ;;   (global-eldoc-mode 1)
;; ;;   (setq eldoc-echo-area-use-multiline-p t)
;; ;;   )
