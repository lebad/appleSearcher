//
//  ManagedItem.swift
//  AppleSearcher
//
//  Created by andrey on 22/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import Foundation
import CoreData

@objc(ManagedItem)
class ManagedItem: NSManagedObject {

  func toItem() -> Item {
    return Item(name: name, description: desription, imageURLString: imageURLString, trackID: trackID?.integerValue)
  }

}
