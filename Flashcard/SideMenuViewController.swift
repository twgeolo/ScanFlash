//
//  SideMenuViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {

    var rowNames: [String] = ["Gallery", "All", "Favorite", "Recommended"]

    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "Wallpaper.jpg"))
        super.viewDidLoad()
        
        let footerView: UIView = UIView(frame: CGRectMake(0, 0, 250, 50))
        footerView.backgroundColor = UIColor.clearColor()
        let settingBtn: UIButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton
        settingBtn.tintColor = UIColor.whiteColor()
        settingBtn.frame = CGRectMake(0, 2, 48, 48)
        settingBtn.setImage(UIImage(named: "Settings").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        let copyrightLbl: UILabel = UILabel(frame: CGRectMake(0, 2, 250, 48))
        copyrightLbl.text = "© G. Lo, S. Xu, M. Lee, K. Sawant"
        copyrightLbl.textColor = UIColor.whiteColor()
        copyrightLbl.textAlignment = NSTextAlignment.Right
        copyrightLbl.font = UIFont(name: "Avenir-Book", size: 15)
        footerView.addSubview(copyrightLbl)
        let upperLayer: CALayer = CALayer()
        upperLayer.frame = CGRectMake(0, 0, 1000, 1)
        upperLayer.backgroundColor = UIColor(white: 0.5, alpha: 0.6).CGColor
        footerView.layer.addSublayer(upperLayer)
        self.tableView.tableFooterView = footerView

        let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, name FROM Lists")
        while (rs.next()) {
            rowNames.append(rs.objectForColumnIndex(1) as String)
        }
        
        self.tableView.rowHeight = 70;
        self.tableView.separatorColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func viewWillAppear(animated: Bool) {

    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.rowNames.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        let kImageViewId = 101
        
        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellIdentifier")
        }
        
        cell?.imageView?.image = UIImage(named: rowNames[indexPath.row]).imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        if (indexPath.row > 3) {
            cell?.imageView?.image = UIImage(named: "DefaultListIcon").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        cell?.imageView?.tintColor = UIColor.whiteColor()
        cell?.textLabel?.font = UIFont(name: "Avenir-Book", size: 18)
        cell?.backgroundColor = UIColor.clearColor()
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.textLabel?.text = rowNames[indexPath.row].uppercaseString
        if (indexPath.row == 3) {
            cell?.textLabel?.text = " Recommended".uppercaseString
        }
        
        let view: UIView = UIView(frame: cell!.bounds)
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        cell?.selectedBackgroundView = view
        
        return cell!
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    /*override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }    
    }*/
    

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
