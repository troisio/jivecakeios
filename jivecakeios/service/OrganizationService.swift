import BrightFutures
import Alamofire
import Auth0

class OrganizationService {
    let idToken: String

    init(idToken: String) {
        self.idToken = idToken
    }

    func getTree(id: String) -> Future<OrganizationTree, AnyError> {
        return Future<OrganizationTree, AnyError> { complete in
            Alamofire.request(
                "https://api.jivecake.com/organization/\(id)/tree",
                method: .get,
                encoding: JSONEncoding.default
                ).responseJSON { response in
                    switch response.result {
                    case .success(_):
                        let tree = OrganizationTree(
                            organization: Organization(),
                            items: [Item](),
                            events: [Event](),
                            transactions: [Transaction]()
                        )
                        complete(.success(tree))
                    case .failure(let error):
                        complete(.failure(AnyError(error: error)))
                    }
            }
        }
    }
}
