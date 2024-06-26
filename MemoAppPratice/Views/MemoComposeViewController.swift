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
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()        
    }
    
    func bindViewModel() {
        let input = MemoComposeViewModel.Input(
            inputTitle: titleTextField.rx.text.orEmpty,
            inputContent: contentTextField.rx.text.orEmpty,
            saveButtonTap: saveButton.rx.tap,
            closeButtonTap: closeButton.rx.tap)
                
        let output = viewModel.transform(input: input)
        
        output.validate
            .drive(saveButton.rx.isEnabled)
            .disposed(by: bag)
        
        output.editCompleted
            .subscribe(onNext: { [weak self] in
            self?.dismiss(animated: true)
        })
        .disposed(by: bag)
        
        output.outputTitle
            .drive(titleTextField.rx.text)
            .disposed(by: bag)
        
        output.outputContent
            .drive(contentTextField.rx.text)
            .disposed(by: bag)
        
        // Cocoa touch에서는 키보드 노티피케이션을 등록하고 해제해야함
        
        // keyboard가 나타날때 next이벤트 전달
       let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map { $0.cgRectValue.height }
        
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        let keyboardObservable = Observable.merge(willShowObservable, willHideObservable)
            .share()
       
        keyboardObservable
            .subscribe { [weak self] height in
                guard let  self = self else {
                    return
                }
                self.saveButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -(height - 20)).isActive = true
            }
            .disposed(by: bag)
    }
}
