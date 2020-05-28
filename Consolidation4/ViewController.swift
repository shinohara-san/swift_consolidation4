//
//  ViewController.swift
//  Consolidation4
//
//  Created by Yuki Shinohara on 2020/05/27.
//  Copyright © 2020 Yuki Shinohara. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var questions = [String]()
    @IBOutlet var question: UILabel!
    @IBOutlet var score: UILabel!
    
    var coveredQuestion = [String]()
    var hiddenAnswer:String?
    var life = 0{
        didSet{
            score.text = "Your life is \(life)"
        }
    }
    
    var answerBit = [Character]()
    
    @IBOutlet var tryButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        questions = ["mango", "orange"]
        title = "hangman game"
        newGame()
        tryButton.layer.cornerRadius = 10
        
    }
    
    @IBAction func tryTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Enter an alphabet", message: nil, preferredStyle: .alert)
        ac.addTextField() //アラートに入力フォーム
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [weak self, weak ac] action in
            guard let letter = ac?.textFields?[0].text else { return }
            if letter.count == 1 {
                self?.checkAlphabet(letter: letter)
            } else {
                return
            }
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func checkAlphabet(letter: String){
        
        if answerBit.contains(Character(letter)){
            life += 1
            let index = answerBit.firstIndex(of: Character(letter))
            
            if index != nil{
                //print(index!)
                coveredQuestion[index!] = letter
                question.text = coveredQuestion.joined()
            }
            
            if !coveredQuestion.contains("?"){
                let ac = UIAlertController(title: "You did it!", message: nil, preferredStyle: .alert)
                let submitAction = UIAlertAction(title: "Next", style: .default, handler: { [weak self] (UIAlertAction) -> Void in
                    let index = self?.questions.firstIndex(of: self?.hiddenAnswer ?? "")
                    if index != nil{
                        self?.questions.remove(at: index!)
                    } else {
                        return
                    }
                        
                    
                    self?.newGame()
                })
                
                ac.addAction(submitAction)
                present(ac, animated: true)
            }
            
        } else {
            life -= 1
            if life == 0{
                let ac = UIAlertController(title: "GAME OVER", message: nil, preferredStyle: .alert)
                let submitAction = UIAlertAction(title: "Replay", style: .default, handler: { [weak self] (UIAlertAction) -> Void in
                    self?.newGame()
                })
                
                ac.addAction(submitAction)
                present(ac, animated: true)
                
            }
        }
    }
    
    func newGame(){
        coveredQuestion = [String]()
        answerBit = [Character]()
        hiddenAnswer = questions.randomElement() ?? "end"
        guard let hiddenAnswer = hiddenAnswer else {return}
        life = 5
        
        for i in hiddenAnswer{
            answerBit.append(i)
        }
        print(answerBit)
        
        for _ in 0 ..< answerBit.count{
            coveredQuestion.append("?")
        }
        
        question.text = coveredQuestion.joined()
    }
    
}

