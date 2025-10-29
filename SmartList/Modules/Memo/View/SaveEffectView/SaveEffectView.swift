//
//  SaveEffect.swift
//  SmartList
//
//  Created by 川前優太 on 2025/10/29.
//

import UIKit

class SaveEffectView: UIView {

    @IBOutlet var view: UIView!
    @IBOutlet weak var saveImageView: UIImageView!
    @IBOutlet weak var saveLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
        saveImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        saveImageView.center = CGPoint(x: 115, y: 100)
        
        saveLabel.frame = CGRect(x: 0, y: 0, width: 230, height: 50)
        saveLabel.center = CGPoint(x: 115, y: 200)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadNib()
        saveImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        saveImageView.center = CGPoint(x: 115, y: 100)
        
        saveLabel.frame = CGRect(x: 0, y: 0, width: 230, height: 50)
        saveLabel.center = CGPoint(x: 115, y: 200)
    }
    
    func loadNib() {
        Bundle.main.loadNibNamed("\(SaveEffectView.self)", owner: self)
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0)
        ])
    }
}
