//
//  PostViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/25.
//

import UIKit
import FirebaseCore
import FirebaseFirestore


class ColorButtonView: UIView {
    
    var buttons: [UIButton] = []
    let colors: [UIColor] = [.black, .blue, .systemPink]
    
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
            button.layer.borderColor = UIColor.white.cgColor
            button.tag = index
            button.addTarget(self, action: #selector(colorButtonTapped(_:)), for: .touchUpInside)
            buttons.append(button)
            addSubview(button)
        }
        
        let totalWidth = CGFloat(colors.count) * (buttonSize + padding) - padding
        self.frame = CGRect(x: 0, y: 0, width: totalWidth, height: buttonSize)
    }

    
    @objc private func colorButtonTapped(_ sender: UIButton) {
        let selectedColor = colors[sender.tag]
        print("Selected color: \(selectedColor)")
    }
}


class PostViewController: UIViewController , UITextViewDelegate {
    
    @IBOutlet var textview :UITextView!
    @IBOutlet var ConfirmButton :UIButton!
    var inputData: String?
    var ThemeTxt = "取得失敗！"
    
    var characterCountLabel: UILabel!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textview.text = GetTxt
        
        textview.delegate = self
        textview.becomeFirstResponder()
        
        characterCountLabel = UILabel()
        characterCountLabel.text = String(GetTxt.count) + "/30"
        characterCountLabel.sizeToFit()
        characterCountLabel.frame.size.width += 10

        let countBarButtonItem = UIBarButtonItem(customView: characterCountLabel)
        
        
        let colorButtonView = ColorButtonView()
         colorButtonView.translatesAutoresizingMaskIntoConstraints = false
         
        let colorButtonViewItem = UIBarButtonItem(customView: colorButtonView)

        
        let toolbar = UIToolbar()
        view.addSubview(toolbar)
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        
        toolbar.items = [colorButtonViewItem,space, countBarButtonItem]
        
        toolbar.sizeToFit()
        textview.inputAccessoryView = toolbar
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        characterCountLabel.translatesAutoresizingMaskIntoConstraints = false
        textview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            colorButtonView.heightAnchor.constraint(equalToConstant: 44), // Adjust height according to the number of buttons and padding
            colorButtonView.widthAnchor.constraint(equalToConstant: colorButtonView.frame.width)   // Adjust width according to button size
        ])
        
        

    }
    
    @objc func didTapDoneButton() {
        textview.resignFirstResponder()
    }
    
    
    
    @IBAction func ConfirmButtonTapped(){
        let inputData = textview.text
        //print("入力された\(inputData ?? "")")
        let nextView = storyboard?.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        nextView.ReceivedData = inputData!
        //nextView.modalPresentationStyle = .fullScreen
        present(nextView, animated: true, completion: nil)
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//            let maxTextLength = 30
//            let currentText = textView.text ?? ""
//            guard let stringRange = Range(range, in: currentText) else { return false }
//            let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
//            return updatedText.count <= maxTextLength
//        }

    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let maxTextLength = 30
        let currentText = textView.text ?? ""
        
        let newLength = currentText.count + text.count - range.length

        return newLength <= maxTextLength
    }



    func updateCharacterCount() {
        let count = textview.text.count
        characterCountLabel.text = "\(count)" + "/30"
        if count >= 25{
            characterCountLabel.textColor = .red
        }else{
            characterCountLabel.textColor = .label
        }
    }
}

