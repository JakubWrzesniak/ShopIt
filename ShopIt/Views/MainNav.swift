//
//  NavLeft.swift.swift
//  ShopIt
//
//  Created by Jakub Wrześniak on 17/12/2021.
//

import SwiftUI

struct MainNav: View {
    var body: some View {
            VStack(alignment: .leading, spacing: 40){
                NavigationLink(destination: self){
                    Label("Profil", systemImage: "person")
                }
                NavigationLink(destination: self){
                    Label("Zamówienia", systemImage: "bag")
                }
                NavigationLink(destination: self){
                    Label("Pomoc i kontakt", systemImage: "message")
                }
                NavigationLink(destination: self){
                    Label("Ustawienia", systemImage: "gearshape")
                }
                Section(header: Text("Administartion Area")){
                    NavigationLink(destination: {ProductCreation()}){
                        Label("Nowy Produkt", systemImage: "folder")
                    }
                }
                Spacer()
            }
        .padding(.top, 200)
        .padding(.leading, 50)
        .frame(minWidth: 400, maxWidth: .infinity, alignment: .leading)
        .font(.title2)
      //  .shadow(radius: 30)
       // .cornerRadius(40)
        .background(Color(uiColor: UIColor(hex: "bcd8d5") ?? UIColor(.white)))
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainNav__Previews: PreviewProvider {
    static var previews: some View {
        MainNav()
    }
}
