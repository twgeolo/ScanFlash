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
    var imgCache: NSCache = NSCache()
    
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
        switch id{
        case 0:
            // all
            self.navigationItem.title = "All".uppercaseString
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, listId, englishText, foreignText, PicId, favorite FROM Cards")
                while (rs.next()) {
                    var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), listId: Int(rs.intForColumnIndex(1)), text: rs.objectForColumnIndex(2) as String, foreign: rs.objectForColumnIndex(3) as String, pictureId: Int(rs.intForColumnIndex(4)), favorite: Int(rs.intForColumnIndex(5)))
                    self.cardArray.append(cardTmp)
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.tableView.reloadData()
                })
            })
            break;
        case 1:
            //fav
            self.navigationItem.title = "Favorite".uppercaseString
            let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id, listId, englishText, foreignText, PicId, favorite FROM Cards WHERE Cards.favorite = 1")
            while (rs.next()) {
                var cardTmp : Card = Card(cardId: Int(rs.intForColumnIndex(0)), listId: Int(rs.intForColumnIndex(1)), text: rs.objectForColumnIndex(2) as String, foreign: rs.objectForColumnIndex(3) as String, pictureId: Int(rs.intForColumnIndex(4)), favorite: Int(rs.intForColumnIndex(5)))
                self.cardArray.append(cardTmp)
            }
            break;
        case 2:
            //recommended
            self.navigationItem.title = "Recommended".uppercaseString
            break;
        default:
            var rs: FMResultSet = DatabaseHelper.executeQuery("SELECT name FROM Lists WHERE id = \(id-3)")
            while (rs.next()) {
                self.navigationItem.title = (rs.objectForColumnIndex(0)! as NSString).uppercaseString
            }
            rs = DatabaseHelper.executeQuery("SELECT id, listId, englishText, foreignText, PicId, favorite FROM Cards WHERE listId = \(id-3)")
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
        
        self.tableView.rowHeight = 80
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
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.cardArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CellIdentifier") as? UITableViewCell

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
        
        let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        cell?.backgroundView?.addSubview(view)
        
        if (self.imgCache.objectForKey(c.text) == nil) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
                var err: NSError?
                let data: NSData? = NSData.dataWithContentsOfURL(NSURL(string: "http://pixabay.com/api/?username=cscz3329&key=21481a8de1b2c9ae5950&search_term=\(c.text)&image_type=photo&page=1&per_page=5".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!), options: NSDataReadingOptions.DataReadingUncached, error: &err)
                if (data != nil) {
                    let dict: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: &err) as NSDictionary
                    if ((dict["hits"] as NSArray).count > 0) {
                        let imageURL: NSURL = NSURL(string: (((dict["hits"] as NSArray)[0]) as NSDictionary)["previewURL"] as String)
                        dispatch_async(dispatch_get_main_queue(), {
                            let imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
                            cell?.backgroundView = imageView
                            self.imgCache.setObject(UIImage(data: NSData(contentsOfURL: imageURL)), forKey: c.text)
                            imageView.image = UIImage(data: NSData(contentsOfURL: imageURL))
                            cell?.backgroundView?.bringSubviewToFront(view)
                        })
                    } else {
                        let imageURL: NSURL = NSURL(string: "http://pixabay.com/static/uploads/photo/2014/09/27/13/46/question-mark-463497_150.jpg")
                        dispatch_async(dispatch_get_main_queue(), {
                            let imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
                            cell?.backgroundView = imageView
                            self.imgCache.setObject(UIImage(data: NSData(contentsOfURL: imageURL)), forKey: c.text)
                            imageView.image = UIImage(data: NSData(contentsOfURL: imageURL))
                            cell?.backgroundView?.bringSubviewToFront(view)
                        })
                    }
                }
            })
        } else {
            let imageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
            cell?.backgroundView = imageView
            imageView.image = self.imgCache.objectForKey(c.text) as UIImage
            let view = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 80))
            view.backgroundColor = UIColor(white: 0, alpha: 0.5)
            cell?.backgroundView?.addSubview(view)
        }
        

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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
