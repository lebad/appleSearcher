//
//  SearchItemsConfigurator.swift
//  AppleSearcher
//
//  Created by andrey on 31/01/16.
//  Copyright (c) 2016 AndreyLebedev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

// MARK: Connect View, Interactor, and Presenter

extension SearchItemsViewController: SearchItemsPresenterOutput
{
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
  {
    router.passDataToNextScene(segue)
  }
}

extension SearchItemsInteractor: SearchItemsViewControllerOutput
{
}

extension SearchItemsPresenter: SearchItemsInteractorOutput
{
}

class SearchItemsConfigurator
{
  // MARK: Object lifecycle
  
  class var sharedInstance: SearchItemsConfigurator
  {
    struct Static {
      static var instance: SearchItemsConfigurator?
      static var token: dispatch_once_t = 0
    }
    
    dispatch_once(&Static.token) {
      Static.instance = SearchItemsConfigurator()
    }
    
    return Static.instance!
  }
  
  // MARK: Configuration
  
  func configure(viewController: SearchItemsViewController)
  {
    let router = SearchItemsRouter()
    router.viewController = viewController
    
    let presenter = SearchItemsPresenter()
    presenter.output = viewController
    
    let interactor = SearchItemsInteractor()
    interactor.output = presenter
    
    viewController.output = interactor
    viewController.router = router
  }
}
