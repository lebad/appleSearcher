//
//  SearchItemsModels.swift
//  AppleSearcher
//
//  Created by andrey on 31/01/16.
//  Copyright (c) 2016 AndreyLebedev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

struct SearchItems_FetchItems_Request
{
  var searchString: String
}

struct SearchItems_FetchItems_Response
{
  var items: [Item]
}

struct SearchItems_FetchItems_ViewModel
{
  struct DisplayedItem {
    var name: String?
    var description: String?
    var imagePath: String?
    var trackID: String?
  }
  var displayedItems: [DisplayedItem]
}


