//
//  ChatListViewModelTests.swift
//  BLEChattingTests
//
//  Created by 백상휘 on 12/14/24.
//

import XCTest
import Combine
@testable import BLEChatting
import CoreBluetooth
import SwiftData

class ChatListViewModelTests: XCTestCase {
    
    var sut: ChatListViewModel!
    var mockUseCaseFactory: MockUseCaseFactory!
    var subscriptions: Set<AnyCancellable>!
    
    private var modelContainer: ModelContainer = {
        let schema = Schema([BLEChattingSchema.self])
        let configuration = ModelConfiguration(schema: schema,
                                               isStoredInMemoryOnly: true)
        do {
            return try ModelContainer(for: schema,
                                      configurations: [configuration])
        } catch {
            fatalError("😫")
        }
    }()
    
    override func setUp() {
        super.setUp()
        // MARK: Fatal! Build Error
//        mockUseCaseFactory = MockUseCaseFactory(modelContext: modelContainer.mainContext)
        sut = ChatListViewModel(mockUseCaseFactory)
        subscriptions = .init()
    }
    
    override func tearDown() {
        sut = nil
        mockUseCaseFactory = nil
        subscriptions = nil
        super.tearDown()
    }
    
    func test_InitialState() {
        // Given - Initial state
        
        // Then
        XCTAssertEqual(sut.userName, "")
        XCTAssertFalse(sut.showModal)
        XCTAssertTrue(sut.items.isEmpty)
        XCTAssertNil(sut.error)
    }
    
    func test_UserNameValidation_WhenExceedingMaxLength() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for userName validation")
        
        // When
        sut.$error
            .dropFirst()
            .sink { error in
                XCTAssertEqual(error, .excceded)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.userName = "ThisIsAVeryLongUserName"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_UserNameValidation_WhenValidLength() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for userName validation")
        
        // When
        sut.$error
            .dropFirst()
            .sink { error in
                XCTAssertNil(error)
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        sut.userName = "ValidName"
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_UserNameValidation_RemovesDuplicates() {
        // Given
        let expectation = XCTestExpectation(description: "Wait for userName validation")
        var validationCount = 0
        
        // When
        sut.$error
            .sink { _ in
                validationCount += 1
            }
            .store(in: &subscriptions)
        
        sut.userName = "Test"
        sut.userName = "Test" // Duplicate value
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(validationCount, 1) // Should only validate once for duplicate values
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

// MARK: - Mock Classes
class MockUseCaseFactory: UseCaseFactory {
    func getUseCase(_ type: BLEManager) -> (any ChatBLMInterface<ChatListManageableUseCase.Actions>)? {
        return nil // Return mock implementation if needed
    }
}
