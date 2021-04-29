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
    private lazy var symbolResult: Results<SymbolGroup>? = realm.objects(SymbolGroup.self).sorted(byKeyPath: "symbol")
    private var notificationToken: NotificationToken?
    private var searchNotificationToken: NotificationToken?
    private var symbolNotificationToken: NotificationToken?
    private var searchText: String = ""
    private var idFriend: Int!
    private let headerID = String(describing: HeaderSection.self)
    private var calculatorSymbolSearch = 0
    
    override func viewDidLoad() {
        tableFriends.dataSource = self
        searchFriend.delegate = self
        
        let userAuth = Session.inctance
        userAuth.getData()
        
        networkManager.loadFriends { [self] in
            notificationToken = friendsResult!.observe { [weak self] (changes: RealmCollectionChange) in
                guard let tableView = self?.tableFriends else {return}
                switch changes {
                case .initial:
                    tableView.reloadData()
                case .update(let results, let deletions, let insertions, let modifications):
                    tableView.apply(results: Array(results), sections: self?.symbolResult, delitions: deletions, insertions: insertions, modifications: modifications)
                case .error(let error):
                    print(error)
                }
            }
        }
        
        tableView.register(UINib(nibName: headerID, bundle: nil), forHeaderFooterViewReuseIdentifier: headerID)
        symbolControl = SymbolControl.init(frame: CGRect(x: view.frame.maxX - 20, y: 0, width: 20, height: view.frame.height),groupSymbol: Array(symbolResult!))
        symbolControl.viewController = self
        symbolControl.isUserInteractionEnabled = true
    }
    
    func message(name: String) {
        let alert = UIAlertController(title: "Вход", message: "Поздравляем \(name)! Вы вошли в свой аккаунт! ", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        view.addSubview(symbolControl)
        clearFormatSelectedCell(row: 0, section: symbolControl.selectedSymbolId)
        symbolControl.isSelectedButton(selectedSymbolId: symbolControl.selectedSymbolId, isSelected: false)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section <= tableView.numberOfSections else {return nil}
        let requestFriends = friendsResult!.filter("lastName LIKE '\((Array(arrayLiteral: symbolResult!).first![section - calculatorSymbolSearch].symbol))*'")
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! HeaderSection
        if requestFriends.count != 0 {
            header.setBackgroundColor(color: view.backgroundColor!, alpha: 0.5)
            header.textHeader.text = symbolResult![section - calculatorSymbolSearch].symbol
            return header
        }
        else {
            symbolResult = symbolResult!.filter("symbol != '\(symbolResult![section - calculatorSymbolSearch].symbol)'")
            calculatorSymbolSearch = calculatorSymbolSearch + 1
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if friendsResult!.filter("lastName LIKE '\((Array(arrayLiteral: symbolResult!).first![section - calculatorSymbolSearch].symbol))*'").count == 0 {
            return 0.0
        }
        return 30
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        symbolControl.frame = CGRect.init(x: symbolControl.frame.origin.x, y: scrollView.contentOffset.y + 130, width: symbolControl.frame.width, height: symbolControl.frame.height)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idFriend = friendsResult!.filter("lastName LIKE '\((Array(arrayLiteral: symbolResult!).first![indexPath.section].symbol))*'")[indexPath.row].id
        clearFormatSelectedCell(row: 0, section: symbolControl.selectedSymbolId)
        symbolControl.isSelectedButton(selectedSymbolId: symbolControl.selectedSymbolId, isSelected: false)
        let photoController = self.storyboard?.instantiateViewController(withIdentifier: "Photo") as! PhotoController
        photoController.setIdFriend(idFriend: idFriend)
        navigationController?.pushViewController(photoController, animated: true)
    }
    
    func clearFormatSelectedCell(row: Int?, section: Int?) {
        if row != nil,  section != nil {
            tableView.cellForRow(at: IndexPath(row: row!, section: section!))?.backgroundColor = UIColor.white
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendsResult?.filter("lastName LIKE '\((Array(arrayLiteral: symbolResult!).first![section].symbol))*'").count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as! FriendsCell
        let friend = friendsResult!.filter("lastName LIKE '\((Array(arrayLiteral: symbolResult!).first![indexPath.section].symbol))*'")[indexPath.row]
        cell.nameFriend.text = "\(friend.lastName) \(friend.firstName)"
        cell.faceImage.setImage(url: URL(string: friend.photo100)!)
        cell.backgroundColor = UIColor.white
        return cell
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return symbolResult!.count
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
                tableView.apply(results: Array(results), sections: self?.symbolResult, delitions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                print(error)
            }
        }
        
        symbolResult = realm.objects(SymbolGroup.self).sorted(byKeyPath: "symbol")
        calculatorSymbolSearch = 0
    }
}
