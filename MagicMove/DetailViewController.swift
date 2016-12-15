//
//  DetailViewController.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/2/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController, UINavigationControllerDelegate, PanInteractionControllerDelegate {
    
    var image: UIImage?
    var interactionController = PanInteractionController()
  
    @IBOutlet var imageView: FKBRemoteImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        interactionController.delegate = self
        interactionController.attachToView(view: self.view)
    }
  
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        edgesForExtendedLayout = UIRectEdge()
        
        navigationController?.delegate = self
        
        if let image = image {
            imageView.image = image
        }
    }
  
    func navigationController(_ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
      
      //return nil
      
      if operation == .pop {
          let animator = Animator()
          animator.presenting = false
          return animator
      } else {
          return nil
      }
    }
  
    func navigationController(_ navigationController: UINavigationController,
                              interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
      if interactionController.isActive {
        return interactionController
      }else {
        return nil
      }
      
    }
    
    //MARK : PanInteractionControllerDelegate
    func interactiveAnimationDidStart(controller: PanInteractionController) {
      _ = navigationController?.popViewController(animated: true)
    }
}
