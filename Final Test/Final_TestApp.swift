//
//  Final_TestApp.swift
//  Final Test
//
//  Created by Lekhana Sandeep on 2022-04-14.
//

import SwiftUI
import Firebase

@main
struct Final_TestApp: App {

    var body: some Scene {
        WindowGroup {
            //ContentView()
            LoginView(loginSuccessed: {})
            //ListInsertView()
        }
    }
}

class FirebaseManager: NSObject {
    
    let auth: Auth
    let storage: Storage
    let firestore: Firestore
    
    static let shared = FirebaseManager()
    
    override init(){
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
}
