(require 'dash)
(setq fb/buffer-fragments
      '((1 1 "project.org")
        (3 3 "project.org")
        (2 2 "project.org")
        (4 4 "project.org")
        (1 7 "magit: frankenbuffer")))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utils
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmacro with-font-face (face &rest body)
  `(let ((start (point)))
     ,@body
     (put-text-property start (point) 'face ,face)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fb/goto-line (n)
  (goto-char (point-min))
  (forward-line (1- n)))
(defun fb/line-n-beginning-position (n)
  (save-excursion
    (fb/goto-line n)
    (line-beginning-position)))
(defun fb/line-n-end-position (n)
  (save-excursion
    (fb/goto-line n)
    (line-end-position)))

(defun fb/get-string-from-lines (x y)
  (let* ((begin (fb/line-n-beginning-position x))
         (end   (fb/line-n-end-position y))
         (region (buffer-substring begin end)))
    region))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Region
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fb/get-region-lines ()
  "Takes region and gives you the first line number its on and last;
  If you highlight text from the first 3 lines, you'd get (1 3)"
  (interactive)
  (let* ((begin (region-beginning))
         (end   (region-end)))
    
    (list (line-number-at-pos begin)
          (line-number-at-pos end))))
(defun fb/get-region-lines-string ()
  "Gets lines your region is on and gets ALL text from those lines"
  (interactive)
  (let* ((lines (fb/get-region-lines))
         (region (fb/get-string-from-lines (car lines) (cadr lines))))
    region))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun fb/add-buffer-frag-to-fbuffer (start end buffer)
  (interactive)
  (append fb/buffer-fragments (list (list start end buffer)))
  )
(defun fb/insert-buffer-frag (buffer-frag)
  (interactive)
  (with-current-buffer (get-buffer-create "*frankenbuffer*")
    (let* ((buffer-name (caddr buffer-frag))
           (begin (car buffer-frag))
           (end   (cadr buffer-frag))
           (text (with-current-buffer buffer-name
                   (fb/get-string-from-lines begin end))))
      (insert text))))
(defun fb/refresh-fbuffer ()
  (with-current-buffer "*frankenbuffer*"
    (erase-buffer)
    (cl-loop for frag in fb/buffer-fragments
             do (progn
                  (with-font-face
                   font-lock-comment-delimiter-face
                   (insert-char ?\- (window-text-width)))
                  (insert "\n")
                  (fb/insert-buffer-frag frag)
                  (insert "\n")))))



;;font-lock-comment-delimiter-face
