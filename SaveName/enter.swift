//
//  enter.swift
//  SaveName
//
//  Created by RazanAlzahrani on 16/10/1445 AH.
//

import Foundation
import Firebase

class AuthService {
    func signIn(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }

    func signUp(email: String, password: String, completion: @escaping (AuthDataResult?, Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password, completion: completion)
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }
}

import SwiftUI

struct EnterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(isSignUp ? "Sign Up" : "Log In") {
                if isSignUp {
                    // Call your authentication service to sign up
                    AuthService().signUp(email: email, password: password) { result, error in
                        if let error = error {
                            print("Sign up failed: \(error.localizedDescription)")
                        } else {
                            print("Sign up successful")
                            // Navigate to the next screen or perform any other action
                        }
                    }
                } else {
                    // Call your authentication service to sign in
                    AuthService().signIn(email: email, password: password) { result, error in
                        if let error = error {
                            print("Login failed: \(error.localizedDescription)")
                        } else {
                            print("Login successful")
                            // Navigate to the next screen or perform any other action
                        }
                    }
                }
            }
            .padding()

            Button(isSignUp ? "Already have an account? Log In" : "Don't have an account? Sign Up") {
                isSignUp.toggle()
            }

            Spacer()
        }
        .padding()
    }
}

struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView()
    }
}
