import UIKit
import RealmSwift

class PhotoController: UICollectionViewController {
    
    private var networkManager = NetworkManager(token: Session.inctance.token)
    private var realm: Realm = RealmBase.inctance.getRealm()!
    private var idFriend: Int = 0
    var photos: [Photo] = []
    var photosUrl: [String] = []
    
    var albums: [Album]?
    
    func fillData() {
        albums = []
        photosUrl = []
        networkManager.loadAlbums(idFriend: idFriend, completion: {
            [weak self] in
            do {
                let albums = self!.realm.objects(Album.self).filter("ownerID = \(self!.idFriend)").sorted(byKeyPath: "ownerID")
                self?.albums = Array(albums)
                self!.albums?.forEach({ self!.photosUrl.append($0.thumbSrc)})
                self!.collectionView.reloadData()
            } catch {
                print(error)
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillData()
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
        return photosUrl.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCell
        let requestAlbums = realm.objects(Album.self).filter("thumbSrc = '\(photosUrl[indexPath.row])'")
        let album = Array(requestAlbums)
        let requestCountPhotos = realm.objects(Photo.self).filter("albumID = \(album.first!.id) AND ownerID = \(idFriend)")
        let countPhotos = Array(requestCountPhotos).count
        cell.nameAlbum.text = album.first?.title ?? "Без названия"
        cell.countPhotos.text = "\(countPhotos)"
        cell.photo.kf.setImage(with: URL(string: photosUrl[indexPath.row])!)
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
            let request = self.realm.objects(Photo.self).filter("albumID = \(self.albums![indexPath.row].id) AND ownerID = \(self.idFriend)")
            self.photos = Array(request)
            if (self.photos.count > 0) {
                self.photos.forEach({ photoUser.arrayValue.append($0.sizesList[2].url)})
                let onePhotoController = self.storyboard?.instantiateViewController(withIdentifier: "OnePhotoController") as! OnePhotoController
                onePhotoController.photoUser = photoUser
                self.navigationController?.pushViewController(onePhotoController, animated: true)
            }
        })
    }
}
