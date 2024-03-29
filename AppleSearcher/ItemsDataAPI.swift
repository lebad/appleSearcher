//
//  ItemsDataAPI.swift
//  AppleSearcher
//
//  Created by andrey on 12/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import Foundation

class ItemsDataAPI: SearchItemsStoreProtocol {
  
  let baseURLString = "https://itunes.apple.com/search?"
  
  lazy var session: NSURLSession = {
    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    return NSURLSession.init(configuration: sessionConfiguration)
  }()
  
  var dataTask: NSURLSessionDataTask?
  
  func fetchItems(request: SearchItems_FetchItems_Request, completionHandler: (items: [Item], error: ItemsStoreError?) -> Void) {
    
      dataTask?.cancel()
    
      let URL = formatURLForRequest(request)
    
      dataTask = session.dataTaskWithURL(URL) { (data, response, error) -> Void in
        do {
          let items = try self.getItems(data)
          
          if error == nil {
            completionHandler(items: items, error: nil)
          } else {
            completionHandler(items: [], error: ItemsStoreError.CannotFetch("Cannot fetch items from api"))
          }
        } catch {
          completionHandler(items: [], error: ItemsStoreError.CannotFetch("Cannot fetch items from api"))
        }
      }
      dataTask?.resume()
  }
  
  func formatURLForRequest(request: SearchItems_FetchItems_Request) -> NSURL {
    
    let language = NSString(format: "&lang=%@", request.language) as String
    
    let lang = String(language.lowercaseString.characters.map {
      $0 == "-" ? "_" : $0
    })
    
    let country = NSString(format: "&country=%@", lang.componentsSeparatedByString("_").last!) as String
    
    let term = "term="
    
    let offsetString = NSString(format: "&offset=%d", request.offset) as String
    let itemsInRequestString = NSString(format: "&limit=%d", request.itemsInRequest) as String
    let URLString = baseURLString + term + formatString(request.searchString) + country + itemsInRequestString + offsetString
    
    if let url = NSURL(string: URLString) {
      return url
    } else {
      return NSURL()
    }
  }
  
  func fetchItem(trackID: NSNumber?, completionHandler: (item: Item?, error: ItemsStoreError?) -> Void) {
    completionHandler(item: Item(name: "", description: "", imageURLString: "", trackID: 0),
      error: ItemsStoreError.CannotFetch("Can not fetch from API"))
  }
  
  func createItem(itemToCreate: Item, completionHandler: (item: Item?, error: ItemsStoreError?) -> Void) {
    completionHandler(item: Item(name: "", description: "", imageURLString: "", trackID: 0),
      error: ItemsStoreError.CannotCreate("Can not create to API"))
  }
  
  func createItems(itemsToCreate: [Item], completionHandler: (items: [Item], error: ItemsStoreError?) -> Void) {
    completionHandler(items: [Item(name: "", description: "", imageURLString: "", trackID: 0)],
      error: ItemsStoreError.CannotCreate("Can not create to API"))
  }
  
  func formatString(string: String) -> String {
    let searchURLStrings = string.componentsSeparatedByString(" ")
    let mutSearchString = NSMutableString()
    
    for (index, str) in searchURLStrings.enumerate() {
      mutSearchString.appendString(str)
      
      if index != (searchURLStrings.count - 1) {
        mutSearchString.appendString("+")
      }
    }
    return mutSearchString.copy() as! String
  }
  
  func getItems(responseData: NSData?) throws -> [Item] {
    var items = [Item]()
    
    if let responseData = responseData {
      let json = try NSJSONSerialization.JSONObjectWithData(responseData, options: []) as! [String: AnyObject]
      print(json)
      
      if let results = json["results"] as? [[String: AnyObject]] {
        for result in results {
          items.append(Item.init(responseObject: result))
        }
      }
    }
    return items
  }
}
