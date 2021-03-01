; 1.1
10 ; 10
(+ 5 3 4) ; 12
(- 9 1) ; 8
(/ 6 2) ; 3
(+ (* 2 4) (- 4 6)) ; 6
(define a 3) ;; a
(define b (+ a 1)) ;; b
(+ a b (* a b)) ; 19
(= a b) ; #f
(if (and (> b a) (< b (* a b)))
    b
    a) ; 4
(cond ((= a 4) 6)
      ((= b 4) (+ 6 7 a))
      (else 25)) ; 16
(+ 2 (if (> b a) b a)) ; 6 
(* (cond ((> a b) a)
         ((< a b) b)
         (else -1))
   (+ a 1)) ; 16

; 1.2
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))

; 1.3
(define (square-largest x y z)
  (cond ((>= x y z) (+ (square x) (square y)))
  ((>= x z y) (+ (square x) (square z)))
  ((>= y x z) (+ (square y) (square x)))
  ((>= y z x) (+ (square y) (square z)))
  ((>= z x y) (+ (square z) (square x)))
  ((>= z y x) (+ (square z) (square y)))
  )
)

; 1.4
(define (a-plus-abs-b a b)
  ((if (> b 0) + -) a b))

; if b > 0, then add b to a
; if not then subtract b from a

; 1.5
; Applicative: hang indefinitely
; Normal: 0
; in applicative order, (p) as an argument would try to be evalutated before it reached the if statement
; whereas in normal order, it evalutes the if statement because it's not trying to reference (p)


; 1.5

; I think this must have to do with applicative order? Let's walk through an example

(define (average x y)
  (/ (+ x y) 2))

(define (improve guess x)
  (average guess (/ x guess)))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))

(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x)
                     x)))

(sqrt-iter 1 5)

; We first check if our guess is good enough:

(< (abs (- (square guess) x)) 0.0001)
(< (abs (- (square 1) 5)) 0.0001)
(< (abs (- 1 5)) 0.0001)
(< (abs -4) 0.0001)
(< 4 0.0001)
; #f

; Not good enough! So we call `sqrt-iter` again with new params:

(sqrt-iter (improve 1 5) 5)
(sqrt-iter (average 1 (/ 5 1)) 5)
(sqrt-iter (average 1 5) 5)
(sqrt-iter 2.5 5)
(new-if (good-enough? 2.5 5)
          2.5
          (sqrt-iter (improve 2.5 5)
                     5))

; "`else` causes `cond` to return as its value the value of the corresponding expression whenever all previous clauses have been bypassed": does that mean we would just return `(sqrt-iter (improve 1 5) 5)` and not actually try to evaluate it?

; "To evaluate an `if` expression, the interpreter starts by evaluating the `<predicate>` part of the expression. If the `<predicate>` evaluates to a true value, the interpreter then evaluates the `<consequent>` and returns its value. Otherwise it evaluates the `<alternative>` and returns its value."

; My answer: the `else` clause of the `cond` in `new-if` attempts to return the value of the expression `(sqrt-iter (improve guess x) x)`, but

; Correct answer, after some googling and brow-furrowing: 
; the problem is not with the `cond` in `new-if`, I understood that correctly. 
; The problem is that `new-if` itself is a function and therefore all of its 
; parameters are evaluated. When we call it within `sqrt-iter`, we're passing three arguments:

(new-if (good-enough? guess x) guess (sqrt-iter (improve guess x) x))

; So we're atomatically kicking off another evaluation of sqrt-iter, which kicks off
; another evaluation of sqrt-iter, which... and in the end we just never stop