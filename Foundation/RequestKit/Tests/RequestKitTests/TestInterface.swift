import RequestKit

class TestInterfaceConfiguration: Configuration {
    var apiEndpoint: String
    var errorDomain = "com.nerdishbynature.RequestKitTests"
    var accessToken: String?

    init(url: String) {
        apiEndpoint = url
    }
}

class TestInterface {
    var configuration: Configuration {
        TestInterfaceConfiguration(url: "https://example.com")
    }

    func postJSON(_ session: RequestKitURLSession, completion: @escaping (_ response: Response<[String: AnyObject]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = JSONTestRouter.testPOST(configuration)
        return router.postJSON(session, expectedResultType: [String: AnyObject].self) { json, error in
            if let error {
                completion(Response.failure(error))
            } else {
                if let json {
                    completion(Response.success(json))
                }
            }
        }
    }

    func getJSON(_ session: RequestKitURLSession, completion: @escaping (_ response: Response<[String: String]>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = JSONTestRouter.testGET(configuration)
        return router.load(session, expectedResultType: [String: String].self) { json, error in
            if let error {
                completion(Response.failure(error))
            } else {
                if let json {
                    completion(Response.success(json))
                }
            }
        }
    }

    func loadAndIgnoreResponseBody(_ session: RequestKitURLSession, completion: @escaping (_ response: Response<Void>) -> Void) -> URLSessionDataTaskProtocol? {
        let router = JSONTestRouter.testPOST(configuration)
        return router.load(session) { error in
            if let error {
                completion(Response.failure(error))
            } else {
                completion(Response.success(()))
            }
        }
    }
}

enum JSONTestRouter: JSONPostRouter {
    case testPOST(Configuration)
    case testGET(Configuration)

    var configuration: Configuration {
        switch self {
        case let .testPOST(config): config
        case let .testGET(config): config
        }
    }

    var method: HTTPMethod {
        switch self {
        case .testPOST:
            .POST
        case .testGET:
            .GET
        }
    }

    var encoding: HTTPEncoding {
        switch self {
        case .testPOST:
            .json
        case .testGET:
            .json
        }
    }

    var path: String {
        switch self {
        case .testPOST:
            "some_route"
        case .testGET:
            "some_route"
        }
    }

    var params: [String: Any] {
        switch self {
        case .testPOST:
            [:]
        case .testGET:
            [:]
        }
    }
}
