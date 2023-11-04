//
//  NominationSubmittedViewController.swift
//  iOSTask2
//
//  Created by ARBAZ on 01/11/2023.
//

import UIKit

class NominationSubmittedViewController: UIViewController {

    @IBOutlet weak var backToHomeButton: UIButton!
    @IBOutlet weak var thankYouLabel: UILabel!
    
    @IBOutlet weak var bottomContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        // Do any additional setup after loading the view.
    }
    func initUI() {
        thankYouLabel.setLineHeight(lineHeight: 7)
        backToHomeButton.layer.borderWidth = 2
        backToHomeButton.layer.borderColor = UIColor.black.cgColor
        
        bottomContainerView.layer.shadowColor = UIColor.gray.cgColor
        bottomContainerView.layer.shadowOffset = CGSize(width: 0.0, height : 0.0)
        bottomContainerView.layer.shadowOpacity = 0.3
        bottomContainerView.layer.shadowRadius = 10
    }
    
    @IBAction func createNewTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: Storyboards.Main.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllers.CreateNominationViewController.rawValue) as? CreateNominationViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func backToHomeTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
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
