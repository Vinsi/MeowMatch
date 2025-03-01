//
//  Debounce.swift
//  MeowMatch
//
//  Created by Vinsi.
//
import Foundation

final class AsyncDebouncer<Input: Equatable, Output> {
    private var currentTask: Task<Void, any Error>?
    private let delay: TimeInterval
    private var operation: ((Input) async throws -> Output)!

    private(set) var lastInput: Input? // Keeps track of the last input
    private(set) var lastUUID: UUID?
    private(set) var loader: (@MainActor (Bool) -> Void)?

    init(delay: TimeInterval) {
        self.delay = delay
    }

    func config(loader: @escaping @MainActor (Bool) -> Void) {
        self.loader = loader
    }

    func config(operation: @escaping (Input) async throws -> Output) {
        self.operation = operation
    }

    func debounce(input: Input, onCompletion: @escaping @MainActor (Result<Output, any Error> ) -> Void) {
        guard input != lastInput else { return }
        lastInput = input

        // Cancel the current task if it exists
        currentTask?.cancel()

        let requestID = UUID()
        self.lastUUID = requestID

        currentTask = Task {
            do {
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
                guard !Task.isCancelled else { return }

                await self.loader?(true)
                let result = try await operation(input)
                guard requestID == self.lastUUID
                else {
                    log.logW("Stale response ignored")
                    return
                }
                await onCompletion(.success(result))
            }
            catch is CancellationError {
                log.logE("CancellationError", .failure)
            }
            catch  {
                if error.localizedDescription != "cancelled" {
                    log.logE(error.localizedDescription, .failure)
                    await onCompletion(.failure(error))
                }
            }
            await self.loader?(false)
        }
    }
}
