import BrightFutures
import Alamofire
import Auth0
import SwiftyJSON

class OrganizationService {
    let idToken: String

    init(idToken: String) {
        self.idToken = idToken
    }

    func getTree(id: String) -> Future<OrganizationTree, AnyError> {
        return Future<OrganizationTree, AnyError> { complete in
            Alamofire.request(
                "https://api.jivecake.com/organization/\(id)/tree"
                ).responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        let data = JSON(data)

                        let transactions = data["transaction"].arrayValue.map {JsonMappingService.toTransaction(json: $0)}
                        let items = data["item"].arrayValue.map {JsonMappingService.toItem(json: $0)}
                        let events = data["event"].arrayValue.map {JsonMappingService.toEvent(json: $0)}
                        let organization = JsonMappingService.toOrganization(json: data["organization"])
                        
                        let tree = OrganizationTree(
                            organization: organization,
                            items: items,
                            events: events,
                            transactions: transactions
                        )
                        complete(.success(tree))
                    case .failure(let error):
                        complete(.failure(AnyError(error: error)))
                    }
            }
        }
    }
}
