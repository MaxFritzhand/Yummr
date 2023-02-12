//
//  HomeViewController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import CoreLocation

class HomeViewController: PIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var restaurants: [Restaurant] = []
//    var owner: Owner
    
    var locationManager: CLLocationManager?
    
    
//    init(withOwner owner: Owner) {
//        self.owner = owner
//
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    
    
    var user: User? {
        didSet{
            API.shared.bannerManager.showSuccessNotification(withTitle: user!.fullName!, withMessage: user!.email!)
        }
    }
     
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.userManager.addConsumer(consumer: self)
        API.shared.userManager.checkIfUserIsLoggedIn()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
        setupTableView()
        setupView()
        // Do any additional setup after loading the view.
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isTranslucent = false
        
        API.shared.restaurantManager.restaurantService.getApprovedRestaurants { restaurants in
            self.restaurants = restaurants
            self.tableView.reloadData()
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.registerNibArray(withNames: ["RestaurantTableViewCell", "SearchTableViewCell", "FoodFilterTableViewCell"])
    }
    
    func getScreenSize() -> CGFloat {
        if UIScreen.main.nativeBounds.height == 2778 && UIScreen.main.nativeBounds.width == 1284 {
            return 40
        } else {
            return 32
        }
    }
    
    func disableAnimation() {
        self.loadingView.alpha = 0
        self.activityIndicator.stopAnimating()
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RestaurantViewController(withRestaurantData: restaurants[indexPath.row])
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return restaurants.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let searchCell = tableView.dequeueReusableCell(withIdentifier: "SearchTableViewCell") as? SearchTableViewCell else {
                fatalError()
            }
            return searchCell
        } else  {
            guard let restaurantCell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell") as? RestaurantTableViewCell else {
                fatalError()
            }
            restaurantCell.update(withRestaurantData: restaurants[indexPath.row])
            return restaurantCell
        }
    }
}

extension HomeViewController: UserManagerConsumer {
    func userDidSignup() {
        DispatchQueue.main.async {
            self.disableAnimation()
            self.tableView.reloadData()
        }
    }
    
    func userDidLogIn() {
        DispatchQueue.main.async {
            self.disableAnimation()
            self.tableView.reloadData()
        }
    }
    
    func userDidLogOut() {
        let vc = UINavigationController(rootViewController: LoginViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    func didGetCurrentUser() {
        DispatchQueue.main.async {
            self.disableAnimation()
            self.tableView.reloadData()
        }
    }
    
    func userIsLoggedIn() {
        DispatchQueue.main.async {
            self.disableAnimation()
            self.tableView.reloadData()
        }
    }
    
    func userFailedToLogIn(with message: String) {
        let vc = UINavigationController(rootViewController: LoginViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    func noCurrentUser() {
        let vc = UINavigationController(rootViewController: LoginViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
}
