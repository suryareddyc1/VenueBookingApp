//
//  BookingDetailsView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI

struct BookingDetailsView: View {
    var booking: BookingEntity
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customer Info")) {
                    Text("Name: \(booking.customerName ?? "-")")
                    Text("Mobile: \(booking.mobileNumber ?? "-")")
                }

                Section(header: Text("Event Details")) {
                    Text("Type: \(booking.eventType ?? "-")")
                    Text("Date: \(formatted(date: booking.eventDate ?? Date()))")
                }
            }
            .navigationTitle("Booking Details")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}
