//
//  ImageViewerViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 23..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

class ImageViewerViewController: BaseViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    
    class func viewController(image image: UIImage?) -> ImageViewerViewController {
        let storyboard = UIStoryboard(name: "ImageViewer", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! ImageViewerViewController
        viewController.image = image
        return viewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupImageViewer()
    }
    
    func setupImageViewer() {
        self.imageView.image = image
    }
    
    @IBAction func onCloseTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
