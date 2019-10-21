+++
title = "C"
weight = 2
insert_anchor_links = "left"
+++

- Finish a C program from non-main function [1.3.10 - The Return Statement](https://publications.gbdirect.co.uk/c_book/chapter1/description_of_example.html)
```
...Returning from the main function is the same as calling the library function exit with the return value as an argument. The difference is that exit may be called from anywhere in the program, and terminates it at that point, after doing some tidying up activities. If you intend to use exit, you must include the header file <stdlib.h>. From now on, we shall use exit rather than returning from main.

TL;DR

EXIT_SUCCESS and EXIT_FAILURE for main function, exit for others
```

- Get an int lenght
```c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

int length = (int)floor(log10((float)number)) + 1;
```

- Trygraphs

```

C character	Trigraph
       #	??=
       [	??(
       ]	??)
       {	??<
       }	??>
       \	??/
       |	??!
       ~	??-
       ^	??'
```

- Keywords
```
auto       double   int        struct
break      else     long       switch
case       enum     register   typedef
char       extern   return     union
const      float    short      unsigned
continue   for      signed     void
default    goto     sizeof     volatile
do         if       static     while
```

- The range specified in the Standard for an unsigned int is 0 to at least 65535, meaning that it cannot be negative


- Unsigned/Signed Int conversion: https://stackoverflow.com/questions/50605/signed-to-unsigned-conversion-in-c-is-it-always-safe 

6.2.5 (9)
A computation involving unsigned operands can never overflow, because a result that cannot be represented by the resulting unsigned integer type is reduced modulo the number that is one greater than the largest value that can be represented by the resulting type.

- Bonus: Arithmetic Conversion Semi-WTF
```c
#include <stdio.h>

int main(void)
{
  unsigned int plus_one = 1;
  int minus_one = -1;

  if(plus_one < minus_one)
    printf("1 < -1");
  else
    printf("boring");

  return 0;
}
```

More conversions:

```c
unsigned int u;
int s = 1;
u = s;
```

But if the integer is negative the interpreter will just copy the bits, so you can do something like this:

```c
#include <stdio.h>
 
int main() {
 
  unsigned int u;
  int s = -5;
  u = s; 
  u = (s >= 0 ? s:-s);
 
  return 0;
 
}
```


- The usual arithmetic conversions (following thi hierarchy)

if either operand is  Double Large, then Double large
elif "" Double, then Double
elif "" Float, then Float
elif "" Unsigned Long Int, then Unsigned Long Int
elif "" Long int, then Long int
elif "" Unsigned Int, then Unsigned Int
elif "" int, then int

- Example of a conversion by accident:
```c
#include <stdio.h>
#include <stdlib.h>
main(){
      int i;
      unsigned int stop_val;

      stop_val = 0;
      i = -10;

      while(i <= stop_val){
              printf("%d\n", i);
              i = i + 1;
      }
      exit(EXIT_SUCCESS);
}
```

There is further support for this method of encoding characters. Strings, which we have already seen, are implemented as arrays of char, even though they look like this:

```c
"a string"
```
To get strings whose type is wchar_t, simply prefix a string with the letter L. For example:

```c
L"a string"
```
In the two examples, it is very important to understand the differences. Strings are implemented as arrays and although it might look odd, it is entirely permissible to use array indexing on them:

```c
"a string"[4]
L"a string"[4]
```

- Casts - Force a value to perform a conversion into the type between ()
```c
pcnt_diff = 100/(float)curr_val;
```

```
Declaration     Cast            Type
---------------------------------------
int x;          (int)           int
float f;        (float)         float
char x[30];     (char [30])     array of char
int *ip;        (int *)         pointer to int
int (*f)();     (int (*)())     pointer to function returning int
```


-  The bitwise operators
```
Operator	Effect	            Conversions
&	        bitwise AND	        usual arithmetic conversions
|	        bitwise OR	        usual arithmetic conversions
^	        Bitwise XOR	        usual arithmetic conversions
<<	        left shift	        integral promotions
>>	        right shift	        integral promotions
~	        one's complement	integral promotions
```

Now something different; one of those little tricks that C programmers find helps to write better programs. If for any reason you want to form a value that has 1s in all but its least significant so-many bits, which are to have some other pattern in them, you don't have to know the word length of the machine. For example, to set the low order bits of an int to 0x0f0 and all the other bits to 1, this is the way to do it:

int some_variable;
some_variable = ~0xf0f;

- Asignations

```
*=	/=	%=
+=	-=	
&=	|=	^=
>>=	<<=	
```

- Add/Substract
```
C programmers never add or subtract one with statements like this

x += 1;
they invariably use one of

x++; /* or */ ++x;
```


- Precedence and grouping
```
Operator                                    Direction       Notes
() [] -> .                                  left to right   1
! ~ ++ -- - + (cast) * & sizeof             right to left   all unary
* / %                                       left to right   binary
+ -                                         left to right   binary
<< >>                                       left to right   binary
< <= > >=                                   left to right   binary
== !=                                       left to right   binary
&                                           left to right   binary
^                                           left to right   binary
|                                           left to right   binary
&&                                          left to right   binary
||                                          left to right   binary
?:                                          right to left   2
= += and all combined assignment            right to left   binary
,                                           left to right   binary
```

- Parentheses
C allows you to override the normal effects of precedence and associativity by the use of parentheses as the examples have illustrated. In Old C, the parentheses had no further meaning, and in particular did not guarantee anything about the order of evaluation in expressions like these:

int a, b, c;
a+b+c;
(a+b)+c;
a+(b+c);

- Side Effects
To repeat and expand the warning given for the increment operators: it is unsafe to use the same variable more than once in an expression if evaluating the expression changes the variable and the new value could affect the result of the expression. This is because the change(s) may be ‘saved up’ and only applied at the end of the statement. So f = f+1; is safe even though f appears twice in a value-changing expression, f++; is also safe, but f = f++; is unsafe.

The problem can be caused by using an assignment, use of the increment or decrement operators, or by calling a function that changes the value of an external variable that is also used in the expression. These are generally known as ‘side effects’. C makes almost no promise that side effects will occur in a predictable order within a single expression. (The discussion of ‘sequence points’ in Chapter 8 will be of interest if you care about this.)


- Concatenate 2 integers
```c
unsigned concatenate(unsigned x, unsigned y) {
    unsigned pow = 10;
    while(y >= pow)
        pow *= 10;
    return x * pow + y;        
}
```
