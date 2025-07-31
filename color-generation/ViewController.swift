//
//  ViewController.swift
//  color-generation
//
//  Created by Gungun Bali on 30/07/25.
//

import UIKit
import Network


class ViewController: UIViewController {

    @IBOutlet weak var networkStatusLabel: UILabel!
    //@IBOutlet weak var networkIndicator: UILabel!
    //@IBOutlet weak var networkStatusLabel: UILabel!
    @IBOutlet weak var hexCodeinput: UITextField!
    @IBOutlet weak var colorStackView: UIStackView!

    var generatedHexCode: String?
    var savedColors: [ColorEntry] = []
    let monitor = NWPathMonitor()
    let monitorQueue = DispatchQueue(label: "NetworkMonitor")


    override func viewDidLoad() {
        super.viewDidLoad()
        loadColorsFromUserDefaults()
        startNetworkMonitoring()
    }

    @IBAction func addCodeButton(_ sender: Any) {
        guard let input = hexCodeinput.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !input.isEmpty else {
            showAlert(message: "Please enter a hex code.")
            return
        }

        let hexPattern = "^#?[0-9A-Fa-f]{6}$"
        let regex = try! NSRegularExpression(pattern: hexPattern)
        let range = NSRange(location: 0, length: input.utf16.count)

        if regex.firstMatch(in: input, options: [], range: range) == nil {
            showAlert(message: "Invalid hex code format. Use #RRGGBB.")
            return
        }

        var hex = input
        if !hex.hasPrefix("#") {
            hex = "#" + hex
        }

        let timestamp = getCurrentTimestamp()
        addColorCard(hex: hex, timestamp: timestamp)
        savedColors.append(ColorEntry(hexCode: hex, timestamp: timestamp))
        saveColorsToUserDefaults()

        generatedHexCode = hex.uppercased()
        performSegue(withIdentifier: "goToResults", sender: self)
    }
    

    @IBAction func generateHexcode(_ sender: UIButton) {
        let red = Int.random(in: 0...255)
        let green = Int.random(in: 0...255)
        let blue = Int.random(in: 0...255)

        let hexCode = String(format: "#%02X%02X%02X", red, green, blue)
        let timestamp = getCurrentTimestamp()

        addColorCard(hex: hexCode, timestamp: timestamp)
        savedColors.append(ColorEntry(hexCode: hexCode, timestamp: timestamp))
        saveColorsToUserDefaults()

        generatedHexCode = hexCode
        performSegue(withIdentifier: "goToResults", sender: self)
    }
    func startNetworkMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self?.networkStatusLabel.text = "Online"
                    self?.networkStatusLabel.textColor = .systemGreen
                } else {
                    self?.networkStatusLabel.text = "Offline"
                    self?.networkStatusLabel.textColor = .systemRed
                }
            }
        }
        monitor.start(queue: monitorQueue)
    }


    func addColorCard(hex: String, timestamp: String) {
        // Convert hex to UIColor
        let scanner = Scanner(string: String(hex.dropFirst()))
        var hexNumber: UInt64 = 0
        guard scanner.scanHexInt64(&hexNumber) else { return }

        let r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(hexNumber & 0x0000FF) / 255.0

        let cardView = UIView()
        cardView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        cardView.layer.cornerRadius = 12
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardView.heightAnchor.constraint(equalToConstant: 100)
        ])

        // Labels
        let hexLabel = UILabel()
        hexLabel.text = hex.uppercased()
        hexLabel.textColor = .white
        hexLabel.textAlignment = .center
        hexLabel.font = UIFont.boldSystemFont(ofSize: 18)

        let timeLabel = UILabel()
        timeLabel.text = timestamp
        timeLabel.textColor = .white
        timeLabel.textAlignment = .center
        timeLabel.font = UIFont.systemFont(ofSize: 14)

        let labelStack = UIStackView(arrangedSubviews: [hexLabel, timeLabel])
        labelStack.axis = .vertical
        labelStack.spacing = 4
        labelStack.translatesAutoresizingMaskIntoConstraints = false

        cardView.addSubview(labelStack)
        NSLayoutConstraint.activate([
            labelStack.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            labelStack.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])

        colorStackView.addArrangedSubview(cardView)
    }

    func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: Date())
    }

    func saveColorsToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(savedColors) {
            UserDefaults.standard.set(encoded, forKey: "SavedColors")
        }
    }

    func loadColorsFromUserDefaults() {
        if let data = UserDefaults.standard.data(forKey: "SavedColors"),
           let decoded = try? JSONDecoder().decode([ColorEntry].self, from: data) {
            savedColors = decoded
            for entry in savedColors {
                addColorCard(hex: entry.hexCode, timestamp: entry.timestamp)
            }
        }
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResults" {
            if let destinationVC = segue.destination as? ColorController {
                destinationVC.colorHex = generatedHexCode ?? "#FFFFFF"
            }
        }
    }
    @IBAction func resetColors(_ sender: UIButton) {
        // Remove from UserDefaults
        UserDefaults.standard.removeObject(forKey: "SavedColors")
        
        // Clear color stack UI
        for view in colorStackView.arrangedSubviews {
            colorStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        // Also clear in-memory list if you're keeping one
        savedColors.removeAll()
    }

}
