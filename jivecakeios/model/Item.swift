class Item {
    let id: String
    let eventId: String
    let organizationId: String
    let name: String
    let description: String?
    let totalAvailible: Int?
    let maximumPerUser: Int?
    let amount: Double
    let timeAmounts: [ItemTimeAmount]?
    let countAmounts: [ItemCountAmount]?
    let status: Int
    let timeStart: Int?
    let timeEnd: Int?
    let timeUpdated: Int
    let timeCreated: Int
    let lastActivity: Int

    init(
        id: String,
        eventId: String,
        organizationId: String,
        name: String,
        description: String?,
        totalAvailible: Int?,
        maximumPerUser: Int?,
        amount: Double,
        timeAmounts: [ItemTimeAmount]?,
        countAmounts: [ItemCountAmount]?,
        status: Int,
        timeStart: Int?,
        timeEnd: Int?,
        timeUpdated: Int,
        timeCreated: Int,
        lastActivity: Int
    ) {
        self.id = id
        self.eventId = eventId
        self.organizationId = organizationId
        self.name = name
        self.description = description
        self.totalAvailible = totalAvailible
        self.maximumPerUser = maximumPerUser
        self.amount = amount
        self.timeAmounts = timeAmounts
        self.countAmounts = countAmounts
        self.status = status
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.timeUpdated = timeUpdated
        self.timeCreated = timeCreated
        self.lastActivity = lastActivity
    }
}
