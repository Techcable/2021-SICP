Chapter 1
==========
Written solutions to exercises

## Exercise 1.4
Describe the behavior of the following procedure:
```scheme
(define (a-plus-abs-b a b)
        ((if (> b 0) + -) a b))

```

The operator is applied conditionally,
in order to ensure that the number a
always increases by the magnitude of b.

There are two cases:
1. If b is negative, a negative (subtraction)
  and a negative (sign) make the value of a increase.
2. b is positive (or zero), the addition proceeds
  normally, increasing the value of a.

This effectively adds the absolute value of b,
because the sign of b is ignored and its magnitude
is always used to increase a (I tried to describe it without using that word though).

## Exercise 1.5
Ben Bitwiddle invents the following test to test whether the interpreter
uses "normal order" or "applicative order" evaluation

To review (for my sake), "applicative order" means to evaluate the args first,
and then apply. In other words, it's "eager" evaluation, like in Java or C.
The alternative "fully expand and then reduce" is called "normal order".
In other words it's "lazy" evaluation, like in Haskell (I think).
```scheme
(define (p) (p))
(define (test x y) (if (= x 0) 0 y))
```

NOTE: P evaluates by calling itself.
In "applicative order" mode,
this causes infinite recursion.
Because p() will call itself and loop infinitely.

At first I thought this might create some sort of closure or function reference,
but it does in fact do the stupid thing
and perform a call (and thus loop forever)
In "normal order" mode, the if test evaluates
to true, and the `p` function doesn't need to be
evaluated (because everything is lazy).
The result is `0` instead of an infinite loop.
I guess the author is trying to hint at the
advantage of "normal order"/lazy evaluated languages.
However, I'm still skeptical it is worth the complexity
(despite not seriously working with it much) :p

## Exercise 1.6
Alyssa P. Hacker doesn’t see why `if` needs to be provided as a special form. “Why can’t I just define it as an ordinary procedure in terms of `cond`?” she asks. Alyssa’s friend Eva Lu Ator claims this can indeed be done, and she defines a new version of `if`:
```scheme
(define (new-if predicate then-clause else-clause)
    (cond (predicate then-clause)
    (else else-clause)))
```

Delighted, Alyssa uses new-if to rewrite the square-root program:
```scheme
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x) x)))
```
What happens when Alyssa attempts to use this to compute square roots? Explain. 

### Answer
Since Lisp uses applicative order, and `new-if` is a regular function (not a "special form") both the 'then-clause' and the 'else-clause' of the if statement will be evaluated unconditionally.

This will trigger an infinite recursion. Thanks to Lisp's Tail Call Optimization, this is equivalent to an infinite loop.

## Exercise 1.7
Here is an example that proves that our current definition of `good-enough?` is very poor.
Five iterations of newtons method (starting with one) to compute `sqrt(1e-7)` gives `0.03125106561775382` on my machine.

Then `(good-enough? .03 1e-7)` gives true, even though `square .03` gives `9e-4`, which is off by three orders of magnitude from the target `1e-7`.

A better version would use *relative* differences.
Instead of checking if `abs(actual - target) < fixed_diff`,
check if `abs(actual - target) / target < fixed_relative_diff`.
This will implicitly adjust to different orders of magnitude, both large and small.

More explicitly, define
```scheme
(define (good-enough? guess x)
    (< (/ (abs (- x (square guess))) x) 0.001))
```

This modified version gives `.00316` as the answer to `(sqrt 1e-7)`.

### Note on suggestion on running to a fixpoint
NOTE: The book suggested essentially running the `sqrt-iter` function until the difference between iterations settles down to a very small fraction of the guess.

While I believe this would work,
it seems very inelegant without using let-bindings
or intermediate variables, because it would require
running what is essentially a hypothetical iteration of each loop.

Although I believe this would work, I find it extremely inelegant.

## Exercise 1.9
```scheme
(define (+ a b)
  (if (= a 0) 
      b 
      (inc (+ (dec a) b))))
```
For `(+ 4 5)`, this reduces to:
`(inc (+ (3) 5))`
`(inc (inc (+ (2) 5))`
`(inc (inc (inc (+ (1) 5)))`
`(inc (inc (inc (inc (+ (0) 5)))))`
`(inc (inc (inc (inc 5)))`
`(inc (inc (inc 6)))`
`(inc (inc 7))`
`(inc 8)`
`9`
This is recursive, the amount of state/memory it requires increases with the input. In particular the number of deferred *calls* is proportional to the input.

This makes sense, because the function doesn't call itself as the final instruction. It isn't a *tail* call.

For the second definition,
```scheme
(define (+ a b)
  (if (= a 0)
      b
      (+ (dec a) (inc b))))
```
The final call *is* a tail call, so I expect this to be iterative (not recursive). The procedure calls itself as its final action.

Lets check:
`(+ 4 5)`
`(+ 3 6)`
`(+ 2 7)`
`(+ 1 8)`
`(+ 0 9)`
`9`

The tree (and number of deferred calls) doesn't grow and remains constant regardless of the input. Therefore this second procedure is iterative.

## Exercise 1.10
Here is a definition of the "Ackerman function:"
```scheme
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y)
        ((= y 1) 2)
        (else (A (- x 1)
                (A x (- y 1)))))))
```
Evaluating the following:
1. `(A 1 10)`
`(A 0 (A 1 9))`
`(A 0 (A 0 (A 1 8)))`

`(A 0 (A 0 (A 0 (A 1 7))))`

`(A 0 (A 0 (A 0 (A 0 (A 1 5)))))`
.......
Ends up computing 2 ** 10

2. `(A 3 4)` (EDIT: I made a mistake copying this down. Ignore it)
`(A 2 (A 3 3))`
`(A 2 (A 2 (A 3 3)))`
`(A 2 (A 2 (A 2 (A 3 2))))`
`(A 2 (A 2 (A 2 (A 2 (A 3 1)))))`
`(A 2 (A 2 (A 2 (A 2 2))))`

For future reference:
`(A 1 y)` is `(exp 2 y)`
`(A 2 y)` reduces (assuming y > 2)
`(A 1 (A 2 (- y 1))`
`(exp 2 (A 2 (- y 1))`
`(exp 2 (A 1 (A 2 (- y 2)))`
`(exp 2 (exp 2 (A 2 (- y 2)))`

So `(A 2 x)` is to `(exp 2 x)` as `(exp 2 x)` is to `(* 2 x)`.
However, when `y=1`, we seed the sequence with 2 instead of `2**0=1`.

For example,
`(A 2 2)`
`(exp 2 2)`
Or, in standard notation, `2^2`
`(A 2 3)`
`(exp (exp 2 2))`
In standard notation: `2^2^2`

This grows **super** fast:
`(A 2 (A 2 (A 2 (A 2 2))))`
`(A 2 (A 2 (A 2 (exp 2 2))))`
`(A 2 (A 2 (4^4^4^4)))`
Soooo, this looks like it'll probably take forever ;)
That's what happens when you make mistakes copying down

1. `f(n)=2n`
2. `g(n)=2^n`
3. `h(n)` is to `2^n` as `2^n` is to `2n`. In standard mathematical notation, this would be written with the n as a superscript to the left of 2, instead of the right of 2 like it is with exponents (I remember my Calc II teacher explaining this to me once)

## Exercise 1.13
I can't for the life of me figure this proof out (that $Fib(n)=(\phi^n-\psi^n)/\sqrt{5}$. I've spent over an hour trying to prove it. However, I did manage to prove that the expression $(\phi^n-\psi^n)/\sqrt{5}$ expands to the following infinite series:

$$\sum_{k=0}^{\lfloor(n-1)\div 2\rfloor}{({n\choose{2k+1}}\sqrt{5}^{2k+1})\div(\sqrt{5}\cdot2^{n-1})}$$

