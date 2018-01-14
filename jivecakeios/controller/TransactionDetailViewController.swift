import UIKit
import Auth0

class TransactionDetailViewController: UIViewController {
    var transaction: Transaction?
    var item: Item?
    var event: Event?
    var userInfo: UserInfo?

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var eventValue: UILabel!
    @IBOutlet weak var nameValue: UILabel!
    @IBOutlet weak var amountValue: UILabel!
    @IBOutlet weak var quantityValue: UILabel!
    @IBOutlet weak var statusValue: UILabel!
    @IBOutlet weak var paymentMethodValue: UILabel!
    @IBOutlet weak var itemValue: UILabel!

    override func viewDidLoad() {
        let statusText: String
        let paymentMethodValue: String

        switch self.transaction!.status {
        case TransactionService.SETTLED:
            statusText = "settled"
        case TransactionService.PENDING:
            statusText = "pending"
        case TransactionService.USER_REVOKED:
            statusText = "revoked"
        case TransactionService.REFUNDED:
            statusText = "refunded"
        default:
            statusText = "unknown"
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

        if let event = self.event {
            if event.qr {
                self.imageView.image = self.generateQRCode()
            }
        }
        
        self.nameValue.text = TransactionService.derivedDisplayedTransactionIdentity(transaction: self.transaction!, userInfo: self.userInfo)
        self.eventValue.text = "\(self.event!.name)"
        self.itemValue.text = "\(self.item!.name)"
        self.amountValue.text = String(format:"%.2f", transaction!.amount)
        self.quantityValue.text = "\(self.transaction!.quantity)"
        self.statusValue.text = statusText
        self.paymentMethodValue.text = paymentMethodValue
    }

    func generateQRCode() -> UIImage? {
        if let transaction = self.transaction {
            let data = transaction.id.data(using: String.Encoding.ascii)
            
            if let filter = CIFilter(name: "CIQRCodeGenerator") {
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 3, y: 3)
                if let output = filter.outputImage?.transformed(by: transform) {
                    return UIImage(ciImage: output)
                }
            }
        }
        
        return nil
    }
}
