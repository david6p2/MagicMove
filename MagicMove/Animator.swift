//
//  Animator.swift
//  MagicMove
//
//  Created by David Andres Cespedes on 11/28/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class Animator: NSObject, UIViewControllerAnimatedTransitioning {
	
	var presenting = false
	
	func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
		return 0.4
	}
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    if presenting {
      animatePush(transitionContext)
    } else {
      animatePop(transitionContext)
    }
  }
  
  func getCellImageView(_ viewController: ViewController) -> UIImageView {
    let indexPath = viewController.lastSelectedIndexPath!
    let cell = viewController.collectionView!.cellForItem(at: indexPath as IndexPath) as! ImageViewCell
    return cell.imageView
  }
  
  func animatePush(_ transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView
    let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! ViewController
    let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! DetailViewController
    
    toVC.view.setNeedsLayout()
    toVC.view.layoutIfNeeded()
    
    let fromImageView = getCellImageView(fromVC)
    guard let toImageView = toVC.imageView else { return }
    
    //Changed to work in iPhone 7 Simulator
    //http://stackoverflow.com/questions/40188089/swift-3-why-does-the-snapshot-from-snapshotview-appears-blank-in-iphone-7-plus
    //guard let snapshot = fromImageView.snapshotView(afterScreenUpdates: false) else { return }
    guard let snapshot = fromImageView.snapshotView() else { return }
    
    fromImageView.isHidden = true
    toImageView.isHidden = true
    
    let backdrop = UIView(frame: toVC.view.frame)
    backdrop.backgroundColor = toVC.view.backgroundColor
    container.addSubview(backdrop)
    backdrop.alpha = 0
    toVC.view.backgroundColor = UIColor.clear
    
    toVC.view.alpha = 0
    let finalFrame = transitionContext.finalFrame(for: toVC)
    var frame = finalFrame
    frame.origin.y += frame.size.height
    toVC.view.frame = frame
    container.addSubview(toVC.view)
    
    snapshot.frame = container.convert(fromImageView.frame, from: fromImageView)
    container.addSubview(snapshot)
    
    
    /*UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.9, options: UIViewAnimationOptions.curveEaseIn, animations: {
      backdrop.alpha = 1
      toVC.view.alpha = 1
      toVC.view.frame = finalFrame
      snapshot.frame = container.convert(toImageView.frame, from: toImageView)
      
    }, completion: { (finished) in
      
      toVC.view.backgroundColor = backdrop.backgroundColor
      backdrop.removeFromSuperview()
      
      fromImageView.isHidden = false
      toImageView.isHidden = false
      snapshot.removeFromSuperview()
      
      transitionContext.completeTransition(finished)
      
    })*/
    UIView.animate(withDuration: transitionDuration(using: transitionContext)
      , animations: {
      
      backdrop.alpha = 1
      toVC.view.alpha = 1
      toVC.view.frame = finalFrame
      snapshot.frame = container.convert(toImageView.frame, from: toImageView)
      
      }, completion: { (finished) in
      
      toVC.view.backgroundColor = backdrop.backgroundColor
      backdrop.removeFromSuperview()
      
      fromImageView.isHidden = false
      toImageView.isHidden = false
      snapshot.removeFromSuperview()
      
      transitionContext.completeTransition(finished)
    })
  }
  
  func animatePop(_ transitionContext: UIViewControllerContextTransitioning) {
    let container = transitionContext.containerView
    let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)! as! DetailViewController
    print(" FROM vc \(transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!.description)")
    let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)! as! ViewController
    print(" TO vc \(transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!.description)")
    
    guard let fromImageView = fromVC.imageView else { return }
    //guard let fromImageView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
    let toImageView = getCellImageView(toVC)
    
    //Changed to work in iPhone 7 Simulator
    //http://stackoverflow.com/questions/40188089/swift-3-why-does-the-snapshot-from-snapshotview-appears-blank-in-iphone-7-plus
    //guard let snapshot = fromImageView.snapshotView(afterScreenUpdates: false) else { return }
    guard let snapshot = fromImageView.snapshotView() else { return }
    
    fromImageView.isHidden = true
    toImageView.isHidden = true
    
    let backdrop = UIView(frame: fromVC.view.frame)
    backdrop.backgroundColor = fromVC.view.backgroundColor
    container.insertSubview(backdrop, belowSubview: fromVC.view)
    backdrop.alpha = 1
    fromVC.view.backgroundColor = UIColor.clear
    
    let finalFrame = transitionContext.finalFrame(for: toVC)
    toVC.view.frame = finalFrame
    
    var frame = finalFrame
    frame.origin.y += frame.size.height
    container.insertSubview(toVC.view, belowSubview: backdrop)
    
    snapshot.frame = container.convert(fromImageView.frame, from: fromImageView)
    container.addSubview(snapshot)
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext)
      , animations: {
      
      backdrop.alpha = 0
      fromVC.view.frame = frame
      snapshot.frame = container.convert(toImageView.frame, from: toImageView)
      
      }, completion: { (finished) in
      
      fromVC.view.backgroundColor = backdrop.backgroundColor
      backdrop.removeFromSuperview()
      
      fromImageView.isHidden = false
      toImageView.isHidden = false
      snapshot.removeFromSuperview()
      
      let wasCancelled = transitionContext.transitionWasCancelled
      
      transitionContext.completeTransition(!wasCancelled)
      
      if (wasCancelled){
        print("Adding fromView Again")
        //UIApplication.shared.keyWindow!.addSubview(fromVC.view)
        transitionContext.containerView.addSubview(fromVC.view)
        print("Transition was cancelled: \(wasCancelled)")
      }
      
    })
  }
	
}

public extension UIView {
  
  public func snapshotImage() -> UIImage? {
    UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
    drawHierarchy(in: bounds, afterScreenUpdates: false)
    let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return snapshotImage
  }
  
  public func snapshotView() -> UIView? {
    if let snapshotImage = snapshotImage() {
      return UIImageView(image: snapshotImage)
    } else {
      return nil
    }
  }
}
