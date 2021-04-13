import UIKit

class PhotoController: UICollectionViewController {
    
    private var idFriend: Int = 0
    var namePhotos = [String]()
    
    var photoUser = PhotoUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        namePhotos.append("\(idFriend as Int)")
        var i = 0
        var namePhoto: String = ""
        while true {
            namePhoto = "\(idFriend as Int)-\(i)"
            if UIImage(named: namePhoto) != nil {
                namePhotos.append(namePhoto)
                print(namePhoto)
                i += 1
            }
            else {
                break
            }
    }
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
        return namePhotos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Photo", for: indexPath) as! PhotoCell
        
        if !namePhotos[indexPath.row].contains("-") {
            cell.contentView.backgroundColor = UIColor.yellow
        }
        cell.photo.image = UIImage(named: namePhotos[indexPath.row])
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
        photoUser.presentValueId  = indexPath.row
        photoUser.arrayValue = namePhotos
        let onePhotoController = self.storyboard?.instantiateViewController(withIdentifier: "OnePhotoController") as! OnePhotoController
        onePhotoController.photoUser = photoUser
        navigationController?.pushViewController(onePhotoController, animated: true)
        //show(onePhotoController, sender: self)
        //segueOnePhoto.photoUser = photoUser
        //print("рисуем нажали")
    }

    

}
