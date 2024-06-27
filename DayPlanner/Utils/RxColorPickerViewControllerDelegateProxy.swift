//
//  RxColorPickerViewControllerDelegateProxy.swift
//  DayPlanner
//
//  Created by 석기권 on 6/27/24.
//

import UIKit
import RxCocoa
import RxSwift

extension UIColorPickerViewController: HasDelegate {
    public typealias Delegate = UIColorPickerViewControllerDelegate
}

// HasDelegate를 채택한 경우에 기본구현을 제공
class RxColorPickerViewControllerDelegateProxy: DelegateProxy<UIColorPickerViewController, UIColorPickerViewControllerDelegate>, DelegateProxyType, UIColorPickerViewControllerDelegate {
    weak private(set) var uiColorPickerViewController: UIColorPickerViewController?
    
    init(uiColorPickerViewController: UIColorPickerViewController) {
        self.uiColorPickerViewController = uiColorPickerViewController
        super.init(parentObject: uiColorPickerViewController, delegateProxy: RxColorPickerViewControllerDelegateProxy.self)
    }
    
    // 필요시점에 자동적으로 호출됨
    // Proxy팩토리에 Proxy 저장
    static func registerKnownImplementations() {
        self.register {
            RxColorPickerViewControllerDelegateProxy(uiColorPickerViewController: $0)
        }
    }
}

extension Reactive where Base: UIColorPickerViewController {
    // 새로운 인스턴스를 생성시 문제가 발생할 수 있음 proxy(for) 메서드 사용
    var delegate: DelegateProxy<UIColorPickerViewController, UIColorPickerViewControllerDelegate> {
        return RxColorPickerViewControllerDelegateProxy.proxy(for: base)
    }
    
    var didSeleteColor: Observable<UIColor> {
        return delegate
            .methodInvoked(#selector(UIColorPickerViewControllerDelegate.colorPickerViewController(_:didSelect:continuously:)))
            .map { parameter in
                parameter[1] as! UIColor
            }
    }
}
