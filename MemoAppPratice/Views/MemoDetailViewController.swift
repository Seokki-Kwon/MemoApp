//
//  MemoDetailViewController.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/18/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MemoDetailViewController: UIViewController, BindableType {
    var viewModel: MemoDetailViewModel!
    private let bag = DisposeBag()
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentLabel: UITextView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    func bindViewModel() {
        let input = MemoDetailViewModel.Input(editButtonTap: editButton.rx.tap,
                                              deleteButtonTap: deleteButton.rx.tap,
                                              inputTitle: titleTextField.rx.text.orEmpty,
                                              inputContent: contentLabel.rx.text.orEmpty)        
            
        let output = viewModel.transform(input: input)
        
        output.outputTitle
            .drive(titleTextField.rx.text)
            .disposed(by: bag)
        
        output.outputContent
            .drive(contentLabel.rx.text)
            .disposed(by: bag)
                
        output.editModeChanged
            .drive(contentLabel.rx.isUserInteractionEnabled)
            .disposed(by: bag)
        
        output.editModeChanged
            .asObservable()
            .map { $0 ? "편집 완료" : "메모 편집"}
            .bind(to: editButton.rx.title())
            .disposed(by: bag)
        
        output.editModeChanged
            .drive(titleTextField.rx.isEnabled)
            .disposed(by: bag)
     
        output.deletedMemo
            .subscribe(onCompleted: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
