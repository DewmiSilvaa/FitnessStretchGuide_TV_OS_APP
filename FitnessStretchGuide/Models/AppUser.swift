import Foundation
import FirebaseFirestore
struct AppUser: Codable, Identifiable {
    @DocumentID var id: String?
    var email: String
    var displayName: String?
    var customRoutines: [String]? // Array of routine IDs
    var completedRoutines: [String]? // Array of routine IDs
    var createdAt: Date
}
