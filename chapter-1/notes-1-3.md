# 1.3 Formulating Abstractions with Higher-Order Procedures

- Procedures are "abstractions that describe compound operations on numbers independent of the particular numbers"; in other words, a function for `square` is good for squaring any number and not only 3 or 5
  - We don't necessarily need to define `square` since we could just always write out what it does, but it gets...inconvenient to do so. We'd be forced to work only at primitives but never higher-level operations
  - With any programming language, we should be able to build abstractions by assigning names to common patterns
- If we only create abstractions with procedures that take in numbers, we're still limited. We need to make procedures that can accept other procedures as arguments or return procedures as values
  - Procedures that manipulate procedures are called _higher-order procedures_

## 1.3.1 Procedures as Arguments

- ...you can pass procedures as arguments. That's kinda it for this section. Lots of examples and scary math notation.

## 1.3.2 Constructing Procedures Using Lambda

- You can construct procedures without naming them using _lambda_, a special form
- Structure: `(lambda (<formal-parameters>) <body>)`
  - Example function:

```scheme
(define (f x y)
  ((lambda (a b)
     (+ (* x (square a))
        (* y b)
        (* a b)))
   (+ 1 (* x y))
   (- 1 y)))
```

Example

```scheme
(f 5 6)
  ((lambda (a b)
  ; Sum: 4805 + -30 + -155 = 4620, the final result of our function
     (+ (* 5 (square a))
        (* 6 b)
        (* a b)))
    ; This is our first argument for the lambda function
   31
    ; This is our second argument
   -5)
```

- `let`: an alternate syntax for `lambda` where we define local variables and then use them in context of a function body
- The same example function using `let`:

```scheme
(define (f x y)
  (let ((a (+ 1 (* x y)))
        (b (- 1 y)))
    (+ (* x (square a))
       (* y b)
       (* a b))))
```

- Here, we define `a` to equal `(+ 1 (* x y))` and `b` to equal `(b (- 1 y))`, then we plug those values into our body, `(+ (* x (square a)) (* y b) (* a b))`. Whew! What a mouthful that is
- General form of `let`:

```scheme
(let ((<var1> <exp1>)
      (<var2> <exp2>)
      ...
      (<varN> <expN>))
    <body>)
```

- Breaking that down: the first part is a list of name-expression pairs. At evaluation time, the body of `let` is evaluated with those locally-bound variables defined in the first part
- `let` is literally interpreted as an alternate syntax for `lambda`, which can be generalized as

```scheme
((lambda (<var1 ... varN>)
  <body>)
<exp1>
...
<expN>)
```

- Important note on `let`: I'm not sure how to describe this well so here's an example. Let's say we're inside a function and we already have a value `x = 2`. Then this happens:

```scheme
(let ((x 3)
      (y (+ x 2)))
  (* x y))
```

- The final value of `(* x y)` is `12`: the `x` in the BODY of the `let` expression is 3, as is defined in the `<var> <exp>` section. But `y` is 4, because _its_ x is the `x` that was already defined in the context
  - Perhaps the way to sum it up is "`let` variables and expressions are separate from each other. You cannot reference a variable defined in one "definition block" (what I'm calling those var/exp pairs) in another definition block

## 1.3.3 Procedures as General Methods

- Uh...You can use functions passed as arguments to express math things...?

## 1.3.4 Procedures as Returned Values

- As you may have intuited from the header of this section, you can return procedures from other procedures! An example:

```scheme
(define (average-damp f)
  (lambda (x) (average x (f x))))
```

- This example takes in a function and returns a function that computes the average of the input provided to said function and its output. You would call this like so:

```scheme
((average-damp square) 10)
```

- The syntax looks a little funky, huh? Well, we have that double `((` at the beginning because we're calling `average-damp` and passing it `square`, and then that gives us a procedure back. We then call that procedure and pass it `10` - we end up with the average of `10` and `10^2` - 55
- Different programming languages impose different levels of restriction on computational elements, and _first-class_ elements are those with the fewest restrictions. This text (and perhaps computer science...people...more generally) notes that some "rights and privileges" of first-class elements are as follows:
  - They may be named by variables
  - They may be passed as arguments to procedures
  - They may be returned as the results of procedures
  - They may be included in data structures
- In Lisp, procedures have full first-class status! This is hard to implement but results in an enormous "gain in expressive power"
