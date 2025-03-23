import SwiftUI

struct HealthChatView: View {
    @StateObject private var viewModel = HealthChatViewModel()
    @State private var showingHealthForm = true // Show form first
    
    var body: some View {
        VStack {
            if showingHealthForm {
                HealthInfoFormView(
                    viewModel: viewModel,
                    isPresented: $showingHealthForm
                )
            } else {
                ChatInterface(viewModel: viewModel)
            }
        }
        .navigationTitle("Health Assistant")
    }
}

struct HealthInfoFormView: View {
    @ObservedObject var viewModel: HealthChatViewModel
    @Binding var isPresented: Bool
    
    @State private var height = ""
    @State private var weight = ""
    @State private var age = ""
    @State private var livingLocation = "On Campus"
    @State private var major = ""
    @State private var yearInCollege = "Freshman"
    @State private var healthConditions = ""
    @State private var healthGoals = ""
    
    let livingOptions = ["On Campus", "Off Campus"]
    let yearOptions = ["Freshman", "Sophomore", "Junior", "Senior", "Graduate"]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Tell us about yourself")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Basic Information
                Group {
                    TextField("Height (in inches)", text: $height)
                        .keyboardType(.numberPad)
                    TextField("Weight (in lbs)", text: $weight)
                        .keyboardType(.numberPad)
                    TextField("Age", text: $age)
                        .keyboardType(.numberPad)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Academic Information
                Group {
                    Picker("Living Situation", selection: $livingLocation) {
                        ForEach(livingOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    TextField("Major", text: $major)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("Year", selection: $yearInCollege) {
                        ForEach(yearOptions, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                // Health Information
                Group {
                    Text("Health Conditions")
                        .font(.headline)
                    TextEditor(text: $healthConditions)
                        .frame(height: 100)
                        .border(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    
                    Text("Health Goals")
                        .font(.headline)
                    TextEditor(text: $healthGoals)
                        .frame(height: 100)
                        .border(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                
                Button(action: submitForm) {
                    Text("Start Health Plan Generation")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top)
            }
            .padding()
        }
    }
    
    private func submitForm() {
        let userInfo = [
            "height": height,
            "weight": weight,
            "age": age,
            "living_location": livingLocation,
            "major": major,
            "year": yearInCollege,
            "health_conditions": healthConditions,
            "health_goals": healthGoals
        ]
        
        viewModel.submitUserInfo(userInfo)
        isPresented = false
    }
}

struct ChatInterface: View {
    @ObservedObject var viewModel: HealthChatViewModel
    @State private var userInput = ""
    
    var body: some View {
        VStack {
            // Chat history
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 15) {
                    ForEach(viewModel.chatHistory) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            
            // Loading indicator
            if viewModel.isLoading {
                ProgressView("Generating response...")
                    .padding()
            }
            
            // Input area
            VStack(spacing: 10) {
                if viewModel.showFormatSelection {
                    FormatSelectionView(viewModel: viewModel)
                } else {
                    HStack {
                        TextField("Type your message...", text: $userInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action: sendMessage) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.blue)
                        }
                        .disabled(userInput.isEmpty || viewModel.isLoading)
                    }
                }
            }
            .padding()
        }
    }
    
    private func sendMessage() {
        guard !userInput.isEmpty else { return }
        viewModel.sendMessage(userInput)
        userInput = ""
    }
}

struct FormatSelectionView: View {
    @ObservedObject var viewModel: HealthChatViewModel
    
    var body: some View {
        VStack(spacing: 10) {
            Text("How would you like your health plan formatted?")
                .font(.headline)
            
            Button("Detailed Paragraphs") {
                viewModel.generatePlanWithFormat("paragraphs")
            }
            .buttonStyle(.bordered)
            
            Button("Bullet Points") {
                viewModel.generatePlanWithFormat("bullets")
            }
            .buttonStyle(.bordered)
            
            Button("Daily Schedule") {
                viewModel.generatePlanWithFormat("schedule")
            }
            .buttonStyle(.bordered)
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            
            Text(message.content)
                .padding()
                .background(message.isUser ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(message.isUser ? .white : .primary)
                .cornerRadius(12)
            
            if !message.isUser {
                Spacer()
            }
        }
    }
} 
