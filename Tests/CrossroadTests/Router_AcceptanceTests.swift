import Foundation
import XCTest
import Crossroad

final class Router_AcceptanceTests: XCTestCase {
    private let customURLScheme: LinkSource = .customURLScheme("pokedex")
    private let universalLink: LinkSource = .universalLink(URL(string: "https://my-awesome-pokedex.com")!)

    func testAcceptOnly() throws {
        let router = try SimpleRouter(accepts: [customURLScheme, universalLink]) { route in
            route("/pokemons/:id", accepts: .only(for: universalLink)) { _ in
                true
            }
        }

        XCTAssertFalse(router.responds(to: URL(string: "pokedex://pokemons/:id")!))
        XCTAssertTrue(router.responds(to: URL(string: "https://my-awesome-pokedex.com/pokemons/:id")!))
    }

    func testAcceptOnlyWithGroup() throws {
        let router = try SimpleRouter(accepts: [customURLScheme, universalLink]) { route in
            route.group(accepts: [universalLink]) { route in
                route("/pokemons/:id") { _ in
                    true
                }
            }

            route.group(accepts: [customURLScheme]) { route in
                route("/moves/:id") { _ in
                    true
                }
            }
        }

        XCTAssertFalse(router.responds(to: URL(string: "pokedex://pokemons/:id")!))
        XCTAssertTrue(router.responds(to: URL(string: "https://my-awesome-pokedex.com/pokemons/:id")!))
        XCTAssertTrue(router.responds(to: URL(string: "pokedex://moves/:id")!))
        XCTAssertFalse(router.responds(to: URL(string: "https://my-awesome-pokedex.com/moves/:id")!))
    }
}
