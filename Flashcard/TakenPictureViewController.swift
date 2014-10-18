//
//  TakenPictureViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class TakenPictureViewController: UICollectionViewController {
    
    var pictureName: NSMutableArray = NSMutableArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(70, 103)
        layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.collectionView?.collectionViewLayout = layout
        
        let rs: FMResultSet = DatabaseHelper.executeQuery("SELECT id FROM Picture")
        while (rs.next()) {
            self.pictureName.addObject(rs)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictureName.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
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

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Did select
    }

}
