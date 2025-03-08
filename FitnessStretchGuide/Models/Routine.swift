import Foundation
import FirebaseFirestore
enum DifficultyLevel: String, Codable {
    case beginner
    case intermediate
    case advanced
}

// File: Models/Routine.swift
struct Routine: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var description: String
    var creatorID: String
    var isCustom: Bool
    var exercises: [String] // Array of exercise IDs
    var totalDuration: Int
    var difficultyLevel: DifficultyLevel
    var tags: [String]?
}
