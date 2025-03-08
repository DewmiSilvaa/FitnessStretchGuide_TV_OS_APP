import Foundation
import FirebaseFirestore
import Combine

class UserService {
    private let db = Firestore.firestore()
    
    // Create User Profile
    func createUserProfile(_ user: AppUser) -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                guard let userId = user.id else {
                    promise(.failure(NSError(domain: "UserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid user ID"])))
                    return
                }
                
                try self.db.collection("users").document(userId).setData(from: user) { error in
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
    
    // Fetch User Profile
    func fetchUserProfile(withId userId: String) -> AnyPublisher<AppUser, Error> {
        return Future { promise in
            self.db.collection("users").document(userId).getDocument { (document, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let document = document, document.exists,
                      let user = try? document.data(as: AppUser.self) else {
                    promise(.failure(NSError(domain: "UserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "User profile not found"])))
                    return
                }
                
                promise(.success(user))
            }
        }.eraseToAnyPublisher()
    }
    
    // Update User Profile
    func updateUserProfile(_ user: AppUser) -> AnyPublisher<Void, Error> {
        return Future { promise in
            guard let userId = user.id else {
                promise(.failure(NSError(domain: "UserService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user ID provided"])))
                return
            }
            
            do {
                try self.db.collection("users").document(userId).setData(from: user) { error in
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
    
    // Add Completed Routine to User Profile
    func addCompletedRoutine(userId: String, routineId: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
            let userRef = self.db.collection("users").document(userId)
            
            userRef.updateData([
                "completedRoutines": FieldValue.arrayUnion([routineId])
            ]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // Add Custom Routine to User Profile
    func addCustomRoutine(userId: String, routineId: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
            let userRef = self.db.collection("users").document(userId)
            
            userRef.updateData([
                "customRoutines": FieldValue.arrayUnion([routineId])
            ]) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
