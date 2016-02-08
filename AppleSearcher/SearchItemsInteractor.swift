//
//  SearchItemsInteractor.swift
//  AppleSearcher
//
//  Created by andrey on 31/01/16.
//  Copyright (c) 2016 AndreyLebedev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol SearchItemsInteractorInput
{
  func fetchItems(request: SearchItems_FetchItems_Request)
}

protocol SearchItemsInteractorOutput
{
  func presentFetchedItems(response: SearchItems_FetchItems_Response)
}

class SearchItemsInteractor: SearchItemsInteractorInput
{
  var output: SearchItemsInteractorOutput!
  var worker = SearchItemsWorker(itemsStore: ItemsDataStore())
  
  // MARK: Business logic
  
  func fetchItems(request: SearchItems_FetchItems_Request) {
    worker.fetchItems { (items) -> Void in
      <#code#>
    }
    worker.fetchItems(request.searchString) { (items) -> Void in
      let response = SearchItems_FetchItems_Response(items: items)
      self.output.presentFetchedItems(response)
    }
  }
  
//  func doSomething(request: SearchItems_FetchItems_Request)
//  {
//    // NOTE: Create some Worker to do the work
//    
//    worker = SearchItemsWorker()
//    worker.doSomeWork()
//    
//    // NOTE: Pass the result to the Presenter
//    
//    let response = SearchItemsResponse()
//    output.presentSomething(response)
//  }
}
