import Alamofire
import Auth0
import BrightFutures
import SwiftyJSON

class TransactionService {
    let idToken: String
    let uri: String
    
    static let SETTLED = 0
    static let PENDING = 1
    static let USER_REVOKED = 2
    static let REFUNDED = 3
    static let UNKNOWN = 4
    static let CURRENCIES = [
        Currency(
            id: "AUD",
            label: "Australian Dollar",
            symbol: "$",
            languages: ["en-au"]
        ),
        Currency(
            id: "BBD",
            label: "Barbadian dollar",
            symbol: "Bds$",
            languages: []
        ),
        Currency(
            id: "BRL",
            label: "Brazilian Real",
            symbol: "R$",
            languages: ["pt-br"]
        ),
        Currency(
            id: "BBD",
            label: "Barbadian Dollar",
            symbol: "Bds$",
            languages: []
        ),
        Currency(
            id: "BSD",
            label: "Bahamian dollar",
            symbol: "$",
            languages: []
        ),
        Currency(
            id: "CAD",
            label: "Canadian Dollar",
            symbol: "$",
            languages: ["en-ca", "fr-ca"]
        ),
        Currency(
            id: "EUR",
            label: "Euro",
            symbol: "€",
            languages: ["en-ie", "ga", "it", "de", "de-de", "de-ch", "nl", "fr", "fr-fr", "fr-mc", "gd", "gd-ie", "es-es", "pt"]
        ),
        Currency(
            id: "FJD",
            label: "Fijian Dollar",
            symbol: "FJ$",
            languages: ["fj"]
        ),
        Currency(
            id: "GBP",
            label: "Pound Sterling",
            symbol: "£",
            languages: ["en-gb"]
        ),
        Currency(
            id: "ILS",
            label: "Israeli Shekel",
            symbol: "₪",
            languages: ["he", "ji"]
        ),
        Currency(
            id: "ISK",
            label: "Icelandic Krona",
            symbol: "kr",
            languages: ["is"]
        ),
        Currency(
            id: "NZD",
            label: "New Zealand Dollar",
            symbol: "$",
            languages: ["en-nz"]
        ),
        Currency(
            id: "RUB",
            label: "Russian Ruble",
            symbol: "₽",
            languages: ["ru", "ru-mo"]
        ),
        Currency(
            id: "SEK",
            label: "Swedish Kronner",
            symbol: "kr",
            languages: ["sv", "sv-fl", "sv-sv"]
        ),
        Currency(
            id: "TTD",
            label: "Trinidad and Tobago Dollar",
            symbol: "$",
            languages: ["en-tt"]
        ),
        Currency(
            id: "USD",
            label: "US Dollar",
            symbol: "$",
            languages: ["en-us", "es-pr"]
        ),
        Currency(
            id: "ZAR",
            label: "South African Rand",
            symbol: "R",
            languages: ["af", "en-za", "zu"]
        )
    ]

    init(uri: String, idToken: String) {
        self.uri = uri
        self.idToken = idToken
    }
    
    static func getTransactionRows(tree: OrganizationTree) -> [TransactionRow] {
        let idToEvent: [String: [Event]] = Dictionary(
            grouping: tree.events,
            by: { (event: Event) in event.id}
        )

        let idToItem: [String: [Item]] = Dictionary(
            grouping: tree.items,
            by: { (item: Item) in item.id}
        )

        let idToUser: [String: [UserInfo]] = Dictionary(
            grouping: tree.transactionUsers,
            by: { (userInfo: UserInfo) in userInfo.sub}
        )
        
        return tree.transactions.map { transaction in
            var userInfo: UserInfo? = nil
            
            if let id = transaction.user_id {
                if let users = idToUser[id] {
                    userInfo = users[0]
                }
            }

            return TransactionRow(
                transaction: transaction,
                item: idToItem[transaction.itemId]![0],
                event: idToEvent[transaction.eventId]![0],
                organization: tree.organization,
                userInfo: userInfo
            )
        }
    }

    func search(parameters: Alamofire.Parameters) -> Future<[Transaction], AnyError> {
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(self.idToken)"
        ]

        return Future<[Transaction], AnyError> { complete in
            Alamofire.request(
                "\(self.uri)/transaction",
                parameters: parameters,
                headers: headers
            ).responseJSON { response in
                switch response.result {
                case .success(let data):
                    let data = JSON(data)
                    let transactions = data.arrayValue.map { JsonMappingService.toTransaction(json: $0) }
                    complete(.success(transactions))
                case .failure(let error):
                    complete(.failure(AnyError(error: error)))
                }
            }
        }
    }

    static func derivedDisplayedTransactionIdentity(transaction: Transaction, userInfo: UserInfo?) -> String {
        var result = ""
        
        if let info = userInfo {
            if info.givenName == nil && info.familyName == nil {
                result = info.name ?? info.email ?? ""
            } else {
                result += info.givenName ?? ""
                
                if info.familyName != nil {
                    if result == "" {
                        result += " "
                    }

                    result += "\(info.familyName!)"
                }
            }
        } else {
            result = transaction.given_name ?? ""
            
            if result != "" && transaction.family_name != nil {
                result += " "
            }
            
            result += transaction.family_name ?? ""
            
            if result == "" {
                result = transaction.email ?? ""
            }
        }
        
        return result
    }

    static func getCurrencyFromCode(symbol: String) -> Currency? {
        for currency in TransactionService.CURRENCIES {
            if currency.id == symbol {
                return currency
            }
        }
        
        return nil
    }
}
