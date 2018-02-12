
import UIKit

class TransactionDetail: UIViewController,UITableViewDataSource,UITableViewDelegate {
    @IBOutlet weak var _daaruImage: UIImageView!
    @IBOutlet weak var _daaruPrice: UILabel!
    @IBOutlet weak var _stausLabel: UILabel!
    @IBOutlet weak var _daaruPurchaseDate: UILabel!
    @IBOutlet weak var _transactionId: UILabel!
    
    @IBOutlet weak var myTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        myTableView.separatorInset = UIEdgeInsets.zero
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transcell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}
