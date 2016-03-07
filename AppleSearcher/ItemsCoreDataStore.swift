//
//  ItemsCoreDataStore.swift
//  AppleSearcher
//
//  Created by andrey on 22/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import CoreData

class ItemsCoreDataStore: SearchItemsStoreProtocol {
  
  // MARK: - Managed object contexts
  
  var mainManagedObjectContext: NSManagedObjectContext
  var privateManagedObjectContext: NSManagedObjectContext
  
  init() {
    guard let modelURL = NSBundle.mainBundle().URLForResource("AppleSearcher", withExtension: "momd") else {
      fatalError("Error loading model from bundle")
    }
    
    guard let mom = NSManagedObjectModel(contentsOfURL: modelURL) else {
      fatalError("Error initializing mom from: \(modelURL)")
    }
    
    let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
    mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
    mainManagedObjectContext.persistentStoreCoordinator = psc
    
    let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
    let docURL = urls[urls.endIndex - 1]
    let storeURL = docURL.URLByAppendingPathComponent("Searcher.sqlite")
    print(storeURL)
    do {
      let options = [NSSQLitePragmasOption: ["journal_mode": "DELETE"]]
      try psc.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: options)
    } catch {
      fatalError("Error migrating store: \(error)")
    }
    
    privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
    privateManagedObjectContext.parentContext = mainManagedObjectContext
  }
  
  deinit {
    do {
      try self.mainManagedObjectContext.save()
    } catch {
      fatalError("Error deinitializing main managed object context")
    }
  }
  
  func fetchItems(request: SearchItems_FetchItems_Request,
    completionHandler: (items: [Item], error: ItemsStoreError?) -> Void) {
    
    privateManagedObjectContext.performBlock {
      do {
        let fetchRequest = NSFetchRequest(entityName: "ManagedItem")
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@ OR desription CONTAINS[c] %@",
          request.searchString,
          request.searchString)
        fetchRequest.fetchBatchSize = request.itemsInRequest
        fetchRequest.fetchLimit = request.itemsInRequest
        fetchRequest.fetchOffset = request.offset
        let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        let descriptionSortDescriptor = NSSortDescriptor(key: "desription", ascending: true)
        fetchRequest.sortDescriptors = [nameSortDescriptor, descriptionSortDescriptor]
        
        let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [ManagedItem]
        let items = results.map { $0.toItem() }
        completionHandler(items: items, error: nil)
      } catch {
        completionHandler(items: [], error: ItemsStoreError.CannotFetch("Cannot fetch from core data"))
      }
    }
  }
  
  func fetchItem(trackID: NSNumber?, completionHandler: (item: Item?, error: ItemsStoreError?) -> Void) {
    privateManagedObjectContext.performBlock {
      guard let id = trackID else {
        completionHandler(item: nil, error: ItemsStoreError.CannotFetch("Can not fetch item: \(trackID)"))
        return
      }
      do {
        let fetchRequest = NSFetchRequest(entityName: "ManagedItem")
        fetchRequest.predicate = NSPredicate(format: "trackID == %@", id)
        let results = try self.privateManagedObjectContext.executeFetchRequest(fetchRequest) as! [ManagedItem]
        if let item = results.first?.toItem() {
          completionHandler(item: item, error: nil)
        } else {
          completionHandler(item: nil, error: ItemsStoreError.CannotFetch("Can not fetch item: \(id)"))
        }
      } catch {
        completionHandler(item: nil, error: ItemsStoreError.CannotFetch("Can not fetch item: \(id)"))
      }
    }
  }
  
  func createItem(itemToCreate: Item, completionHandler: (item: Item?, error: ItemsStoreError?) -> Void) {
    privateManagedObjectContext.performBlock { () -> Void in
      do {
        let managedItem = NSEntityDescription.insertNewObjectForEntityForName("ManagedItem",
          inManagedObjectContext: self.privateManagedObjectContext) as! ManagedItem
        
        managedItem.name = itemToCreate.name
        managedItem.desription = itemToCreate.description
        managedItem.imageURLString = itemToCreate.imageURLString
        managedItem.trackID = itemToCreate.trackID
        
        try self.privateManagedObjectContext.save()
        
        try self.mainManagedObjectContext.save()
        
        completionHandler(item: managedItem.toItem(), error: nil)
      } catch {
        completionHandler(item: nil,
          error: ItemsStoreError.CannotCreate("Cannot create item with id \(itemToCreate.trackID)"))
      }
    }
  }
  
  func createItems(itemsToCreate: [Item], completionHandler: (error: ItemsStoreError?) -> Void) {
    do {
      for item in itemsToCreate {
        let managedItem = NSEntityDescription.insertNewObjectForEntityForName("ManagedItem",
          inManagedObjectContext: self.privateManagedObjectContext) as! ManagedItem
        managedItem.name = item.name
        managedItem.desription = item.description
        managedItem.imageURLString = item.imageURLString
        managedItem.trackID = item.trackID
      }
      try self.privateManagedObjectContext.save()
      
      try self.mainManagedObjectContext.save()
      
      completionHandler(error: nil)
    } catch {
      completionHandler(error: ItemsStoreError.CannotCreate("Cannot create items"))
    }
  }
}






