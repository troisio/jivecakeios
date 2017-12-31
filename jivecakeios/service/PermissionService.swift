import Alamofire
import BrightFutures
import SwiftyJSON

class PermissionService {
    let idToken: String
    let uri: String

    init(uri: String, idToken: String) {
        self.uri = uri
        self.idToken = idToken
    }

    func search(parameters: Alamofire.Parameters) -> Future<[Permission], AnyError> {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.idToken)"
        ]

        return Future<[Permission], AnyError> { complete in
            Alamofire.request(
                "\(self.uri)/permission",
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
                            objectClass: json["objectClass"].stringValue,
                            read: json["read"].boolValue,
                            write: json["write"].boolValue,
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
