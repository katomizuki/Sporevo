import Foundation
import UIKit
class ContainerController:UIViewController {
    
    // MARK: - Properties
    var centerController:UIViewController!
    var menuController:MenuController!
    var isExpanded = false
    // MARK: - Initialize
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func setupMainController() {
        let main = SporevoMainController()
        centerController = UINavigationController(rootViewController: main)
        view.addSubview(menuController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
    }
    private func animatePanel(expanded: Bool ,menuOptions: MenuOptions) {
        
    }
    
}
