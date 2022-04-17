//
//  Model.swift
//  Final Test
//
//  Created by Lekhana Sandeep on 2022-04-14.
//

import Foundation


class User: Identifiable {
    
    let nic: String
    let name: String
    let mobile: String
    let email: String
    let password: String
    let retype: String
    let location: String
    let gender: String
    let dob: Date
    

    init(nic: String, name: String, mobile: String, email: String, password: String, retype: String, location: String, address: String, dob: Date, gender: String){
        self.nic = nic
        self.name = name
        self.mobile = mobile
        self.email = email
        self.password = password
        self.retype = retype
        self.gender = gender
        self.dob = dob
        self.location = location
    }
}
