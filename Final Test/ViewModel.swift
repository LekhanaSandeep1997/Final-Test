//
//  ViewModel.swift
//  Final Test
//
//  Created by Lekhana Sandeep on 2022-04-14.
//

import Foundation
import SwiftUI
import Firebase

class ViewModel: ObservableObject{

    @Published var loginStatusMessage = ""
    @Published var isLogged = false
    @Published var showPopup = false
    
    func loginUser(email: String, password: String) {
        FirebaseManager.shared.auth.signIn(withEmail: email, password: password) { result, err in
            if let err = err {
                print("failed to login", err)
                self.loginStatusMessage = "Failed to login user: \(err)"
                self.showPopup.toggle()
                return
            }
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            self.loginStatusMessage = "Successfully logged as user: \(result?.user.uid ?? "")"
            self.isLogged.toggle()
        }
    }

    func createNewAccount(nic: String, name: String, mobile: String, email: String, password: String, dob: Date, location: String, gender: String) {
        FirebaseManager.shared.auth.createUser(withEmail: email, password: password) {
            result, err in
            if let err = err {
                print("Failed to create user: ", err)
                self.loginStatusMessage = "Failed to create user: \(err)"
                self.showPopup.toggle()
                return
            }
            
            guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
            let userData = [
                "uid": uid,
                "name": name,
                "mobile": mobile,
                "nic": nic,
                "email": email,
                "password": password,
                "dob": dob,
                "location": location,
                "gender": gender] as [String: Any]
            
            FirebaseManager.shared.firestore.collection("users").document(uid).setData(userData) { err in
                if let err = err {
                    print("Successfully created user: \(err)")
                    self.loginStatusMessage = "Successfully created user: \(err)"
                    return
                }
            }
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.loginStatusMessage = "Successfully created user: \(result?.user.uid ?? "")"
            self.isLogged.toggle()
        }
    }
}
