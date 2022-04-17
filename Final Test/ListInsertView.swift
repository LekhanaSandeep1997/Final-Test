//
//  ListInsertView.swift
//  Final Test
//
//  Created by Lekhana Sandeep on 2022-04-16.
//

import SwiftUI

struct ListInsertView: View {
    
    @State var price = ""
    @State var firstImage : UIImage?
    @State var secondImage : UIImage?
    @State var thirdImage : UIImage?
    @State var fourthImage : UIImage?
    @State var location = ""
    @State var size = ""
    @State var district = ""
    @State var town = ""
    @State var title = ""
    @State var ShowFirstImagePicker = false
    @State var ShowSecondImagePicker = false
    @State var ShowThirdImagePicker = false
    @State var ShowFourthImagePicker = false
    @State var loginStatusMsg = ""
    @State var imageStatus = ""
    @State var properties = ["Land", "House"]
    @State var selectProperties = ""
    
    @State var linktoImageOne = ""
    @State var linktoImageTwo = ""
    @State var linktoImageThree = ""
    @State var linktoImageFour = ""
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = ListViewModel()
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack(alignment: .center, spacing: 4){
                    HStack{
                        Button {
                            ShowFirstImagePicker.toggle()
                        } label: {
                            VStack{
                                if let firstImage = self.firstImage {
                                    Image(uiImage: firstImage)
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .scaledToFit()
                                        .cornerRadius(8)
                                        
                                }else {
                                    Image(systemName: "photo")
                                        .font(.system(size: 74))
                                        .padding()
                                }
                            }
                        }
                        
                        Button {
                            ShowSecondImagePicker.toggle()
                        } label: {
                            VStack{
                                if let secondImage = self.secondImage {
                                    Image(uiImage: secondImage)
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .scaledToFit()
                                        .cornerRadius(8)
                                }else {
                                    Image(systemName: "photo")
                                        .font(.system(size: 74))
                                        .padding()
                                }
                            }
                        }
                    }
                    HStack{
                        Button {
                            ShowThirdImagePicker.toggle()
                        } label: {
                            VStack{
                                if let thirdImage = self.thirdImage {
                                    Image(uiImage: thirdImage)
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .scaledToFit()
                                        .cornerRadius(8)
                                }else {
                                    Image(systemName: "photo")
                                        .font(.system(size: 74))
                                        .padding()
                                }
                            }
                        }
                        
                        Button {
                            ShowFourthImagePicker.toggle()
                        } label: {
                            VStack{
                                if let fourthImage = self.fourthImage {
                                    Image(uiImage: fourthImage)
                                        .resizable()
                                        .frame(width: 120, height: 120)
                                        .scaledToFit()
                                        .cornerRadius(8)
                                }else {
                                    Image(systemName: "photo")
                                        .font(.system(size: 74))
                                        .padding()
                                }
                            }
                        }
                    }
                Divider()
                Spacer()
                VStack {
                    Group{
                        TextField("Title", text: $title)
                            .padding(12)
                            .background(Color.white)
                            .keyboardType(.numberPad)
                            .frame(width: 380)
                        TextField("Price", text: $price)
                            .padding(12)
                            .background(Color.white)
                            .keyboardType(.numberPad)
                            .frame(width: 380)
                        Picker(selection: $selectProperties, label: TextField("Property", text: $selectProperties)) {
                            ForEach(properties, id: \.self) { properties in
                                Text(properties).tag(properties)
                            }
                        }
                            .frame(width: 380, height: 40)
                            .background(.white)
                            .foregroundColor(Color.green)
                            .pickerStyle(MenuPickerStyle())
                        TextField("Land Size", text: $size)
                            .padding(12)
                            .background(Color.white)
                            .keyboardType(.numberPad)
                            .frame(width: 380)
                        TextField("District", text: $district)
                            .padding(12)
                            .background(Color.white)
                            .frame(width: 380)
                        TextField("Town", text: $town)
                            .padding(12)
                            .frame(width: 380)
                            .background(Color.white)
                            .keyboardType(.numberPad)
                        TextField("Location", text: $location)
                            .padding(12)
                            .frame(width: 380)
                            .background(Color.white)
                            .keyboardType(.numberPad)
                    }
                    
                        Button {
                            persistImageOne()
                        } label: {
                            HStack {
                                Spacer()
                                Text("Add")
                                    .foregroundColor(.white)
                                    .padding(.vertical, 12)
                                Spacer()
                            }
                            .background(Color.green)
                            .frame(width: 350, height: 80)
                        }
                        .alert(isPresented: $vm.showPopup) {
                            Alert(title: Text(vm.storeSuccessMessage))
                        }
                    }
                    .font(.system(size: 18))
                }
                    
            }.navigationBarTitle("Lets Add Post Here!")
                .background(Color(.init(white: 0, alpha: 0.05))
                                .ignoresSafeArea())
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarLeading){
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                    }
                }
        }
        .fullScreenCover(isPresented: $ShowFirstImagePicker, onDismiss: nil) {
            ImagePicker(image: $firstImage)
        }
        .fullScreenCover(isPresented: $ShowSecondImagePicker, onDismiss: nil) {
            ImagePicker(image: $secondImage)
        }
        .fullScreenCover(isPresented: $ShowThirdImagePicker, onDismiss: nil) {
            ImagePicker(image: $thirdImage)
        }
        .fullScreenCover(isPresented: $ShowFourthImagePicker, onDismiss: nil) {
            ImagePicker(image: $fourthImage)
        }
    }
    
    func persistImageOne() {
        let first = UUID().uuidString
        
        let ref = FirebaseManager.shared.storage.reference(withPath: first)
        guard let imageData = firstImage?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil){ metadata, err in
            if let err = err {
                self.loginStatusMsg = "Failed to push image to Storage \(err)"
                return
            }
            ref.downloadURL{url, err in
                if let err = err {
                    self.loginStatusMsg = "Failed to Retrive downloadURL: \(err)"
                    return
                }
                self.loginStatusMsg = "Successfully stored image with URL: \(url?.absoluteString ?? "")"
                
                guard let url = url else { return }
                self.linktoImageOne = url.absoluteString
                persistImageTwo()
            }
        }
    }
    
    func persistImageTwo() {
        let second = UUID().uuidString
        let ref = FirebaseManager.shared.storage.reference(withPath: second)
        guard let imageData = secondImage?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil){ metadata, err in
            if let err = err {
                self.loginStatusMsg = "Failed to push image to Storage \(err)"
                return
            }
            ref.downloadURL{url, err in
                if let err = err {
                    self.loginStatusMsg = "Failed to Retrive downloadURL: \(err)"
                    return
                }
                self.loginStatusMsg = "Successfully stored image with URL: \(url?.absoluteString ?? "")"
                
                guard let url = url else { return }
                self.linktoImageTwo = url.absoluteString
                persistImageThree()
            }
        }
    }
    func persistImageThree() {
        let third = UUID().uuidString
        let ref = FirebaseManager.shared.storage.reference(withPath: third)
        guard let imageData = thirdImage?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil){ metadata, err in
            if let err = err {
                self.loginStatusMsg = "Failed to push image to Storage \(err)"
                return
            }
            ref.downloadURL{url, err in
                if let err = err {
                    self.loginStatusMsg = "Failed to Retrive downloadURL: \(err)"
                    return
                }
                self.loginStatusMsg = "Successfully stored image with URL: \(url?.absoluteString ?? "")"
                
                guard let url = url else { return }
                self.linktoImageThree = url.absoluteString
                persistImageFour()
            }
        }
    }
    
    func persistImageFour() {
        let fourth = UUID().uuidString
        let ref = FirebaseManager.shared.storage.reference(withPath: fourth)
        guard let imageData = fourthImage?.jpegData(compressionQuality: 0.5) else { return }
        ref.putData(imageData, metadata: nil){ metadata, err in
            if let err = err {
                self.loginStatusMsg = "Failed to push image to Storage \(err)"
                return
            }
            ref.downloadURL{url, err in
                if let err = err {
                    self.loginStatusMsg = "Failed to Retrive downloadURL: \(err)"
                    return
                }
                self.loginStatusMsg = "Successfully stored image with URL: \(url?.absoluteString ?? "")"
                
                guard let url = url else { return }
                self.linktoImageFour = url.absoluteString
                vm.insertSalesData(title: title, firstImage: linktoImageOne, secondImage: linktoImageTwo, thirdImage: linktoImageThree, fourthImage: linktoImageFour, location: location, land: selectProperties, size: size, district: district, town: town)
            }
        }
    }
}

struct ListInsertView_Previews: PreviewProvider {
    static var previews: some View {
        ListInsertView()
    }
}
