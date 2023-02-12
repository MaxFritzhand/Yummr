import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class RestaurantDetailViewController: PIViewController {
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backView: UIView!
    private var restaurants: [Restaurant] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailTableView.delegate = self
        detailTableView.dataSource = self
        setupTableView()
        setupUIElements()
    }
    
    @objc func didTapCellButton(_ sender: UIButton) {
        print("Button Got tapped")
    }
    
    func setupTableView() {
   
        detailTableView.registerNibArray(withNames: ["HeaderImageTableViewCell", "DetailTableViewCell"])
        detailTableView.isScrollEnabled = true;
        let service = RestaurantService()
        let email = Auth.auth().currentUser!.email!
        service.getOwnerRestaurants(withEmail: email) { restaurant in
            self.restaurants.append(restaurant)
            self.restaurantName.text = restaurant.restaurantName
            RestaurantDetailRows.updateInfo(restaurant)
            self.detailTableView.reloadData()
        }
    }
    
    func setupUIElements() {
        backView.addCornerRadius(value: backView.frame.width/2)
        headerView.layer.cornerRadius = 25
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
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
            vc.update(data: RestaurantDetailRows.restaurantDetailRows[indexPath.row - 1], restaurantID: restaurants[0].restaurantID!)
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
        if indexPath.row != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DetailTableViewCell", for: indexPath) as! DetailTableViewCell
            cell.update(data: RestaurantDetailRows.restaurantDetailRows[indexPath.row - 1])
            return cell
        }
        if restaurants.count != 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderImageTableViewCell", for: indexPath) as! HeaderImageTableViewCell
            cell.update(withRestaurantData: restaurants[0], title: "Cover Image")
            cell.editButton.addTarget(self, action:  #selector(RestaurantDetailViewController.didTapCellButton(_:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
}

