//
//  CustomNavigationController.swift
//  iOSTask2
//
//  Created by ARBAZ on 31/10/2023.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        
        // Do any additional setup after loading the view.
    }
    
    func initUI() {
        self.navigationBar.backgroundColor = .black
        self.navigationBar.barTintColor = .black
       


    }

    func addLogoInMiddle(vc: UIViewController) {
        let appLogo = UIImage(named: "logo")
        let imageToPutOnNavBar = UIImageView(image: appLogo)
        vc.navigationItem.titleView = imageToPutOnNavBar

    }

}
