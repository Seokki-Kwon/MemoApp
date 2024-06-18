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
        
    }
        
    func bindViewModel() {
        // 내용입력 여부
        Observable.combineLatest(titleTextField.rx.text.orEmpty, contentTextField.rx.text.orEmpty)
            .map { !$0.0.isEmpty && !$0.1.isEmpty }
            .bind(to: saveButton.rx.isEnabled)
            .disposed(by: bag)
        
        saveButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                
            }
            .disposed(by: bag)
    }
}
