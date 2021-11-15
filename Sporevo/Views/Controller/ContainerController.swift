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
    weak var delegate:ContainerControllerDelegate?
    // MARK: - Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMainController()
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
        let main = SporevoMainController()
        centerController = UINavigationController(rootViewController: main)
        main.delegate = self
        // CenterControllerのViewをsubViewに追加
        view.addSubview(centerController.view)
        //　子ビューとしてcenterControllerを追加
        addChild(centerController)
        // 親ビューにしっかり教えてあげる。
        centerController.didMove(toParent: self)
    }
    private func setupMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            view.insertSubview(menuController.view, at: 0)
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
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
}
// MARK: - SporevoMainControllerDelegate
extension ContainerController: SporevoMainControllerDelegate {
    func handleMenuToggle(forMenuOptions menuOptions: MenuOptions?) {
        print(#function)
        if !isExpanded {
            setupMenuController()
        }
        isExpanded = !isExpanded
        animatePanel(expand: isExpanded, menuOptions: menuOptions)
    }
}
