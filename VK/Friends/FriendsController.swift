import UIKit
import RealmSwift

class FriendsController: UITableViewController, UISearchBarDelegate {
    
    @IBOutlet var tableFriends: UITableView!
    @IBOutlet weak var searchFriend: UISearchBar!
    
    @IBAction func LogOut(_ sender: UIBarButtonItem) {
    }
    private var networkManager = NetworkManager(token: Session.inctance.token)
    private var realm: Realm = RealmBase.inctance.getRealm()!
    private var symbolControl: SymbolControl!
    private lazy var friendsResult: Results<User>? = realm.objects(User.self).sorted(byKeyPath: "lastName")
    private var notificationToken: NotificationToken?
    private var searchNotificationToken: NotificationToken?
    private var searchText: String = ""
    private var idFriend: Int!
    private let headerID = String(describing: HeaderSection.self)
    private var calculatorSymbolSearch = 0
    private lazy var symbolGroup: [String] = Array(Set(Array(friendsResult!).map({$0.lastName.first!.uppercased()}))).sorted()
    
    override func viewDidLoad() {
        tableFriends.dataSource = self
        searchFriend.delegate = self
        
        let userAuth = Session.inctance
        userAuth.getData()
        
        networkManager.loadFriends { [weak self] in
            self?.notificationToken = self?.friendsResult!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self!.tableFriends else {return}
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(let results, let deletions, let insertions, let modifications):
                    tableView.apply(results: Array(results), sections: self!.symbolGroup, delitions: deletions, insertions: insertions, modifications: modifications)
                case .error(let error):
                    print(error)
                }
            }
        }
        
        tableView.register(UINib(nibName: headerID, bundle: nil), forHeaderFooterViewReuseIdentifier: headerID)
        symbolControl = SymbolControl.init(frame: CGRect(x: view.frame.maxX - 20, y: 0, width: 20, height: view.frame.height),groupSymbol: symbolGroup)
        symbolControl.viewController = self
        symbolControl.isUserInteractionEnabled = true
    }
    
    func message(name: String) {
        let alert = UIAlertController(title: "Вход", message: "Поздравляем \(name)! Вы вошли в свой аккаунт! ", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        view.addSubview(symbolControl)
        clearFormatSelectedCell(row: 0, section: symbolControl.selectedSymbolId)
        symbolControl.isSelectedButton(selectedSymbolId: symbolControl.selectedSymbolId, isSelected: false)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let requestFriends = searchBySymbol(indexSymbol: section - calculatorSymbolSearch)
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! HeaderSection
        if requestFriends.count != 0 {
            header.setBackgroundColor(color: view.backgroundColor!, alpha: 0.5)
            header.textHeader.text = symbolGroup[section - calculatorSymbolSearch]
            return header
        }
        else {
            calculatorSymbolSearch = calculatorSymbolSearch + 1
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let hideSection = searchBySymbol(indexSymbol: section - calculatorSymbolSearch)
        if hideSection.count == 0 {
            return 0.0
        }
        return 30
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        symbolControl.frame = CGRect.init(x: symbolControl.frame.origin.x, y: scrollView.contentOffset.y + 130, width: symbolControl.frame.width, height: symbolControl.frame.height)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idFriend = searchBySymbol(indexSymbol: indexPath.section)[indexPath.row].id
        clearFormatSelectedCell(row: 0, section: symbolControl.selectedSymbolId)
        symbolControl.isSelectedButton(selectedSymbolId: symbolControl.selectedSymbolId, isSelected: false)
        let photoController = self.storyboard?.instantiateViewController(withIdentifier: "Photo") as! PhotoController
        photoController.setIdFriend(idFriend: idFriend)
        navigationController?.pushViewController(photoController, animated: true)
    }
    
    func searchBySymbol(indexSymbol: Int) -> [User] {
        return Array(friendsResult!.filter("lastName LIKE '\(symbolGroup[indexSymbol])*'"))
    }
    
    func clearFormatSelectedCell(row: Int?, section: Int?) {
        if row != nil,  section != nil {
            tableView.cellForRow(at: IndexPath(row: row!, section: section!))?.backgroundColor = UIColor.white
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchBySymbol(indexSymbol: section).count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as! FriendsCell
        let friend = searchBySymbol(indexSymbol: indexPath.section)[indexPath.row]
        cell.nameFriend.text = "\(friend.lastName) \(friend.firstName)"
        cell.faceImage.setImage(url: URL(string: friend.photo100)!)
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return symbolGroup.count
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchFriendsResult = realm.objects(User.self).sorted(byKeyPath: "lastName")
        if searchText != "" && !searchText.elementsEqual(self.searchText) {
            self.searchText = searchText
            searchFriendsResult = realm.objects(User.self).filter("lastName CONTAINS '\(searchText)' OR firstName CONTAINS '\(searchText)'").sorted(byKeyPath: "lastName")
        }
        
        friendsResult = searchFriendsResult
        
        searchNotificationToken = searchFriendsResult.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableFriends else {return}
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                tableView.apply(results: Array(results), sections: self!.symbolGroup, delitions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                print(error)
            }
        }
        calculatorSymbolSearch = 0
    }
}
