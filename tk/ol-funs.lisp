;; copyright (c) 1985,1986 Franz Inc, Alameda, Ca.
;; copyright (c) 1986-2005 Franz Inc, Berkeley, CA  - All rights reserved.
;; copyright (c) 2002-2007 Franz Inc, Oakland, CA - All rights reserved.
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
;; Commercial Software developed at private expense as specified in
;; DOD FAR Supplement 52.227-7013 (c) (1) (ii), as applicable.
;;
;; $Id: ol-funs.lisp,v 2.7 2007/04/17 21:45:53 layer Exp $

;;
;; This file contains compile time only code -- put in clim-debug.fasl.
;;

(in-package :tk)

(defforeign 'ol_toolkit_initialize
    :entry-point (ff:convert-foreign-name "OlToolkitInitialize")
    :call-direct t
    :arguments nil
    :arg-checking nil
    :return-type :void)

(defforeign 'ol_set_warning_handler
    :entry-point (ff:convert-foreign-name "OlSetWarningHandler")
    :call-direct t
    :arguments '(integer)
    :arg-checking nil
    :return-type :unsigned-integer)

(defforeign 'ol_set_error_handler
    :entry-point (ff:convert-foreign-name "OlSetErrorHandler")
    :call-direct t
    :arguments '(integer)
    :arg-checking nil
    :return-type :unsigned-integer)

(defforeign 'ol_set_va_display_error_msg_handler
    :entry-point (ff:convert-foreign-name "OlSetVaDisplayErrorMsgHandler")
    :call-direct t
    :arguments '(integer)
    :arg-checking nil
    :return-type :unsigned-integer)

(defforeign 'ol_set_va_display_warning_msg_handler
    :entry-point (ff:convert-foreign-name "OlSetVaDisplayWarningMsgHandler")
    :call-direct t
    :arguments '(integer)
    :arg-checking nil
    :return-type :unsigned-integer)

(defforeign 'ol_add_callback
    :entry-point (ff:convert-foreign-name "OlAddCallback")
    :call-direct t
    :arguments '(foreign-address foreign-address foreign-address foreign-address)
    :arg-checking nil
    :return-type :void)

(defforeign 'ol_call_accept_focus
    :entry-point (ff:convert-foreign-name "OlCallAcceptFocus")
    :call-direct t
    :arguments '(foreign-address integer)
    :arg-checking nil
    :return-type :unsigned-integer)

(defforeign 'ol_can_accept_focus
    :entry-point (ff:convert-foreign-name "OlCanAcceptFocus")
    :call-direct t
    :arguments '(foreign-address integer)
    :arg-checking nil
    :return-type :unsigned-integer)

(defforeign 'ol_set_input_focus
    :entry-point (ff:convert-foreign-name "OlSetInputFocus")
    :call-direct t
    :arguments '(foreign-address fixnum integer)
    :arg-checking nil
    :return-type :void)

(defforeign 'ol_move_focus
    :entry-point (ff:convert-foreign-name "OlMoveFocus")
    :call-direct t
    :arguments '(foreign-address fixnum integer)
    :arg-checking nil
    :return-type :void)

(defforeign 'ol_get_current_focus_widget
    :entry-point (ff:convert-foreign-name "OlGetCurrentFocusWidget")
    :call-direct t
    :arguments '(foreign-address)
    :arg-checking nil
    :return-type :unsigned-integer)

(defforeign 'ol_menu_post
    :entry-point (ff:convert-foreign-name "OlMenuPost")
    :call-direct t
    :arguments '(foreign-address)
    :arg-checking nil
    :return-type :void)

(defforeign 'ol_menu_popdown
    :entry-point (ff:convert-foreign-name "OlMenuPopdown")
    :call-direct t
    :arguments '(foreign-address fixnum)
    :arg-checking nil
    :return-type :void)

(defforeign 'ol_text_edit_clear_buffer
    :entry-point (ff:convert-foreign-name "OlTextEditClearBuffer")
    :call-direct t
    :arguments '(foreign-address)
    :arg-checking nil
    :return-type :fixnum)

(defforeign 'ol_text_edit_read_substring
    :entry-point (ff:convert-foreign-name "OlTextEditReadSubString")
    :call-direct t
    :arguments '(foreign-address foreign-address fixnum fixnum)
    :arg-checking nil
    :return-type :fixnum)

(defforeign 'ol_text_edit_insert
    :entry-point (ff:convert-foreign-name "OlTextEditInsert")
    :call-direct t
    :arguments '(foreign-address foreign-address fixnum)
    :arg-checking nil
    :return-type :fixnum)

(defforeign 'ol_text_edit_get_last_position
    :entry-point (ff:convert-foreign-name "OlTextEditGetLastPosition")
    :call-direct t
    :arguments '(foreign-address foreign-address)
    :arg-checking nil
    :return-type :fixnum)

(defforeign 'ol_register_help
    :entry-point (ff:convert-foreign-name "OlRegisterHelp")
    :call-direct t
    :arguments '(fixnum foreign-address foreign-address fixnum foreign-address)
    :arg-checking nil
    :return-type :void)

(defforeign 'ol_appl_add_item
    :entry-point (ff:convert-foreign-name "ol_appl_add_item")
    :call-direct t
    :arguments '(integer foreign-address foreign-address foreign-address
		 foreign-address)
    :arg-checking nil
    :return-type :unsigned-integer)

(defforeign 'ol_appl_delete_item
    :entry-point (ff:convert-foreign-name "ol_appl_delete_item")
    :call-direct t
    :arguments '(integer foreign-address integer)
    :arg-checking nil
    :return-type :unsigned-integer)


(defforeign 'ol_list_item_pointer
    :entry-point (ff:convert-foreign-name "ol_list_item_pointer")
    :call-direct t
    :arguments '(integer)
    :arg-checking nil
    :return-type :unsigned-integer)

(defforeign 'ol_appl_touch_item
    :entry-point (ff:convert-foreign-name "ol_appl_touch_item")
    :call-direct t
    :arguments '(integer foreign-address integer)
    :arg-checking nil
    :return-type :void)

(provide :clim-debugol)
