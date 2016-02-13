//
//  ItemsMemoryStore.swift
//  AppleSearcher
//
//  Created by andrey on 08/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import Foundation

class ItemsMemoryStore: SearchItemsStoreProtocol {
  
  var items = [Item]()
  
  func fetchItems(request: SearchItems_FetchItems_Request, completionHandler: (items: () throws -> [Item]) -> Void) {
    completionHandler { return self.items }
  }
}
