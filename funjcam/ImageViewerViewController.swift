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
    @IBOutlet weak var shareToKakaoTalkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
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
        
        self.setupButtons()
    }
    
    func setupImageViewer() {
        self.imageView.image = image
    }
    
    func setupButtons() {
        self.closeButton.setTitle(LocalizedString("close"), forState: .Normal)
        self.shareToKakaoTalkButton.setTitle(LocalizedString("kakao_talk"), forState: .Normal)
        self.shareButton.setTitle(LocalizedString("share"), forState: .Normal)
    }
    
    @IBAction func onCloseTapped(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onShareToKakaoTalkTapped(sender: UIButton) {
    }
    
    @IBAction func onShareTapped(sender: UIButton) {
        if let image = self.image {
            let viewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.presentViewController(viewController, animated: true, completion: nil)
        }
    }
    
}
