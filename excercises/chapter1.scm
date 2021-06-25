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

;; Newton's Method. Chapter 1.1.7
;;
;; NOTE: Modified "good-enough?" is solution
;; to Excercise 1.7
(define (good-enough? guess x)
    (< (/ (abs (- x (square guess))) x)  0.001))


(define (sqrt-iter guess x)
  (if (good-enough? square guess x)
      guess
      (sqrt-iter (improve guess x) x)))

(define (average x y) 
  (/ (+ x y) 2))

(define (improve guess x) (average guess (/ x guess)))

;; Improve sqrt (via newtons method) until it is "good-enough?"
(define (sqrt x) (sqrt-iter 1 x))

;; Little utility program to run a certian number of iterations
(define (sqrt-n guess x n) (if (= n 0) guess
    (sqrt-n (improve guess x) x (- n 1))))

;; Exercise 1.8
;;
;; Implement a cbrt procedure using
;; the fact that a guess `y` can be improved:
;; (x/y^2+2y)/3
;;
;; I wanted to generalize this to arbitrary
;; roots *SOOO* bad, but I decided to wait
(define (cube x) (* x x x))

(define (good-enough-cbrt? guess x)
    (< (/ (abs (- x (cube guess))) x)  0.001))


(define (cbrt-iter guess x)
  (if (good-enough-cbrt? guess x)
      guess
      (cbrt-iter (improve-cbrt guess x) x)))

(define (improve-cbrt guess x) (/
  (+ (/ x (square guess)) (* 2 guess))
  3))

(define (cbrt x) (cbrt-iter 1 x))
