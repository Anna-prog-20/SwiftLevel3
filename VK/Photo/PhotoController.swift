import UIKit
import RealmSwift

class PhotoController: UICollectionViewController {
    
    private var networkManager = NetworkManager(token: Session.inctance.token)
    private var realm: Realm = RealmBase.inctance.getRealm()!
    private var notificationToken: NotificationToken?
    private lazy var albums: Results<Album>?  = realm.objects(Album.self).filter("ownerID = \(idFriend)")
    private var idFriend: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkManager.loadAlbums(idFriend: idFriend) {}
        notificationToken = albums!.observe { [self] (changes: RealmCollectionChange) in
            guard let collectionView = self.collectionView else {return}
            switch changes {
            case .initial:
                print("initial")
                collectionView.reloadData()
            case .update(let results, let deletions, let insertions, let modifications):
                print("update")
                collectionView.apply(delitions: deletions, insertions: insertions, modifications: modifications)
            case .error(let error):
                print(error)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func setIdFriend(idFriend: Int) {
        self.idFriend = idFriend
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return albums!.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCell
        if albums != nil {
            let album = Array(albums!)
            let currentAlbum = album[indexPath.row]
            let requestCountPhotos = realm.objects(Photo.self).filter("albumID = \(currentAlbum.id) AND ownerID = \(idFriend)")
            let countPhotos = Array(requestCountPhotos).count
            
            cell.nameAlbum.text = currentAlbum.title ?? "Без названия"
            cell.countPhotos.text = (countPhotos != 0) ? String(countPhotos): ""
            let urlAlbum = URL(string: currentAlbum.thumbSrc)
            cell.photo.kf.setImage(with: urlAlbum)
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     */
    //    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAtindexPath: IndexPath, withSender sender: Any?) {
    //    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        var photoUser = PhotoUser()
        photoUser.presentValueId  = 0
        networkManager.loadPhotosByAlbum(idFriend: idFriend, idAlbum: albums![indexPath.row].id, completion: {
            let request = self.realm.objects(Photo.self).filter("albumID = \(Array(self.albums!)[indexPath.row].id) AND ownerID = \(self.idFriend)")
            let photos = Array(request)
            if (photos.count > 0) {
                photos.forEach({ photoUser.arrayValue.append($0.sizesList[2].url)})
                let onePhotoController = self.storyboard?.instantiateViewController(withIdentifier: "OnePhotoController") as! OnePhotoController
                onePhotoController.photoUser = photoUser
                self.navigationController?.pushViewController(onePhotoController, animated: true)
            }
        })
    }
}
