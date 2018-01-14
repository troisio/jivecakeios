import Auth0
import BrightFutures

class ApplicationService {
    static func getStorageFromCredentials(credentials: Credentials) -> Future<ApplicationStorage, AnyError> {
        return Future<(Credentials, UserInfo), AnyError> { complete in
            Auth0
                .authentication()
                .userInfo(withAccessToken: credentials.accessToken!)
                .start { result in
                    switch result {
                    case .success(let profile):
                        complete(.success((credentials, profile)))
                    case .failure(let error):
                        complete(.failure(AnyError(error: error)))
                    }
            }
        }.flatMap { (credentials, profile) -> Future<([Permission], Credentials, UserInfo), AnyError> in
            let storage = ApplicationStorage(profile: profile, credentials: credentials)
            return storage
                .permissionService.search(parameters: ["user_id": storage.profile.sub])
                .flatMap { permissions in Future(value: (permissions, credentials, profile)) }
        }.flatMap({ permissions, credentials, userInfo -> Future<([TransactionRow], [OrganizationTree], [Permission], Credentials, UserInfo), AnyError> in
            let storage = ApplicationStorage(profile: userInfo, credentials: credentials)
            
            let myTransactionsFuture = storage.transactionService.getTransactionRowFromSub(sub: userInfo.sub)
            let treesFuture = permissions
                .filter {$0.objectClass == "Organization"}
                .map { storage.organizationService.getTree(id: $0.objectId) }
                .sequence()
            return myTransactionsFuture.zip(treesFuture)
                .flatMap { (trees, myTransactions) in Future(value: (trees, myTransactions, permissions, credentials, userInfo)) }
        }).flatMap { (myTransactions, organizationTrees, permissions, credentials, userInfo) -> Future<ApplicationStorage, AnyError> in
            var storage = ApplicationStorage(profile: userInfo, credentials: credentials)
            storage.permissions = permissions
            storage.organizationTrees = organizationTrees
            storage.myTransactions = myTransactions.map {
                TransactionRow(
                    transaction: $0.transaction,
                    item: $0.item,
                    event: $0.event,
                    organization: $0.organization,
                    userInfo: userInfo
                )
            }
            return Future(value: storage)
        }
    }
}
