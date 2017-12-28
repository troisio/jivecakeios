import Alamofire
import BrightFutures

class Permission {
    let id: String
    let user_id: String
    let objectId: String
    let objectClass: String
    let read: Bool
    let write: Bool
    let timeCreated: Int

    init(
        id: String,
        user_id: String,
        objectId: String,
        objectClass: String,
        read: Bool,
        write: Bool,
        timeCreated: Int
    ) {
        self.id = id
        self.user_id = user_id
        self.objectId = objectId
        self.objectClass = objectClass
        self.read = read
        self.write = write
        self.timeCreated = timeCreated
    }
}
