//
//  CreateNominationViewController.swift
//  iOSTask2
//
//  Created by ARBAZ on 31/10/2023.
//

import UIKit

class CreateNominationViewController: UIViewController {

    @IBOutlet weak var cubeNameTextField: UITextField!
    @IBOutlet weak var pleaseSelectLabel: UILabel!
    @IBOutlet weak var bottomContainerView: UIView!
    
    @IBOutlet weak var submitNominationButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var pleaseLetUsKnowLabel: UILabel!
    
    @IBOutlet weak var reasoningTextView: UITextView!
    
    @IBOutlet weak var isHowWeCanLabel: UILabel!
    
    @IBOutlet weak var asYouKnowLabel: UILabel!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet var radioButtonContainerViews: [UIView]!
    
    @IBOutlet weak var veryUnfairRadioContainerView: UIView!
    
    @IBOutlet weak var fairRadioContainerView: UIView!
    
    @IBOutlet weak var notSureRadioContainerView: UIView!
    
    @IBOutlet weak var secondaryFairContainerView: UIView!
    
    @IBOutlet weak var veryFairRadioContainerView: UIView!
    
    @IBOutlet weak var veryUnfairRadioImageView: UIImageView!
    
    @IBOutlet weak var fairRadioImageView: UIImageView!
    
    @IBOutlet weak var notSureRadioImageView: UIImageView!
    
    @IBOutlet weak var secondaryFairRadioImageView: UIImageView!
    
    @IBOutlet weak var veryFairRadioImageView: UIImageView!
    
    var process: String = ""
    var startedEditing: Bool? = false
    let pickerView = UIPickerView()
    let createNominationViewModel = CreateNominationViewModel(networkManager: NetworkManager())
    let homeViewModel = HomeViewModel(networkManager: NetworkManager())
    var selectedNominee: Int?
    var isValidated: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initUI()
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let customNavBar = self.navigationController as? CustomNavigationController
        customNavBar?.setNavigationBarHidden(true, animated: false)
    }
   func initUI() {
       pickerView.dataSource = self
       pickerView.delegate = self
       submitNominationButton.isEnabled = false

       let toolBar = UIToolbar()
       toolBar.barStyle = UIBarStyle.default
       toolBar.isTranslucent = true
       toolBar.sizeToFit()

       let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(donePicker))
      
       cubeNameTextField.inputView = pickerView


       toolBar.setItems([doneButton], animated: false)
       cubeNameTextField.inputAccessoryView = toolBar

       
       bottomContainerView.layer.shadowColor = UIColor.gray.cgColor
       bottomContainerView.layer.shadowOffset = CGSize(width: 0.0, height : 0.0)
       bottomContainerView.layer.shadowOpacity = 0.3
       bottomContainerView.layer.shadowRadius = 10
      
       pleaseSelectLabel.setLineHeight(lineHeight: 7)
       pleaseLetUsKnowLabel.setLineHeight(lineHeight: 7)
       cubeNameTextField.layer.borderWidth = 1
       cubeNameTextField.borderStyle = .roundedRect
       cubeNameTextField.layer.borderColor = UIColor.init(named: "MediumGray")?.cgColor
       
       cubeNameTextField.setLeftPaddingPoints(13)
       cubeNameTextField.setRightPaddingPoints(19)
       cubeNameTextField.leftImage(UIImage.init(named: "DownwardChevron"), imageWidth: 10, padding: 19)
       reasoningTextView.layer.borderColor = UIColor.init(named: "MediumGray")?.cgColor
       reasoningTextView.layer.borderWidth = 1
       reasoningTextView.contentInset = UIEdgeInsets(top: 7, left: 13, bottom: 7, right: 13)
       
       let text = ""

       let font = UIFont(name: "AnonymousPro-Regular", size: 16)!
       // let font = UIFont.systemFontOfSize(31.0)

       let paragraph = NSMutableParagraphStyle()
       paragraph.lineHeightMultiple = 1.5
       paragraph.alignment = NSTextAlignment.left

       let attributes = [ NSAttributedString.Key.paragraphStyle: paragraph, NSAttributedString.Key.font: font ]

       reasoningTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
      
       
       let stringOne = "IS HOW WE CURRENTLY RUN CUBE OF THE MONTH FAIR?"
       let stringTwo = "CUBE OF THE MONTH"

       let range = (stringOne as NSString).range(of: stringTwo)

       let attributedText = NSMutableAttributedString.init(string: stringOne)
       attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(named: "Pink")! , range: range)
       isHowWeCanLabel.attributedText = attributedText
       
       asYouKnowLabel.setLineHeight(lineHeight: 7)

       radioButtonContainerViews.forEach { view in
           view.isUserInteractionEnabled = true
         
           view.layer.borderWidth = 1
           view.layer.borderColor = UIColor.init(named: "MediumGray")?.cgColor
       }
       veryUnfairRadioContainerView.isUserInteractionEnabled = true
       veryUnfairRadioContainerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(radioButtonTapped(_:))))
       fairRadioContainerView.isUserInteractionEnabled = true
       fairRadioContainerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(radioButtonTapped(_:))))
       notSureRadioContainerView.isUserInteractionEnabled = true
       notSureRadioContainerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(radioButtonTapped(_:))))
       secondaryFairContainerView.isUserInteractionEnabled = true
       secondaryFairContainerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(radioButtonTapped(_:))))
       veryFairRadioContainerView.isUserInteractionEnabled = true
       veryFairRadioContainerView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(radioButtonTapped(_:))))
       
       backButton.layer.borderColor = UIColor.black.cgColor
       backButton.layer.borderWidth = 2
       
       reasoningTextView.delegate = self
       cubeNameTextField.delegate = self
       cubeNameTextField.attributedPlaceholder = NSAttributedString(
           string: "Select Option",
           attributes: [NSAttributedString.Key.foregroundColor: UIColor.black,
                        NSAttributedString.Key.font: UIFont(name: "AnonymousPro-Regular", size: 16.0)!]
       )
    }
   
    
    @IBAction func submitNominationTapped(_ sender: Any) {
        let nomineeID = self.createNominationViewModel.nominees?[self.selectedNominee ?? 0].nominee_id
        let reason = self.reasoningTextView.text
        
        self.createNominationViewModel.createNomination(nomineeID: nomineeID, reason: reason, process: self.process) { result in
            DispatchQueue.main.async {[self] in
                homeViewModel.appendData(nomination: result)
                
                pushToNominationSubmittedScreen()
            }
        }
    }
    func pushToNominationSubmittedScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllers.NominationSubmittedViewController.rawValue) as? NominationSubmittedViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @objc func radioButtonTapped(_ sender: UITapGestureRecognizer) {
        let tag = sender.view?.tag
        let view = sender.view
        
        switch tag {
        case 0:
            selectedRadioButton(view: veryUnfairRadioContainerView, radioImage: veryUnfairRadioImageView)
            unselectedRadioButton(view: fairRadioContainerView, radioImage: fairRadioImageView)
            unselectedRadioButton(view: notSureRadioContainerView, radioImage: notSureRadioImageView)
            unselectedRadioButton(view: secondaryFairContainerView, radioImage: secondaryFairRadioImageView)
            unselectedRadioButton(view: veryFairRadioContainerView, radioImage: veryFairRadioImageView)
            self.process = "very_unfair"
            self.cubeNameTextField.resignFirstResponder()
            self.reasoningTextView.resignFirstResponder()
            validateFields()
            self.startedEditing = true

        case 1:
            selectedRadioButton(view: fairRadioContainerView, radioImage: fairRadioImageView)
            unselectedRadioButton(view: veryUnfairRadioContainerView, radioImage: veryUnfairRadioImageView)
            unselectedRadioButton(view: notSureRadioContainerView, radioImage: notSureRadioImageView)
            unselectedRadioButton(view: secondaryFairContainerView, radioImage: secondaryFairRadioImageView)
            unselectedRadioButton(view: veryFairRadioContainerView, radioImage: veryFairRadioImageView)
            self.cubeNameTextField.resignFirstResponder()
            self.reasoningTextView.resignFirstResponder()
            self.process = "unfair"
            validateFields()
            self.startedEditing = true

        case 2:
            selectedRadioButton(view: notSureRadioContainerView, radioImage: notSureRadioImageView)
            unselectedRadioButton(view: veryUnfairRadioContainerView, radioImage: veryUnfairRadioImageView)
            unselectedRadioButton(view: fairRadioContainerView, radioImage: fairRadioImageView)
            unselectedRadioButton(view: secondaryFairContainerView, radioImage: secondaryFairRadioImageView)
            unselectedRadioButton(view: veryFairRadioContainerView, radioImage: veryFairRadioImageView)
            self.cubeNameTextField.resignFirstResponder()
            self.reasoningTextView.resignFirstResponder()
            self.process = "not_sure"
            validateFields()
            self.startedEditing = true

        case 3:
            selectedRadioButton(view: secondaryFairContainerView, radioImage: secondaryFairRadioImageView)
            unselectedRadioButton(view: veryUnfairRadioContainerView, radioImage: veryUnfairRadioImageView)
            unselectedRadioButton(view: fairRadioContainerView, radioImage: fairRadioImageView)
            unselectedRadioButton(view: notSureRadioContainerView, radioImage: notSureRadioImageView)
            unselectedRadioButton(view: veryFairRadioContainerView, radioImage: veryFairRadioImageView)
            self.cubeNameTextField.resignFirstResponder()
            self.reasoningTextView.resignFirstResponder()
            self.process = "fair"
            validateFields()
            self.startedEditing = true

        case 4:
            selectedRadioButton(view: veryFairRadioContainerView, radioImage: veryFairRadioImageView)
            unselectedRadioButton(view: veryUnfairRadioContainerView, radioImage: veryUnfairRadioImageView)
            unselectedRadioButton(view: fairRadioContainerView, radioImage: fairRadioImageView)
            unselectedRadioButton(view: notSureRadioContainerView, radioImage: notSureRadioImageView)
            unselectedRadioButton(view: secondaryFairContainerView, radioImage: secondaryFairRadioImageView)
            self.cubeNameTextField.resignFirstResponder()
            self.reasoningTextView.resignFirstResponder()

            self.process = "very_fair"
            validateFields()
            self.startedEditing = true

        default:
            break
        }
      
    }
    @objc func donePicker() {
        cubeNameTextField.resignFirstResponder()
    }
    func selectedRadioButton(view: UIView, radioImage: UIImageView) {
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOffset = CGSize(width: 0.0, height : 2)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowRadius = 10
        radioImage.image = UIImage(named: "SelectedRadioButton")
        view.layer.borderColor = UIColor.init(named: "Gray")?.cgColor
    }
    func unselectedRadioButton(view: UIView, radioImage: UIImageView) {
        view.layer.shadowColor = UIColor.white.cgColor
        view.layer.borderColor = UIColor.init(named: "MediumGray")?.cgColor
        radioImage.image = UIImage(named: "UnselectedRadioIcon")
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        if self.isValidated || self.startedEditing ?? false {
            pushToAreYouSureModal()
        }
        else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
   
    func pushToAreYouSureModal() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllers.AreYouSureViewController.rawValue) as? AreYouSureViewController
        vc?.modalPresentationStyle = .overFullScreen
        vc?.leavePage = {
            self.navigationController?.popToRootViewController(animated: true)
        }
        self.navigationController?.present(vc!, animated: true)
    }
}

extension CreateNominationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.createNominationViewModel.nominees?.count ?? 0
    }

    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.createNominationViewModel.nominees?[row].first_name ?? "") \(self.createNominationViewModel.nominees?[row].last_name ?? "")"
    }

    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.cubeNameTextField.text = "\(self.createNominationViewModel.nominees?[row].first_name ?? "") \(self.createNominationViewModel.nominees?[row].last_name ?? "")"
        self.selectedNominee = row
        
    }

}


extension CreateNominationViewController: UITextViewDelegate, UITextFieldDelegate {
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text)
        validateFields()
    }
    func textFieldDidChangeSelection(_ textField: UITextField) {
       validateFields()
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.startedEditing = true
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = "\(self.createNominationViewModel.nominees?[0].first_name ?? "") \(self.createNominationViewModel.nominees?[0].last_name ?? "")"
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.startedEditing = true
    }
    func validateFields() {
        guard !reasoningTextView.text.isEmpty || reasoningTextView.text != "",
            !cubeNameTextField.text!.isEmpty || cubeNameTextField.text != "",
              self.process != "" else {
            disableButton()
            return
        }
        enableButton()
        
    }
    
    func disableButton(){
        self.isValidated = false
        submitNominationButton.backgroundColor = UIColor(named: "MediumGray")
        submitNominationButton.setTitleColor(UIColor.white, for: .normal)
        submitNominationButton.isEnabled = false
    }
    
    func enableButton(){
        self.isValidated = true
        submitNominationButton.backgroundColor = UIColor.black
        submitNominationButton.setTitleColor(UIColor.white, for: .normal)
        submitNominationButton.isEnabled = true
    }
}
