(use srfi-1 json tcp6)

(define-values (in out) (tcp-connect "localhost" 8001))

(define (send-json-line o port)
  (with-output-to-port port (lambda () (json-write o) (newline))))

(define (read-message s)
  (define (parse-message ht)
    (cons (hash-table-ref ht "msgType")
          (hash-table-ref ht "data")))

  (parse-message
    (alist->hash-table
      (vector->list
        (with-input-from-string s (lambda () (json-read)))))))

(define (read-json-message json-msg)
  (let ((msg (read-message json-msg)))
    (print (format "got message: ~A with data: ~A" (car msg) (cdr msg)))
    msg))

(define (receive-message data) 'pass)

(let loop ()
  (send-json-line (vector '(key . value) '(key2 . value2)) out)
  (receive-message (read-json-message (read-line in)))
  (loop))

