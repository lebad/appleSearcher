//
//  ItemCollectionViewCell.swift
//  AppleSearcher
//
//  Created by andrey on 13/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
  var width: CGFloat
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var numberLabel: UILabel!
  
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var descriptionLabel: UILabel!
  
  lazy var customConstraints: [NSLayoutConstraint] = {
    return [NSLayoutConstraint]()
  }()
  
  required init?(coder aDecoder: NSCoder) {
    self.width = 0.0
    super.init(coder: aDecoder)
    self.contentView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override class func requiresConstraintBasedLayout() -> Bool {
    return true
  }
  
  override func updateConstraints() {
    if customConstraints.count > 0 {
      self.contentView.removeConstraints(customConstraints)
      customConstraints.removeAll()
    }
    
    let contentView = self.contentView as UIView
    
    if self.width != 0 {
      let width = self.width
      let metricsWidth = ["width": width]
      let constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:[contentView(==width)]",
        options: [], metrics: metricsWidth, views: ["contentView": contentView])
      customConstraints += constraints
      self.contentView.addConstraints(constraints)
    }
    super.updateConstraints()
  }
  
  func updateCell(displayedItem: SearchItems_FetchItems_ViewModel.DisplayedItem) {
    nameLabel.text = displayedItem.name
    descriptionLabel.text = displayedItem.description
  }
  
  func calculateSize() -> CGSize {
    setNeedsLayout()
    layoutIfNeeded()
    let cellSize = contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
    return cellSize
  }
}
