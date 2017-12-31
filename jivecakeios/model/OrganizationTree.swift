import Auth0

struct OrganizationTree {
    let organization: Organization
    let items: [Item]
    let events: [Event]
    let transactions: [Transaction]
    let paymentProfiles: [PaymentProfile]
    let transactionUsers: [UserInfo]
    let transactionUsersAssets: [EntityAsset]
    let organizationAssets: [EntityAsset]

    init(
        organization: Organization,
        items: [Item],
        events: [Event],
        transactions: [Transaction],
        paymentProfiles: [PaymentProfile],
        transactionUsers: [UserInfo],
        transactionUsersAssets: [EntityAsset],
        organizationAssets: [EntityAsset]
    ) {
        self.organization = organization
        self.items = items
        self.events = events
        self.transactions = transactions
        self.paymentProfiles = paymentProfiles
        self.transactionUsers = transactionUsers
        self.transactionUsersAssets = transactionUsersAssets
        self.organizationAssets = organizationAssets
    }
}
