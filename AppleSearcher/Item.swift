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
  var itemImagePath: String?
}

func ==(lhs: Item, rhs: Item) -> Bool
{
  return lhs.name == rhs.name
      && lhs.description == rhs.description
      && lhs.itemImagePath == rhs.itemImagePath
}
