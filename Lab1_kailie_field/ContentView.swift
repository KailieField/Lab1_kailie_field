import SwiftUI
//------------[ LAB TEST 1 || KAILIE FIELD| 100627702 ]------------

// ---------------------------[ WELCOME VIEW ]---------------------------

struct ContentView: View {
    @State private var presentWelcomeScreen = true
    
    var body: some View {
        
        ZStack {
            
            if presentWelcomeScreen {
                
                WelcomeView(presentWelcomeScreen: $presentWelcomeScreen)
            }else{
                QuizView()
            }
        }
    }
}

struct WelcomeView: View {
    
    @Binding var presentWelcomeScreen: Bool
    
    var body: some View {
        ZStack {
            Color.teal.opacity(0.4).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                
                Spacer()
                
                Image("rabbit")
                    .resizable()
                    .frame(width: 250, height: 250)
                    .scaledToFit()
                    .padding(.top, 250)
                    
                Spacer()
                    Text("Prime Time")
                    .font(.custom("AvenirNext-DemiBold", size: 24))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(10)
                
                Button(action: {
                    presentWelcomeScreen = false
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.7))
                            .frame(width: 100, height: 100)
                        Text("Hop In")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                }
                .shadow(radius: 10)
                Spacer()
            }
        }
    }
}





// ------------------------[ THE PRIME QUIZ VIEW ]------------------------
// --- [ HELPER FUNCTIONS ] ---
// --- prime number logic ---
func checkPrime(_ number: Int) -> Bool {
    
    if number < 2 {
        
        return false
    }
    for i in 2..<Int(sqrt(Double(number)) + 1){
        
        if number % i == 0 {
            return false
        }
        
    }
    return true
}

// --- [ FLIPPING ANSWER BUTTON ] ---
// -- ** If user does not choose a number within 5 second timer default,
//       will be recorded as an incorrect answer in score card **
func flipButton(
    
    isPrime: Bool,
    isFlipped: Bool,
    isPrimeNumber: Bool,
    feedback: String,
    action: @escaping () -> Void
    
) -> some View{
    
    ZStack {
        Circle()
            .fill(isFlipped && isPrimeNumber == isPrime ?
                  (feedback == "✅" ? Color.green : Color.red) : Color.yellow.opacity(0.7))
            .frame(height: 150)
            .shadow(radius: 100)
            .rotation3DEffect( // --adding an animation to flip button
                Angle(
                    degrees: isFlipped && isPrimeNumber == isPrime ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                
            )
            .animation(.easeInOut, value: isFlipped)
        
        if isFlipped && isPrimeNumber == isPrime {
            
            Text(feedback)
                .font(.largeTitle)
                .foregroundColor(.black)
                .transition(.opacity)
            
        } else {
            Text(isPrime ? "PRIME" : "NOT PRIME")
                .font(.headline)
                .foregroundColor(.black)
            
        }
    }
    .onTapGesture {
        action()
        
    }
}


// --- [ MAIN VIEW || QUIZ ] ---

struct QuizView : View {
    @State private var testNumber = Int.random(in: 1...100)
    @State private var timerDefault = 5
    @State private var correctScore = 0
    @State private var incorrectScore = 0
    @State private var attempts = 0
    @State private var feedback = ""
    @State private var timer : Timer? = nil
    @State private var revealResult = false
    @State private var isFlipped = false
    @State private var isPrimeNumber = false
    
    var body: some View {
        ZStack {
            // bottom left alignment for the timer -- test -- removed as it is not a requirement that the timer be visible for submission, just had for own awareness.
            Color.teal.opacity(0.3).edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30){
                
                // -- quiz number display
                Text("\(testNumber)")
                    .font(.system(size: 100, weight: .bold))
                    .foregroundColor(.primary)
                    .padding(.top, 250)
                
                // -- quiz question
                Text("Is this a Prime Number?")
                    .font(.custom("AvenirNext-DemiBold", size: 24))
                    .foregroundColor(.black)
                    .padding(.top, 30)
                
                // -- answer selection
                HStack(spacing: 30) {
                    flipButton(
                        
                        isPrime: true,
                        isFlipped: isFlipped,
                        isPrimeNumber: isPrimeNumber,
                        feedback: feedback
                        
                    ) {
                        
                        checkAnswer(true)
                        
                    }
                    
                    flipButton(
                        
                        isPrime: false,
                        isFlipped: isFlipped,
                        isPrimeNumber: isPrimeNumber,
                        feedback: feedback
                        
                    ) {
                        
                        checkAnswer(false)
                        
                    }
                    
                }
                .padding()
            }
//            VStack {
///*                Spacer()*/ // trying out spacer as per documentation suggestion
//                HStack { // adding HStack to isolate its movements
////                    Text("TIMER: \(timerDefault)")
////                        .font(.title)
////                        .foregroundColor(timerDefault <= 3 ? .red : .primary)
////                        .padding(.leading, 16) // space from left edge
////                        .padding(.bottom, 16) // space from bottom edge
////                    Spacer()
//                }
//            }
        }
        .ignoresSafeArea(edges: .all) // pushing to the very bottom left
        .onAppear {
                
                startQuiz()
            
        }
        .alert(isPresented: $revealResult){
            
                Alert(
                    
                    title: Text("SCORE"),
                    message: Text(
                        
                    "Correct: \(correctScore)\nIncorrect: \(incorrectScore)"),
                    dismissButton: .default(Text("RESTART"), action: startQuiz)
                    
                )
                
            }
            
        }
    

    // --- [ QUIZ LOGIC ] ---
    
    func resetTimer(){
        
        timer?.invalidate()
        timerDefault = 5
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){
            
            _ in timerDefault -= 1
            
            if timerDefault == 0 {
                
                timer?.invalidate()
                recordScore()
                
            }
        }
    }
    
    // --- [ SCORE CARD LOGIC ] ---
    func recordScore (){
        
        incorrectScore += 1
        feedback = "❌"
        attempts += 1
        
        if attempts >= 10 {
            
            revealResult = true
            timer?.invalidate()
            return
            
        }
        
        isFlipped = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            nextQuizNumber()
            
    }
}
    
    // --- [ REVEAL NEXT QUIZ NUMBER ] ---
    func nextQuizNumber(){
        
        testNumber = Int.random(in: 1...100)
        isPrimeNumber = checkPrime(testNumber)
        isFlipped = false
        timerDefault = 5
        resetTimer()
    }
    
    // --- [ START QUIZ ] ---
    func startQuiz(){
        
        testNumber = Int.random(in: 1...100)
        isPrimeNumber = checkPrime(testNumber)
        correctScore = 0
        incorrectScore = 0
        feedback = ""
        isFlipped = false
        revealResult = false
        nextQuizNumber()
        
    }
    // --- [ CHECK USER ANSWER ] ---
    func checkAnswer(_ isPrime: Bool) {
        timer?.invalidate()
        attempts += 1
        
        if attempts >= 10{
            
            revealResult = true
            timer?.invalidate()
            return
        }
        
        isFlipped = true
        
        if isPrime == isPrimeNumber{
            
            feedback = "✅"
            correctScore += 1
            
        } else {
            
            feedback = "❌"
            incorrectScore -= 1
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isFlipped = false
            feedback = ""
            nextQuizNumber() // moving to next number immediately
                
            }
        }
    }


 // --- [ LIVE PREVIEW ] --
struct ContentView_Previews: PreviewProvider{
static var previews: some View {
        ContentView()
  }
}
    

