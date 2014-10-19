//
//  DisplayImageViewController.swift
//  Flashcard
//
//  Created by Ming Lee on 10/19/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

class DisplayImageViewController: UIViewController {
    var imageView:UIImageView!
    var image:UIImage!
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(){
        super.init()
    }
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    init(image: UIImage){
        super.init()
        self.image = image
        
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        super.viewDidLoad()
        imageView = UIImageView(frame: CGRectMake(0, self.view.center.y-self.view.frame.width/2.0, self.view.frame.width, self.view.frame.width))
        imageView.image = image
        self.view.addSubview(imageView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
}
