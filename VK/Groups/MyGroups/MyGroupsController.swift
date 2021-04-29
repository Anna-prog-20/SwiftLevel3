import UIKit
import Kingfisher
import RealmSwift

class MyGroupsController: UITableViewController, DelegateGroup {
    
    private var networkManager = NetworkManager(token: Session.inctance.token)
    private var realm: Realm = RealmBase.inctance.getRealm()!
    private lazy var groupsResult: Results<Group>? = realm.objects(Group.self).sorted(byKeyPath: "name")
    private var notificationToken: NotificationToken?
    
    @IBAction func addGroup(_ sender: Any) {
        let groupsController = self.storyboard?.instantiateViewController(withIdentifier: "GroupsController") as! GroupsController
        navigationController?.pushViewController(groupsController, animated:true)
    }
    
    func update(group: Group) {
        do {
            try realm.write {
                realm.add(group, update: .modified)
            }
        } catch  {
            print(error)
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Group", for: indexPath) as! MyGroupsCell
        
        if let group = groupsResult?[indexPath.row] {
            cell.nameGroup.text = group.name
            cell.faceImage.setImage(url: URL(string: group.photo50)!)
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.loadGroups {}
        notificationToken = groupsResult!.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {return}
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update( _, let deletions, let insertions, let modifications):
                tableView.apply(delitions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        notificationToken = groupsResult!.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else {return}
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update( _, let deletions, let insertions, let modifications):
                tableView.apply(delitions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                print(error)
            }
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsResult!.count
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    //    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        // Return false if you do not want the specified item to be editable.
    //        return true
    //    }
    //
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do {
                try realm.write {
                    realm.delete(Array(groupsResult!)[indexPath.row])
                }
            } catch  {
                print(error)
            }
        }
    }
    
    //    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
    //
    //    }
    
    
    //    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    //        // Return false if you do not want the item to be re-orderable.
    //        return true
    //    }
    
    
}
