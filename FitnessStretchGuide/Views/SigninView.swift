import SwiftUI
import Combine

struct SigninView: View {
    // View Model
    @StateObject private var viewModel = SigninViewModel()
    
    // Navigation
    @State private var navigateToSignup = false
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Title
                Text("Fitness Stretch")
                    .font(.largeTitle)
                    .foregroundColor(.red)
                    .padding(.bottom, 30)
                
                // Email TextField
                CustomTextField(
                    placeholder: "Email",
                    text: $viewModel.email
                )
                
                // Password TextField
                CustomTextField(
                    placeholder: "Password",
                    text: $viewModel.password,
                    isSecure: true
                )
                
                // Sign In Button
                CustomButton(
                    title: "Sign In",
                    action: {
                        viewModel.signIn()
                    },
                    isDisabled: viewModel.isLoading
                )
                
                // Don't have an account
                HStack {
                    Text("Don't have an account?")
                        .foregroundColor(.white)
                    
                    Button(action: {
                        navigateToSignup = true
                    }) {
                        Text("Sign Up Now")
                            .foregroundColor(.red)
                            .underline()
                    }
                }
                
                // Loading Indicator
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                }
                
                // Error Message
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .background(Color.black)
            .navigationDestination(isPresented: $navigateToSignup) {
                SignupView()
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
            }
        }
        .onReceive(viewModel.$isSignedIn) { isSignedIn in
            if isSignedIn {
                navigateToHome = true
            }
        }
    }
}

// ViewModel
class SigninViewModel: ObservableObject {
    // Published properties
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSignedIn = false
    
    // Authentication service
    private let authService = AuthenticationService.shared
    private var cancellables = Set<AnyCancellable>()
    
    func signIn() {
        // Reset previous error
        errorMessage = nil
        isLoading = true
        
        // Validate inputs
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter email and password"
            isLoading = false
            return
        }
        
        // Perform sign in
        authService.signIn(email: email, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            } receiveValue: { [weak self] _ in
                self?.isSignedIn = true
            }
            .store(in: &cancellables)
    }
}

#Preview {
    SigninView()
        .preferredColorScheme(.dark)
}
