;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CL-USER; Base: 10; Lowercase: Yes -*-

;; $Header: /repo/cvs.copy/clim2/sys/sysdcl-pc.lisp,v 1.3 1997/05/24 03:52:47 tomj Exp $

(in-package #-ANSI-90 :user #+ANSI-90 :cl-user)

"Copyright (c) 1990, 1991, 1992 Symbolics, Inc.  All rights reserved."

(eval-when (compile load eval)

;;; Tell the world that we're here
;;;--- These need to be in the CLIM.fasl also.
;;;--- Currently they're in EXCL-VERIFICATION but that does not seem the best place.
(pushnew :clim *features*)
(pushnew :clim-2 *features*)
(pushnew :clim-2.1 *features*)
(pushnew :silica *features*)

)	;eval-when

#+(or aclpc acl86win32)
(progn
  ; (pushnew :use-fixnum-coordinates *features*)
  ;;mm: to suppress many compiler warnings.
  (declaim (declaration values arglist))
  )


;;; CLIM is implemented using the "Gray Stream Proposal" (STREAM-DEFINITION-BY-USER)
;;; a proposal to X3J13 in March, 1989 by David Gray of Texas Instruments.  In that
;;; proposal, stream objects are built on certain CLOS classes, and stream functions
;;; (e.g., WRITE-CHAR) are non-generic interfaces to generic functions (e.g.,
;;; STREAM-WRITE-CHAR).  These "trampoline" functions are required because their
;;; STREAM argument is often optional, which means it cannot be used to dispatch to
;;; different methods.

;;; Various Lisp vendors have their own stream implementations, some of which are
;;; identical to the Gray proposal, some of which implement just the trampoline
;;; functions and not the classes, etc.  If the Lisp vendor has not implemented the
;;; classes, we will shadow those class names (and the predicate functions for them)
;;; in the CLIM-LISP package, and define the classes ourselves.  If the vendor has
;;; not implemented the trampoline functions, we will shadow their names, and write
;;; our own trampolines which will call our generic function, and then write default
;;; methods which will invoke the COMMON-LISP package equivalents.

(eval-when (compile load eval)

#+(or Allegro 
      Minima)
(pushnew :clim-uses-lisp-stream-classes *features*)

#+(or Allegro
      Genera				;Except for STREAM-ELEMENT-TYPE
      Minima
      Cloe-Runtime
      CCL-2)				;Except for CLOSE (and WITH-OPEN-STREAM)
(pushnew :clim-uses-lisp-stream-functions *features*)

;;; CLIM-ANSI-Conditions means this lisp truly supports the ANSI CL condition system
;;; CLIM-Conditions      means that it has a macro called DEFINE-CONDITION but that it works
;;;                      like Allegro 3.1.13 or Lucid.
(pushnew :CLIM-ANSI-Conditions *features*)

#+Allegro
(pushnew :allegro-v4.0-constructors *features*)

)	;eval-when


#+aclpc
(setq clim-defsys:*load-all-before-compile* t)

#+aclpc
(defun frob-pathname (subdir
		      &optional (dir #+Allegro excl::*source-pathname*
				     #+Lucid lcl::*source-pathname*
				     #+Cloe-Runtime #p"E:\\CLIM2\\SYS\\SYSDCL.LSP"
                                     ;;mm: 11Jan95 - remove explicit pathname
				     #-(or Allegro Lucid Cloe-Runtime)
				     (or *compile-file-pathname*
					 *load-pathname*)))
  (namestring
    (make-pathname
      :defaults dir
      :directory (append (butlast (pathname-directory dir)) (list subdir)))))


#+aclpc
(clim-defsys:defsystem clim-utils
    (:default-pathname #+Genera "SYS:CLIM;REL-2;UTILS;"
		       #-Genera (frob-pathname "utils")
     :default-binary-pathname #+Genera "SYS:CLIM;REL-2;UTILS;"
			      #-Genera (frob-pathname "utils"))
  ;; These files establish a uniform Lisp environment
  ("excl-verification" :features Allegro)
  ("lucid-before" :features lucid)
  ("lisp-package-fixups")
  ("defpackage" :features (or Allegro (not ANSI-90)))
  ("packages")
  ("coral-char-bits" :features CCL-2)
  ("defun-utilities") ;; extract-declarations and friends
  ("defun" :features (or Genera aclpc #||acl86win32||# (not ANSI-90)))
  ("reader")
  ("clos-patches")
  ("clos")
  ("condpat" :features CLIM-conditions)  ;get the define-condition macro

  ;; General Lisp extensions
  ("utilities")
  ("lisp-utilities")
  ("processes")
  ("queue")
  ("timers" :load-before-compile ("queue" "processes"))
  ("protocols")

  ;; Establish a uniform stream model
  ("clim-streams")
  ("cl-stream-classes" 
   ;; :short-name "clstclas"
   :features (not clim-uses-lisp-stream-classes))
  ("minima-stream-classes" :features Minima)
  ("cl-stream-functions"
   ;; :short-name "clstfunc"
   :features (and (not clim-uses-lisp-stream-functions) (not Lucid)))
  ("lucid-stream-functions" :features Lucid)
  ("genera-streams" :features Genera)
  ("excl-streams" :features Allegro)
  ("ccl-streams" :features CCL-2)

  ;; Basic utilities for Silica and CLIM
  ("clim-macros")
  ("transformations" :load-before-compile ("condpat"))
  ("regions")
  ("region-arithmetic")
  ("extended-regions")
  ("base-designs")
  ("designs"))

#+aclpc
(clim-defsys:defsystem clim-silica
    (:default-pathname #+Genera "SYS:CLIM;REL-2;SILICA;"
		       #-Genera (frob-pathname "silica")
     :default-binary-pathname #+Genera "SYS:CLIM;REL-2;SILICA;"
			      #-Genera (frob-pathname "silica")
     :needed-systems (clim-utils)
     :load-before-compile (clim-utils))
  ;; "Silica"
  ("macros")
  ("classes")
  ("text-style")
  ("sheet")
  ("mirror")
  ("event")
  ("port")
  ("medium")
  ("framem")
  ("graphics")
  ("pixmaps")
  ("std-sheet")

  ;; "Windshield", aka "DashBoard"
  ;; First the layout gadgets
  ("layout")
  ("db-layout")
  ("db-box")
  ("db-table")

  ;; Then the "physical" gadgets
  ("gadgets")
  ("db-border")
  ("db-scroll")
  ("scroll-pane")
  ("db-button")
  ("db-label"
   :load-before-compile ("db-border"))
  ("db-slider"))

#+aclpc
(clim-defsys:defsystem clim-standalone
    (:default-pathname #+Genera "SYS:CLIM;REL-2;CLIM;"
		       #-Genera (frob-pathname "clim")
     :default-binary-pathname #+Genera "SYS:CLIM;REL-2;CLIM;"
			      #-Genera (frob-pathname "clim")
     :needed-systems (clim-utils clim-silica)
     :load-before-compile (clim-utils clim-silica))

  ;; Basic tools
  ("gestures")
  ("defprotocol")
  ("stream-defprotocols") ; ( :short-name "stdefpro")
  ("defresource")
  ("temp-strings")
  ("coral-defs" :features CCL-2)
  ("clim-defs")
  
  ;; Definitions and protocols
  ("stream-class-defs") ; (:short-name "scdefs")
  ("interactive-defs") ; ( :short-name "idefs")
  ("cursor")
  ("view-defs")
  ("input-defs")
  ("input-protocol")
  ("output-protocol")

  ;; Output recording
  ("recording-defs" ;  :short-name "rdefs"
   :load-before-compile ("clim-defs"))
  ("formatted-output-defs")
  ("recording-protocol" ;  :short-name "rprotoco"
   :load-before-compile ("recording-defs"))
  ("text-recording"
   :load-before-compile ("recording-protocol"))
  ("graphics-recording"
   :load-before-compile ("recording-protocol"))
  ("design-recording"
   :load-before-compile ("graphics-recording"))

  ;; Input editing
  ("interactive-protocol" ;  :short-name "iprotoco"
   :load-before-compile ("clim-defs"))
  ("input-editor-commands")

  ;; Incremental redisplay
  ("incremental-redisplay"
   :load-before-compile ("clim-defs" "recording-protocol"))

  ;; Windows
  ("coordinate-sorted-set")
  ("r-tree")
  ("window-stream")
  ("pixmap-streams")

  ;; Presentation types
  ("ptypes1"
   :load-before-compile ("clim-defs"))
  ("completer"
   :load-before-compile ("ptypes1"))
  ("presentations"
   :load-before-compile ("ptypes1"))
  ("translators"
   :load-before-compile ("presentations"))
  ("histories"
   :load-before-compile ("presentations"))
  ("ptypes2"
   :load-before-compile ("translators"))
  ("standard-types"
   :load-before-compile ("ptypes2"))
  ("excl-presentations"
   :load-before-compile ("presentations")
   :features Allegro)

  ;; Formatted output
  ("table-formatting"
   :load-before-compile ("clim-defs" "incremental-redisplay"))
  ("graph-formatting"
   :load-before-compile ("clim-defs" "incremental-redisplay"))
  ("surround-output" 
   :load-before-compile ("clim-defs" "incremental-redisplay"))
  ("text-formatting"
   :load-before-compile ("clim-defs" "incremental-redisplay"))

  ;; Pointer tracking
  ("tracking-pointer")
  ("dragging-output"
   :load-before-compile ("tracking-pointer"))

  ;; Gadgets
  ("db-stream")
  ("gadget-output")

  ;; Application building substrate
  ("accept"
   :load-before-compile ("clim-defs" "ptypes2"))
  ("present"
   :load-before-compile ("clim-defs" "ptypes2"))
  ("command"
   :load-before-compile ("clim-defs" "ptypes2"))
  ("command-processor"
   :load-before-compile ("clim-defs" "command"))
  ("basic-translators"
   :load-before-compile ("ptypes2" "command"))
  ("frames" 
   :load-before-compile ("clim-defs" "command-processor"))
  ("panes" :load-before-compile ("frames"))
  ("default-frame" 
   :load-before-compile ("frames"))
  ("activities" 
   :load-before-compile ("frames"))
  ("db-menu"
   :load-before-compile ("frames"))
  ("db-list"
   :load-before-compile ("db-menu"))
  ("db-text"
   :load-before-compile ("frames"))
  ("noting-progress"
   :load-before-compile ("frames"))
  ("menus"
   :load-before-compile ("defresource" "clim-defs"))
  ("accept-values"
   :load-before-compile ("clim-defs" "incremental-redisplay" "frames"))
  ("drag-and-drop" 
   :load-before-compile ("frames"))
  ("item-list-manager")

  ;; Bootstrap everything
  ("stream-trampolines"  ; :short-name "strtramp"
   :load-before-compile ("defprotocol" "stream-defprotocols"))
  ("lucid-after" :features lucid)
  ("prefill" :features (or Genera Cloe-Runtime)))

