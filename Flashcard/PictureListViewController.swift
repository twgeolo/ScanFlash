//
//  PictureListViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class PictureListViewController: UITableViewController {
    
    var cardArray:[Card]! = []
    var processStr: [String]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.rowHeight = 80
        self.navigationItem.title = "Results"
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.editing = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "done")
    }
    
    func done() {
        let progressHUD: MRProgressOverlayView = MRProgressOverlayView.showOverlayAddedTo(self.navigationController?.view, title: "Saving", mode: MRProgressOverlayViewMode.Indeterminate, animated: true)
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let selectedRows: [NSIndexPath]? = self.tableView.indexPathsForSelectedRows() as? [NSIndexPath]
            var error: Int = 0
            if (selectedRows == nil) {
                error = 1
            } else {
                for indexPath: NSIndexPath in selectedRows! {
                    let lang: NSString = NSUserDefaults.standardUserDefaults().objectForKey("Foreign") as String
                    let str: NSString = "https://www.googleapis.com/language/translate/v2?key=AIzaSyDahysSwvSeyCxfIu99ikcc5iFaJF-Jo_U&q=\(self.processStr[indexPath.row])&source=en&target=\(lang)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
                    println(str)
                    var err: NSError?
                    let data: NSData? = NSData(contentsOfURL: NSURL(string: str), options: NSDataReadingOptions.DataReadingUncached, error: &err)
                    if (data != nil) {
                        let dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &err) as NSDictionary
                        let translated: NSString = ((((dict.objectForKey("data") as NSDictionary).objectForKey("translations") as NSArray)[0] as NSDictionary).objectForKey("translatedText")) as NSString
                        NSLog(translated)
                        DatabaseHelper.executeUpdate("insert into Cards(englishText, foreignText, favorite) VALUES (\'\(self.processStr[indexPath.row])\', \'\(translated)\', 0)")
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                progressHUD.dismiss(true)
                self.navigationController?.popToRootViewControllerAnimated(true)
                
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
        return processStr.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        cell?.textLabel?.text = processStr[indexPath.row]

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
