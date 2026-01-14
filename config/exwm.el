;; Basic EXWM setup
(require 'exwm)
(require 'exwm-config)
(exwm-config-default)

;; Use 10 workspaces (0–9)
(setq exwm-workspace-number 10)

;; Allow certain keys to pass through / be global
(setq exwm-input-prefix-keys
      '(?\C-x ?\C-u ?\C-h ?\M-x ?\M-` ?\M-& ?\M-:
        [XF86AudioLowerVolume] [XF86AudioRaiseVolume]
        [XF86AudioMute] [XF86AudioPlay]
        [XF86AudioNext] [XF86AudioPrev]
        [XF86MonBrightnessUp] [XF86MonBrightnessDown]))

;; Helper to spawn shell commands
(defun my/spawn (cmd)
  (start-process-shell-command cmd nil cmd))

;; --- Workspace switching (Alt+1..0) ---
(dotimes (i 10)
  (exwm-input-set-key
   (kbd (format "M-%d" (if (= i 9) 0 (1+ i))))
   `(lambda ()
      (interactive)
      (exwm-workspace-switch ,i))))

(dotimes (i 10)
  (exwm-input-set-key
   (kbd (format "M-S-%d" (if (= i 9) 0 (1+ i))))
   `(lambda ()
      (interactive)
      (exwm-workspace-move-window ,i))))

;; Quick previous workspace (Alt+Tab analogue)
(exwm-input-set-key (kbd "M-<tab>") #'exwm-workspace-switch-last)

;; --- Movement: Alt+E/B/N/P and arrows ---
(exwm-input-set-key (kbd "M-e") #'windmove-right)  ; focus-column-right
(exwm-input-set-key (kbd "M-b") #'windmove-left)   ; focus-column-left
(exwm-input-set-key (kbd "M-n") #'windmove-down)   ; focus-window-down
(exwm-input-set-key (kbd "M-p") #'windmove-up)     ; focus-window-up

(exwm-input-set-key (kbd "M-<left>")  #'windmove-left)
(exwm-input-set-key (kbd "M-<right>") #'windmove-right)
(exwm-input-set-key (kbd "M-<up>")    #'windmove-up)
(exwm-input-set-key (kbd "M-<down>")  #'windmove-down)

;; You can add buffer-move-* from windmove/buffer-move for Alt+Shift+arrows.

;; --- Terminal and launcher (Alt+Shift+Return, Alt+F) ---
(exwm-input-set-key
 (kbd "M-S-<return>")
 (lambda () (interactive) (start-process "kitty" nil "kitty")))

(exwm-input-set-key
 (kbd "M-f")
 (lambda () (interactive)
   (start-process "wofi" nil "wofi" "--show" "drun")))

;; --- Close / fullscreen / maximize ---
(exwm-input-set-key (kbd "M-S-q") #'exwm-layout-delete-window)
(exwm-input-set-key (kbd "M-S-f") #'exwm-layout-toggle-fullscreen)

;; “Maximize column” rough analogue: maximize current window
(exwm-input-set-key
 (kbd "M-S-m")
 (lambda () (interactive)
   (delete-other-windows)))

;; --- App launchers matching your Niri binds ---
(exwm-input-set-key
 (kbd "M-S-e")
 (lambda () (interactive)
   (my/spawn "emacsclient -c --alternate-editor=\"\"")))

(exwm-input-set-key
 (kbd "M-S-d")
 (lambda () (interactive)
   (my/spawn "microsoft-edge")))

(exwm-input-set-key
 (kbd "M-d")
 (lambda () (interactive)
   (my/spawn "firefox")))

(exwm-input-set-key
 (kbd "M-a")
 (lambda () (interactive)
   (my/spawn "hyprshot -m region --clipboard-only")))

;; --- Screenshots (Print / Alt+Print) ---
(exwm-input-set-key
 [print]
 (lambda () (interactive)
   (my/spawn "grimblast copy area && wl-paste | swappy -f -")))

;; --- Media & brightness keys ---
(exwm-input-set-key
 [XF86MonBrightnessUp]
 (lambda () (interactive)
   (my/spawn "brightnessctl s +5% && notify-send -t 1000 'Brightness' \"$(brightnessctl g)\"")))

(exwm-input-set-key
 [XF86MonBrightnessDown]
 (lambda () (interactive)
   (my/spawn "brightnessctl s 5%- && notify-send -t 1000 'Brightness' \"$(brightnessctl g)\"")))

(exwm-input-set-key
 [XF86AudioRaiseVolume]
 (lambda () (interactive)
   (my/spawn \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ && notify-send -t 1000 'Volume' \"\"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)\"\"\")))

(exwm-input-set-key
 [XF86AudioLowerVolume]
 (lambda () (interactive)
   (my/spawn \"wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- && notify-send -t 1000 'Volume' \"\"$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | cut -d' ' -f2)\"\"\")))

(exwm-input-set-key
 [XF86AudioMute]
 (lambda () (interactive)
   (start-process "mute" nil "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle")))

(exwm-input-set-key
 [XF86AudioPlay]
 (lambda () (interactive)
   (my/spawn "playerctl play-pause && notify-send -t 1000 'Media' \"$(playerctl status): $(playerctl metadata title)\"")))

(exwm-input-set-key [XF86AudioNext]
                    (lambda () (interactive) (start-process "next" nil "playerctl" "next")))
(exwm-input-set-key [XF86AudioPrev]
                    (lambda () (interactive) (start-process "prev" nil "playerctl" "previous")))

;; --- Startup applications roughly matching Niri spawn-at-startup ---
(defun my/exwm-init ()
  (my/spawn "wl-paste --watch cliphist store")
  (start-process "dex" nil "dex" "--autostart" "--environment" "exwm")
  (start-process "nm-applet" nil "nm-applet")
  (start-process "wallpaper" nil "swaybg" "-i" "/home/puppy/Pictures/gruvbox_pokemon_marnie_wp_dark.png" "-m" "fill")
  (start-process "gammastep" nil "gammastep" "-l" "52.520008:13.404954" "-t" "4000:4000")
  (start-process "dunst" nil "dunst")
  (start-process "vesktop" nil "vesktop"))

;; Bar
(require 'exwm-systemtray)
(setq-default
 mode-line-format
 '(" "
   ;; workspaces: [0] [1] [2] ...
   (:eval
    (let* ((cur exwm-workspace-current-index)
           (n   exwm-workspace-number))
      (mapconcat
       (lambda (i)
         (format (if (= i cur) "[%d]" " %d ") i))
       (number-sequence 0 (1- n))
       ""))
   " | "
   mode-line-buffer-identification
   " | "
   mode-line-position
   " | "
   ;; clock
   (:eval (format-time-string "%Y-%m-%d %H:%M"))))


(add-hook 'exwm-init-hook #'my/exwm-init)

(exwm-enable)
