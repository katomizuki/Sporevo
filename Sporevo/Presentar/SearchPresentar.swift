import Foundation
protocol SearchListInputs {
    func viewDidLoad(_ tojudgeKeywordOptions:SearchOptions)
    func didTapCell()
}
protocol SearchListOutputs:AnyObject {
    
}

struct SearchListPresentar:SearchListInputs {

    private weak var outputs:SearchListOutputs!
    private var model:FetchFacilityInputs!
    
    init(outputs:SearchListOutputs,model:FetchFacilityInputs) {
        self.outputs = outputs
        self.model = model
    }
    func didTapCell() {
        
    }
    func viewDidLoad(_ tojudgeKeywordOptions: SearchOptions) {
        switch tojudgeKeywordOptions {
        case .place:
            <#code#>
        case .institution:
            <#code#>
        case .competition:
            <#code#>
        case .price:
            <#code#>
        case .tag:
            <#code#>
        }
    }
}
