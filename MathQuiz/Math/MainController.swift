import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    var playerName: String?
    var currentQuestion: Question?
    var score: Int = 0
    var questions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
    }
    
    @IBAction func bt1(_ sender: Any) {
        updateAnswerLabel(with: "1")
    }
    
    @IBAction func bt2(_ sender: Any) {
        updateAnswerLabel(with: "2")
    }
    
    @IBAction func bt3(_ sender: Any) {
        updateAnswerLabel(with: "3")
    }
    
    @IBAction func bt4(_ sender: Any) {
        updateAnswerLabel(with: "4")
    }
    
    @IBAction func bt5(_ sender: Any) {
        updateAnswerLabel(with: "5")
    }
    
    @IBAction func bt6(_ sender: Any) {
        updateAnswerLabel(with: "6")
    }
    
    @IBAction func bt7(_ sender: Any) {
        updateAnswerLabel(with: "7")
    }
    
    @IBAction func bt8(_ sender: Any) {
        updateAnswerLabel(with: "8")
    }
    
    @IBAction func bt9(_ sender: Any) {
        updateAnswerLabel(with: "9")
    }
    
    @IBAction func bt0(_ sender: Any) {
        updateAnswerLabel(with: "0")
    }
    
    @IBAction func bt(_ sender: Any) {
        if !answerLabel.text!.contains(".") {
            answerLabel.text = answerLabel.text! + "."
        } else {
            showAlert(message: "Invalid Input (double points)")
        }
    }

    @IBAction func btn(_ sender: Any) {
        let minusSignCount = answerLabel.text!.filter({ $0 == "-" }).count

        if minusSignCount == 0 {
            answerLabel.text = "-" + answerLabel.text!
        } else if minusSignCount == 1 {
            answerLabel.text!.remove(at: answerLabel.text!.startIndex)
        } else {
            showAlert(message: "Invalid Input (double --)")
        }
    }


    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    @IBAction func generateButtonTapped(_ sender: UIButton) {
        currentQuestion = generateQuestion()
        questionLabel.text = currentQuestion?.text
    }
    
    @IBAction func validateButtonTapped(_ sender: UIButton) {
        // Check if there is a current question; if not, return and do nothing
        guard let currentQuestion = currentQuestion else { return }

        // Try to parse the user's answer as a Double from the answerLabel text, and if it's not possible, default to 0
        let userAnswer = Double(answerLabel.text ?? "0") ?? 0

        // Get the correct answer for the current question
        let correctAnswer = currentQuestion.correctAnswer

        // Check if the user's answer is correct by comparing it to the correct answer with a tolerance of 0.01
        let isCorrect = abs(userAnswer - correctAnswer) < 0.01

        // If the user's answer is correct
        if isCorrect {
            // Increase the score by 1
            score += 1

            // Show an alert indicating the user got the right answer
            showAlert(title: "Right!", message: "Correct Answer")
        } else {
            // Show an alert indicating the user got the wrong answer
            showAlert(title: "Wrong", message: "Wrong Answer")
        }

        // Update the question with the user's answer and add it to the questions array
        let updatedQuestion = Question(text: currentQuestion.text, correctAnswer: correctAnswer, userAnswer: userAnswer)
        questions.append(updatedQuestion)
    }

    @IBAction func clearButtonTapped(_ sender: UIButton) {
        answerLabel.text = ""
    }
    
    @IBAction func scoreButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "goToThirdPage", sender: (playerName, score, questions))
    }

    
    func generateQuestion() -> Question {
        let firstNumber = Int.random(in: 1...10)
        let secondNumber = Int.random(in: 1...10)
        var operation = Int.random(in: 1...4)
        
        while operation == 4 && firstNumber % secondNumber != 0 {
            operation = Int.random(in: 1...4)
        }
        
        var questionText: String
        var correctAnswer: Double
        
        switch operation {
        case 1:
            questionText = "\(firstNumber) + \(secondNumber)"
            correctAnswer = Double(firstNumber + secondNumber)
        case 2:
            questionText = "\(firstNumber) - \(secondNumber)"
            correctAnswer = Double(firstNumber - secondNumber)
        case 3:
            questionText = "\(firstNumber) * \(secondNumber)"
            correctAnswer = Double(firstNumber * secondNumber)
        case 4:
            questionText = "\(firstNumber) / \(secondNumber)"
            correctAnswer = Double(firstNumber) / Double(secondNumber)
        default:
            fatalError("Invalid operation")
        }
        return Question(text: questionText, correctAnswer: correctAnswer, userAnswer: nil)
    }

    
    func updateAnswerLabel(with number: String) {
        if answerLabel.text == "0" {
            answerLabel.text = number
        } else {
            answerLabel.text = answerLabel.text! + number
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToThirdPage",
           let data = sender as? (String?, Int, [Question]),
           let thirdViewController = segue.destination as? ThirdViewController {
            thirdViewController.playerName = data.0
            thirdViewController.score = data.1
            thirdViewController.questions = data.2
        }
    }

    func showAlert(title: String, message: String) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Done", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
}
