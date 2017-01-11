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
    var searchedImage: SearchedImage?
    
    class func viewController(image: UIImage?, searchedImage: SearchedImage?) -> ImageViewerViewController {
        let storyboard = UIStoryboard(name: "ImageViewer", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! ImageViewerViewController
        viewController.image = image
        viewController.searchedImage = searchedImage
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
        self.closeButton.setTitle(LocalizedString("close"), for: UIControlState())
        self.shareToKakaoTalkButton.setTitle(LocalizedString("kakao_talk"), for: UIControlState())
        self.shareButton.setTitle(LocalizedString("share"), for: UIControlState())
    }
    
    @IBAction func onCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onShareToKakaoTalkTapped(_ sender: UIButton) {
        if let link = self.searchedImage?.link {
            let linkObject: KakaoTalkLinkObject
            if let width = self.searchedImage?.width, let height = self.searchedImage?.height {
                linkObject = KakaoTalkLinkObject.createImage(link, width: Int32(width), height: Int32(height))
            } else {
                linkObject = KakaoTalkLinkObject.createImage(link, width: 80, height: 80)
            }
            KOAppCall.openKakaoTalkAppLink([linkObject])
        }
    }
    
    @IBAction func onShareTapped(_ sender: UIButton) {
        if let image = self.image {
            let viewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
}
