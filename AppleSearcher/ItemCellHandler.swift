//
//  ItemCellHandler.swift
//  AppleSearcher
//
//  Created by andrey on 15/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import UIKit

protocol ItemCellHandlerDelegate: class {
  func getImageAt(trackID id: Int) -> UIImage?
  func setImage(image: UIImage, atTrackID id: Int)
  func animateImageView(imageView: UIImageView)
}

class ItemCellHandler {
  
  weak var delegate: ItemCellHandlerDelegate?
  
  private var displayedItem: SearchItems_FetchItems_ViewModel.DisplayedItem
  private var index: Int
  
  init(displayedItem: SearchItems_FetchItems_ViewModel.DisplayedItem, index: Int) {
    self.displayedItem = displayedItem
    self.index = index
  }
  
  func updateDisplayedItem(displayedItem: SearchItems_FetchItems_ViewModel.DisplayedItem) {
    self.displayedItem = displayedItem
  }
  
  func updateDataFor(cell: ItemCollectionViewCell) {
    
    cell.currentHandler = self
    cell.nameLabel.text = displayedItem.name
    cell.descriptionLabel.text = displayedItem.description
    cell.numberLabel.text = NSString.init(format: "%d", index + 1) as String
    cell.imageView.image = nil
    
    if let trackID = displayedItem.trackID {
      if let image = self.delegate?.getImageAt(trackID: trackID) {
        if cell.imageView.image != image {
          cell.imageView.image = image
        }
      } else {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
          self.downloadOrGetImageForCell(cell)
        })
      }
    }
  }
  
  func downloadOrGetImageForCell(cell: ItemCollectionViewCell){
    ItemImage.imageForString(displayedItem.imagePath!, completion: { (image) -> Void in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        cell.imageView.image = image
        self.delegate?.setImage(image, atTrackID: self.displayedItem.trackID!)
      })
    })
  }
  
  func animateImageView(imageView: UIImageView) {
    self.delegate?.animateImageView(imageView)
  }
}
