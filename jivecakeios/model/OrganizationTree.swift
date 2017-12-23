struct OrganizationTree {
    let organization: Organization
    let items: [Item]
    let events: [Event]
    let transactions: [Transaction]

    init(organization: Organization, items: [Item], events: [Event], transactions: [Transaction]) {
        self.organization = organization
        self.items = items
        self.events = events
        self.transactions = transactions
    }
}
