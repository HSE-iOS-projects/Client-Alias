import Foundation

class RoomsViewModel {

    let activeRoom: Room?
    let openRooms: [Room]

    init(activeRoom: Room? = nil, openRooms: [Room]) {
        self.activeRoom = activeRoom
        self.openRooms = openRooms
    }
}

extension RoomsViewModel: Equatable {
    
    static func == (lhs: RoomsViewModel, rhs: RoomsViewModel) -> Bool {
        lhs.activeRoom == rhs.activeRoom && lhs.openRooms == rhs.openRooms
    }
}
