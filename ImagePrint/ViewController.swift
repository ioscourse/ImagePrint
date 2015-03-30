//
//  ViewController.swift
//  ImagePrint
//
//  Created by Charles Konkol on 3/30/15.
//  Copyright (c) 2015 Rock Valley College. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIWebViewDelegate,UIDocumentInteractionControllerDelegate {
 var intTop:CGFloat = 50
   
    @IBOutlet weak var nav: UINavigationItem!
    
    @IBOutlet weak var btnPrint: UIButton!
    
    @IBAction func btnPrint(sender: UIButton) {
        let screenshot = self.view?.pb_takeSnapshot()
        let selectedImage : UIImage = screenshot!
        UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        
        var fileName:String = "new.pdf"
        var rect =  CGRectMake(0, 0, 850, 1100)
        var path = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        
        var pdfPath = path.stringByAppendingPathComponent(fileName)
        //var pdfPath =  NSBundle.mainBundle().pathForResource(fileName, ofType: "pdf")!
        UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil)
        UIGraphicsBeginPDFPageWithInfo(rect, nil)
        var currentContext:CGContextRef = UIGraphicsGetCurrentContext()
        var imageView : UIImageView
        imageView  = UIImageView(frame:CGRectMake(0,0,850, 1100));
        imageView.image = selectedImage
        imageView.image?.drawInRect(rect)
        UIGraphicsEndPDFContext()
        
        let webV:UIWebView = UIWebView(frame: CGRectMake(0, 50, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        
       
    
        let url = NSURL(fileURLWithPath: pdfPath)
        let pdfRequest = NSURLRequest(URL: url!)
        webV.loadRequest(pdfRequest)
        webV.delegate = self;
        self.view.addSubview(webV)

    }
    
   @IBAction func btnAdd(sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            println("Select Photo")
            var imag = UIImagePickerController()
            imag.delegate = self
            imag.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
            //imag.mediaTypes = [kUTTypeImage];
            imag.allowsEditing = false
            self.presentViewController(imag, animated: true, completion: nil)
        }

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!) {
        if intTop == 50
        {
            
        }
        else
        {
            intTop = intTop + 50
        }
        intTop = intTop + 50
        let selectedImage : UIImage = image
        //var tempImage:UIImage = editingInfo[UIImagePickerControllerOriginalImage] as UIImage
        var imageView : UIImageView
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        imageView  = UIImageView(frame:CGRectMake(0,intTop,screenSize.width, 100));
        // imageView.contentMode = UIViewContentMode.ScaleAspectFill
        
        imageView.image = selectedImage
        
        imageView.userInteractionEnabled = true
        
        self.view.addSubview(imageView)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func toggle(sender: AnyObject) {
        navigationController?.setNavigationBarHidden(navigationController?.navigationBarHidden == false, animated: true) //or animated: false
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return navigationController?.navigationBarHidden == true
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return UIStatusBarAnimation.Fade
    }
    
    
}
extension UIView {
    
    func pb_takeSnapshot() -> UIImage {
         var rect =  CGRectMake(0, -100,  UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.mainScreen().scale)
        
        drawViewHierarchyInRect(rect, afterScreenUpdates: true)
        
        // old style: layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
extension UIWebView {
    func loadLocalPDF(name:String!) {
        //load local pdf
       let termsPath:String? = NSBundle.mainBundle().pathForResource(name, ofType: "pdf")!
        let url = NSURL(fileURLWithPath: termsPath!)
        let pdfRequest = NSURLRequest(URL: url!)
        self.loadRequest(pdfRequest)
    }
    func loadExternalPDF(name:String!){
        let url = NSURL(string: name)
        let request = NSURLRequest(URL:url!)
        self.scalesPageToFit = true
        self.loadRequest(request)
    }
}
