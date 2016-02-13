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
  
  init(responseObject: [String: AnyObject]) {
    if let name = responseObject["artistName"] as? String {
      self.name = name
    }
    if let description = responseObject["trackCensoredName"] as? String {
      self.description = description
    }
    if let imageURLString = responseObject["artworkUrl100"] as? String {
      self.imageURLString = imageURLString
    }
  }
}

func ==(lhs: Item, rhs: Item) -> Bool
{
  return lhs.name == rhs.name
      && lhs.description == rhs.description
      && lhs.imageURLString == rhs.imageURLString
}
