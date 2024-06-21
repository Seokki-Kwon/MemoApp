//
//  MemoComposeViewController.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import UIKit
import RxSwift
import RxCocoa

class MemoComposeViewController: UIViewController, BindableType {
    var viewModel: MemoComposeViewModel!
    let bag = DisposeBag()

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        titleTextField.addBottomBorder()
    }
        
    func bindViewModel() {
        let input = MemoComposeViewModel.Input(
            inputTitle: titleTextField.rx.text.orEmpty,
            inputContent: contentTextField.rx.text.orEmpty,
            saveButtonTap: saveButton.rx.tap)
                
        let output = viewModel.transform(input: input)
        
        output.validate
            .drive(saveButton.rx.isEnabled)
            .disposed(by: bag)
        
        output.dismissView.subscribe(onCompleted:  {
            self.dismiss(animated: true)
        })
        .disposed(by: bag)
    }
}
