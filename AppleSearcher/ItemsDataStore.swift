//
//  ItemsDataStore.swift
//  AppleSearcher
//
//  Created by andrey on 02/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import Foundation

class ItemsDataStore: SearchItemsStoreProtocol {
  
  private var items = [Item]()
  
  func fetchItems(request: SearchItems_FetchItems_Request, completionHandler: (items: () throws -> [Item]) -> Void) {
    completionHandler { return self.items }
  }
  
//  func fetchItems(completionHandler: OrdersStoreFetchOrdersCompletionHandler) {
//    
//  }
}
