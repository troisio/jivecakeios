import UIKit

class TransactionViewController: UITableViewController, UISearchBarDelegate {
    var displayRows: [TransactionRow] = []
    var rows: [TransactionRow] = []
    let reloadControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setRowsFromStorage(storage: ApplicationState.storage!)

        self.reloadControl.addTarget(self, action: #selector(TransactionViewController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        self.reloadControl.tintColor = Color.PENDING_COLOR.withAlphaComponent(0.6)
        self.tableView.addSubview(self.reloadControl)
    }

    func setRowsFromStorage(storage: ApplicationStorage) {
        self.rows = storage.organizationTrees
            .map { TransactionService.getTransactionRows(tree: $0) }
            .flatMap { $0 }
            .filter { $0.transaction.leaf }
            .sorted { $0.transaction.timeCreated > $1.transaction.timeCreated }
        
        /* this is not correct, has to be derived from search bar */
        self.displayRows = self.rows
    }
    
    @objc func onRefresh(_ sender: Any) {
        ApplicationService.getStorageFromCredentials(credentials: ApplicationState.storage!.credentials)
            .onSuccess { storage in
                ApplicationState.storage = storage
                self.setRowsFromStorage(storage: storage)
                self.tableView.reloadData()
                self.reloadControl.endRefreshing()
            }.onFailure { error in
                let alert = UIAlertController(
                    title: "Unable to refresh",
                    message: error.localizedDescription,
                    preferredStyle: UIAlertControllerStyle.alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alert, animated: true, completion: nil)
                self.reloadControl.endRefreshing()
            }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "transactionRowTableCell") as! TransactionRowTableCell
        cell.update(row: self.displayRows[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayRows.count
    }

    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "selectTranscation", sender: self)
    }
    
    func searchBarSearchButtonClicked(_ bar: UISearchBar) {
        bar.resignFirstResponder()
    }

    static func isFiltered(row: TransactionRow, search:String) -> Bool {
        let components = [
            row.transaction.given_name,
            row.transaction.middleName,
            row.transaction.family_name,
            row.transaction.organizationName,
            row.transaction.email,
            row.item.name,
            row.userInfo?.givenName,
            row.userInfo?.familyName,
            row.userInfo?.email,
            row.userInfo?.name
        ]
        .filter { $0 != nil}
        .map { $0!.lowercased() }
        .filter { $0.contains(search.lowercased()) }
        
        return components.count > 0 || search.isEmpty
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange search: String) {
        self.displayRows = self.rows.filter { TransactionViewController.isFiltered(row: $0, search: search) }
        self.tableView.reloadData()
    }
}
