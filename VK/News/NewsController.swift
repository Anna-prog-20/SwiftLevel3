import UIKit

class NewsController: UITableViewController {
    private let cellID = String(describing: NewsCell.self)
    var news: [News] = []
    
    func fillData() {
        for i in 0...2 {
            let user = User.init(id:i, name: "User \(i)", photo: [Photo(id: 0, name: "\(i)", checkFaceImage: false, title: "", date: Date())])
            let new = News(id: i, user: user, title: "Новость дня \(i)", text: "\(user.name) каким-то чудом попал в сегодняшние новости!!!!", photo: [Photo(id: 0, name: "news-\(i)", checkFaceImage: false, title: "", date: Date())])
            news.append(new)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillData()
        tableView.register(UINib(nibName: cellID, bundle: nil), forCellReuseIdentifier: cellID)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return news.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! NewsCell
        let new = news[indexPath.row]
        cell.faceImage.setImage(named: "\(new.user.photo[0].name)")
        cell.nameUser.text = new.user.name
        cell.textNew.text = new.text
        cell.photoNew.image = UIImage(named: new.photo[0].name)
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
