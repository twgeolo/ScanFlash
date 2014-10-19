//
//  SettingsViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/19/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController, UIActionSheetDelegate {
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Grouped)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.Done, target: self, action: "dismiss")
    }
    
    func dismiss() {
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
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CellIdentifier")
        }
        
        cell?.textLabel?.text = "Language"
        
        if (NSUserDefaults.standardUserDefaults().objectForKey("Foreign") as String == "zh-TW") {
            cell?.detailTextLabel?.text = "繁體中文"
        } else if (NSUserDefaults.standardUserDefaults().objectForKey("Foreign") as String == "zh-CN") {
            cell?.detailTextLabel?.text = "简体中文"
        } else if (NSUserDefaults.standardUserDefaults().objectForKey("Foreign") as String == "ja") {
            cell?.detailTextLabel?.text = "日本語"
        } else if (NSUserDefaults.standardUserDefaults().objectForKey("Foreign") as String == "fr") {
            cell?.detailTextLabel?.text = "français"
        } else if (NSUserDefaults.standardUserDefaults().objectForKey("Foreign") as String == "es") {
            cell?.detailTextLabel?.text = "español"
        }

        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let actionSheet: UIActionSheet = UIActionSheet(title: "Select your language", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "繁體中文", "简体中文", "日本語", "français", "español")
        actionSheet.delegate = self
        actionSheet.showFromRect(CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height), inView: self.view, animated: true)
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (actionSheet.buttonTitleAtIndex(buttonIndex) != "Cancel") {
            if (actionSheet.buttonTitleAtIndex(buttonIndex) == "繁體中文") {
                NSUserDefaults.standardUserDefaults().setObject("zh-TW", forKey: "Foreign")
            } else if (actionSheet.buttonTitleAtIndex(buttonIndex) == "简体中文") {
                NSUserDefaults.standardUserDefaults().setObject("zh-CN", forKey: "Foreign")
            } else if (actionSheet.buttonTitleAtIndex(buttonIndex) == "日本語") {
                NSUserDefaults.standardUserDefaults().setObject("ja", forKey: "Foreign")
            } else if (actionSheet.buttonTitleAtIndex(buttonIndex) == "français") {
                NSUserDefaults.standardUserDefaults().setObject("fr", forKey: "Foreign")
            } else if (actionSheet.buttonTitleAtIndex(buttonIndex) == "español") {
                NSUserDefaults.standardUserDefaults().setObject("es", forKey: "Foreign")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
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
