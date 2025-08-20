//
//  CreateBookingView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI

struct CreateBookingView: View {
    @EnvironmentObject var viewModel: BookingViewModel
    @Binding var selectedTab: Int
    @FocusState private var focusedField: Field?

    @State private var name = ""
    @State private var mobile = ""
    @State private var date = Date()
    @State private var eventType = ""

    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = "Error"
    @State private var showConfirmation = false
    @State private var triggerSuccessNavigation = false

    enum Field {
        case name, mobile
    }

    let eventTypes = ["Birthday", "Marriage", "Gathering", "Casual Party"]

    var isValid: Bool {
        guard name.trimmingCharacters(in: .whitespaces).count > 1 else {
            alertMessage = "Name must not be empty."
            return false
        }

        guard mobile.count == 10, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: mobile)) else {
            alertMessage = "Mobile number must be exactly 10 digits."
            return false
        }

        guard date >= Calendar.current.startOfDay(for: Date()) else {
            alertMessage = "Event date cannot be in the past."
            return false
        }

        guard !eventType.isEmpty else {
            alertMessage = "Please select an event type."
            return false
        }

        return true
    }

    var body: some View {
        Form {
            Section(header: Text("Customer Info")) {
                TextField("Customer Name", text: $name)
                    .focused($focusedField, equals: .name)
                TextField("Mobile Number", text: $mobile)
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .mobile)
            }

            Section(header: Text("Event Details")) {
                DatePicker("Event Date", selection: $date, displayedComponents: .date)
                Picker("Event Type", selection: $eventType) {
                    Text("Select").tag("")
                    ForEach(eventTypes, id: \.self) { type in
                        Text(type).tag(type)
                    }
                }
            }

            Button("Create Booking") {
                if isValid {
                    showConfirmation = true
                } else {
                    alertTitle = "Validation Error"
                    showAlert = true
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")) {
                    if triggerSuccessNavigation {
                        selectedTab = 0 // Go to dashboard
                        triggerSuccessNavigation = false
                    }
                })
            }
            .alert("Confirm Booking", isPresented: $showConfirmation) {
                Button("Confirm", role: .none) {
                    // Save booking
                    viewModel.addBooking(customerName: name, mobileNumber: mobile, eventDate: date, eventType: eventType)

                    // Reset form
                    resetForm()

                    // Dismiss keyboard
                    focusedField = nil

                    // Show success alert & navigate
                    alertTitle = "Success"
                    alertMessage = "Booking created successfully!"
                    triggerSuccessNavigation = true
                    showAlert = true
                }

                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Do you want to confirm the booking for \(name) on \(formatted(date: date))?")
            }
        }
        .navigationTitle("Create Booking")
    }

    private func resetForm() {
        name = ""
        mobile = ""
        date = Date()
        eventType = ""
    }

    private func formatted(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter.string(from: date)
    }
}
