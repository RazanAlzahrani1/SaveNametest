//
//  createview.swift
//  SaveName
//
//  Created by RazanAlzahrani on 16/10/1445 AH.
//

import Foundation
struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Sign Up") {
                // Call your authentication service to sign up
                AuthService().signUp(email: email, password: password) { result, error in
                    if let error = error {
                        print("Sign up failed: \(error.localizedDescription)")
                    } else {
                        print("Sign up successful")
                        // Navigate to the next screen or perform any other action
                    }
                }
            }
            .padding()

            Spacer()
        }
        .padding()
    }
}
