//
//  BookingManager.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 18.12.2020.
// Здесь находится модель каталога услуг и акций

import Foundation
import DSKit
import DSKitFakery

class BookingManager {
    
    // Simulate user authorization - симулируем авторищацию пользователя
    public var authorized: Bool = false
    
    // Selected specialist for booking - выбор барбера
    public var selectedSpecialist: DSPerson?
    
    
    // Selected services - Выбор услуги
    public var services = [Service]()
    
    // Selected date and time - выбор даты и времени
    public var dateAndTime: Date?
    
    // Is current booking valid - проверка заполнения всех данных
    func isValidBooking() -> Bool {
        return selectedSpecialist != nil && !services.isEmpty && dateAndTime != nil
    }
    
    // Shared instance - Экземпляр класса
    static let shared = BookingManager()
    
    public init() {}
    
    func reset() {
        selectedSpecialist = nil
        dateAndTime = nil
        services.removeAll()
    }
}

extension BookingManager {
    
    static func getPromotionsServices() -> [Service] {
        
        [
            Service(id: 1, title: "День рождения", duration: "1 час", amount: 1000, regularAmount: 2000, currency: "₽", picture: URL.birthdayUrl()),
            Service(id: 2, title: "Первый визит -10 %", duration: "1 час", amount: 1000, regularAmount: 2000,  currency: "₽"),
            Service(id: 3, title: "Отец и сын -15%", duration: "1 час", amount: 1000, regularAmount: 2000,  currency: "₽"),
        ]
    }
    
        // здесь услуги от топ барберов
    static func getProBarberServices() -> [Service] {
        
        [
            Service(id: 4, title: "Стрижка ножницами", duration: "1 час", amount: 1000, currency: "₽"),
            Service(id: 5, title: "Детская стрижка (6 - 10 лет) Pro Барбера", duration: "1 час", amount: 1000, currency: "₽"),
            Service(id: 6, title: "Стрижка бороды", duration: "1 час", amount: 1400, currency: "₽"),
            Service(id: 7, title: "Подкраска бороды", duration: "1 час", amount: 1400, currency: "₽"),
            Service(id: 8, title: "Подбор стиля", duration: "1 час", amount: 2000, currency: "₽"),
            Service(id: 9, title: "Комплексный уход", duration: "1 час", amount: 3000, currency: "₽")
        ]
    }
        // Здесь услуги от обычных барберов
    static func getBarberServices() -> [Service] {
        
        [
            Service(id: 10, title: "Стрижка ножницами", duration: "1 час", amount: 900, currency: "₽"),
            Service(id: 11, title: "Детская стрижка (6 - 10 лет) Pro Барбера", duration: "1 час", amount: 1000, currency: "₽"),
            Service(id: 12, title: "Стрижка бороды", duration: "1 час", amount: 1000, currency: "₽"),
            Service(id: 13, title: "Подкраска бороды", duration: "1 час", amount: 80000, currency: "₽"),
            Service(id: 14, title: "Подбор стиля", duration: "1 час", amount: 1000, currency: "₽"),
            Service(id: 15, title: "Комплексный уход", duration: "1 час", amount: 1000, currency: "₽")
        ]
    }
    
    static func getBarberService() -> Service {
        return BookingManager.getBarberServices()[0]
    }
    
    //Спа услуги
    static func getSpaServices() -> [Service] {
        
        [
            Service(id: 16, title: "Комплекс СПА услуг для лица", duration: "1 час", amount: 1000, currency: ""),
            Service(id: 17, title: "Маникюр", duration: "1 час", amount: 1000, currency: "₽")
        ]
    }
}

