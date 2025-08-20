//
//  ChartsView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 20/06/25.
//


import SwiftUI
import CoreData
import Charts

struct ChartsView: View {
    @FetchRequest(
        entity: BookingEntity.entity(),
        sortDescriptors: []
    ) private var bookings: FetchedResults<BookingEntity>

    @State private var selectedSegment = 0

    var bookingsPerMonth: [String: Int] {
        var result: [String: Int] = [:]
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM yyyy"

        for booking in bookings {
            if let date = booking.eventDate {
                let key = formatter.string(from: date)
                result[key, default: 0] += 1
            }
        }

        return result
    }

    var bookingsByCategory: [String: Int] {
        var result: [String: Int] = [:]
        for booking in bookings {
            if let category = booking.eventType {
                result[category, default: 0] += 1
            }
        }
        return result
    }

    var body: some View {
        VStack(alignment: .leading) {
            Picker("Chart Type", selection: $selectedSegment) {
                Text("By Month").tag(0)
                Text("By Category").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            if selectedSegment == 0 {
                Text("Monthly Bookings")
                    .font(.title2).bold()
                    .padding(.horizontal)

                Chart {
                    ForEach(bookingsPerMonth.sorted(by: { $0.key < $1.key }), id: \ .key) { month, count in
                        BarMark(
                            x: .value("Month", month),
                            y: .value("Bookings", count)
                        )
                    }
                }
                .frame(height: 300)
                .padding()
            } else {
                Text("Bookings by Category")
                    .font(.title2).bold()
                    .padding(.horizontal)

                Chart {
                    ForEach(bookingsByCategory.sorted(by: { $0.key < $1.key }), id: \ .key) { category, count in
                        BarMark(
                            x: .value("Category", category),
                            y: .value("Bookings", count)
                        )
                    }
                }
                .frame(height: 300)
                .padding()
            }
        }
        .navigationTitle("Bookings Chart")
    }
}
