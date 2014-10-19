//
//  AppDelegate.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UITableViewDelegate, UIAlertViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    var sourceType: UIImagePickerControllerSourceType?
    var window: UIWindow?
    var open: Bool = false
    var slidingViewController: ECSlidingViewController?
    var topViewSnapshot: UIView?
    var rowNames: [String]?
    var homeButton: UIButton!
    var addButton: UIButton!
    
    let sideMenuVC : SideMenuViewController = SideMenuViewController()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        println(NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String)
        //DatabaseHelper.executeUpdate("drop table Lists")
        //DatabaseHelper.executeUpdate("drop table Cards")
        //DatabaseHelper.executeUpdate("drop table Pictures")
        DatabaseHelper.executeUpdate("create table if not exists Lists (id INTEGER PRIMARY KEY, name TEXT)")
        DatabaseHelper.executeUpdate("create table if not exists Cards (id INTEGER PRIMARY KEY, englishText TEXT, foreignText TEXT, favorite INT, listId INTEGER, PicId INTEGER)")
        DatabaseHelper.executeUpdate("create table if not exists Pictures (id INTEGER PRIMARY KEY, desc TEXT)")
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        let viewController : TakenPictureViewController = TakenPictureViewController()
        
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "SideMenu"), style: UIBarButtonItemStyle.Done, target: self, action: "showMenu")
        

         viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Camera"), style: UIBarButtonItemStyle.Done, target: self, action: "showCam")

        
        let navigationController: UINavigationController = createNavController(viewController)
        slidingViewController = ECSlidingViewController(topViewController: navigationController)
        
        rowNames = sideMenuVC.rowNames
        sideMenuVC.tableView.delegate = self
        slidingViewController?.underLeftViewController = sideMenuVC
        slidingViewController?.anchorLeftRevealAmount = 250.0;
        
        self.window?.rootViewController = slidingViewController
        self.window?.makeKeyAndVisible()
        
        
        
        return true
    }
    
    func createNavController(viewController: UIViewController) -> UINavigationController {
        let navigationController: UINavigationController = UINavigationController()
        navigationController.viewControllers = [viewController]
        navigationController.view.backgroundColor = UIColor.whiteColor()
        return navigationController
    }
    
    func showMenu() {
        if open {
            open = false
            slidingViewController?.resetTopViewAnimated(true)
        } else {
            open = true
            slidingViewController?.anchorTopViewToRightAnimated(true)
        }
    }
    
   
    
    // MARK: - Table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var navigationController: UINavigationController?
            
            if (sideMenuVC.rowNames[indexPath.row] as NSString).isEqualToString("Gallery") {
                navigationController = createNavController(TakenPictureViewController())
            } else if (sideMenuVC.rowNames[indexPath.row] as NSString).isEqualToString("All") {
                    navigationController = createNavController(ListViewController(id: 0))
            } else if (sideMenuVC.rowNames[indexPath.row] as NSString).isEqualToString("Favorite") {
                navigationController = createNavController(ListViewController(id: 1))
            } else if (sideMenuVC.rowNames[indexPath.row] as NSString).isEqualToString("Recommended") {
                navigationController = createNavController(ListViewController(id: 2))
            } else
            {
                navigationController = createNavController(ListViewController(id: indexPath.row))
            }
            
            slidingViewController?.topViewController = navigationController
            (slidingViewController?.topViewController as UINavigationController).viewControllers[0].navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "SideMenu"), style: .Done, target: self, action: "showMenu")
            open = false
            slidingViewController?.resetTopViewAnimated(true)
            slidingViewController?.viewWillAppear(true);
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 160
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView: UIView = UIView(frame: CGRectMake(0, 0, 280, 160))
        
        let homeBtnView: UIView = UIView(frame: CGRectMake(0, 0, 276, 110))
        homeButton = UIButton(frame: CGRectMake(0, 40, 276, 70))
        homeButton.backgroundColor = UIColor.clearColor()
        homeButton.setTitle("FLASHCARD", forState: UIControlState.Normal)
        homeButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        homeButton.titleLabel?.font = UIFont.systemFontOfSize(36.0)
        homeButton.titleLabel?.textAlignment = NSTextAlignment.Center
        homeButton.addTarget(UIApplication.sharedApplication().delegate as AppDelegate, action: "homeButtonPressed",forControlEvents: UIControlEvents.TouchUpInside)
        homeBtnView.addSubview(homeButton)
        
        let toolbar: UIToolbar = UIToolbar(frame: CGRectMake(0,106,276,50))
        toolbar.tintColor = UIColor.whiteColor()
        toolbar.setBackgroundImage(UIImage(), forToolbarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        toolbar.setShadowImage(UIImage(), forToolbarPosition: UIBarPosition.Any)
        let addBtn: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "addCategory")
        let att: NSDictionary = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 30)]
        addBtn.setTitleTextAttributes(att, forState: UIControlState.Normal)
        let space: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        toolbar.items = [space,addBtn]
        let upperLayer = CALayer()
        upperLayer.frame = CGRectMake(0, 158, 1000, 1)
        upperLayer.backgroundColor = UIColor(white: 0.5, alpha: 0.6).CGColor
        headerView.layer.addSublayer(upperLayer)
        
        headerView.addSubview(toolbar)
        headerView.addSubview(homeBtnView)
        return headerView
    }
    

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func homeButtonPressed(){
        //showMenu()
    }
    
    func addCategory(){
        let alertview: UIAlertView = UIAlertView(title: "Add Category", message: "Enter Category Name:", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Add")
        alertview.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertview.show()
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let s = alertView.buttonTitleAtIndex(buttonIndex)
        if (s != "Cancel"){
            let categoryName: NSString = alertView.textFieldAtIndex(0)!.text
            DatabaseHelper.executeUpdate("INSERT INTO Lists (name) VALUES (\'\(categoryName)\')")
            sideMenuVC.rowNames.append(categoryName)
            sideMenuVC.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
        }
    }
}

