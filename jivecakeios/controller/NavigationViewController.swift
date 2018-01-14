import UIKit

class NavigationViewController: UIViewController {
    @IBOutlet weak var toTransactions: UIButton!
    @IBOutlet weak var scanner: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.toTransactions.isHidden = ApplicationState.storage!.organizationTrees.isEmpty
        self.scanner.isHidden = ApplicationState.storage!.organizationTrees
            .map { $0.events }
            .flatMap { $0 }
            .filter { $0.qr }
            .isEmpty
    }
}
