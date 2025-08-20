//
//  EstimateCostView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI

struct EstimateEventView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: EstimationSettings.entity(),
        sortDescriptors: []
    ) private var settings: FetchedResults<EstimationSettings>

    @State private var foodType = "Veg"
    @State private var numberOfPlates = ""
    @State private var eventDate = Date()
    @State private var totalEstimate: Double?

    var body: some View {
        Form {
            Section(header: Text("Event Requirements")) {
                Picker("Food Type", selection: $foodType) {
                    Text("Veg").tag("Veg")
                    Text("Non-Veg").tag("Non-Veg")
                }
                .pickerStyle(SegmentedPickerStyle())

                TextField("Number of Plates", text: $numberOfPlates)
                    .keyboardType(.numberPad)

                DatePicker("Event Date", selection: $eventDate, displayedComponents: .date)
            }

            if let total = totalEstimate {
                Section(header: Text("Estimated Cost")) {
                    Text("₹ \(Int(total))")
                        .font(.title)
                }
            }

            Button("Estimate Cost") {
                estimateCost()
            }
        }
        .navigationTitle("Estimate Event")
    }

    func estimateCost() {
        guard let setting = settings.first else { return }
        guard let plates = Int(numberOfPlates) else { return }

        let isWeekend = Calendar.current.isDateInWeekend(eventDate)
        let baseCharge = isWeekend ? setting.weekendCharge : setting.weekdayCharge
        let foodCost = (foodType == "Veg") ? setting.vegCost : setting.nonVegCost

        totalEstimate = Double(plates) * foodCost + baseCharge
    }
}

