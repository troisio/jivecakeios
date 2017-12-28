class Transaction {
    let id: String
    let parentTransactionId: String
    let itemId: String
    let eventId: String
    let organizationId: String
    let user_id: String?
    let linkedId: String?
    let linkedObjectClass: String?
    let status: Int
    let paymentStatus: Int
    let quantity: Int
    let given_name: String?
    let middleName: String?
    let family_name: String?
    let organizationName: String?
    let amount: Double
    let currency: String
    let email: String?
    let leaf: Bool
    let timeCreated: Int
    
    init(
        id: String,
        parentTransactionId: String,
        itemId: String,
        eventId: String,
        organizationId: String,
        user_id: String?,
        linkedId: String?,
        linkedObjectClass: String?,
        status: Int,
        paymentStatus: Int,
        quantity: Int,
        given_name: String?,
        middleName: String?,
        family_name: String?,
        organizationName: String?,
        amount: Double,
        currency: String,
        email: String?,
        leaf: Bool,
        timeCreated: Int
    ) {
        self.id = id
        self.parentTransactionId = parentTransactionId
        self.itemId = itemId
        self.eventId = eventId
        self.organizationId = organizationId
        self.user_id = user_id
        self.linkedId = linkedId
        self.linkedObjectClass = linkedObjectClass
        self.status = status
        self.paymentStatus = paymentStatus
        self.quantity = quantity
        self.given_name = given_name
        self.middleName = middleName
        self.family_name = family_name
        self.organizationName = organizationName
        self.amount = amount
        self.currency = currency
        self.email = email
        self.leaf = leaf
        self.timeCreated = timeCreated
    }
}
