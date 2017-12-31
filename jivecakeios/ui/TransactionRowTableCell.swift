import UIKit

class TransactionRowTableCell: UITableViewCell {
    @IBOutlet weak var transactionText: UILabel!
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var amount: UILabel!

    func update(row: TransactionRow) {
        var text = ""

        if let userInfo = row.userInfo {
            if userInfo.givenName == nil && userInfo.familyName == nil {
                text = userInfo.name ?? userInfo.email ?? ""
            } else {
                text += userInfo.givenName ?? ""

                if userInfo.familyName != nil {
                    if text == "" {
                        text += " "
                    }
                    
                    text += "\(userInfo.familyName!)"
                }
            }
        } else {
            text = row.transaction.given_name ?? ""

            if text != "" && row.transaction.family_name != nil {
                text += " "
            }

            text += row.transaction.family_name ?? ""
            
            if text == "" {
                text = row.transaction.email ?? ""
            }
        }

        self.transactionText.text = text
        self.item.text = row.item.name
        self.amount.text = String(format:"%@ %.2f", row.transaction.currency, row.transaction.amount)
    }
}
