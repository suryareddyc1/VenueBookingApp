//
//  EditBookingView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI

struct EditBookingView: View {
    @EnvironmentObject var viewModel: BookingViewModel
    @ObservedObject var booking: BookingEntity
    @Binding var isPresented: Bool

    @State private var name: String = ""
    @State private var mobile: String = ""
    @State private var date: Date = Date()
    @State private var eventType: String = ""

    @State private var showAlert = false
    @State private var alertMessage = ""

    let eventTypes = ["Birthday", "Marriage", "Gathering", "Casual Party"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customer Info")) {
                    TextField("Customer Name", text: $name)
                    TextField("Mobile Number", text: $mobile)
                        .keyboardType(.numberPad)
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

                Button("Save Changes") {
                    if validate() {
                        booking.customerName = name
                        booking.mobileNumber = mobile
                        booking.eventDate = date
                        booking.eventType = eventType
                        viewModel.save()
                        isPresented = false
                    }
                }
            }
            .navigationTitle("Edit Booking")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .alert("Error", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                name = booking.customerName ?? ""
                mobile = booking.mobileNumber ?? ""
                date = booking.eventDate ?? Date()
                eventType = booking.eventType ?? ""
            }
        }
    }

    func validate() -> Bool {
        guard name.trimmingCharacters(in: .whitespaces).count > 1 else {
            alertMessage = "Name must not be empty."
            showAlert = true
            return false
        }
        guard mobile.count == 10, CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: mobile)) else {
            alertMessage = "Mobile number must be exactly 10 digits."
            showAlert = true
            return false
        }
        guard date >= Calendar.current.startOfDay(for: Date()) else {
            alertMessage = "Event date cannot be in the past."
            showAlert = true
            return false
        }
        guard !eventType.isEmpty else {
            alertMessage = "Please select an event type."
            showAlert = true
            return false
        }
        return true
    }
}
