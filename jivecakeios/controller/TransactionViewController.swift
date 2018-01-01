import UIKit

class TransactionViewController: UITableViewController, UISearchBarDelegate {
    var displayRows: [TransactionRow] = []
    var rows: [TransactionRow] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.rows = ApplicationState.storage!.organizationTrees
            .map { TransactionService.getTransactionRows(tree: $0) }
            .flatMap { $0 }
            .filter { $0.transaction.leaf }
            .sorted { $0.transaction.timeCreated > $1.transaction.timeCreated }
        self.displayRows = self.rows
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
        self.performSegue(withIdentifier: "selectTranscation", sender: self)
    }

    func searchBarSearchButtonClicked(_ bar: UISearchBar) {
        bar.resignFirstResponder()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange search: String) {
        func isFiltered(row: TransactionRow) -> Bool {
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

        self.displayRows = self.rows
            .filter { isFiltered(row: $0) }

        self.tableView.reloadData()
    }
}
