//
//  DashboardViewController.swift
//  PlopIt
//
//  Created by e on 3/29/22.
//

import UIKit
import MessageUI

class DashboardViewController: PIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var dashboardTableView: UITableView!
    
    var isOwner = UserDefaults.standard.bool(forKey: "isOwner")
    var restaurant: Restaurant
    
    init(withRestaurantData restaurantData: Restaurant) {
        self.restaurant = restaurantData
        //self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarFunction()
    
        setupTableView()
        print(isOwner)
        // Do any additional setup after loading the view.
    }

    func setupTableView() {
        dashboardTableView.delegate = self
        dashboardTableView.dataSource = self
        dashboardTableView.register(UINib(nibName: "DashboardTableViewCell", bundle: nil), forCellReuseIdentifier: "DashboardTableViewCell")
        dashboardTableView.layer.cornerRadius = 25
        dashboardTableView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        //self.navigationController?.isNavigationBarHidden = true
    
    }
    
    func setupNavBarFunction() {
        self.title = "Dashboard"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController!.navigationBar.barStyle = .black
        
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = UIColor(hex: "#FE7700")
        appearance.shadowColor = .clear
        
        let backItem = UIBarButtonItem()
            backItem.title = ""
        backItem.tintColor = UIColor.white
        navigationItem.backBarButtonItem = backItem
        
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isOwner ? ProfileRows.ownerProfileRows.count : ProfileRows.userProfileRows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let dashboardCell = tableView.dequeueReusableCell(withIdentifier: "DashboardTableViewCell") as? DashboardTableViewCell else {
            fatalError()
        }
        isOwner ? dashboardCell.updateRows(with: ProfileRows.ownerProfileRows[indexPath.row]) : dashboardCell.updateRows(with: ProfileRows.userProfileRows[indexPath.row])
        return dashboardCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(90)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            print("")                                          //incorporate favorites page soon
            let vc = isOwner ? RestaurantDetailViewController(withRestaurantData: restaurant) : ProfileViewController()
            //let vc = RestaurantDetailViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            print("")
                                  //messages needs to be fixed  //this goes to profile for Customer
            let vc = isOwner ? MessageViewController(withRestaurantData: restaurant) : ProfileViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            //let vc = isOwner ? RestaurantDetailViewController() : ProfileViewController()
            let vc = ProfileViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("")
        }
       
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func sendEmail(_ sender: UIButton) {
        // Modify following variables with your text / recipient
        let recipientEmail = "support@yummr.io"
        let subject = "Customer Support"
        let body = "Hello Team Yummr, "
        
        // Show default mail composer
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([recipientEmail])
            mail.setSubject(subject)
            mail.setMessageBody(body, isHTML: false)
            
            present(mail, animated: true)
        
        // Show third party email composer if default Mail app is not present
        } else if let emailUrl = createEmailUrl(to: recipientEmail, subject: subject, body: body) {
            UIApplication.shared.open(emailUrl)
        }
    }
    
    private func createEmailUrl(to: String, subject: String, body: String) -> URL? {
        let subjectEncoded = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let bodyEncoded = body.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        let gmailUrl = URL(string: "googlegmail://co?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let outlookUrl = URL(string: "ms-outlook://compose?to=\(to)&subject=\(subjectEncoded)")
        let yahooMail = URL(string: "ymail://mail/compose?to=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let sparkUrl = URL(string: "readdle-spark://compose?recipient=\(to)&subject=\(subjectEncoded)&body=\(bodyEncoded)")
        let defaultUrl = URL(string: "mailto:\(to)?subject=\(subjectEncoded)&body=\(bodyEncoded)")
        
        if let gmailUrl = gmailUrl, UIApplication.shared.canOpenURL(gmailUrl) {
            return gmailUrl
        } else if let outlookUrl = outlookUrl, UIApplication.shared.canOpenURL(outlookUrl) {
            return outlookUrl
        } else if let yahooMail = yahooMail, UIApplication.shared.canOpenURL(yahooMail) {
            return yahooMail
        } else if let sparkUrl = sparkUrl, UIApplication.shared.canOpenURL(sparkUrl) {
            return sparkUrl
        }
        
        return defaultUrl
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
