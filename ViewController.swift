//
//  ViewController.swift
//  DispatchGroup
//
//  Created by Евгений Стариков on 29.04.16.
//  Copyright © 2016 Starikov Evgen. All rights reserved.
//
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thePaths = ["http://easyways.com.ua/storage/gallery/images/tours/bde/bdef63df38a15170593a6ebecaac1e41.jpg", "http://mywishlist.ru/pic/i/wish/orig/004/719/410.jpeg", "http://www.bontravel.com.ua/wp-content/uploads/2014/11/vodorosli.jpg", "http://vybratpravilno.ru/wp-content/uploads/2014/12/148.jpg", "http://abyss.com.ua/wp-content/uploads/2015/04/daiving.jpg"]
        self.downloadPhotosWithURLs(thePaths)
        
    }
    
    func downloadPhotosWithURLs(urls: [String]) {
        var images = [UIImage]()
        
        let group = dispatch_group_create()
        
        for url in urls {
            dispatch_group_enter(group)
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: url)!, completionHandler: { data, response, error in
                
                if let imgData = data {
                    if let image = UIImage(data: imgData) {
                        dispatch_sync(dispatch_get_main_queue()) {
                            images.append(image)
                        }
                    } else {
                        // PUT IN "Photo Unavailable" Pic
                    }
                } else {
                    // PUT IN "Photo Unavailable" Pic
                }
                
                dispatch_group_leave(group)
            }).resume()
        }
        
        // UPDATE
        dispatch_group_notify(group, dispatch_get_main_queue()) {
            self.images = images
            self.tableView.reloadData()
        }
    }
    

    // MARK: Table view data source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return images.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! TableViewCell
        
        cell.imageViewCell.image = self.images[indexPath.row]
        
        return cell
        
    }

}

