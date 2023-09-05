//
//  ProfileDetailsViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 17.12.2020.
//
// Редактор профиля и личных данных

import UIKit
import DSKit
import DSKitFakery

class ProfileDetailsViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let person = DSFaker().person
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Персональные данные"
        update()
    }
    
    /// Update current content on the screen
    func update() {
        self.show(content: [getProfileDescription(), getPersonalDetailsSection()])
    }
}

// MARK: - Personal details form
extension ProfileDetailsViewController {
    
    /// Get profile description
    /// - Returns: DSSection
    func getProfileDescription() -> DSSection {
        
        // Profile picture
        let picture = DSImageVM(imageUrl: person.image, height: .absolute(100), displayStyle: .circle)
        
        // Profile text
        let text = DSTextComposer(alignment: .center)
        text.add(type: .title1, text: person.name)
        text.add(type: .subheadline, text: person.description)
        text.add(type: .body, text: person.phone, icon: UIImage(systemName: "phone.circle"))
        
        var description = DSActionVM(composer: text)
        description.style.displayStyle = .default
        
        return [picture, description].list()
    }
}

// MARK: - Personal details form - Форма заполнения персональных даннных
extension ProfileDetailsViewController {
    
    /// Personal details form
    /// - Returns: DSSection
    func getPersonalDetailsSection() -> DSSection {
        
        // Full name
        let fullName = DSTextFieldVM.name(placeholder: "Имя")
        fullName.errorPlaceHolderText = "Минимум 3 символа, максиму 35"
        fullName.text = person.name
        fullName.didUpdate = { text in
            print(text.text ?? "Введите имя")
        }
        
        // Email
        let email = DSTextFieldVM.email(placeholder: "Email")
        email.text = person.email
        email.errorPlaceHolderText = "Пример: email@example.com"
        
        // Phone
        let phone = DSTextFieldVM.phone(placeholder: "Номер телефона")
        phone.text = person.phone
        phone.errorPlaceHolderText = "Пример: 7928 111 11 1"
        
        // Update
        var updateButton = DSButtonVM(title: "Обновить")
        
        // Handle did tap on update button
        updateButton.didTap = { [unowned self] model in
            
            // Check if current from present on the screen is valid
            self.isCurrentFormValid { isValid in
                if isValid {
                    self.showSuccessMessage()
                }
            }            
        }
        
        return [fullName, email, phone, updateButton].list()
    }
    
    /// Show success message
    func showSuccessMessage() {
        self.show(message: "Ваш профиль успешно обновлен", type: .success, timeOut: 2) {
            self.popToRoot()
        }
    }
}
