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
    var downLoadTimer: NSTimer!
    let timeUpdateInterval: Int = 3
    var secondsToUpdate: Int = 3
    let thePaths = ["http://easyways.com.ua/storage/gallery/images/tours/bde/bdef63df38a15170593a6ebecaac1e41.jpg", "http://mywishlist.ru/pic/i/wish/orig/004/719/410.jpeg", "http://www.bontravel.com.ua/wp-content/uploads/2014/11/vodorosli.jpg", "http://vybratpravilno.ru/wp-content/uploads/2014/12/148.jpg", "http://abyss.com.ua/wp-content/uploads/2015/04/daiving.jpg"]
    let thePaths2 = ["http://seriobus.com/sites/default/files/britanskaya_korotkosherstnaya_koshka_6.jpg", "http://avivas.ru/img/2015/05/topic/38638/58036.jpg", "http://allphoto.in.ua/photo/23/es2236596.jpg", "http://www.fullhdoboi.ru/_ph/29/720623227.jpg", "http://www.wallpaper-wallpaper.com/wp-content/uploads/images/cats-dogs/cats-dogs-wallpaper-retina-hd-download-18.jpg"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.downloadPhotosWithURLs(thePaths)
        self.setupTimer()
        
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
    
    // MARK: Timer
    
    func setupTimer() {
        if downLoadTimer == nil  {
            let theSelector: Selector = "updateDownloadTimer:"
            downLoadTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: theSelector, userInfo: nil, repeats: true)
        }
    }
    
    
    func updateDownloadTimer(timer: NSTimer) {
        self.secondsToUpdate -= 1
        print(self.secondsToUpdate)
        if self.secondsToUpdate == 0 {
            self.secondsToUpdate = timeUpdateInterval
            self.downloadPhotosWithURLs(thePaths2)
        }
    }
    
    
    
    

}

