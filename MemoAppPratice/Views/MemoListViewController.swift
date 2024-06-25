//
//  MemoListViewController.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/17/24.
//

import UIKit
import RxSwift
import RxCocoa

final class MemoListViewController: UIViewController, BindableType {
    var viewModel: MemoListViewModel!
    private let bag = DisposeBag()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!

    
    override func viewDidLoad() {
        tableView.rowHeight = 80
        super.viewDidLoad()
    }
    
    func bindViewModel() {
        let input = MemoListViewModel.Input(
            addButtonTap: addButton.rx.tap,
            memoCellSelected: tableView.rx.modelSelected(Memo.self))
        
        let output = viewModel.transform(input: input)
        
        output.tableViewDriver
            .drive(tableView.rx.items(cellIdentifier: MemoTableViewCell.reuseIdentifier, cellType: MemoTableViewCell.self)) {row, memo, cell in
                cell.titleLabel.text = memo.title                
                cell.dateLabel.text = memo.date.toDateString
            }
            .disposed(by: bag)
        
        output.presentMemoComposeVC
            .bind(onNext: presentMemoComposeVC)
            .disposed(by: bag)

        
        output.goToMemoDetailVC
            .subscribe(onNext: {[weak self] memo in
                self?.goToMemoDetailVC(memo)}
            )
            .disposed(by: bag)
        
    }
    
    private func goToMemoDetailVC(_ memo: Memo) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard var memoDetailVC = storyboard.instantiateViewController(withIdentifier: "MemoDetail") as? MemoDetailViewController else {
            fatalError()
        }
        memoDetailVC.bind(viewModel: MemoDetailViewModel(memo: memo, storage: self.viewModel.storage))
        
        self.navigationController?.pushViewController(memoDetailVC, animated: true)
    }
    
    private func presentMemoComposeVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard var composeNav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else {
            fatalError()
        }
        guard var memoComposeVC = composeNav.viewControllers.first as? MemoComposeViewController else {
            fatalError()
        }
        memoComposeVC.bind(viewModel: MemoComposeViewModel(storage: self.viewModel.storage))
        
        present(composeNav, animated: true)
    }
    
    private func goToSettingVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingVC = storyboard.instantiateViewController(withIdentifier: "Setting") as? SettingViewController else {
            fatalError()
        }
        
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}
