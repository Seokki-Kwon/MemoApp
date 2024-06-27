//
//  MainViewController.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/25/24.
//

import UIKit
import RxCocoa
import RxSwift

class MainViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var settingButton: UIBarButtonItem!
    @IBOutlet weak var navTitle: UIBarButtonItem!
    
    @IBOutlet weak var shadowView: UIView!
    private let bag = DisposeBag()
    
    var viewModel: MainViewModel!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 2
        shadowView.layer.masksToBounds = false
        shadowView.layer.cornerRadius = 16
        shadowView.layer.backgroundColor = UIColor.white.cgColor
    }
    
    private lazy var subViewControllers: [UIViewController] = {
        // binding
        var memoListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemoList") as! MemoListViewController
        let storage = CoreDataStorage(modelName: "MemoApp")
        let viewModel = MemoListViewModel(storage: storage)
        memoListVC.bind(viewModel: viewModel)
        return [
            memoListVC,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MemoCalender") as! CalenderViewController,
        ]
    }()
    private var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavTitle()
        setPageViewLayout()
    }
    
    private func setNavTitle() {
        let font = UIFont.systemFont(ofSize: 18, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font
        ]
        navTitle.setTitleTextAttributes(attributes, for: .normal)
    }
    
    private func setPageViewLayout() {
        // pageViewController Setting
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        addChild(pageViewController)
        containerView.addSubview(pageViewController.view)
        pageViewController.view.frame = containerView.bounds
        pageViewController.didMove(toParent: self)
        
        pageViewController.setViewControllers([subViewControllers[0]], direction: .forward, animated: true)
    }
}

extension MainViewController: BindableType {
    
    func bindViewModel() {
        // binding
        let input = MainViewModel.Input(settingButtonTap: settingButton.rx.tap,
                                        segmentSeleted: segmentedControl.rx.selectedSegmentIndex)
        
        let output = viewModel.transform(input: input)
        
        output.goToSettingVC
            .subscribe(onNext: goToSettingVC)
            .disposed(by: bag)
        
        output.movePage
            .drive(onNext: setPage)
            .disposed(by: bag)
        
        output.movePage
            .map { $0 == 0 ? "다가오는 일정" : "캘린더"}
            .drive(navTitle.rx.title)
            .disposed(by: bag)
        
    }
    
    private func setPage(_ index: Int) {
        var direction: UIPageViewController.NavigationDirection
        let willShownViewController = subViewControllers[index]
        if let _ = willShownViewController as? MemoListViewController {
            direction = .reverse
        } else {
            direction = .forward
        }
        pageViewController.setViewControllers([subViewControllers[index]], direction: direction, animated: true)
    }
    
    private func goToSettingVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let settingVC = storyboard.instantiateViewController(withIdentifier: "Setting") as? SettingViewController else {
            fatalError()
        }
        
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}


