import UIKit
import Kingfisher
import RealmSwift

class GroupsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var tableGroups: UITableView!
    @IBOutlet weak var searchGroup: UISearchBar!
    
    private var networkManager = NetworkManager(token: Session.inctance.token)
    weak var delegate: DelegateGroup?
    var groups = [Group]()
    
    override init(style: UITableView.Style) {
        super.init(style: style)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableGroups.dataSource = self
        searchGroup.delegate = self
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return groups.count
        }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchGroup", for: indexPath) as! GroupsCell

        let group = groups[indexPath.row]
        cell.nameGroupGlobal.text = group.name
        cell.faceImage.setImage(url: URL(string: group.photo50)!)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            networkManager.loadGroupsByName(searchName: searchText, completion: {
                [weak self] result in
                switch result {
                case let .failure(error):
                    print(error)
                case let .success(groups):
                    self!.groups = groups
                    self!.tableGroups.reloadData()
                }
            })
        } else {
            groups = []
            tableGroups.reloadData()
        }
    }
   
}

