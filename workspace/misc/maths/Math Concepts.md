[source](https://levelup.gitconnected.com/5-mathematical-concepts-for-better-programming-d26005932656)
#### 1.SETS
## Notations

-   Ø is a **Null set** i.e. A set that does not have any elements.
-   μ is the **Universal Set** i.e. the set of all the elements of all the sets which are being considered for set operations
-   A’ **is the complement** of a Set**:** A set that includes all the elements that are not part of the universal set i.e. (A’ = μ — A)
-   x **∈** A represents that x **_is a member of_** A.  
    For example, a person (x) in a set of the population of France (A).
-   A **⊂** B represents that A **_is a subset of_** B.  
    For example, the set of the population of France (A) is a subset of the set of the population of Europe (B).
-   ∪ represents the **Union** of two sets i.e. the combination of all the elements of two sets into a single set
-   **∩** represents the **Intersection** of two sets i.e. combining the common elements of the two sets into a new set

#### 2. Venn Diabrams

These are a scheme of representing sets and their operations diagrammatically.

#### 3.Prime number

A Prime Number is any natural number greater than 1, that can only be divided exactly by itself or 1.

A set of Prime numbers can be represented as `{2,3,5,7,11,13,17,...}`.

#### 4. Probability

It is a mathematical branch that deals with the likelihood of an event occurrence.

Mathematically represented by **P,** the probability of an event X occurring is **P(X)**.

> P (X) = Number of events where X occurs / Total number of possible outcomes

For example, the probability of getting heads in a coin toss is 1/2 or 50%.

#####  Rules of Probability

-   The probability of an event can only be between 0 and 1.
-   If two events are **independent** of each other’s occurrence, then the probability of both happening is given by **multiplying** their individual probabilities.

> P (X and Y) = P (X) * P (Y)

-   If two events are **mutually exclusive**, the probability of either one occurring is given by adding their individual probabilities.

> P (X or Y) = P (X) + P (Y)

#### 5.Calculus

It is a mathematical branch that is concerned with continuous change.

Its two major branches deal with:

-   the rate of change/ gradient of a quantity (**_differential calculus_**)
-   summation of infinitely many small quantities to calculate the whole (**_integral calculus_**)
- 
Differentiation represents the rate of change of a function. Integration represents an accumulation or sum of a function over a range. They are kind of inverses of each other.

##### Differentiation

It is used to calculate the **gradient/ slope/ tangent** of a mathematical curve.

It can also be used to find the smallest (**_minima_**) and largest value (**_maxima_**_)_ of a function.

For a curve with an equation of `y= x^n`, the gradient of y with respect to x (`dy/dx`) is given by `n * x^(n-1)` .

** Rules of Differentiation**
-   `d(n)/dx = 0`
-   `d(x)/dx = 1`
-   `d(x^n)/dx = n * x^(n-1)`
-   `d(e^x)/dx = e^x`
-   `d(ln x)/dx = 1/x`
-   `d(n^x)/dx = n^x * ln(x)`
-   `d(sin x)/dx = cos x`
-   `d(cos x)/dx = — sin x`

##### Integration

It is the inverse of differentiation.

It is commonly used for calculating areas and volumes of shapes.

For an equation `y = x^n` , the integral of y is given by:

> ∫y dx = ∫ (x^n) dx = (1/n+1) * (x^n+1) + C

where C is a numerical constant.

#### 6. Correlation

A term introduced by **_Francis Galton_**, Correlation is a property that demonstrates how two variables are **associated** with each other.

It determines how varying one variable changes the other.

The **Pearson correlation coefficient** / **Pearson’s _r (ρ)_** measures this correlation on a scale from -1 to 1 where:

-   0 — No correlation
-   -1 — Anti-correlation
-   1 — Perfect correlation

> **Correlation does not imply causation.**
> The number of ice creams sold on a particular day and the number of children born on that day may correlate but this does not mean that one is the cause of another.


#### 7. Regression

It is a process of mathematically estimating the relationships between a dependent variable and one or more independent variables.

Two types of regression models are explained below.

##### Linear Regression

It is an approach to modeling the **linear relationship** between different variables.

This relation can be between:

-   two variables (plotted on a 2-D plane) or
-   multiple variables (plotted on a multi-dimensional plane)

The relation between two variables can be represented as:

> `y = m*x + c`
> where x is the independent variable and y is the dependent variable.

Linear regression as a machine learning model can be used to predict **continuous variables** as opposed to classification.

For example, estimating the temperature (a continuous variable) at a particular time of the day.

###### Logistic Regression

This approach estimates the probability of an event occurring (that **_lies between 0 and 1_**) based on given independent variables.

Logistic Regression as a machine learning model is used for **classification** tasks (**as opposed to regression tasks**).
These classification tasks can either be:

-   binary (classification between 2 outcomes)
-   multi-class (classification between more than 2 outcomes)
eg:  Logistic regression is used to classify the probability of passing the exam based on the number of hours of study.

#### Vectors

A Vector is a **one-dimensional matrix**.

It can be written as a list of numbers.

Matrices with a single row are called **_row vectors_** (`1 x n` dimensional).

Matrices with a single column are called **_column vectors_** (`n x 1` dimensional).

#### Congruence

Given two numbers `a` and `b`, if the difference of these numbers ( `k = a-b` ) is exactly divisible by another number `n` :

> `_a_` _and_ `_b_` _are said to be_ **_congruent modulo n_**

> **a ≡ b (mod n)**

** Applications**

Modulo Arithmetic is used in:

-   [Public Key Cryptography](https://en.wikipedia.org/wiki/Public-key_cryptography) uses [Modular Exponentiation](https://en.wikipedia.org/wiki/Modular_exponentiation)
-   [Bitwise Operations](https://en.wikipedia.org/wiki/Bitwise_operation) (e.g. [XOR](https://en.wikipedia.org/wiki/XOR) sums 2 bits, modulo 2)
-   [International Bank Account Numbers](https://en.wikipedia.org/wiki/International_Bank_Account_Number) (IBANs) use **modulo 97** arithmetic to spot user input errors in bank account numbers
-   Computer algebra algorithms (e.g. [Polynomial Factorisation](https://en.wikipedia.org/wiki/Factorization_of_polynomials))

#### Hexadecimal Numbers

There are numbers that follow the **Base(16)** number system.

These are represented by the set below:

`{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F}`

Hexadecimal numbers are commonly used:

-   To represent memory addresses
-   To represent Media Access Control (MAC) addresses
-   To define colors

##### Conversion of Hexadecimal To Decimal

To convert a Hexadecimal number to a Decimal, we use the **Base(16)**notation as follows:

> `_1_` _(hexadecimal) =_ `_1_` _x 16⁰=_ `_1_` _(decimal)_
> 
> `_1ED2_` _(hexadecimal) =_ `_1_` _x 16³+_ `_E_` _x 16²+_ `_D_` _x 16¹+_ `_2_`_x 16⁰=_ `_7890_` _(decimal)_

##### Conversion of Hexademical To Binary

The steps to perform this are as follows:

-   Split the hexadecimal number into single values
-   Convert each value to a decimal number
-   Convert the decimal number to a binary number with 4 bits
-   Combine them all together

For example, `1ED2` is binary is:

-   `1` -> `1` (decimal) -> `0001` (binary)
-   `E` -> `14` (decimal) -> `1110` (binary)
-   `D` -> `13` (decimal) -> `1101` (binary)
-   `2` -> `2` (decimal) -> `0010` (binary)

Combine them all to get the result: `0001111011010010` or `1111011010010`

# Endianness

It is the order or sequence of bytes used when storing data in computer memory.

## Big-endian System

Here, the **most** significant byte of multi-byte data is stored at the **smallest**memory address and the least significant byte at the largest.

Before transferring data on a network, data is first converted to big-endian.

![](https://miro.medium.com/max/700/0*nXLsjMDYBPYhJSUI.png)
#### Boolean logic
The truth tables for all the gates described above can be summarized as:

![[1*2pe7VH1_lsHrsisCwaRJjA.webp]]


#  Fibonacci Numbers

Fibonacci numbers were first described in India by Pingala.

> `1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...`

It is a sequence of whole numbers that can be obtained by adding the previous two numbers in the series.

This sequence commonly occurs in nature in form of:

-   branching in trees
-   the arrangement of leaves on a stem
-   number of spirals formed from the number of seeds in the spirals of a sunflower

#  Factorials

The Factorial of a number `n` is represented by `n!`.

It is the product of all positive integers less than or equal to n.

#  Permutations

It is the number of ways in which items can be arranged in a particular **_order_**.

-   For given `n` items, there are `n!` possible permutations.
-   If picking `k` items from a total of `n` items, the possible permutations are `n! / (n-k)!`.

For example, there are six permutations of the set `{1, 2, 3}`:

-   `(1, 2, 3)`
-   `(1, 3, 2)`
-   `(2, 1, 3)`
-   `(2, 3, 1)`
-   `(3, 1, 2)`
-   `(3, 2, 1)`
# Combinations

It is the number of ways in which items can be arranged **_without particular order._**

If picking `k` items from a total of `n` items, the possible combinations (`C (n, k)`) are:

> `n! / (k! * (n-k)!)`

For example, when picking up two items from the set `{1, 2, 3}`, there are three combinations of :

-   `(1, 2)`
-   `(1, 3)`
-   `(2, 3)`


#### Graph

A Graph is a mathematical structure that consists of:

-   **_vertices_** (also called _nodes_ or _points_) (**V**) which are connected by
-   **_edges_** (also called _links_ or _lines_) (**E**)

It is represented as:

> G = (V, E)

## Degree

The number of edges of a particular vertex is called its **Degree**.
##### Graphs & Types

** Directed Graph/ Digraph **

A **g**raph in which edges have orientations.

This means that an edge can only be transversed in one direction.

For example, a graph representing a Medium newsletter and its subscribers.
# Graphs & Types

## Directed Graph/ Digraph

A **g**raph in which edges have orientations.

This means that an edge can only be transversed in one direction.

For example, a graph representing a Medium newsletter and its subscribers.

## Undirected Graph

A **g**raph in which edges do not have orientations.

This means that an edge can be transversed bidirectionally.

For example, a graph representing the relationship between friends on Facebook.

## Cycle

A cycle is a graph with some of its vertices (at least 3) connected in a closed chain.

## Cyclic Graph

It is a graph with at least one cycle.
## Acyclic Graph

It is a graph with no cycles.

## Connected Graph

It is a graph with an edge from any vertex to another.

It can be:

-   **Strongly connected**: if there any bi-directional edge connections between all vertices
-   **Weakly connected**: if there are no bi-directional connections between all vertices

## Disconnected Graph

A graph with no connected vertices is called to be disconnected.

# Graph Transversal Algorithms

## Depth-first Search

**Depth-first search (DFS)** is an algorithm for searching graph data structures.

The algorithm starts at the root node and explores as far as possible along each branch before going back to the start.
## Breadth-first Search

**Breadth-first search** (**BFS**) is another algorithm for searching a graph data structure.

It starts at the root node and explores all nodes at a present branch prior to moving on to the nodes in the other branches.
# Logarithm

It is the **inverse** operation of raising a number to a power.

> _where_ `_log(b)_` _is called log to the base_ `_b_`_._

The commonly used base for logarithms are:

-   The logarithm base `10` (decimal or common logarithm)
-   The logarithm base `e` (natural logarithm)
-   The logarithm base `2` (binary logarithm)