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
  var cellHandlers: [NSIndexPath: ItemCellHandler] = [:]
  var itemImages: [Int: UIImage] = [:]
  lazy var footerHandler: ItemFooterHandler = {
    return ItemFooterHandler()
  }()
  
  let itemsInRequest = 20
  
  var didChangeText = false
  var loading = false
  
  lazy var imageAnimationHandler: ImageAnimationHandler = {
    [unowned self] in
    return ImageAnimationHandler(view: self.view, seacrhView: self.searchBar)
  }()
  
  // MARK: Interface
  @IBOutlet weak var collectionView: UICollectionView! {
    didSet {
      let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
      flowLayout.minimumLineSpacing = 5.0
      let nib = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
      collectionView.registerNib(nib, forCellWithReuseIdentifier: "ItemCollectionViewCell")
      
      let footerNib = UINib(nibName: "ItemFooterCollectionReusableView", bundle: nil)
      collectionView.registerNib(footerNib,
        forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ItemFooterCollectionReusableView")
    }
  }

  @IBOutlet weak var searchBar: UISearchBar! {
    didSet {
      searchBar.delegate = self;
    }
  }
  
  @IBOutlet weak var mainActivityIndicator: UIActivityIndicatorView! {
    didSet {
      mainActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
      mainActivityIndicator.hidden = true
    }
  }
  
  // MARK: Object lifecycle
  
  override func awakeFromNib()
  {
    super.awakeFromNib()
    SearchItemsConfigurator.sharedInstance.configure(self)
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: "tapWithGesture:")
    collectionView.addGestureRecognizer(gestureRecognizer)
  }
  
  // MARK: Display logic
  
  func displayFetchedItems(viewModel: SearchItems_FetchItems_ViewModel) {
    
    if didChangeText == true {
      
      collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
      displayedItems = viewModel.displayedItems
      didChangeText = false
      collectionView.reloadData()
      
      if viewModel.displayedItems.count != 0 {
        loading = false
      }
      
    } else {
      displayedItems += viewModel.displayedItems
      
      UIView.setAnimationsEnabled(false)
      collectionView.performBatchUpdates({ () -> Void in
        
        let indexPaths = self.getIndexPathsFor(viewModel)
        self.collectionView.insertItemsAtIndexPaths(indexPaths)
        
        },
        completion: { (finished) -> Void in
          UIView.setAnimationsEnabled(true)
          
          if viewModel.displayedItems.count != 0 {
            self.loading = false
          }
          
          if viewModel.displayedItems.count != 0 {
            self.footerHandler.stopIndicate()
          }
      })
    }
    
    if viewModel.displayedItems.count != 0 {
      mainActivityIndicator.stopAnimating()
      mainActivityIndicator.hidden = true
    }
  }
  
  func getIndexPathsFor(viewModel: SearchItems_FetchItems_ViewModel) -> [NSIndexPath] {
    var indexPaths = [NSIndexPath]()
    let index = self.displayedItems.count - viewModel.displayedItems.count
    for var i = index; i < self.displayedItems.count; i++ {
      indexPaths.append(NSIndexPath.init(forItem: i, inSection: 0))
    }
    return indexPaths
  }
  
  func request(searchString: String) -> SearchItems_FetchItems_Request {
    return SearchItems_FetchItems_Request(searchString: searchString,
      offset: displayedItems.count,
      itemsInRequest: self.itemsInRequest,
      language: (searchBar.textInputMode?.primaryLanguage)!)
  }
  
  // SCROLL
  func scrollViewDidScroll(scrollView: UIScrollView) {
    let currentOffset = scrollView.contentOffset.y
    let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
    
    if (currentOffset - maximumOffset) >= 0 {
      
      self.collectionView.setContentOffset(CGPoint(x: 0.0, y: maximumOffset), animated: false)
      
      loadSegment()
    }
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    searchBar.resignFirstResponder()
  }
  
  func loadSegment() {
    if loading == false {
      loading = true
      
      self.output.fetchItems(self.request(searchBar.text!))
      
      self.footerHandler.startIndicate()
    }
  }
  
  // MARK: Gestures
  
  func tapWithGesture(tapGestureRecognizer: UITapGestureRecognizer) {
    searchBar.resignFirstResponder()
  }
}

// MARK: UICollectionViewDelegateFlowLayout

extension SearchItemsViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    
      return CGSize(width: CGRectGetWidth(collectionView.bounds), height: 100.0)
  }
  
  func collectionView(collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForFooterInSection section: Int) -> CGSize {
    
      var footerHeight: CGFloat = 50.0
      if displayedItems.count == 0 {
        footerHeight = 0.0
      }
      return CGSize(width: CGRectGetWidth(collectionView.bounds), height: footerHeight)
  }
}

// MARK: UISearchBarDelegate

extension SearchItemsViewController: UISearchBarDelegate {
  
  func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
    
    didChangeText = true
    
    self.itemImages.removeAll()
    self.output.fetchItems(self.request(searchText))
    
    self.mainActivityIndicator.hidden = false
    self.mainActivityIndicator.startAnimating()
    
  }
  
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
}

//MARK: UICollectionViewDataSource

extension SearchItemsViewController: UICollectionViewDataSource {
  
  func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return displayedItems.count
  }
  
  func collectionView(collectionView: UICollectionView,
    cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
    let displayedItem = displayedItems[indexPath.row]
    let handler = getHandler(displayedItem, indexPath: indexPath)
    handler.delegate = self
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ItemCollectionViewCell",
      forIndexPath: indexPath) as! ItemCollectionViewCell
    handler.updateDataFor(cell)
      
    return cell
  }
  
  func getHandler(displayedItem: SearchItems_FetchItems_ViewModel.DisplayedItem, indexPath: NSIndexPath) -> ItemCellHandler {
    if let handler: ItemCellHandler = cellHandlers[indexPath] {
      handler.updateDisplayedItem(displayedItem)
    } else {
      cellHandlers[indexPath] = ItemCellHandler(displayedItem: displayedItem, index: indexPath.row)
    }
    return cellHandlers[indexPath]!
  }
  
  func collectionView(collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {

    let footer = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter,
      withReuseIdentifier: "ItemFooterCollectionReusableView", forIndexPath: indexPath)
      
    footerHandler.footerView = footer as? ItemFooterCollectionReusableView
      
    return footer
  }
}

//MARK: ItemCellHandlerDelegate

extension SearchItemsViewController: ItemCellHandlerDelegate {
  
  func getImageAt(trackID id: Int) -> UIImage? {
    return itemImages[id]
  }
  
  func setImage(image: UIImage, atTrackID id: Int) {
    itemImages[id] =  image
  }
  
  func animateImageView(imageView: UIImageView) {
    searchBar.resignFirstResponder()
    imageAnimationHandler.animateImageView(imageView)
  }
}











