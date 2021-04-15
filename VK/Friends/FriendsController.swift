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
    private var friends: [User] = []
    private var groupSymbol: [GroupSymbol] = []
    private var searchText: String = ""
    private var idFriend: Int!
    private let headerID = String(describing: HeaderSection.self)
    
    func fillData() {
       networkManager.loadFriends(completion: {
        [weak self] in
                do {
                    let realm = try Realm()
                    let friends = realm.objects(User.self).sorted(byKeyPath: "lastName")
                    self!.friends = Array(friends)
                    self!.writeGroupFriend()
                    self!.tableFriends.reloadData()
                } catch {
                    print(error)
                }
        })
    }
    
    override func viewDidLoad() {
        tableFriends.dataSource = self
        searchFriend.delegate = self
        
        let userAuth = Session.inctance
        userAuth.getData()
        
        fillData()
        tableView.register(UINib(nibName: headerID, bundle: nil), forHeaderFooterViewReuseIdentifier: headerID)
        symbolControl = SymbolControl.init(frame: CGRect(x: view.frame.maxX - 20, y: 0, width: 20, height: view.frame.height),groupSymbol: groupSymbol)
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
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerID) as! HeaderSection
        header.setBackgroundColor(color: view.backgroundColor!, alpha: 0.5)
        header.textHeader.text = groupSymbol[section].name
        return header
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        symbolControl.frame = CGRect.init(x: symbolControl.frame.origin.x, y: scrollView.contentOffset.y + 130, width: symbolControl.frame.width, height: symbolControl.frame.height)
    }
    
    func writeGroupFriend() {
        var i = 0
        var k = 0
        var firstSymbol = ""
        groupSymbol = []
        
        for friend in friends {
            let nameFriend = "\(friend.lastName) \(friend.firstName)"
            let friendSymbol = String(nameFriend[nameFriend.startIndex])
            if firstSymbol != friendSymbol {
                k = i
                groupSymbol.append(GroupSymbol(id: i, name: friendSymbol))
                groupSymbol[i].users.append(friend)
                i = i + 1
            }
            else {
                groupSymbol[k].users.append(friend)
            }
            firstSymbol = friendSymbol
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        idFriend = groupSymbol[indexPath.section].users[indexPath.row].id
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
        return groupSymbol[section].users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Friend", for: indexPath) as! FriendsCell
        let friend = groupSymbol[indexPath.section].users[indexPath.row]
        cell.nameFriend.text = "\(friend.lastName) \(friend.firstName)"
        cell.faceImage.setImage(url: URL(string: friend.photo100)!)
        cell.backgroundColor = UIColor.white
        return cell
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupSymbol.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 30
        }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var request = realm.objects(User.self).sorted(byKeyPath: "lastName")
        if searchText != "" && !searchText.elementsEqual(self.searchText) {
            self.searchText = searchText
            request = realm.objects(User.self).filter("lastName CONTAINS '\(searchText)' OR firstName CONTAINS '\(searchText)'").sorted(byKeyPath: "lastName")
        }
        friends = Array(request)
        writeGroupFriend()
        tableFriends.reloadData()
    }
}
