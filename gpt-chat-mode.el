;;; gpt-chat-mode.el --- Just another emacs chatGPT app ---*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Ariel Serranoni
;;
;; Author: Ariel Serranoni <arielserranoni@gmail.com>
;; Maintainer: Ariel Serranoni <arielserranoni@gmail.com>
;; Created: December 29, 2022
;; Modified: December 29, 2022
;; Version: 0.0.1
;; Keywords: abbrev bib c calendar comm convenience data docs emulations extensions faces files frames games hardware help hypermedia i18n internal languages lisp local maint mail matching mouse multimedia news outlines processes terminals tex tools unix vc wp
;; Homepage: https://github.com/aserranoni/gpt-chat-mode
;; Package-Requires: ((emacs "24.3"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  This code is the result of me studying emacs lisp and wrapping the openAI API.
;;
;;; Code:

(require 'lui)
(require 'url)
(require 'json)


(define-derived-mode gpt-chat-mode lui-mode "AI-Chat"

  (setq lui-input-function #'interact-gpt-assistant)
  (setq lui-post-output-hook #'(lambda () (fill-region (point-min) (point-max))))
  (lui-set-prompt ">> "))


(defun get-string-from-file (file-name)
  (with-temp-buffer (insert-file file-name)
                    (substring (buffer-string) 0 -1)))


(defun get-integers (x)
  (let (result)
    (dotimes (i x)
      (setq result (cons i result)))
    (reverse result)))


(defvar openai-key-file "~/emacs-gpt/key")

(defvar openai-base-url "https://api.openai.com/v1")

(defvar openai-api-key (get-string-from-file openai-key-file))

(defvar gpt-bot-welcome-message "\nWelcome to the chat GPT bot assistant. Ask me anything!\n")

(defvar ask-gpt-default-buffer-name "*ASKGPT*")

(defvar default-headers
  (list (cons "Content-Type" "application/json")
        (cons "Authorization" (format "Bearer %s" openai-api-key))))

(defun format-api-url (endpoint)
  (format "%s/%s" openai-base-url endpoint))

(defun  format-sample-data (query role model)
  (let (
        (messages-field '(
                          ("role" . "dummy")
                          ("content" . "dummy")
                          ))
        (data '(
                ("model" . "dummy")
                ("messages" . "dummy")
                ("max_tokens" . 2000)
                ("temperature" . 0))))
    (setcdr (elt data 0) model)
    (setcdr (elt messages-field 1) query)
    (setcdr (elt messages-field 0) role)
    (setcdr (elt data 1) (list messages-field))
    data))

;(format-sample-data "Hey There" "user" "gpt-3.5-turbo")


(defun make-api-request (endpoint query role model)
  (let (
        (url (format-api-url endpoint))
        (url-request-method "POST")
        (url-request-extra-headers default-headers)
        (url-request-data (json-encode (format-sample-data query role model))))

    (with-current-buffer (url-retrieve-synchronously url)
      (goto-char (point-min))
      (re-search-forward "^$")
      (json-read))))

;(defvar sample-response (make-api-request "chat/completions" "Hey There" "user" "gpt-3.5-turbo"))
;(cdr (assoc 'content (cdr (car (elt (cdr (assoc 'choices sample-response)) 0)))))


(defun format-gpt-response (resp)
  (cdr (assoc 'content (cdr (car (elt (cdr (assoc 'choices resp)) 0)))))
  )

;(format-gpt-response sample-response)

(defun gpt-interact (x role)
  (let (
    (str (format-gpt-response (make-api-request "chat/completions" x role "gpt-3.5-turbo"))))
    (lui-insert str)
    (fill-region (point-min) (point-max))))


(defun interact-gpt-assistant (x)
  (gpt-interact x "assistant")
  )

(defun chat-get-buffer-create (name)
  (let (
        (buffer (get-buffer name)))
    (unless buffer
      (setq buffer (get-buffer-create name))
      (with-current-buffer buffer
        (gpt-chat-mode)
        (lui-insert gpt-bot-welcome-message)))
    buffer))

;;;###autoload
(defun start-chatting ()
  (interactive)
  (let (
        (buffer (chat-get-buffer-create ask-gpt-default-buffer-name)))
    (with-current-buffer buffer
      (goto-char (point-max)))
    (switch-to-buffer buffer)))



(provide 'gpt-chat-mode)
;;; gpt-chat-mode.el ends here
