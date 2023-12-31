//
//  AboutUsFeedbackViewController.swift
//  Barber Shop
//
//  Created by Borinschi Ivan on 18.12.2020.
//

import UIKit
import DSKit
import DSKitFakery

class AboutUsFeedbackViewController: DSViewController {
    
    // Random data generator, an wrapper around https://github.com/vadymmarkov/Fakery
    let faker = DSFaker()
    
    var rating = 5
    var feedback: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBarShadow()
        update()
    }
    
    func update() {
        
        let button = DSButtonVM(title: "Отправить") { _ in
            self.show(message: "Спасибо за отзыв!", type: .success) {
                self.dismiss()
            }
        }
        
        let cancel = DSButtonVM(title: "Закрыть", type: .link) { _ in
            self.dismiss()
        }
        
        show(content: specialistDetailsSection(),
                      textViewSection(),
                      ratingSection(),
                      [button, cancel].list())
    }
    
    func specialistDetailsSection() -> DSSection {
        
        // Title
        let title = DSLabelVM(.title1, text: "Обратная связь")
        return [title].list()
    }
    
    /// Text view section
    /// - Returns: DSSection
    func textViewSection() -> DSSection {
        
        let textView = DSTextViewVM(text: feedback)
        
        // Handle this did update
        textView.didUpdate = { vm in
            self.feedback = vm.text
        }
        textView.height = .absolute(150)
        
        return [textView].list().subheadlineHeader("Напишите ваш отзыв")
    }
    
    /// Rating section
    /// - Returns: DSSection
    func ratingSection() -> DSSection {
        
        var ratingViewModels = [DSViewModel]()
        
        for r in 1...5 {
            var model = starViewModel(fill: r <= rating)
            model.object = r as AnyObject
            ratingViewModels.append(model)
        }
        
        ratingViewModels = ratingViewModels.didTap({ (action :DSActionVM) in
            
            guard let newRating = action.object as? Int else {
                return
            }
            
            self.rating = newRating
            self.update()
        })
        
        return ratingViewModels.gallery().subheadlineHeader("Оцените наш сервис")
    }
    
    /// Star view model
    /// - Parameter fill: Is star filled or not
    /// - Returns: Bool
    func starViewModel(fill: Bool) -> DSActionVM {
        
        let brandColor = UIColor.systemYellow
        let composer = DSTextComposer()
        
        if fill {
            composer.add(sfSymbol: "star.fill", style: .medium, tint: .custom(brandColor))
        } else {
            composer.add(sfSymbol: "star", style: .medium, tint: .subheadline)
        }
        
        var action = composer.actionViewModel()
        action.style.displayStyle = .default
        action.width = .absolute(30)
        action.height = .absolute(30)
        return action
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
