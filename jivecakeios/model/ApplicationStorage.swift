import Auth0

struct ApplicationStorage {
    let jiveCakeUri = "https://api.jivecake.com"
    let profile: UserInfo
    let credentials: Credentials
    let permissionService: PermissionService
    let organizationService: OrganizationService
    let transactionService: TransactionService

    var organizationTrees: [OrganizationTree] = []
    var permissions: [Permission] = []
    var myTransactions: [TransactionRow] = []

    init(profile: UserInfo, credentials: Credentials) {
        self.profile = profile
        self.credentials = credentials
        self.permissionService = PermissionService(uri: self.jiveCakeUri, idToken: credentials.idToken!)
        self.organizationService = OrganizationService(uri: self.jiveCakeUri, idToken: credentials.idToken!)
        self.transactionService = TransactionService(uri: self.jiveCakeUri, idToken: credentials.idToken!)
    }
}
