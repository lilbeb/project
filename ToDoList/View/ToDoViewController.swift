//
//  ViewController.swift
//  ToDoList
//
//  Created by Элина Борисова on 23.06.2023.
//

import UIKit

class ToDoViewController: UIViewController {
    
    private var toDoItems = TodoItem(text: "", importance: .usual, isDone: false, creationDate: .now)
    private let textLabel = textLabelFunc()
    private let scrollView = scrollViewFunc()
    private let contentView = contentViewFunc()
    private let deadlineLabel = deadlineLabelFunc()
    private let importanceLabel = importanceLabelFunc()
    private let importanceControl = importanceControlFunc()
    private let deadlineSwitch = deadlineSwitchFunc()
    private let deadlineButton = deadlineButtonFunc()
    private let deadlineSep = deadlineSepFunc()
    private let deleteButton = deleteButtonFunc()
    private let optionView = optionViewFunc()
    private let calendarView = calendarViewFunc()
    private let importanceSep = importanceSepFunc()

    var cancelButton: UIBarButtonItem?
    var saveButton: UIBarButtonItem?
    
    private var deadlineDate: Date? {
        didSet{
            if let deadline = deadlineDate{
                let formater = DateFormatter()
                formater.dateFormat = "dd.MM.yyyy"
                deadlineButton.setTitle(formater.string(from: deadline), for: .normal)
            }
        }
    }
    private lazy var textView: UITextView = {
        let text = UITextView()
        text.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        text.translatesAutoresizingMaskIntoConstraints = false
        text.layer.cornerRadius = 16
        text.delegate = self
        text.font = .systemFont(ofSize: 17)
        text.textContainer.lineFragmentPadding = 16
        text.isScrollEnabled = false
        text.textContainerInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return text
    }()
    
    private lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
    
    private func subscribeToKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
//    MARK: - ViewDidload
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.95, alpha: 1.0)
        title = "Дело"
        tapGestureRecognizer.isEnabled = false
        view.addGestureRecognizer(tapGestureRecognizer)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Сохранить", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Отменить", style: .plain, target: self, action: #selector(cancel))
        
        subscribeToKeyboard()
        
        scrollView.keyboardDismissMode = .interactive
        
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        scrollView.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 1),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
//        scrollView.keyboardDismissMode = .interactive
        
        contentView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])
        
        contentView.addSubview(optionView)
        NSLayoutConstraint.activate([
            optionView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 16),
            optionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            optionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            optionView.heightAnchor.constraint(greaterThanOrEqualToConstant: 112.5)
        ])
        
        optionView.addSubview(importanceLabel)
        NSLayoutConstraint.activate([
            importanceLabel.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 16),
            importanceLabel.topAnchor.constraint(equalTo: optionView.topAnchor),
            importanceLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        optionView.addSubview(importanceSep)
        NSLayoutConstraint.activate([
            importanceSep.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 16),
            importanceSep.trailingAnchor.constraint(equalTo: optionView.trailingAnchor, constant: -16),
            importanceSep.topAnchor.constraint(equalTo: importanceLabel.bottomAnchor),
            importanceSep.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        optionView.addSubview(deadlineSep)
        NSLayoutConstraint.activate([
            deadlineSep.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 16),
            deadlineSep.trailingAnchor.constraint(equalTo: optionView.trailingAnchor, constant: -16),
            deadlineSep.topAnchor.constraint(equalTo: importanceSep.bottomAnchor, constant: 56),
            deadlineSep.heightAnchor.constraint(equalToConstant: 0.5)
        ])
        
        optionView.addSubview(deadlineLabel)
        NSLayoutConstraint.activate([
            deadlineLabel.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 16),
            deadlineLabel.topAnchor.constraint(equalTo: importanceSep.bottomAnchor, constant: 9),
            deadlineLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
        
        optionView.addSubview(deadlineButton)
        NSLayoutConstraint.activate([
            deadlineButton.leadingAnchor.constraint(equalTo: optionView.leadingAnchor, constant: 16),
            deadlineButton.topAnchor.constraint(equalTo: deadlineLabel.bottomAnchor),
            deadlineButton.bottomAnchor.constraint(equalTo: deadlineSep.topAnchor, constant: -9),
            deadlineButton.heightAnchor.constraint(equalToConstant: 0)
        ])
        
        optionView.addSubview(importanceControl)
        NSLayoutConstraint.activate([
            importanceControl.trailingAnchor.constraint(equalTo: optionView.trailingAnchor,  constant: -16),
            importanceControl.centerYAnchor.constraint(equalTo: importanceLabel.centerYAnchor),
            importanceControl.heightAnchor.constraint(equalToConstant: 36),
            importanceControl.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        optionView.addSubview(deadlineSwitch)
        NSLayoutConstraint.activate([
            deadlineSwitch.trailingAnchor.constraint(equalTo: optionView.trailingAnchor,  constant: -16),
            deadlineSwitch.topAnchor.constraint(equalTo: importanceSep.bottomAnchor, constant: 13.5)
        ])
        
        optionView.addSubview(calendarView)
        NSLayoutConstraint.activate([
            calendarView.topAnchor.constraint(equalTo: deadlineSep.bottomAnchor),
            calendarView.trailingAnchor.constraint(equalTo: optionView.trailingAnchor),
            calendarView.leadingAnchor.constraint(equalTo: optionView.leadingAnchor),
            calendarView.bottomAnchor.constraint(equalTo: optionView.bottomAnchor),
            calendarView.heightAnchor.constraint(equalToConstant: 0)
        ])
        
        contentView.addSubview(deleteButton)
        NSLayoutConstraint.activate([
            deleteButton.topAnchor.constraint(equalTo: optionView.bottomAnchor, constant: 16),
            deleteButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            deleteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            deleteButton.heightAnchor.constraint(equalToConstant: 56),
            deleteButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        textView.translatesAutoresizingMaskIntoConstraints = false
       textView.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: textView.topAnchor, constant: 12),
            textLabel.leadingAnchor.constraint(equalTo: textView.leadingAnchor, constant: 16)
        ])
        
        deleteButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
//    MARK: - Actions
    @objc func cancel(){
        print("cancel")
    }
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @objc func showCalendar(sender: UISwitch) {
        if deadlineSwitch.isOn {
            let date = Calendar.current.date(byAdding: .day, value: 1, to: .now)!
            deadlineDate = date
            let dateSelection = UICalendarSelectionSingleDate(delegate: self)
            dateSelection.selectedDate = Calendar.current.dateComponents([.day, .month, .year], from: date)
            calendarView.selectionBehavior = dateSelection
        }
        deadlineButton.alpha = deadlineSwitch.isOn ? 1 : 0
        deadlineButton.heightAnchor.constraint(equalToConstant: 0).constant = deadlineSwitch.isOn ? 18 : 0
        if !deadlineSwitch.isOn {
            calendarView.heightAnchor.constraint(equalToConstant: 0).isActive = true
        }
        UIView.animate(withDuration: 0.5) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
    @objc func handleKeyboard(_ notification: NSNotification){
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        let height = view.convert(keyboardValue.cgRectValue, from: view.window).height
        let keyboardConst: CGFloat
        if notification.name == UIResponder.keyboardWillShowNotification {
            keyboardConst = height + 16
            tapGestureRecognizer.isEnabled = true
        } else {
            keyboardConst = 0
            tapGestureRecognizer.isEnabled = false
        }
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).constant = -keyboardConst
        UIView.animate(withDuration: 0.5) {
            self.view.layoutSubviews()
        }
    }
//    @objc func save(){
//        let selectedIndex = importanceControl.selectedSegmentIndex
//        let importance: Importance
//        switch selectedIndex{
//        case 0:
//            importance = .notImportant
//        case 1:
//            importance = .usual
//        default:
//            importance = .important
//        }
//        let todoItem = TodoItem(text: textView.text, importance: importance, deadline: )
//        let fileCache: FileCache = FileCache()
//        fileCache.addTodoItem(todoItem)
//        fileCache.save(to: "Cache")
//    }
//    func loadFromCache(){
//        let fileCache: FileCache = FileCache()
//        do {
//            try fileCache.load(to: "todoItemsCache")
//        } catch {
//            print(error)
//        }
//        if  let (_, item) = fileCache.todoItems.first {
//            textView.text = item.text
//            textLabel.isHidden = true
//            switch item.importance{
//            case .important:
//                importanceControl.selectedSegmentIndex = 2
//            case .low:
//                importanceControl.selectedSegmentIndex = 0
//            default:
//                importanceControl.selectedSegmentIndex = 1
//            }
//            deadlineDate = item.deadline
//            deadlineSwitch.isOn = item.deadline != nil
//            deadlineButton.alpha = deadlineSwitch.isOn ? 1 : 0
//            deadlineButton.heightAnchor.constraint(equalToConstant: 0).constant = deadlineSwitch.isOn ? 18 : 0
//            deleteButton.isEnabled = true
//        }
//    }
    
}

// MARK: - Setup


private extension ToDoViewController {
    
    func setUpView() {
        view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
    }
    
    func setupNavigationBar() {
        let attributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.font: 17
        ]
        navigationController?.navigationBar.titleTextAttributes = attributes
        title = "Дело"
        let cancelButton = UIBarButtonItem(
            title: "Отменить",
            style: .plain,
            target: self,
            action: #selector(cancel)
        )
        
        let saveButton = UIBarButtonItem(
            title: "Сохранить",
            style: .done,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        navigationItem.leftBarButtonItem?.tintColor = .blue
        navigationItem.rightBarButtonItem?.tintColor = .blue
    }
    
    static func textLabelFunc() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Что надо сделать?"
        label.textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        label.font = .systemFont(ofSize: 17)
        return label
    }
    
    static func scrollViewFunc() -> UIScrollView {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }
    
    static func contentViewFunc() -> UIView {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        return contentView
    }
    
    static func importanceSepFunc() -> UIView {
        let separator = UIView()
        separator.layer.cornerRadius = 16
        separator.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        return separator
    }
    
    static func importanceLabelFunc() -> UILabel {
        let label = UILabel()
        label.text = "Важность"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static func importanceControlFunc() -> UISegmentedControl {
        let importanceSegment = UISegmentedControl(items: [UIImage(named: "low")!, "нет", "‼️"])
        importanceSegment.selectedSegmentIndex = 2
        importanceSegment.translatesAutoresizingMaskIntoConstraints = false
        
        return importanceSegment
    }
    
    static func deadlineSepFunc() -> UIView {
        let separator = UIView()
        separator.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.2)
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        return separator
    }
    
    static func deadlineLabelFunc() -> UILabel {
        let label = UILabel()
        label.text = "Сделать до"
        label.font = .systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    static func deadlineSwitchFunc() -> UISwitch {
        let deadlineSwitch = UISwitch()
        deadlineSwitch.addTarget(self, action: #selector(showCalendar), for: .valueChanged)
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        return deadlineSwitch
    }
    
    static func calendarViewFunc() -> UICalendarView {
        let calendarView = UICalendarView()
        calendarView.layer.cornerRadius = 16
        calendarView.availableDateRange = DateInterval(start: .now, end: .distantFuture)
        calendarView.calendar = .current
        calendarView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        calendarView.translatesAutoresizingMaskIntoConstraints = false
        
        return calendarView
    }
    
    static func deadlineButtonFunc() -> UIButton {
        let button = UIButton()
        button.setTitleColor(UIColor(red: 0, green: 0.48, blue: 1, alpha: 1), for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.alpha = 0
        button.setTitle("01.01.1970", for: .normal)
        button.addTarget(self, action: #selector(showCalendar), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    static func optionViewFunc() -> UIView {
        let option = UIView()
        option.layer.cornerRadius = 16
        option.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        option.translatesAutoresizingMaskIntoConstraints = false

        return option
    }
    
    static func deleteButtonFunc() -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setTitleColor(.gray, for: .disabled)
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        button.isEnabled = false

        return button
        }
    
}

extension ToDoViewController: UICalendarSelectionSingleDateDelegate{
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?){
        if let dateComponents = dateComponents{
            if let date = Calendar.current.date(from: dateComponents){
                deadlineDate = date
            }
        }
    }
    private func findActiveField(in view: UIView) -> UIView? {
        for subview in view.subviews {
            if let textField = subview as? UITextField, textField.isFirstResponder {
                return textField
            }
            if let textView = subview as? UITextView, textView.isFirstResponder {
                return textView
            }
            if let found = findActiveField(in: subview) {
                return found
            }
        }
        return nil
    }
}



extension ToDoViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        navigationItem.rightBarButtonItem?.isEnabled = textView.text.isEmpty == false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView){
        textLabel.isHidden = textView.isFirstResponder
    }
    
    func textViewDidEndEditing(_ textView: UITextView){
        if !textView.isFirstResponder && textView.text.isEmpty {
            textLabel.isHidden = false
        }
    }
}
