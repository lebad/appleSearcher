//
//  SearchItemsPresenterTests.swift
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

class SearchItemsPresenterTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: SearchItemsPresenter!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    setupSearchItemsPresenter()
  }
  
  override func tearDown()
  {
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupSearchItemsPresenter()
  {
    sut = SearchItemsPresenter()
  }
  
  // MARK: Test doubles
  class SearchItemsPresenterOutputSpy: SearchItemsPresenterOutput {
    var displayFetchedItemsCalled = false
    
    var searchItems_fetchItems_ViewModel: SearchItems_FetchItems_ViewModel!
    
    func displayFetchedItems(viewModel: SearchItems_FetchItems_ViewModel) {
      displayFetchedItemsCalled = true
      searchItems_fetchItems_ViewModel = viewModel
    }
  }
  
  // MARK: Tests
  
  func testPresentFetchedItemsShouldFormatFetchedItemsForDisplay()
  {
    // Given
    let searchItemsPresenterOutputSpy = SearchItemsPresenterOutputSpy()
    sut.output = searchItemsPresenterOutputSpy
    
    let items = [Item(name: "RHCP", description: "ROCK", imageURLString: "/var/folders/.rhcp.jpg")]
    let responce = SearchItems_FetchItems_Response(items: items)
    
    // When
    sut.presentFetchedItems(responce)
    
    // Then
    let displayedItems = searchItemsPresenterOutputSpy.searchItems_fetchItems_ViewModel.displayedItems
    for displayedItem in displayedItems {
      XCTAssertEqual(displayedItem.name, "RHCP", "Should properly format name")
      XCTAssertEqual(displayedItem.description, "ROCK", "Should properly format description")
      XCTAssertEqual(displayedItem.imagePath, "/var/folders/.rhcp.jpg", "Should properly format image")
    }
  }
  
  func testPresentFetchedItemsShouldAskViewControllerToDisplayFetchedItems() {
    // Given
    let searchItemsPresenterOutputSpy = SearchItemsPresenterOutputSpy()
    sut.output = searchItemsPresenterOutputSpy
    
    let items = [Item(name: "RHCP", description: "ROCK", imageURLString: "/var/folders/.rhcp.jpg")]
    let responce = SearchItems_FetchItems_Response(items: items)
    
    // When
    sut.presentFetchedItems(responce)
    
    // Then
    XCTAssertTrue(searchItemsPresenterOutputSpy.displayFetchedItemsCalled, "Present fetched items should ask view controller to display items")
  }
}






