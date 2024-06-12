//
//  PostViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/25.
//
//
import UIKit
import FirebaseCore
import FirebaseFirestore

protocol ColorButtonViewDelegate: AnyObject {
    func colorButtonView(_ view: ColorButtonView, didSelectColor color: UIColor)
}

class PaddedLabel: UILabel {
    var textInsets = UIEdgeInsets.zero {
        didSet { setNeedsDisplay() }
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += textInsets.top + textInsets.bottom
        contentSize.width += textInsets.left + textInsets.right
        return contentSize
    }
}

class ColorButtonView: UIView {
    
    weak var delegate: ColorButtonViewDelegate?

    var buttons: [UIButton] = []
    let colors: [UIColor] = [
        UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0), // パステルイエロー
        UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0), // パステルブルー
        .white,
        UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0)  // パステルグリーン
    ]
    
    var selectedButtonTag: Int?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        let buttonSize: CGFloat = 40
        let padding: CGFloat = 10.0
        
        for (index, color) in colors.enumerated() {
            let button = UIButton(frame: CGRect(x: CGFloat(index) * (buttonSize + padding), y: 0, width: buttonSize, height: buttonSize))
            button.backgroundColor = color
            button.layer.cornerRadius = buttonSize / 2
            button.layer.borderWidth = 2
            button.layer.borderColor = UIColor.black.cgColor
            button.tag = index
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        
        if let firstButton = buttons.first {
            firstButton.layer.borderColor = UIColor.red.cgColor
            selectedButtonTag = firstButton.tag
        }
        
        let totalWidth = CGFloat(colors.count) * (buttonSize + padding) - padding
        self.frame = CGRect(x: 0, y: 0, width: totalWidth, height: buttonSize)
    }
    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        let selectedColor = colors[sender.tag]
        print("Selected color: \(selectedColor)")
        
        if let previousTag = selectedButtonTag {
            buttons[previousTag].layer.borderColor = UIColor.black.cgColor
        }
        
        sender.layer.borderColor = UIColor.red.cgColor
        selectedButtonTag = sender.tag

        delegate?.colorButtonView(self, didSelectColor: selectedColor)
    }
}

class PostViewController: UIViewController, UITextViewDelegate, ColorButtonViewDelegate {
    
    @IBOutlet var textview: UITextView!
    @IBOutlet var confirmButton: UIButton!
    var inputData: String?
    
    var characterCountLabel: UILabel!
    var themeLabel: PaddedLabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        textview.delegate = self
        textview.becomeFirstResponder()
        textview.font = UIFont(name: "Georgia", size: 20)
        
        self.view.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        self.textview.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0)
        
        characterCountLabel = UILabel()
        characterCountLabel.text = "0/30"
        characterCountLabel.sizeToFit()
        characterCountLabel.frame.size.width += 10

        let countBarButtonItem = UIBarButtonItem(customView: characterCountLabel)
        
        let addButton = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        let cancelButton = UIBarButtonItem(title: "キャンセル", style: .plain, target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
        
        let colorButtonView = ColorButtonView()
        colorButtonView.delegate = self
        colorButtonView.translatesAutoresizingMaskIntoConstraints = false
         
        let colorButtonViewItem = UIBarButtonItem(customView: colorButtonView)

        
        let toolbar = UIToolbar()
        view.addSubview(toolbar)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.items = [colorButtonViewItem, space, countBarButtonItem]
        
        toolbar.sizeToFit()
        textview.inputAccessoryView = toolbar
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        textview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            colorButtonView.heightAnchor.constraint(equalToConstant: 40), // Adjust height according to the number of buttons and padding
            colorButtonView.widthAnchor.constraint(equalToConstant: colorButtonView.frame.width)   // Adjust width according to button size
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        setupThemeLabel(Theme: inputData ?? "取得失敗！")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutTextView()
    }
    
    func setupThemeLabel(Theme: String) {
        if themeLabel == nil {
            themeLabel = PaddedLabel()
            themeLabel.text = Theme
            themeLabel.textAlignment = .center
            themeLabel.font = UIFont(name: "Georgia", size: 20)
            themeLabel.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0)
            themeLabel.layer.cornerRadius = 12
            themeLabel.layer.masksToBounds = true
            themeLabel.translatesAutoresizingMaskIntoConstraints = false
            themeLabel.numberOfLines = 0
            themeLabel.textInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            view.addSubview(themeLabel)
            
            NSLayoutConstraint.activate([
                themeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
                themeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                themeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
                themeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
            ])
        } else {
            themeLabel.text = Theme
        }
    }
    
    func layoutTextView() {
        NSLayoutConstraint.activate([
            textview.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 20),
            textview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        ])
    }
    
    @objc func addButtonTapped() {
        let inputData = (inputData ?? "") + textview.text
        let color = textview.backgroundColor
        
        let nextView = storyboard?.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        nextView.ReceivedData = inputData
        nextView.colorData = color
        
        present(nextView, animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func didTapDoneButton() {
        textview.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            adjustForKeyboard(show: true, keyboardHeight: keyboardHeight)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        adjustForKeyboard(show: false, keyboardHeight: 0)
    }

    func adjustForKeyboard(show: Bool, keyboardHeight: CGFloat) {
        let adjustmentHeight = show ? keyboardHeight : 0
        textview.contentInset.bottom = adjustmentHeight
        if #available(iOS 13.0, *) {
            textview.verticalScrollIndicatorInsets.bottom = adjustmentHeight
        } else {
            textview.scrollIndicatorInsets.bottom = adjustmentHeight
        }
    }
    
    @IBAction func confirmButtonTapped() {
        let inputData = textview.text
        let color = textview.backgroundColor
        
        let nextView = storyboard?.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        nextView.ReceivedData = inputData!
        nextView.colorData = color
        
        present(nextView, animated: true, completion: nil)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
    }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxTextLength = 30
        let currentText = textView.text ?? ""
        let newLength = currentText.count + text.count - range.length
        return newLength <= maxTextLength
    }
    
    func colorButtonView(_ view: ColorButtonView, didSelectColor color: UIColor) {
        print("Delegate method called with color: \(color)")
        self.view.backgroundColor = color
        self.textview.backgroundColor = color
    }

    func updateCharacterCount() {
        let count = textview.text.count
        characterCountLabel.text = "\(count)/30"
        if count >= 25 {
            characterCountLabel.textColor = .red
        } else {
            characterCountLabel.textColor = .label
        }
    }
}


