import Auth0

struct TransactionRow {
    let transaction: Transaction
    let item: Item
    let event: Event
    let organization: Organization
    let userInfo: UserInfo?
}
