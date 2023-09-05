//
//  AboutUsViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//

// Вкладки "О нас"

import UIKit
import DSKit
import DSKitFakery

class AboutUsViewController: DSViewController {
    
    enum AboutUsViewControllerSegments: Int {
        case info
        case comments
        case contacts
    }
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    var currentSectionIndex: AboutUsViewControllerSegments = .info
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "О нас"
        update()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func update() {
        
        var sections = [DSSection]()
        
        sections.append(getSwitchSectionsSection())
        
        // Switch between sections and update content
        switch currentSectionIndex {
        case .info:
            sections.append(getInfoHeaderSection())
            sections.append(getInfoGallerySection())
            sections.append(getInfoDescriptionSection())
        case .comments:
            sections.append(getFeedbackSection())
        case .contacts:
            sections.append(getContactsSection())
        }
        
        let space = DSSpaceVM()
        sections.append(space.list())
        self.show(content: sections)
        
        // Switch between sections and update bottom content
        switch currentSectionIndex {
        case .info:
            self.hideBottomContent()
        case .comments:
            let button = DSButtonVM(title: "Оставьте отзыв", icon: DSSFSymbolConfig.buttonIcon("message.fill")) { _ in
                self.present(vc: AboutUsFeedbackViewController(), presentationStyle: .fullScreen)
            }
            self.showBottom(content: [button])
        case .contacts:
            self.hideBottomContent()
        }
    }
}

// MARK: - Info
extension AboutUsViewController {
    
    /// Info header section
    /// - Returns: DSSection
    func getInfoHeaderSection() -> DSSection {
        
        // Title
        let title = DSLabelVM(.title2, text: "Giggles Barbershop")
        
        // Subtitle
        let subtitle = DSLabelVM(.body ,text: " знаменитый барбершоп в Ростове-на-Дону, где мы делаем стиль! Наши мастера стригут со вкусом и чувством стиля. Мы гарантируем безупречный сервис и качественную стрижку.")
        
        return [title, subtitle].list()
    }
    
    /// Info description section
    /// - Returns: DSSection
    func getInfoDescriptionSection() -> DSSection {
        
        let text1 = DSLabelVM(.body ,text: faker.text)
        let text2 = DSLabelVM(.subheadline ,text: faker.text)
        let text3 = DSLabelVM(.body ,text: faker.text)
        
        return [text1, text2, text3].list().zeroTopInset()
    }
    
    /// Gallery section
    /// - Returns: DSSection
    func getInfoGallerySection() -> DSSection {
        
        let urls = [URL.barberShop(index: 3),
                    URL.barberShop(index: 1),
                    URL.barberShop(index: 0),
                    URL.barberShop(index: 2)].compactMap({ $0 })
        
        let pictureModels = urls.map { url -> DSViewModel in
            return DSImageVM(imageUrl: url, height: .absolute(200))
        }
        
        let pageControl = DSPageControlVM(type: .viewModels(pictureModels))
        return pageControl.list().zeroLeftRightInset()
    }
}

// MARK: - Contacts - контактная информация
extension AboutUsViewController {
    
    /// Contacts section
    /// - Returns: DSSection
    func getContactsSection() -> DSSection {
        
        let phone = textRow(title: "Телефон: ", details: faker.phoneNumber, icon: "phone.fill")
        let address = textRow(title: "Адрес: ", details: faker.streetAddress, icon: "map.fill")
        let workingHours = textRow(title: "Часы работы: ", details: "10:00 - 20:00", icon: "calendar.badge.clock")
//        let health = textRow(title: "Здоровье и безопасность: ", details: "Требуется маска · Проверка температуры· Staff wear masks · Staff get temperature checks", icon: "info.circle.fill")
        let map = DSMapVM(coordinate: faker.address.coordinate)
        let button = DSButtonVM(title: "Описание", icon: UIImage(systemName: "map.fill"))
        
        return [phone, address, workingHours, map, button].list()
    }
    
    func textRow(title: String, details: String, icon: String) -> DSActionVM {
        
        let text = DSTextComposer()
        text.add(type: .headline, text: title)
        text.add(type: .subheadline, text: details, newLine: false)
        var row = DSActionVM(composer: text)
        row.leftIcon(sfSymbolName: icon, size: CGSize(width: 18, height: 18))
        row.leftViewPosition = .top
        row.style.displayStyle = .grouped(inSection: false)
        return row
    }
}

// MARK: - Feedback
extension AboutUsViewController {
    
    /// Feedback section
    /// - Returns: DSSection
    func getFeedbackSection() -> DSSection {
        
        let models = [0,1,2,4].map { (index) -> DSViewModel in
            
            // Text
            let text = DSTextComposer()
            text.add(type: .headline, text: faker.name)
            text.add(type: .subheadline, text: Date().stringFormatted(), icon: UIImage(systemName: "calendar"), spacing: 5)
            
            // Rating
            text.add(rating: Int.random(in: 2...5),
                     maximumValue: 5,
                     positiveSymbol: "star.fill",
                     negativeSymbol: "star",
                     style: .custom(size: 15, weight: .medium),
                     tint: .custom(UIColor.systemYellow), spacing: 5)
            
            text.add(type: .callout, text: faker.text)
            
            var action = DSActionVM(composer: text)
            action.style.displayStyle = .grouped(inSection: false)
            return action
        }
        
        return models.list()
    }
}

// MARK: - About Us
extension AboutUsViewController {
    
    /// Switch sections section
    /// - Returns: DSSection
    func getSwitchSectionsSection() -> DSSection {
        
        let segment = DSSegmentVM(segments: ["Информация", "Коментарии", "Контакты"])
        
        segment.didTapOnSegment = { segment in
            self.currentSectionIndex =  AboutUsViewControllerSegments(rawValue: segment.index) ?? .info
            
            // Call update to show changes
            self.update()
        }
        
        return segment.list()
    }
}
