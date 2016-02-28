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
  
  func fetchItems(request: SearchItems_FetchItems_Request,
    completionHandler: (items: [Item], error: ItemsStoreError?) -> Void) {
    completionHandler(items: [], error: nil)
  }
  
  func fetchItem(trackID: NSNumber?, completionHandler: (item: Item?, error: ItemsStoreError?) -> Void) {
    //
  }
  
  func createItem(itemToCreate: Item, completionHandler: (item: Item?, error: ItemsStoreError?) -> Void) {
    //
  }
  
  func createItems(itemsToCreate: [Item], completionHandler: (error: ItemsStoreError?) -> Void) {
    //
  }
}
