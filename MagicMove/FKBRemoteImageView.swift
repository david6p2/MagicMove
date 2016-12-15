//
//  FKBRemoteImageView.swift
//
//  Created by Ben Scheirman on 4/28/15.
//  Copyright (c) 2015 Fickle Bits, LLC. All rights reserved.
//

import UIKit

class FKBRemoteImageView : UIImageView {
    
    static var configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        return config
        }()
    
    static var session: URLSession = {
        let session = URLSession(
            configuration: FKBRemoteImageView.configuration,
            delegate: nil,
            delegateQueue: nil)
        session.delegateQueue.maxConcurrentOperationCount = 2
        return session
        }()
    
    var imageTask: URLSessionDataTask?
    
    func fkb_setImageWithURL(_ url: URL!, placeholder: UIImage? = nil) {
        imageTask?.cancel()
        imageTask = type(of: self).session.dataTask(with: url, completionHandler: { (data, response, error) in
            if error == nil {
                if let http = response as? HTTPURLResponse {
                    if http.statusCode == 200 {
                        
                        assert(!Thread.isMainThread, "called on main thread!")
                        
                        if (self.imageTask!.state == URLSessionTask.State.canceling) {
                            return
                        }
                        
                        self.fkb_loadImageWithData(data!)
                    } else {
                        print("received an HTTP \(http.statusCode) downloading \(url)")
                    }
                } else {
                    print("Not an HTTP response")
                }
            } else {
                if (error!._domain == NSURLErrorDomain && error!._code == NSURLErrorCancelled) {
                    // ignore this, will happen in normal use
                    return
                }
                print("Error downloading image: \(url) -- \(error)")
            }
        }) 
        if let placeholderImage = placeholder {
            image = placeholderImage
        }
        imageTask?.resume()
    }
    
    fileprivate func fkb_loadImageWithData(_ data: Data) {
        if let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.image = image
                
                let transition = CATransition()
                transition.duration = 0.25
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
                transition.type = kCATransitionFade
                self.layer.add(transition, forKey: nil)
            }
        }
    }
    
    func fkb_cancelImageLoad() {
        imageTask?.cancel()
    }
}
