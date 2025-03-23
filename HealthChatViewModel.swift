import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let content: String
    let isUser: Bool
}

class HealthChatViewModel: ObservableObject {
    @Published var chatHistory: [ChatMessage] = []
    @Published var isLoading = false
    @Published var showFormatSelection = false
    
    private var userInfo: [String: String] = [:]
    private let apiService = HealthPlanAPIService()
    
    init() {
        // Add welcome message
        chatHistory.append(ChatMessage(
            content: "Welcome to LionWell! Please fill out your information to get started with your personalized health plan.",
            isUser: false
        ))
    }
    
    func submitUserInfo(_ info: [String: String]) {
        userInfo = info
        
        // Create initial message based on user info
        let initialPrompt = createInitialPrompt(from: info)
        sendToAPI(query: initialPrompt, additionalData: info)
        
        // Show format selection after initial response
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showFormatSelection = true
        }
    }
    
    func sendMessage(_ message: String) {
        // Add user message to chat
        chatHistory.append(ChatMessage(content: message, isUser: true))
        
        // Send to API with context
        sendToAPI(query: message, additionalData: userInfo)
    }
    
    func generatePlanWithFormat(_ format: String) {
        showFormatSelection = false
        isLoading = true
        
        let formatPrompt = """
        Please generate a health plan based on our previous conversation in \(format) format. 
        Include specific Penn State resources and recommendations.
        """
        
        let data: [String: Any] = [
            "query": formatPrompt,
            "health_metrics": userInfo,
            "format_type": format
        ]
        
        // Send to generate_health_plan endpoint
        apiService.generateHealthPlan(data: data) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    self?.chatHistory.append(ChatMessage(
                        content: response,
                        isUser: false
                    ))
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func createInitialPrompt(from info: [String: String]) -> String {
        return """
        I am a \(info["age"] ?? "")-year-old \(info["year"] ?? "") studying \(info["major"] ?? "") at Penn State. 
        I live \(info["living_location"] ?? ""). 
        Height: \(info["height"] ?? "") inches, Weight: \(info["weight"] ?? "") lbs
        Health Conditions: \(info["health_conditions"] ?? "None")
        Health Goals: \(info["health_goals"] ?? "")
        
        Please provide initial health recommendations and ask about my preferred format for the detailed plan.
        """
    }
    
    private func sendToAPI(query: String, additionalData: [String: String]) {
        isLoading = true
        
        let data: [String: Any] = [
            "query": query,
            "health_metrics": additionalData
        ]
        
        apiService.generateHealthPlan(data: data) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                switch result {
                case .success(let response):
                    self?.chatHistory.append(ChatMessage(
                        content: response,
                        isUser: false
                    ))
                case .failure(let error):
                    self?.handleError(error)
                }
            }
        }
    }
    
    private func handleError(_ error: Error) {
        let errorMessage = """
        I apologize, but I encountered an error while generating your health plan. 
        Please try again or rephrase your request.
        Error: \(error.localizedDescription)
        """
        
        chatHistory.append(ChatMessage(
            content: errorMessage,
            isUser: false
        ))
    }
} 
