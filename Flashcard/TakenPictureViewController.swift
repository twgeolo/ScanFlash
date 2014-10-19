//
//  TakenPictureViewController.swift
//  Flashcard
//
//  Created by George Lo on 10/18/14.
//  Copyright (c) 2014 Boilermake Fall 2014. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class TakenPictureViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, TesseractDelegate {
    
    var pictureName: NSMutableArray = NSMutableArray()
    let collectionView: UICollectionView = UICollectionView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 0), collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Gallery".uppercaseString
        
        let allFiles: NSArray = NSFileManager.defaultManager().contentsOfDirectoryAtPath(NSHomeDirectory().stringByAppendingPathComponent("Documents"), error: nil)!
        pictureName = NSMutableArray(array: allFiles.filteredArrayUsingPredicate(NSPredicate(format: "self ENDSWITH '.png'", argumentArray: nil)))
        
        self.collectionView.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSizeMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.width/2)
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        self.collectionView.backgroundColor = UIColor.blackColor()
        self.collectionView.collectionViewLayout = layout
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.view.addSubview(collectionView)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Camera"), style: UIBarButtonItemStyle.Done, target: self, action: "showCamera")
    }
    
    func showCamera() {
        var picker : UIImagePickerController  = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: {
            var image: UIImage = info["UIImagePickerControllerOriginalImage"] as UIImage
            if (image.imageOrientation != UIImageOrientation.Up) {
                UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
                image.drawInRect(CGRectMake(0, 0, image.size.width, image.size.height))
                image = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext();
            }
            let date: NSDate = NSDate()
            let dateFormatter: NSDateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MM-dd_hh:mm:ss_aa"
            let dateStr = dateFormatter.stringFromDate(date)
            DatabaseHelper.executeUpdate("insert into Pictures (desc) values (\'\(dateStr)\')")
            let picDir = NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent(dateStr + ".png")
            UIImagePNGRepresentation(image).writeToFile(picDir, atomically: true)
            self.pictureName.addObject(dateStr + ".png")
            self.collectionView.reloadSections(NSIndexSet(index: 0))
        })
        
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
        
        for view: UIView in cell.contentView.subviews as [UIView] {
            view.removeFromSuperview()
        }
        
        let imageView: AsyncImageView = AsyncImageView(frame: CGRectMake(1, 1, UIScreen.mainScreen().bounds.width/2-2, UIScreen.mainScreen().bounds.width/2-2))
        imageView.imageURL = NSURL(fileURLWithPath: NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent(pictureName[indexPath.row] as String), isDirectory: false)
        
        let label: UILabel = UILabel(frame: CGRectMake(0, UIScreen.mainScreen().bounds.width/2-36+1, UIScreen.mainScreen().bounds.width/2-2, 36-2))
        label.text = (pictureName[indexPath.row] as String).stringByReplacingOccurrencesOfString(".png", withString: "").stringByReplacingOccurrencesOfString("_", withString: " ").stringByReplacingOccurrencesOfString("-", withString: "/")
        label.backgroundColor = UIColor(white: 0.1, alpha: 0.9)
        label.textAlignment = NSTextAlignment.Center
        label.font = UIFont(name: "HelveticaNeue", size: 17)
        label.textColor = UIColor.whiteColor()
        imageView.addSubview(label)
        
        cell.contentView.addSubview(imageView)
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        var tesseract:Tesseract = Tesseract();
        tesseract.language = "eng";
        tesseract.delegate = self;
        //list of char to be recognized
        tesseract.setVariableValue("0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,!()'|[]-_:;?#%^&*<>/@", forKey: "tessedit_char_whitelist");
        
        tesseract.image = UIImage(contentsOfFile: NSHomeDirectory().stringByAppendingPathComponent("Documents").stringByAppendingPathComponent(pictureName[indexPath.row] as String));
        
        tesseract.recognize();
        NSLog("%@", tesseract.recognizedText);
    }

    func degreesToRadians(degrees:Float)->Float{
        let ret: Float = Float(degrees)*3.1415926/180.0
        return ret;
    }
}
