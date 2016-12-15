//
//  PanInteractionController.swift
//  MagicMove
//
//  Created by David Andres Cespedes on 11/30/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

protocol PanInteractionControllerDelegate {
  func interactiveAnimationDidStart(controller: PanInteractionController)
}

class PanInteractionController : UIPercentDrivenInteractiveTransition {
  var pan: UIPanGestureRecognizer?
  var delegate: PanInteractionControllerDelegate?
  
  var isActive: Bool {
    get {
      return pan?.state != .possible
    }
  }
  
  func attachToView(view: UIView) {
    pan = UIPanGestureRecognizer(target: self, action: #selector(screenEdgePan(_:)))
    view.addGestureRecognizer(pan!)
  }
  
  func screenEdgePan(_ pan: UIScreenEdgePanGestureRecognizer) {
    let view = pan.view!
    switch pan.state {
    case .began:
      let location = pan.location(in: view)
      if location.y < view.bounds.midY/2 {
        delegate?.interactiveAnimationDidStart(controller: self)
      }
      
    case .changed:
      let translation = pan.translation(in: view)
      let percent = fabs(translation.y / view.bounds.height)
      self.update(percent)
      
    case .ended:
      if pan.velocity(in: view).y > 0 {
        self.finish()
      } else {
        self.cancel()
      }
      
      
    case .cancelled: fallthrough
    case .failed:
      self.cancel()
    case .possible: break
      
    }
    
  }
  
}
