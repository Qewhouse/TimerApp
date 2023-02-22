//
//  RootViewController.swift
//  TimerApp
//
//  Created by Alexander Altman on 22.02.2023.
//

import UIKit

// Runloop

final class RootViewController: UIViewController {
    
    private var timer: Timer?
    private var counter = 0
    private var isPaused: Bool = false
    private var isRunning: Bool = false
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.text = "00:00"
        label.font = .boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startResetButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startResetActionTapped), for: .touchUpInside)
        return button
    }()
    
    private let pauseButton: UIButton = {
        let button = UIButton()
        button.setTitle("Pause", for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(pauseActionTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(timerLabel)
        view.addSubview(startResetButton)
        view.addSubview(pauseButton)
        setConstraints()
        updateButtonsUI()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupObservers()
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeAppState),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(changeAppState),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
    }
    
    @objc private func changeAppState() {
      togglePause()
    }
    
    private func updateTimerText() {
        let minutes = counter / 60
        let seconds = counter % 60
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc private func startResetActionTapped() {
        
        if !isRunning {
            setupTimer()
        } else {
            timer?.invalidate()
            counter = 0
            updateTimerText()
            
        }
        
        isRunning = !isRunning
        updateButtonsUI()
    }
    
    @objc private func pauseActionTapped() {
        guard isRunning else { return }
        togglePause()
    }
    
    private func togglePause() {
       
        if isPaused {
            setupTimer()
        } else {
            timer?.invalidate()
        }
        isPaused = !isPaused
        updateButtonsUI()
    }
    
    private func updateButtonsUI() {
        if isRunning {
            startResetButton.setTitle("Reset", for: .normal)
            
        } else {
            startResetButton.setTitle("Start", for: .normal)
            
        }
        
        if isRunning {
            pauseButton.isHidden = false
            pauseButton.setTitle("Pause", for: .normal)
        } else {
            pauseButton.isHidden = true
        }
        
        if isPaused {
            pauseButton.setTitle("Resume", for: .normal)
        }
        
    }
    
    private func setupTimer() {
        timer?.invalidate()
        let timer = Timer.scheduledTimer(timeInterval: 1.0,
                                         target: self,
                                         selector: #selector(timerTick),
                                         userInfo: nil,
                                         repeats: true)
        self.timer = timer
    }
    
    @objc private func timerTick() {
        counter += 1
        updateTimerText()
    }
}

extension RootViewController {
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.heightAnchor.constraint(equalToConstant: 50),
            
            startResetButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 50),
            startResetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startResetButton.heightAnchor.constraint(equalToConstant: 40),
            
            pauseButton.topAnchor.constraint(equalTo: startResetButton.bottomAnchor, constant: 30),
            pauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pauseButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
