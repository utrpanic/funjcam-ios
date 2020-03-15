import UIKit

class FJViewController: UIViewController {
    
    private var needSetupScene: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.updateNavigationBarAsTransparent()
        if self.needSetupScene {
            self.setupScene()
        }
    }
    
    func setupScene() {
        self.needSetupScene = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
}
