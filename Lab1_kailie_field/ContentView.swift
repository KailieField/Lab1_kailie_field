import SwiftUI

// --- [ HELPER FUNCTIONS ] ---
func checkPrime(_ number: Int) -> Bool {
    if number < 2 { return false }
    for i in 2..<Int(sqrt(Double(number)) + 1){
        if number % 1 == 0 { return false}
    }
    return true
}

func flipButton(isPrime: Bool, isFlipped: Bool, isPrimeNumber: Bool, feedback: String, action: @escaping () -> Void) -> some View{
    ZStack {
        RoundedRectangle(cornerRadius: 20)
            .fill(isFlipped && isPrimeNumber == isPrime ?
                  (feedback == "YES" ? Color.green : Color.red) :
                    Color.gray)
            .frame(height: 60)
            .shadow(radius: 5)
            .rotation3DEffect(
                Angle(degrees: isFlipped && isPrimeNumber == isPrime ? 180 : 0), axis: (x: 0, y: 1, z: 0)
            )
        Text(isPrime ? "Prime" : "Not Prime").foregroundColor(.white).font(.headline)
    }
    .onTapGesture {
        action()
    }
}











//struct ContentView : View {
//    @State private var testNumber = Int.random(in: 1...100)
//    @State private var timerDefault = 5
//    @State private var correctScore = 0
//    @State private var incorrectScore = 0
//    @State private var attempts = 0
//    @State private var feedback = ""
//    @State private var timer : Timer? = nil
//    @State private var revealResult = false
//    @State private var isFlipped = false
//    @State private var isPrimeNumber = false
//    
//    var body: some View {
//    }
//}
//
// --- [ LIVE PREVIEW ] --
//struct ContentView_Previews: PreviewProvider{
//    static var previews: some View {
//        ContentView()
//    }
//}
