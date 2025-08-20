//
//  SearchAvailabilityView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI

struct SearchAvailabilityView: View {
    @EnvironmentObject var viewModel: BookingViewModel
    @State private var selectedDate = Date()
    @State private var available: Bool?
    @State private var selectedBooking: BookingEntity?
    @State private var showDetails = false

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                DatePicker("Select Date", selection: $selectedDate, displayedComponents: .date)
                    .datePickerStyle(.graphical)

                Button("Check Availability") {
                    if let booking = viewModel.bookings.first(where: {
                        Calendar.current.isDate($0.eventDate ?? Date.distantPast, inSameDayAs: selectedDate)
                    }) {
                        available = false
                        selectedBooking = booking
                    } else {
                        available = true
                        selectedBooking = nil
                    }
                }

                if let available = available {
                    if available {
                        Text("✅ Available")
                            .font(.headline)
                            .foregroundColor(.green)
                    } else {
                        Text("❌ Not Available")
                            .font(.headline)
                            .foregroundColor(.red)

                        Button("View Booking Details") {
                            showDetails = true
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .sheet(isPresented: $showDetails) {
                            if let booking = selectedBooking {
                                BookingDetailsView(booking: booking)
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Check Date")
        }
    }
}
