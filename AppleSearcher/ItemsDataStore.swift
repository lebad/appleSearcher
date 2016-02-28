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
  
  private let itemsDataAPI: SearchItemsStoreProtocol
  private let itemsDataStore: SearchItemsStoreProtocol
  
  init() {
    self.itemsDataAPI = ItemsDataAPI()
    self.itemsDataStore = ItemsCoreDataStore()
  }
  
  func fetchItems(request: SearchItems_FetchItems_Request,
    completionHandler: (items: [Item], error: ItemsStoreError?) -> Void) {
      
      itemsDataStore.fetchItems(request) { (items, error) -> Void in
        if items.count == 0 {
          self.itemsDataAPI.fetchItems(request) { (items, error) -> Void in
            if items.count != 0 {
              self.createItems(items, completionHandler: { (error) -> Void in
                if error == nil {
                  self.itemsDataStore.fetchItems(request, completionHandler: { (items, error) -> Void in
                    completionHandler(items: items, error: error)
                  })
//                  self.fetchItems(request, completionHandler: { (items, error) -> Void in
//                    completionHandler(items: items, error: nil)
//                  })
                }
              })
            }
          }
        } else {
          completionHandler(items: items, error: nil)
        }
      }
  }
  
  func fetchItem(trackID: NSNumber?, completionHandler: (item: Item?, error: ItemsStoreError?) -> Void) {
    itemsDataStore.fetchItem(trackID, completionHandler: completionHandler)
  }
  
  func createItem(itemToCreate: Item, completionHandler: (item: Item?, error: ItemsStoreError?) -> Void) {
    itemsDataStore.createItem(itemToCreate, completionHandler: completionHandler)
  }
  
  func createItems(itemsToCreate: [Item], completionHandler: (error: ItemsStoreError?) -> Void) {
    itemsDataStore.createItems(itemsToCreate, completionHandler: completionHandler)
  }
}












