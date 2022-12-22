
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


(defvar sample (get-model-list))

(defvar model-list (mapcar 'cdr (mapcar (lambda (x) (assoc 'id (elt (cdr (assoc 'data sample)) x))) (get-integers (length (cdr (assoc 'data sample)))))))


(defun show-results (source)
    (ivy-read "Results: "
               source
               :action (lambda (x) (cdr (assoc x source)))
    )
  )


(show-results model-list)



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
