//
//  NavControllerDelegate.swift
//  MagicMove
//
//  Created by David Andres Cespedes on 11/28/16.
//  Copyright © 2016 NSScreencast. All rights reserved.
//

import UIKit

class NavController : NSObject, UINavigationControllerDelegate {
  
  func navigationController(_ navigationController: UINavigationController,
                            animationControllerFor operation: UINavigationControllerOperation,
                                                            from fromVC: UIViewController,
                                                                               to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning?
  {
    if operation == .push {
      return Animator()
    } else {
      return nil
    }
  }
}
