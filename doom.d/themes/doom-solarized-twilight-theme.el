(require 'doom-themes)

;;
;;; Variables

(defgroup doom-solarized-twilight-theme nil
  "Options for the `doom-solarized-twilight' theme."
  :group 'doom-themes)

(defcustom doom-solarized-twilight-brighter-modeline nil
  "If non-nil, more vivid colors will be used to style the mode-line."
  :group 'doom-solarized-twilight-theme
  :type 'boolean)

(defcustom doom-solarized-twilight-brighter-comments nil
  "If non-nil, comments will be highlighted in more vivid colors."
  :group 'doom-solarized-twilight-theme
  :type 'boolean)

(defcustom doom-solarized-twilight-brighter-text nil
  "If non-nil, default text will be brighter."
  :group 'doom-solarized-twilight-theme
  :type 'boolean)

(defcustom doom-solarized-twilight-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-solarized-twilight-theme
  :type '(choice integer boolean))


;;
;;; Theme definition

(def-doom-theme doom-solarized-twilight
    "A dark theme inspired by VS Code Solarized Dark"

  ;; name        default   256       16

  ;; name        default   256       16
  ((bg         '("#2a0d3b" "#2a0d3b" "brightwhite" ))
   (fg         (if doom-solarized-twilight-brighter-text
                   '("#DD99FF" "#DD99FF" "brightwhite")
                 '("#B280B8" "#B280B8" "brightwhite")))

   ;; These are off-color variants of bg/fg, used primarily for `solaire-mode',
   ;; but can also be useful as a basis for subtle highlights (e.g. for hl-line
   ;; or region), especially when paired with the `doom-darken', `doom-lighten',
   ;; and `doom-blend' helper functions.
   (bg-alt     '("#3d1b59" "#3d1b59" "white"       ))
   (fg-alt     '("#7a4b82" "#7a4b82" "white"       ))

   ;; These should represent a spectrum from bg to fg, where base0 is a starker
   ;; bg and base8 is a starker fg. For example, if bg is light grey and fg is
   ;; dark grey, base0 should be white and base8 should be black.
   (base0      '("#2a0d3b" "#2a0d3b" "black"       ))
   (base1      '("#3d1b59" "#3d1b59" "brightblack" ))
   (base2      '("#4a2c6e" "#4a2c6e" "brightblack" ))
   (base3      '("#5e4a8e" "#5e4a8e" "brightblack" ))
   (base4      '("#7f6fb5" "#7f6fb5" "brightblack" ))
   (base5      '("#9a7fcd" "#9a7fcd" "brightblack" ))
   (base6      '("#b7b0e0" "#b7b0e0" "brightblack" ))
   (base7      '("#c6a4d2" "#c6a4d2" "brightblack" ))
   (base8      '("#e0c6e4" "#e0c6e4" "white"       ))

   (grey       base4)
   (red        '("#d04b8c" "#ff66b2" "red"          ))
   (orange     '("#f77b76" "#ff88cc" "brightred"    ))
   (green      '("#e458b6" "#ff66cc" "magenta"      )) ;; #expede LOL FIXME
   (teal       '("#539bc5" "#33aa99" "brightgreen"  ))
   (yellow     '("#8f4dff" "#bb66ff" "yellow"       )) ;; #expede LOL FIXME
   (blue       '("#6f4ce1" "#51afef" "brightblue"   ))
   (dark-blue  '("#4629a8" "#2257A0" "blue"         ))
   (violet     '("#7c56c3" "#a9a1e1" "brightmagenta"))
   (magenta    '("#d33682" "#c678dd" "magenta"      ))
   (cyan       '("#2aa198" "#46D9FF" "brightcyan"   ))
   (dark-cyan  '("#204052" "#5699AF" "cyan"         ))

   ;; face categories -- required for all themes
   (highlight      yellow)
   (vertical-bar   (doom-darken base1 0.5))
   (selection      dark-blue)
   (builtin        blue)
   (comments       (if doom-solarized-twilight-brighter-comments purple base5))
   (doc-comments   teal)
   (constants      violet)
   (functions      blue)
   (keywords       yellow)
   (methods        cyan)
   (operators      orange)
   (type           magenta)
   (strings        cyan)
   (variables      violet)
   (numbers        magenta)
   (region         base0)
   (error          red)
   (warning        yellow)
   (success        teal)
   (vc-modified    magenta)
   (vc-added       teal)
   (vc-deleted     red)

   ;; custom categories
   (-modeline-bright doom-solarized-twilight-brighter-modeline)
   (-modeline-pad
    (when doom-solarized-twilight-padded-modeline
      (if (integerp doom-solarized-twilight-padded-modeline) doom-solarized-twilight-padded-modeline 4)))

   (modeline-fg 'unspecified)
   (modeline-fg-alt base5)

   (modeline-bg
    (if -modeline-bright
        base3
      `(,(doom-darken (car bg) 0.1) ,@(cdr base0))))
   (modeline-bg-alt
    (if -modeline-bright
        base3
      `(,(doom-darken (car bg) 0.15) ,@(cdr base0))))
   (modeline-bg-inactive     `(,(car bg-alt) ,@(cdr base1)))
   (modeline-bg-inactive-alt (doom-darken bg 0.1)))


  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :background (if doom-solarized-twilight-brighter-comments (doom-lighten bg 0.05) 'unspecified))
   ((font-lock-keyword-face &override) :weight 'bold)
   ((font-lock-constant-face &override) :weight 'bold)
   ((line-number &override) :foreground base4)
   ((line-number-current-line &override) :foreground fg)
   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground (if -modeline-bright base8 highlight))

   ;;;; centaur-tabs
   (centaur-tabs-active-bar-face :background blue)
   (centaur-tabs-modified-marker-selected
    :inherit 'centaur-tabs-selected :foreground blue)
   (centaur-tabs-modified-marker-unselected
    :inherit 'centaur-tabs-unselected :foreground blue)
   ;;;; company
   (company-tooltip-selection     :background dark-cyan)
   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property             :foreground green)
   (css-selector             :foreground blue)
   ;;;; doom-modeline
   (doom-modeline-bar :background blue)
   (doom-modeline-evil-emacs-state  :foreground magenta)
   (doom-modeline-evil-insert-state :foreground blue)
   ;;;; elscreen
   (elscreen-tab-other-screen-face :background "#353a42" :foreground "#1e2022")
   ;;;; helm
   (helm-selection :inherit 'bold
                   :background selection
                   :distant-foreground bg
                   :extend t)
   ;;;; markdown-mode
   (markdown-markup-face :foreground base5)
   (markdown-header-face :inherit 'bold :foreground red)
   (markdown-url-face    :foreground teal :weight 'normal)
   (markdown-reference-face :foreground base6)
   ((markdown-bold-face &override)   :foreground fg)
   ((markdown-italic-face &override) :foreground fg-alt)
   ;;;; outline <built-in>
   ((outline-1 &override) :foreground blue)
   ((outline-2 &override) :foreground green)
   ((outline-3 &override) :foreground teal)
   ((outline-4 &override) :foreground (doom-darken blue 0.2))
   ((outline-5 &override) :foreground (doom-darken green 0.2))
   ((outline-6 &override) :foreground (doom-darken teal 0.2))
   ((outline-7 &override) :foreground (doom-darken blue 0.4))
   ((outline-8 &override) :foreground (doom-darken green 0.4))
   ;;;; org <built-in>
   ((org-block &override) :background base0)
   ((org-block-begin-line &override) :foreground comments :background base0)
   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line
    :background modeline-bg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-alt)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive
    :background modeline-bg-inactive-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-alt))))

  ;;;; Base theme variable overrides-
  ;; ()
  )

;;; doom-solarized-twilight-theme.el ends here
