
;;;;;;;;;;;;
;; Cheats ;;
;;;;;;;;;;;;

(defun grass/open-cheats ()
  "Open Emacs cheats file"
  (interactive)
  (find-file "~/Dropbox/Notes/Emacs.md"))

;;;;;;;;;;;;;;;;;
;; Comment box ;;
;;;;;;;;;;;;;;;;;

;; http://stackoverflow.com/a/21051395/62023
(defun grass/comment-box (beg end &optional arg)
  (interactive "*r\np")
  ;; (when (not (region-active-p))
  (when (not (and transient-mark-mode mark-active))
    (setq beg (point-at-bol))
    (setq end (point-at-eol)))
  (let ((fill-column (- fill-column 6)))
    (fill-region beg end))
  (comment-box beg end arg)
  (grass/move-point-forward-out-of-comment))

(defun grass/point-is-in-comment-p ()
  "t if point is in comment or at the beginning of a commented line, otherwise nil"
  (or (nth 4 (syntax-ppss))
    (looking-at "^\\s *\\s<")))

(defun grass/move-point-forward-out-of-comment ()
  "Move point forward until it's no longer in a comment"
  (while (grass/point-is-in-comment-p)
    (forward-char)))

;;;;;;;;;;;;;;;
;; Unfilling ;;
;;;;;;;;;;;;;;;

;; From http://mbork.pl/2015-11-14_A_simple_unfilling_function
(defun grass/unfill-region (begin end)
  "Change isolated newlines in region into spaces."
  (interactive (if (use-region-p)
                 (list (region-beginning)
                   (region-end))
                 (list nil nil)))
  (save-restriction
    (narrow-to-region (or begin (point-min))
      (or end (point-max)))
    (goto-char (point-min))
    (while (search-forward "\n" nil t)
      (if (eq (char-after) ?\n)
        (skip-chars-forward "\n")
        (delete-char -1)
        (insert ?\s)))))

;;;;;;;;;;;;;;;
;; Indenting ;;
;;;;;;;;;;;;;;;

(defun grass/indent-buffer ()
  "Indents the entire buffer."
  (indent-region (point-min) (point-max)))

(defun grass/indent-region-or-buffer ()
  "Indents a region if selected, otherwise the whole buffer."
  (interactive)
  (save-excursion
    (if (region-active-p)
      (progn
        (indent-region (region-beginning) (region-end))
        (message "Indented selected region."))
      (progn
        (grass/indent-buffer)
        (message "Indented buffer.")))))

;;;;;;;;;;;
;; Shell ;;
;;;;;;;;;;;

;; Easier key binding for shell replace command
(defun grass/shell-command-with-prefix-arg ()
  (interactive)
  (setq current-prefix-arg '(4)) ; C-u
  (call-interactively 'shell-command-on-region))

;;;;;;;;;;;;;;;;;;;;;;;;
;; Search and Replace ;;
;;;;;;;;;;;;;;;;;;;;;;;;


(defun grass/replace-string (from-string to-string &optional delimited start end)
  "This is a modified version of `replace-string'. This modified version defaults to operating on the entire buffer instead of working only from POINT to the end of the buffer."
  (interactive
  (let ((common
          (query-replace-read-args
          (concat "Replace"
                  (if current-prefix-arg " word" "")
                  (if (and transient-mark-mode mark-active) " in region" ""))
          nil)))
    (list (nth 0 common) (nth 1 common) (nth 2 common)
          (if (and transient-mark-mode mark-active)
              (region-beginning)
            (buffer-end -1))
          (if (and transient-mark-mode mark-active)
              (region-end)
            (buffer-end 1)))))
  (perform-replace from-string to-string nil nil delimited nil nil start end))

(defun grass/replace-regexp (regexp to-string &optional delimited start end)
  "This is a modified version of `replace-regexp'. This modified version defaults to operating on the entire buffer instead of working only from POINT to the end of the buffer."
  (interactive
  (let ((common
          (query-replace-read-args
          (concat "Replace"
                  (if current-prefix-arg " word" "")
                  " regexp"
                  (if (and transient-mark-mode mark-active) " in region" ""))
          t)))
    (list (nth 0 common) (nth 1 common) (nth 2 common)
          (if (and transient-mark-mode mark-active)
              (region-beginning)
            (buffer-end -1))
          (if (and transient-mark-mode mark-active)
              (region-end)
            (buffer-end 1)))))
  (perform-replace regexp to-string nil t delimited nil nil start end))

(defun grass/query-replace-regexp (regexp to-string &optional delimited start end)
  "This is a modified version of `query-replace-regexp'. This modified version defaults to operating on the entire buffer instead of working only from POINT to the end of the buffer."
  (interactive
  (let ((common
          (query-replace-read-args
          (concat "Replace"
                  (if current-prefix-arg " word" "")
                  " regexp"
                  (if (and transient-mark-mode mark-active) " in region" ""))
          t)))
    (list (nth 0 common) (nth 1 common) (nth 2 common)
          (if (and transient-mark-mode mark-active)
              (region-beginning)
            (buffer-end -1))
          (if (and transient-mark-mode mark-active)
              (region-end)
            (buffer-end 1)))))
  (perform-replace regexp to-string t t delimited nil nil start end))

(defun grass/query-replace-string (from-string to-string &optional delimited start end)
  "This is a modified version of `query-replace-string'. This modified version defaults to operating on the entire buffer instead of working only from POINT to the end of the buffer."
  (interactive
  (let ((common
          (query-replace-read-args
          (concat "Replace"
                  (if current-prefix-arg " word" "")
                  (if (and transient-mark-mode mark-active) " in region" ""))
          nil)))
    (list (nth 0 common) (nth 1 common) (nth 2 common)
          (if (and transient-mark-mode mark-active)
              (region-beginning)
            (buffer-end -1))
          (if (and transient-mark-mode mark-active)
              (region-end)
            (buffer-end 1)))))
  (perform-replace from-string to-string t nil delimited nil nil start end))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Insert current word into minibuffer ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; http://stackoverflow.com/a/8257269/62023
(defun grass/minibuffer-insert-word-at-point ()
  "Get word at point in original buffer and insert it to minibuffer."
  (interactive)
  (let (word beg)
    (with-current-buffer (window-buffer (minibuffer-selected-window))
      (save-excursion
        (skip-syntax-backward "w_")
        (setq beg (point))
        (skip-syntax-forward "w_")
        (setq word (buffer-substring-no-properties beg (point)))))
    (when word
      (insert word))))

(defun grass/minibuffer-setup-hook ()
  (local-set-key (kbd "s-w") 'grass/minibuffer-insert-word-at-point))

(add-hook 'minibuffer-setup-hook 'grass/minibuffer-setup-hook)


;;;;;;;;;;;;;;;;;;;;;;
;; Markdown Preview ;;
;;;;;;;;;;;;;;;;;;;;;;

(defun grass/markdown-open-marked ()
  "run Marked.app on the current file and revert the buffer"
  (interactive)
  (shell-command
    (format "open -a 'Marked 2' %s"
      (shell-quote-argument (buffer-file-name)))))

(defun grass/today ()
  (format-time-string "%Y-%m-%d"))

(defun grass/insert-date ()
  (interactive)
  (insert (grass/today)))
