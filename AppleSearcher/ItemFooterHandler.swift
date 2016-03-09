//
//  ItemFooterHandler.swift
//  AppleSearcher
//
//  Created by andrey on 09/03/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import Foundation

class ItemFooterHandler {
  
  weak var footerView: ItemFooterCollectionReusableView?
  
  func startIndicate() {
    footerView?.activityIndiactor.hidden = false
    footerView?.activityIndiactor.startAnimating()
  }
  
  func stopIndicate() {
    footerView?.activityIndiactor.stopAnimating()
    footerView?.activityIndiactor.hidden = true
  }
}
