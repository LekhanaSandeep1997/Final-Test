//
//  LoginView.swift
//  Final Test
//
//  Created by Lekhana Sandeep on 2022-04-14.
//

import SwiftUI

struct LoginView: View {
    
    let loginSuccessed: () -> ()
    
    @State var isLogMode = false
    @State var email = ""
    @State var password = ""
    @State var nic = ""
    @State var name = ""
    @State var mobile = ""
    @State var retype = ""
    @State var location = ""
    @State var gender = ["Male", "Female"]
    @State var selectGender = ""
    @State private var selectDob = Date()
    @State var loginStatusMessage = ""
    @State var image: UIImage?
    
    @ObservedObject var vm = ViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView{
                VStack(spacing: 16){
                    Picker(selection: $isLogMode, label: Text("picker Here")) {
                        Text("Login")
                            .tag(true)
                        Text("Create Account")
                            .tag(false)
                    }
                        .background(Color.green)
                        .pickerStyle(SegmentedPickerStyle())
                        .padding()
                    
                    
                    if !isLogMode {
                        //Create Account
                        Group {
                            TextField("NIC", text: $nic)
                                .padding(12)
                                .background(Color.white)
                            TextField("Name", text: $name)
                                .padding(12)
                                .background(Color.white)
                                .disableAutocorrection(true)
                            TextField("Mobile", text: $mobile)
                                .padding(12)
                                .background(Color.white)
                                .keyboardType(.numberPad)
                            DatePicker("Date Of Birth", selection: $selectDob, in: ...Date(), displayedComponents: .date)
                                .frame(width: 350, height: 40)
                                .padding()
                                
                            Picker(selection: $selectGender, label: TextField("Gender", text: $selectGender)) {
                                ForEach(gender, id: \.self) { gender in
                                    Text(gender).tag(gender)
                                }
                            }
                                .frame(width: 380, height: 40)
                                .background(.white)
                                .foregroundColor(Color.green)
                                .pickerStyle(MenuPickerStyle())

                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(12)
                                .background(Color.white)
                                .disableAutocorrection(true)
                            SecureField("Password", text: $password)
                                .padding(12)
                                .background(Color.white)
                                .disableAutocorrection(true)

                            TextField("Location", text: $location)
                                .autocapitalization(.none)
                                .padding(12)
                                .background(Color.white)
                                .disableAutocorrection(true)
                        }
                    }
                    else{
                        //Login
                        Group {
                            TextField("Email", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(12)
                                .background(Color.white)
                            SecureField("Password", text: $password)
                                .padding(12)
                                .background(Color.white)
                        }
                    
                    }
                    
                    
                    Button {
                        if isLogMode {
                            vm.loginUser(email: email, password: password)
                        } else {
                            vm.createNewAccount(nic: nic, name: name, mobile: mobile, email: email, password: password, dob: selectDob, location: location, gender: selectGender)
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Text(isLogMode ? "Login" : "Create Account")
                                .foregroundColor(.white)
                                .padding(.vertical, 12)
                            Spacer()
                        }.background(Color.green)
                    }
                    .alert(isPresented: $vm.showPopup) {
                        Alert(title: Text(vm.loginStatusMessage))
                    }
                    .fullScreenCover(isPresented: $vm.isLogged) {
                        ListView(loginCorrectly: {})
                    }
                }.padding()
            }
            .navigationBarTitle(isLogMode ? "Login" : "Create Account")
            .background(Color(.init(white: 0, alpha: 0.05))
                            .ignoresSafeArea())
        }
        
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(loginSuccessed: {})
    }
}
