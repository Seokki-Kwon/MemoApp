//
//  RxPageViewControllerDataSourceProxy.swift
//  MemoAppPratice
//
//  Created by 석기권 on 6/24/24.
//

import UIKit
import RxSwift
import RxCocoa

extension UIPageViewController: HasDataSource {
    public typealias DataSource = UIPageViewControllerDataSource
}

class RxPageViewControllerDataSourceProxy: DelegateProxy<UIPageViewController, UIPageViewControllerDataSource>, DelegateProxyType {
    weak private(set) var pageViewController: UIPageViewController?
    static func registerKnownImplementations() {
        self.register {
            RxPageViewControllerDataSourceProxy(pageViewController: $0)
        }
    }
    
    init(pageViewController: UIPageViewController) {
        self.pageViewController = pageViewController
        super.init(parentObject: pageViewController, delegateProxy: RxPageViewControllerDataSourceProxy.self)
    }
}

extension RxPageViewControllerDataSourceProxy: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }
}

extension Reactive where Base: UIPageViewController {
    var dataSource: DelegateProxy<UIPageViewController, UIPageViewControllerDataSource> {
        return RxPageViewControllerDataSourceProxy.proxy(for: base)
    }
    
}


