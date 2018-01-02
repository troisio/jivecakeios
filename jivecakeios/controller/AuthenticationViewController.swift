import UIKit
import Auth0
import Locksmith
import BrightFutures
import Alamofire
import SwiftyJSON

class AuthenticationViewController: UIViewController {
    @IBAction func onSignInClick() {
        Future<(Credentials), AnyError> { complete in
            Auth0
                .webAuth()
                .scope("openid profile")
                .audience("https://jivecake.auth0.com/userinfo")
                .start {
                    switch $0 {
                    case .failure(let error):
                        complete(.failure(AnyError(error: error)))
                    case .success(let credentials):
                        complete(.success(credentials))
                    }
            }
        }.flatMap {
            ApplicationService.getStorageFromCredentials(credentials: $0)
        }.onSuccess { storage in
            ApplicationState.storage = storage
            self.performSegue(withIdentifier: "signInToNavigation", sender: self)
        }.onFailure { error in
            let alert = UIAlertController(
                title: "Unable to log in",
                message: error.localizedDescription,
                preferredStyle: UIAlertControllerStyle.alert
            )
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
