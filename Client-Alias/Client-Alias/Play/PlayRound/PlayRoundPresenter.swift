import Foundation

struct PlayRoundInfo {
    let roomID: UUID
    var isAdmin: Bool
}

protocol PlayRoundModuleInput: AnyObject {}

protocol PlayRoundModuleOutput: AnyObject {}

final class PlayRoundPresenter {
    // MARK: - Properties

    weak var view: PlayRoundViewInput?
    var router: PlayRoundRouterInput?
    weak var output: PlayRoundModuleOutput?
    var roundCount: Int = 1
    var wordIndex = -1
    var allWords: [WordInfo]
    var usedWords: [[WordInfo]] = []
    var isPlaying = false
    let worker: PlayWorker
    let roomIfo: PlayRoundInfo

    init(words: [String], worker: PlayWorker, room: PlayRoundInfo) {
        var wordsInfo = [WordInfo]()
        for i in 0 ..< words.count {
            wordsInfo.append(WordInfo(word: words[i], index: i))
        }
        self.allWords = wordsInfo
        self.worker = worker
        self.roomIfo = room
    }
}

// MARK: - PlayRoundViewOutput

extension PlayRoundPresenter: PlayRoundViewOutput {
    func stopGame() {
        view?.stopGame(isPlaying: isPlaying)
    }

    func continueGame() {
        view?.continueGame(isPlaying: isPlaying)
    }

    func isAdmin() -> Bool {
        roomIfo.isAdmin
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
        var points = 0
        if usedWords.count < roundCount {
            for _ in usedWords.count...roundCount {
                usedWords.append([])
            }
        }
        for k in usedWords[roundCount - 1] {
            points += k.value
        }
        worker.nextRound(request: NextRoundRequest(points: points, roomID: roomIfo.roomID)) { result in
            switch result {
            case .success:
                print("New ROund")
            case .failure(let error):
                print("No New ROund")
                print(error.localizedDescription)
            }
        }
        roundCount += 1
    }

    func viewDidLoad() {
        if allWords.isEmpty {
            view?.waitForGame(data: RoundInfo(roundNum: String(roundCount), team: "Win Win HI", timeSeconds: 10))
            isPlaying = false
        } else {
            view?.displayInfo(data: RoundInfo(roundNum: String(roundCount), team: "Win Win HI", timeSeconds: 10))
            isPlaying = true
        }
    }

    private func createInfo() -> [WordInfo] {
        var info = [WordInfo]()
        usedWords.forEach { item in
            info += item
        }
        return info
    }
}

// MARK: - PlayRoundInput

extension PlayRoundPresenter: PlayRoundModuleInput {}
