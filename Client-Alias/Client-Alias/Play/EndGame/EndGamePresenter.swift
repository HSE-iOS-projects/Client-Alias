protocol EndGameModuleInput: AnyObject {}

protocol EndGameModuleOutput: AnyObject {}

final class EndGamePresenter {
    // MARK: - Properties

    weak var view: EndGameViewInput?
    var router: EndGameRouterInput?
    weak var output: EndGameModuleOutput?

    var usedWords = [WordInfo]()

    init(data: [WordInfo]) {
        usedWords = data
    }
}

// MARK: - EndGameViewOutput

extension EndGamePresenter: EndGameViewOutput {
    func changeWordValue(index: Int, value: Int) {
        usedWords[index].value = value
    }

    func countUsedWords() -> Int {
        usedWords.count
    }

    func getUsedWord(index: Int) -> WordInfo {
        return usedWords[index]
    }

    func viewDidLoad() {}
}

// MARK: - EndGameInput

extension EndGamePresenter: EndGameModuleInput {}
