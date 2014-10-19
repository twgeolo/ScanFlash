//
//  ListViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var cardArray: [Card]!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewStyle) {
        super.init(style: UITableViewStyle.Plain)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(id: Int){
        super.init()
        switch id{
        case 0:
            // all
                let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, listId, englishText, foreignText, PicId, favorite FROM Cards")
                while (rs.next()) {
                    
                    var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), listId: Int(rs.intForColumnIndex(1)), text: rs.objectForColumnIndex(2) as String, foreign: rs.objectForColumnIndex(3) as String, pictureId: Int(rs.intForColumnIndex(4)), favorite: Int(rs.intForColumnIndex(5)))
                    self.cardArray.append(cardTmp)
                }
                break;
        case 1:
            //fav
            let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, listId, englishText, foreignText, PicId, favorite FROM Cards WHERE Cards.favorite = 1")
            while (rs.next()) {
                
                var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), listId: Int(rs.intForColumnIndex(1)), text: rs.objectForColumnIndex(2) as String, foreign: rs.objectForColumnIndex(3) as String, pictureId: Int(rs.intForColumnIndex(4)), favorite: Int(rs.intForColumnIndex(5)))
                self.cardArray.append(cardTmp)
            }
            break;
        case 2:
            //recommended
            break;
        default:
            let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, listId, englishText, foreignText, PicId, favorite FROM Cards WHERE listId = \(id-3)")
            while (rs.next()) {
                
                var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), listId: Int(rs.intForColumnIndex(1)), text: rs.objectForColumnIndex(2) as String, foreign: rs.objectForColumnIndex(3) as String, pictureId: Int(rs.intForColumnIndex(4)), favorite: Int(rs.intForColumnIndex(5)))
                self.cardArray.append(cardTmp)
            }
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Camera"), style: UIBarButtonItemStyle.Done, target: self, action: "showCamera")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showCamera() {
        
        var picker : UIImagePickerController  = UIImagePickerController();
        picker.delegate = self;
        picker.allowsEditing = true;
        picker.sourceType = UIImagePickerControllerSourceType.Camera;
        
        self.presentViewController(picker, animated: true, completion: { imageP in });
        
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }

    /*
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
