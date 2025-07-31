//
//  colorController.swift
//  color-generation
//
//  Created by Gungun Bali on 31/07/25.
//


import UIKit

class ColorController: UIViewController {
    var colorHex = "#FFFFFF"
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = hexStringToUIColor(colorHex) // Just to visually differentiate
        let backButton = UIButton(type: .system)
            backButton.setTitle("Back", for: .normal)
            backButton.tintColor = .white
            backButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            backButton.frame = CGRect(x: 20, y: 60, width: 60, height: 30)
            backButton.addTarget(self, action: #selector(dismissSelf), for: .touchUpInside)
            view.addSubview(backButton)
    }
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    func hexStringToUIColor(_ hex:String)->UIColor{
        var cString = hex.trimmingCharacters(in:.whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#"){
            cString.removeFirst()
        }
        if(cString.count != 6){
            return UIColor.gray
        }
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8)/255.0,
            blue: CGFloat(rgbValue & 0x0000FF)/255.0,
            alpha: 1.0
        )
    }
}
