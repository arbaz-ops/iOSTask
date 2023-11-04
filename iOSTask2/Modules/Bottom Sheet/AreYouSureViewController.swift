//
//  AreYouSureViewController.swift
//  iOSTask2
//
//  Created by ARBAZ on 01/11/2023.
//

import UIKit

class AreYouSureViewController: UIViewController {

    @IBOutlet weak var areYouSureLabel: UILabel!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var ifYouLeaveLabel: UILabel!
    
    @IBOutlet weak var leavePageButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var leavePage: (() -> Void)?
    override func viewDidLoad() {
        
        super.viewDidLoad()

        initUI()
    }
    
    func initUI() {
        bottomContainerView.layer.shadowColor = UIColor.gray.cgColor
        bottomContainerView.layer.shadowOffset = CGSize(width: 0.0, height : 0.0)
        bottomContainerView.layer.shadowOpacity = 0.3
        bottomContainerView.layer.shadowRadius = 10
        ifYouLeaveLabel.setLineHeight(lineHeight: 7)
        cancelButton.layer.borderColor = UIColor.black.cgColor
        cancelButton.layer.borderWidth = 2
        
        leavePageButton.layer.borderColor = UIColor.black.cgColor
        leavePageButton.layer.borderWidth = 2
    }

    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func leavePageTapped(_ sender: Any) {
        self.dismiss(animated: true)
        self.leavePage?()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
