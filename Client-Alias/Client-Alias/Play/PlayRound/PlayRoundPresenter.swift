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

    var usedWords: [[WordInfo]] = []
    var isPlaying = false
}

// MARK: - PlayRoundViewOutput

extension PlayRoundPresenter: PlayRoundViewOutput {
    func stopGame() {
        // мб захотим показать алёрт
        // TODO: - отправить на сервер запрос о остановке
        view?.stopGame(isPlaying: isPlaying)
    }
    
    func continueGame() {
        // TODO: - отправить на сервер запрос о продолжениее
        view?.continueGame(isPlaying: isPlaying)
    }
    
    func countUsedWords() -> Int {
        if usedWords.count < roundCount {
            return 0
        }
        return usedWords[roundCount - 1].count
    }
    
    func getUsedWord(index: Int) -> WordInfo {
       return usedWords[roundCount - 1][index]
    }
    
    func changeWordValue(index: Int, value: Int) {
        allWords[index].value = value
    }

    func rightSwipe(index: Int) {
        if usedWords.count < roundCount {
            for _ in usedWords.count...roundCount {
                usedWords.append([])
            }
            
        }
        usedWords[roundCount - 1].append(allWords[index])
    
    }

    func leftSwipe(index: Int) {
        let currentWord = allWords[index]
        if usedWords.count < roundCount {
            for _ in usedWords.count...roundCount {
                usedWords.append([])
            }
        }
        usedWords[roundCount - 1].append(WordInfo(word: currentWord.word, index: currentWord.index, value: 0))
    }

    func getNextCardText() -> WordInfo {
        wordIndex += 1
        if wordIndex == allWords.count {
            wordIndex = 0
        }
        return allWords[wordIndex]
    }

    func continueNextRound() {
        // TODO: - проверка что не все раунды закончились, отправка данных, получение новых слов мб, а если все то другой экран
        roundCount += 1
        if roundCount == 3 {
            router?.openEndGameController(data: createInfo())
        } else {
            view?.displayInfo(
                data:
                    RoundInfo(
                        roundNum: String(roundCount),
                        team: "Win Win HI",
                        timeSeconds: 5
                    )
            )
        }
    }
    
    func viewDidLoad() {
//        view?.waitForGame(data: RoundInfo(roundNum: String(roundCount), team: "Win Win HI", timeSeconds: 5))
        view?.displayInfo(data: RoundInfo(roundNum: String(roundCount), team: "Win Win HI", timeSeconds: 5))
    }
    
    private func createInfo() -> [WordInfo]{
        var info = [WordInfo]()
        usedWords.forEach { item in
            info += item
        }
        return info
    }
}

// MARK: - PlayRoundInput

extension PlayRoundPresenter: PlayRoundModuleInput {}
