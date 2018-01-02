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
        }.flatMap({ permissions, credentials, userInfo -> Future<([OrganizationTree], [Permission], Credentials, UserInfo), AnyError> in
            let storage = ApplicationStorage(profile: userInfo, credentials: credentials)
            return permissions
                .filter {$0.objectClass == "Organization"}
                .map { storage.organizationService.getTree(id: $0.objectId) }
                .sequence()
                .flatMap { trees in Future(value: (trees, permissions, credentials, userInfo)) }
        }).flatMap { (organizationTrees, permissions, credentials, userInfo) -> Future<ApplicationStorage, AnyError> in
            var storage = ApplicationStorage(profile: userInfo, credentials: credentials)
            storage.permissions = permissions
            storage.organizationTrees = organizationTrees
            return Future(value: storage)
        }
    }
}
