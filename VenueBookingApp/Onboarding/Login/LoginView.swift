//
//  LoginView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Banquet Hall Login")
                .font(.largeTitle)
            TextField("Username", text: $username)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Button("Login") {
                // Dummy login validation
                if !username.isEmpty && !password.isEmpty {
                    isLoggedIn = true
                }
            }
            .padding()
        }
        .padding()
    }
}
