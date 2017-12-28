import UIKit
import Locksmith

class TransactionViewController: UIViewController {
    var permissions: [Permission] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let storage = ApplicationState.storage!

        storage.permissionService.search(
            parameters: ["user_id": storage.profile.sub]
        ).onSuccess { permissions in
            self.permissions = permissions.filter {$0.objectClass == "Organization"}
        }.onFailure { error in
            let alert = UIAlertController(
                title: "Unable to retrieve data",
                message: error.localizedDescription,
                preferredStyle: UIAlertControllerStyle.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
