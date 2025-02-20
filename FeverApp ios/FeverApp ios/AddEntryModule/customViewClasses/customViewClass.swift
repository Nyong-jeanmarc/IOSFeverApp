//
//  customViewClass.swift
//  FeverApp ios
//
//  Created by NEW on 11/11/2024.
//

import Foundation
import UIKit
/// CUSTOM CLASSES FOR REUSABILITY ON VIEWS THAT LOOK ALIKE
    //custom rounded message view class
class customRoundedView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        applyRoundedCornersAndShadow()
    }
    
    private func applyRoundedCornersAndShadow() {
        let path = UIBezierPath(roundedRect: bounds,
                                byRoundingCorners: [.topLeft, .topRight, .bottomRight],
                                cornerRadii: CGSize(width: 10, height: 10))
        
        // Rounded corners
        layer.cornerRadius = 10
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        layer.backgroundColor = UIColor.white.cgColor
        layer.masksToBounds = true
        
        // Shadow
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 5
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowPath = path.cgPath
        layer.masksToBounds = false
    }
}

// custom date picker class
class entryDatePickerView: UIView, UITableViewDelegate, UITableViewDataSource {

    private let dayTableView = UITableView()
    private let hourTableView = UITableView()
    private let minuteTableView = UITableView()
    private let selectionIndicatorLine = UIView()

    var days = [String]()
    var hours = (0..<24).map { String(format: "%02d", $0) }
    var minutes = (0..<60).map { String(format: "%02d", $0) }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDatePickerSubviews()
        scrollToBottom(for: dayTableView)
        scrollToCurrentHourAndMinute()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDatePickerSubviews()
        scrollToBottom(for: dayTableView)
        scrollToCurrentHourAndMinute()
    }
    
    private func generateDaysArray() -> [String] {
        var days = ["Today", "Yesterday"]
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE.dd.MMM"
        
        for dayOffset in 2...14 {
            if let date = calendar.date(byAdding: .day, value: -dayOffset, to: Date()) {
                let dayString = dateFormatter.string(from: date)
                days.append(dayString)
            }
        }
        
        return days.reversed()
    }
    
    private func setupDatePickerSubviews() {
        days = generateDaysArray()
        
        // Setup main container view
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        
        [dayTableView, hourTableView, minuteTableView].forEach { tableView in
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.isScrollEnabled = true
            tableView.backgroundColor = .white
            tableView.rowHeight = 40
            tableView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(tableView)
        }
        
        // Customizing selection indicator
        selectionIndicatorLine.translatesAutoresizingMaskIntoConstraints = false
        selectionIndicatorLine.backgroundColor = .clear
        selectionIndicatorLine.layer.borderWidth = 2
        selectionIndicatorLine.layer.borderColor = UIColor(red: 165/255.0, green: 195/255.0, blue: 242/255.0, alpha: 1.0).cgColor
        self.addSubview(selectionIndicatorLine)
        
        // Setup constraints
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 500),
            
            dayTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            dayTableView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            dayTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            dayTableView.topAnchor.constraint(equalTo: self.topAnchor),
            
            hourTableView.leadingAnchor.constraint(equalTo: dayTableView.trailingAnchor),
            hourTableView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            hourTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            hourTableView.topAnchor.constraint(equalTo: self.topAnchor),
            
            minuteTableView.leadingAnchor.constraint(equalTo: hourTableView.trailingAnchor),
            minuteTableView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            minuteTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            minuteTableView.topAnchor.constraint(equalTo: self.topAnchor),
            selectionIndicatorLine.leadingAnchor.constraint(equalTo: dayTableView.leadingAnchor, constant: -10),
            selectionIndicatorLine.trailingAnchor.constraint(equalTo: minuteTableView.trailingAnchor, constant: 10),
            selectionIndicatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25),
            selectionIndicatorLine.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    func scrollToBottom(for tableView: UITableView) {
        DispatchQueue.main.async {
            let lastRow = tableView.numberOfRows(inSection: 0) - 1
            guard lastRow >= 0 else { return }
            let indexPath = IndexPath(row: lastRow, section: 0)
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func scrollToCurrentHourAndMinute() {
        DispatchQueue.main.async {
            let currentHour = Calendar.current.component(.hour, from: Date())
            let currentMinute = Calendar.current.component(.minute, from: Date())
            
            if let hourIndex = self.hours.firstIndex(of: String(format: "%02d", currentHour)),
               let minuteIndex = self.minutes.firstIndex(of: String(format: "%02d", currentMinute)) {
                let hourIndexPath = IndexPath(row: hourIndex, section: 0)
                let minuteIndexPath = IndexPath(row: minuteIndex, section: 0)
                
                self.hourTableView.scrollToRow(at: hourIndexPath, at: .bottom, animated: false)
                self.minuteTableView.scrollToRow(at: minuteIndexPath, at: .bottom, animated: false)
            }
        }
    }
    
    // TableView DataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case dayTableView:
            return days.count
        case hourTableView:
            return hours.count
        case minuteTableView:
            return minutes.count
        default:
            return 0
        }
    }
 func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
     let cellRect = tableView.convert(cell.frame, to:  self)
     let overlayRect = selectionIndicatorLine.frame
     
     if cellRect.intersects(overlayRect) {
         cell.textLabel?.textColor = .black
     } else {
         cell.textLabel?.textColor = .lightGray // or any other default color
     }
 }

 func scrollViewDidScroll(_ scrollView: UIScrollView) {
     guard let tableView = scrollView as? UITableView else { return }
     
     for cell in tableView.visibleCells {
         let cellRect = tableView.convert(cell.frame, to:  self)
         let overlayRect = selectionIndicatorLine.frame
         
         let intersectionRect = cellRect.intersection(overlayRect)
         print("Intersection Rect: \(intersectionRect)")
         
         if !intersectionRect.isNull {
             print("Cell intersects with overlay view")
             cell.textLabel?.textColor = .black
         } else {
             print("Cell does not intersect with overlay view")
             cell.textLabel?.textColor = .lightGray
         }
     }
 }


 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
     return 80 // Add padding
 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.lightGray
        cell.selectionStyle = .none
        // Configure text for each table view with reversed data order
        switch tableView {
        case dayTableView:
            cell.textLabel?.text = Array(days)[indexPath.row]
        case hourTableView:
            cell.textLabel?.text = Array(hours)[indexPath.row]
        case minuteTableView:
            cell.textLabel?.text = Array(minutes)[indexPath.row]
        default:
            break
        }
        
        return cell
    }
 }
// custom class for buttom view containing the confirm and no answer button
class BottomView: UIView {
    let skipButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedString = NSMutableAttributedString(string: "No answer Skip")
        
        attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: NSRange(location: 0, length: 9))
        attributedString.addAttribute(.foregroundColor, value: UIColor.gray, range: NSRange(location: 10, length: 4))
        
        button.setAttributedTitle(attributedString, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let confirmButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Confirm", for: .normal)
        button.backgroundColor = UIColor(red: 161/255, green: 194/255, blue: 255/255, alpha: 1)
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    // Apply constraints once added to the superview
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        guard let superview = superview else { return }
        
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            self.heightAnchor.constraint(equalToConstant: 95)
        ])
    }
    private func setupView() {
        self.backgroundColor = .white
        self.translatesAutoresizingMaskIntoConstraints = false
        
        // Add buttons to the view
        self.addSubview(skipButton)
        self.addSubview(confirmButton)
        
        // Set constraints for skipButton and confirmButton
        NSLayoutConstraint.activate([
            // Skip Button constraints
            skipButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            skipButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            skipButton.heightAnchor.constraint(equalToConstant: 45),
            
            // Confirm Button constraints
            confirmButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            confirmButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            confirmButton.heightAnchor.constraint(equalToConstant: 45),
            
            skipButton.widthAnchor.constraint(equalTo: confirmButton.widthAnchor),
            
            // Add spacing between the buttons
            confirmButton.leadingAnchor.constraint(equalTo: skipButton.trailingAnchor, constant: 16)
        ])
    }
    
    // Add button action functions for touchDown only
       func addTargets(
           target: Any?,
           skipTouchDown: Selector,
           skipTouchUp: Selector,
           confirmTouchDown: Selector,
           confirmTouchUp: Selector
           
       ) {
           skipButton.addTarget(target, action: skipTouchDown, for: .touchDown)
           skipButton.addTarget(target, action: skipTouchUp, for: .touchUpInside)
           confirmButton.addTarget(target, action: confirmTouchDown, for: .touchDown)
           confirmButton.addTarget(target, action: confirmTouchUp, for: .touchUpInside)
       }
}
// custom view class for subview of main views
class subView: UIView {
    
      // Initialization
      override init(frame: CGRect) {
          super.init(frame: frame)
          setupView()
      }
      
      required init?(coder: NSCoder) {
          super.init(coder: coder)
          setupView()
      }
      
      // Set up the view
      private func setupView() {
          self.translatesAutoresizingMaskIntoConstraints = false
          self.backgroundColor = .clear
          // Set any default background color or style if needed
      }
      
      // Apply constraints once added to the superview
      override func didMoveToSuperview() {
          super.didMoveToSuperview()
          
          guard let superview = superview else { return }
          
          NSLayoutConstraint.activate([
              self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
              self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
              self.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
              self.heightAnchor.constraint(equalToConstant: 600)
          ])
      }
}
class MainView: UIView {

    init(scrollView: UIScrollView) {
        super.init(frame: .zero)
        setupView(scrollView: scrollView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView(scrollView: UIScrollView) {
        // Set properties
        self.translatesAutoresizingMaskIntoConstraints = false

        // Add constraints relative to the superview and scrollView
        guard let superview = scrollView.superview else { return }
        
        superview.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(lessThanOrEqualToConstant: 600),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            self.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 20),
            self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0)
        ])
    }
}



