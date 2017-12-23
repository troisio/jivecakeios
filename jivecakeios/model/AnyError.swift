struct AnyError: Error {
    let localizedDescription: String
    init(error: Error) {
        self.localizedDescription = error.localizedDescription
    }
}
