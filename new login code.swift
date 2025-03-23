//
//  login.swift
//  LionWell real
//
//  Created by Adheera Chilamkurthi on 3/6/25.
//
import SwiftUI

// MARK: - LoginView
struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @State private var isSignUpPresented: Bool = false
    @State private var navigateToCheckIn: Bool = false // Track navigation status

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: performLogin) {
                    Text("Login")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 32)

                Button(action: {
                    isSignUpPresented.toggle()
                }) {
                    Text("Sign Up")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
                .padding(.top, 10)

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                // Navigation Link to CheckInView
                NavigationLink(destination: CheckInView(), isActive: $navigateToCheckIn) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Login")
            .sheet(isPresented: $isSignUpPresented) {
                SignUpView(email: $email, password: $password)
            }
        }
    }

    private func performLogin() {
        guard validateInputs() else { return }

        // Simulate user login
        let storedEmail = UserDefaults.standard.string(forKey: "userEmail") ?? ""
        let storedPassword = UserDefaults.standard.string(forKey: "userPassword") ?? ""

        if email == storedEmail && password == storedPassword {
            // Update navigation status to go to CheckInView
            navigateToCheckIn = true
        } else {
            errorMessage = "Invalid email or password"
            showError = true
        }
    }

    private func validateInputs() -> Bool {
        if email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields"
            showError = true
            return false
        }
        return true
    }
}

// MARK: - SignUpView
struct SignUpView: View {
    @Binding var email: String
    @Binding var password: String
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    @Environment(\.presentationMode) var presentationMode // To dismiss the view

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Sign Up")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                SecureField("Confirm Password", text: $confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: performSignUp) {
                    Text("Create Account")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 32)

                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Sign Up")
        }
    }

    private func performSignUp() {
        guard validateInputs() else { return }

        // Store user credentials
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")

        // Dismiss the SignUpView after successful sign-up
        presentationMode.wrappedValue.dismiss()
        print("Sign up successful")
    }

    private func validateInputs() -> Bool {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty {
            errorMessage = "Please fill in all fields"
            showError = true
            return false
        }

        if password != confirmPassword {
            errorMessage = "Passwords do not match"
            showError = true
            return false
        }

        return true
    }
}

// MARK: - Preview
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
