import SwiftUI

// --- [ HELPER FUNCTIONS ] ---
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

// --- [ FLIPPING BUTTON ] ---
func flipButton(
    
    isPrime: Bool,
    isFlipped: Bool,
    isPrimeNumber: Bool,
    feedback: String,
    action: @escaping () -> Void
    
) -> some View{
    
    ZStack {
        RoundedRectangle(cornerRadius: 20)
            .fill(isFlipped && isPrimeNumber == isPrime ?
                  (feedback == "✅" ? Color.green : Color.red) :
                    Color.gray)
            .frame(height: 60)
            .shadow(radius: 10)
            .rotation3DEffect(
                Angle(
                    degrees: isFlipped && isPrimeNumber == isPrime ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                
            )
            .animation(.easeInOut, value: isFlipped)
        
        if isFlipped && isPrimeNumber == isPrime {
            
            Text(feedback)
                .font(.largeTitle)
                .foregroundColor(.white)
            
        } else {
            Text(isPrime ? "Prime" : "Not Prime")
                .font(.headline)
                .foregroundColor(.white)
            
        }
    }
    .onTapGesture {
        action()
        
    }
}


// --- [ MAIN VIEW || QUIZ ] ---

struct ContentView : View {
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
            // bottom left alignment for the timer -- test
            Color.green.opacity(0.2).edgesIgnoringSafeArea(.all)
            VStack(spacing: 80){
                
                Text("\(testNumber)")
                    .font(.system(size: 100, weight: .bold))
                
                Text("Is this a prime number?")
                    .font(.title)
                
                HStack(spacing: 40) {
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
            VStack {
                Spacer() // trying out spacer as per documentation suggestion
                HStack { // adding HStack to isolate its movements
                    Text("TIMER: \(timerDefault)")
                        .font(.title)
                        .foregroundColor(timerDefault <= 3 ? .red : .primary)
                        .padding(.leading, 16) // space from left edge
                        .padding(.bottom, 16) // space from bottom edge
                    Spacer()
                }
            }
        }
        .ignoresSafeArea(edges: .all) // pushing to the very bottom left
        .onAppear {
                
                startQuiz()
            
        }
        .alert(isPresented: $revealResult){
            
                Alert(
                    
                    title: Text("GAME OVER"),
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
    
    
    func nextQuizNumber(){
        
        testNumber = Int.random(in: 1...100)
        isPrimeNumber = checkPrime(testNumber)
        isFlipped = false
        timerDefault = 5
        resetTimer()
    }
    
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
    

