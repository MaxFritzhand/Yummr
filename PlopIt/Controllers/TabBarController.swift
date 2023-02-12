//
//  TabBarController.swift
//  PlopIt
//
//  Created by Raivis Olehno on 08/01/2022.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate {
    var currentVC: UIViewController?
    let higherTabBarInset: CGFloat = 24
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.shared.userManager.addConsumer(consumer: self)
        currentVC = HomeViewController()
        delegate = self
        checkIfItsLaunched()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBar.tintColor = Colours.buttonActive
        self.tabBar.barTintColor = Colours.white
        self.tabBar.unselectedItemTintColor = Colours.darkGrey
        self.tabBar.isTranslucent = false
        self.tabBar.backgroundColor = Colours.white
        goToHome()
    }
    
    
    func checkIfItsLaunched() {
        let hasAlreadyLaunched = UserDefaults.standard.bool(forKey: "hasAlreadyLaunched")
        if !hasAlreadyLaunched {
            UserDefaults.standard.set(true, forKey: "hasAlreadyLaunched")
            UserDefaults.standard.set(true, forKey: "firstTimeLaunched")
            UserDefaults.standard.synchronize()
            DispatchQueue.main.async {
                let loginVC = UINavigationController(rootViewController: LoginViewController())
                loginVC.modalPresentationStyle = .fullScreen
                self.present(loginVC, animated: false, completion: nil)
            }
        }
        else {
            createTabBarItems()
        }
    }
    
    
    func createTabBarItems() {
        
        let firstTimeLaunched = UserDefaults.standard.bool(forKey: "firstTimeLaunched")
        if firstTimeLaunched {
            view.showLoader(.white)
            API.shared.userManager.userService.getOwnerStatus { isOwner in
                guard let isOwner = isOwner else {
                    self.addTabs(isOwner: false)
                    return
                }
                self.addTabs(isOwner: isOwner)
                self.view.dismissLoader()
                UserDefaults.standard.set(false, forKey: "firstTimeLaunched")
                
                
            }
        } else {
            let isOwner = UserDefaults.standard.bool(forKey: "isOwner")
            addTabs(isOwner: isOwner)
        }
    }
    
    private func addTabs(isOwner: Bool) {
        let home = HomeViewController()
        let navHome = UINavigationController(rootViewController:home)
        let homeItem = self.addTabItem(forViewController:navHome, imageName: "homeTab", selectedImageName: "homeTab", forTitle: "Home")
        
        if isOwner {
            API.shared.userManager.userService.getOwner { Owner in
                let owner = Owner
                API.shared.restaurantManager.restaurantService.getRestaurantByID(restaurantID: owner.restaurantID) { restaurant in

            let menu = UINavigationController(rootViewController: MenuViewController(withRestaurantData: restaurant))
            
            let menuItem = self.addTabItem(forViewController: menu, imageName: "menuTab", selectedImageName: "menuTab", forTitle: "Menu")
            let dashboard = UINavigationController(rootViewController: DashboardViewController(withRestaurantData: restaurant))
            let dashboardItem = self.addTabItem(forViewController: dashboard, imageName: "dashboardTab", selectedImageName: "dashboardTab", forTitle: "Dashboard")
                    
            let ownerController = [homeItem, menuItem, dashboardItem]
            self.viewControllers = ownerController
                }
            }
        } else {
            let dashboard = UINavigationController(rootViewController: DashboardViewController(withRestaurantData: Restaurant()))
            let dashboardItem = self.addTabItem(forViewController: dashboard, imageName: "dashboardTab", selectedImageName: "dashboardTab", forTitle: "Dashboard")
            let customerController = [homeItem, dashboardItem]
            self.viewControllers = customerController
        }
    }
    
    private func addTabItem(forViewController vc: UIViewController, imageName: String, selectedImageName: String, forTitle title: String) -> UIViewController {
        let item = vc
        let icon = UITabBarItem(title: title, image: UIImage(named: imageName), selectedImage: UIImage(named: selectedImageName))
        item.tabBarItem = icon
        return item
    }
    private func addTabItemSFSymbols(forViewController vc: UIViewController, imageName: String, selectedImageName: String, forTitle title: String) -> UIViewController {
        let item = vc
        let icon = UITabBarItem(title: title, image: UIImage(systemName: imageName), selectedImage: UIImage(named: selectedImageName))
        item.tabBarItem = icon
        return item
    }
    
    
    func goToHome() {
        self.selectedIndex = 0
    }
    
    func goToMenu() {
        self.selectedIndex = 1
    }
    
    func goToFeedback() {
        self.selectedIndex = 2
    }
    
    func goToOwner() {
        self.selectedIndex = 3
    }
    
    public func show(_ vc: UIViewController, animated: Bool = false) {
        self.present(vc, animated: animated, completion: nil)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        currentVC = viewController
        return true
    }
    
    func showItems() {
        for subview in self.tabBar.subviews {
            subview.alpha = 1
        }
    }
    
    func hideItems() {
        for subview in self.tabBar.subviews {
            subview.alpha = 0
        }
    }
    
}

extension TabBarController: UserManagerConsumer {
    
    func userDidLogIn() {
        DispatchQueue.main.async {
            self.createTabBarItems()
            self.showItems()
        }
    }
    
    func didGetCurrentUser() {
        DispatchQueue.main.async {
            self.showItems()
        }
    }
    
    func userDidSignup() {
        DispatchQueue.main.async {
            self.showItems()
        }
    }
    
    func userDidLogOut() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true) {
                self.hideItems()
            }
        }
    }
    
    func noCurrentUser() {
        DispatchQueue.main.async {
            let loginVC = LoginViewController()
            loginVC.modalPresentationStyle = .fullScreen
            self.present(loginVC, animated: true) {
                self.hideItems()
            }
        }
    }
}
