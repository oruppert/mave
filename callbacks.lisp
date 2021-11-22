(uiop:define-package :webapp/callbacks
  (:use :common-lisp
	:hunchentoot
	:cl-ppcre)
  (:export #:register
	   #:back))

(in-package :webapp/callbacks)

(defun register (function &rest args)
  (let ((map (or (session-value 'callbacks)
		 (setf (session-value 'callbacks)
		       (make-hash-table :synchronized t))))
	(key (logxor (get-universal-time)
		     (random #xffffffffffffffff))))
    (setf (gethash key map)
	  (lambda ()
	    (apply function args)))
    (format nil "/x?key=~a&back=~a"
	    key
	    (url-encode
	     (request-uri*)))))

(define-easy-handler (callback-handler :uri "/x")
    ((key :parameter-type 'integer))
  (let ((map (session-value 'callbacks)))
    (if (or (null map)
	    (null key)
	    (null (gethash key map)))
	(redirect "/")
	(funcall (gethash key map)))))

(defun back (&optional (uri (request-uri*)))
  (let ((params
	  (mapcar (lambda (s) (mapcar #'url-decode (split #\= s :limit 2)))
		  (split #\& (second (split #\? uri :limit 2))))))
    (or (second (assoc "back" params :test #'string=))
	"/")))
