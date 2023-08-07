//
//  TaskTypeCollectionViewCell.swift
//  ToDoTask
//
//  Created by Trung Nguyễn Quốc on 05/08/2023.
//

import UIKit

class TaskTypeCollectionViewCell: UICollectionViewCell {

    
    //MARK: - Outlets
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var typeName: UILabel!
    
    //MARK: - Variable
    static var identifier = "TaskTypeCollectionViewCell"
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        DispatchQueue.main.async {
            self.imageContainerView.layer.cornerRadius = self.imageContainerView.bounds.width / 2
        }
    }
    
    //MARK: -  Functions
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
        self.imageView.image = nil
    }
    
    func setupCell (taskType: TaskType, isSelected: Bool) {
        self.typeName.text = taskType.typename
        if isSelected {
            self.imageContainerView.backgroundColor = UIColor(hex: "17b879").withAlphaComponent(0.5)
            self.typeName.textColor = UIColor(hex: "006666")
            self.imageView.tintColor = UIColor.white
            self.imageView.image = UIImage(systemName: taskType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 24, weight: .medium))
        }else {
            reset()
            self.imageView.image = UIImage(systemName: taskType.symbolName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))
        }
    }
    
    func reset () {
        self.imageContainerView.backgroundColor = UIColor.clear
        self.typeName.textColor = UIColor.black
        self.imageView.tintColor = UIColor.black
    }
    

}
