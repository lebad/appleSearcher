//
//  SearchItemsPresenter.swift
//  AppleSearcher
//
//  Created by andrey on 31/01/16.
//  Copyright (c) 2016 AndreyLebedev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS and Mac projects, see http://clean-swift.com
//

import UIKit

protocol SearchItemsPresenterInput
{
  func presentFetchedItems(response: SearchItems_FetchItems_Response)
}

protocol SearchItemsPresenterOutput: class
{
  func displayFetchedItems(viewModel: SearchItems_FetchItems_ViewModel)
}

class SearchItemsPresenter: SearchItemsPresenterInput
{
  weak var output: SearchItemsPresenterOutput!
  
  // MARK: Presentation logic
  
  func presentFetchedItems(response: SearchItems_FetchItems_Response) {
    var displayedItems: [SearchItems_FetchItems_ViewModel.DisplayedItem] = []
    
    for item in response.items {
      let name = item.name!
      let description = item.description!
      let imagePath = item.imageURLString!
      let trackID = item.trackID!
      let displayedItem = SearchItems_FetchItems_ViewModel.DisplayedItem(name: name,
        description: description,
        imagePath: imagePath,
        trackID: trackID)
      displayedItems.append(displayedItem)
    }
    
    let viewModel = SearchItems_FetchItems_ViewModel(displayedItems: displayedItems)
    output.displayFetchedItems(viewModel)
  }
}








