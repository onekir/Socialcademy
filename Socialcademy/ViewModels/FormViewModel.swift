//
//  FormViewModel.swift
//  Socialcademy
//
//  Created by Александр Кириченко on 31.01.2024.
//
import Foundation

@MainActor
class FormViewModel<Value>: ObservableObject {
    typealias Action = (Value) async throws -> Void
    
    @Published var isWorking = false
    @Published var value: Value
    @Published var error: Error?
    
    private let action: Action
    
    init(initialValue: Value, action: @escaping Action) {
        self.value = initialValue
        self.action = action
    }
    
    nonisolated func submit() {
        Task {
            await handleSubmit()
        }
    }
    
    private func handleSubmit() async {
        isWorking = true
        do {
            try await action(value)
        } catch {
            print("[FormViewModel] Cannot submit: \(error)")
            self.error = error
        }
        isWorking = false
    }
}
