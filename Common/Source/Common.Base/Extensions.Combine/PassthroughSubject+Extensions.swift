//
//  Created by Ricardo P Santos on 2019.
//  Copyright © 2019 Ricardo P Santos. All rights reserved.
//

import Combine

public typealias Trigger = PassthroughSubject<Void, Never>

extension PassthroughSubject where Output == Void, Failure: Error {
    func trigger() {
        send(())
    }
}
