import Auth0

class TransactionService {
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
}
