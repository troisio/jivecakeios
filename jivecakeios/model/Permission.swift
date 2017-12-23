import Alamofire
import BrightFutures

class Permission {
    let id: String
    let user_id: String
    let objectId: String
    let include: Int
    let objectClass: String
    let permissions: [Int]
    let timeCreated: Int
    
    init(
        id: String,
        user_id: String,
        objectId: String,
        include: Int,
        objectClass: String,
        permissions: [Int],
        timeCreated: Int
    ) {
        self.id = id
        self.user_id = user_id
        self.objectId = objectId
        self.include = include
        self.objectClass = objectClass
        self.permissions = permissions
        self.timeCreated = timeCreated
    }
}
