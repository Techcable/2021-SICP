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
