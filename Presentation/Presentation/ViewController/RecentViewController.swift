//
//  RecentViewController.swift
//  funjcam
//
//  Created by box-jeon on 2016. 7. 16..
//  Copyright © 2016년 box-jeon. All rights reserved.
//
import BoxKit

public final class RecentViewController: ViewController, NibLoadable {
  
  public static func create() -> Self {
    let viewController = self.createFromStoryboard(name: "Main")
    return viewController
  }
}
