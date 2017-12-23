import Auth0

struct ApplicationStorage {
    let profile: UserInfo
    let credentials: Credentials
    let permissionService: PermissionService
    let downstreamService: DownstreamService
    let organizationService: OrganizationService

    init(profile: UserInfo, credentials: Credentials) {
        self.profile = profile
        self.credentials = credentials
        self.permissionService = PermissionService(idToken: credentials.idToken!)
        self.downstreamService = DownstreamService(idToken: credentials.idToken!)
        self.organizationService = OrganizationService(idToken: credentials.idToken!)
    }
}
