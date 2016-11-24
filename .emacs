;; EMACS 24.5 CONFIGURATION FILE
;; Jeremy Yee

;; INSTALLING PACKAGES
;; --------------------------------------

(require 'package)
(add-to-list 'package-archives 
	     '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    material-theme
    py-autopep8
    evil
    magit
    ess
    iedit
    auctex
    autopair
    auto-complete
    auto-complete-c-headers
    flymake-google-cpplint
    flymake-cursor
    google-c-style
    yasnippet))

(mapc #'(lambda (package)
    (unless (package-installed-p package)
      (package-install package)))
      myPackages)

;; BASIC
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally
(evil-mode t) ;; enable evil mode
(global-set-key "\C-xg" 'magit-status) ;; key for git
(autopair-global-mode t) ;; autopairing
(global-flycheck-mode t) ;; style
(yas-global-mode t) ;; yasnippet templates
(define-key global-map (kbd "C-;") 'iedit-mode) ;; iedit mode
;; windmove
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))
;; Move along visual lines instead of physical ones
(define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
(define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
;; Quick way to find and open file
(global-set-key [f7] 'find-file-in-repository)
;; Auto-complete mode + extra settings
(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
;; Start yasnippet with emacs
(require 'yasnippet)
(yas-global-mode t)
;; Code browser
;;(require 'ecb)
;;(setq ecb-auto-activate 1) 
(put 'downcase-region 'disabled nil)

;; PYTHON
;; --------------------------------------
;; Need to install pip, matplotlib, flake8, jedi, ipython

(elpy-enable)
(elpy-use-ipython)

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; use python3. comment this out for python2
(setq python-shell-interpreter "/usr/bin/python3")

;; R
;; --------------------------------------

(autoload 'R-mode "ess-site.el" "ESS" t)
(add-to-list 'auto-mode-alist '("\\.R$" . R-mode))

;; TEX
;; --------------------------------------

(load "auctex.el" nil t t)
;;(load "preview-latex.el" nil t t)

(setq TeX-auto-save t)
(setq TeX-parse-self t)
(setq-default TeX-master nil)

(add-hook 'LaTeX-mode-hook 'visual-line-mode)
;;(add-hook 'LaTeX-mode-hook 'flyspell-mode) ;; comment this out for iedit
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)

(add-hook 'LaTeX-mode-hook 'turn-on-reftex)
(setq reftex-plug-into-AUCTeX t)

;; C++
;; --------------------------------------
;; Install cpplint

;; Auto-complete-c-headers and gets called for c/c++ hooks
(defun my:ac-c-header-init ()
  (require 'auto-complete-c-headers)
  (add-to-list 'ac-sources 'ac-source-c-headers)
  )
;; Call this function from c/c++ hooks
(add-hook 'c++-mode-hook 'my:ac-c-header-init)
(add-hook 'c-mode-hook 'my:ac-c-header-init)

;; Start flymake-google-cpplint-load
(defun my:flymake-google-init () 
  (require 'flymake-google-cpplint)
  (custom-set-variables
   '(flymake-google-cpplint-command "/usr/local/bin/cpplint"))
  (flymake-google-cpplint-load)
  )
(add-hook 'c-mode-hook 'my:flymake-google-init)
(add-hook 'c++-mode-hook 'my:flymake-google-init)

;; Google c style
(require 'google-c-style)
(add-hook 'c-mode-common-hook 'google-set-c-style)
(add-hook 'c-mode-common-hook 'google-make-newline-indent)

;; Turn on Semantic
(semantic-mode 1)
;; let's define a function which adds semantic as a suggestion backend to auto complete
;; and hook this function to c-mode-common-hook
(defun my:add-semantic-to-autocomplete() 
  (add-to-list 'ac-sources 'ac-source-semantic)
  )
(add-hook 'c-mode-common-hook 'my:add-semantic-to-autocomplete)

;; JULIA
;; --------------------------------------
;; set paths to ess-site.el and julia executable

(load "/home/jeremyyee/.emacs.d/elpa/ess-20160208.453/lisp/ess-site.el")
(setq inferior-julia-program-name "/usr/bin/julia")

;;; .emacs ends here
