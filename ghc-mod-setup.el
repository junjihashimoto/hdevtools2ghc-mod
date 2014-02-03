(ffap-bindings)
(add-to-list 'load-path "~/.cabal/share/x86_64-linux-ghc-7.6.3/ghc-mod-3.1.4")
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook 
	  (lambda ()
	    (ghc-init) 
	    (flymake-mode)
	    (local-set-key "\C-c\C-c" 'comment-region)
	    (local-set-key "\C-c\C-g" 'ghc-goto-def)
	    (local-set-key "\C-c\C-b" 'ghc-show-browse)
	    (local-set-key "\C-c\C-l" 'ghc-show-list)
	    )
	  )
(global-set-key "\C-c\C-c" 'comment-region)
(global-set-key "\C-x\C-g" 'goto-line)

(defun ghc-goto-def (&optional ask)
  (interactive "P")
  (let* ((expr0 (ghc-things-at-point))
	  (expr (if (or ask (not expr0)) (ghc-read-expression expr0) expr0))
	   (info (ghc-get-info expr)))
    (if (string-match "Defined at \\([^:]*\\):\\([0-9]+\\):\\([0-9]+\\)" info)
	(let ((path (match-string 1 info))
	            (line (string-to-number (match-string 2 info)))
		          (pos  (string-to-number (match-string 3 info)))
			        )
	    (find-file-at-point path)
	      (goto-line line)
	        (move-to-column (- pos 1) t)
		  )
      )
    ))

(require 'thingatpt)
(defun ghc-read-module-name-at-point ()
	(interactive)
	(if (thing-at-point-looking-at "[A-Za-z.]+")
			(let ((beginning (match-beginning 0))
						(end (match-end 0)))
				(buffer-substring beginning end)
			)
		)
	)

(defun ghc-show-browse (module)
;  (interactive "sModule: ")
  (interactive (list
                (read-string (format "Module (%s): " (ghc-read-module-name-at-point))
                             nil nil (ghc-read-module-name-at-point))))
  (let* ((info (ghc-get-browse module)))
    (when info
      (ghc-display
       nil
       (lambda () (insert info))))))

(defun ghc-get-browse (expr)
  (let ((cmds (list "browse" "-d" "-o" expr)))
    (ghc-run-ghc-mod cmds)
		)
	)

(defun ghc-show-list ()
  (interactive)
  (let* ((info (ghc-get-list)))
    (when info
      (ghc-display
       nil
       (lambda () (insert info))))))

(defun ghc-get-list ()
  (let ((cmds (list "list")))
    (ghc-run-ghc-mod cmds)
		)
	)



(setq ghc-module-command "~/bin/ghc-mod.sh")


