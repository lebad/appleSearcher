//
//  ItemImage.swift
//  AppleSearcher
//
//  Created by andrey on 13/02/16.
//  Copyright © 2016 AndreyLebedev. All rights reserved.
//

import UIKit

class ItemImage {
  
  private lazy var session: NSURLSession = {
    let sessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
    return NSURLSession.init(configuration: sessionConfiguration)
  }()
  
  func imageForString(imageString: String, completion:(image: UIImage) -> Void) {
    var image = UIImage()
    
    let URL = NSURL(string: imageString)
    
    let dataTask = session.dataTaskWithURL(URL!, completionHandler: { (data, response, error) -> Void in
      dispatch_async(dispatch_get_main_queue(), { () -> Void in
        if error == nil {
          image = UIImage(data: data!)!
          completion(image: image)
        }
      })
      
    })
    dataTask.resume()
  }
  
}
