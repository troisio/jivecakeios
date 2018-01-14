import UIKit
import BrightFutures

class MyTransactionsController: UITableViewController {
    var rows: [TransactionRow] = []
    let reloadControl = UIRefreshControl()
    var selectedRow: TransactionRow?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.rows = ApplicationState.storage!.myTransactions.filter {
            $0.transaction.leaf &&
            $0.transaction.status == TransactionService.SETTLED
        }
        self.reloadControl.addTarget(self, action: #selector(TransactionViewController.onRefresh(_:)), for: UIControlEvents.valueChanged)
        self.reloadControl.tintColor = Color.PENDING_COLOR.withAlphaComponent(0.6)
        self.tableView.addSubview(self.reloadControl)
    }

    func getRows(storage: ApplicationStorage) -> Future<[TransactionRow], AnyError> {
        return storage.transactionService.getTransactionRowFromSub(sub: storage.profile.sub)
            .flatMap { rows -> Future<[TransactionRow], AnyError> in
                let rowsWithUser = rows
                    .map {
                        TransactionRow(
                            transaction: $0.transaction,
                            item: $0.item,
                            event: $0.event,
                            organization: $0.organization,
                            userInfo: ApplicationState.storage!.profile
                        )
                    }

                return Future(value: rowsWithUser)
            }
    }

    @objc func onRefresh(_ sender: Any) {
        self.getRows(storage: ApplicationState.storage!)
            .onSuccess { rows in
                ApplicationState.storage!.myTransactions = rows
                self.rows = rows.filter {
                    $0.transaction.leaf &&
                    $0.transaction.status == TransactionService.SETTLED
                }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "row") as! MyTransactionRowTableCell
        cell.update(row: self.rows[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rows.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier ?? nil) == "myTransactionToDetail" {
            let controller = segue.destination as! TransactionDetailViewController
            controller.transaction = selectedRow?.transaction
            controller.item = selectedRow?.item
            controller.event = selectedRow?.event
            controller.userInfo = selectedRow?.userInfo
        }
    }
    
    override  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = self.rows[indexPath.row]
        self.performSegue(withIdentifier: "myTransactionToDetail", sender: self)
    }
}
