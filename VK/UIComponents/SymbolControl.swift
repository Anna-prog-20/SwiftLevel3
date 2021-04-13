import UIKit

class SymbolControl: UIControl {
    
    var viewController = UIViewController()
    
    var groupSymbol: [GroupSymbol] = []
    var selectedSymbol: String? {
        didSet {
            updateSelectedSymbol()
            sendActions(for: .valueChanged)
        }
    }
    
    var selectedSymbolId: Int?
    
    private var buttons: [UIButton] = []
    private var stackView: UIStackView!
    
    init(frame: CGRect, groupSymbol: [GroupSymbol]) {
        super.init(frame: frame)
        self.groupSymbol = groupSymbol
        setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    @objc private func selectSymbol(_ sender: UIButton) {
        if let myViewController = (viewController as? FriendsController), selectedSymbolId != nil {
            myViewController.tableView.cellForRow(at: IndexPath(row: 0, section: selectedSymbolId!))?.backgroundColor = UIColor.white
        }
        guard let index = self.buttons.firstIndex(of: sender) else {
            return
        }
        self.selectedSymbol = groupSymbol[index].name
        self.selectedSymbolId = index
        
        if let myViewController = (viewController as? FriendsController) {
            myViewController.tableView.scrollToRow(at: IndexPath(row: 0, section: selectedSymbolId!), at: .top, animated: true)
            myViewController.tableView.cellForRow(at: IndexPath(row: 0, section: selectedSymbolId!))?.backgroundColor = UIColor.green
        }
    }
    
    private func setupView() {
        for group in groupSymbol {
            let button = UIButton(type: .system)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.heightAnchor.constraint(equalToConstant: 20).isActive = true
            button.widthAnchor.constraint(equalToConstant: 20).isActive = true
            button.setTitle(group.name, for: .normal)
            button.setTitleColor(.lightGray, for: .normal)
            button.setTitleColor(.black, for: .selected)
            button.addTarget(self, action: #selector(selectSymbol(_:)), for: .touchUpInside)
            buttons.append(button)
        }
        
        stackView = UIStackView(arrangedSubviews: self.buttons)
        
        self.addSubview(stackView)
        
        stackView.spacing = CGFloat(groupSymbol.count)
        //stackView.frame.size.height = CGFloat(20 * groupSymbol.count)
        //stackView.frame.size.width = 20
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

    }
    
    private func updateSelectedSymbol() {
        for (index, button) in self.buttons.enumerated() {
            button.isSelected = groupSymbol[index].name == self.selectedSymbol
        }
    }
    
    func isSelectedButton(selectedSymbolId: Int?, isSelected: Bool) {
        if selectedSymbolId != nil {
            buttons[selectedSymbolId!].isSelected = isSelected
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stackView.frame = bounds
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
    }

}
