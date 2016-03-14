//
//  SearchItemsViewControllerTests.swift
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

class SearchItemsViewControllerTests: XCTestCase
{
  // MARK: Subject under test
  
  var sut: SearchItemsViewController!
  var window: UIWindow!
  
  // MARK: Test lifecycle
  
  override func setUp()
  {
    super.setUp()
    window = UIWindow()
    setupSearchItemsViewController()
  }
  
  override func tearDown()
  {
    window = nil
    super.tearDown()
  }
  
  // MARK: Test setup
  
  func setupSearchItemsViewController()
  {
    let bundle = NSBundle(forClass: self.dynamicType)
    let storyboard = UIStoryboard(name: "Main", bundle: bundle)
    let className = "SearchItemsViewController"
    sut = storyboard.instantiateViewControllerWithIdentifier(className) as! SearchItemsViewController
    loadView()
  }
  
  func loadView()
  {
    window.addSubview(sut.view)
    NSRunLoop.currentRunLoop().runUntilDate(NSDate())
  }
  
  // MARK: Test doubles
  
  class SearchItemsViewControllerOutputSpy: SearchItemsViewControllerOutput {
    // MARK: Method call expectations
    var fetchItemsCalled = false
    
    var searchItems_FetchItems_Request: SearchItems_FetchItems_Request!
    
    // MARK: Spied methods
    func fetchItems(request: SearchItems_FetchItems_Request) {
      fetchItemsCalled = true
      searchItems_FetchItems_Request = request
    }
  }
  
  class CollectionViewSpy: UICollectionView {
    
    var reloadDataCalled = false
    
    override func reloadData() {
      reloadDataCalled = true
    }
  }
  
  // MARK: Tests
  
  func testShouldFetchItemsWhenSearchStringIsTyped() {
    // Given
    let searchItemsViewControllerOutputSpy = SearchItemsViewControllerOutputSpy()
    sut.output = searchItemsViewControllerOutputSpy
    
    // When
    sut.searchBar(sut.searchBar, textDidChange: "AAA")
    
    // Then
    XCTAssertTrue(searchItemsViewControllerOutputSpy.fetchItemsCalled, "Should fetch items when one letter is typed")
  }
  
  func testShouldCarrySearchString() {
    // Given
    let searchItemsViewControllerOutputSpy = SearchItemsViewControllerOutputSpy()
    sut.output = searchItemsViewControllerOutputSpy
    
    // When
    sut.searchBar(sut.searchBar, textDidChange: "AAA")
    
    // Then
    XCTAssertEqual("AAA", searchItemsViewControllerOutputSpy.searchItems_FetchItems_Request.searchString,
      "Should carry searchString")
  }
  
  func testShouldDisplayFetchItems() {
    // Given
    let collectionViewSpy = CollectionViewSpy.init(frame: sut.view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
    sut.collectionView = collectionViewSpy
    
    let displayedItems = [SearchItems_FetchItems_ViewModel.DisplayedItem(name: "RED", description: "HOT", imagePath: "image.jpg", trackID: 2)]
    let viewModel = SearchItems_FetchItems_ViewModel(displayedItems: displayedItems)
    
    // When
    sut.didChangeText = true
    sut.displayFetchedItems(viewModel)
    
    // Then
    XCTAssertTrue(collectionViewSpy.reloadDataCalled, "Displaying fetch items should reload collection view")
  }
  
  func testNumberOfSectionsShouldAlwaysBeOne() {
    // Given
    let collectionView = sut.collectionView
    
    // When
    let numberOfSections = sut.numberOfSectionsInCollectionView(collectionView)
    
    // Then
    XCTAssertEqual(numberOfSections, 1, "The number of table view sections should always be 1")
  }
  
  func testNumberOfRowsInAnySectionShouldEqaulNumberOfItemsToDisplay() {
    // Given
    let collectionView = sut.collectionView
    let displayedItems = [SearchItems_FetchItems_ViewModel.DisplayedItem(name: "RED", description: "HOT", imagePath: "image.jpg", trackID: 2)]
    sut.displayedItems = displayedItems
    
    // When
    let numberOfRows = sut.collectionView(collectionView, numberOfItemsInSection: 0)
    
    // Then
    XCTAssertEqual(numberOfRows, displayedItems.count, "The number of table view rows should equal the number of orders to display")
  }
}












