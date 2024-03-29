//
//  Item.swift
//  AppleSearcher
//
//  Created by andrey on 02/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import Foundation

struct Item: Hashable {
  var name: String?
  var description: String?
  var imageURLString: String?
  var trackID: Int?
  
  var hashValue: Int {
    return trackID!
  }
  
  init(name: String?, description: String?, imageURLString: String?, trackID: Int?) {
    self.name = name
    self.description = description
    self.imageURLString = imageURLString
    self.trackID = trackID
  }
  
  init(responseObject: [String: AnyObject]) {
    self.name = responseObject["artistName"] as? String
    self.description = responseObject["trackCensoredName"] as? String
    self.imageURLString = responseObject["artworkUrl100"] as? String
    self.trackID = responseObject["trackId"] as? Int
  }
}

func ==(lhs: Item, rhs: Item) -> Bool {
  return lhs.name == rhs.name
      && lhs.description == rhs.description
      && lhs.trackID == rhs.trackID
}
