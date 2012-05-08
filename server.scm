(use srfi-18 posix tcp6 json)

(define (server)
  (define l (tcp-listen 8001))

  (set-signal-handler! signal/int
                       (lambda (sig)
                         (print "Closing socket")
                         (tcp-close l)
                         (exit)))

  (define (send-json-line out port)
    (with-output-to-port port (lambda () (json-write out) (newline))))

  (let accept ()
    (let-values (((in out) (tcp-accept l)))
      (print "client connected")
      (let ((data (read-line in)))
        (print (format "client sent: ~A" data))
        (send-json-line (vector '(msgType . gameStarted) '(data . "ökytunkkaaja")) out)))
    (accept)))

(server)

