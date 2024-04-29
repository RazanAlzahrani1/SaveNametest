//
//  ContentView.swift
//  SaveName
//
//  Created by RazanAlzahrani on 13/10/1445 AH.
//


import SwiftUI
import FirebaseFirestore
import UserNotifications // Step 1: Import UserNotifications Framework

struct ContentView: View {
    @State private var name: String = ""
    @State private var names: [String] = [] // Array to hold the fetched names
    @State private var showAlert = false

    var body: some View {
        VStack {
            Spacer()
            TextField("Enter your name", text: $name)
                .frame(width: 350, height:50)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            
            Button(action: {
                self.saveName() // Call saveName when the button is tapped
            }) {
                Text("Save Name")
            }
            .padding()
            
            // Display the fetched names
            List(names, id: \.self) { name in
                Text(name)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("Name saved successfully"), dismissButton: .default(Text("OK")))
        }
        .onAppear {
            // Step 2: Request authorization
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { success, error in
                if success {
                    print("Authorization granted")
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                }
            }
            // Fetch names when the view appears
            fetchNames()
        }
    }
    
    func saveName() {
        let db = Firestore.firestore()
        db.collection("names").addDocument(data: ["name": name]) { error in
            if let error = error {
                print("Error saving Name: \(error)")
            } else {
                print("Name successfully saved")
                self.showAlert = true // Show the alert when name is successfully saved
                
                fetchNames()
            }
        }
    }
    
    func fetchNames() {
        let db = Firestore.firestore()
        db.collection("names").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching names: \(error)")
            } else {
                self.names = snapshot?.documents.compactMap { $0.data()["name"] as? String } ?? []
            }
        }
    }
    
}

// Preview code
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
