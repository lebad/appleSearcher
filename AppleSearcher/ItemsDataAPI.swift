//
//  ItemsDataAPI.swift
//  AppleSearcher
//
//  Created by andrey on 12/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import Foundation

class ItemsDataAPI: SearchItemsStoreProtocol {
  
  let baseURLString = "https://itunes.apple.com/search?term="
  
  lazy var session: NSURLSession = {
    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    return NSURLSession.init(configuration: sessionConfiguration)
  }()
  
  func fetchItems(request: SearchItems_FetchItems_Request,
    completionHandler: (items: () throws -> [Item]) -> Void) {
      let offsetString = NSString.init(format: "&offset=%d", request.offset) as String
      let itemsInRequestString = NSString.init(format: "&limit=%d", request.itemsInRequest) as String
      
      let URLString = baseURLString + formatString(request.searchString) + itemsInRequestString + offsetString
      let URL = NSURL(string: URLString)
      
      let dataTask = session.dataTaskWithURL(URL!) { (data, response, error) -> Void in
        
        do {
          let items = try self.getItems(data)
          completionHandler{ return items }
        } catch {
          completionHandler { throw ItemsStoreError.CannotFetch("Cannot fetch items") }
        }
      }
      dataTask.resume()
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
//      print(json)
      
      if let results = json["results"] as? [[String: AnyObject]] {
        for result in results {
          items.append(Item.init(responseObject: result))
        }
      }
    }
    return items
  }
}
