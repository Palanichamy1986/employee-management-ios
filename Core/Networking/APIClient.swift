import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case decodingError
    case networkError(Error)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .unauthorized:
            return "Unauthorized. Please login again."
        case .forbidden:
            return "Access denied"
        case .notFound:
            return "Resource not found"
        case .serverError:
            return "Server error. Please try again later."
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let error):
            return error.localizedDescription
        case .unknown:
            return "An unknown error occurred"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

final class APIClient {
    static let shared = APIClient()
    
    private let baseURL = "https://api.example.com"
    private let keychainManager = KeychainManager.shared
    private let logger = Logger.shared
    
    private var isRefreshing = false
    private var refreshWaiters: [CheckedContinuation<String, Error>] = []
    
    private init() {}
    
    func request<T: Decodable>(
        endpoint: APIEndpoint,
        method: HTTPMethod,
        body: Encodable? = nil,
        responseType: T.Type
    ) async throws -> T {
        let url = URL(string: baseURL + endpoint.path)!
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = try keychainManager.getAccessToken() {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = body {
            request.httpBody = try JSONEncoder().encode(body)
        }
        
        logger.debug("Request: \(method.rawValue) \(url.absoluteString)")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.unknown
            }
            
            logger.debug("Response: \(httpResponse.statusCode)")
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    return try JSONDecoder().decode(T.self, from: data)
                } catch {
                    logger.error("Decoding error: \(error.localizedDescription)")
                    throw NetworkError.decodingError
                }
                
            case 401:
                if isRefreshing {
                    return try await withCheckedThrowingContinuation { continuation in
                        refreshWaiters.append(continuation)
                    }
                }
                
                isRefreshing = true
                do {
                    let newAccessToken = try await refreshAccessToken()
                    isRefreshing = false
                    
                    refreshWaiters.forEach { $0.resume(returning: newAccessToken) }
                    refreshWaiters.removeAll()
                    
                    return try await request(
                        endpoint: endpoint,
                        method: method,
                        body: body,
                        responseType: T.self
                    )
                } catch {
                    isRefreshing = false
                    refreshWaiters.forEach { $0.resume(throwing: error) }
                    refreshWaiters.removeAll()
                    throw NetworkError.unauthorized
                }
                
            case 403:
                throw NetworkError.forbidden
            case 404:
                throw NetworkError.notFound
            case 500...599:
                throw NetworkError.serverError
            default:
                throw NetworkError.unknown
            }
        } catch let error as NetworkError {
            throw error
        } catch {
            logger.error("Network error: \(error.localizedDescription)")
            throw NetworkError.networkError(error)
        }
    }
    
    private func refreshAccessToken() async throws -> String {
        let authRepository = AuthRepository(apiClient: self)
        return try await authRepository.refreshToken()
    }
}
