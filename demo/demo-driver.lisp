;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CLIM-DEMO; Base: 10; Lowercase: Yes -*-

;; $fiHeader: aaai-demo-driver.lisp,v 1.7 92/06/02 13:31:04 cer Exp Locker: cer $

(in-package :clim-demo)

"Copyright (c) 1990, 1991 Symbolics, Inc.  All rights reserved."

(defvar *demos* nil)

(defmacro define-demo (name start-form)
  `(clim-utils:push-unique (cons ,name #'(lambda () ,start-form)) *demos*
			   :test #'string-equal :key #'car))

(define-demo "Exit" (exit-demo))

(defun exit-demo () (throw 'exit-demo nil))

(define-presentation-type demo-menu-item ())

#-silica
(defun size-demo-frame (root desired-left desired-top desired-width desired-height)
  (declare (values left top right bottom))
  (multiple-value-bind (left top right bottom)
      (window-inside-edges root)
    (let ((desired-right (+ desired-left desired-width))
	  (desired-bottom (+ desired-top desired-height)))
      (when (> desired-right right)
	(setf desired-right right
	      desired-left (max left (- desired-right desired-width))))
      (when (> desired-bottom bottom)
	(setf desired-bottom bottom
	      desired-top (max top (- desired-bottom desired-height))))
      (values desired-left desired-top desired-right desired-bottom))))

#+silica
(defun size-demo-frame (root desired-left desired-top desired-width desired-height)
  (values desired-left desired-top  
	  (+ desired-left desired-width) (+ desired-top desired-height)))

(defvar *demo-root* nil)

(defun start-demo (&optional (root *demo-root*))
  (setq *demo-root* (or root (setq root (find-graft))))
  ;;--- Make a dummy frame for the time being
  (let ((*application-frame* (make-application-frame 'standard-application-frame)))
    (labels ((demo-menu-drawer (stream type &rest args)
	       (declare (dynamic-extent args))
	       (with-text-style (stream '(:serif :roman :very-large))
		 (apply #'draw-standard-menu stream type args)))
	     (demo-menu-choose (list associated-window)
	       (with-menu (menu associated-window)
		 (setf (window-label menu)
		   '("Clim Demonstrations" :text-style (:fix :bold :normal)))
		 (menu-choose-from-drawer
		  menu 'demo-menu-item
		  #'(lambda (stream type)
		      (demo-menu-drawer stream type list nil))
		  :cache nil
		  :unique-id 'demo-menu :id-test #'eql
		  :cache-value *demos* :cache-test #'equal))))
      (catch 'exit-demo
	(loop
	  (let* ((demo-name (demo-menu-choose (nreverse (map 'list #'car *demos*)) root))
		 (demo-fcn (cdr (assoc demo-name *demos* :test #'string-equal))))
	    (when demo-fcn
	      (funcall demo-fcn))))))))

(defparameter *color-stream-p* t)
(defun color-stream-p (stream)
  #-genera *color-stream-p*		;--- kludge
  #+genera (if (and stream
		    (eql (port-type (port stream)) ':genera))
	       (slot-value stream 'clim-internals::color-p)
	       *color-stream-p*))
