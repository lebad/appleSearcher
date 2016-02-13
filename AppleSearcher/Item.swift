//
//  Item.swift
//  AppleSearcher
//
//  Created by andrey on 02/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import Foundation

struct Item: Equatable {
  var name: String?
  var description: String?
  var imageURLString: String?
  var trackID: String?
  
  init(responseObject: [String: AnyObject]) {
    self.name = getValue(responseObject, string: "artistName")
    self.description = getValue(responseObject, string: "trackCensoredName")
    self.imageURLString = getValue(responseObject, string: "artworkUrl100")
    self.trackID = getValue(responseObject, string: "trackId")
  }
  
  func getValue(responseObject: [String: AnyObject], string: String) -> String {
    var value = ""
    if let tempVal = responseObject[string] as? String {
      value = tempVal
    }
    return value
  }
}

func ==(lhs: Item, rhs: Item) -> Bool {
  return lhs.name == rhs.name
      && lhs.description == rhs.description
      && lhs.trackID == rhs.trackID
}
