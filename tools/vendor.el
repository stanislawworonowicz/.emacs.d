; for loading libraries in from the vendor directory
(defun vendor (library)
  (let* ((file (symbol-name library))
         (normal (concat user-emacs-directory "vendor/" file))
         (suffix (concat normal ".el"))
         (tools (concat user-emacs-directory "tools/" file)))
    (cond
      ((file-directory-p normal) (add-to-list 'load-path normal) (require library))
      ((file-directory-p suffix) (add-to-list 'load-path suffix) (require library))
      ((file-exists-p suffix) (require library)))
    (when (file-exists-p (concat tools ".el"))
      (load tools))))