//
//  DebouncerTests.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import XCTest

@testable import MeowMatch
var logT = LogWriter(.init(value: "TEST"), attributes: [.prefix, .duration])
final class DebouncerTests: XCTestCase {
    
    func testDebouncer_ExecutesTaskAfterDelay() async {
        let debouncer = AsyncDebouncer<String, [String]>(delay: 0.5)
        debouncer.config { _ in
           return ["cat"]
        }

        let expectation = XCTestExpectation(description: "Debounced task executed")
        
        debouncer.debounce(input: "c") { result in
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0) // Wait for execution
    }
    
    func testDebouncer_IgnoresDuplicateInput() async {
        let debouncer = AsyncDebouncer<String, [String]>(delay: 0.5)
        let expectation = XCTestExpectation(description: "Task should execute only once")
        expectation.expectedFulfillmentCount = 1 // Ensure it's only called once
        var count = 0
        debouncer.config { _ in
            count += 1
           return ["cat"]
        }

        debouncer.debounce(input: "c") { result in
            expectation.fulfill()
        }
        
        // Schedule the same input again before the delay finishes
        debouncer.debounce(input: "c") { result in
            expectation.fulfill()
        }

        
        await fulfillment(of: [expectation], timeout: 1.0) // Ensure task runs only once
    }
    
    func testDebouncer_CancelsPreviousTask() async {
        let debouncer = AsyncDebouncer<String, [String]>(delay: 0.5)
        let expectation = XCTestExpectation(description: "Only the last task should execute")
        expectation.expectedFulfillmentCount = 1 // Only last call should run

        debouncer.config { _ in
           return ["cat"]
        }

        debouncer.debounce(input: "c") { result in  expectation.fulfill() }

        // Schedule another task before the first one executes
        debouncer.debounce(input: "ca") { result in  expectation.fulfill() }

        await fulfillment(of: [expectation], timeout: 2.0) // Ensure only one execution
    }
    
    func testDebouncer_ForStale_Response() async {
        let debouncer = AsyncDebouncer<String, [String]>(delay: 0.4)
        let expectation = XCTestExpectation(description: "Each unique input should trigger execution")
        expectation.expectedFulfillmentCount = 1 // Both "one" and "two" should execute

        debouncer.config {
            if $0 == "ca" {
                logT.logI("ca.just.started")
                try? await Task.sleep(nanoseconds: 650_000_000)
                logT.logI("ca")
                return ["kat","cat"]
            } else {
                try? await Task.sleep(nanoseconds: 150_000_000)
                logT.logI("cat")
                return ["cat"]
            }
        }
        logT.logI("ca.started")
        debouncer.debounce(input: "ca") { result in
            logT.logI("ca.ended")
            expectation.fulfill() }

        try? await Task.sleep(nanoseconds: 500_000_000)

        logT.logI("cat.started")
        debouncer.debounce(input: "cat") { result in
            logT.logI("cat.ended")
            expectation.fulfill() }// Different input should execute

        await fulfillment(of: [expectation], timeout: 8.5) // Ensure both executions happen
    }
}
