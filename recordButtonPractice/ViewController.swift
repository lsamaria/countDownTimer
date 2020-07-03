//
//  ViewController.swift
//  recordButtonPractice
//
//  Created by Lance Samaria on 6/27/20.
//  Copyright © 2020 Lance Samaria. All rights reserved.
//
//  https://www.calayer.com/core-animation/2017/12/25/cashapelayer-in-depth-part-ii.html

import UIKit

class ViewController: UIViewController {
    
    
    //MARK:- Animations
    fileprivate let shapeLayer = CAShapeLayer()
    fileprivate let bgShapeLayer = CAShapeLayer()
    fileprivate var basicAnimation: CABasicAnimation!
    
    //MARK:- UIElements
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
    
    fileprivate lazy var box: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .brown
        return view
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
    fileprivate lazy var initialStrForTimerLabel = "\(preRecordMaxVideoTimeInSecs).0" // "\(preRecordMaxVideoTimeInSecs)"
    
    fileprivate weak var videoTimer: Timer?
    
    fileprivate var timerAnimation: CABasicAnimation?
    
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
            
            addBothCAShapeLayersToCameraButton()
        }
    }
    
    //MARK:- Target Actions
    @objc fileprivate func cameraButtonPressed() { }
    
    //MARK:- Animations Methods
    fileprivate func addBothCAShapeLayersToCameraButton() {
        
        let center = cameraButton.center
        let radius = (cameraButton.frame.width / 2) + 10
        let lineWidth: CGFloat = 6
        let fillColor = UIColor.clear.cgColor
        
        /* circle- */
        let bgCircularPath = UIBezierPath(arcCenter: center,
                                          radius: radius,
                                          startAngle: -.pi/2,
                                          endAngle: 3 * .pi/2,
                                          clockwise: true)
        //bgShapeLayer.path = bgCircularPath.cgPath
        /* circle- */
        
        /* box- */
        bgShapeLayer.frame = box.bounds
        bgShapeLayer.path = UIBezierPath(rect: box.bounds).cgPath
        /* box- */
        
        bgShapeLayer.strokeColor = UIColor.lightGray.cgColor
        bgShapeLayer.fillColor = fillColor
        bgShapeLayer.lineWidth = lineWidth
        
        /* circle- */
        //view.layer.addSublayer(bgShapeLayer)
        //view.layer.insertSublayer(bgShapeLayer, at: 0)
        /* circle- */
        
        /* box- */
        box.layer.addSublayer(bgShapeLayer)
        box.layer.insertSublayer(bgShapeLayer, at: 0)
        /* box- */
        
        /* circle- */
        let circularPath = UIBezierPath(arcCenter: center,
                                             radius: radius,
                                             startAngle: -.pi/2,
                                             endAngle: 3 * .pi/2,
                                             clockwise: true)
        //shapeLayer.path = circularPath.cgPath
        /* cicrle- */
        
        /* box- */
        shapeLayer.frame = box.bounds
        shapeLayer.path = UIBezierPath(rect: box.bounds).cgPath
        /* box- */
        
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = fillColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineCap = .round
        shapeLayer.strokeEnd = 0
        
        /* circle- */
        //view.layer.addSublayer(shapeLayer)
        /* circle- */
        
        /* box- */
        box.layer.addSublayer(shapeLayer)
        /* box- */
        
        //addProgressAnimation()
    }
    
    fileprivate var isBasicAnimationAnimating = false
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
        basicAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        basicAnimation.fromValue = 0
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(seconds)
        basicAnimation.fillMode = CAMediaTimingFillMode.forwards
        basicAnimation.isRemovedOnCompletion = false
        
        CATransaction.setCompletionBlock {
            print("CATransaction completion called")
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
        
        print("You can do something here now that the animation has stopped")
    }
    
    fileprivate func resumeShapeLayerAnimation() {
        
        let pausedTime = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    //MARK:- Anchors
    fileprivate func configureAnchors() {
        
        view.addSubview(box)
        view.addSubview(cameraButton)
        view.addSubview(timerLabel)
        
        box.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3).isActive = true
        box.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 3).isActive = true
        box.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -3).isActive = true
        box.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -3).isActive = true
        
        cameraButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0).isActive = true
        cameraButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        cameraButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        cameraButton.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        timerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        timerLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}

//MARK:- CAAnimationDelegate
extension ViewController: CAAnimationDelegate  {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("***** animation done *****")
        //isBasicAnimationAnimating = false
        //resetTimerSecsAndInvalidateVideoTimer()
        //pauseAnimation()
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
        
        updateTimerLabel()
        
        if !isBasicAnimationAnimating {
            isBasicAnimationAnimating = true
            
            addProgressAnimation()
        }
        
        // *** SECONDS && MILLISECONDS ONLY ***
        milliseconds -= 1

        if milliseconds < 0 {

            milliseconds = 9

            if seconds != 0 {
                seconds -= 1

            } else {

                invalidateVideoTimer()

                print("timer done")
            }
        }

        if milliseconds == 0 {

            milliseconds = 0
        }
        
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
    }
    
    fileprivate func updateTimerLabel() {
        
        let millisecStr = "\(milliseconds)"
        let secondsStr = seconds > 9 ? "\(seconds)" : "0\(seconds)"
        
        timerLabel.text = "\(secondsStr).\(millisecStr)"
        //timerLabel.text = "\(secondsStr)"
        
        //let minutesStr = minutes > 9 ? "\(minutes)" : "0\(minutes)"
        //timerLabel.text = "\(minutesStr):\(secondsStr).\(millisecStr)"
    }
    
    fileprivate func resetTimerSecsAndInvalidateVideoTimer() {
        
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
        
        if isBasicAnimationAnimating {
            isBasicAnimationAnimating = false
            
            pauseShapeLayerAnimation()
            
            // this is just to immediatley remove the animation, don't uncomment this out
            //removeAnimation()
        }
        
        videoTimer?.invalidate()
    }
}

//MARK:- Gestures
extension ViewController {
    
    fileprivate func configureGestures() {
        
        let takePhotoaTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(takePhotoGesture))
        //takePhotoaTapRecognizer.numberOfTouchesRequired = 1
        cameraButton.addGestureRecognizer(takePhotoaTapRecognizer)
        
        let recordVideoLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(recordVideoGesture))
        //recordVideoLongPressGestureRecognizer.minimumPressDuration = 0.1
        cameraButton.addGestureRecognizer(recordVideoLongPressGestureRecognizer)
    }
    
    @objc private func takePhotoGesture(recognizer: UITapGestureRecognizer) {
        print("tap")
        //startTimer()
        //addProgressAnimation()
    }
    
    @objc private func recordVideoGesture(recognizer: UILongPressGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            resetTimerSecsAndInvalidateVideoTimer()
            startTimer()
            print("long gesture began")
        case .ended, .cancelled:
            //pauseAnimation()
            invalidateVideoTimer()
            print("long gesture ended or cancelled")
        case .failed:
            print("long gesture failed")
        default:
            //print("long gesture default")
            break
        }
    }
}
