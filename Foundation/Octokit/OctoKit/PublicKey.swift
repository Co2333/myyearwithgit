import Foundation
import RequestKit
#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

// MARK: request

public extension Octokit {
    func postPublicKey(_ session: RequestKitURLSession = URLSession.shared, publicKey: String, title: String, completion: @escaping (_ response: Response<String>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = PublicKeyRouter.postPublicKey(publicKey, title, configuration)
        return router.postJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error {
                completion(Response.failure(error))
            } else {
                if let _ = json {
                    completion(Response.success(publicKey))
                }
            }
        }
    }
}

enum PublicKeyRouter: JSONPostRouter {
    case postPublicKey(String, String, Configuration)

    var configuration: Configuration {
        switch self {
        case let .postPublicKey(_, _, config): config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .postPublicKey:
            .POST
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .postPublicKey:
            .json
        }
    }

    var path: String {
        switch self {
        case .postPublicKey:
            "user/keys"
        }
    }

    var params: [String: Any] {
        switch self {
        case let .postPublicKey(publicKey, title, _):
            ["title": title, "key": publicKey]
        }
    }
}
