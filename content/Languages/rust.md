+++
title = "Rust"
weight = 1
+++

## Fedora Perks

## DNF

```bash
sudo dnf install rust rust-doc.x86_64 rust-std-static.x86_64 rust-debugger-common.noarch rust-analysis.x86_64 rust-packaging.x86_64 --best --allowerasing -y
```

## IDEs

- Nvim
```vim
call plug#begin('~/.vim/plugged')
" Rust
Plug 'rust-lang/rust'
Plug 'rust-lang/rust.vim'
call plug#end()
```

- VSCode
  - Required: rustup + RLS
  - Extensions:
    - Rust Base
    - Rust (rls)
    - Rust Snippets
    - Rust Test Lens
    - Rust Doc Viewer 

## Basics 

- Immutable, this next program will not compile

```rust
let var = "lol";
var = "chorizo";
```

- If you want a mutable var just:

```rust
let mut var = 1;
var = var + 1;
var = var + 15;
```

- First Functions
```rust
fn main() {
    println!("Hello World");
}
```

```rust
fn main() {
    let a = 1;
    let b = 2;
    println!("{} + {} is {}", a, b, a+b);
}
```

### Types

```rust
// Bools

let x = true;
let x: bool = true;
let y = false && true; #False

// Chars
// Not 8-bit like C, but unicode scalars which means that support unicode ootb

let c: char = "A";
let d: char = "";


// Integers (like C)

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


// Floating

let single: f32 = 1.1225 * 10.0;
let double: f64 = 1.2e-15;


//Containers

let array: [i8, 3] = [1, 4, 7];
let tuple: (i32, char) = (21, 'x');
println!("{}, {}", array[1], tuple.1); # Will print 4, x


// Functions Parameters

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

### Concatenate Strings

When you concatenate strings, you need to allocate memory to store the result. The easiest to start with is String and &str:

```rust
fn main() {
    let mut owned_string: String = "hello ".to_owned();
    let borrowed_string: &str = "world";

    owned_string.push_str(borrowed_string);
    println!("{}", owned_string);
}
```

Here, we have an owned string that we can mutate. This is efficient as it potentially allows us to reuse the memory allocation. There's a similar case for String and String, as &String can be dereferenced as &str.

```rust
fn main() {
    let mut owned_string: String = "hello ".to_owned();
    let another_owned_string: String = "world".to_owned();

    owned_string.push_str(&another_owned_string);
    println!("{}", owned_string);
}
```

After this, another_owned_string is untouched (note no mut qualifier). There's another variant that consumes the String but doesn't require it to be mutable. This is an implementation of the Add trait that takes a String as the left-hand side and a &str as the right-hand side:

```rust
fn main() {
    let owned_string: String = "hello ".to_owned();
    let borrowed_string: &str = "world";

    let new_owned_string = owned_string + borrowed_string;
    println!("{}", new_owned_string);
}
```

Note that owned_string is no longer accessible after the call to +.

What if we wanted to produce a new string, leaving both untouched? The simplest way is to use format!:

```rust
fn main() {
    let borrowed_string: &str = "hello ";
    let another_borrowed_string: &str = "world";

    let together = format!("{}{}", borrowed_string, another_borrowed_string);
    println!("{}", together);
}
```

Note that both input variables are immutable, so we know that they aren't touched. If we wanted to do the same thing for any combination of String, we can use the fact that String also can be formatted:

```rust
fn main() {
    let owned_string: String = "hello ".to_owned();
    let another_owned_string: String = "world".to_owned();

    let together = format!("{}{}", owned_string, another_owned_string);
    println!("{}", together);
}
```

You don't have to use format! though. You can clone one string and append the other string to the new string:

```rust
fn main() {
    let owned_string: String = "hello ".to_owned();
    let borrowed_string: &str = "world";

    let together = owned_string.clone() + borrowed_string;
    println!("{}", together);
}
```

Note - all of the type specification I did is redundant - the compiler can infer all the types in play here. I added them simply to be clear to people new to Rust, as I expect this question to be popular with that group!


## Crates and Modules

```rust
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

```rust
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
```rust
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


## Ownership & Borrowing

- Eliminates all mem unsafety then will never seg fault
    - When a program tries to access to a Virt mem space outside of it's allowed area (seg Fault)
- With a strict static compile time checking (Borrow checker:
    - Seg faults: ^^
    - Buffer Overruns: Read off the end of an array
    - Dangling Pointers: Memory freed but the pointer is still there, then you could try to use it (in other languages)
    - Double frees: Allocate mem, free them, an then free them again, causing issues and revealing sensitive info
    - Use-After-Frees: Tries to use the mem already freed

- GC: Statically compiled, minimum impact on performance
- Concurrency:
    - Fearless concurrency: The mem management of Rust and the Borrow checker takes care about preventing and avoid data races.

- Ownership sample:
```rust
// a owns the value
let a = foo();

// now b owns the value
let b = a;

// ownership passed to do_something()
do_something(b);

// This will fail
do_something_else(b);
```

- How Ownership works:
    - Every valuee has an owner
    - Ownership can be passed around by binding and/or function calls
    - Once ownership is passed, the old binding can't be user again
    - This prevents use-after-free

- Borrowing sample
```rust
// a owns the value
let a = foo();

// a still owns the value
let b = &a;

// But functions still could use it
do_something_yet_again(&a);
```

- How Mut and non-Mut Borrowing works:
    - You cannot pass the ownership of a borrowed var
    - In the past example you cannot pass the ownership of b
    - Borrowed values are inmutable, even if the value is mutable that borrow can't be used to mutate the value
    - Either One mutable or Many inmutable borrows
    - You can share state or you can mutate state but you can't do both

- Mutable Borrowing sample
```rust
let a = foo();
let b = &a;

// Error, Cannot move borrowed value
do_something(a);
```

- Mutable borrows:
    - Allow values to be changed without transfering the ownership
    - Ony one mutable borrow can exists at one and non-mutable borrows can exist a the same time

- Sample Mut and non-Mut to the same borrow
```rust
let mut a = 10;
let b = &mut a;
b += 1;

// Error cannot have mutable and inmutable borrows
let c = &a;
b += 1;
```

- RAII
    - Stands for Resource Allocation is Initialization
    - You get resources (mem, files, db cons) when you initialize them and free them when you de-initialize them
    - Ownership make this easy for Rust to be managed

- RAII Sample
```rust
fn munge_file() {
    let mut file = File::create("file.txt")?;
    file.write_all(b"hello world");
} // file closed auto when the functions finishes because no-one is owning the file handler
```

- Shared and exclusive Access, sample
```rust
fn take_ownership_of_value(v: Vec<i32>) -> i32 { 
    let mut sum = 0;
    for val in v { sum += val; }
    return sum;
}

fn main() {
    let arr = vec![1,2,3,4,5,6,7,8,9];
    let sum = take_ownership_of_value(arr);
    // This will give us an err because the function 'take_ownership_of_value'
    // owns the value and when finishes frees the resource.
    println!("Sum of {} values: {}", arr.len(), sum);
}

```

- But we could do this instead:
```rust
fn borrow_sum (v: &Vec<i32>) -> i32 {
    // Receives a reference (mem position)
    let mut sum = 0;
    for val in v { // We iterate over mem positions.
        // This is a pointer that points to the content.
        sum += *val;  
    }
    return sum;
}

fn main() {
    let arr = vec![1,2,3,4,5,6,7,8,9];
    let sum = borrow_sum(&arr);
    println!("Sum of {} values: {}", &arr.len(), sum);
}
```

- Sample of mutable reference to vector
```rust
fn cap_value_borrow(max: i32, v: &mut Vec<i32>) {
    for index in 0..v.len() {
        if v[index] > max {
            v[index] = max;
        }
    }
}

fn main() {
    let mut arr = vec![1,2,3,500000,4,5];
    cap_value_borrow(10, &mut arr);
    for v in arr {
        println!("{}", v);
    }
}

// The output
:!./vec_mut_ref                                                                                                                                                                                         
1
2
3
10
4
5
```

## Strs, Vecs, Strings and Slices

- Strings and Vecs are almost the same:
    - Heap allocated
    - Consist of a pointer to that heap memory and a little data
    - when we create a Vec, we receive a lenght and a pointer where the vec starts

![img](../vec_strings.png "vector and strigs")

- Slices & Strs
    - Allow passing around views into hep without copying values or passing raw pointers
    - They consist also on a pointer and a lenght but without owning the data
    - WARN: You Can't directly hold an str or a slice because ir doesn't own the it's mem 
    - WARN: You have to have a reference, since it is basically a reference (and the original vars are freed)

- Sample code
```rust
let a = vec![1,2,4,6,7,8];
let sla = &a[1..2];
// sla = &[2,4]

let b = String::from("Hello");
let slb = &b[1..2];
// slb = "el"
```

## Strict Borrow checker

- Cannot borrow as inmutable due to existing mutable borrow
- Cannot borrow as mutable due to existing inmutable borrow
- Cannot have multiple mutable borrows
- Cannot move while borrow exists
- Cannot use moved value

![img](../slices.png "Slices")


## Structs & Enums

- Sample of Struct
```rust
#[derive(Debug, Deserialize)]
pub struct Global {
    pub repository_path: String,
    pub content_root_path: String,
}

#[derive(Debug, Deserialize)]
pub struct Settings {
    pub debug: bool,
    pub global: Global,
}

let config = matches.value_of("config").unwrap();
let settings = Settings::new(config).unwrap()
println!("You have all of this topics at {}/{}:\n",
        settings.global.repository_path, 
        settings.global.content_root_path);
```

- Sample of enums
```rust
#[derive(PartialEq)]
enum Animal {
    Cat,
    Dog,
}

// This will fail because are not the same animal.
fn main() {
    let pet = Animal::Dog;
    let other_pet = Animal::Cat;

    assert!(pet == other_pet);

}
```

- Sample Enums with match in a complex one
```rust
enum Action {
    Drive,
    Turn(Direction),
    Stop
}

enum Direction {
    Left,
    Right,
}

print_action(a: Action) {
    match a {
        // The compiler will take care about to cover all cases
        Action::Drive => println!("Go Forward"),
        Action::Turn(direction) => match direction {
            // This is chcking inside of Direction enum
            Direction::Left => println!("Turn Left!!"),
            Direction::Right => println!("Turn Right!!"),
        }
        Action::Pickup => println!("Pick up Object!"),
        Action::Stop => println!("Stop!")
    }
}


fn main() {
    let program = vec![
        Action::Drive, 
        Action::Turn(Direction::Left), 
        Action::Drive, 
        Action::Pickup,
        Action::Turn(Direction::Left), 
        Action::Turn(Direction::Left), 
        Action::Turn(Direction::Left), 
        Action::Drive,
        Action::Turn(Direction::Right),
        Action::Drive,
        Action::Stop
    ];
    for action in program {
        print_action(action)
    }
}
```

- A Machine State to manage text and format it
```- 
#[derive(Copy, Clone)]
enum MachineState {
    Normal,
    Comment,
    Upper,
    Lower,
}

fn machine_cycle(state: MachineState, c: char) -> (Option<char>, MachineState) {
    use self::MachineState::*;

    match (state, c) {
        (Normal, '#') => (None, Comment),
        (Normal, '^') => (None, Upper),
        (Normal, '_') => (None, Lower),
        (Normal, other) => (Some(other), Normal),
        (Comment, '#') => (None, Normal),
        (Comment, _) => (None, Comment),
        (Upper, '^') => (None, Normal),
        (Upper, other) => (Some(other.to_ascii_uppercase()), Upper),
        (Lower, '_') => (None, Normal),
        (Lower, other) => (Some(other.to_ascii_lowercase()), Lower),
    }
}

fn main(){
    let mut state = MachineState::Normal;
    let mut processed_string = String::new();

    let input = "This _Is_ some ^input^. #we want this trnasformed without this comment#";

    for character in input.chars() {
        let (output, new_state) = machine_cycle(state, character);

        if let Some(c) = output {
            processed_string.push(c);
        }

        state = new_state;
    }

    println!("{}", processed_string);
}
```

- Input:
```
"This _Is_ some ^input^. #we want this trnasformed without this comment#"
```

- Output:
```
This is some INPUT.
```

## Traits and Generics

- Traits:
    - Allow us to group types based on behaviour
    - Like anything that can be read from, such as a file or a network conn has the Read trait
    - Similar to interfaces in OOP (Object Oriented Programming)

- Non-so much useful sample xD
```rust
struct Foo {x: u32}

trait Print {
    fn print(&self);
}

impl Print for Foo {
    fn print(&self) {
        println!("{}", self.x)
    }
}

// To call this implementation just use this snippet 
// let a = Foo {x = 20};
// a.print()
```

- Practical sample
```rust
struct config {
    has_config: bool,
    file_name: String,
    path: String,
}

trait Create {
    fn create(&self);
}

impl Create for config {
    fn create(&self) {
        if (self.has_config) {
            File::create(format!("{}/{}", self.path, self.file_name));
        }
    }
}
```

- More practical samples
```rust
struct Dwarf {
    name: String
}

struct Elf {
    name: String
}

struct HalfOrc {
    name: String
}

struct Human {
    name: String
}

pub trait Constitution {
    fn constitution_bonus(&self) -> u8 {
        0
    }
}

impl Constitution for HalfOrc {
    fn constitution_bonus(&self) -> u8 {
        1
    }
}

impl Constitution for Dwarf {
    fn constitution_bonus(&self) -> u8 {
        2
    }
}

fn main() {

    let my_dwarf = Dwarf {name: String::from("ParriDwarf")};
    let my_horc = HalfOrc {name: String::from("ParriHOrc")};

    println!("{}", my_dwarf.constitution_bonus());
    println!("{}",my_horc.constitution_bonus());
}
```

- Built-in traits 
    - Non-partial means infallible
    - Eq/PartialEq: Allow values to be compared and put in order
        - Some floating point ops, will just implement a PartialEq because could compared with themselves and return false
        
    - Ord/PartialOrd: Ordering elements of the same type
    ```
    if a < b && b < c {
        a < c
    }
    if a == b && b == c {
        a == c
    }
    ```
    - Display: allows you to format with the default formatter, fit for users to read
    ```
    println!("{}", display);
    ```
    - Debug: Similar to display but for debug situations
    ```
    println!("{:?}", debug);  // non-pretty view
    println!("{:#?}", debug); // pretty view
    ```
    - Clone: Allows a value to be explicitly cloned
    ```
    let a = foo();
    let b = a.clone();
    ```
    - Copy: Do the same as clone but the compiler will do it for you.
    - Iterator: Allows the `for ... in ...` syntax to work on HashMap, Vec, LinkedList, ... and many others collections


- Generic functions
    - Create functions with generic type parameters
    ```rust
    fn print<T: Display>(t: T) {
        println!("{}", t);
    }
    ```
    
    - As you see you need to ensure that the type that are you passing to the function supports this trait, in this case, you need to pass all the types that support `Display` trait
    - with generic functions you will gain some flexibility without describe the entry parameter, but you need to implement the `Trait` and the function associated
    - Very useful to re-use code and avoid DRY

- Generic Types
    - Allows you to be more concise with your code
    - Useful when creating collections and other data structures
    - Allows users of a library more flexibility
    - Sample:
    ```rust
    struct Tagged<T> {
        value: T,
        tag: String.
    }

    impl<T> Tagged<T> {
        fn tag(&self) -> String {
            self.tag.clone()
        }
    }
    ```

    - Existing Generic Types:
        - Vec, HashMap, LinkedList
        - Smart Pointers(
            // Single Value + Extra functionality
            - Box
            - Arc: Atomic Reference Counting
            - Rc: Reference Counting
            - Mutex
            - etc...
        )
        - Option and result types

- Static Distpatching
    - The usual way of work is using Static Dispatch which involves static basic functions with explicit arguments types and a clear return type.
    - When we use the generic types, the compiler takes care of catch the generic function and create all the possiblities in a process called "Monomorphization"

    ![img](../monomorphization.png "monomorphization process")

    - Monomorphization characteristics:
        - Extremely fast (no extra pointers)
        - Requires static reasoning about types
            - The compiler need to know extacly which type you are going to use at compile time in each instance because it just swaps out function call
        - No runtime heterogeneity of types
            - You can't have a function that you don't know when it's passed a variable, what type that variable is, then here is where Dynamic Distpatching comes in.

- Dynamic Distpatching
    - Dynamic distpatch looks up the correct functions at runtime
    - Performance penalty because an extra pointer lookup is required
    - Can deal with runtime heterogeneity
    - Sample:
    ```rust
    fn show_all(v: Vec<&dyn Display>) {
        for item in v {
            println!("{}", item);
        }
    }

    fn main() {
        // Here we force the reference to 12 to be a Display trait type, also with the String
        // and then we passes them to show_all function which receives a Dynamic Vector that contains
        // just Display types, and then get them printed.
        let v = vec![&12 as &Display, &"Hi all!" as &Display];
        // This is quite important because in the end we've changed the morpholoy
        show_all(v);
    }
    ```
        - Monomorphization is preferred, and you need to be sure that you want to use this feature
        - Ugly sintax and also long compile times
        - It uses v-tables, introduction to extra pointer lookup

    ![img](../extra_pointer_lookup.png "pointer lookup")

        - Which means:
            We have a Pointer to the argumment (cannot be passed by value), then you have a pointer to the v-table and this v-table will have a pointer to a function which is actually called. This have a very serious performance penalty like in an example Dyn Distpatch it's called in a loop in a performance critical section of the code


## Functional features and Concurrency

- Closures:
    - It's an element that captures its environment or closes over it
    - It is defined in line with other code and can access bindings declared in that code
    - They are anonymous and their types cannot be named
    - sample:
    ```rust
    fn main() {
        let closure1 = |x| { x + 1 };
        println!("{}", closure1(2));
        //prints 3
    }
    ```
    - Is written with `| arg1, arg2, argN |`
    - It implements one of the Fn family of traits, meaning it can be called with the () syntax, like a function.
    - sample:
    ```rust
    fn main() {
        let val = 10;
        let closure2 = |x| { x + val };
        println!("{}", closure2(2)); 
        // Prints 12
    }
    ```
    - We cannot write the type of a function
    - It's called an anonymous type of unspeakable type
    - This will give us an error:
    ```rust
    fn main() {
        let c: Type = |x| { x + 1 };
    }
    ```
    - To return it or accept it in a function, we must use generics or a dynamic trait object
    - sample:
    ```rust
    fn <T: Fn(i32) -> i32> f1()-> T {
        let f = |x| { x + 1 };
        return f;
    }

    fn f2() -> Box<dyn Fn(i32) -> i32 > {
        let f = |x| { x + 1};
        return f;
    }
    ```

    - Fn traits
        - Fn: Can run any number of times, only using inmutable bindings, Does not allocate memory because does not take ownership of anything
        - FnMut: Can run any number of times, only using Mutable and Inmutable bindings. Does not allocate Memory because does not take ownership of anything
        - FnOnce: Can run Once, taking ownership of captured bindings, Allocates mem

- Threads
    - Any FnOnce can be spawned into a thread
    - sample:
    ```rust
    use std::thread

    let handle = thread::spawn(|| {
        println!("From a thread!");
    });
    println!("Before a thread!")

    // Wait for execution
    handle.join();
    ```
    - This is done using std::thread::spawn
    - It creates a full OS threads, not green like Go or coroutines like Lua
    - Fn Trait separation makes concurrency fearless

- Iterators
    - Iterators are types which implement the iterator trait method, requiring a .next() method associated to the type
    - There are 3 methods which generally create iterators:
        - `x.into_iter()`: Gives an iterator over T
        - `x.iter_mut()`: Gives an iterator over &mut T
        - `x.iter()`: Gives an iterator over &T
    - Sample:
    ```rust
    let mut iterator = (1..5).into_iter();
    iterator.next(); //Some(1)
    iterator.next(); //Some(2)
    iterator.next(); //Some(3)
    iterator.next(); //Some(4)
    iterator.next(); //None
    iterator.next(); //None
    iterator.next(); //None
    ```
    - when the iterator gets exhausted, returns `None`
    - Other methods:
        - `take()` & `skip()` Sample code:
        ```rust
        let mut iterator(1..10).into?iter();
        iterator.skip(2);
        iterator.next(); //Some(3)
        let taken = iterator.take(2);
        taken.next(); //Some(4)
        taken.next(); //Some(5)
        taken.next(); //None
        ```

    - `enumerate()`:
    ```rust
    let mut iterator = vec![
        "A",
        "B",
        "C"].into_iter();
    let enumerated = iterator.enumerate();
    enumerated.next(); //Some((0, "A"))
    enumerated.next(); //Some((1, "B"))
    ```
- Iterators are Lazy!, this is important because just store in memory the actual value and the next one, the you could use it on a interator without exhaust the memory
- You could also concile the iterator using the trait `collect()`
```rust
let mut iterator = (1..10).into_iter();
iterator.skip(2);
let taken = iterator.take(4);
lev v: Vec<i32> = taken.collect();
// vec![3,4,5,6]
```

- Map, Filer and Fold
    - Mixes iterators with closures for functional programming
    - Map allows runnin a function on each element of an interator in a sequence generating another iterator:
    ```rust
    let items = (1..10).into_iter();
    let other_items: Vec<i32> = items.map(|x| { x + 1 }).collect();
    ```
    this ^^ is like:
    ```rust
    let items = (1..10).into_iter();
    let mut other_items = Vec::new();
    for item in items {
        other_items.push(x + 1);
    }
    ```

    - Maps are lazy also and could be conbined any number of times:
    ```rust
    let items = (1..10).into_iter();
    let other_items: Vec<i32> = iter
        .map(|x| { foo(x, 12) }) //i32
        .map(|x| { bar(x, "Hello") }) //String
        .map(|x| { baz(x) }) //String
        .map(|x| { fuz(x, bar(x)) }) //i32
        .collect();
    ```
    - Filter
        - Accept or reject items from an iterator based on a predicate, a function takes a single item and returns a bool, if the item is false, is discardad, otherwise it is retained
        ```rust
        let items = (1..10).into_iter();
        let evens: Vec<_> = items
            .filter(|x| { x % 2 == 0 }).
            .collect();
        // vec![2,4,6,8]
        ```
    - Fold
        - Known as `reduce` in other langs
        - applies a function to each element from an iterator along with an accumulator:
        ```rust
        let items = (1..10).into_iter();
        items.fold(0, |sum, item| {
            sum + item
        });
        //45
        ```
    - put them together:
    ```rust
    (1..100).into_iter();
        .filter(|x| {2 % x == 1})
        .map(|x| {x * x})
        .filter(|x| {x % 5 != 0})
        .fold(0, |sum, x| {sum + x});
    ```
    - Functional style can be concise and still easy to read
    - in addition, because iterator ops, map and filter are lazy, the compiler can make function code extremelly speedy and mem efficient



## Epic Resources

- [Rust Playground](play.rust-lang.org)
- [Rust Cheatsheet](https://cheats.rs)
- [Rust By Example](https://doc.rust-lang.org/rust-by-example/)
- [Rust Programming Language (Book)](https://doc.rust-lang.org/book/)
