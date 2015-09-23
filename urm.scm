
;; This is my second attempt at a URM machine in Scheme

;; Like the old one, this is also licensed GPLv3

(import (scheme base)
        (scheme char)
        (scheme file)
        (scheme read)
        (scheme write)
        (scheme process-context))

(define (start-urm p)

  (define (inc n)
    (lambda ()
      (vector-set! registers
                   n
                   (+ (vector-ref registers n) 1))
      1))

  (define (clr n)
    (lambda ()
      (vector-set! registers n 0)
      1))

  (define (cpy m n)
    (lambda ()
      (vector-set! registers
                   n
                   (vector-ref registers m))
      1))

  (define (jmp m n offset)
    (lambda ()
      (if (= (vector-ref registers m)
             (vector-ref registers n))
          offset
          1)))

  (define (prn n)
    (lambda ()
      (display (vector-ref registers n))
      (newline)
      1))

  (define (prc n)
    (lambda ()
      (write-char (integer->char (vector-ref registers n)))
      1))

  (define (rdn n)
    (lambda ()
      (vector-set! registers
                   n
                   (read-integer (current-input-port)))
      1))

  (define (rdc n)
    (lambda ()
      (vector-set! registers
                   n
                   (char->integer (read-char (current-input-port))))
      1))

  (define (read-integer p)
    (define v (read p))
    (if (and (exact? v) (integer? v))
        v
        (error "read-integer" "Not an integer value")))

  (define (get-lines p)
    (define (strip s)
      (define sp (open-input-string s))
      (let loop ((peek (peek-char sp)))
        (cond
         ((member peek '(#\space #\tab #\return
                         #\0 #\1 #\2 #\3 #\4
                         #\5 #\6 #\7 #\8 #\9))
          (read-char sp)
          (loop (peek-char sp)))
         ((or (eof-object? peek)
              (char=? peek #\#))
          "")
         (else ; keep reading until eof or #\#
          (let loop2 ((out '())
                      (peek2 (peek-char sp)))
            (if (or (eof-object? peek2)
                    (char=? peek2 #\#))
                (list->string (reverse out))
                (begin
                  (read-char sp)
                  (loop2 (cons peek2 out)
                         (peek-char sp)))))))))
    (let loop ((out '())
               (peek (peek-char p)))
      (if (eof-object? peek)
          (reverse out)
          (let ((next (strip (read-line p))))
            (loop (if (equal? next "")
                      out
                      (cons next out))
                  (peek-char p))))))

  (define (parse-line s-in)
    (define s (string-downcase s-in))
    (define p (open-input-string s))
    (define result
      (case (read p)
        ((inc)
         (let ((n (read-integer p)))
           (cons (inc (- n 1)) n)))
        ((clr)
         (let ((n (read-integer p)))
           (cons (clr (- n 1)) n)))
        ((cpy)
         (let ((m (read-integer p)))
           (let ((n (read-integer p)))
             (cons (cpy (- m 1) (- n 1)) (max m n)))))
        ((jmp)
         (let ((m (read-integer p)))
           (let ((n (read-integer p)))
             (let ((offset (read-integer p)))
               (cons (jmp (- m 1) (- n 1) offset) (max m n))))))
        ((prn)
         (let ((n (read-integer p)))
           (cons (prn (- n 1)) n)))
        ((prc)
         (let ((n (read-integer p)))
           (cons (prc (- n 1)) n)))
        ((rdn)
         (let ((n (read-integer p)))
           (cons (rdn (- n 1)) n)))
        ((rdc)
         (let ((n (read-integer p)))
           (cons (rdc (- n 1)) n)))
        (else
         (error "parse-line" "Parsing failed"))))
    (if (not (eof-object? (read p)))
        (error "parse-line" "Unexpected character")
        result))

  (define pairs (map parse-line (get-lines p)))
  (define instructions (list->vector (map car pairs)))
  (define registers (make-vector (apply max (map cdr pairs)) 0))
  (let loop ((pc 0))
    (if (< pc (vector-length instructions))
        (loop (+ pc ((vector-ref instructions pc)))))))

(define (main-prog args)
  (start-urm (open-input-file (car args))))

(main-prog (cdr (command-line)))

