//
//  SearchItemsViewController.swift
//  AppleSearcher
//
//  Created by andrey on 31/01/16.
//  Copyright (c) 2016 AndreyLebedev. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so you can apply
//  clean architecture to your iOS avarMac projects, see http://clean-swift.com
//

import UIKit

protocol SearchItemsViewControllerInput
{
  func displayFetchedItems(viewModel: SearchItems_FetchItems_ViewModel)
}

protocol SearchItemsViewControllerOutput
{
  func fetchItems(request: SearchItems_FetchItems_Request)
}

class SearchItemsViewController: UIViewController, SearchItemsViewControllerInput
{
  var output: SearchItemsViewControllerOutput!
  var router: SearchItemsRouter!
  
  var displayedItems: [SearchItems_FetchItems_ViewModel.DisplayedItem] = []
  var displayedTrackIDs = [NSIndexPath: String]()
  var displayedImages = [NSIndexPath: UIImage]()
  
  // MARK: Interface
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      flowLayout.minimumLineSpacing = 5.0
      let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
      collectionView.registerNib(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
    }
  }

  @IBOutlet weak var searchBar: UISearchBar! {
    didSet {
      searchBar.delegate = self;
    }
  }
  private var cellSizeCache = NSCache()
  
  // MARK: Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    SearchItemsConfigurator.sharedInstance.configure(self)
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  // MARK: Display logic
  
  func displayFetchedItems(viewModel: SearchItems_FetchItems_ViewModel) {
    displayedItems = viewModel.displayedItems
    collectionView.reloadData()
  }
  
  func requestImageForIndexPath(indexPath: NSIndexPath, imageURLString: String?) {
    
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension SearchItemsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
      let displayedItem = displayedItems[indexPath.row]
      
      let cell = NSBundle.mainBundle().loadNibNamed("ItemCollectionViewCell",
        owner: self,
        options: nil).first as! ItemCollectionViewCell
      cell.width = CGRectGetWidth(collectionView.bounds)
      cell.updateCell(displayedItem)
      let cellSize = cell.calculateSize()
      requestImageForIndexPath(indexPath, imageURLString: displayedItem.imagePath)
      return cellSize
  }
}

extension SearchItemsViewController: UISearchBarDelegate {
  // MARK: UISearchBarDelegate
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    let request = SearchItems_FetchItems_Request(searchString: searchText)
    output.fetchItems(request)
  }
}

//MARK: UICollectionViewDelegate

extension SearchItemsViewController: UICollectionViewDelegate {
  
}

//MARK: UICollectionViewDataSource

extension SearchItemsViewController: UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return displayedItems.count
  }
  
  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let displayedItem = displayedItems[indexPath.row]
    
    var cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCollectionViewCell",
      forIndexPath: indexPath) as? ItemCollectionViewCell
    
    if let itemCell = cell {
      itemCell.updateCell(displayedItem)
      
      if displayedTrackIDs[indexPath] != displayedItem.trackID {
        if let imageString = displayedItem.imagePath {
          ItemImage().imageForString(imageString, completion: { (image) -> Void in
            
            itemCell.imageView.image = image
            self.displayedTrackIDs[indexPath] = displayedItem.trackID
            self.displayedImages[indexPath] = image
          })
        }
      }
      
    } else {
      cell = ItemCollectionViewCell(coder: NSCoder())
    }
    
    return cell!
  }
}










