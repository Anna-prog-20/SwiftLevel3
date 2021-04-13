import UIKit

class PhotoController: UICollectionViewController {
    
    private var idFriend: Int = 0
    private var networkManager = NetworkManager(token: Session.inctance.token)
    var photos: [Photo]?
    var photosUrl: [String] = []
    
    var albums: [Album]?
    
    func fillData() {
        networkManager.loadAlbums(idFriend: idFriend, completion: {
            [weak self] result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(albums1):
                if ((self!.albums?.elementsEqual(albums1, by: {$0.id == $1.id})) == nil) {
                    self!.albums = albums1
                    self!.albums?.forEach({self!.photosUrl.append($0.thumbSrc)})
                    self!.collectionView.reloadData()
                }
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillData()
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
        
        networkManager.loadPhotosByAlbum(idFriend: idFriend, idAlbum: albums![indexPath.row].id, completion: {
            [weak self] result in
            switch result {
            case let .failure(error):
                print(error)
            case let .success(photos1):
                //let photos1 = photos1
                var photoUser = PhotoUser()
                photoUser.presentValueId  = 0
                if (photos1.count > 0) {
                    photos1.forEach({photoUser.arrayValue.append($0.sizes[2].url)})
                    
                    let onePhotoController = self!.storyboard?.instantiateViewController(withIdentifier: "OnePhotoController") as! OnePhotoController
                    onePhotoController.photoUser = photoUser
                    
                    self!.navigationController?.pushViewController(onePhotoController, animated: true)
                }
            }
        })
    }
}
