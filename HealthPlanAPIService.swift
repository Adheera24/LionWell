import Foundation

enum HealthPlanAPIError: Error {
    case invalidURL
    case noData
    case decodingError
    case networkError(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid API URL"
        case .noData:
            return "No data received from server"
        case .decodingError:
            return "Error processing server response"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}

class HealthPlanAPIService {
    private let baseURL = "http://10.169.84.115:5001"
    
    func generateHealthPlan(data: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/generate_health_plan") else {
            completion(.failure(HealthPlanAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(HealthPlanAPIError.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(HealthPlanAPIError.noData))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let response = json["response"] as? String {
                    completion(.success(response))
                } else {
                    completion(.failure(HealthPlanAPIError.decodingError))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Fallback query endpoint if generate_health_plan fails
    func query(message: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/query") else {
            completion(.failure(HealthPlanAPIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = ["query": message]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(HealthPlanAPIError.networkError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(HealthPlanAPIError.noData))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let answer = json["answer"] as? String {
                    completion(.success(answer))
                } else {
                    completion(.failure(HealthPlanAPIError.decodingError))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
} 
