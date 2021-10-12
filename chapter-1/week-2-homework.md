1. Exercises 1.31(a), 1.32(a), 1.33, 1.40, 1.41, 1.43, 1.46

- 1.31(a):

```scheme
(define (product term a next b)
  (if (> a b)
      1
      (* (term a)
         (product term (next a) next b))
  )
)

(define (factorial a)
  (define (factorial-term x) x)
  (define (factorial-next x) (+ x 1))
  (product factorial-term 1 factorial-next a)
)

; Getting stuck here, pausing for now
(define (pi-approx depth)
  (define (pi-approx-term x index)
    (if (= (modulo index 3) 0)
      x
      (+ 2 x)
    )
  )
)
```

- 1.32(a):

```scheme
(define (accumulate combiner null-value term a next b)
  (if (> a b)
      null-value
      (combiner (term a)
        (accumulate combiner null-value term (next a) next b)
      )
  )
)

(define (sum term a next b)
  (accumulate + 0 term a next b)
)

(define (product term a next b)
  (accumulate * 1 term a next b)
)
```

- 1.33:

```scheme
(define (filtered-accumulate filter combiner null-value term a next b)
  (if (> a b)
      null-value
      (if (filter a)
        (combiner (term a)
          (filtered-accumulate filter combiner null-value term (next a) next b))
        (filtered-accumulate filter combiner null-value term (next a) next b)
      )
  )
)

; Stolen from https://stackoverflow.com/questions/49822541/check-if-a-number-is-prime

(define (prime? n)
  (let loop ((d 2))
    (cond ((< n (* d d)) #t)
          ((zero? (modulo n d)) #f)
          (else (loop (+ d 1))))))

(define (square x) (* x x))
(define (inc x) (+ x 1))
(define (sum-prime-squares a b)
  (filtered-accumulate prime? + 0 square a inc b)
)

(define (identity x) x)
(define (relatively-prime x n)
  (if (= (modulo n x) 0)
    #f
    #t)
)
; This is wrong because my filter procedure takes two args and filtered-accumulate only passes one arg
(define (product-relative-primes n)
  (filtered-accumulate relatively-prime * 1 identity 1 inc n)
)
```

- 1.40

```scheme
(define (cubic a b c)
  (lambda (x) (+ (* x x x) (* a x x) (* b x) c)
)
```

- 1.41

```scheme
(define (double procedure)
  (lambda (x) (procedure (procedure x)))
)
```

- 1.42

```scheme
(define (compose proc1 proc2)
  (lambda (x) (proc1 (proc2 x)))
)
```

- 1.43

```scheme
(define (repeated procedure repetitions)
  (lambda (x)
    (if (= 1 repetitions)
      (procedure x)
      ((compose procedure (repeated procedure (- repetitions 1))) x)
    )
  )
)
```

- 1.46

```scheme
; How do I test this?
(define (iterative-improve is-guess-good-enough improve-guess)
  (lambda (guess)
    (if (is-guess-good-enough guess)
      guess
      (improve-guess guess)
    )
  )
)
```

Rewriting `sqrt` using iterative-improve:

```scheme
; Original:
(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))

(define (sqrt x)
  (sqrt-iter 1.0 x))

; New:
; I want the square root of x, say 9
(define (sqrt-new x)
  ((iterative-improve good-enough? improve) x)
)
```

- What I'm getting confused about: x. What is x, and how does it work when we're passing it around?
  - X is actually the number we want to get the square root of
  - So I guess I could just hardcode guess as 1 for my good-enough procedure...ah, but that doesn't work, does it? Because as soon as we guess another number, we need to change guess
- Ugh. I guess I'll come back to this tomorrow
