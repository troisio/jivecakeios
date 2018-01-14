import UIKit

class MyTransactionRowTableCell: UITableViewCell {
    @IBOutlet weak var item: UILabel!
    
    func update(row: TransactionRow) {
        item.text = row.item.name
    }
}
