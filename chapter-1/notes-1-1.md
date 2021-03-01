# 1.1

- How do languages allow us to combine simple ideas into more complex ideas?
- Three mechanisms for accomplishing idea combination:
  - Primitive expressions, "the simplest entities the language is concerned with"
  - Means of combination, the way we build compound elements from simpler ones
  - Means of abstraction, which means that "compound elements can be named and manipulated as units"
- Two key "elements": **procedures and data**
  - Data = stuff, procedures = how we manipulate stuff

## 1.1.1 Expressions

- _Expression_ = thing that can be evaluated
- A compound expression formed by listing multiple expressions in parentheses (i.e. "run this stuff") is a _combination_
  - Leftmost element = _operator_
  - Other elements = _operands_
  - I typically think of these as functions and parameters respectively - that's how we refer to them in JS and Ruby
  - Uhh I don't understand this: "The value of a combination is obtained by applying the procedure specified by the operator to the _arguments_ that are the values of the operands" - what's the difference between an operand and an argument?
- _Prefix notation_: operator goes to the left of the operands
  - Allows for infinite arguments to be passed to operand with clarity
  - Allows for _nesting_ of combinations; combinations composed of combinations
- _Pretty-printing_ in LISP = "operands are aligned vertically", e.g.

```scheme
(+ (* 3
        (+ (* 2 4)
          (+ 3 5)))
    (+ (- 10 7)
        6))
```

- The interpreter runs a _read-eval-print-loop_: reads expression, evaluates the expression, prints the result. You don't need to explicitly say "hey please print this", it just does so. REPL!

## 1.1.2 Naming and the Environment

- Using names to refer to computational objects: name identifies a _variable_ whose _value_ is the object
- In Scheme, we name things with _define_
- "Possibility of associating values with symbols and later retrieving them means the interpreter must maintain some sort of memory" - known as the _environment_, the _global environment_ in the case of just running a `(define ...)`

## 1.1.3 Evaluating Combinations

- To evaluate a combination, we have to:
  1. Evaluate the subexpressions of the combination
  2. "Apply the procedure that is the value of the leftmost subexpression (the operator) to the arguments that are the values of the other subexpressions (the operands)"
- The evaluation rule is _recursive_
- To visualize recursive evaluation of combinations, we can use a tree, where each node has a value and branches that are the operator and operands:

```
  ...
   | 26
  /|\
 / | \
+  2  \
       \ 24
       /|\
      / | \
     /  |  \
    /   |   \
    *   4   6
```

- ...ok whew that was hard to create. You get the idea.
- "Percolate values upward" form of evaluation rule is an example of _tree accumulation_
- Repeatedly evaluating the subexpressions will eventually get us to a point where we have primitives - numerals, built-in operators, other names. We resolve these:
  - Values of numerals are the numbers they name (4 is 4, cool)
  - Values of built-in operators are "machine instruction sequences that carry out the corresponding operations (+ is +, cool)
  - Values of other names are the objects associated with those names **in the environment** (myFour is myFour, got it)
- Environment is key: "x + 1" doesn't mean anything unless we've defined x somewhere - and + too, for that matter
- "Environment provides a context in which evaluation takes place"
- Evaluation rule does not cover definitions. Exceptions to the evaluation rule are called _special forms_. Define is one such form
  - Special forms each have their own evaluation rules
- _Formal parameters_ = the parameters as defined when defining a function, e.g. `(define (<name> <formal parameters>) <body>)`

## 1.1.4 Compound Procedures

- Basically, you can call procedures with other procedures as arguments and that's fine

## 1.1.5 the Substitution Model for Procedure Application

- In effect: you can evaluate an expression by replacing formal parameters with corresponding arguments
- E.g. `(+ (square 5) 4)`: we get the definition for square `(define (square x) (* x x) )`, replace the `x`es with `5`, evaluate that to 25, add 4, and return 29
- Important note: this is a MODEL, and may not actually reflect how the interpreter actually works
- This is a simplified, incomplete model. As we progress, we'll learn more elaborate models for how interpreters work!
- Normal order vs. applicative order:
  - Normal order = keep substituting expressions for parameters until we get to a point where we only have primitive operators, and _then_ evaluate
  - Example: the first normal-order step for evaluating `(sum-of-squares (+ 5 1) (* 5 2))` would be `(+ (square (+ 5 1)) (square (* 5 2)))`. Notice how `(+ 5 1)` and `(* 5 2)` have not been evaluated yet!
  - Can be helpful to think of it as "fully expand and then reduce"
  - Applicative order = "evaluate the arguments and then apply"
  - Example: the first applicative-order step for evaluating `(sum-of-squares (+ 5 1) (* 5 2))` would be `(sum-of-squares 6 10))`
  - **Our interpreter uses applicative order**
  - For procedure applications that can be modeled using substitution, normal and applicative orders produce the same result - but there are expressions for which they do not!

## 1.1.6 Conditional Expressions and Predicates

- _Case analysis_: test different cases and do something based on the results. _This is one of LISP's special forms_
- To use: `(cond ((first case) first result) ((second case) second result) ...)`
  - The actual term for "first case" is a _predicate_, which evaluates to true or false
  - The actual term for "first result" is a _consequent expression_
  - "First case" and "first result" are referred to as _clauses_
- Conditional expressions are evaluated from the top down - if "first case" is true, return "first result". Otherwise, go on to "second case" and so on
- Value of `cond` is undefined if none of the predicates are true
- "Predicate" is used for procedures that return true or false and for expressions that evaluate to true or false
- You can use `else` instead of the final predicate clause in a `cond`
- Another conditional: our good friend `if`!
  - Defined as: `(if <predicate> <consequent> <alternative>)`
  - Interesting - this is basically what I think of as a ternary. Are you allowed to leave off the `<alternative>`, or do you have to use a `cond` for that?
    - Tested it out - yeah, you can just leave off the `<alternative>` and nothing will be returned
- Primitive predicates: `<, >, =`
- Logical composition operations: `and, or, not`
  - `and` evaluates left-to-right and stops evaluating as soon as it hits a `false`
  - `or` evaluates left-to-right and stops evaluating as soon as it hits a `true`
- `and` and `or` _are special forms_ because it's not guaranteed that all subexpressions will be evaluated. `not` is an ordinary procedure

## 1.1.7 Example: Square Roots by Newton's Method

- Key takeaway: computer procedures must be "effective" - they need to describe how to do things rather than properties of things
