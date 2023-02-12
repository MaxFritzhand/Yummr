//
//  ProfileViewController.swift
//  PlopIt
//
//  Created by Raeein on 03/24/2022.
//

import UIKit
import FirebaseAuth
import SwiftProtobuf
import FirebaseFirestore
import Firebase

class ProfileViewController: PIViewController {

    
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet var profileTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarFunction()
        API.shared.userManager.addConsumer(consumer: self)
        setupTableView()
        setupUIElements()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
         getCurrentUserInfo()
    }
    
    func setupTableView() {
        profileTableView.delegate = self
        profileTableView.dataSource = self
        profileTableView.register(UINib(nibName: "ProfileTableViewCell", bundle: nil), forCellReuseIdentifier: "ProfileTableViewCell")
        profileTableView.isScrollEnabled = false;
    }
    
    func setupUIElements() {
        changePasswordButton.addBorder(withColor: .darkGray, width: 1)
        changePasswordButton.layer.cornerRadius = 15
        logOutButton.addBorder(withColor: .darkGray, width: 1)
        logOutButton.layer.cornerRadius = 15
    }
    
    func setupNavBarFunction() {
        self.title = "Account Settings"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController!.navigationBar.barStyle = .black
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(didTapCellButton(_:)))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(hex: "#FE7700")
        appearance.shadowColor = .clear
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
    }
    
    func getCurrentUserInfo() {
        let service = UserService()
        let email = Auth.auth().currentUser!.email!
        
        service.getCurrentUserInfoWithEmail(UserEmail: email) { user in
            AccountRows.updateInfo(user)
            self.profileTableView.reloadData()
        }
    }
    
    @IBAction func changePasswordPressed(_ sender: UIButton) {
        let vc = ForgotPasswordViewController()
        vc.update(mainText: "Reset your password", subtitle: "Please enter the address you would like your new password information sent to", dismissText: "Dismiss")
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    @IBAction func logOutPressed(_ sender: UIButton) {
        API.shared.userManager.logout()
        UserDefaults.standard.set(true, forKey: "firstTimeLaunched")
    }
    
    @objc func didTapCellButton(_ sender: UIButton) {
        print("Button Got tapped")
        /*let vc =
        self.present(vc, animated: true, completion: nil)*/
    }
    
}

extension ProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90)
    }
}


extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AccountRows.userRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as! ProfileTableViewCell
        cell.update(data: AccountRows.userRows[indexPath.row])        
        return cell
    }
}
    
extension ProfileViewController: UserManagerConsumer {
    func userDidLogOut() {
        let vc = UINavigationController(rootViewController: LoginViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
