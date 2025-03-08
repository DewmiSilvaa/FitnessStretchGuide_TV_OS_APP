import Foundation
import FirebaseAuth
import Combine

class AuthenticationService {
    static let shared = AuthenticationService()
    
    private init() {}
    
    func signUp(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = authResult?.user else {
                    promise(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User creation failed"])))
                    return
                }
                
                promise(.success(user))
            }
        }.eraseToAnyPublisher()
    }
    
    func signIn(email: String, password: String) -> AnyPublisher<User, Error> {
        return Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    promise(.failure(error))
                    return
                }
                
                guard let user = authResult?.user else {
                    promise(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Sign in failed"])))
                    return
                }
                
                promise(.success(user))
            }
        }.eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, Error> {
        return Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func getCurrentUser() -> User? {
        return Auth.auth().currentUser
    }
}
