//
//  NewTaskViewController.swift
//  ToDoTask
//
//  Created by Trung Nguyễn Quốc on 05/08/2023.
//

import UIKit

class NewTaskViewController: UIViewController {
    
    
    //MARK: - Outlets
    
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskDescriptionTextField: UITextField!
    @IBOutlet weak var hourTextField: UITextField!
    @IBOutlet weak var minuteTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var nameDescriptionContainerView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newTaskTopConstraint: NSLayoutConstraint!
    
    //MARK: - Variable
    
    private var taskViewModel: TaskViewModel!
    private var keyboardOpened = false
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.taskViewModel = TaskViewModel()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: TaskTypeCollectionViewCell.identifier, bundle: .main), forCellWithReuseIdentifier: TaskTypeCollectionViewCell.identifier)
        self.startButton.layer.cornerRadius = 12
        self.nameDescriptionContainerView.layer.cornerRadius = 12
        
        [self.hourTextField, self.minuteTextField, self.secondTextField].forEach {
            $0?.attributedPlaceholder = NSAttributedString(string: "00", attributes: [NSAttributedString.Key.font : UIFont(name: "Code-Pro-Bold-LC", size: 55)!, NSAttributedString.Key.foregroundColor: UIColor.black])
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(textFieldInputChanged(_ :)), for: .editingChanged)
        }
        
        self.taskNameTextField.attributedPlaceholder = NSAttributedString(string: "Task Name", attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-Medium", size: 16.5)!, NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.55)])
        
        self.taskDescriptionTextField.attributedPlaceholder = NSAttributedString(string: "Task Description", attributes: [NSAttributedString.Key.font : UIFont(name: "Montserrat-Medium", size: 16.5)!, NSAttributedString.Key.foregroundColor: UIColor.black.withAlphaComponent(0.55)])
        
        self.taskNameTextField.addTarget(self, action: #selector(textFieldInputChanged(_ :)), for: .editingChanged)
        self.taskDescriptionTextField.addTarget(self, action: #selector(textFieldInputChanged(_ :)), for: .editingChanged)
        
        self.disableButton()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped(_:)))
        
        tapGesture.cancelsTouchesInView = false
        
        self.view.addGestureRecognizer(tapGesture)
        
        self.taskViewModel.getHours().bind { hours in
            self.hourTextField.text = hours.appendZeros()
        }
        
        self.taskViewModel.getMinutes().bind { minutes in
            self.minuteTextField.text = minutes.appendZeros()
        }
        
        self.taskViewModel.getSeconds().bind { seconds in
            self.secondTextField.text = seconds.appendZeros()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }
    
    
    
    //MARK: - Outlets & obj functions
    @IBAction func startButtonPressed(_ sender: Any) {
        guard let timerVC = self.storyboard?.instantiateViewController(withIdentifier: TimerViewController.description()) as? TimerViewController
        else {return}
        taskViewModel.computeSeconds()
        self.present(timerVC, animated: true)
        
    }
    
    @IBAction func multiplyButtonPressed(_ sender: Any) {
        
    }
    
    @objc func textFieldInputChanged(_ textField: UITextField) {
        guard let text = textField.text else { return }
        
        if (textField == taskNameTextField){
            self.taskViewModel.setTaskName(to: text)
            
        }else if (textField == taskDescriptionTextField) {
            
            self.taskViewModel.setTaskDescription(to: text)
            
        }else if (textField == hourTextField){
            
            guard let hours = Int(text) else {return}
            
            self.taskViewModel.setHours(to: hours)
            
        }else if (textField == minuteTextField){
            
            guard let minutes = Int(text) else {return}
            
            self.taskViewModel.setMinutes(to: minutes)
        }else {
            guard let seconds = Int(text) else {return}
            self.taskViewModel.setSeconds(to: seconds)
        }
        
        checkButtonStatus()
    }
    
    
    
    @objc func viewTapped (_ sender: UITapGestureRecognizer){
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if !Constants.hasTopNotch, !keyboardOpened {
            self.keyboardOpened.toggle()
            self.newTaskTopConstraint.constant -= self.view.frame.height * 0.2
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        self.newTaskTopConstraint.constant = 20
        self.keyboardOpened = false
        self.view.layoutIfNeeded()
    }
    
    //MARK: - Functions
    
    override class func description() -> String {
        return "NewTaskViewController"
    }
    
    func enableButton() {
        if (self.startButton.isUserInteractionEnabled == false){
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 1
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func disableButton () {
        if (self.startButton.isUserInteractionEnabled){
            UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                self.startButton.layer.opacity = 0.25
            } completion: { _ in
                self.startButton.isUserInteractionEnabled.toggle()
            }
        }
    }
    
    func checkButtonStatus () {
        
        if taskViewModel.isTaskValid() {
            enableButton()
        }else {
            disableButton()
        }
    }
    
    
}


extension NewTaskViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 2
        
        let currentText: NSString = (textField.text ?? "") as NSString
        let newString: NSString = currentText.replacingCharacters(in: range, with: string) as NSString
        guard let text = textField.text else { return false }
        if (text.count == 2 && text.starts(with: "0")) {
            textField.text?.removeFirst()
            textField.text? += string
            self.textFieldInputChanged(textField)
        }
        return newString.length <= maxLength
    }
}


extension NewTaskViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return taskViewModel.getTaskType().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let columns: CGFloat = 3.75
        let width: CGFloat = collectionView.frame.width
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let adjustedWidth = width - (flowLayout.minimumLineSpacing * (columns - 1))
        
        return CGSize(width: adjustedWidth / columns, height: self.collectionView.frame.height)
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TaskTypeCollectionViewCell.identifier, for: indexPath) as! TaskTypeCollectionViewCell
        cell.setupCell(taskType: self.taskViewModel.getTaskType()[indexPath.item], isSelected: taskViewModel.getSelectedIndex() == indexPath.item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.taskViewModel.setSelectedIndex(to: indexPath.item)
        self.collectionView.reloadSections(IndexSet(integer: 0))
        checkButtonStatus()
    }
    
    
}
