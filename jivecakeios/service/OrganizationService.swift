import BrightFutures
import Alamofire
import Auth0
import SwiftyJSON

class OrganizationService {
    let uri: String
    let idToken: String

    init(uri: String, idToken: String) {
        self.uri = uri
        self.idToken = idToken
    }

    func getTree(id: String) -> Future<OrganizationTree, AnyError> {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.idToken)"
        ]

        return Future<OrganizationTree, AnyError> { complete in
            Alamofire.request(
                "\(self.uri)/organization/\(id)/tree",
                headers: headers
                ).responseJSON { response in
                    switch response.result {
                    case .success(let data):
                        let data = JSON(data)
                        let transactions = data["transaction"].arrayValue.map {JsonMappingService.toTransaction(json: $0)}
                        let items = data["item"].arrayValue.map {JsonMappingService.toItem(json: $0)}
                        let events = data["event"].arrayValue.map {JsonMappingService.toEvent(json: $0)}
                        let paymentProfiles = data["paymentProfile"].arrayValue.map {JsonMappingService.toPaymentProfile(json: $0)}
                        let transactionUsers: [UserInfo] = data["transactionUser"].arrayValue.map { JsonMappingService.toUserInfo(json: $0) }
                        let transactionUsersAssets = data["transactionUserAsset"].arrayValue.map { JsonMappingService.toAsset(json: $0) }
                        let organizationAssets = data["organizationAsset"].arrayValue.map { JsonMappingService.toAsset(json: $0) }
                        let organization = JsonMappingService.toOrganization(json: data["organization"])
dump(transactionUsers)
                        let tree = OrganizationTree(
                            organization: organization,
                            items: items,
                            events: events,
                            transactions: transactions,
                            paymentProfiles: paymentProfiles,
                            transactionUsers: transactionUsers,
                            transactionUsersAssets: transactionUsersAssets,
                            organizationAssets: organizationAssets
                        )
                        complete(.success(tree))
                    case .failure(let error):
                        complete(.failure(AnyError(error: error)))
                    }
            }
        }
    }
}
