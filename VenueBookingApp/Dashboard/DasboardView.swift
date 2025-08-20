//
//  DasboardView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI
import UIKit

struct DashboardView: View {
    @EnvironmentObject var viewModel: BookingViewModel
    @State private var editingBooking: BookingEntity?
    @State private var isEditing = false

    @State private var bookingToDelete: BookingEntity?
    @State private var showDeleteConfirmation = false

    @State private var shareBooking: BookingEntity?
    @State private var showShareSheet = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.upcomingBookings, id: \.id) { booking in
                    VStack(alignment: .leading, spacing: 8) {
                        bookingRow(label: "Customer", value: booking.customerName ?? "-")
                        bookingRow(label: "Mobile", value: booking.mobileNumber ?? "-")
                        bookingRow(label: "Date", value: formatted(date: booking.eventDate ?? Date()))
                        bookingRow(label: "Event Type", value: booking.eventType ?? "-")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            bookingToDelete = booking
                            showDeleteConfirmation = true
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            if let number = booking.mobileNumber,
                               let url = URL(string: "tel://\(number)"),
                               UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url)
                            }
                        } label: {
                            Label("Call", systemImage: "phone")
                        }
                        .tint(.blue)

                        
                    }
                }
            }
            .navigationTitle("Upcoming Bookings")
            .sheet(isPresented: $isEditing) {
                if let booking = editingBooking {
                    EditBookingView(booking: booking, isPresented: $isEditing)
                        .environmentObject(viewModel)
                }
            }
            
            .alert("Confirm Delete", isPresented: $showDeleteConfirmation, presenting: bookingToDelete) { booking in
                Button("Delete", role: .destructive) {
                    viewModel.deleteBooking(booking)
                }
                Button("Cancel", role: .cancel) {}
            } message: { booking in
                Text("Are you sure you want to delete booking for \(booking.customerName ?? "-")?")
            }
        }
    }
    
    @ViewBuilder
    func bookingRow(label: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .fontWeight(.semibold)
                .foregroundColor(.secondary)
            Text(value)
                .foregroundColor(.primary)
        }
    }

    func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }

    func generateSummary(for booking: BookingEntity) -> String {
        """
        Booking Summary:
        Name: \(booking.customerName ?? "-")
        Mobile: \(booking.mobileNumber ?? "-")
        Date: \(formatted(date: booking.eventDate ?? Date()))
        Event Type: \(booking.eventType ?? "-")
        """
    }
}



struct ShareSheet: UIViewControllerRepresentable {
    var activityItems: [Any]
    var applicationActivities: [UIActivity]? = nil

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
