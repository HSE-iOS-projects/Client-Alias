protocol PlayRoundModuleInput: AnyObject {}

protocol PlayRoundModuleOutput: AnyObject {}

final class PlayRoundPresenter {
    // MARK: - Properties

    weak var view: PlayRoundViewInput?
    var router: PlayRoundRouterInput?
    weak var output: PlayRoundModuleOutput?
    var roundCount: Int = 1
    var wordIndex = -1
    var allWords = [
        WordInfo(word: "Рука", index: 0),
        WordInfo(word: "Нога", index: 1),
        WordInfo(word: "Кружка", index: 2),
        WordInfo(word: "Чай", index: 3),
        WordInfo(word: "BTS", index: 4),
        WordInfo(word: "Китай", index: 5),
    ]

    var usedWords = [WordInfo]()
}

// MARK: - PlayRoundViewOutput

extension PlayRoundPresenter: PlayRoundViewOutput {
    func changeWordValue(index: Int, value: Int) {
        allWords[index].value = value
    }

    func rightSwipe(index: Int) {
        usedWords.append(allWords[index])
    }

    func leftSwipe(index: Int) {
        let currentWord = allWords[index]
        usedWords.append(WordInfo(word: currentWord.word, index: currentWord.index, value: 0))
    }

    func getNextCardText() -> WordInfo {
        wordIndex += 1
        if wordIndex == allWords.count {
            wordIndex = 0
        }
        return allWords[wordIndex]
    }

    func viewDidLoad() {
        view?.displayInfo(data: RoundInfo(roundNum: String(roundCount), team: "Win Win HI", timeSeconds: 130))
    }
}

// MARK: - PlayRoundInput

extension PlayRoundPresenter: PlayRoundModuleInput {}
