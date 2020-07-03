//
//  BocController.swift
//  recordButtonPractice
//
//  Created by Lance Samaria on 7/3/20.
//  Copyright © 2020 Lance Samaria. All rights reserved.
//


import UIKit

class BoxController: UIViewController {
    
    //MARK:- UIElements
    fileprivate lazy var roundButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.backgroundColor = UIColor.blue
        return button
    }()
    
    fileprivate lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.monospacedDigitSystemFont(ofSize: 22, weight: .medium)
        label.textColor = UIColor.black
        label.text = initialStrForTimerLabel
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var boxForTimerLayer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .brown
        return view
    }()
    
    //MARK:- Properties
    fileprivate let shapeLayer = CAShapeLayer()
    fileprivate let bgShapeLayer = CAShapeLayer()
    fileprivate var basicAnimation: CABasicAnimation!
    
    fileprivate var wereCAShapeLayersAdded = false
    fileprivate var isBasicAnimationAnimating = false
    
    fileprivate var maxTimeInSecs = 15
    fileprivate lazy var seconds = maxTimeInSecs
    fileprivate var milliseconds = 0
    fileprivate lazy var timerStr = initialStrForTimerLabel
    fileprivate lazy var initialStrForTimerLabel = "\(maxTimeInSecs).0"
    
    fileprivate weak var timer: Timer?
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setAnchors()
        
        setGestures()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !wereCAShapeLayersAdded {
            wereCAShapeLayersAdded = true
            
            roundButton.layer.cornerRadius = roundButton.frame.width / 2
            
            addBothCAShapeLayersToCameraButton()
        }
    }
    
    //MARK:- Anchors
    fileprivate func setAnchors() {
        
        view.addSubview(boxForTimerLayer)
        view.addSubview(roundButton)
        view.addSubview(timerLabel)
        
        boxForTimerLayer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3).isActive = true
        boxForTimerLayer.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 3).isActive = true
        boxForTimerLayer.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -3).isActive = true
        boxForTimerLayer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -3).isActive = true
        
        roundButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        roundButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        roundButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        roundButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        timerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

//MARK:- Animations Methods
extension BoxController {
    
    fileprivate func addBothCAShapeLayersToCameraButton() {
        
        bgShapeLayer.frame = boxForTimerLayer.bounds
        bgShapeLayer.path = UIBezierPath(rect: boxForTimerLayer.bounds).cgPath
        bgShapeLayer.strokeColor = UIColor.lightGray.cgColor
        bgShapeLayer.fillColor = UIColor.clear.cgColor
        bgShapeLayer.lineWidth = 6
        boxForTimerLayer.layer.addSublayer(bgShapeLayer)
        boxForTimerLayer.layer.insertSublayer(bgShapeLayer, at: 0)
        
        shapeLayer.frame = boxForTimerLayer.bounds
        shapeLayer.path = UIBezierPath(rect: boxForTimerLayer.bounds).cgPath
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 6
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        
        boxForTimerLayer.layer.addSublayer(shapeLayer)
    }
    
    fileprivate func addProgressAnimation() {
        
        CATransaction.begin()
        
        basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        removeAnimation()
        
        if shapeLayer.timeOffset > 0.0 {
            // restarts animatiom from 0
            shapeLayer.speed = 1.0
            shapeLayer.timeOffset = 0.0
        }
        
        basicAnimation.delegate = self
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(seconds)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            print("CATransaction completion called\n")
        }
        
        shapeLayer.add(basicAnimation, forKey: "myAnimation")
        
        CATransaction.commit()
    }
    
    fileprivate func removeAnimation() {
        shapeLayer.removeAnimation(forKey: "myAnimation")
    }
    
    fileprivate func pauseShapeLayerAnimation() {
        
        let pausedTime = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
        
        print("animation has paused/stopped\n")
    }
}

//MARK:- CAAnimationDelegate
extension BoxController: CAAnimationDelegate  {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        if seconds == 0 {
            
            print("***** animation done *****\n")
        }
    }
}

//MARK:- Timer
extension BoxController {
    
    //MARK:- Timers
    fileprivate func startTimer() {
        
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.timerIsRunning()
        })
    }
    
    @objc fileprivate func timerIsRunning() {
        
        if seconds == maxTimeInSecs && milliseconds == 0 {
           // seconds = 14
           // milliseconds = 0
        }
        
        updateTimerLabel()
        
        if !isBasicAnimationAnimating {
            isBasicAnimationAnimating = true
            
            addProgressAnimation()
        }
        
        milliseconds -= 1

        if milliseconds < 0 {

            milliseconds = 9

            if seconds != 0 {
                seconds -= 1

            } else {

                invalidateTimer()

                print("timer done\n")
            }
        }

        if milliseconds == 0 {

            milliseconds = 0
        }
    }
    
    fileprivate func updateTimerLabel() {
        
        let millisecStr = "\(milliseconds)"
        let secondsStr = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        timerLabel.text = "\(secondsStr).\(millisecStr)"
    }
    
    fileprivate func resetTimerSecsAndLabel() {
        
        milliseconds = 0
        seconds = maxTimeInSecs
        
        timerLabel.text = initialStrForTimerLabel
    }
    
    fileprivate func invalidateTimer() {
        
        if isBasicAnimationAnimating {
            isBasicAnimationAnimating = false
            
            if seconds != 0 {
                pauseShapeLayerAnimation()
            }
        }
        
        timer?.invalidate()
    }
}

//MARK:- Gestures
extension BoxController {
    
    fileprivate func setGestures() {
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        roundButton.addGestureRecognizer(tapRecognizer)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture))
        roundButton.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func tapGesture(recognizer: UITapGestureRecognizer) {
        print("tap\n")
    }
    
    @objc private func longPressGesture(recognizer: UILongPressGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            resetTimerSecsAndLabel()
            startTimer()
            print("long gesture began\n")
        case .ended, .cancelled:
            invalidateTimer()
            print("long gesture ended or cancelled\n")
        case .failed:
            print("long gesture failed\n")
        default:
            break
        }
    }
}
