
### Call back vs promise

![[Pasted image 20250821113611.png]]

# JavaScript Async/Await: Complete Guide for Senior Developers


## **callbacks → promises → async/await**, with **simple examples**
## 🔹 1. Callback Functions

- A **callback** is a function passed as an argument to another function, executed after some work is done.
- 👉 **Problem:** callbacks can get messy (“callback hell”) when you chain multiple async operations.

```js
// Example: simulate fetching data with a delay
function getData(callback) {
  console.log("getData time: "+ new Date().toLocaleString())
  setTimeout(() => {
    console.log("setTimeout time: "+ new Date().toLocaleString())
    console.log("Data fetched!");
    callback("Here is your data");
  }, 1500);
}

// Using callback
getData((result) => {
  console.log("callback time: "+ new Date().toLocaleString())
  console.log("call back data : "+result);
});
```
---

## 🔹 2. Promises

- A **Promise** represents a value that will be available **now, later, or never**.
- Has 3 states: `pending`, `fulfilled`, `rejected`.
- You use `.then()` and `.catch()` to handle results.
- 👉 **Improves readability** compared to nested callbacks.
```js
// Wrapping same example in a Promise
function getData() {
  return new Promise((resolve, reject) => {
    console.log("Executing Promise at " + new Date().toLocaleString())
    setTimeout(() => {
      console.log("Data fetched!");
      resolve("Here is your data");
      // ✅ Pass an object with multiple properties
      reject({
        message: "Something went wrong",
        timestamp: new Date().toLocaleString(),
        errorCode: "DATA_FETCH_ERROR",
        details: { userId: 123, operation: "getData" }
      });
    }, 1000);
  });
}

getData()
  .then((result) => console.log("then result: " + result +"at " + new Date().toLocaleString()))
  .catch((errorObj) => {
    console.error(`Error: ${errorObj.message}`);
    console.error(`Time: ${errorObj.timestamp}`);
    console.error(`Code: ${errorObj.errorCode}`);
    console.error(`Details:`, errorObj.details);
  });

```

>Note: 
>**Promise reject (and resolve) can only pass ONE argument**. When you call `reject(arg1, arg2)`, only the first argument is passed to the catch handler.
## 🔹 3. Async/Await

- `async` / `await` is **syntactic sugar over Promises**.
- Makes async code look **like synchronous code**.
- Easier to read & write.
```js
function getData() {
  return new Promise((resolve, reject) => {
    console.log("Executing Promise at " + new Date().toLocaleString())
    setTimeout(() => {
      console.log("Data fetched!");
      resolve("Here is your resolved data");
      // ✅ Pass an object with multiple properties
      // reject({
      //   message: "Something went wrong",
      //   timestamp: new Date().toLocaleString(),
      //   errorCode: "DATA_FETCH_ERROR",
      //   details: { userId: 123, operation: "getData" }
      // });
    }, 1000);
  });
}
  // Using async/await
async function fetchData() {
  try {
    const result = await getData(); //Toggle "await", waits until Promise resolves
    console.log(result + " at "+new Date().toLocaleString());
  } catch (err) {
    console.error(err.message+" at "+new Date().toLocaleString());
  }
}

fetchData();
```
## 🔑  Summary

- **Callback:** Pass function into another → leads to callback hell in complex flows.
- **Promise:** Cleaner, uses `.then()`/`.catch()`, avoids deep nesting.
### callbacks → promises → async/await with api call example
We have 3 async functions (simulated with `setTimeout`):
```js
function getUser(callback) {
  setTimeout(() => callback({ id: 1, name: "Alice" }), 1000);
}

function getOrders(userId, callback) {
  setTimeout(() => callback([{ id: 101 }, { id: 102 }]), 1000);
}

function getOrderDetails(orderId, callback) {
  setTimeout(() => callback({ orderId, item: "Book", price: 200 }), 1000);
}
```
1️⃣ Using **Callbacks**
👉 Works, but **nested** → “Callback Hell”.
```js
getUser((user) => {
  console.log("User:", user);
  getOrders(user.id, (orders) => {
    console.log("Orders:", orders);
    getOrderDetails(orders[0].id, (details) => {
      console.log("Order Details:", details);
    });
  });
});
```
2️⃣ Using **Promises**
👉 Cleaner than callbacks, but `.then()` chaining can still grow.
```js
function getUser() {
  return new Promise((resolve) => {
    setTimeout(() => resolve({ id: 1, name: "Alice" }), 1000);
  });
}

function getOrders(userId) {
  return new Promise((resolve) => {
    setTimeout(() => resolve([{ id: 101 }, { id: 102 }]), 1000);
  });
}

function getOrderDetails(orderId) {
  return new Promise((resolve) => {
    setTimeout(() => resolve({ orderId, item: "Book", price: 200 }), 1000);
  });
}

// Chain with .then()
getUser()
  .then((user) => {
    console.log("User:", user);
    return getOrders(user.id);
  })
  .then((orders) => {
    console.log("Orders:", orders);
    return getOrderDetails(orders[0].id);
  })
  .then((details) => console.log("Order Details:", details))
  .catch((err) => console.error(err));

```
3️⃣ Using **Async/Await (Sequential)**
👉 Looks like **synchronous code**, easiest to read & debug.

```js
function getUser() {
  return new Promise((resolve) => {
    setTimeout(() => resolve({ id: 1, name: "Alice" }), 1000);
  });
}

function getOrders(userId) {
  return new Promise((resolve) => {
    setTimeout(() => resolve([{ id: 101 }, { id: 102 }]), 1000);
  });
}

function getOrderDetails(orderId) {
  return new Promise((resolve) => {
    setTimeout(() => resolve({ orderId, item: "Book", price: 200 }), 1000);
  });
}

async function fetchData() {
  try {
    const user = await getUser();
    console.log("User:", user);

    const orders = await getOrders(user.id);
    console.log("Orders:", orders);

    const details = await getOrderDetails(orders[0].id);
    console.log("Order Details:", details);
  } catch (err) {
    console.error(err);
  }
}

fetchData();

```

## 🔹 Parallel vs Sequential Execution

### ✅ Sequential (waits one by one)
⏱ Total Time ≈ 3 seconds (1s + 1s + 1s).
```js
function getUser() {
  return new Promise((resolve) => {
    setTimeout(() => resolve({ id: 1, name: "Alice" }), 1000);
  });
}

function getOrders(userId) {
  return new Promise((resolve) => {
    setTimeout(() => resolve([{ id: 101 }, { id: 102 }]), 1000);
  });
}

function getOrderDetails(orderId) {
  return new Promise((resolve) => {
    setTimeout(() => resolve({ orderId, item: "Book", price: 200 }), 1000);
  });
}

async function sequentialExample() {
  console.log("Inside sequentialExample function start time"+new Date().toLocaleString())
  const user = await getUser();
  const orders = await getOrders(user.id);
  const details = await getOrderDetails(orders[0].id);
  console.log(user, orders, details);
  console.log("Inside sequentialExample function end time"+new Date().toLocaleString())
}
console.log("Start time: "+new Date().toLocaleString())
sequentialExample()
console.log("End time"+new Date().toLocaleString())
```
✅ Parallel (run all at once with `Promise.all`)
⏱ Total Time ≈ 1 second (all run together).
**Sequential vs Parallel**:
- Sequential (`await` one by one) = slower but needed when order matters.
- Parallel (`Promise.all`) = faster when tasks are independent.

```js
function getUser() {
  return new Promise((resolve) => {
    setTimeout(() => resolve({ id: 1, name: "Alice" }), 1000);
  });
}

function getOrders(userId) {
  return new Promise((resolve) => {
    setTimeout(() => resolve([{ id: 101 }, { id: 102 }]), 1000);
  });
}

function getOrderDetails(orderId) {
  return new Promise((resolve) => {
    setTimeout(() => resolve({ orderId, item: "Book", price: 200 }), 1000);
  });
}

console.log("Start time: "+new Date().toLocaleString())
parallelExample()
console.log("End time"+new Date().toLocaleString())

async function parallelExample() {
  console.log("Inside parallelExample function start time"+new Date().toLocaleString())
  const [user, orders, details] = await Promise.all([
    getUser(),
    getOrders(1),
    getOrderDetails(101),
  ]);
  console.log(user, orders, details);
  console.log("Inside parallelExample function end time"+new Date().toLocaleString())
}
```

### Q1: What is the difference between `var`, `let`, and `const`?

**Model Answer:**

- `var`: function-scoped, hoisted, allows redeclaration.
- `let`: block-scoped, no redeclaration, hoisted but in temporal dead zone.
- `const`: block-scoped, must be initialized, cannot be reassigned (but objects can be mutated).  
    👉 Best practice: use `const` by default, `let` when reassignment needed.
### Q2: How does **event loop** work in JavaScript? What are **microtasks** vs **macrotasks**?

**Model Answer:**

- JS is single-threaded → event loop manages async operations.
- **Macrotasks**: `setTimeout`, `setInterval`, I/O.
- **Microtasks**: `Promises`, `process.nextTick` (executed before macrotasks).  
    👉 Order: current stack → microtasks → next macrotask.
### Q3: Difference between `==` and `===`?

**Model Answer:**
- `==`: loose equality (performs type coercion).
- `===`: strict equality (no coercion, type + value must match).  
    👉 Always prefer `===`.
 **`===` (Strict Equality)**

- Compares **both value AND type**
- **No type conversion** happens
**`==` (Loose Equality)**

- Compares **value only**
- **Automatic type conversion** (coercion) happens
```js
// === Strict Equality Examples
console.log(5 === 5);        // true (same value, same type)
console.log(5 === "5");      // false (same value, different type)
console.log(true === 1);     // false (different type)
console.log(null === undefined); // false (different types)

// == Loose Equality Examples  
console.log(5 == 5);         // true (same value, same type)
console.log(5 == "5");       // true (different type, but coerced to same value)
console.log(true == 1);      // true (true coerced to 1)
console.log(null == undefined); // true (special case in coercion rules)

// Edge Cases
console.log(0 == false);     // true (false coerced to 0)
console.log("" == false);    // true (both coerced to 0)
console.log([] == false);    // true ([] coerced to "" then to 0)
console.log({} == false);    // false ({} coerced to "[object Object]")

```
### Q4: Explain closures. Give me an example.

**Model Answer:**  
A closure is when an inner function “remembers” variables from its outer scope, even after the outer function has finished execution.
```js
function counter() {
  let count = 0;
  return function () {
    count++;
    return count;
  };
}

const inc = counter();
console.log(inc()); // 1
console.log(inc()); // 2

```
### Q5: How would you handle multiple API calls where the second depends on the first?

**Model Answer:**  
Use **sequential `await`** if dependent. If independent → use `Promise.all`.  
Example:
```js
const user = await getUser();
const orders = await getOrders(user.id);
```
### Explain `interface` vs `type` in TypeScript.

**Model Answer:**

- `interface`: extendable, primarily for object shapes.
- `type`: more flexible, can alias primitives, unions, intersections.
- Modern TS allows most overlap, but prefer `interface` for object contracts, `type` for complex compositions.
>At first glance, they look identical for object shapes, but the differences become important in advanced scenarios.

**interface**
```js
// Interface - describes the shape of an object
interface User {
  id: number;
  name: string;
  email: string;
  isActive?: boolean;
}

// Usage
const user: User = {
  id: 1,
  name: "John Doe",
  email: "john@example.com"
};

```
**Type Alias**
```js
// Type alias - creates a new name for any type
type User = {
  id: number;
  name: string;
  email: string;
  isActive?: boolean;
};

// Usage (identical to interface)
const user: User = {
  id: 1,
  name: "John Doe", 
  email: "john@example.com"
};

```
## **Interface: Declaration Merging**
```ts
// ✅ Interfaces can be merged/extended automatically
interface User {
  id: number;
  name: string;
}

interface User {
  email: string;  // Merges with previous declaration
}

interface User {
  isActive?: boolean;  // Further extends
}

// Final interface has all properties
const user: User = {
  id: 1,
  name: "John",
  email: "john@example.com",
  isActive: true
};
```

```ts
// ❌ Types cannot be merged - this will error
type User = {
  id: number;
  name: string;
};

type User = {  // Error: Duplicate identifier 'User'
  email: string;
};
```
**Type: Union Types & Primitives**
```ts
// ✅ Type aliases can define unions, primitives, etc.
let myVariable: string | number;

myVariable = "hello"; // Valid, as 'myVariable' can be a string
myVariable = 123;     // Valid, as 'myVariable' can be a number
// myVariable = true; // Invalid, as 'myVariable' cannot be a boolean

// ❌ Interfaces cannot define these directly 
// interface Status { // Error: Interface can't represent union types // Cannot do: "pending" | "approved" | "rejected" }
```

## Extension Patterns

### **Interface Extension**
```ts
// ✅ Interface extends with 'extends' keyword
interface BaseEntity {
  id: number;
  createdAt: Date;
  updatedAt: Date;
}

interface User extends BaseEntity {
  name: string;
  email: string;
}

interface AdminUser extends User {
  permissions: string[];
  role: 'admin' | 'superadmin';
}

// Multiple inheritance
interface Timestamped {
  createdAt: Date;
  updatedAt: Date;
}

interface Versioned {
  version: number;
}

interface Document extends Timestamped, Versioned {
  title: string;
  content: string;
}
```

###  **Type Extension**
```ts
// ✅ Type intersection with '&'
type BaseEntity = {
  id: number;
  createdAt: Date;
  updatedAt: Date;
};

type User = BaseEntity & {
  name: string;
  email: string;
};

type AdminUser = User & {
  permissions: string[];
  role: 'admin' | 'superadmin';
};

// Complex intersections
type Timestamped = {
  createdAt: Date;
  updatedAt: Date;
};

type Versioned = {
  version: number;
};

type Document = Timestamped & Versioned & {
  title: string;
  content: string;
};

```

# What are Generics in TypeScript? Give me an example.

**Model Answer:**  
Generics provide type safety while keeping functions reusable.
👉 Useful in collections, reusable functions, and typed APIs.
```ts
function identity<T>(value: T): T {
  return value;
}

const num = identity<number>(42);
const str = identity("hello");

```
