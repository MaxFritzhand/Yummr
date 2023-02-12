import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class RestaurantDetailViewController: PIViewController {
    @IBOutlet weak var detailTableView: UITableView!

    private var restaurant: Restaurant
    
    init(withRestaurantData restaurantData:  Restaurant) {
        self.restaurant = restaurantData
        //self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBarFunction()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    @objc func didTapCellButton(_ sender: UIButton) {
        print("Button Got tapped")
        let vc = SignUpInformationRestaurantViewController(fullName: "", email: "", password: "", confirmPassword: "", restaurantState: .edit, withRestaurantData: self.restaurant)
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupTableView() {
        detailTableView.registerNibArray(withNames: ["HeaderImageTableViewCell", "DetailTableViewCell"])
        detailTableView.isScrollEnabled = true;
    }
    
    func setupNavBarFunction() {
        self.title = restaurant.restaurantName!
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
}
    
extension RestaurantDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row != 0 {
            return 60
        }
        return 300
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.row {
        case 0:
            print("Me")
            //Upload new photo
        default:
            let vc = RestaurantDetailEdit()
            vc.update(data: RestaurantDetailRows.restaurantDetailRows[indexPath.row - 1], restaurantID: restaurant.restaurantID!)
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension RestaurantDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //1 more for the restaurant image
        return RestaurantDetailRows.restaurantDetailRows.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderImageTableViewCell", for: indexPath) as! HeaderImageTableViewCell
            cell.update(withRestaurantData: restaurant, title: "Cover Image")
            cell.editButton.addTarget(self, action:  #selector(RestaurantDetailViewController.didTapCellButton(_:)), for: .touchUpInside)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
            cell.update(data: RestaurantDetailRows.restaurantDetailRows[indexPath.row - 1])
            return cell
        }
        return UITableViewCell()
    }
}

