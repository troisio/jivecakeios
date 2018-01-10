import UIKit
import Auth0

class TransactionDetailViewController: UIViewController {
    var transaction: Transaction?
    var item: Item?
    var event: Event?
    var userInfo: UserInfo?

    @IBOutlet weak var nameValue: UILabel!
    @IBOutlet weak var eventItemValue: UILabel!
    @IBOutlet weak var amountValue: UILabel!
    @IBOutlet weak var quantityValue: UILabel!
    @IBOutlet weak var statusValue: UILabel!
    @IBOutlet weak var paymentMethodValue: UILabel!

    override func viewDidLoad() {
        let statusText: String
        let statusColor: UIColor
        let paymentMethodValue: String

        switch self.transaction!.status {
        case TransactionService.SETTLED:
            statusText = "settled"
            statusColor = Color.SUCCESS_COLOR
        case TransactionService.PENDING:
            statusText = "pending"
            statusColor = Color.PENDING_COLOR
        case TransactionService.USER_REVOKED:
            statusText = "revoked"
            statusColor = Color.FAILURE_COLOR
        case TransactionService.REFUNDED:
            statusText = "refunded"
            statusColor = Color.FAILURE_COLOR
        default:
            statusText = "unknown"
            statusColor = UIColor.black
        }

        if let linkedObjectClass = transaction?.linkedObjectClass {
            if linkedObjectClass == "PaypalPayment" {
                paymentMethodValue = "Paypal"
            } else if linkedObjectClass == "Stripe" {
                paymentMethodValue = "Stripe"
            } else {
                paymentMethodValue = "JiveCake"
            }
        } else {
            paymentMethodValue = "JiveCake"
        }

        self.nameValue.text = TransactionService.derivedDisplayedTransactionIdentity(transaction: self.transaction!, userInfo: self.userInfo)
        self.eventItemValue.text = "\(self.event!.name) / \(self.item!.name)"
        self.amountValue.text = String(format:"%.2f", transaction!.amount)
        self.quantityValue.text = "\(self.transaction!.quantity)"
        self.statusValue.text = statusText
        self.statusValue.textColor = statusColor
        self.paymentMethodValue.text = paymentMethodValue
    }
}
