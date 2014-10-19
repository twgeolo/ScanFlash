//
//  TakenPictureViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class TakenPictureViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var pictureName: NSMutableArray = NSMutableArray()
    let collectionView: UICollectionView = UICollectionView(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 64 - 44), collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gallery".uppercaseString
        
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width/4, UIScreen.mainScreen().bounds.width/4)
        layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.collectionView.collectionViewLayout = layout
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Camera"), style: UIBarButtonItemStyle.Done, target: self, action: "showCamera")
        
        let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id FROM Cards")
        while (rs.next()) {
            self.pictureName.addObject("\(rs.objectForColumnIndex(0))")
        }
    }
    
    func showCamera() {
        
        var picker : UIImagePickerController  = UIImagePickerController();
        picker.delegate = self;
        picker.allowsEditing = true;
        picker.sourceType = UIImagePickerControllerSourceType.Camera;
        
        self.presentViewController(picker, animated: true, completion: { imageP in });
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureName.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, 80, 80))
        imageView.imageURL = NSURL(fileURLWithPath: NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent("\(pictureName[indexPath.row]).jpg"))
        imageView.layer.borderColor = UIColor.whiteColor().CGColor
        imageView.layer.borderWidth = 1.5
        cell.contentView.addSubview(imageView)
        
        cell.backgroundColor = UIColor.clearColor()
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Did select
    }

}
