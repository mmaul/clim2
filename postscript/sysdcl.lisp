;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Package: CL-USER; Base: 10; Lowercase: Yes -*-

;; $Header: /repo/cvs.copy/clim2/postscript/sysdcl.lisp,v 1.12 1997/05/24 03:52:43 tomj Exp $

(in-package #-ANSI-90 :user #+ANSI-90 :cl-user)

"Copyright (c) 1990, 1991, 1992 Symbolics, Inc.  All rights reserved."

(defsystem postscript-clim
    (:default-pathname "clim2:;postscript;")
  (:serial
   clim-standalone
   ("pkgdcl")
   #+(and Allegro (not acl86win32)) ("postscript-s") ;; why not?
   ("postscript-port")
   ("postscript-medium")
   ("read-afm")
   ("laserwriter-metrics")))

#+Genera
(clim-defsys:import-into-sct 'postscript-clim
  :pretty-name "PostScript CLIM"
  :default-pathname "SYS:CLIM;REL-2;POSTSCRIPT;"
  :required-systems '(clim)
  :bug-reports "Bug-CLIM"
  :patches-reviewed "Bug-CLIM-Doc")
