import SwiftUI
import AuthenticationServices

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    // MARK: - Authentication Manager
    @StateObject private var authManager = AuthenticationManager()
    
    var body: some View {
        ZStack {
            // Background
            Color("BackgroundColor")
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 20) {
                    // Logo and App Name
                    Image("lionwell-logo") // Add your logo asset
                        .resizable()
                        .scaledToFit()
                        .frame(height: 100)
                    
                    Text("LionWell")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.primary)
                    
                    // Input Fields
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Password", text: $password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal, 32)
                    
                    // Login Button
                    Button(action: performLogin) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 32)
                    .disabled(isLoading)
                    
                    // Microsoft SSO Button
                    Button(action: performMicrosoftLogin) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                            Text("Sign in with Penn State")
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                    .padding(.horizontal, 32)
                    
                    // Forgot Password Link
                    Button(action: forgotPassword) {
                        Text("Forgot Password?")
                            .foregroundColor(.blue)
                    }
                    
                    // Sign Up Option
                    HStack {
                        Text("Don't have an account?")
                        Button(action: navigateToSignUp) {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .padding(.vertical, 32)
            }
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("Error"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Actions
    
    private func performLogin() {
        guard validateInputs() else { return }
        
        isLoading = true
        
        // Simulate network request
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            // Add your actual login logic here
        }
    }
    
    private func performMicrosoftLogin() {
        isLoading = true
        authManager.signInWithMicrosoft { result in
            isLoading = false
            switch result {
            case .success:
                // Handle successful login
                break
            case .failure(let error):
                showError = true
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func validateInputs() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields"
            showError = true
            return false
        }
        
        if !isValidEmail(email) {
            errorMessage = "Please enter a valid email address"
            showError = true
            return false
        }
        
        return true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    private func forgotPassword() {
        // Implement forgot password logic
    }
    
    private func navigateToSignUp() {
        // Implement navigation to sign up page
    }
}

// MARK: - Authentication Manager
class AuthenticationManager: ObservableObject {
    func signInWithMicrosoft(completion: @escaping (Result<Void, Error>) -> Void) {
        // Implement Microsoft authentication using Penn State credentials
        // You'll need to set up Azure AD authentication and use appropriate SDK
        // Example implementation would use MSAL (Microsoft Authentication Library)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
