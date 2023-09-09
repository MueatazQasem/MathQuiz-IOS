import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var scoreTextField: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
  
    
    @IBOutlet weak var sortWrongAscendingButton: UIButton!
    var playerName: String?
    var score: Int = 0
    var questions: [Question] = []
    var filteredQuestions: [Question] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameTextField.text = playerName
        let scorePercentage = Double(score) / Double(questions.count) * 100
        scoreTextField.text = "\(scorePercentage)%"
        
        resultTableView.delegate = self
        resultTableView.dataSource = self
        
        updateTableView(filter: "all")
    }
    
    @IBAction func backButtonTapped(_ sender: UIBarButtonItem) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }


    
    
    @IBAction func allButtonTapped(_ sender: UIButton) {
        updateTableView(filter: "all")
    }

    @IBAction func rightButtonTapped(_ sender: UIButton) {
        updateTableView(filter: "right")
    }

    @IBAction func wrongButtonTapped(_ sender: UIButton) {
        updateTableView(filter: "wrong")
    }

   

    func updateTableView(filter: String) {
        print("Filter:", filter)
        print("All questions:", questions)
        
        switch filter {
        case "right":
            filteredQuestions = questions.filter { $0.userAnswer != nil && abs($0.userAnswer! - $0.correctAnswer) < 0.01 }
        case "wrong":
            filteredQuestions = questions.filter { $0.userAnswer == nil || abs($0.userAnswer! - $0.correctAnswer) >= 0.01 }
        default:
            filteredQuestions = questions
        }
        
        print("Filtered questions:", filteredQuestions)
        resultTableView.reloadData()
    }

}


extension ThirdViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredQuestions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath) as! ResultTableViewCell
        
        let question = filteredQuestions[indexPath.row]
        cell.questionLabel.text = question.text
        cell.correctAnswerLabel.text = "\(question.correctAnswer)"
        
        if let userAnswer = question.userAnswer {
            cell.userAnswerLabel.text = "\(userAnswer)"
        } else {
            cell.userAnswerLabel.text = "empty"
        }
        
        return cell
    }

}
