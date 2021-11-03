//
//  SettingsViewController.swift
//  FunJCam
//
//  Created by box-jeon on 2018. 4. 29..
//  Copyright © 2018년 box-jeon. All rights reserved.
//
import BoxKit

public final class SettingsViewController: ViewController, NibLoadable {
  
  public static func create() -> Self {
    let viewController = self.createFromStoryboard(name: "Main")
    return viewController
  }
}
