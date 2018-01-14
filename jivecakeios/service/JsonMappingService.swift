import SwiftyJSON
import Auth0

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
        return Item(
            id: json["id"].stringValue,
            eventId: json["eventId"].stringValue,
            organizationId: json["organizationId"].stringValue,
            name: json["name"].stringValue,
            description: json["description"].string,
            totalAvailible: json["totalAvailible"].int,
            maximumPerUser: json["maximumPerUser"].int,
            amount: json["amount"].doubleValue,
            timeAmounts: json["timeAmounts"].array?.map {ItemTimeAmount(amount: $0["amount"].doubleValue, after: $0["after"].intValue)},
            countAmounts: json["countAmounts"].array?.map {ItemCountAmount(count: $0["count"].intValue, amount: $0["amount"].doubleValue)},
            status: json["status"].intValue,
            timeStart: json["timeStart"].int,
            timeEnd: json["timeEnd"].int,
            timeUpdated: json["timeUpdated"].intValue,
            timeCreated: json["timeCreated"].intValue,
            lastActivity: json["lastActivity"].intValue
        )
    }

    static func toEvent(json: JSON) -> Event {
        return Event(
            id: json["id"].stringValue,
            hash: json["hash"].stringValue,
            organizationId: json["organizationId"].stringValue,
            entityAssetConsentId: json["entityAssetConsentId"].string,
            paymentProfileId: json["paymentProfileId"].string,
            userData: json["userData"].arrayValue.map { UserData(userId: $0["userId"].stringValue, number: $0["number"].intValue) },
            currency: json["currency"].string,
            name: json["name"].stringValue,
            description: json["description"].string,
            status: json["status"].intValue,
            requireName: json["requireName"].boolValue,
            requireOrganizationName: json["requireOrganizationName"].boolValue,
            assignIntegerToRegistrant: json["assignIntegerToRegistrant"].boolValue,
            requirePhoto: json["requirePhoto"].boolValue,
            qr: json["qr"].boolValue,
            facebookEventId: json["facebookEventId"].string,
            twitterUrl: json["twitterUrl"].string,
            websiteUrl: json["websiteUrl"].string,
            previewImageUrl: json["previewImageUrl"].string,
            timeStart: json["timeStart"].int,
            timeEnd: json["timeEnd"].int,
            timeUpdated: json["timeUpdated"].intValue,
            timeCreated: json["timeCreated"].intValue,
            lastActivity: json["lastActivity"].intValue
        )
    }

    static func toOrganization(json: JSON) -> Organization {
        return Organization(
            id: json["id"].stringValue,
            parentId: json["id"].string,
            name: json["name"].stringValue,
            email: json["email"].stringValue,
            emailConfirmed: json["emailConfirmed"].boolValue,
            createdBy: json["createdBy"].stringValue,
            timeUpdated: json["timeUpdated"].intValue,
            timeCreated: json["timeCreated"].intValue,
            lastActivity: json["lastActivity"].intValue
        )
    }

    static func toPaymentProfile(json: JSON) -> PaymentProfile {
        return PaymentProfile(
            id: json["id"].stringValue,
            organizationId: json["organizationId"].stringValue,
            email: json["email"].string,
            stripe_publishable_key: json["stripe_publishable_key"].string,
            stripe_user_id: json["stripe_user_id"].string,
            timeCreated: json["timeCreated"].intValue
        )
    }

    static func toAsset(json: JSON) -> EntityAsset {
        return EntityAsset(
            id: json["id"].stringValue,
            entityId: json["entityId"].stringValue,
            entityType: json["entityType"].intValue,
            assetType: json["assetType"].intValue,
            data: json["data"].string,
            name: json["name"].string,
            timeCreated: json["timeCreated"].intValue
        )
    }
    
    static func toUserInfo(json: JSON) -> UserInfo {
        return UserInfo(
            sub: json["user_id"].stringValue,
            name: json["name"].string,
            givenName: json["givenName"].string,
            familyName: json["familyName"].string,
            middleName: json["middleName"].string,
            nickname: json["nickname"].string,
            preferredUsername: nil,
            profile: nil,
            picture: nil,
            website: nil,
            email: json["email"].string,
            emailVerified: json["emailVerified"].bool,
            gender:json["emailVerified"].string,
            birthdate: json["emailVerified"].string,
            zoneinfo: nil,
            locale: nil,
            phoneNumber: json["phoneNumber"].string,
            phoneNumberVerified: json["phoneNumberVerified"].bool,
            address: [:],
            updatedAt: nil,
            customClaims: [:]
        )
    }
}
