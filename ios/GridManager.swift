//
//  GridManager.swift
//  SortableGrid
//
//  Created by Brendan Rius on 9/19/17.
//  Copyright © 2017 Facebook. All rights reserved.
//

import Foundation

let WigglingCollectionViewStartedMovingNotification = "WigglingCollectionView.StartedMoving"
let WigglingCollectionViewFinishedMovingNotification = "WigglingCollectionView.FinishedMoving"

class ColumnFlowLayout: UICollectionViewFlowLayout {
  
  let cellsPerRow: Int
  override var itemSize: CGSize {
    get {
      guard let collectionView = collectionView else { return super.itemSize }
      let marginsAndInsets = sectionInset.left + sectionInset.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
      let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
      return CGSize(width: itemWidth, height: itemWidth)
    }
    set {
      super.itemSize = newValue
    }
  }
  
  init(cellsPerRow: Int, minimumInteritemSpacing: CGFloat = 0, minimumLineSpacing: CGFloat = 0, sectionInset: UIEdgeInsets = .zero) {
    self.cellsPerRow = cellsPerRow
    super.init()
    
    self.minimumInteritemSpacing = minimumInteritemSpacing
    self.minimumLineSpacing = minimumLineSpacing
    self.sectionInset = sectionInset
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func invalidationContext(forBoundsChange newBounds: CGRect) -> UICollectionViewLayoutInvalidationContext {
    let context = super.invalidationContext(forBoundsChange: newBounds) as! UICollectionViewFlowLayoutInvalidationContext
    context.invalidateFlowLayoutDelegateMetrics = newBounds != collectionView?.bounds
    return context
  }
  
}

class GridView : UICollectionView {
  var _urls: [String] = []
  var onOrderChange: RCTDirectEventBlock = {_ in }
  
  var isWiggling: Bool { return _isWiggling }
  
  @objc
  public func setUrls(_ urls: NSArray) -> Void {
    self._urls = urls as! [String]
  }
  
  private var _isWiggling = false
  
  @available(iOS 9.0, *)
  override func beginInteractiveMovementForItem(at indexPath: IndexPath) -> Bool {
    startWiggle()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: WigglingCollectionViewStartedMovingNotification), object: self)
    return super.beginInteractiveMovementForItem(at: indexPath as IndexPath)
  }
  
  @available(iOS 9.0, *)
  override func endInteractiveMovement() {
    super.endInteractiveMovement()
    stopWiggle()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: WigglingCollectionViewFinishedMovingNotification), object: self)
  }
  
  // Wiggle code below from https://github.com/LiorNn/DragDropCollectionView
  
  private func startWiggle() {
    for cell in self.visibleCells {
      addWiggleAnimationToCell(cell: cell as UICollectionViewCell)
    }
    _isWiggling = true
  }
  
  private func stopWiggle() {
    for cell in self.visibleCells {
      cell.layer.removeAllAnimations()
    }
    _isWiggling = false
  }
  
  private func addWiggleAnimationToCell(cell: UICollectionViewCell) {
    CATransaction.begin()
    CATransaction.setDisableActions(false)
    cell.layer.add(rotationAnimation(), forKey: "rotation")
    cell.layer.add(bounceAnimation(), forKey: "bounce")
    CATransaction.commit()
  }
  
  private func rotationAnimation() -> CAKeyframeAnimation {
    let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
    let angle = CGFloat(0.04)
    let duration = TimeInterval(0.1)
    let variance = Double(0.025)
    animation.values = [angle, -angle]
    animation.autoreverses = true
    animation.duration = self.randomizeInterval(interval: duration, withVariance: variance)
    animation.repeatCount = Float.infinity
    return animation
  }
  
  private func bounceAnimation() -> CAKeyframeAnimation {
    let animation = CAKeyframeAnimation(keyPath: "transform.translation.y")
    let bounce = CGFloat(2.0)
    let duration = TimeInterval(0.12)
    let variance = Double(0.025)
    animation.values = [bounce, -bounce]
    animation.autoreverses = true
    animation.duration = self.randomizeInterval(interval: duration, withVariance: variance)
    animation.repeatCount = Float.infinity
    return animation
  }
  
  private func randomizeInterval(interval: TimeInterval, withVariance variance:Double) -> TimeInterval {
    let random = (Double(arc4random_uniform(1000)) - 500.0) / 500.0
    return interval + variance * random;
  }

}

class GridViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  var collectionView: GridView? = nil;
  
  override func loadView() {
    self.collectionView = GridView(frame: UIScreen.main.bounds, collectionViewLayout: ColumnFlowLayout(
      cellsPerRow: 3,
      minimumInteritemSpacing: 10,
      minimumLineSpacing: 10,
      sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    ))
    self.collectionView?.delegate = self
    self.collectionView?.dataSource = self
    self.view = self.collectionView
  }
  
  override func viewDidLoad() {
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture))
    self.collectionView?.bounces = true
    self.collectionView?.alwaysBounceVertical = true
    self.collectionView?.addGestureRecognizer(longPressGesture)
    self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
    
    self.collectionView!.backgroundColor = UIColor.red
  }
  
  func handleLongGesture(gesture: UILongPressGestureRecognizer) {
    
    switch(gesture.state) {
      
    case UIGestureRecognizerState.began:
      guard let selectedIndexPath = self.collectionView?.indexPathForItem(at: gesture.location(in: self.collectionView)) else {
        break
      }
      if #available(iOS 9.0, *) {
        collectionView?.beginInteractiveMovementForItem(at: selectedIndexPath)
      } else {
        // Fallback on earlier versions
      }
    case UIGestureRecognizerState.changed:
      if #available(iOS 9.0, *) {
        collectionView?
          .updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
      } else {
        // Fallback on earlier versions
      }
    case UIGestureRecognizerState.ended:
      if #available(iOS 9.0, *) {
        collectionView?.endInteractiveMovement()
      } else {
        // Fallback on earlier versions
      }
    default:
      if #available(iOS 9.0, *) {
        collectionView?.cancelInteractiveMovement()
      } else {
        // Fallback on earlier versions
      }
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return (self.collectionView?._urls.count)!
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath)
    let btn = UIButton(frame: CGRect(x: cell.frame.width - 25, y: 5, width: 20, height: 20))

    btn.setBackgroundImage(UIImage.init(named: "delete.png"), for: .normal)
    btn.addTarget(self, action: #selector(self.press), for: .touchUpInside)
    
    let imageView = UIImageView(frame: cell.bounds)
    imageView.layer.cornerRadius = 4.0
    imageView.layer.masksToBounds = true
    cell.addSubview(imageView)
    
    cell.addSubview(btn)
    let url = self.collectionView?._urls[indexPath.item]
    NSURLConnection.sendAsynchronousRequest(URLRequest(url: URL(string: url!)!), queue: OperationQueue.main) { (response, data, error) in
      if let d = data{
        imageView.image = UIImage(data: d)
      }
    }
    return cell
  }
  
  func press(sender: UIButton) {
    let indexPath = self.collectionView?.indexPathForItem(at: (self.collectionView?.convert(sender.center, from: sender.superview))!)
    self.collectionView?._urls.remove(at: (indexPath?.item)!)
    self.collectionView?.deleteItems(at: [indexPath!])
  }
  
  func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    let item = self.collectionView?._urls.remove(at: sourceIndexPath.item)
    self.collectionView?._urls.insert(item!, at: destinationIndexPath.item)
    self.collectionView?.onOrderChange(["urls": self.collectionView?._urls])
  }
  
}

@objc(GridViewManager)
class GridViewManager: RCTViewManager {
  var gridViewController = GridViewController()
  
  override func view() -> UIView {
    return self.gridViewController.view
  }
}
