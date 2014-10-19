//
//  ListViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var cardArray: [Card]! = []
    var id: Int = 0
    var mode: Int = 0;
    
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
        self.tableView.separatorColor = UIColor.clearColor()
        self.id = id
        switch id {
        case 0:
            // All
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            self.navigationItem.title = "All".uppercaseString
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
            break;
        case 1:
            //fav
            self.navigationItem.title = "Favorite".uppercaseString
            let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, englishText, foreignText, PicId, favorite FROM Cards WHERE Cards.favorite = 1")
            while (rs.next()) {
                var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), text: rs.objectForColumnIndex(1) as String, foreign: rs.objectForColumnIndex(2) as String, pictureId: Int(rs.intForColumnIndex(3)), favorite: Int(rs.intForColumnIndex(4)))
                self.cardArray.append(cardTmp)
            }
            break;
        case 2:
            //recommended
            self.navigationItem.title = "Recommended".uppercaseString
            let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, englishText, foreignText, PicId, favorite FROM Cards ORDER by id desc LIMIT 10")
            while (rs.next()) {
                var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), text: rs.objectForColumnIndex(1) as String, foreign: rs.objectForColumnIndex(2) as String, pictureId: Int(rs.intForColumnIndex(3)), favorite: Int(rs.intForColumnIndex(4)))
                self.cardArray.append(cardTmp)
            }
            break;
        default:
            var rs: FMResultSet = DatabaseHelper.executeQuery("SELECT name FROM Lists WHERE id = \(id-3)")
            while (rs.next()) {
                self.navigationItem.title = (rs.objectForColumnIndex(0)! as NSString).uppercaseString
            }
            rs = DatabaseHelper.executeQuery("SELECT id, englishText, foreignText, PicId, favorite FROM Cards INNER JOIN CL ON Cards.id = CL.cid WHERE lid = \(id-3)")
            while (rs.next()) {
                var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), text: rs.objectForColumnIndex(1) as String, foreign: rs.objectForColumnIndex(2) as String, pictureId: Int(rs.intForColumnIndex(3)), favorite: Int(rs.intForColumnIndex(4)))
                self.cardArray.append(cardTmp)
            }
            break;
        }
        if (id > 2) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addItems")
        } else {
            self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "Switch"), style: UIBarButtonItemStyle.Done, target: self, action: "switchMode")];
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.cardArray = []
        self.tableView.reloadData()
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            var rs: FMResultSet = FMResultSet()
            if (self.id == 0) {
                rs = DatabaseHelper.executeQuery("SELECT id, englishText, foreignText, PicId, favorite FROM Cards")
            } else if (self.id == 1) {
                rs = DatabaseHelper.executeQuery("SELECT id, englishText, foreignText, PicId, favorite FROM Cards WHERE Cards.favorite = 1")
            } else if (self.id == 2) {
                rs = DatabaseHelper.executeQuery("SELECT id, englishText, foreignText, PicId, favorite FROM Cards ORDER by id desc LIMIT 10")
            } else {
                rs = DatabaseHelper.executeQuery("SELECT id, englishText, foreignText, PicId, favorite FROM Cards INNER JOIN CL ON Cards.id = CL.cid WHERE lid = \(self.id-3)")
            }
            while (rs.next()) {
                var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), text: rs.objectForColumnIndex(1) as String, foreign: rs.objectForColumnIndex(2) as String, pictureId: Int(rs.intForColumnIndex(3)), favorite: Int(rs.intForColumnIndex(4)))
                self.cardArray.append(cardTmp)
            }
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            })
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 80
    }
    
    func addItems() {
        let addItemsViewcontroller: AddItemsViewController = AddItemsViewController()
        addItemsViewcontroller.listId = id - 3
        self.presentViewController(UINavigationController(rootViewController: addItemsViewcontroller), animated: true, completion: nil)
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
    func switchMode() {
        if (mode == 0){
            //switch to 1, show English
            mode = 1
        }else if (mode == 1){
            //switch to 2, show Chinese
            mode = 2
        }else{
            //switch to 0, default
            mode = 0
        }
        self.tableView.reloadData()
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
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
        return self.cardArray.count
    }
    
    func buttonTapped(sender: AnyObject) {
        var fav: Int = Int(1)
        let rs = DatabaseHelper.executeQuery("select favorite from cards where id = \(sender.tag + 1)")
        while (rs.next()) {
            fav = Int(rs.intForColumnIndex(0))
        }
        if (fav == 1) {
            (sender as UIButton).setImage(UIImage(named: "Favorite").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
            (self.cardArray[sender.tag] as Card).favorite = 0
            DatabaseHelper.executeUpdate("update cards set favorite = 0 where id = \(sender.tag + 1)")
        } else {
            (sender as UIButton).setImage(UIImage(named: "Favorited").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
            (self.cardArray[sender.tag] as Card).favorite = 1
            DatabaseHelper.executeUpdate("update cards set favorite = 1 where id = \(sender.tag + 1)")
        }
        (sender as UIButton).tintColor = UIColor.whiteColor()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell
        let kPhotoId = 101

        if (cell == nil) {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "CellIdentifier")
        }
        
        let c: Card = cardArray[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 22)
        cell?.textLabel?.textColor = UIColor.whiteColor()
        cell?.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: 20)
        cell?.detailTextLabel?.textColor = UIColor.whiteColor()
        
        if (id == 0) {
            let button = UIButton(frame: CGRectMake(0, 0, 50, 50))
            button.tag = indexPath.row
            button.addTarget(self, action: "buttonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
            if (c.favorite == 1) {
                button.setImage(UIImage(named: "Favorited").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
            } else {
                button.setImage(UIImage(named: "Favorite").imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
            }
            button.tintColor = UIColor.whiteColor()
            cell?.accessoryView = button
            cell?.accessoryType = UITableViewCellAccessoryType.None
        } else {
            cell?.accessoryView = nil
            cell?.accessoryType = UITableViewCellAccessoryType.None
        }
        
        
        if (mode == 0){
            cell?.textLabel?.text = c.text
            cell?.detailTextLabel?.text = c.foreign
        }else if (mode == 1){
            cell?.textLabel?.text = c.text
            cell?.detailTextLabel?.text = nil
        }else{
            cell?.textLabel?.text = c.foreign
            cell?.detailTextLabel?.text = nil
        }
        
        let imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
        imageView.tag = kPhotoId
        cell?.backgroundView = imageView
        
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        cell?.backgroundView?.addSubview(view)
        
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

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            DatabaseHelper.executeUpdate("delete from Cards where id = \((self.cardArray[indexPath.row] as Card).cardId)")
            self.cardArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
