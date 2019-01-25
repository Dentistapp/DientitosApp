//
//  Extension.swift
//  dientitosApp
//
//  Created by Adrian on 1/24/19.
//  Copyright © 2019 DentistaApp. All rights reserved.
//

import UIKit
//Saving all the images
let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
 
    func loadImageUsingCacheWithUrlString(urlString: String) {
        
        self.image = nil
        
        //check cache for image first
        if let cacheimage = imageCache.object(forKey: urlString as AnyObject) {
            self.image = (cacheimage as! UIImage) 
            return
        }
        
        
        
        let url =  URL(string: urlString)
        URLSession.shared.dataTask(with: url!) { (data, responde, error) in
            
            
            if error != nil {
                print(error!)
            }
            DispatchQueue.main.async {
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
            }
        }.resume()
    }
}
