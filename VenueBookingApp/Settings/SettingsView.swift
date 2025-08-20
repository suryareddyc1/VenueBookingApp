//
//  SettingsView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var viewModel: BookingViewModel
    @State private var showConfirmation = false

    var body: some View {
        NavigationView {
            Form {
//                Section(header: Text("Estimation")) {
//                    NavigationLink(destination: EstimateEventView()) {
//                        Text("Estimate Event Cost")
//                    }
//                }
//                
                Section(header: Text("Data")) {
                    NavigationLink("Charts") {
                        ChartsView()
                    }
                }
                
                
                Section(header: Text("Data Management")) {
                    Button("Remove All Bookings", role: .destructive) {
                        showConfirmation = true
                    }
                }

            }
            .navigationTitle("Settings")
            .alert("Confirm Deletion", isPresented: $showConfirmation) {
                Button("Delete All", role: .destructive) {
                    viewModel.deleteAllBookings()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Are you sure you want to delete all bookings? This action cannot be undone.")
            }
        }
    }
}

