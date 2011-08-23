(setq inhibit-startup-message t)
;For debugging
;(setq stack-trace-on-error t)
;(fset 'eshell 'shell)

; Emacs load path
(add-to-list 'load-path user-emacs-directory)
(add-to-list 'load-path (concat user-emacs-directory "vendor"))
(add-to-list 'load-path (concat user-emacs-directory "tools"))

; Load vendor shortcut
(load "vendor")

; Fix scrolling
(vendor 'smooth-scrolling)

; Enable my theme
(vendor 'color-theme)
(vendor 'django-theme)
(django-theme)
; Settings
(set-default-font "Monaco-16")
;; Font size
(define-key global-map (kbd "C-+") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)

; Disable scrollbars
(scroll-bar-mode -1)
; Disable bell completly
(setq ring-bell-function 'ignore)
; Disable toolbar
(tool-bar-mode 0)
; Stop creating those backup~ files
(setq make-backup-files nil)
; Stop creating those #autosave# files
(setq auto-save-default nil)
; Enable fullscren
(global-set-key (kbd "M-RET") 'ns-toggle-fullscreen)
; Display trailing spaces
(setq-default show-trailing-whitespace t)
; Remove trailing spaces
(add-hook 'before-save-hook 'delete-trailing-whitespace)
; Highlight text selection
(transient-mark-mode 1)
; Delete seleted text when typing
(delete-selection-mode 1)
; Fn-Delete is delete
(global-set-key [kp-delete] 'delete-char)
; Undo is Ctrl-Z (better than hidding the Dock
(global-set-key (kbd "C-z") 'undo)
; Ask for 'y' or 'n', not 'yes' or 'no
(fset 'yes-or-no-p 'y-or-n-p)
; Disable fringe
(set-fringe-mode 0)
;(global-linum-mode 1)
(global-visual-line-mode 1)

(setq split-height-threshold nil)
(setq split-width-threshold 0)
; Run a single instance of emacs, which accepts all 'open file' requests
(setq ns-pop-up-frames nil)
(if window-system
  (server-start))
; Does not popup the annoying message when killing a client buffer
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
; Kill them all
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (flet ((process-list ())) ad-do-it))

; Run extensions
(vendor 'gist)
(vendor 'magit)
(vendor 'textmate)
(textmate-mode)

; (vendor 'yasnippet)
; (yas/initialize)
; (setq yas/root-directory "~/.emacs.d/snippets")
; (yas/load-directory yas/root-directory)

; This is needed for Erlang mode setup
(setq erlang-root-dir "/usr/local/Cellar/erlang/R14B03")
(setq load-path (cons "/usr/local/Cellar/erlang/R14B03/lib/erlang/lib/tools-2.6.6.4/emacs" load-path))
(setq exec-path (cons "/usr/local/Cellar/erlang/R14B03/bin" exec-path))
(require 'erlang-start)

;
(defvar erlang-compile-extra-opts '(bin_opt_info (i . "../include")))

; This is needed for Distel setup
(let ((distel-dir (concat user-emacs-directory "vendor/distel/elisp")))
  (unless (member distel-dir load-path)
    ;; Add distel-dir to the end of load-path
    (setq load-path (append load-path (list distel-dir)))))

; Load distel
(require 'distel)
(distel-setup)

(setq erl-nodename-cache 'emacs@127.0.0.1)
(setq inferior-erlang-machine-options '("-name" "emacs@127.0.0.1"))
(setq distel-modeline-node "emacs@127.0.0.1")

(require 'erlang-flymake)

(defun erlang-flymake-get-code-path-dirs ()
  (list (concat (erlang-flymake-get-app-dir) "ebin") (concat (erlang-flymake-get-app-dir) "deps/proper/ebin")))
(defun erlang-flymake-get-include-dirs ()
  (list (concat (erlang-flymake-get-app-dir) "include") (concat (erlang-flymake-get-app-dir) "deps/proper/include")))


(erlang-flymake-only-on-save)

(add-to-list 'load-path (concat user-emacs-directory "vendor/wrangler/elisp"))
(require 'wrangler)
(erlang-refactor-on)

; Flymake syntax checker
; (add-to-list 'load-path (concat user-emacs-directory "vendor/flymake"))
; (require 'flymake_config)
; (erlang-flymake-only-on-save)

; (add-to-list 'load-path (concat user-emacs-directory "vendor/rinari"))
; (require 'rinari)

; (load (concat user-emacs-directory "vendor/nxhtml/autostart.el"))
;
; (setq
;  nxhtml-global-minor-mode t
;  mumamo-chunk-coloring 'submode-colored
;  nxhtml-skip-welcome t
;  indent-region-mode t
;  rng-nxml-auto-validate-flag nil
;  nxml-degraded t)

; (add-to-list 'load-path "~/path/to/your/elisp/nxml-directory/util")
; (require 'mumamo-fun)
; (setq mumamo-chunk-coloring 'submode-colored)
; (add-to-list 'auto-mode-alist '("\\.rhtml$" . eruby-html-mumamo-mode))
; (add-to-list 'auto-mode-alist '("\\.html\\.erb$" . eruby-html-mumamo-mode))

(add-to-list 'auto-mode-alist '("\\.html\\.erb$" . eruby-nxhtml-mumamo-mode))
(add-to-list 'auto-mode-alist '("\\.html$" . eruby-nxhtml-mumamo-mode))

(setq auto-mode-alist
  (append auto-mode-alist
    '(("\\.rel$" . erlang-mode)
      ("\\.app$" . erlang-mode)
      ("\\.appSrc$" . erlang-mode)
      ("\\.app.src$" . erlang-mode)
      ("\\.hrl$" . erlang-mode)
      ("\\.erl$" . erlang-mode)
      ("\\.yrl$" . erlang-mode))))

(defconst distel-shell-keys
  '(("C-M-i"   erl-complete)
    ("M-?"      erl-complete)
    ("M-."      erl-find-source-under-point)
    ("M-,"      erl-find-source-unwind)
    ("M-*"      erl-find-source-unwind)
    )
  "Additional keys to bind when in Erlang shell.")

(defun my-shell()
  (interactive)
  (split-window-horizontally)
  (shell))

(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x C-l") 'linum-mode)
(global-set-key (kbd "C-l") 'goto-line)
(global-set-key (kbd "C-x m") 'shell)

(defun* get-closest-pathname (&optional (file "rebar.config"))
  "Determine the pathname of the first instance of FILE starting from the current directory towards root.
This may not do the correct thing in presence of links. If it does not find FILE, then it shall return the name
of FILE in the current directory, suitable for creation"
  (let ((root (expand-file-name "/"))) ; the win32 builds should translate this correctly
    (expand-file-name file
          (loop
      for d = default-directory then (expand-file-name ".." d)
      if (file-exists-p (expand-file-name file d))
      return d
      if (equal d root)
      return nil))))



; (defun run-rebar()
;   (interactive)
;   (save-buffer)
;   (shell-command "./rebar compile")
;   (if (<= (* 2 (window-height)) (frame-height))
;       (enlarge-window 20)
;     nil))
; (global-set-key (kbd "C-x r") 'run-rebar)


(setq erlang-compile-outdir "../ebin")

;(add-hook 'shell-mode-hook 'erlang-shell-mode)

; Window switching. (C-x o goes to the next window)
;(windmove-default-keybindings) ;; Shift+direction
(global-set-key (kbd "C-x O") (lambda () (interactive) (other-window -1))) ;; back one
(global-set-key (kbd "C-x C-o") (lambda () (interactive) (other-window 2))) ;; forward two

; Use regex searches by default.
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "\C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)
(global-set-key (kbd "C-x C-M-f") 'find-file-in-project)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "C-c y") 'bury-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)
(global-set-key (kbd "M-`") 'file-cache-minibuffer-complete)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(load-library "pc-select")
(pc-selection-mode)

; save window size handling
(defun restore-saved-window-size()
  (unless (load "~/.emacs.d/whsettings" t nil t)
    (setq saved-window-size '(80 30)))
  (nconc default-frame-alist `((width . ,(car saved-window-size))
                               (height . ,(cadr saved-window-size)))))

(defun save-window-size-if-changed (&optional unused)
  (let ((original-window-size  `(,(frame-width) ,(frame-height))))
    (unless (equal original-window-size saved-window-size)
      (with-temp-buffer
        (setq saved-window-size original-window-size)
        (insert (concat "(setq saved-window-size '"
                        (prin1-to-string saved-window-size) ")"))
        (write-file (concat user-emacs-directory "whsettings"))))))

(restore-saved-window-size)
(add-hook 'window-size-change-functions 'save-window-size-if-changed)

; Does not popup the annoying message when killing a client buffer
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)
(defadvice save-buffers-kill-emacs (around no-query-kill-emacs activate)
  "Prevent annoying \"Active processes exist\" query when you quit Emacs."
  (flet ((process-list ())) ad-do-it))

(vendor 'fill-column-indicator)
(require 'fci-osx-23-fix)
(setq fci-rule-color "#000") ; 001f12
(add-hook 'erlang-mode-hook 'fci-mode)

;(define-globalized-minor-mode global-fci-mode fci-mode (lambda () (fci-mode t)))
;(global-fci-mode t)
; (defun clear-shell ()
;    (interactive)
;   (let ((old-max comint-buffer-maximum-size))
;     (setq comint-buffer-maximum-size 0)
;     (comint-truncate-buffer)
;     (setq comint-buffer-maximum-size old-max)))
;(setq display-buffer-prefer-horizontal-split t)

(add-hook 'comint-mode-hook
         (lambda ()
           (define-key comint-mode-map (kbd "<down>") 'comint-next-input)
           (define-key comint-mode-map (kbd "<up>") 'comint-previous-input)
           (define-key comint-mode-map (kbd "s-k") 'comint-show-output)
           ))

(add-hook 'erlang-shell-mode-hook
  (lambda ()
    ;; add some Distel bindings to the Erlang shell
    (dolist (spec distel-shell-keys)
    (define-key erlang-shell-mode-map (car spec) (cadr spec)))))


(global-hl-line-mode 1)

;; Show line-number in the mode line
(setq line-number-mode 1)

;; Show column-number in the mode line
(setq column-number-mode 1)

(setq display-time-day-and-date t
             display-time-24hr-format t)
          (display-time)

(setq eshell-prompt-function
      (lambda ()
        (concat (eshell/pwd)
                " " (or (concat "[" (eshell/branch) "]") "")
                (if (= (user-uid) 0) " # " " $ "))))

(defun eshell/branch ()
  "Return the current git branch, if applicable."
  (let ((branch (shell-command-to-string "git branch")))
    (string-match "^\\* \\(.*\\)" branch)
    (match-string 1 branch)))



(set-face-background 'vertical-border "#245032")
(set-face-foreground 'vertical-border "#245032")

(eval-after-load 'diff-mode
  '(progn
     (set-face-foreground 'diff-added "green4")
     (set-face-foreground 'diff-removed "red3")))

(eval-after-load 'magit
  '(progn
     (set-face-foreground 'magit-diff-add "green3")
     (set-face-foreground 'magit-diff-del "red3")))


;; disable line wrap
;;(setq default-truncate-lines t)

;; make side by side buffers function the same as the main window
;;(setq truncate-partial-width-windows nil)

;; Add F5 to toggle line wrap
(global-set-key [f5] 'toggle-truncate-lines)