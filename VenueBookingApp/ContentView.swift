//
//  ContentView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 03/06/25.
//

import SwiftUI
import CoreData
import Foundation

struct ContentView: View {
    @Environment(\.managedObjectContext) private var context
    @State private var isLoggedIn = true
    @State private var selectedTab = 0
    
    var body: some View {
        if isLoggedIn {
            let viewModel = BookingViewModel(context: context)
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tabItem { Label("Home", systemImage: "house.fill") }
                    .tag(0)

                SearchAvailabilityView()
                    .tabItem { Label("Availability", systemImage: "magnifyingglass") }
                    .tag(1)

                NavigationView {
                    CreateBookingView(selectedTab: $selectedTab)
                }
                .tabItem { Label("Add Booking", systemImage: "person.badge.plus") }
                .tag(2)
                
                SettingsView()
                    .tabItem { Label("More", systemImage: "ellipsis") }
                    .tag(3)
            }
            .environmentObject(viewModel)
        } else {
            LoginView(isLoggedIn: $isLoggedIn)
        }
    }
}
