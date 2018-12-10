//
//  BaseViewController.swift
//  ImageCacheDemo
//
//  Created by Aatish Molasi on 12/8/18.
//  Copyright © 2018 Aatish Molasi. All rights reserved.
//

import Foundation
import UIKit

protocol ViewSetupProtocol {
    func setupViews()
    func setupAppearance()
    func setupConstraints()
    func setupUI()
}

extension ViewSetupProtocol {
    func setupUI() {
        self.setupViews()
        self.setupConstraints()
        self.setupAppearance()
    }
}

class BaseViewController: UIViewController {
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    func showError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in
        })
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
