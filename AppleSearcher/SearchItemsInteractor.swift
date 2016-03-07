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
    worker.fetchItems(request) { (items, error) -> Void in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        let response = SearchItems_FetchItems_Response(items: items)
        self.output.presentFetchedItems(response)
      })
    }
  }
}
