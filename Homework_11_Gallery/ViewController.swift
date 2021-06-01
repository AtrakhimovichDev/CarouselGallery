//
//  ViewController.swift
//  Homework_11_Gallery
//
//  Created by Andrei Atrakhimovich on 17.05.21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    
    private let firstImageView = UIImageView()
    private let secondImageView = UIImageView()
    private let thirdImageView = UIImageView()
    
    private var currentImageView = UIImageView()
    private var leftImageView = UIImageView()
    private var rightImageView = UIImageView()
    
    private var currentImageIndex = 1
    private var imagesArray: [UIImage] = []
    private var startLocationX: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillImagesArray()
        setImageViewSettings(imageView: firstImageView, startImage: imagesArray[0])
        setImageViewSettings(imageView: secondImageView, startImage: imagesArray[1])
        setImageViewSettings(imageView: thirdImageView, startImage: imagesArray[2])
        leftImageView = firstImageView
        currentImageView = secondImageView
        rightImageView = thirdImageView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leftImageView.frame.origin.x = -mainView.frame.width
        currentImageView.frame.origin.x = 0
        rightImageView.frame.origin.x = mainView.frame.width
    }
    
    @objc func makePanGesture(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            startLocationX = sender.location(in: mainView).x
        case .changed:
            currentImageView.frame.origin.x = currentImageView.frame.origin.x + sender.translation(in: mainView).x
            leftImageView.frame.origin.x = leftImageView.frame.origin.x + sender.translation(in: mainView).x
            rightImageView.frame.origin.x = rightImageView.frame.origin.x + sender.translation(in: mainView).x
            sender.setTranslation(.zero, in: mainView)
        case .ended:
            makeGalleryAnimation(senderLastLocationX: sender.location(in: mainView).x)
        default:
            break
        }
    }
    
    private func makeGalleryAnimation(senderLastLocationX: CGFloat) {
        if senderLastLocationX < startLocationX {
            if rightImageView.frame.minX < mainView.frame.width / 2 {
                makeLeftSideAnimation()
            } else {
                makeNormaStateAnimation()
            }
        } else {
            if leftImageView.frame.maxX > mainView.frame.width / 2 {
                makeRightSideAnimation()
            } else {
                makeNormaStateAnimation()
            }
        }
    }
    
    private func makeLeftSideAnimation() {
        moveImageView(to: -mainView.frame.width, imageView: currentImageView) { _ in }
        moveImageView(to: 0, imageView: rightImageView) { _ in
            self.setNewSettingsAfterAnimation(direction: .left)
        }
    }
    
    private func makeRightSideAnimation() {
        moveImageView(to: 0, imageView: leftImageView) { _ in }
        moveImageView(to: mainView.frame.width, imageView: currentImageView) { _ in
            self.setNewSettingsAfterAnimation(direction: .right)
        }
    }
    
    private func makeNormaStateAnimation() {
        moveImageView(to: -mainView.frame.width, imageView: leftImageView) { _ in }
        moveImageView(to: 0, imageView: currentImageView) { _ in }
        moveImageView(to: mainView.frame.width, imageView: rightImageView) { _ in }
    }
    
    private func setNewSettingsAfterAnimation(direction: Direction) {
        switch direction {
        case .left:
            self.leftImageView.frame.origin.x = self.mainView.frame.width
            let saveLeftView = self.leftImageView
            self.leftImageView = self.currentImageView
            self.currentImageView = self.rightImageView
            self.rightImageView = saveLeftView
        case .right:
            self.rightImageView.frame.origin.x = -self.mainView.frame.width
            let saveRightView = self.rightImageView
            self.rightImageView = self.currentImageView
            self.currentImageView = self.leftImageView
            self.leftImageView = saveRightView
        }
        changeCurrentImageIndex(direction: direction)
        changeImages(direction: direction)
    }
    
    private func changeCurrentImageIndex(direction: Direction) {
        switch direction {
        case .left:
            if currentImageIndex + 1 < imagesArray.count {
                currentImageIndex += 1
            } else {
                currentImageIndex = 0
            }
        case .right:
            if currentImageIndex - 1 >= 0 {
                currentImageIndex -= 1
            } else {
                currentImageIndex = imagesArray.count - 1
            }
        }
    }
    
    private func changeImages(direction: Direction) {
        
        var nextImageIndex = 0
        var imageViewForNewImage: UIImageView
       
        switch direction {
        case .left:
            if currentImageIndex + 1 < imagesArray.count {
                nextImageIndex = currentImageIndex + 1
            } else {
                nextImageIndex = 0
            }
            imageViewForNewImage = rightImageView
        case .right:
            if currentImageIndex - 1 >= 0 {
                nextImageIndex = currentImageIndex - 1
            } else {
                nextImageIndex = imagesArray.count - 1
            }
            imageViewForNewImage = leftImageView
        }
        
        imageViewForNewImage.image = imagesArray[nextImageIndex]
        let colors = imageViewForNewImage.image?.getColors()
        imageViewForNewImage.backgroundColor = colors?.background
    }
    
    private func fillImagesArray() {
        imagesArray.append(UIImage(named: "photo7")!)
        imagesArray.append(UIImage(named: "photo8")!)
        imagesArray.append(UIImage(named: "photo9")!)
        imagesArray.append(UIImage(named: "photo10")!)
        imagesArray.append(UIImage(named: "photo11")!)
        imagesArray.append(UIImage(named: "photo12")!)
    }
    
    private func setImageViewSettings(imageView: UIImageView, startImage: UIImage) {

        let panGesture = UIPanGestureRecognizer()
        panGesture.addTarget(self, action: #selector(makePanGesture(sender:)))
        
        imageView.frame = CGRect(origin: CGPoint(x: mainView.frame.width, y: 0), size: mainView.frame.size)
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true

        imageView.image = startImage
        let colors = imageView.image?.getColors()
        imageView.backgroundColor = colors?.background
        
        mainView.addGestureRecognizer(panGesture)
        mainView.addSubview(imageView)
        
    }
    
    
    private func moveImageView(to xPoint: CGFloat, imageView: UIImageView, completion: @escaping (Bool) -> ()) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            imageView.frame.origin.x = xPoint
        }, completion: completion)
    }
}

