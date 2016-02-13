//
//  SearchItemsWorkerTests.swift
//  AppleSearcher
//
//  Created by andrey on 31/01/16.
//  Copyright (c) 2016 AndreyLebedev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

@testable import AppleSearcher
import XCTest

class SearchItemsWorkerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: SearchItemsWorker!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupSearchItemsWorker()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupSearchItemsWorker()
  {
    sut = SearchItemsWorker(itemsStore: ItemsDataStoreSpy())
  }
  
  // MARK: Test doubles
  
  class ItemsDataStoreSpy: ItemsDataAPI { //временно
    
    var fetchItemsCalled = false
    
    override func fetchItems(searchString: String, completionHandler: (items: () throws -> [Item]) -> Void) {
      fetchItemsCalled = true
      let oneSecond = dispatch_time(dispatch_time_t(DISPATCH_TIME_NOW), 1 * Int64(NSEC_PER_SEC))
      dispatch_after(oneSecond, dispatch_get_main_queue()) { () -> Void in
        completionHandler{ return [Item(), Item()] }
      }
    }
  }
  
  // MARK: Tests
  
  func testFetchItemsShouldReturnListOfItems() {
    // Given
    let itemDataStoreSpy = sut.itemsStore as! ItemsDataStoreSpy
    let searchString = "Red hot chili peppers"
    
    // When
    let expectation = expectationWithDescription("Wait for the fecth items result")
    sut.fetchItems(searchString) { (items) -> Void in
      expectation.fulfill()
    }
    
    // Then
    XCTAssertTrue(itemDataStoreSpy.fetchItemsCalled, "Calling fetchItems() should ask itemData store for a list of items")
    waitForExpectationsWithTimeout(1.1) { (error: NSError?) -> Void in
      XCTAssertTrue(true, "Calling fechItems should result completion handler being called")
    }
  }
}
