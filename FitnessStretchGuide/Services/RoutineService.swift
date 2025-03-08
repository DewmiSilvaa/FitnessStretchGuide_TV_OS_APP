import Foundation
import FirebaseFirestore
import Combine

class RoutineService {
    private let db = Firestore.firestore()
    
    // Create Routine
    func createRoutine(_ routine: Routine) -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                let _ = try self.db.collection("routines").addDocument(from: routine) { error in
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
    
    // Fetch All Routines
    func fetchAllRoutines() -> AnyPublisher<[Routine], Error> {
        return Future { promise in
            self.db.collection("routines").getDocuments { (querySnapshot, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                let routines = querySnapshot?.documents.compactMap { document -> Routine? in
                    return try? document.data(as: Routine.self)
                } ?? []
                
                promise(.success(routines))
            }
        }.eraseToAnyPublisher()
    }
    
    // Fetch Routine by ID
    func fetchRoutine(byId id: String) -> AnyPublisher<Routine, Error> {
        return Future { promise in
            self.db.collection("routines").document(id).getDocument { (document, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let document = document, document.exists,
                      let routine = try? document.data(as: Routine.self) else {
                    promise(.failure(NSError(domain: "RoutineService", code: -1, userInfo: [NSLocalizedDescriptionKey: "Routine not found"])))
                    return
                }
                
                promise(.success(routine))
            }
        }.eraseToAnyPublisher()
    }
    
    // Fetch User's Custom Routines
    func fetchCustomRoutines(forUserId userId: String) -> AnyPublisher<[Routine], Error> {
        return Future { promise in
            self.db.collection("routines")
                .whereField("creatorID", isEqualTo: userId)
                .whereField("isCustom", isEqualTo: true)
                .getDocuments { (querySnapshot, error) in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    let routines = querySnapshot?.documents.compactMap { document -> Routine? in
                        return try? document.data(as: Routine.self)
                    } ?? []
                    
                    promise(.success(routines))
                }
        }.eraseToAnyPublisher()
    }
    
    // Update Routine
    func updateRoutine(_ routine: Routine) -> AnyPublisher<Void, Error> {
        return Future { promise in
            guard let id = routine.id else {
                promise(.failure(NSError(domain: "RoutineService", code: -1, userInfo: [NSLocalizedDescriptionKey: "No routine ID provided"])))
                return
            }
            
            do {
                try self.db.collection("routines").document(id).setData(from: routine) { error in
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
    
    // Delete Routine
    func deleteRoutine(withID id: String) -> AnyPublisher<Void, Error> {
        return Future { promise in
            self.db.collection("routines").document(id).delete { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
