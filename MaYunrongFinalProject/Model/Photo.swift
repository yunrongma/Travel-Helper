import Foundation
import UIKit

class Photo: Codable {
    var tripId: Int
    var identifiers: [String]
    
    init()
    {
        self.tripId = -1;
        self.identifiers = [String]()
    }
    
    init(tripId: Int,identifiers: [String]) {
        self.tripId = tripId
        self.identifiers = identifiers
    }
}
