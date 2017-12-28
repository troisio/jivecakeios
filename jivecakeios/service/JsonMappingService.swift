import SwiftyJSON

class JsonMappingService {
    static func toTransaction(json: JSON) -> Transaction {
        return Transaction(
            id: json["id"].stringValue,
            parentTransactionId: json["parentTransactionId"].stringValue,
            itemId: json["itemId"].stringValue,
            eventId: json["eventId"].stringValue,
            organizationId: json["organizationId"].stringValue,
            user_id: json["user_id"].string,
            linkedId: json["linkedId"].string,
            linkedObjectClass: json["linkedObjectClass"].string,
            status: json["status"].intValue,
            paymentStatus: json["paymentStatus"].intValue,
            quantity: json["quantity"].intValue,
            given_name: json["given_name"].string,
            middleName: json["middleName"].string,
            family_name: json["family_name"].string,
            organizationName: json["organizationName"].string,
            amount: json["amount"].doubleValue,
            currency: json["currency"].stringValue,
            email: json["email"].string,
            leaf: json["leaf"].boolValue,
            timeCreated: json["timeCreated"].intValue
        )
    }

    static func toItem(json: JSON) -> Item {
        return Item()
    }

    static func toEvent(json: JSON) -> Event {
        return Event()
    }

    static func toOrganization(json: JSON) -> Organization {
        return Organization()
    }
}
