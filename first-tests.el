
(require 'url)
(require 'json)
(require 'ivy)


(defun get-string-from-file (file-name)
  (with-temp-buffer (insert-file file-name)
   (buffer-string)
   )
  )


(defun get-integers (x)
  (let (result)
    (dotimes (i x)
      (setq result (cons i result)))
    (reverse result)
    )
  )


<<<<<<< HEAD

(defvar openai-key-file "./key")

(defvar openai-base-url "https://api.openai.com/v1")

(defvar openai-api-key (get-string-from-file openai-key-file))


(defun default-headers (&optional data)
  (or data (setq data (cons "User-Agent" "Emacs Client")))
  (list (cons "Content-Type" "application/json")
        (cons "Authorization" (format "Bearer %s" openai-api-key))
        data)
)

(default-headers)
=======
>>>>>>> 5c81d22... other file changes...




(defun format-api-url (endpoint)
  (format "%s/%s" openai-base-url endpoint))


(format-api-url "models")



;(switch-to-buffer (url-retrieve (format-api-url "models") 'restclient-http-handle-response))

(defun request-api-endpoint (endpoint model query)
  (let (
        (url (format-api-url endpoint))
        (data (json-encode '(
                             ("prompt" . "What is the meaning of life?")
                             ("model" . "text-davinci-003")
                             ("max_tokens" . 100)
                             ("temperature" . 0.0)
                             )
                )
         )
        )
    (message url)
    (message data)
    (with-current-buffer (url-retrieve-synchronously url (default-headers) data)
      (goto-char (point-min))
      (re-search-forward "^$")
      (json-read-object)
      )
    )
  )

(request-api-endpoint "completions" "text-davinci-003" "What is the meaning of life?")

(defun get-model-list ()
  (let (
        (url (format-api-url "models"))
        )
    (with-current-buffer (url-retrieve-synchronously url
                                                     (list (cons "Content-Type" "application/json")
                                                           (cons "Authorization" (format "Bearer %s" openai-api-key)))
                         )
     (goto-char (point-min))
     (re-search-forward "^$")
     (json-read)
     )
    )
  )

<<<<<<< HEAD
=======
(defun format-model-list (list)
  (mapcar 'cdr
          (mapcar
            (lambda (x) (assoc 'id (elt (cdr (assoc 'data sample)) x)))
            (get-integers (length (cdr (assoc 'data sample))))

          )
   )
  )

(define-derived-mode chat-mode lui-mode "AI-Chat"
(lui-set-prompt ">> ")

(defvar openai-key-file "./key")

(defvar openai-base-url "https://api.openai.com/v1")

(defvar openai-api-key (get-string-from-file "./key"))

(defvar gpt-bot-welcome-message "\nWelcome to the chat GPT bot. Ask me anything!\n")

(defvar ask-gpt-default-buffer-name "*ASKGPT")


(defun format-davinci-response (resp)
(let* (
       (choices (cdr (assoc 'choices resp)))
       (n-choices (length choices))
       (ret (mapcar
        (lambda (x) (cdr (assoc 'text (elt choices x))))
        (get-integers n-choices)))
      )
  (car ret)
  )
)

(defun davinci-interact (x)
  (lui-insert x)
  (let (
(str (format-davinci-response (make-api-request "completions" x "text-davinci-003")))
        )
    (lui-insert str)))
(setq lui-input-function #'davinci-interact)
(defun chat-get-buffer-create (name)
  (let (
        (buffer (get-buffer name))
        )
    (unless buffer
      (setq buffer (get-buffer-create name))
      (with-current-buffer buffer
        (some-chat-mode)
        ))
    buffer
    ))
(defun start-chattingg (contact)
  (let (
        (buffer (chat-get-buffer-create (format "*Chat-%s*" contact)))
       )
  (with-current-buffer buffer
    (lui-insert "Welcome to my chat emacs module")
    (goto-char (point-max))))
  )
)
(chat-mode)
(start-chattingg "Clarissa")


;; (interactive)
;; (let* (
;;        (buffer (get-buffer-create "*Chat*"))
;;        )
;;   (with-current-buffer buffer
;;     (lui-insert "hello!! What do you want to ask?" t)
;;     )

;;   (lui-set-prompt "> ")
;;   (pop-to-buffer buffer)
;;   ))
;; )
;; (provide 'ai-chat-mode)

>>>>>>> 5c81d22... other file changes...

(defvar sample (get-model-list))

(defvar model-list (mapcar 'cdr (mapcar (lambda (x) (assoc 'id (elt (cdr (assoc 'data sample)) x))) (get-integers (length (cdr (assoc 'data sample)))))))


(defun show-results (source)
    (ivy-read "Results: "
               source
               :action (lambda (x) (cdr (assoc x source)))
    )
  )


(show-results model-list)
<<<<<<< HEAD



(defun get-models-list ()
  (request-api-endpoint "models"))

(get-models-list)

(setq request-log-level '-1)
;; make a simple  request

(request "http://127.0.0.1:5062/api/Spaces/GetAllSpaces/GetAllSpaces"
         :headers '(("accept" . "text/plain"))
         :sync t)

;; TODO: Also test with (url-retrieve)
(defvar first-tests-my-buffer (url-retrieve-synchronously "https://api.coingecko.com/api/v3/coins/list?include-platform=false"))

(type-of first-tests-my-buffer)

(switch-to-buffer first-tests-my-buffer)


(defun format-literal-string (string)
  ;(concat \"\\\"\" string \"\\\"\")
   (replace-regexp-in-string "\"\\\\\\\\\"   "\"\"\"    string))


(defvar string "\n\n(defun format-literal-string (string)\n  \"Format a literal string by adding double quotes around it.\"\n  (concat \"\\\"\" string \"\\\"\"))")

(defvar qualquer "ariel e \n \"clarissa\".")

(format-literal-string qualquer)

(defun find-candidates-function (str pred _)
  (let ((props '(1 2))
        (strs '("foo" "foo2")))
    (cl-mapcar (lambda (s p) (propertize s 'property p))
               strs
               props)))

(defun find-candidates ()
  (interactive)
  (ivy-read "Find symbols: "
            #'find-candidates-function
            :action (lambda (x)
                      (message "Value: %s" (get-text-property 0 'property x)
                       ))))
=======
(show-results nada)
> 
>> 
>> 
>>>>>>> 5c81d22... other file changes...
