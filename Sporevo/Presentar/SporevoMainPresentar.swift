
import Foundation
protocol SporevoMainInputs {
    func viewdidLoad()
    func didTapDetailSearchButton()
    func didTapSegment(index:Int)
}
protocol SporevoMainOutputs:AnyObject {
    func loadData()
    func detailSearchController()
    func changeSegment(index:Int)
}
final class SporevoMainPresentar:SporevoMainInputs {
    
    
    private weak var outputs:SporevoMainOutputs!
    init(outputs:SporevoMainOutputs) {
        self.outputs = outputs
    }
    
    func viewdidLoad() {
        self.outputs.loadData()
    }
    
    func didTapDetailSearchButton() {
        outputs.detailSearchController()
    }
    func didTapSegment(index:Int) {
        self.outputs.changeSegment(index: index)
    }
    
}
