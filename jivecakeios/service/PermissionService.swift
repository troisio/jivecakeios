import Alamofire
import BrightFutures
import SwiftyJSON

class PermissionService {
    let idToken: String

    init(idToken: String) {
        self.idToken = idToken
    }

    func search(parameters: Alamofire.Parameters) -> Future<[Permission], AnyError> {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.idToken)"
        ]

        return Future<[Permission], AnyError> { complete in
            Alamofire.request(
                "https://api.jivecake.com/permission",
                parameters: parameters,
                headers: headers
            ).responseJSON { response in
                switch response.result {
                case .success(let data):
                    let data = JSON(data)
                    let permissions = data["entity"].arrayValue.map { json in
                        Permission(
                            id: json["id"].stringValue,
                            user_id: json["user_id"].stringValue,
                            objectId: json["objectId"].stringValue,
                            include: json["include"].intValue,
                            objectClass: json["objectClass"].stringValue,
                            permissions: json["permissions"].arrayValue.map { $0.intValue },
                            timeCreated: json["timeCreated"].intValue
                        )
                    }

                    complete(.success(permissions))
                case .failure(let error):
                    complete(.failure(AnyError(error: error)))
                }
            }
        }
    }
}
