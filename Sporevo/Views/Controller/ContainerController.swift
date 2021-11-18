import Foundation
import UIKit
protocol ContainerControllerDelegate:AnyObject {
    func didTapMenuButton(_ options: MenuOptions)
}
class ContainerController:UIViewController {
    // MARK: - Properties
    var centerController:UIViewController!
    var menuController:MenuController!
    var isExpanded = false
    var scrollView:UIScrollView!
    weak var delegate:ContainerControllerDelegate?
    // MARK: - Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainController()
        setupMenuController()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    override var prefersStatusBarHidden: Bool {
        return isExpanded
    }
    // MARK: - setupMethod
    private func setupMainController() {
        let screenWidth = Int(UIScreen.main.bounds.size.width)
        scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.frame = self.view.frame
        scrollView.contentSize = CGSize(width: CGFloat(screenWidth) * 2.0,
                                        height: view.frame.height)
        view.addSubview(scrollView)
        scrollView.anchor(top:view.safeAreaLayoutGuide.topAnchor,
                          bottom: view.bottomAnchor,
                          left: view.leftAnchor,
                          right: view.rightAnchor)
        let main = SporevoMainController()
        centerController = UINavigationController(rootViewController: main)
        main.delegate = self
        // CenterControllerのViewをsubViewに追加
        scrollView.addSubview(centerController.view)
        //　子ビューとしてcenterControllerを追加
        addChild(centerController)
        // 親ビューにしっかり教えてあげる。
        centerController.didMove(toParent: self)
        let mapVC = SeachMapController()
        mapVC.view.frame = CGRect(x: view.frame.size.width, y: 0,
                                  width: scrollView.frame.width, height: view.frame.size.height)
        scrollView.addSubview(mapVC.view)
        addChild(mapVC)
        mapVC.didMove(toParent: mapVC)
    }
    private func setupMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            scrollView.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: menuController)
        }
    }
    private func animatePanel(expand:Bool,menuOptions:MenuOptions?) {
            if expand {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.centerController.view.frame.origin.x = self.centerController.view.frame.width - 200
                }, completion: nil)
            } else {
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.centerController.view.frame.origin.x = 0
                }) { _ in
                    guard let menuOptions = menuOptions else {
                        return
                    }
                    self.didSelectMenuOption(menuOption: menuOptions)
                }
            }
        }
    private func didSelectMenuOption(menuOption: MenuOptions) {
        print(#function)
        let controller = SearchDetailController()
        present(controller, animated: true, completion: nil)
    }
}
// MARK: - SporevoMainControllerDelegate
extension ContainerController: SporevoMainControllerDelegate {
    func handleSegmentController(selectedIndex: Int) {
        let controller = SeachMapController()
        controller.modalPresentationStyle = .fullScreen
        present(controller, animated: false, completion: nil)
    }
    
    func handleMenuToggle(forMenuOptions menuOptions: MenuOptions?) {
        print(#function)
        if !isExpanded {
            setupMenuController()
        }
        isExpanded = !isExpanded
        animatePanel(expand: isExpanded, menuOptions: menuOptions)
    }
}

class SeachMapController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
