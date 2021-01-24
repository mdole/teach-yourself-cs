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