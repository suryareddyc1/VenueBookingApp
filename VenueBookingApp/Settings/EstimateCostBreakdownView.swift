//
//  EstimateCostBreakdownView.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import SwiftUI

struct EstimateCostBreakdownView: View {
    var plateCount: Int
    var perPlateCost: Double
    var baseCharge: Double

    var body: some View {
        Form {
            Section(header: Text("Details")) {
                Text("Plates: \(plateCount)")
                Text("Per Plate Cost: ₹\(Int(perPlateCost))")
                Text("Base Charge: ₹\(Int(baseCharge))")
                Text("Total: ₹\(Int(Double(plateCount) * perPlateCost + baseCharge))")
            }
        }
        .navigationTitle("Cost Breakdown")
    }
}
