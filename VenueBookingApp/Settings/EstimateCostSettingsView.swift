//
//  EstimateCostSettingsView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI

struct EstimateCostSettingsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: EstimationSettings.entity(),
        sortDescriptors: []
    ) private var settings: FetchedResults<EstimationSettings>

    @State private var vegCost = ""
    @State private var nonVegCost = ""
    @State private var weekendCharge = ""
    @State private var weekdayCharge = ""

    var body: some View {
        Form {
            Section(header: Text("Per Plate Cost")) {
                TextField("Veg Cost", text: $vegCost).keyboardType(.numberPad)
                TextField("Non-Veg Cost", text: $nonVegCost).keyboardType(.numberPad)
            }

            Section(header: Text("Event Charge")) {
                TextField("Weekend Charge", text: $weekendCharge).keyboardType(.numberPad)
                TextField("Weekday Charge", text: $weekdayCharge).keyboardType(.numberPad)
            }

            Button("Save Settings") {
                saveSettings()
            }
        }
        .navigationTitle("Cost Settings")
        .onAppear {
            if let setting = settings.first {
                vegCost = String(setting.vegCost)
                nonVegCost = String(setting.nonVegCost)
                weekendCharge = String(setting.weekendCharge)
                weekdayCharge = String(setting.weekdayCharge)
            }
        }
    }

    private func saveSettings() {
        let setting = settings.first ?? EstimationSettings(context: viewContext)
        setting.vegCost = Double(vegCost) ?? 0
        setting.nonVegCost = Double(nonVegCost) ?? 0
        setting.weekendCharge = Double(weekendCharge) ?? 0
        setting.weekdayCharge = Double(weekdayCharge) ?? 0

        try? viewContext.save()
    }
}
