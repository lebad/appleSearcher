//
//  ImageAnimationHandler.swift
//  AppleSearcher
//
//  Created by andrey on 28/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import UIKit

class ImageAnimationHandler {
  
  private weak var view: UIView!
  private weak var searchView: UIView!
  private weak var backView: UIView!
  private lazy var imageView: UIImageView = {
    let imView = UIImageView(frame: CGRectZero)
    imView.contentMode = .ScaleAspectFill
    return imView
  }()
  private var imageViewRect: CGRect = CGRectZero
  private lazy var tapGestireRecognizer: UITapGestureRecognizer = {
    [unowned self] in
    let recognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
    return recognizer
  }()
  
  init(view: UIView, seacrhView: UIView) {
    self.view = view
    self.searchView = seacrhView
  }
  
  func animateImageView(imageView: UIImageView) {
    
    self.imageView.image = imageView.image
    
    addBackViewToView()
    imageViewRect = imageView.convertRect(imageView.frame, toView: backView)
    
    addImageViewToBackView()
    increaseAndAnimateImageView()
    self.imageView.userInteractionEnabled = true
    self.imageView.addGestureRecognizer(tapGestireRecognizer)
  }
  
  private func addBackViewToView() {
    let backView = UIView()
    backView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(backView)
    view.bringSubviewToFront(backView)
    backView.backgroundColor = UIColor.clearColor()
    
    let top = CGRectGetMinY(searchView.frame)
    
    var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
      options: [],
      metrics: nil,
      views: ["view": backView])
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-top-[view]|",
      options: [],
      metrics: ["top": top],
      views: ["view": backView])
    
    view.addConstraints(constraints)
    
    view.layoutIfNeeded()
    
    self.backView = backView
  }
  
  private func addImageViewToBackView() {
    
    imageView.translatesAutoresizingMaskIntoConstraints = false
    backView.addSubview(imageView)
    
    let leftSpace = CGRectGetMinX(imageViewRect)
    let width = CGRectGetWidth(imageViewRect)
    let topSpace = CGRectGetMinY(imageViewRect)
    let height = CGRectGetHeight(imageViewRect)
    
    var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-leftSpace-[view(==width)]",
      options: [],
      metrics: ["leftSpace": leftSpace, "width": width],
      views: ["view": imageView])
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-topSpace-[view(==height)]",
      options: [],
      metrics: ["topSpace": topSpace, "height": height],
      views: ["view": imageView])
    backView.addConstraints(constraints)
    
    backView.layoutIfNeeded()
  }
  
  private func increaseAndAnimateImageView() {
    
    let width = CGRectGetWidth(backView.bounds)
    let height = width
    let topSpace = CGRectGetHeight(searchView.frame)
    
    var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|",
      options: [],
      metrics: nil,
      views: ["view": imageView])
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-topSpace-[view(==height)]",
      options: [],
      metrics: ["topSpace": topSpace, "height": height],
      views: ["view": imageView])
    
    imageView.removeFromSuperview()
    backView.addSubview(imageView)
    
    backView.addConstraints(constraints)
    
    UIView.animateWithDuration(0.3) { () -> Void in
      self.backView.layoutIfNeeded()
    }
  }
  
  // MARK: Gestures
  
  private dynamic func handleTap(gestureRecognizer: UIGestureRecognizer) {
    decreaseAndAnimateImageView()
  }
  
  private func decreaseAndAnimateImageView() {
    
    let leftSpace = CGRectGetMinX(imageViewRect)
    let width = CGRectGetWidth(imageViewRect)
    let topSpace = CGRectGetMinY(imageViewRect)
    let height = CGRectGetHeight(imageViewRect)
    
    var constraints = NSLayoutConstraint.constraintsWithVisualFormat("H:|-leftSpace-[view(==width)]",
      options: [],
      metrics: ["leftSpace": leftSpace, "width": width],
      views: ["view": imageView])
    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-topSpace-[view(==height)]",
      options: [],
      metrics: ["topSpace": topSpace, "height": height],
      views: ["view": imageView])
    
    imageView.removeFromSuperview()
    backView.addSubview(imageView)
    
    backView.addConstraints(constraints)
    
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      
      self.backView.layoutIfNeeded()
      
      }) { (finished) -> Void in
        
        self.backView.removeFromSuperview()
    }
  }
}
