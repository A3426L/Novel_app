//
//  PostViewController.swift
//  Novel_app
//
//  Created by aru on 2024/05/25.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

protocol ColorButtonViewDelegate: AnyObject {
    func colorButtonView(_ view: ColorButtonView, didSelectColor color: UIColor)
}

class ColorButtonView: UIView {
    
    weak var delegate: ColorButtonViewDelegate?

    var buttons: [UIButton] = []
//    let colors: [UIColor] = [.systemOrange.withAlphaComponent(0.5), .systemBlue.withAlphaComponent(0.5), .systemPink.withAlphaComponent(0.5)]
    let colors: [UIColor] = [
        UIColor(red: 1.0, green: 1.0, blue: 0.8, alpha: 1.0), // パステルイエロー
        UIColor(red: 0.7, green: 0.8, blue: 1.0, alpha: 1.0), // パステルブルー
        UIColor(red: 1.0, green: 0.8, blue: 0.8, alpha: 1.0), // パステルピンク
        UIColor(red: 0.8, green: 1.0, blue: 0.8, alpha: 1.0)  // パステルグリーン
    ]
    
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
        delegate?.colorButtonView(self, didSelectColor: selectedColor)
    }
}


class PostViewController: UIViewController , UITextViewDelegate, ColorButtonViewDelegate {
    
    @IBOutlet var textview :UITextView!
    @IBOutlet var ConfirmButton :UIButton!
    var inputData: String?
    //var ThemeTxt = "取得失敗！"
    
    var characterCountLabel: UILabel!
    
    var themeLabel: UILabel!

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupThemeLabel(Theme: GetTxt)
        
        textview.delegate = self
        textview.becomeFirstResponder()
        
        characterCountLabel = UILabel()
        characterCountLabel.text = "0/30"
        characterCountLabel.sizeToFit()
        characterCountLabel.frame.size.width += 10

        let countBarButtonItem = UIBarButtonItem(customView: characterCountLabel)
        
        let addButton = UIBarButtonItem(title: "完了", style: .plain, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
        
        let colorButtonView = ColorButtonView()
        colorButtonView.delegate = self
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
            textview.topAnchor.constraint(equalTo: themeLabel.bottomAnchor, constant: 20), // ラベルとテキストビューの間に20ポイントのスペースを追加
            textview.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            textview.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            textview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)  // テキストビューの下に余白を追加
        ])
        
        NSLayoutConstraint.activate([
            toolbar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolbar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            colorButtonView.heightAnchor.constraint(equalToConstant: 40), // Adjust height according to the number of buttons and padding
            colorButtonView.widthAnchor.constraint(equalToConstant: colorButtonView.frame.width)   // Adjust width according to button size
        ])
        
        

    }
    
    
    
    func setupThemeLabel(Theme:String) {
        themeLabel = UILabel()
        themeLabel.text = Theme
        themeLabel.textAlignment = .center
        themeLabel.font = UIFont.boldSystemFont(ofSize: 24)
        themeLabel.backgroundColor = UIColor(white: 0.9, alpha: 1)
        themeLabel.layer.cornerRadius = 12
        themeLabel.layer.masksToBounds = true
        themeLabel.translatesAutoresizingMaskIntoConstraints = false
        themeLabel.numberOfLines = 0
        view.addSubview(themeLabel)
        
//        NSLayoutConstraint.activate([
//            themeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//            themeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            themeLabel.widthAnchor.constraint(equalToConstant: 200),
//            themeLabel.heightAnchor.constraint(equalToConstant: 50)
//        ])
        NSLayoutConstraint.activate([
            themeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            themeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            themeLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            themeLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    @objc func addButtonTapped() {
        
        let inputData = GetTxt  + textview.text
        let color = textview.backgroundColor
        //print("入力された\(inputData ?? "")")
        let nextView = storyboard?.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        nextView.ReceivedData = inputData
        nextView.colorData = color
        //nextView.modalPresentationStyle = .fullScreen
        present(nextView, animated: true, completion: nil)
    }
    
    @objc func didTapDoneButton() {
        textview.resignFirstResponder()
    }
    
    
    
    @IBAction func ConfirmButtonTapped(){
        let inputData = textview.text
        let color = textview.backgroundColor
        //print("入力された\(inputData ?? "")")
        let nextView = storyboard?.instantiateViewController(withIdentifier: "ConfirmViewController") as! ConfirmViewController
        nextView.ReceivedData = inputData!
        nextView.colorData = color
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
    

    func colorButtonView(_ view: ColorButtonView, didSelectColor color: UIColor) {
        print("Delegate method called with color: \(color)")
        self.view.backgroundColor = color
        self.textview.backgroundColor = color
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

