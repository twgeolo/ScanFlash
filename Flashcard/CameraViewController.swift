//
//  APPViewController.m
//  CameraApp
//
//  Created by Rafael Garcia Leiva on 10/04/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

import UIkit

class CameraViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var imageView : UIImageView!
    
    override func viewDidLoad () {
    
        super.viewDidLoad()
        
       
   
    }
    
    override func viewDidAppear(animated : Bool) {
        
        super.viewDidAppear(animated);
        
    }
        
    func showCamera() {
            
            var picker : UIImagePickerController  = UIImagePickerController();
            picker.delegate = self;
            picker.allowsEditing = true;
        
            picker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum
           // picker.sourceType = UIImagePickerControllerSourceType.Camera;
            
            self.presentViewController(picker, animated: true, completion: { imageP in });
            
    }
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        let selectedImage : UIImage = image
    }
    
}
