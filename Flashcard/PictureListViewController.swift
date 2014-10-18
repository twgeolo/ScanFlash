//
//  PictureListViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class PictureListViewController: UITableViewController {
    
    var cardArray:[Card]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRectMake((UIScreen.mainScreen().bounds.size.width - 44) / 2, 85, 44, 44))
        self.tableView.addSubview(indicator)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, listId, englishText, foreignText, PicId, favorite FROM Cards")
            while (rs.next()) {
                let cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), listId: Int(rs.intForColumnIndex(1)), text: rs.objectForColumnIndex(2) as String, foreign: rs.objectForColumnIndex(3) as String, pictureId: Int(rs.intForColumnIndex(4)), favorite: Int(rs.intForColumnIndex(5)))
                self.cardArray.append(cardTmp)
            }
            dispatch_async(dispatch_get_main_queue(), {
                indicator.removeFromSuperview()
                self.tableView.reloadData()
            })
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return self.cardArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CellIdentifier")
        }
        
        let c: Card = cardArray[indexPath.row] as Card
        //cell?.imageView?.imageURL = c.pictureId
        cell?.textLabel?.text = c.text
        cell?.detailTextLabel?.text = c.foreign

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
