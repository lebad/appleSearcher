//
//  ItemsDataStoreTests.swift
//  AppleSearcher
//
//  Created by andrey on 09/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import XCTest

class ItemsDataStoreTests: XCTestCase {
  
  var sut: ItemsDataStore!
    
  override func setUp() {
    super.setUp()
    sut = ItemsDataStore()
  }
  
  override func tearDown() {
    sut = nil
    super.tearDown()
  }
  
//  func testFetchItemsShouldReturnListOfItems_InnerClosure() {
//    // Given
//    let searchString = "red"
//    
//    // When
//    var returnedItems = [Item]()
//    let expectation = expectationWithDescription("Wait for fetchOrders() to return")
//    sut.fetchItems(searchString) { (items) -> Void in
//      returnedItems = try! items()
//      expectation.fulfill()
//    }
//    waitForExpectationsWithTimeout(1.0) { (error: NSError?) -> Void in
//    }
//    
//    // Then
//    XCTAssertTrue(returnedItems.count != 0, "fetch items should return smth")
//  }
}
