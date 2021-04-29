import UIKit
import RealmSwift
import Kingfisher

class NewsController: UITableViewController {
    
    private var networkManager = NetworkManager(token: Session.inctance.token)
    private var realm: Realm = RealmBase.inctance.getRealm()!
    private lazy var newsResult: Results<News>? = realm.objects(News.self).sorted(byKeyPath: "date").filter("photoURLString != ''")
    private lazy var groupsResult: Results<Group>? = realm.objects(Group.self).sorted(byKeyPath: "name")
    private var notificationToken: NotificationToken?
    private var notificationTokenGroups: NotificationToken?
    private let cellID = String(describing: NewsCell.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if groupsResult?.count == 0 {
            networkManager.loadGroups {}
        }
            
        networkManager.loadNews() {[weak self] in
            self?.notificationToken = self?.newsResult!.observe { [weak self] (changes: RealmCollectionChange) in
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
        
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsResult!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewsCell
        if let new = newsResult?[indexPath.row] {
            
            if let group = groupsResult?.filter("id = \(new.sourceId < 0 ? new.sourceId*(-1): new.sourceId)") {
                cell.faceImage.setImage(url: URL(string: group.first!.photo100)!)
                
                cell.nameUser.text = group.first?.name
                cell.textNew.text = new.text
                print(new.photoURLString)
                cell.photoNew.kf.setImage(with: URL(string: new.photoURLString.isEmpty ? "https://vk.com/images/m_noalbum.png" : new.photoURLString)!)
            }
        }
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
