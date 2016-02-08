//
//  DigitItemCollectionViewCell.swift
//  AppleSearcher
//
//  Created by andrey on 31/01/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import UIKit

@objc (DigitItemCollectionViewCell)

class DigitItemCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!

  override func awakeFromNib() {
      super.awakeFromNib()
      // Initialization code
  }
  
  override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
    
    var newFrame = attr.frame
    self.frame = newFrame
    
    self.setNeedsLayout()
    self.layoutIfNeeded()
    
    let desiredHeight: CGFloat = self.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
    newFrame.size.height = desiredHeight
    attr.frame = newFrame
    return attr
  }
}
