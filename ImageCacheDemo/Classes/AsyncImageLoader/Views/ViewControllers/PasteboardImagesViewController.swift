import UIKit

class PasteboardImagesViewController: UIViewController {

    @IBOutlet
    var pinImagesTable: UITableView?
    var refreshControl: UIRefreshControl?

    var pins:[Pin] = []

    init() {

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.fetchPins()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(self.fetchPins), for: .valueChanged)
        self.pinImagesTable?.backgroundView = refreshControl
    }

    @objc func fetchPins(){

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension PasteboardImagesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: PinCell.getCellIdentifier())
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: PinCell.getCellIdentifier())
        }
        (cell as! PinCell).updateData(pin: self.pins[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pins.count
    }
}

