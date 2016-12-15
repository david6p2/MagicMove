//
//  ViewController.swift
//  MagicMove
//
//  Created by Ben Scheirman on 6/2/15.
//  Copyright (c) 2015 NSScreencast. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController, UINavigationControllerDelegate {

    var lastSelectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
      super.viewDidLoad()
      let layout = collectionView!.collectionViewLayout as! UICollectionViewFlowLayout
      let size = view.bounds.width / 2.0 - 1
      layout.itemSize = CGSize(width: size, height: size)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
   
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageViewCell", for: indexPath) as! ImageViewCell
        let w = Int(view.frame.size.width) * 2
        let url = URL(string: "http://lorempixel.com/\(w)/\(w)")!
        cell.imageView.fkb_setImageWithURL(url, placeholder: nil)
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let selected = collectionView?.indexPathsForSelectedItems
        guard let indexPath = selected?.first else { return }

        let cell = collectionView!.cellForItem(at: indexPath) as! ImageViewCell
        let image = cell.imageView.image
        let detailVC = segue.destination as! DetailViewController
        detailVC.image = image
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.delegate = self
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        lastSelectedIndexPath = indexPath
    }
    
    func navigationController(_ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationControllerOperation,
        from fromVC: UIViewController,
        to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
            if operation == .push {
                let animator = Animator()
                animator.presenting = true
                return animator
            } else {
                return nil
            }
    }
    
}

