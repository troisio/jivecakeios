import UIKit
import Auth0
import Locksmith

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let account = Locksmith.loadDataForUserAccount(userAccount: "default")

        if account != nil {
            self.performSegue(withIdentifier: "signInToNavigation", sender: self)
        }
    }
    
    @IBAction func onSignInClick() {
        Auth0
            .webAuth()
            .scope("openid profile")
            .audience("https://jivecake.auth0.com/userinfo")
            .start {
                switch $0 {
                case .failure(let error):
                    print("Error: \(error)")
                case .success(let credentials):
                    let success:Bool

                    do {
                        Locksmith.deleteDataForUserAccount(userAccount: "default")
                        try Locksmith.saveData(
                            data: [
                                "accessToken": credentials.accessToken!,
                                "expiresIn": credentials.expiresIn!,
                                "idToken": credentials.idToken!,
                                "tokenType": credentials.tokenType!
                            ],
                            forUserAccount: "default"
                        )
                        success = true
                    } catch {
                        print("Error info: \(error)")
                        success = false
                    }
                    
                    if success {
                        self.performSegue(withIdentifier: "signInToNavigation", sender: self)
                    } else {
                        let alert = UIAlertController(
                            title: "Unable to log in",
                            message: "Sorry, we are not able log you in",
                            preferredStyle: UIAlertControllerStyle.alert
                        )
                        alert.addAction(UIAlertAction(title: "Ok", style: .default))
                        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
    }
}
