//
//  PersonalPageViewController.swift
//  TickHelp
//
//  Created by Ariel on 4/9/16.
//  Copyright © 2016 Ariel. All rights reserved.
//

import UIKit
import Firebase


class PersonalPageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var avator: UIImageView!
    @IBOutlet weak var userName: UILabel!
    let ref = Firebase(url:constant.userURL + "/users/" + constant.uid)
    let locationRef = Firebase(url: constant.userURL + "/locations/")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.avator.image = maskRoundedImage(centerCrop(self.avator.image!))
        self.avator.image = resizeImage(self.avator.image!, targetSize: CGSize(width: 160, height: 160))
        
        print(ref)
        
        // Get the data on a post that has changed
        ref.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            //Get the data from the firebase
            self.userName.text = snapshot.value.objectForKey("nickname") as? String
            //Store the image to firebase
            let base64EncodedString = snapshot.value.objectForKey("image_path") as! String
            let imageRetrieve = NSData(base64EncodedString: base64EncodedString ,
                options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
            let decodedImage = UIImage(data:imageRetrieve!)
            if(decodedImage != nil){
            self.avator.image = decodedImage
            }

            }, withCancelBlock: { error in
                print(error.description)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func uploadImage(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = false
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
    }
    
 
    func uploadtoFireBase(image: UIImage){
        
        var uploadImage = image
        
        uploadImage = maskRoundedImage(centerCrop(uploadImage))
        uploadImage = resizeImage(uploadImage, targetSize: CGSize(width: 160, height: 160))
        
        let imageData = UIImageJPEGRepresentation(uploadImage, 0.5)!
        let base64String = imageData.base64EncodedStringWithOptions(.Encoding64CharacterLineLength)
        let imageRef = ref.childByAppendingPath("image_path")
        imageRef.setValue(base64String)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        self.avator.image = maskRoundedImage(centerCrop(image))
        self.avator.image = resizeImage(self.avator.image!, targetSize: CGSize(width: 180, height: 180))
        print("uploaded")
        uploadtoFireBase(self.avator.image!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func logOutBtnPressed(sender: UIBarButtonItem) {
     //   locationRef.observeSingleEventOfType(.Value, withBlock: { snapshot in
     //   })
        
        
        let next = self.storyboard!.instantiateViewControllerWithIdentifier("InitialViewController")
        self.presentViewController(next, animated: true, completion: nil)

    }
    
    func centerCrop(image: UIImage) -> UIImage{
        let width = image.size.width
        let height = image.size.height
        let contextImage: UIImage = UIImage(CGImage: image.CGImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRectMake(posX, posY, cgwidth, cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImageRef = CGImageCreateWithImageInRect(contextImage.CGImage, rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(CGImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
    
    func maskRoundedImage(image: UIImage) -> UIImage {
        
        let imageView = UIImageView(image: image)
        
        
        var layer: CALayer = CALayer()
        layer = imageView.layer
        
        layer.masksToBounds = true
        layer.cornerRadius = CGFloat(25)
        
        UIGraphicsBeginImageContext(imageView.bounds.size)
        layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(size.width * heightRatio, size.height * heightRatio)
        } else {
            newSize = CGSizeMake(size.width * widthRatio,  size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRectMake(0, 0, newSize.width, newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
