//
//  ImageViewerViewController.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 23..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import Crashlytics

class ImageViewerViewController: FJViewController {
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var shareToKakaoTalkButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
    var image: UIImage?
    var searchedImage: SearchedImage?
    
    class func create(image: UIImage?, searchedImage: SearchedImage?) -> Self {
        let viewController = self.create(storyboardName: "Main")!
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
        self.imageView.setImage(url: self.searchedImage?.originalUrl, placeholder: self.image, completion: { [weak self] (image) -> Void in
            if let url = self?.searchedImage?.originalUrl, image == nil {
                Answers.logCustomEvent(withName: "Image Download Failure", customAttributes: ["host": URL(string: url)?.host ?? "unknown"])
            }
        })
    }
    
    func setupButtons() {
        // TODO: Language
        self.closeButton.setTitle("Close", for: .normal)
        self.shareToKakaoTalkButton.setTitle("KakaoTalk", for: .normal)
        self.shareButton.setTitle("Share", for: .normal)
    }
    
    @IBAction func onCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onShareToKakaoTalkTapped(_ sender: UIButton) {
        if let link = self.searchedImage?.originalUrl {
            let linkObject: KakaoTalkLinkObject
            if let width = self.searchedImage?.originalWidth, let height = self.searchedImage?.originalHeight {
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
