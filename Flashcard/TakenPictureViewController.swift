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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as UICollectionViewCell
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        /*for (UIView *view in cell.contentView.subviews) {
            [view removeFromSuperview];
        }
        
        Person *friend = [friendsAry objectAtIndex:indexPath.row];
        UIImageView *imageView;
        if (friend.imageData!=(NSData *)[NSNull null] && friend.imageData!=nil) {
            imageView = [[UIImageView alloc] initWithImage:[ApplicationDelegate makeCircularImage:[UIImage imageWithData:friend.imageData] withFrame:CGRectMake(0, 0, 70, 70)]];
        } else {
            if ([friend.gender isEqualToString:@"M"]) {
                imageView = [[UIImageView alloc] initWithImage:[ApplicationDelegate makeCircularImage:[UIImage imageNamed:@"Male"] withFrame:CGRectMake(0, 0, 70, 70)]];
            } else {
                imageView = [[UIImageView alloc] initWithImage:[ApplicationDelegate makeCircularImage:[UIImage imageNamed:@"Female"] withFrame:CGRectMake(0, 0, 70, 70)]];
            }
        }
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1.5;
        imageView.layer.cornerRadius = 35;
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 70, 70, 23)];
        nameLabel.text = [[friend.displayName componentsSeparatedByString:@" "] objectAtIndex:0];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:14];
        
        [cell.contentView addSubview:imageView];
        [cell.contentView addSubview:nameLabel];
        cell.backgroundColor = [UIColor clearColor];*/
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Did select
    }

}
