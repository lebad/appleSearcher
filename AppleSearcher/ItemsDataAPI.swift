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
  
  func fetchItems(searchString: String, completionHandler: (items: () throws -> [Item]) -> Void) {
    let URLString = baseURLString + formatString(searchString)
    let URL = NSURL(string: URLString)
    
    let dataTask = session.dataTaskWithURL(URL!) { (data, response, error) -> Void in
      
      do {
        let items = try self.getItems(data)
        print(items)
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
      
      if let results = json["results"] as? [[String: AnyObject]] {
        for result in results {
          items.append(Item.init(responseObject: result))
        }
      }
    }
    return items
  }
}
