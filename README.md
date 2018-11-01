# URLNavigator 使用教程

本框架主要用于iOS客户端功能模块路由调度跳转。

使用场景：

+ 轮播广告跳转指定模块
+ 推送通知跳转指定模块
+ 消息中心跳转指定模块
+ 活动web交互跳转指定模块

## 安装URLNavigator

~~~
pod 'URLNavigator', '~> 2.1.0'
~~~

### [约定协议](Protocol.md)

## 原理解析
Navigator遵循了 NavigatorType 协议，并且主要实现了以下内容

###协议注册

~~~
  open func register(_ pattern: URLPattern, _ factory: @escaping ViewControllerFactory) {
    self.viewControllerFactories[pattern] = factory
  }
~~~
 pattern: 就是String类型的自定义协议 factory: 回调block

### 打开注册的协议
~~~
  public func push(_ url: URLConvertible, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
    return self.pushURL(url, context: context, from: from, animated: animated)
  }
~~~

NavigatorType 协议默认实现了push 最终调用的是

~~~
  public func pushURL(_ url: URLConvertible, context: Any? = nil, from: UINavigationControllerType? = nil, animated: Bool = true) -> UIViewController? {
    guard let viewController = self.viewController(for: url, context: context) else { return nil }
    return self.pushViewController(viewController, from: from, animated: animated)
  }
~~~

该方法主要回调注册时候的block，以便获取到需要被push的viewController，然后遍历当前视图viewController进行push

### 遍历当前视图viewController
~~~
 open class func topMost(of viewController: UIViewController?) -> UIViewController? {
    // presented view controller
    if let presentedViewController = viewController?.presentedViewController {
      return self.topMost(of: presentedViewController)
    }

    // UITabBarController
    if let tabBarController = viewController as? UITabBarController,
      let selectedViewController = tabBarController.selectedViewController {
      return self.topMost(of: selectedViewController)
    }

    // UINavigationController
    if let navigationController = viewController as? UINavigationController,
      let visibleViewController = navigationController.visibleViewController {
      return self.topMost(of: visibleViewController)
    }

    // UIPageController
    if let pageViewController = viewController as? UIPageViewController,
      pageViewController.viewControllers?.count == 1 {
      return self.topMost(of: pageViewController.viewControllers?.first)
    }

    // child view controller
    for subview in viewController?.view?.subviews ?? [] {
      if let childViewController = subview.next as? UIViewController {
        return self.topMost(of: childViewController)
      }
    }

    return viewController
  }
}
~~~
如果是present的则获取到presentedViewController，如果是UITabBarController则获取到当前选中的viewController，如果是导航栏则获取到当前可见的viewController，如果是UIPageViewController，则获取到当前viewController，最后递归遍历到当前的viewController

## 使用案例
### 定义NavigatorConfig管理自定义协议

~~~
import SafariServices
import UIKit
import URLNavigator

// 定义全局变量
let navigator = NavigatorConfig()

class NavigatorConfig: Navigator {
    static func initialize() {
        // 打开网址
        navigator.register("http://<path:_>", self.webViewControllerFactory)
        navigator.register("https://<path:_>", self.webViewControllerFactory)
        
        // 打开本地H5
        navigator.register("navigator://localH5/<target>", self.localH5Factory)
        
        // 打开本地模块
        navigator.register("navigator://transaction/detail") { (url, values, content) -> UIViewController? in
            guard let msg = url.queryParameters["msg"] else {
                return nil
            }
            guard let code = url.queryParameters["code"] else {
                return nil
            }
            
            let modelVC = TestViewController()
            modelVC.msg = msg
            modelVC.code = code
            return modelVC
        }
        
        navigator.handle("navigator://alert") { (url, values, content) -> Bool in
            guard let title = url.queryParameters["title"] else { return false }
            let message = url.queryParameters["message"]
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            navigator.present(alertController)
            return true
        }
    }
    
    private static func webViewControllerFactory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let url = url.urlValue else { return nil }
        return SFSafariViewController(url: url)
    }
    
    private static func localH5Factory(url: URLConvertible, values: [String: Any], context: Any?) -> UIViewController? {
        guard let target = values["target"] as? String else { return nil }
        var h5VC: UIViewController?
        switch target {
        case "help":
            h5VC = HelpWebViewController()
        case "agree":
            h5VC = AgreeWebViewController()
        default:
            break
        }
        return h5VC
    }
}

~~~

ViewController 调用演示

~~~
 let isPushed = navigator.push(user.urlString) != nil
        if isPushed {
            print("[Navigator] push: \(user.urlString)")
        } else {
            print("[Navigator] open: \(user.urlString)")
            navigator.open(user.urlString)
        }

~~~

如果是使用register注册的协议，则使用navigator.push进行调用，如果是使用handle进行协议注册，则使用navigator.open进行调用。
