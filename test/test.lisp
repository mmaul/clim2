
;; 
;; copyright (c) 1985, 1986 Franz Inc, Alameda, Ca.  All rights reserved.
;; copyright (c) 1986-1991 Franz Inc, Berkeley, Ca.  All rights reserved.
;;
;; The software, data and information contained herein are proprietary
;; to, and comprise valuable trade secrets of, Franz, Inc.  They are
;; given in confidence by Franz, Inc. pursuant to a written license
;; agreement, and may be stored and used only in accordance with the terms
;; of such license.
;;
;; Restricted Rights Legend
;; ------------------------
;; Use, duplication, and disclosure of the software, data and information
;; contained herein by any agency, department or entity of the U.S.
;; Government are subject to restrictions of Restricted Rights for
;; Commercial Software developed at private expense as specified in FAR
;; 52.227-19 or DOD FAR Suppplement 252.227-7013 (c) (1) (ii), as
;; applicable.
;;
(in-package :clim)

(define-application-frame test-frame ()
  (a b c)
  (:pane 
   (vertically ()
	       (silica::scrolling
		()
		(setq aaa
		  (silica::realize-pane
		   'interactor-pane
		   :foreground +green+
		   :background +red+)))
	       (realize-pane
		'silica::push-button
		:label "press me"
		:background (make-pattern #2A((0 0 0 1 1 0 0 0)
					      (0 0 1 1 1 1 0 0)
					      (0 1 1 1 1 1 1 0)
					      (1 1 1 1 1 1 1 1)
					      (1 1 1 1 1 1 1 1)
					      (0 1 1 1 1 1 1 0)
					      (0 0 1 1 1 1 0 0)
					      (0 0 0 1 1 0 0 0))
					  (list +red+ +green+))
		:foreground +purple+
		:text-style

		(make-text-style
		 :serif :roman 20)))))


(define-application-frame test-frame0 ()
  (a b c)
  (:command-table test-frame)
  (:pane 
   (silica::scrolling
    ()
    (silica::realize-pane
     'interactor-pane))))

(define-application-frame test-frame2 ()
  (a b c)
  (:command-table test-frame)
  (:pane 
   (vertically ()
	       (silica::tabling ()
				(
				 (silica::horizontally
				  ()
				  (realize-pane 'silica::toggle-button)
				  (realize-pane 'silica::toggle-button)
				  (realize-pane 'silica::toggle-button))
		     
				 (realize-pane 'silica::text-field))
				(
				 (realize-pane 'silica::push-button :label "hello")
				 (realize-pane 'slider)))
	       (silica::scrolling
		()
		(silica::realize-pane
		   'interactor-pane
		   :display-function 'moby-display-function))
	       (silica::scrolling
		()
		(setq aaa
		  (silica::realize-pane
		   'interactor-pane
		   :width 100))))))

(defun moby-display-function (frame stream)
  (window-clear stream)
  (display-command-table-menu 
   (frame-command-table frame)
   stream
   :max-width (bounding-rectangle-width stream)))

(define-application-frame test-frame3 ()
  (a b c)
  (:command-table test-frame)
  (:pane 
   (silica::scrolling
		      ()
		      (setq aaa
			(silica::realize-pane
			 'interactor-pane
			 :width 300
			 :height 300)))))



(define-test-frame-command (com-square-it :name t :menu t)
			   ((x 'integer))
			   (present (* x x) 'integer :stream
				    *query-io*))


(define-test-frame-command (com-double-it :name t :menu t)
			   ((x 'integer))
			   (present (+ x x) 'integer :stream
				    *query-io*))


(define-test-frame-command (com-clear :name t :menu t)
			   ()
			   (window-clear *query-io*))

(define-test-frame-command (com-quit :name t :menu t)
			   ()
  (frame-exit *application-frame*))

(define-test-frame-command (com-make-table :name t :menu t)
    ()
  (formatting-table (*query-io*)
		    (dotimes (i 10)
		      (formatting-row (*query-io*)
				      (dotimes (j 10)
					(formatting-cell (*query-io*)
							 (present (* i j) 'integer :stream *query-io*)))))))
	
					    


(define-test-frame-command (com-show :name t :menu t)
			   ()
			   (terpri *query-io*)
			   (display-command-table-menu 
			    (frame-command-table *application-frame*)
			    *query-io*
			    :move-cursor t)
			   (terpri *query-io*))

(define-presentation-to-command-translator square-int (integer
						       com-square-it test-frame)
					   
					   (object)
					   (list object))


(define-presentation-to-command-translator double-int (integer
						       com-double-it test-frame)
					   
					   (object)
					   (list object))


(define-application-frame test-frame4 ()
  (a b c)
  (:command-table test-frame)
  (:pane 
   (vertically ()
	       (realize-pane 'silica::push-button :label "Press me")
	       (realize-pane 'silica::toggle-button)
	       (realize-pane 'silica::slider)
	       (realize-pane 'silica::text-field)
	       (silica::scrolling
		()
		(silica::realize-pane
		 'interactor-pane
		 :width 300
		 :max-width +fill+
		 :height 300
		 :max-height +fill+)))))


(define-application-frame test-frame5 ()
  ()
  (:command-table test-frame)
  (:panes
   (a (silica::horizontally
	 ()
	 (realize-pane 'silica::push-button :label "Press me")
	 (realize-pane 'silica::push-button :label "Squeeze me")))
   (b (realize-pane 'silica::toggle-button))
   (c (realize-pane 'silica::slider))
   (d (realize-pane 'silica::text-field))
   (e (silica::realize-pane
       'interactor-pane
       :width 300
       :max-width +fill+
       :height 300
       :max-height +fill+)))
  (:layout
   (:default 
       (vertically
	()
	a b c (silica::scrolling () e)))
   (:more
    (vertically
     ()
     a  (silica::scrolling () e) b  d))))



(define-test-frame-command (com-switch :name t :menu t)
    ()
  (setf (frame-current-layout *application-frame*)
    (ecase (frame-current-layout *application-frame*)
      (:default :more)
      (:more :default))))

(define-test-frame-command (com-accept :name t :menu t)
    ()
  (let ((stream *query-io*)
	(a t)
	(b nil)
	(c :normal)
	(d 10))
    (accepting-values 
     (stream)
     (setq a (accept 'boolean  
		     :stream stream
		     :default a
		     :prompt "a"))
     (terpri stream)
     (unless a
       (setq b (accept 'boolean  
		       :stream stream
		       :default b
		       :prompt "b"))
       (terpri stream))
     (when a
       (setq c
	 (accept '(member :normal :point) :stream stream
		 :prompt "Line style units" :default c))
       (terpri stream))
     (setq d (accept '(integer 0 100) 
		     :stream stream
		     :prompt "length"
		     :default d))
     (terpri stream)
     (accept-values-command-button (stream)
				   "Press me"
				   (setq a t b nil c :normal)))))


	 

(define-presentation-type some-kinda-gadget ())

(define-presentation-method present (object (type some-kinda-gadget) stream (view t)
					    &key acceptably)
  ;; Kludge!
  (write-string "gadget" stream))

(define-test-frame-command (com-make-one :name t :menu t)
    ()
  (let* ((stream *query-io*))
    
    (let ((weird (cons nil nil)))
      (setf (car weird)
	(with-output-as-presentation (:object weird :type 'some-kinda-gadget :stream stream)
	  (surrounding-output-with-border (stream)
					  (with-output-as-gadget (:stream stream)
					    (realize-pane 
					     'silica::slider))))))
    (let ((weird (cons nil nil)))
      (setf (car weird)
	(with-output-as-presentation (:object weird :type 'some-kinda-gadget :stream stream)
	  (surrounding-output-with-border (stream)
					  (with-output-as-gadget (:stream stream)
					    (realize-pane 
					     'silica::push-button
					     :label "Amazing"))))))))

(define-presentation-to-command-translator
    move-gadget-translator
    (some-kinda-gadget com-move-gadget test-frame)
  (object)
  (list object))

(define-test-frame-command (com-move-gadget :name t :menu t)
    ((weird 'some-kinda-gadget))
  (dragging-output-record 
   *query-io*
   (car weird)
   :repaint nil
   :erase #'(lambda (c s)
	      (with-bounding-rectangle*
		  (f g h j) c
		  (draw-rectangle*
		   s
		   (1- f) (1- g)
		   (1+ h) (1+ j)
		   :ink +background+)))))
    
(define-test-frame-command (com-track :name t :menu t)
    ()
  (let* ((stream *query-io*))
    (tracking-pointer-test stream)))


(define-test-frame-command (com-make-button :name t :menu t)
    ()
  (let* ((stream *query-io*))
    (flet ((make-it (i)
	     (with-output-as-gadget (:stream stream)
	       (realize-pane 
		'silica::push-button
		:label (format nil "Amazing ~D" i)))))
      (format-graph-from-root
       '(a (c (x) (y)))
       #'(lambda (node s)
	   (declare (ignore s))
	   (make-it (if (consp node) (car node) node)))
       #'cdr
       :stream stream))))


#+ignore
(formatting-table (stream)
		  (dotimes (i 3)
		    (formatting-row (stream)
				    (dotimes (j 3)
				      (formatting-cell (stream)
						       (make-it (+ (* i 3) j)))))))






(define-test-frame-command (com-make-radio-box :name t :menu t)
    ()
  (let* ((stream *query-io*))
    (with-output-as-gadget (:stream stream)
      (let* ((frame-pane
	     (realize-pane 'silica::frame-pane))
	    (gadget
	     (realize-pane 'silica::radio-box :parent frame-pane)))
	(realize-pane 'toggle-button :label "a" :parent gadget)
	(realize-pane 'toggle-button :label "b" :parent gadget)
	(realize-pane 'toggle-button :label "c" :parent gadget)
	frame-pane))))
