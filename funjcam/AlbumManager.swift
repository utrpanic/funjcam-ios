//
//  AlbumManager.swift
//  funjcam
//
//  Created by boxjeon on 2016. 7. 24..
//  Copyright © 2016년 boxjeon. All rights reserved.
//

import Photos

class AlbumManager {
    
    static let albumName = NSBundle.mainBundle().objectForInfoDictionaryKey(kCFBundleNameKey as String) as! String
    
    func save(image image: UIImage?) {
//        var albumPlaceholder: PHObjectPlaceholder?
//        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
//            // Request creating an album with parameter name
//            let createAlbumRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollectionWithTitle(AlbumManager.albumName)
//            // Get a placeholder for the new album
//            albumPlaceholder = createAlbumRequest.placeholderForCreatedAssetCollection
//            }, completionHandler: { success, error in
//                guard let placeholder = albumPlaceholder else {
//                    assert(false, "Album placeholder is nil")
//                }
//                let fetchResult = PHAssetCollection.fetchAssetCollectionsWithLocalIdentifiers([placeholder.localIdentifier], options: nil)
//                guard let album = fetchResult.firstObject as? PhotoAlbum else {
//                    assert(false, "FetchResult has no PHAssetCollection")
//                }
//        })
    }
    
}
