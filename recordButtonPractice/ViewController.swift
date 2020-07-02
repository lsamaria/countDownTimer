//
//  ViewController.swift
//  recordButtonPractice
//
//  Created by Lance Samaria on 6/27/20.
//  Copyright © 2020 Lance Samaria. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    //MARK:- UIElements
    fileprivate let bgShapeLayer = CAShapeLayer()
    fileprivate let timerShapeLayer = CAShapeLayer()
    fileprivate let basicAnimation = CABasicAnimation(keyPath: "strokeEnd") // transform.rotation.z
    fileprivate lazy var cameraButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "paperplaneIcon"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor.lightGray
        button.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        //button.layer.masksToBounds = true
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
    
    //MARK:- Properties
    
    /*
    // *** MINUTES && SECONDS ***
    fileprivate lazy var preRecordMaxVideoTimeInMins = 1
    fileprivate var preRecordMaxVideoTimeInSecs = 60 // 1
    
    fileprivate var hours = 0
    fileprivate lazy var minutes = preRecordMaxVideoTimeInMins
    fileprivate lazy var seconds = 0
    fileprivate var milliseconds = 0
    fileprivate lazy var initialStrForTimerLabel = "0\(preRecordMaxVideoTimeInMins):00.0" // "0\(preRecordMaxVideoTimeInSecs):00.0"
    */
    
    
     // *** SECONDS ONLY ***
     fileprivate var preRecordMaxVideoTimeInSecs = 15
     fileprivate lazy var seconds = preRecordMaxVideoTimeInSecs
     fileprivate var milliseconds = 0
     fileprivate lazy var timerStr = initialStrForTimerLabel
     fileprivate lazy var initialStrForTimerLabel = "\(preRecordMaxVideoTimeInSecs).0"
     
    
    fileprivate weak var videoTimer: Timer?
    fileprivate var startStopTimer = true
    
    //MARK:- View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureAnchors()
        
        configureGestures()
    }
    
    fileprivate var wasCAShapeLayerAddedCameraButton = false
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if !wasCAShapeLayerAddedCameraButton {
            wasCAShapeLayerAddedCameraButton = true
            
            cameraButton.layer.cornerRadius = cameraButton.frame.width / 2
            
            //addBothCAShapeLayersToCameraButton()
        }
    }
    
    //MARK:- Target Actions
    @objc fileprivate func cameraButtonPressed() { }
    
    //MARK:- Anchors
    fileprivate func configureAnchors() {
        
        view.addSubview(cameraButton)
        view.addSubview(timerLabel)
        
        cameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        timerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    fileprivate func addBothCAShapeLayersToCameraButton() {
        
        let center = cameraButton.center
        let radius = (cameraButton.frame.width / 2) + 10
        let lineWidth: CGFloat = 6
        let fillColor = UIColor.clear.cgColor
        
        let bgCircularPath = UIBezierPath(arcCenter: center,
                                          radius: radius,
                                          startAngle: -.pi/2,
                                          endAngle: 3 * .pi/2,
                                          clockwise: true)
        bgShapeLayer.path = bgCircularPath.cgPath
        bgShapeLayer.strokeColor = UIColor.lightGray.cgColor
        bgShapeLayer.fillColor = fillColor
        bgShapeLayer.lineWidth = lineWidth
        view.layer.addSublayer(bgShapeLayer)
        view.layer.insertSublayer(bgShapeLayer, at: 0)
        let timerCircularPath = UIBezierPath(arcCenter: center,
                                             radius: radius,
                                             startAngle: -.pi/2,
                                             endAngle: 3 * .pi/2,
                                             clockwise: true)
        timerShapeLayer.path = timerCircularPath.cgPath
        timerShapeLayer.strokeColor = UIColor.red.cgColor
        timerShapeLayer.fillColor = fillColor
        timerShapeLayer.lineWidth = lineWidth
        
        timerShapeLayer.strokeEnd = 0
        //camerButtonTimerLeftShapeLayer.speed = 0 // pause
        
        //view.layer.addSublayer(timerShapeLayer)
    }
    
    fileprivate var isBasicAnimationAnimating = false
    fileprivate func addProgressAnimation() {
        
        removeProgressAnimation()
        
        basicAnimation.delegate = self
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.default)
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(preRecordMaxVideoTimeInSecs)
        
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        timerShapeLayer.add(basicAnimation, forKey: "timerAnimation")
    }
    
    fileprivate func removeProgressAnimation() {
        timerShapeLayer.removeAnimation(forKey: "timerAnimation")
    }
    
    fileprivate func pauseAnimation() {
        let pausedTime = timerShapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        timerShapeLayer.speed = 0.0
        timerShapeLayer.timeOffset = pausedTime
    }
    
    fileprivate func resumeAnimation() {
        let pausedTime = timerShapeLayer.timeOffset
        timerShapeLayer.speed = 1.0
        timerShapeLayer.timeOffset = 0.0
        timerShapeLayer.beginTime = 0.0
        let timeSincePause = timerShapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        timerShapeLayer.beginTime = timeSincePause
    }
}

//MARK:- CAAnimationDelegate
extension ViewController: CAAnimationDelegate  {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    }
}

//MARK:- Timer
extension ViewController {
    
    //MARK:- Timers
    fileprivate func startTimer() {
        
        videoTimer?.invalidate()
        
        videoTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { [weak self] _ in
            self?.timerIsRunning()
        })
    }
    
    @objc fileprivate func timerIsRunning() {
        // https://teamtreehouse.com/community/swift-countdown-timer-of-60-seconds
        
        updateTimerLabel()
        
        // *** MINUTES && SECONDS && MILLISECONDS ***
        /*
        if seconds == 0 {
            
            if minutes != 0 {
                minutes -= 1
            }
        }
        
        if milliseconds == 0 {
            
            seconds -= 1
        }
        
        if seconds < 0 {
            
            seconds = 59
        }
        
        milliseconds -= 1
        
        if milliseconds < 0 {
            
            milliseconds = 9
        }
        
        if minutes == 0 && seconds == 0 && milliseconds == 0 {
            
            print(minutes)
            print(seconds)
            print(milliseconds)
            
            updateTimerLabel()
            
            videoTimer?.invalidate()
            
            resetTimerSecsAndInvalidateVideoTimer()
        }
        */
        
        // *** SECONDS ONLY ***
        
         if !isBasicAnimationAnimating {
         isBasicAnimationAnimating = true
         
         //addProgressAnimation()
         }
        
        /*
        // *** SECONDS ONLY ***
        if seconds != 0 {
            seconds -= 1
            
        } else {
            
            invalidateVideoTimer()
        }
        */
        
        
        // *** SECONDS && MILLISECONDS ONLY ***
        milliseconds -= 1
        
        if milliseconds < 0 {
            
            milliseconds = 9
            
            if seconds != 0 {
                seconds -= 1
                
            } else {
                
                invalidateVideoTimer()
                
                resetTimerSecsAndInvalidateVideoTimer()
            }
            
            //milliseconds = 9
        }
        
        if milliseconds == 0 {
            
            milliseconds = 0
        }
        
    }
    
    fileprivate func updateTimerLabel() {
        
        let millisecStr = "\(milliseconds)"
        let secondsStr = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        timerLabel.text = "\(secondsStr).\(millisecStr)"
        
        //let minutesStr = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        //timerLabel.text = "\(minutesStr):\(secondsStr).\(millisecStr)"
    }
    
    fileprivate func resetTimerSecsAndInvalidateVideoTimer() {
        invalidateVideoTimer()
        
        // *** MINUTES && SECONDS && MILLISECONDS ***
        /*
        seconds = 0
        milliseconds = 0
        minutes = preRecordMaxVideoTimeInMins
        */
        
        // *** SECONDS ONLY ***
        
        milliseconds = 0
        seconds = preRecordMaxVideoTimeInSecs
        
        timerLabel.text = initialStrForTimerLabel
    }
    
    fileprivate func invalidateVideoTimer() {
        videoTimer?.invalidate()
        isBasicAnimationAnimating = false
        pauseAnimation()
    }
}

//MARK:- Gestures
extension ViewController {
    
    fileprivate func configureGestures() {
        
        let takePhotoaTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(takePhotoGesture))
        cameraButton.addGestureRecognizer(takePhotoaTapRecognizer)
        
        let recordVideoLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(recordVideoGesture))
        //recordVideoLongPressGestureRecognizer.minimumPressDuration = 0.33
        cameraButton.addGestureRecognizer(recordVideoLongPressGestureRecognizer)
    }
    
    @objc private func takePhotoGesture(recognizer: UITapGestureRecognizer) {
        print("tap")
        //removeProgressAnimation()
        startTimer()
    }
    
    @objc private func recordVideoGesture(recognizer: UILongPressGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            //startTimer()
            break
        case .ended, .cancelled, .failed:
            //invalidateVideoTimer()
            break
        default:
            //invalidateVideoTimer()
            break
        }
    }
}
