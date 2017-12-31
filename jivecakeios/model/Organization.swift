class Organization {
    let id: String
    let parentId: String?
    let name: String
    let email: String
    let emailConfirmed: Bool
    let createdBy: String
    let timeUpdated: Int
    let timeCreated: Int
    let lastActivity: Int

    init(
        id: String,
        parentId: String?,
        name: String,
        email: String,
        emailConfirmed: Bool,
        createdBy: String,
        timeUpdated: Int,
        timeCreated: Int,
        lastActivity: Int
    ) {
        self.id = id
        self.parentId = parentId
        self.name = name
        self.email = email
        self.emailConfirmed = emailConfirmed
        self.createdBy = createdBy
        self.timeUpdated = timeUpdated
        self.timeCreated = timeCreated
        self.lastActivity = lastActivity
    }
}
