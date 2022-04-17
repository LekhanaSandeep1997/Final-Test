//
//  ListViewModel.swift
//  Final Test
//
//  Created by Lekhana Sandeep on 2022-04-15.
//

import Foundation
import UIKit
import Firebase
import SwiftUI

struct DataModel {
    let uid, name: String
    
    init(data: [String: Any]){
        self.uid = data["uid"] as? String ?? ""
        self.name = data["name"] as? String ?? ""
    }
}

class ListViewModel: ObservableObject {
    
    @Published var errorMsg = ""
    @Published var dataModel: DataModel?
    @Published var isUserCurrentlyLoggedOut = false
    @Published var firstURL = ""
    @Published var imageStatus = ""
    @Published var storeSuccessMessage = ""
    @Published var showPopup = false
    
    init() {
        
        DispatchQueue.main.async{
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        
        fetchCurrentUser()
        
    }
    
    private func fetchCurrentUser() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            self.errorMsg = "Could not find Firebase uid"
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                self.errorMsg = "Failed to fetch current user: \(error)"
                print("Failed to fetch current user: ", error)
                return
            }
            
            guard let data = snapshot?.data() else {
                self.errorMsg = "No data Found"
                return
            }
            
            self.dataModel = .init(data: data)
        }
    }
    
    func handleSignOut() {
        isUserCurrentlyLoggedOut.toggle()
        try? FirebaseManager.shared.auth.signOut()
    }
    
    
    
    func insertSalesData(title: String, firstImage: String, secondImage: String, thirdImage: String, fourthImage: String, location: String, land: String, size: String, district: String, town: String){
        
        if firstImage == "" {
            self.imageStatus = "You must select an avatar image"
            return
        }
        
        let salesID = UUID().uuidString
        
        
        let salesData = [
            "title" : title,
            "firstImage": firstImage,
            "secondImage": secondImage,
            "thirdImage": thirdImage,
            "fourthImage": fourthImage,
            "location": location,
            "land": land,
            "size": size,
            "district": district,
            "town": town
        ] as [String : Any]
        
        FirebaseManager.shared.firestore.collection("sales")
            .document(salesID).setData(salesData) { [self] err in
                if let err = err {
                    print(err)
                    print("Failed to insert data: \(err)")
                    self.imageStatus = "\(err)"
                    self.showPopup.toggle()
                    return
                }
                print("Success")
            }
        }
    }

