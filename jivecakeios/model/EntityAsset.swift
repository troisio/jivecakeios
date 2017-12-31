class EntityAsset {
    let id: String
    let entityId: String
    let entityType: Int
    let assetType: Int
    let data: String?
    let name: String?
    let timeCreated: Int

    init(
        id: String,
        entityId: String,
        entityType: Int,
        assetType: Int,
        data: String?,
        name: String?,
        timeCreated: Int
    ) {
        self.id = id
        self.entityId = entityId
        self.entityType = entityType
        self.assetType = assetType
        self.data = data
        self.name = name
        self.timeCreated = timeCreated
    }
}
