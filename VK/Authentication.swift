import UIKit

class Authentication: UIViewController {

    var friendsName = [
            "Bob",
            "Sara",
            "Koly",
            "Bill",
            "Any",
            "Alex",
            "Petya",
            "Bib"
        ]
    var friends: [User] = []
    
    @IBOutlet weak var login: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBAction func comeIn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "home")
        if authentication(login: login.text, password: password.text) {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        else {
            messageError()
        }
    }
    
    func fillData() {
        friendsName.sort()
        for i in 0...friendsName.count - 1 {
            let user = User(id: i, name: friendsName[i],login: "\(friendsName[i])@mail.ru", password: "\(friendsName[i])")
            friends.append(user)
        }
    }
    
    func messageError() {
        let alert = UIAlertController(title: "Ошибка", message: "Введены неверные данные!!!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func authentication(login: String?, password: String?) -> Bool {
        if login != nil && password != nil {
            if !login!.isEmpty || !password!.isEmpty {
                let searchUser = friends.filter{
                    $0.login == login! &&
                    $0.password == password!
                }
                if searchUser.count == 1 {
                    let session = Session.inctance
                    session.loginWithServer(token: "token", userId: searchUser[0].id)
                    return true
                }
            }
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillData()
        // Жест нажатия
        let hideKeyboardGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        // Присваиваем его UIScrollVIew
        scrollView?.addGestureRecognizer(hideKeyboardGesture)
    }

    // Когда клавиатура появляется
    @objc func keyboardWasShown(notification: Notification) {
            
        // Получаем размер клавиатуры
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
            
        // Добавляем отступ внизу UIScrollView, равный размеру клавиатуры
        self.scrollView?.contentInset = contentInsets
            scrollView?.scrollIndicatorInsets = contentInsets
    }
        
    //Когда клавиатура исчезает
    @objc func keyboardWillBeHidden(notification: Notification) {
        // Устанавливаем отступ внизу UIScrollView, равный 0
        let contentInsets = UIEdgeInsets.zero
        scrollView?.contentInset = contentInsets
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        // Подписываемся на два уведомления: одно приходит при появлении клавиатуры
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown), name: UIResponder.keyboardWillShowNotification, object: nil)
        // Второе — когда она пропадает
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func hideKeyboard() {
        self.scrollView?.endEditing(true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

