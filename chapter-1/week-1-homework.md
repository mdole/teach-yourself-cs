2. Write a procedure squares that takes a sentence of numbers as its argument and returns a sentence of the squares of the numbers:

```scheme
> (squares '(2 3 4 5))(4 9 16 25)
```

---

```scheme
(define (square x) (* x x))

(define (squares numbers)
  (if (= (length numbers) 1)
  (square (first numbers))
  (sentence (square (first numbers)) (squares (bf numbers)))))
```

3. Write a procedure switch that takes a sentence as its argument and returns a sentence in which every instance of the words I or me is replaced by you, while every instance of you is replaced by me except at the beginning of the sentence, where it’s replaced by I. (Don’t worry about capitalization of letters.) Example:

```scheme
> (switch '(You told me that I should wake you up))
(i told you that you should wake me up)
```

---

```scheme
(define (replaceWord word)
  (cond
    [(or
      (equal? 'I word)
      (equal? 'i word)
      (equal? 'me word)
      (equal? 'Me word)
    ) 'you]
    [(or
      (equal? 'you word)
      (equal? 'You word)
     ) 'me]
    (else word)
  )
)

(define (switch sentence)
  (if (empty? sentence) '()
    (se (replaceWord (first sentence)) (switch (bf sentence)))
  )
)
```

4. Write a predicate `ordered?` that takes a sentence of numbers as its argument and returns a true value if the numbers are in ascending order, or a false value otherwise.

```scheme
(define (ordered? sentence)
  (if (empty? (bf sentence)) #t
    (if (< (first sentence) (first (bf sentence)))
    (ordered? (bf sentence))
    #f)
  )
)

(define (ordered? sentence)
  (cond ((empty? (bf sentence)) #t)
    ((< (first sentence) (first (bf sentence)))
    (ordered? (bf sentence)))
    (else #f)
  )
)
```

5. Write a procedure `ends-e` that takes a sentence as its argument and returns a sentence containing only those words of the argument whose last letter is E:

```scheme
(ends-e '(please put the salami above the blue elephant))
(please the above the blue)
```

```scheme
(define (ends-e sentence)
  (cond ((empty? sentence) '())
    ((equal? (last (first sentence)) 'e)
    (se (first sentence) (ends-e (bf sentence))))
    (else (ends-e (bf sentence)))
  )
)
```

6. Devise a test that will tell you whether Scheme’s `and` and `or` are special forms or ordinary functions. Why might it be advantageous for an interpreter to treat `or` as a special form and evaluate its arguments one at a time? Can you think of reasons why it might be advantageous to treat or as an ordinary function?

Solve: In other words, do `and` and `or` evaluate their arguments before checking the condition or do they evaluate the arguments one at a time? Treating them as special forms would be advantageous if we're checking a ton of arguments. Let's say for some reason we have an `or` with 1,000 predicates. If the first predicate evaluates to `#t` and it's a special form that evaluates each argument as it goes, then we'd be done in however much time it took to check the first predicate. If it was an ordinary function, it would take us however long it takes to evaluate all 1,000 predicates.

For a test, what if we devised a recursive function that would be called, say, 10,000 or 100,000 times? No, that wouldn't work, because either way it would be evaluated and we'd wait for it to resolve. Though perhaps...what if we had it call itself 10,000 times and then return true? We could have an `or` with several instances of the call, measure the time it takes to resolve one call, and see if it takes about the same time or if it takes a multiple of the time. Should work, I think!

```scheme
(define (really-terrible-function i boolean)
  (if (< i 10000000) (really-terrible-function (+ 1 i) boolean) boolean)
)

(and (really-terrible-function 0 #f) (really-terrible-function 0 #t) (really-terrible-function 0 #t) (really-terrible-function 0 #t) (really-terrible-function 0 #t) (really-terrible-function 0 #t) (really-terrible-function 0 #t))

(or (really-terrible-function 0 #t) (really-terrible-function 0 #f) (really-terrible-function 0 #f) (really-terrible-function 0 #f) (really-terrible-function 0 #f) (really-terrible-function 0 #f) (really-terrible-function 0 #f))
```

Looks like they're special forms that are evaluated one at a time!

As to reasons we might want them to be ordinary functions...Not sure.
