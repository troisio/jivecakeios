class PaymentProfile {
    let id: String
    let organizationId: String
    let email: String?
    let stripe_publishable_key: String?
    let stripe_user_id: String?
    let timeCreated: Int

    init(
        id: String,
        organizationId: String,
        email: String?,
        stripe_publishable_key: String?,
        stripe_user_id: String?,
        timeCreated: Int
    ) {
        self.id = id
        self.organizationId = organizationId
        self.email = email
        self.stripe_publishable_key = stripe_publishable_key
        self.stripe_user_id = stripe_user_id
        self.timeCreated = timeCreated
    }
}
