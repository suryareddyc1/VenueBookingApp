//
//  Booking.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import Foundation

struct Booking: Identifiable {
    let id = UUID()
    let customerName: String
    let mobileNumber: String
    let eventDate: Date
    let eventType: String
}
