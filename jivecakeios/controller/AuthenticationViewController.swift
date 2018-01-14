import UIKit
import Auth0
import BrightFutures
import Alamofire

class AuthenticationViewController: UIViewController {
    let activity = UIActivityIndicatorView(activityIndicatorStyle: .gray)

    override func viewDidLoad() {
        ApplicationState.storage = nil
    }

    @IBAction func onSignInClick() {
        if !self.activity.isAnimating {
            self.view.addSubview(self.activity)
            activity.frame = view.bounds
            activity.startAnimating()

            Future<(Credentials), AnyError> { complete in
                Auth0
                    .webAuth()
                    .scope("openid profile email name user_metadata")
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
                self.performSegue(withIdentifier: "signin", sender: self)
                self.activity.stopAnimating()
                self.activity.removeFromSuperview()
            }.onFailure { error in
                self.activity.stopAnimating()
                self.activity.removeFromSuperview()

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
}
