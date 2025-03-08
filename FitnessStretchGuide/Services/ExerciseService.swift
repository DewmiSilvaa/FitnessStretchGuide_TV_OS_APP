import Foundation
import FirebaseFirestore
import Combine

class ExerciseService {
    private let db = Firestore.firestore()
    
    // Create Exercise
    func createExercise(_ exercise: Exercise) -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                let _ = try self.db.collection("exercises").addDocument(from: exercise) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    // Get All Exercises
    func fetchAllExercises() -> AnyPublisher<[Exercise], Error> {
        return Future { promise in
            self.db.collection("exercises").getDocuments { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                let exercises = querySnapshot?.documents.compactMap { document -> Exercise? in
                    return try? document.data(as: Exercise.self)
                } ?? []
                
                promise(.success(exercises))
            }
        }.eraseToAnyPublisher()
    }
    
    // Get Exercise by ID
    func fetchExercise(byId id: String) -> AnyPublisher<Exercise, Error> {
        return Future { promise in
            self.db.collection("exercises").document(id).getDocument { (document, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let document = document, document.exists,
                      let exercise = try? document.data(as: Exercise.self) else {
                    promise(.failure(NSError(domain: "ExerciseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Exercise not found"])))
                    return
                }
                
                promise(.success(exercise))
            }
        }.eraseToAnyPublisher()
    }
    
    // Update Exercise
    func updateExercise(_ exercise: Exercise) -> AnyPublisher<Void, Error> {
        return Future { promise in
            guard let id = exercise.id else {
                promise(.failure(NSError(domain: "ExerciseService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No exercise ID provided"])))
                return
            }
            
            do {
                try self.db.collection("exercises").document(id).setData(from: exercise) { error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(()))
                    }
                }
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    // Delete Exercise
    func deleteExercise(withID id: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.db.collection("exercises").document(id).delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
