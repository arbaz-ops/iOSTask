//
//  HomeViewController.swift
//  iOSTask2
//
//  Created by ARBAZ on 31/10/2023.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var topContainerView: UIView!
    @IBOutlet weak var yourNominationsContainerView: UIView!
    @IBOutlet weak var emptyListElementsContainerView: UIView!
    @IBOutlet weak var emptyNominationsLabel: UILabel!
    @IBOutlet weak var yourNominationsTableView: UITableView!
    @IBOutlet weak var bottomContainerView: UIView!
    @IBOutlet weak var greenBackgroundImageView: UIImageView!
    @IBOutlet weak var yourNominationsLabel: UILabel!
    @IBOutlet weak var createNewNominationButton: UIButton!
    var customNavigationViewController: CustomNavigationController?

    var homeViewModel = HomeViewModel(networkManager: NetworkManager())
    var createNominationViewModel = CreateNominationViewModel(networkManager: NetworkManager())
    override func viewDidLoad() {
        
        super.viewDidLoad()
        initUI()
        initTableView()
        
        
        // Do any additional setup after loading the view.
    }
        
    
    func initUI() {
        emptyListElementsContainerView.isHidden = true
        emptyNominationsLabel.text = "ONCE YOU SUBMIT A \nNOMINATION YOU WILL \nBE ABLE TO SEE IT HERE."
        self.customNavigationViewController = self.navigationController as? CustomNavigationController
        customNavigationViewController?.initUI()
        customNavigationViewController?.addLogoInMiddle(vc: self)
        yourNominationsLabel.bringSubviewToFront(greenBackgroundImageView)
        
        bottomContainerView.layer.shadowColor = UIColor.gray.cgColor
        bottomContainerView.layer.shadowOffset = CGSize(width: 0.0, height : 0.0)
        bottomContainerView.layer.shadowOpacity = 0.3
        bottomContainerView.layer.shadowRadius = 10
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.customNavigationViewController = self.navigationController as? CustomNavigationController
        customNavigationViewController?.initUI()
        customNavigationViewController?.addLogoInMiddle(vc: self)
        let customNavBar = self.navigationController as? CustomNavigationController
        customNavBar?.setNavigationBarHidden(false, animated: false)
        homeViewModel.getAllNominations {
            
            DispatchQueue.main.async {[weak self] in
                guard let strongSelf = self else {return}
                if strongSelf.homeViewModel.nominations.count == 0 {
                   
                    strongSelf.emptyListElementsContainerView.isHidden = false
                }
                else {
                    strongSelf.emptyListElementsContainerView.isHidden = true
                }
                strongSelf.yourNominationsTableView.reloadData()
            }
        }

    }
    func initTableView() {
        yourNominationsTableView.delegate = self
        yourNominationsTableView.dataSource = self
        yourNominationsTableView.register(UINib(nibName: TableViewCellIdentifier.NomineeTableViewCell.rawValue, bundle: nil), forCellReuseIdentifier: TableViewCellIdentifier.NomineeTableViewCell.rawValue)
        yourNominationsTableView.separatorColor = .gray
        yourNominationsTableView.separatorStyle = .singleLine
        yourNominationsTableView.estimatedRowHeight = 87
        
        yourNominationsTableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func createNomminationTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: Storyboards.Main.rawValue, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ViewControllers.CreateNominationViewController.rawValue) as? CreateNominationViewController
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeViewModel.nominations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellIdentifier.NomineeTableViewCell.rawValue) as? NomineeTableViewCell
        cell?.preservesSuperviewLayoutMargins = false
        let name = getNominationName(nomineeID: homeViewModel.nominations[indexPath.row].nominee_id)
        cell?.configureData(name: name, reason: homeViewModel.nominations[indexPath.row].reason)
        cell?.separatorInset = UIEdgeInsets.zero
        cell?.layoutMargins = UIEdgeInsets.zero
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteNomination(indexPath: indexPath)
           
        }
    }
    func deleteNomination(indexPath: IndexPath) {
        let nominationID = homeViewModel.nominations[indexPath.row].nomination_id ?? ""
        self.homeViewModel.deleteNomination(nominationID: nominationID) {[weak self] success in
            guard let strongSelf = self else {return}
            if success {
                strongSelf.homeViewModel.nominations.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    strongSelf.yourNominationsTableView.deleteRows(at: [indexPath], with: .fade)
                    
                    if strongSelf.homeViewModel.nominations.count == 0 {
                        strongSelf.emptyListElementsContainerView.isHidden = false
                    }
                    else {
                        strongSelf.emptyListElementsContainerView.isHidden = true
                    }
                }
            }
        }
    }
    func getNominationName(nomineeID: String) -> String {
        let results = createNominationViewModel.nominees?.filter { $0.nominee_id == nomineeID}
        return "\(results?[0].first_name ?? "") \(results?[0].last_name ?? "")"
    }
}
