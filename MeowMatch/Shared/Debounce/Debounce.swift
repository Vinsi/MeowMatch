//
//  Debounce.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import Foundation

struct WorkItem<T: Equatable> {
    let query: T
    let task: DispatchWorkItem

    func cancel() {
        task.cancel()
        log.logW("query.cancelled.for:[\(query)]", .failure)
    }
}

final class Debouncer<T: Equatable> {
    private var currentTask: WorkItem<T>?
    private let delay: TimeInterval
    private(set) var lastInput: T? // Keeps track of the last input

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func schedule(_ input: T, _ task: @escaping () async -> Void) {
        guard input != lastInput else { return }
        lastInput = input

        // Cancel the current task if it exists
        currentTask?.cancel()

        // Generate a new task ID to track the latest task
        let param = input

        // Create a new DispatchWorkItem for the task
        let workItem = DispatchWorkItem { [weak self] in
            guard self?.lastInput == param else {
                // Ignore stale tasks
                log.logW("ignored.stale.request.\(param)")
                return
            }
            Task {
                await task()
            }
        }

        currentTask = WorkItem(query: input, task: workItem)
        if let task = currentTask?.task {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: task)
        }
    }
}
