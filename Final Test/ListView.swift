//
//  ListView.swift
//  Final Test
//
//  Created by Lekhana Sandeep on 2022-04-15.
//

import SwiftUI

struct ListView: View {
    
    @State var shouldShowLogOutOptions = false
    @State var shouldShowNewMessageScreen = false
    let loginCorrectly: () -> ()
    
    @ObservedObject var vm = ListViewModel()
    
    var body: some View {
        NavigationView{
            VStack {
                //custom nav bar
                customNavBar
                messageView
                
            }
            .overlay(
                newMessageButton, alignment: .bottom
            )
            .navigationBarHidden(true)
        }
    }
    
    private var customNavBar: some View {
        HStack(spacing: 16) {

            VStack(alignment: .leading, spacing: 4) {
                Text("\(vm.dataModel?.name ?? "")")
                    .font(.system(size: 24, weight: .bold))
            }
            Spacer()
            Button {
                shouldShowLogOutOptions.toggle()
            } label: {
                Image(systemName: "power")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(Color.red)
            }
        }
        .padding()
        .background(Color.green)
        
        .actionSheet(isPresented: $shouldShowLogOutOptions) {
            .init(title: Text("Sign Out"), message: Text("Are you sure want to sign out?"), buttons: [
                .destructive(Text("Sign Out"), action: {
                    print("Handle sign out")
                    vm.handleSignOut()
                }),
                    .cancel()
            ])
        }
        .fullScreenCover(isPresented: $vm.isUserCurrentlyLoggedOut, onDismiss: nil) {
            LoginView(loginSuccessed: {})
        }
    }

    private var messageView: some View {
        ScrollView{
            ForEach(0..<10, id: \.self) { num in
                VStack {
                    HStack(spacing: 16){
                        Image(systemName: "person.fill")
                            .font(.system(size: 32))
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 44).stroke(Color(.label), lineWidth: 1))
                        VStack(alignment: .leading) {
                            Text("Title")
                                .font(.system(size: 16, weight: .bold))
                        }
                        Spacer()
                        
                        Text("22nd")
                            .font(.system(size: 14, weight: .semibold))
                    }
                    Divider()
                        .padding(.vertical, 8)
                }.padding(.horizontal)
            }.padding(.bottom, 50)
        }
    }
    
    private var newMessageButton: some View {
        Button {
            shouldShowNewMessageScreen.toggle()
        } label: {
            HStack{
                Spacer()
                Image(systemName: "plus")
                Text("Add New")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.vertical)
            .background(Color.green)
            .cornerRadius(32)
            .padding(.horizontal)
            .shadow(radius: 5)
        }
        .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
            ListInsertView()
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(loginCorrectly: {})
    }
}
