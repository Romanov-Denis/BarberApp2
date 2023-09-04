//
//  SelectHourViewController.swift
//  DSKit
//
//  Created by Borinschi Ivan on 23.12.2020.
//


// Детальный вид времени


import Foundation
import DSKit

class SelectHourViewController: DSViewController {
    
    let date: Date
    var didSelectTime: ((Date) -> Void)?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Час"
        
        // Show available times
        show(content: getAvailableTimes())
    }
    
    init(date: Date) {
        self.date = date
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Times section - выбор времени
extension SelectHourViewController {
    
    /// Generate available times for person
    /// - Parameter person: Person
    /// - Returns: DSSection
    func getAvailableTimes() -> [DSSection] {
        
        var sections = [DSSection]()
        sections.append(getTimeIntervalsSection(startHour: 10, header: "Утро"))
        sections.append(getTimeIntervalsSection(startHour: 13, header: "День"))
        sections.append(getTimeIntervalsSection(startHour: 18, header: "Вечер"))
        return sections
    }
}

// MARK: - Times section - ячейка времени
extension SelectHourViewController {
    
    /// Get time interval section
    /// - Parameter startHour: Int
    /// - Returns: DSSection
    func getTimeIntervalsSection(startHour: Int, header: String) -> DSSection {
        
        var models = [DSViewModel]()
        
        // Randomly generate hours and minutes - случайный час и минута
        for i in 1...Int.random(in: 2...4) {
            
            let hour = startHour + i
            
            // Hour - час
            let timeFixHour = getTimeViewModel(hour: hour, minute: 15)
            
            // Half hour - пол часа
            let timeHalfHour = getTimeViewModel(hour: hour, minute: 30)
            
            models.append(contentsOf: [timeFixHour, timeHalfHour])
        }
        
        // Handle did tap on time
        models = models.didTap { [unowned self] (time: DSLabelVM) in
            guard let date = time.object as? Date else { return }
            self.didSelectTime?(date)
        }
        
        return models.grid(columns: 4).headlineHeader(header)
    }
    
    func getTimeViewModel(hour: Int, minute: Int) -> DSViewModel {
        
        // Style - вид ячейки
        let font = appearance.fonts.headline.withSize(15)
        let color = appearance.secondaryView.text.title1
        
        // Hour - час
        var time = DSLabelVM(.custom(font: font, color: color), text: "\(hour): \(minute)", alignment: .center)
        time.height = .absolute(43)
        time.style.displayStyle = .grouped(inSection: false)
        time.object = Calendar.current.date(bySettingHour: hour, minute: minute, second: 0, of: self.date) as AnyObject
        
        return time
    }
}

// MARK: - Helpers
extension SelectHourViewController {
    
    /// Header section
    /// - Parameter text: String
    /// - Returns: DSSection
    func headerSection(text: String) -> DSSection {
        let morning = DSLabelVM(.title2, text: text)
        return morning.list()
    }
}
