import UIKit
import Auth0
import Locksmith
import BrightFutures
import Alamofire

class AuthenticationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onSignInClick() {
        Future<(Credentials, UserInfo), AnyError> { complete in
            Auth0
                .webAuth()
                .scope("openid profile")
                .audience("https://jivecake.auth0.com/userinfo")
                .start {
                    switch $0 {
                    case .failure(let error):
                        complete(.failure(AnyError(error: error)))
                    case .success(let credentials):
                        Auth0
                            .authentication()
                            .userInfo(withAccessToken: credentials.accessToken!)
                            .start { result in
                                switch result {
                                case .success(let profile):
                                    complete(.success((credentials, profile)))
                                case .failure(let error):
                                    complete(.failure(AnyError(error: error)))
                                }
                        }
                    }
            }
        }.onSuccess { credentials, profile in
            ApplicationState.storage = ApplicationStorage(profile: profile, credentials: credentials)
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
