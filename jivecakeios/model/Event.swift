class Event {
    let id: String
    let hash: String
    let organizationId: String
    let entityAssetConsentId: String?
    let paymentProfileId: String?
    let userData: [UserData]
    let currency: String?
    let name: String
    let description: String?
    let status: Int
    let requireName: Bool
    let requireOrganizationName: Bool
    let assignIntegerToRegistrant: Bool
    let requirePhoto: Bool
    let qr: Bool
    let facebookEventId: String?
    let twitterUrl: String?
    let websiteUrl: String?
    let previewImageUrl: String?
    let timeStart: Int?
    let timeEnd: Int?
    let timeUpdated: Int
    let timeCreated: Int
    let lastActivity: Int

    init(
        id: String,
        hash: String,
        organizationId: String,
        entityAssetConsentId: String?,
        paymentProfileId: String?,
        userData: [UserData],
        currency: String?,
        name: String,
        description: String?,
        status: Int,
        requireName: Bool,
        requireOrganizationName: Bool,
        assignIntegerToRegistrant: Bool,
        requirePhoto: Bool,
        qr: Bool,
        facebookEventId: String?,
        twitterUrl: String?,
        websiteUrl: String?,
        previewImageUrl: String?,
        timeStart: Int?,
        timeEnd: Int?,
        timeUpdated: Int,
        timeCreated: Int,
        lastActivity: Int
    ) {
        self.id = id
        self.hash = hash
        self.organizationId = organizationId
        self.entityAssetConsentId = entityAssetConsentId
        self.paymentProfileId = paymentProfileId
        self.userData = userData
        self.currency = currency
        self.name = name
        self.description = description
        self.status = status
        self.requireName = requireName
        self.requireOrganizationName = requireOrganizationName
        self.assignIntegerToRegistrant = assignIntegerToRegistrant
        self.requirePhoto = requirePhoto
        self.qr = qr
        self.facebookEventId = facebookEventId
        self.twitterUrl = twitterUrl
        self.websiteUrl = websiteUrl
        self.previewImageUrl = previewImageUrl
        self.timeStart = timeStart
        self.timeEnd = timeEnd
        self.timeUpdated = timeUpdated
        self.timeCreated = timeCreated
        self.lastActivity = lastActivity
    }
}
