import UIKit

class PasteboardImagesViewController: BaseViewController, ViewSetupProtocol {

    var pinImagesTable: UITableView
    var refreshControl: UIRefreshControl
    var pinManager: PinManager
    var currentPage = 1

    var pins:[Pin] = []

    init(pinManager: PinManager) {
        pinImagesTable = UITableView()
        refreshControl = UIRefreshControl()
        self.pinManager = pinManager
        super.init()
        
        setupUI()
    }

    func setupViews() {
        self.pinImagesTable.backgroundView = refreshControl
        refreshControl.addTarget(self, action: #selector(self.fetchPins), for: .valueChanged)
        self.view.addSubview(pinImagesTable)
    }

    func setupAppearance() {
        self.view.backgroundColor = UIColor.white

        self.pinImagesTable.register(PinCell.self, forCellReuseIdentifier: PinCell.getCellIdentifier())
        self.pinImagesTable.delegate = self
        self.pinImagesTable.dataSource = self
    }

    func setupConstraints() {
        pinImagesTable.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            pinImagesTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            pinImagesTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            pinImagesTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            pinImagesTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
            ]);
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.fetchPins()
    }

    @IBAction func fetchPins() {
        self.pinManager.getPins(page: currentPage) { (pins, error) in
            if error != nil {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.showError(title: "Error", message: "Unable to fetch images")
                }
            }
            guard let pins = pins else {
                return
            }
            //will have some sort of appending once we add pagination
            //TODO: move this to a data source
            self.pins = pins
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.pinImagesTable.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func loadMore() {
        //TODO: Implement the logic to load more data
    }
}

extension PasteboardImagesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: PinCell.getCellIdentifier()) as? PinCell {
            let currentPin = pins[indexPath.row]
            cell.updateData(pin: currentPin)
            if indexPath.row == pins.count - 1 {
                self.loadMore()
            }

            return cell
        }

        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pins.count
    }
}

