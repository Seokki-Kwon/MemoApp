//
//  MainPageViewController.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/24/24.
//

import UIKit
import RxCocoa
import RxSwift

class MainPageViewController: UIPageViewController, UIPageViewControllerDataSource, BindableType {
    var viewModel: MainPageViewModel!
    private let bag = DisposeBag()
    
    func bindViewModel() {
            
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex <= 0 {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.firstIndex(of: viewController) ?? 0
        if currentIndex >= subViewControllers.count - 1 {
            return nil
        }
        return subViewControllers[currentIndex + 1]
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        setViewControllers([subViewControllers[0]], direction: .forward, animated: true)
        
        view.backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
    }
    
    func goToSettingVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let settingVC = storyboard.instantiateViewController(withIdentifier: "Setting") as? SettingViewController else {
                    fatalError()
                }
                
        self.navigationController?.pushViewController(settingVC, animated: true)
    }
}
