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
    private let bag = DisposeBag()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextField: UITextView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var closeButton: UIBarButtonItem!
    @IBOutlet weak var actionSheetButton: UIBarButtonItem!
    @IBOutlet weak var colorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        let actionTypeSubject = PublishSubject<ActionSheetType>()
        let selecteColorSubject = PublishSubject<UIColor>()
        let colorPickerView = UIColorPickerViewController()
        
        colorPickerView.rx.didSeleteColor
            .bind(to: selecteColorSubject)
            .disposed(by: bag)
        
        let input = MemoComposeViewModel.Input(
            inputTitle: titleTextField.rx.text.orEmpty,
            inputContent: contentTextField.rx.text.orEmpty,
            saveButtonTap: saveButton.rx.tap,
            closeButtonTap: closeButton.rx.tap,
            actionSheetButtonTap: actionSheetButton.rx.tap,
            selectedActionType: actionTypeSubject.asObservable(),
            colorButtonTap: colorButton.rx.tap,
       selecteColor: selecteColorSubject)
        
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
        
        output.actionButtonTapped
            .subscribe(onNext: { [weak self] in
                guard let self = self else {
                    return
                }
                self.presentActionSheet(actionType: ActionSheetType.allCases, inputSubject: actionTypeSubject)
            })
            .disposed(by: bag)
        
        output.presentColorPicker
            .bind { [weak self] _ in
                self?.present(colorPickerView, animated: true)
            }
            .disposed(by: bag)
        
        output.seleteColor
            .drive(colorButton.rx.backgroundColor, 
                   navigationController!.navigationBar.scrollEdgeAppearance!.rx.backgroundColor)
            .disposed(by: bag)
            
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




