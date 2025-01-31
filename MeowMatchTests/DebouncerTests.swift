//
//  DebouncerTests.swift
//  MeowMatch
//
//  Created by Vinsi.
//

import XCTest

@testable import MeowMatch

final class DebouncerTests: XCTestCase {
    
    func testDebouncer_ExecutesTaskAfterDelay() async {
        let debouncer = Debouncer<String>(delay: 0.5)
        let expectation = XCTestExpectation(description: "Debounced task executed")
        
        debouncer.schedule("test") {
            expectation.fulfill()
        }
        
        await fulfillment(of: [expectation], timeout: 1.0) // Wait for execution
    }
    
    func testDebouncer_IgnoresDuplicateInput() async {
        let debouncer = Debouncer<String>(delay: 0.5)
        let expectation = XCTestExpectation(description: "Task should execute only once")
        expectation.expectedFulfillmentCount = 1 // Ensure it's only called once
        
        debouncer.schedule("test") {
            expectation.fulfill()
        }
        
        // Schedule the same input again before the delay finishes
        debouncer.schedule("test") { 
            expectation.fulfill()
        }

        await fulfillment(of: [expectation], timeout: 1.0) // Ensure task runs only once
    }
    
    func testDebouncer_CancelsPreviousTask() async {
        let debouncer = Debouncer<String>(delay: 0.5)
        let expectation = XCTestExpectation(description: "Only the last task should execute")
        expectation.expectedFulfillmentCount = 1 // Only last call should run
        
        debouncer.schedule("first") { expectation.fulfill() }
        
        // Schedule another task before the first one executes
        debouncer.schedule("second") { expectation.fulfill() }

        await fulfillment(of: [expectation], timeout: 2.0) // Ensure only one execution
    }
    
    func testDebouncer_ExecutesForDifferentInputs() async {
        let debouncer = Debouncer<String>(delay: 0.5)
        let expectation = XCTestExpectation(description: "Each unique input should trigger execution")
        expectation.expectedFulfillmentCount = 2 // Both "one" and "two" should execute
        
        debouncer.schedule("one") { expectation.fulfill() }
        try? await Task.sleep(nanoseconds: 550_000_000)
        debouncer.schedule("two") { expectation.fulfill() } // Different input should execute
        
        await fulfillment(of: [expectation], timeout: 1.5) // Ensure both executions happen
    }
}
