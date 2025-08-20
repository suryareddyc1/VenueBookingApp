//
//  BookiViewModel.swift
//  VenueBookingApp
//
//  Created by Surya Vummadi on 19/06/25.
//

import Foundation
import CoreData

class BookingViewModel: ObservableObject {
    @Published var bookings: [BookingEntity] = []

    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchBookings()
    }

    func fetchBookings() {
        let request: NSFetchRequest<BookingEntity> = BookingEntity.fetchRequest()
        do {
            bookings = try context.fetch(request)
        } catch {
            print("Fetch error: \(error)")
        }
    }

    func isDateAvailable(_ date: Date) -> Bool {
        !bookings.contains {
            Calendar.current.isDate($0.eventDate ?? Date.distantPast, inSameDayAs: date)
        }
    }

    func addBooking(customerName: String, mobileNumber: String, eventDate: Date, eventType: String) {
        let newBooking = BookingEntity(context: context)
        newBooking.id = UUID()
        newBooking.customerName = customerName
        newBooking.mobileNumber = mobileNumber
        newBooking.eventDate = eventDate
        newBooking.eventType = eventType
        save()
    }
    
    func updateBooking(_ booking: BookingEntity, completion: @escaping (String?) -> Void) {
        do {
            try booking.managedObjectContext?.save()
            fetchBookings()
            completion(nil)
        } catch {
            completion("Failed to update booking: \(error.localizedDescription)")
        }
    }


    var upcomingBookings: [BookingEntity] {
        bookings.filter {
            ($0.eventDate ?? Date.distantPast) >= Date()
        }.sorted {
            ($0.eventDate ?? Date.distantPast) < ($1.eventDate ?? Date.distantPast)
        }
    }
    
    func deleteAllBookings() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = BookingEntity.fetchRequest()
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
             let context = PersistenceController.shared.container.viewContext
                try context.execute(batchDelete)
                try context.save()
                fetchBookings()
            
        } catch {
            print("Failed to delete all bookings: \(error.localizedDescription)")
        }
    }


     func save() {
        do {
            try context.save()
            fetchBookings()
        } catch {
            print("Save error: \(error)")
        }
    }
    
    func deleteBooking(_ booking: BookingEntity) {
        context.delete(booking)
        save()
    }

}
