//
//  AddItemsViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/19/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class AddItemsViewController: UITableViewController {
    
    var listId: Int = 0
    var cardArray: [Card]! = []
    var selectedAry: [Int] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorColor = UIColor.clearColor()
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.editing = true
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancel")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        var s = DatabaseHelper.executeQuery("SELECT name FROM Lists WHERE id = \(listId)")
        while ( s.next()) {
            self.navigationItem.prompt = "Select the items you want to add to " + "\'\(s.objectForColumnIndex(0))\'".uppercaseString
        }
        s = DatabaseHelper.executeQuery("SELECT cid FROM CL WHERE lid = \(listId)")
        while (s.next()) {
            var index = Int(s.intForColumnIndex(0))
            selectedAry.append(index-1)
        }
        self.navigationItem.title = "PICK".uppercaseString
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, englishText, foreignText, PicId, favorite FROM Cards")
            while (rs.next()) {
                var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), text: rs.objectForColumnIndex(1) as String, foreign: rs.objectForColumnIndex(2) as String, pictureId: Int(rs.intForColumnIndex(3)), favorite: Int(rs.intForColumnIndex(4)))
                self.cardArray.append(cardTmp)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        })
        self.tableView.rowHeight = 80
    }
    
    override func viewDidAppear(animated: Bool) {
        for i in 0...self.selectedAry.count-1 {
            let indexPath = NSIndexPath(forRow: selectedAry[i], inSection: 0)
            self.tableView.selectRowAtIndexPath(indexPath, animated: true, scrollPosition: UITableViewScrollPosition.Bottom)
        }
    }
    
    func cancel() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done() {
        DatabaseHelper.executeUpdate("delete from CL where lid = \(listId)")
        
        let selectedRows = self.tableView.indexPathsForSelectedRows() as [NSIndexPath]
        for indexPath: NSIndexPath in selectedRows {
            DatabaseHelper.executeUpdate("insert into CL (cid, lid) VALUES (\(indexPath.row + 1), \(listId))")
        }
        for i in 0...selectedAry.count-1 {
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return cardArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        let kPhotoId = 101
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CellIdentifier")
        }
        
        let c: Card = cardArray[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        cell?.textLabel?.text = c.text
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        cell?.detailTextLabel?.text = c.foreign
        cell?.detailTextLabel?.textColor = UIColor.whiteColor()
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
        imageView.tag = kPhotoId
        cell?.backgroundView = imageView
        
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        cell?.backgroundView?.addSubview(view)
        
        let selView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
        selView.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        cell?.selectedBackgroundView = selView
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var err: NSError?
            let data: NSData? = NSData.dataWithContentsOfURL(NSURL(string: "http://pixabay.com/api/?username=cscz3329&key=21481a8de1b2c9ae5950&search_term=\(c.text)&image_type=photo&page=1&per_page=5".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), options: NSDataReadingOptions.DataReadingUncached, error: &err)
            if (data != nil) {
                let dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &err) as NSDictionary
                if ((dict["hits"] as NSArray).count > 0) {
                    let imageURL: NSURL = NSURL(string: (((dict["hits"] as NSArray)[0]) as NSDictionary)["previewURL"] as String)
                    dispatch_async(dispatch_get_main_queue(), {
                        (cell?.viewWithTag(kPhotoId) as UIImageView).imageURL = imageURL
                    })
                } else {
                    let imageURL: NSURL = NSURL(string: "http://pixabay.com/static/uploads/photo/2014/09/27/13/46/question-mark-463497_150.jpg")
                    dispatch_async(dispatch_get_main_queue(), {
                        (cell?.viewWithTag(kPhotoId) as UIImageView).imageURL = imageURL
                    })
                }
            }
        })
        
        return cell!
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
