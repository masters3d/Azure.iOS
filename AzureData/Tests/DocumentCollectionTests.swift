//
//  DocumentCollectionTests.swift
//  AzureDataTests
//
//  Copyright (c) Microsoft Corporation. All rights reserved.
//  Licensed under the MIT License.
//

import XCTest
@testable import AzureData

class DocumentCollectionTests: AzureDataTests {
    
    override func setUp() {
        resourceType = .collection
        ensureDatabase = true
        super.setUp()
    }

    override func tearDown() { super.tearDown() }
    
    
    func testCollectionCrud() {
        
        var createResponse:     Response<DocumentCollection>?
        var listResponse:       ListResponse<DocumentCollection>?
        var getResponse:        Response<DocumentCollection>?
        var refreshResponse:    Response<DocumentCollection>?
        var deleteResponse:     DataResponse?

        
        // Create
        AzureData.create(collectionWithId: collectionId, inDatabase: databaseId) { r in
            createResponse = r
            self.createExpectation.fulfill()
        }
        
        wait(for: [createExpectation], timeout: timeout)
        
        XCTAssertNotNil(createResponse?.resource)
        
        
        
        // List
        AzureData.get(collectionsIn: databaseId) { r in
            listResponse = r
            self.listExpectation.fulfill()
        }
        
        wait(for: [listExpectation], timeout: timeout)
        
        XCTAssertNotNil(listResponse?.resource)
        
        
        
        // Get
        AzureData.get(collectionWithId: collectionId, inDatabase: databaseId) { r in
            getResponse = r
            self.getExpectation.fulfill()
        }
        
        wait(for: [getExpectation], timeout: timeout)
        
        XCTAssertNotNil(getResponse?.resource)

        
        
        // Refresh
        if getResponse?.result.isSuccess ?? false {
            
            AzureData.refresh(getResponse!.resource!) { r in
                refreshResponse = r
                self.refreshExpectation.fulfill()
            }
            
            wait(for: [refreshExpectation], timeout: timeout)
        }
        
        XCTAssertNotNil(refreshResponse?.resource)

        
        
        // Delete
        if getResponse?.result.isSuccess ?? false {
            AzureData.delete(collectionWithId: collectionId, fromDatabase: databaseId) { r in
                deleteResponse = r
                self.deleteExpectation.fulfill()
            }
        
            wait(for: [deleteExpectation], timeout: timeout)
        }
        
        XCTAssert(deleteResponse?.result.isSuccess ?? false)
    }
}
