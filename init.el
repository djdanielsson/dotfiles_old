;;Theme
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")
(load-theme `tron t)

;;Commands
;;to find commmands hit 'C-h' then 'k' then type in what it does
;;to switch buffers 'C-x' 'b'
;;to make a new window 'C-x' '3' and then 'C-x' '0' closes the first window
;;to switch frames 'C-x' 'o'
;;to open a shell 'alt-x' 'shell'
;;to cancel a command 'C-g'
;;to open IRC 'alt-x' 'irc-maybe'
(global-set-key (kbd "C-c") 'kill-ring-save)
(global-set-key (kbd "C-v") 'yank)

;;Date and Time
(setq display-time-day-and-date t
      display-time-24hr-format t)
(display-time)

;IRC stuff
(require 'erc-join)
(erc-autojoin-mode 1)
(setq erc-autojoin-channels-alist
      '(("freenode.net" "#TMCcis")
        ("98.148.11.35" "#general" "#linux-gaming")))
(require 'erc-match)
(setq erc-pals '("Alpha1_501st" "sumbeard"))
(setq erc-log-channels-directory "~/.erc/logs/")
(setq erc-log-insert-log-on-open nil)
(setq erc-log-channels t)
(defadvice save-buffers-kill-emacs (before save-logs (arg) activate)
           (save-some-buffers t (lambda() (when (eq-major-mode 'erc-mode) t))))
(setq erc-save-buffer-on-part nil
      erc-save-queries-on-quit nil
      erc-log-write-after-send t
      erc-log-write-after-insert t)
(defun irc-maybe()
"Connect to IRC."
(interactive)
(when (y-or-n-p "IRC? ")

;;irc notification
(add-hook 'erc-text-matched-hook 'erc-beep-on-match)
(setq erc-beep-match-types '(current-nick keyword))

(add-hook 'erc-insert-post-hook
  (lambda () (goto-char (point-min))
    (when (re-search-forward
      (regexp-quote  (erc-current-nick)) nil t) (ding))))

;Git
;(require 'git)
;(require 'git-commit)
;(add-to-list 'load-path "/mnt/data/appdata/emacs/magit")
;(add-to-list 'load-path "/mnt/data/appdata/emacs/git-modes")
;(require 'magit)
;(global-set-key (kbd "C-x g") 'magit-status)


