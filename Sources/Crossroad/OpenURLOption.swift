#if os(iOS)

import Foundation
import UIKit

public typealias ApplicationOpenURLOptions = [UIApplication.OpenURLOptionsKey: Any]

// https://developer.apple.com/documentation/uikit/uiapplicationopenurloptionskey
public struct OpenURLOption {
    public let sourceApplication: String?
    public let annotation: Any?
    public let openInPlace: Bool

    public init(options: ApplicationOpenURLOptions) {
        self.sourceApplication = options[.sourceApplication] as? String
        self.annotation = options[.annotation]
        self.openInPlace = options[.openInPlace] as? Bool ?? false
    }

    @available(iOS 13.0, *)
    public init(options: UIScene.OpenURLOptions) {
        self.sourceApplication = options.sourceApplication
        self.annotation = options.annotation
        self.openInPlace = options.openInPlace
    }
}

public typealias DefaultRouter = Router<OpenURLOption>

public extension Router where UserInfo == OpenURLOption {
    @discardableResult
    func openIfPossible(_ url: URL, options: ApplicationOpenURLOptions) -> Bool {
        return openIfPossible(url, userInfo: OpenURLOption(options: options))
    }

    func responds(to url: URL, options: ApplicationOpenURLOptions) -> Bool {
        return responds(to: url, userInfo: OpenURLOption(options: options))
    }
}

@available(iOS 13.0, *)
extension Router where UserInfo == OpenURLOption {
    @discardableResult
    public func openIfPossible(_ url: URL, options: UIScene.OpenURLOptions) -> Bool {
        return openIfPossible(url, userInfo: OpenURLOption(options: options))
    }

    public func responds(to url: URL, options: UIScene.OpenURLOptions) -> Bool {
        return responds(to: url, userInfo: OpenURLOption(options: options))
    }
}

extension Context where UserInfo == OpenURLOption {
    public var options: OpenURLOption {
        userInfo
    }
}

#endif
