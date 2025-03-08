import Foundation
import FirebaseFirestore

struct Exercise: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var duration: Int // Duration in seconds
    var imageURL: String?
    var muscleGroups: [String]
    var difficultyLevel: DifficultyLevel
    var videoURL: String?
}

