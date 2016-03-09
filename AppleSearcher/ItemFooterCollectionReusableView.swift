//
//  ItemFooterCollectionReusableView.swift
//  AppleSearcher
//
//  Created by andrey on 08/03/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import UIKit

class ItemFooterCollectionReusableView: UICollectionReusableView {
  
  @IBOutlet weak var activityIndiactor: UIActivityIndicatorView! {
    didSet {
      activityIndiactor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
      activityIndiactor.hidden = true
    }
  }
  
  var footerHandler: ItemFooterHandler?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
