//
//  TableViewCell.swift
//  CL2_Stopwatch
//
//  Created by 이건준 on 2021/12/07.
//

import UIKit

class TableViewCell:UITableViewCell{
    //MARK: Cell Components
    private lazy var numLabel:UILabel={
        let lb = UILabel()
        lb.text = "Lab 1"
        lb.tag = 1
        return lb
    }()
    
    private lazy var labLabel:UILabel={
       let lb = UILabel()
        lb.text = "00:00:00"
        lb.tag = 2
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: Configure
    func configure(){
        self.addSubview(numLabel)
        numLabel.translatesAutoresizingMaskIntoConstraints = false
        numLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        numLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        
        self.addSubview(labLabel)
        labLabel.translatesAutoresizingMaskIntoConstraints = false
        labLabel.centerYAnchor.constraint(equalTo: numLabel.centerYAnchor).isActive = true
        labLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
    }
}
