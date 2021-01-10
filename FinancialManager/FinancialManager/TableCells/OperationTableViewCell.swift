//
//  OperationTableViewCell.swift
//  FinancialManager
//
//  Created by Anderson Alencar on 08/01/21.
//

import UIKit

class OperationTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionOperation: UILabel!
    @IBOutlet weak var value: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var statusOperation: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        self.backgroundColor = .tertiaryColor
        setLayout()
    }
    
    func configureCell(descriptionOperation: String, value: Double, date: Date, statusOperation: Bool) {
        self.descriptionOperation.text = descriptionOperation
        self.value.text = "R$ \(value)".replacingOccurrences(of: ".", with: ",")
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy"
        let dateFormatted = formatter.string(from: date)
        self.date.text = dateFormatted
        self.statusOperation.image = statusOperation == true ? UIImage(named: "pago") : UIImage(named: "pending")
    }
    
    func setLayout() {
        descriptionOperation.textColor = .primaryTextColor
        value.textColor = .expenseSegmented
        date.textColor = .primaryTextColor
    }
}
