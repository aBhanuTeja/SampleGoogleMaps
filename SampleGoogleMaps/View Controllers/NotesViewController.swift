//
//  NotesViewController.swift
//  SampleGoogleMaps
//
//  Created by Bhanuteja on 05/08/22.
//

import UIKit


protocol SaveNotesDelegate: AnyObject {
    func saveAddress(notes: String)
}

class NotesViewController: UIViewController {
    
    @IBOutlet weak var notesTV: UITextView!
    weak var saveAddressDataDelegate: SaveNotesDelegate?
    var addressesData: AddressesData?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func addNotesBtnTap(_ sender: Any) {
        _ = self.navigationController?.popViewController(animated: false)
        self.saveAddressDataDelegate?.saveAddress(notes: notesTV.text!)
    }
}


/*
class PopUpWindow: UIViewController {

    private let popUpWindowView = PopUpWindowView()
    
    init(textFieldText: () -> Void) {
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
        popUpWindowView.popupButton.addTarget(self, action: #selector(dismissView), for: .touchUpInside)
        view = popUpWindowView
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }
}

private class PopUpWindowView: UIView {
    
    let popupView = UIView(frame: CGRect.zero)
    let popupButton = UIButton(frame: CGRect.zero)
    let popupTextField = UITextView()
    let BorderWidth: CGFloat = 2.0
    
    init() {
        super.init(frame: CGRect.zero)
        // Semi-transparent background
        backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        // Popup Background
        popupView.backgroundColor = .white
        popupView.layer.borderWidth = BorderWidth
        popupView.layer.masksToBounds = true
        popupView.layer.borderColor = UIColor.white.cgColor
                
        // Popup Text

        popupTextField.text = "Type something..."

        // Popup Button
        popupButton.setTitleColor(UIColor.white, for: .normal)
        popupButton.titleLabel?.font = UIFont.systemFont(ofSize: 23.0, weight: .bold)
        popupButton.backgroundColor = .orange.withAlphaComponent(0.5)
        popupButton.setTitle("OK", for: .normal)

        popupView.addSubview(popupTextField)
        popupView.addSubview(popupButton)
        
        // Add the popupView(box) in the PopUpWindowView (semi-transparent background)
        addSubview(popupView)
        
        
        // PopupView constraints
        popupView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupView.widthAnchor.constraint(equalToConstant: 293),
            popupView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            popupView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
            ])
        
        // PopupText constraints
        popupTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupTextField.heightAnchor.constraint(greaterThanOrEqualToConstant: 67),
            popupTextField.topAnchor.constraint(equalTo: popupView.topAnchor, constant: 15),
            popupTextField.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: 15),
            popupTextField.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -15),
            popupTextField.bottomAnchor.constraint(equalTo: popupButton.topAnchor, constant: -15)
            ])

        
        // PopupButton constraints
        popupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            popupButton.heightAnchor.constraint(equalToConstant: 44),
            popupButton.leadingAnchor.constraint(equalTo: popupView.leadingAnchor, constant: BorderWidth),
            popupButton.trailingAnchor.constraint(equalTo: popupView.trailingAnchor, constant: -BorderWidth),
            popupButton.bottomAnchor.constraint(equalTo: popupView.bottomAnchor, constant: -BorderWidth)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
*/

