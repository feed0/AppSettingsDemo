# AppSettingsDemo: Singleton design pattern in Swift

AppSettings is a singleton class that offers:
- a `settings` **dictionary**,
- and **read** and **write** methods for its keys and values
    - `int(forKey:) -> Int`
    - `string(forKey:) -> String`
- through its `shared` instance.

## Concurrency issue

> When a thread tries to **read** some key's value using `.int(forKey:) -> Int`,
<br> while other thread tries to **update** some key's value using `set(value:forKey:)`,
<br> an **_EXCUTION_BAD_ACCESS_** _crash_ happens.

### Reproduce

1. Clone the repo
1. **Switch** to commit 4 _53f482271e975ee852059dfd35158ab9aadc5a38_
1. **Run** only `testConcurrentUsage()` until a crash happens
1. Take a **look** at each thread on Xcode's Debug Navigator _(cmd + 7)_

### Understand

#### The test

- A concurrent queue for writes
- A read op that might eventually happen during the write ops, resulting in a **data race**.

```swift
    func testConcurrentUsage() {
        let concurrentQueue = DispatchQueue(
            label: "concurrentQueue",
            attributes: .concurrent)
        
        let expect = expectation(
            description: "Using AppSettings.shared from multiple threads shall succeed.")
        
        let callCount = 100

        /// write ops
        for callIndex in 1...callCount {
            concurrentQueue.async {
                AppSettings.shared.set(
                    value: callIndex,
                    forKey: String(callIndex))
            }
        }

        /// read op
        while AppSettings.shared.int(forKey: String(callCount)) != callCount {
            /// nop
        }
        
        expect.fulfill()
        
        waitForExpectations(timeout: 5) { (error) in
            XCTAssertNil(error, "Test expectation failed")}     
    }
```

#### The crash

- Yellow dashed boxes on the left panel highlight the threads accessing with `AppSettings.int(forKey:)` and threads updating with `AppSettings.set(value:forKey:)`.
- Magenta dashed boxes on the right panel highlight one of the threads' call stack

<img 
  width="1449" 
  height="1161" 
  alt="thread EXCUTION_BAD_ACCESS crash" 
  src="https://github.com/user-attachments/assets/c9cd06ac-2a46-4bf6-9e88-1d8a49b90aa4" />

