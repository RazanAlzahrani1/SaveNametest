import SwiftUI
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

struct EnterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var user: User?

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
                    AuthService().signUp(email: email, password: password) { result, error in
                        if let error = error {
                            showAlert(message: "Sign up failed: \(error.localizedDescription)")
                        } else if let user = result?.user {
                            showAlert(message: "Sign up successful: \(user.uid)")
                        }
                    }
                } else {
                    AuthService().signIn(email: email, password: password) { result, error in
                        if let error = error {
                            showAlert(message: "Login failed: \(error.localizedDescription)")
                        } else if let user = result?.user {
                            showAlert(message: "Login successful: \(user.uid)")
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Authentication"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct EnterView_Previews: PreviewProvider {
    static var previews: some View {
        EnterView()
    }
}
