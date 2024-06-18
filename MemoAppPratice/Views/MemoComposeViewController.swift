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
        // 내용입력 여부
        Observable.combineLatest(titleTextField.rx.text.orEmpty, contentTextField.rx.text.orEmpty)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: bag)
        
        titleTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe { (vc, text) in
                vc.viewModel.updateTitle(title: text)
            }
            .disposed(by: bag)
        
        contentTextField.rx.text.orEmpty
            .withUnretained(self)
            .subscribe { (vc, text) in
                vc.viewModel.updateContent(content: text)
            }
            .disposed(by: bag)
        
        saveButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: {(vc, _) in
                vc.viewModel.performUpdate()
            })
            .disposed(by: bag)
    }
}
