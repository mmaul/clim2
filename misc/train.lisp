;; -*- mode: common-lisp; package: user -*-
;;
;;				-[]-
;; 
;; copyright (c) 1985, 1986 Franz Inc, Alameda, CA  All rights reserved.
;; copyright (c) 1986-1992 Franz Inc, Berkeley, CA  All rights reserved.
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
;; 52.227-19 or DOD FAR Supplement 252.227-7013 (c) (1) (ii), as
;; applicable.
;;
;; $fiHeader: train.lisp,v 1.5 93/04/02 13:36:34 cer Exp $

(defun train-clim (&key (train-times 2) 
			(psview nil)
			(frame-tests t)
			(errorp t)
			(hpglview nil)
			(compile t))
  (setq *global-gc-behavior* nil)
  (load "test/test.lisp")
  (clim-user::with-test-reporting (:file (if (excl::featurep :clim-motif) 
					     "test-suite-reportxm.lisp"
					   "test-suite-reportol.lisp"))
    (when compile
      (load (compile-file "test/test-suite")))
    (when frame-tests
      (clim-user::train-clim-2 train-times) 
      (clim-user::do-frame-tests errorp))
    (when psview
      (load "test/postscript-tests.lisp")
      (clim-user::run-postscript-tests :output psview))
  
    (when hpglview
      (load "test/postscript-tests.lisp")
      (require :climhpgl)
      (load "test/hpgl-tests.lisp")
      (clim-user::run-hpgl-tests :output hpglview)))
  
  (with-open-file (*standard-output* "coverage-report.lisp" 
		   :if-exists :supersede :direction :output)
    (generate-coverage-report))
  (compile-file "misc/clos-preload.cl" 
		:output-file 
		(if (excl::featurep :clim-motif) 
		    "misc/clos-preloadxm.fasl" 
		  "misc/clos-preloadol.fasl")))



