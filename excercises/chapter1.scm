#lang sicp
(define excercise12 (/ (+ 5 4 (- 2 (- 3 (+ 6 4/5)))) (* 3 (-  6 2) (- 2 7))))
(display "Excercise 1.2: ")
(display excercise12)
(newline)

;; Exercise 1.3
;; Define a procedure that takes three numbers
;; as arguments and returns the sum of the ssquares of the two larger numbers

;; NOTE: Lacking more advanced features, I just enumerate all possibilities (3! = 6)
(define (max2of3 a b c) (cond ((>= a b c) (cons a b))
                           ((>= a c b) (cons a c))   
                           ((>= b a c) (cons b a))
                           ((>= b c a) (cons b c))
                           ((>= c a b) (cons c a))
                           ((>= c b a) (cons c b))))
(define (square x) (* x x))

(define (excercise13 a b c) (+ (square (car (max2of3 a b c))) (square (cdr (max2of3 a b c)))))

;; **** Exercise 1.4 ****
;; Describe the behavior of the following procedure
(define (a-plus-abs-b a b)
        ((if (> b 0) + -) a b))
;; The operator is applied conditionally,
;; in order to ensure that the number a
;; always increases by the magnitude of b.
;; If b is negative, a negative (subtraction)
;; and a negative (sign) make the value of a increase.
;; If b is positive, the addition proceeds
;; normally, increasing the value of a.
;; This effectively adds the absolute value of b,
;; because the sign of b is ignored and its magnitude
;; is always used to increase a (I tried to describe it without using that word though).