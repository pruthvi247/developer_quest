### **Sample Data Recap**

`collection-name` :devices
```json
{
  "_id": "device1",
  "name": "Device 1",
  "address": "123 Main St",
  "location": "Berlin",
  "vmc": { "operatingMode": "battery" },
  "dispensers": {
    "1": { "name": "Cola", "setPoint": 100, "max": 120, "choice": "A", "article": "A1", "price": 2.5 },
    "2": { "name": "Water", "setPoint": 80, "max": 100, "choice": "B", "article": "B1", "price": 1.5 }
  },
  "issues": {}
}
```
![[Pasted image 20250821224145.png]]

`collection name`: history
```json
{
  "_id": "history1",
  "meta": { "machineId": "device1", "type": "webFilling" },
  "time": ISODate("2025-08-20T10:00:00Z"),
  "dispensers": [
    { "channel": 1, "newStock": 90 },
    { "channel": 2, "newStock": 70 }
  ]
}
```
![[Pasted image 20250821224240.png]]
`collection-name: logbook`
```json
{ "_id": "log1", "machineId": "device1", "time": ISODate("2025-08-20T10:05:00Z"), "logDataId": 12, "product": { "channel": 1 } }
{ "_id": "log2", "machineId": "device1", "time": ISODate("2025-08-20T10:10:00Z"), "logDataId": 12, "product": { "channel": 1 } }
{ "_id": "log3", "machineId": "device1", "time": ISODate("2025-08-20T10:15:00Z"), "logDataId": 12, "product": { "channel": 2 } }
{ "_id": "log4", "machineId": "device1", "time": ISODate("2025-08-20T10:20:00Z"), "logDataId": 19, "error": { "code": 524 }, "mdbDevice": 0 }
```
![[Pasted image 20250821224344.png]]


### What this query does:

- Finds all devices with dispensers.
- Looks up the latest web filling event for each device.
- Calculates sales per dispenser channel since the last web filling.
- Detects battery issues for devices in battery mode.
- Computes stock and sold levels for each dispenser.
- Returns all relevant details per device.

### Query walk through

### `$match`

```js
{ dispensers: { $exists: true } }
```

**Purpose:**  
Filters for devices that have a `dispensers` field.

**Result:**
```json
[
  {
    "_id": "device1",
    ... // all device fields
  }
]
```

### `$lookup` (history)
**Purpose:**  
Joins the latest webFilling event from `history` for each device.
```js
{
  $lookup: {
    from: "history",
    localField: "_id",
    foreignField: "meta.machineId",
    pipeline: [
      { $match: { "meta.type": "webFilling" } },
      { $sort: { time: -1 } },
      { $limit: 1 }
    ],
    as: "webFilling"
  }
}
```
`result`:
```js
[
  {
    "_id": "device1",
    ...,
    "webFilling": [
      {
        "_id": "history1",
        "meta": { "machineId": "device1", "type": "webFilling" },
        "time": ISODate("2025-08-20T10:00:00Z"),
        "dispensers": [
          { "channel": 1, "newStock": 90 },
          { "channel": 2, "newStock": 70 }
        ]
      }
    ]
  }
]
```
### `$addFields` (flatten webFilling)
**Purpose:**  
Extracts the latest webFilling event as an object, not an array.
```js
[
  {
    "_id": "device1",
    ...,
    "webFilling": {
      "_id": "history1",
      "meta": { "machineId": "device1", "type": "webFilling" },
      "time": ISODate("2025-08-20T10:00:00Z"),
      "dispensers": [
        { "channel": 1, "newStock": 90 },
        { "channel": 2, "newStock": 70 }
      ]
    }
  }
]
```
## `$lookup` (salesByDispensers)

**Purpose:**  
Counts sales per channel since the last webFilling.
```js
{
  $lookup: {
    from: "logbook",
    let: { id: "$_id", time: "$webFilling.time" },
    pipeline: [
      {
        $match: {
          $expr: {
            $and: [
              { $eq: ["$machineId", "$$id"] },
              { $gte: ["$time", "$$time"] }
            ]
          },
          logDataId: 12
        }
      },
      {
        $group: {
          _id: "$product.channel",
          sales: { $sum: 1 }
        }
      }
    ],
    as: "salesByDispensers"
  }
}
```
`result:`
```js
[
  {
    "_id": "device1",
    ...,
    "salesByDispensers": [
      { "_id": 1, "sales": 2 }, // channel 1 sold twice
      { "_id": 2, "sales": 1 }  // channel 2 sold once
    ]
  }
]
```
### Learning🚧 
##  `$let`:

- It lets you declare variables (`vars`) locally.
- You can then reference these variables in the `in` expression.
- These variables exist **only inside** the `$let` expression.
sample json: `to calculate: (price + tax) * (1 - discount)`
```json
{
  "price": 100,
  "tax": 10,
  "discount": 0.1
}
```
**`$let`** to avoid repeating expressions:
```json
/// We can consider it as aliases,
{
  $project: {
    finalPrice: {
      $let: {
        vars: {
          total: { $add: ["$price", "$tax"] },
          discountAmt: { $subtract: [1, "$discount"] }
        },
        in: { $multiply: ["$$total", "$$discountAmt"] }
      }
    }
  }
}

```

## `$match` stage with `$expr`:
```js
{
  $match: {
    $expr: {
      $and: [
        { $eq: ["$machineId", "$$id"] },   // Match logbook.machineId with the current document's _id
        { $gte: ["$time", "$$time"] }      // Only include logs with time >= current document's webFilling.time
      ]
    },
    logDataId: 12                          // Additional fixed filter: only log entries with logDataId = 12
  }
}

```
- `$expr` allows usage of aggregation expressions for field comparisons.
- This filters `logbook` records relevant to the current device (`machineId == id`) and newer or equal to the device's latest filling time.
- The additional `logDataId: 12` filters log entries of a certain type related to sales.
### `$group`

```js
{
  $group: {
    _id: "$product.channel",    // Group sales by dispensing channel
    sales: { $sum: 1 }          // Count number of sales per channel
  }
}
// Groups matched logbook documents by the `product.channel`.
    
// Sums the count of documents (= number of sales) for each channel.
```
`result`: 
```js
[
  {
    "_id": "device1",
    ...,
    "salesByDispensers": [
      { "_id": 1, "sales": 2 }, // channel 1 sold twice
      { "_id": 2, "sales": 1 }  // channel 2 sold once
    ]
  }
]
```

## `$lookup` (batteryIssues)
Finds battery issues for devices in battery mode.

```js
{
  $lookup: {
    from: "logbook",
    let: { id: "$_id", time: "$webFilling.time" },
    pipeline: [
      {
        $match: {
          $expr: {
            $and: [
              { $eq: ["$machineId", "$$id"] },
              { $gte: ["$time", "$$time"] }
            ]
          },
          logDataId: 19,
          "error.code": 524,
          mdbDevice: 0
        }
      },
      { $sort: { time: -1 } },
      { $limit: 1 }
    ],
    as: "batteryIssues"
  }
}
```
`sample output`;
```js
[
  {
    "_id": "device1",
    ...,
    "batteryIssues": [
      {
        "_id": "log4",
        "machineId": "device1",
        "time": ISODate("2025-08-20T10:20:00Z"),
        "logDataId": 19,
        "error": { "code": 524 },
        "mdbDevice": 0
      }
    ]
  }
]
```