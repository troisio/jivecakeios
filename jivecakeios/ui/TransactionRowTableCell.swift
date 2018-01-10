import UIKit

class TransactionRowTableCell: UITableViewCell {
    @IBOutlet weak var item: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var plusMinus: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var identity: UILabel!
    @IBOutlet weak var currency: UILabel!

    func update(row: TransactionRow) {
        var plusMinusText = ""
        var amountText = ""
        var statusText = ""
        var currency = TransactionService.getCurrencyFromCode(symbol: row.transaction.currency)

        if row.transaction.amount > 0 {
            plusMinusText = "+"
            self.plusMinus.textColor = Color.SUCCESS_COLOR
        } else if row.transaction.amount < 0 {
            plusMinusText = "-"
            self.plusMinus.textColor = Color.FAILURE_COLOR
        }

        switch row.transaction.status {
            case TransactionService.PENDING:
                plusMinusText = ""
                currency = nil
                statusText = "pending"
                self.status.textColor = Color.PENDING_COLOR
            case TransactionService.USER_REVOKED:
                plusMinusText = ""
                currency = nil
                statusText = "revoked"
                self.status.textColor = Color.FAILURE_COLOR
            case TransactionService.REFUNDED:
                plusMinusText = ""
                currency = nil
                statusText = "refunded"
                self.status.textColor = Color.FAILURE_COLOR
            default:
                amountText = String(format:"%.2f", abs(row.transaction.amount))
        }

        if row.transaction.amount == 0 {
            amountText = ""
            currency = nil
            statusText = "free"
            self.status.textColor = Color.SUCCESS_COLOR
        }
        
        self.currency.text = currency?.symbol ?? ""
        self.status.text = statusText
        self.plusMinus.text = plusMinusText
        self.amount.text = amountText
        self.identity.text = TransactionService.derivedDisplayedTransactionIdentity(transaction: row.transaction, userInfo: row.userInfo)
        self.item.text = row.item.name
    }
}
