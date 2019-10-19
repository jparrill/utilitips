# Rust

## Fedora Perks

- DNF

```
sudo dnf install rust rust-doc.x86_64 rust-std-static.x86_64 rust-debugger-common.noarch rust-analysis.x86_64 rust-packaging.x86_64 --best --allowerasing -y
```

- Nvim
```
call plug#begin('~/.vim/plugged')
" Rust
Plug 'rust-lang/rust'
Plug 'rust-lang/rust.vim'
call plug#end()
```

## Lang

- Immutable, this next program will not compile

```
let var = "lol";
var = "chorizo";
```

- If you want a mutable var just:

```
let mut var = 1;
var = var + 1;
var = var + 15;
```

- First Functions
```
fn main() {
    println!("Hello World");
}
```

```
fn main() {
    let a = 1;
    let b = 2;
    println!("{} + {} is {}", a, b, a+b);
}
```

- Types

```
# Bools

let x = true;
let x: bool = true;
let y = false && true; #False


# Chars
## Not 8-bit like C, but unicode scalars which means that support unicode ootb

let c: char = "A";
let d: char = "";


# Integers (like C)

let a: i8 = -15;
let b: u8 = 250;
let c: i16 = -356;
let d: u16 = 1029;
let f: i32 = -31337;
let g: u32 = 42949672;
let h: i64 = -4294967295;
let i: u64 = 18446744073709551615;
let j: isize = -1;  # Signed 
let k: usize = 1;   # Unsigned


# Floating

let single: f32 = 1.1225 * 10.0;
let double: f64 = 1.2e-15;


# Containers

let array: [i8, 3] = [1, 4, 7];
let tuple: (i32, char) = (21, 'x');
println!("{}, {}", array[1], tuple.1); # Will print 4, x


# Functions Parameters

fn add(a: i32, b: i32) -> i32 {
    return a + b;
}

fn add_2(a: i32, b: i64) -> i32 {
    return a + (b as i32);
}

fn main() {
    let a = 1;
    let b = 3;
    println!("{} + {} is {}", a, b, add(a,b));
    println!("{} + {} is {}", a, b, add_2(a,b));
}
```

- Crates and Modules

```
use std::collections::LinkedList;

fn main() {
    let mut ll = LinkedList::new();
    ll.push_back(1);
    ll.push_back(2);
    ll.push_back(4);

    for a in ll {
        println!("{}", a);
    }
}
```

```
use std::collections::Vec;

fn main() {
    let mut v = Vec::new();
    v.push('x');
    v.push('y');
    v.push('z');

    for a in v {
        println!("{}", a);
    }
}
```

- New module
```
use hello::say_hello;

mod hello {
    pub fn say_hello() {
        println("Hello World!");
    }
}

fn main() {
    say_hello();
}
```

### Concatenate Strings

When you concatenate strings, you need to allocate memory to store the result. The easiest to start with is String and &str:

```
fn main() {
    let mut owned_string: String = "hello ".to_owned();
    let borrowed_string: &str = "world";

    owned_string.push_str(borrowed_string);
    println!("{}", owned_string);
}
```

Here, we have an owned string that we can mutate. This is efficient as it potentially allows us to reuse the memory allocation. There's a similar case for String and String, as &String can be dereferenced as &str.

```
fn main() {
    let mut owned_string: String = "hello ".to_owned();
    let another_owned_string: String = "world".to_owned();

    owned_string.push_str(&another_owned_string);
    println!("{}", owned_string);
}
```

After this, another_owned_string is untouched (note no mut qualifier). There's another variant that consumes the String but doesn't require it to be mutable. This is an implementation of the Add trait that takes a String as the left-hand side and a &str as the right-hand side:

```
fn main() {
    let owned_string: String = "hello ".to_owned();
    let borrowed_string: &str = "world";

    let new_owned_string = owned_string + borrowed_string;
    println!("{}", new_owned_string);
}
```

Note that owned_string is no longer accessible after the call to +.

What if we wanted to produce a new string, leaving both untouched? The simplest way is to use format!:

```
fn main() {
    let borrowed_string: &str = "hello ";
    let another_borrowed_string: &str = "world";

    let together = format!("{}{}", borrowed_string, another_borrowed_string);
    println!("{}", together);
}
```

Note that both input variables are immutable, so we know that they aren't touched. If we wanted to do the same thing for any combination of String, we can use the fact that String also can be formatted:

```
fn main() {
    let owned_string: String = "hello ".to_owned();
    let another_owned_string: String = "world".to_owned();

    let together = format!("{}{}", owned_string, another_owned_string);
    println!("{}", together);
}
```

You don't have to use format! though. You can clone one string and append the other string to the new string:

```
fn main() {
    let owned_string: String = "hello ".to_owned();
    let borrowed_string: &str = "world";

    let together = owned_string.clone() + borrowed_string;
    println!("{}", together);
}
```

Note - all of the type specification I did is redundant - the compiler can infer all the types in play here. I added them simply to be clear to people new to Rust, as I expect this question to be popular with that group!


## Resources

- play.rust-lang.org
