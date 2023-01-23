//
//  ViewController.swift
//  project-34-sbl
//
//  Created by Diogo Melo on 4/19/22.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    var placedChips = [[UIView]]()
    var board: Board!
    
    var stackView: UIStackView!
    var columnButtons: [UIButton]!
    
    var strategist: GKMinmaxStrategist!
    
    override func loadView() {
        super.loadView()
        
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        stackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        
        
        columnButtons = [UIButton]()
        for tag in 0..<7 {
            let button = UIButton()
            button.tag = tag
            button.backgroundColor = .white
            button.accessibilityLabel = "Column \(tag + 1)"
            button.addTarget(self, action: #selector(makeMove), for: .touchUpInside)
            columnButtons.append(button)
            stackView.addArrangedSubview(button)
        }
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 0 ..< Board.width {
            placedChips.append([UIView]())
        }

        strategist = GKMinmaxStrategist()
        strategist.maxLookAheadDepth = 7
        strategist.randomSource = GKARC4RandomSource()
        resetBoard()
    }
    
    func resetBoard() {
        board = Board()
        strategist.gameModel = board
        
        updateUI()

        for i in 0 ..< placedChips.count {
            for chip in placedChips[i] {
                chip.removeFromSuperview()
            }

            placedChips[i].removeAll(keepingCapacity: true)
        }
    }
    
    @objc func makeMove (_ sender: UIButton) {
        let column = sender.tag

        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row: row, player: board.currentPlayer)
            continueGame()
        }
    }
    
    func addChip(inColumn column: Int, row: Int, player: Player) {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)
        let rect = CGRect(x: 0, y: 0, width: size, height: size)

        if (placedChips[column].count < row + 1) {
            let newChip = UIView()
            newChip.frame = rect
            newChip.isUserInteractionEnabled = false
            newChip.backgroundColor = player.color
            newChip.layer.cornerRadius = size / 2
            newChip.center = positionForChip(inColumn: column, row: row)
            newChip.isAccessibilityElement = true
            newChip.accessibilityLabel = player.name
            newChip.transform = CGAffineTransform(translationX: 0, y: -800)
            view.addSubview(newChip)

            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                newChip.transform = CGAffineTransform.identity
            })

            placedChips[column].append(newChip)
        }
    }
    
    func positionForChip(inColumn column: Int, row: Int) -> CGPoint {
        let button = columnButtons[column]
        let size = min(button.frame.width, button.frame.height / 6)

        let xOffset = button.frame.midX
        var yOffset = button.frame.maxY - size / 2
        yOffset -= size * CGFloat(row)
        return CGPoint(x: xOffset, y: yOffset)
    }

    func updateUI() {
        title = "\(board.currentPlayer.name)'s Turn"
        
        if board.currentPlayer.chip == .black {
            startAIMove()
        }
    }
    
    func continueGame() {
        // 1
        var gameOverTitle: String? = nil

        // 2
        if board.isWin(for: board.currentPlayer) {
            gameOverTitle = "\(board.currentPlayer.name) Wins!"
        } else if board.isFull() {
            gameOverTitle = "Draw!"
        }

        // 3
        if gameOverTitle != nil {
            let alert = UIAlertController(title: gameOverTitle, message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Play Again", style: .default) { [unowned self] (action) in
                self.resetBoard()
            }

            alert.addAction(alertAction)
            present(alert, animated: true)

            return
        }

        // 4
        board.currentPlayer = board.currentPlayer.opponent
        updateUI()
    }
    
    func columnForAIMove() -> Int? {
        if let aiMove = strategist.bestMove(for: board.currentPlayer) as? Move {
            return aiMove.column
        }

        return nil
    }
    
    func makeAIMove(in column: Int) {
        columnButtons.forEach { $0.isEnabled = true }
        navigationItem.leftBarButtonItem = nil
        
        if let row = board.nextEmptySlot(in: column) {
            board.add(chip: board.currentPlayer.chip, in: column)
            addChip(inColumn: column, row:row, player: board.currentPlayer)

            continueGame()
        }
    }
    
    func startAIMove() {
        columnButtons.forEach { $0.isEnabled = false }

        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()

        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: spinner)
        
        DispatchQueue.global().async { [unowned self] in
            let strategistTime = CFAbsoluteTimeGetCurrent()
            guard let column = self.columnForAIMove() else { return }
            let delta = CFAbsoluteTimeGetCurrent() - strategistTime

            let aiTimeCeiling = 1.0
            let delay = aiTimeCeiling - delta

            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.makeAIMove(in: column)
            }
        }
    }

}

