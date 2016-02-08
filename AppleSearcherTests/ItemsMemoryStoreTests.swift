//
//  ItemsMemoryStoreTests.swift
//  AppleSearcher
//
//  Created by andrey on 08/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import XCTest

class ItemsMemoryStoreTests: XCTestCase {
  
  var sut: ItemsMemoryStore!
  var testItems: [Item]!
    
  override func setUp() {
      super.setUp()
      setupItemsMemStore()
  }
  
  func setupItemsMemStore() {
    sut = ItemsMemoryStore()
    
    testItems = [
      Item(name: "RED", description: "HOT", itemImagePath: saveImageOnDisk()),
      Item(name: "rutuiyett", description: "turiyiuryuiy", itemImagePath: saveImageOnDisk())
    ]
    sut.items = testItems
  }
  
  func saveImageOnDisk() -> String {
    let image = UIImage.init(named: "cat")
    let imagePath = fileInDocumentsDirectory("cat.png")
    UIImagePNGRepresentation(image!)!.writeToFile(imagePath, atomically: true)
    return imagePath;
  }
  
  func fileInDocumentsDirectory(filename: String) -> String {
    let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
    return fileURL.path!
  }
  
  func getDocumentsURL() -> NSURL {
    let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
    return documentsURL
  }
    
  override func tearDown() {
    resetItemsMemStore()
    super.tearDown()
  }
  
  func resetItemsMemStore() {
    sut.items = []
    sut = nil
  }
    
//  func testFetchOrdersShouldReturnListOfOrders_OptionalError()
//  {
//    // Given
//    
//    // When
//    var returnedOrders = [Item]()
//    let expectation = expectationWithDescription("Wait for fetchOrders() to return")
//    sut.fetchOrders { (orders: [Order], error: OrdersStoreError?) -> Void in
//      returnedOrders = orders
//      expectation.fulfill()
//    }
//    waitForExpectationsWithTimeout(1.0) { (error: NSError?) -> Void in
//    }
//    
//    // Then
//    XCTAssertEqual(returnedOrders.count, testOrders.count, "fetchOrders() should return a list of orders")
//    for order in returnedOrders {
//      XCTAssert(testOrders.contains(order), "Returned orders should match the orders in the data store")
//    }
//  }
  
}
