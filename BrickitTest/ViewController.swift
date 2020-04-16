//
//  ViewController.swift
//  BrickitTest
//
//  Created by Анастасия Стрекалова on 16.04.2020.
//  Copyright © 2020 Анастасия Стрекалова. All rights reserved.
//

import SnapKit
import UICircularProgressRing
import UIKit

class ViewController: UIViewController {
    
    let stackView = UIStackView()

    var assemblyBlock = UIView()
    var itemsQuantity = 0 {
        didSet {
            countItemsLabel.text = String(itemsQuantity)
        }
    }
    var countItemsLabel = UILabel()
    var assemblyBlockCurrentState = assemblyBlockStates.first {
        didSet {
            refreshBlocks()
        }
    }
    
    var addingBlock = UIView()
    var addingBlockCurrentState = addingBlockStates.first {
        didSet {
            refreshBlocks()
        }
    }
    
    var date = Date()
    
    enum assemblyBlockStates {
        case first
        case second
        case third
    }
    
    enum addingBlockStates {
        case first
        case second
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(stackView)
        
        setupStackView()
        setupAssemblyBlock()
        setupAddingBlock()
    }
    
    func setupStackView() {
        stackView.axis = .horizontal
        stackView.addArrangedSubview(assemblyBlock)
        stackView.addArrangedSubview(addingBlock)
        
        stackView.snp.makeConstraints { (make) in
            make.height.equalTo(117)
            make.width.equalTo(view)
            make.center.equalTo(view)
        }
    }
    
    //MARK: - setupAssemblyBlock
    func setupAssemblyBlock() {
        assemblyBlock.snp.makeConstraints { (make) in
            if assemblyBlockCurrentState == .first {
                make.width.equalTo(stackView).dividedBy(2)
            } else {
                make.width.equalTo(stackView).multipliedBy(0.65)
            }
        }
        
        // box with dashed border
        let box = UIView()
        assemblyBlock.addSubview(box)
        
        box.snp.makeConstraints { (make) in
            make.edges.equalTo(assemblyBlock).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 1)).labeled("boxEdges")
        }
        
        box.layoutIfNeeded()
        box.addDashedBorder()
        
        //vStack
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .center
        
        box.addSubview(vStack)
        
        vStack.snp.makeConstraints { (make) in
            make.edges.equalTo(box).inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        
        // hStack
        let hStack = UIStackView()
        hStack.axis = .horizontal
        hStack.alignment = .center
        hStack.distribution = .fill
        hStack.spacing = 10
        
        vStack.addArrangedSubview(hStack)
        
        hStack.snp.makeConstraints { (make) in
            make.width.equalTo(vStack)
        }
        
        //progressBar
        let progressRing = UICircularProgressRing()
        progressRing.style = .ontop
        progressRing.maxValue = 100
        progressRing.startAngle = 270
        progressRing.outerRingWidth = 9
        progressRing.outerRingColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.9411764706, alpha: 1)
        progressRing.innerRingWidth = 9
        progressRing.innerRingColor = UIColor(named: "yellow")!
        progressRing.innerCapStyle = .butt
        progressRing.font = UIFont(name: "Montserrat", size: 11)!
        progressRing.fontColor = #colorLiteral(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        
        if assemblyBlockCurrentState == .third {
            progressRing.value = 100
            progressRing.shouldShowValueText = false
            
            let checkmark = UIImageView(image: UIImage(named: "checkmark"))
            progressRing.addSubview(checkmark)
            
            checkmark.snp.makeConstraints { (make) in
                make.center.equalTo(progressRing)
            }
        } else {
            progressRing.value = 34
        }
        
        progressRing.snp.makeConstraints { (make) in
            make.size.equalTo(55)
        }
        
        hStack.addArrangedSubview(progressRing)
        
        //label
        let label = UILabel()
        label.numberOfLines = 0
        
        let boldText: String
        let normalText: String
        
        switch assemblyBlockCurrentState {
        case .first:
            boldText = "1367\n"
            normalText = "из 3928 деталей"
        case .second:
            boldText = "15/35\n"
            normalText = "шаг"
        case .third:
            boldText = "100%\n"
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let dateString = formatter.string(from: date)
            normalText = dateString
        }
        
        let attrs1: [NSAttributedString.Key: Any] = [.font : UIFont(name: "Montserrat-Bold", size: 18)!]
        let attributedString = NSMutableAttributedString(string: boldText, attributes: attrs1)

        
        let attrs2: [NSAttributedString.Key: Any] = [.font: UIFont(name: "Montserrat", size: 10)!, .foregroundColor: UIColor.black.withAlphaComponent(0.5)]
        let secondAttributedString = NSMutableAttributedString(string: normalText, attributes: attrs2)

        attributedString.append(secondAttributedString)
        
        label.attributedText = attributedString
        hStack.addArrangedSubview(label)
        
        // label for second state
        if assemblyBlockCurrentState == .second {
            let label = UILabel()
            label.text = "вы закончили\n13.12.2020"
            label.numberOfLines = 0
            label.textColor = UIColor.black.withAlphaComponent(0.5)
            label.font = UIFont(name: "Montserrat", size: 10)!
            label.textAlignment = .right
            
            hStack.addArrangedSubview(label)
            
            label.snp.makeConstraints { (make) in
                make.width.equalTo(74)
            }
        }
        
        // image for third state
        if assemblyBlockCurrentState == .third {
            let cupImage = UIImageView(image: UIImage(named: "cup"))
            cupImage.contentMode = .right
            
            hStack.addArrangedSubview(cupImage)
        }
        
        // btn
        if assemblyBlockCurrentState == .first || assemblyBlockCurrentState == .second {
            let btn: UIButton
            
            if assemblyBlockCurrentState == .first {
                btn = makeBtn(withText: "к сборке")
            } else {
                btn = makeBtn(withText: "продолжить сборку")
            }
            
            vStack.addArrangedSubview(btn)
            
            btn.snp.makeConstraints { (make) in
                make.width.equalTo(vStack)
                make.height.equalTo(33)
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(nextAssemblyState))
            btn.addGestureRecognizer(tap)
        } else {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.spacing = 2
            hStack.distribution = .fill
            vStack.addArrangedSubview(hStack)
            
            hStack.snp.makeConstraints { (make) in
                make.width.equalTo(vStack)
                make.height.equalTo(33)
            }
            
            let firstBtn = makeBtn(withText: "вспомнить")
            hStack.addArrangedSubview(firstBtn)
            firstBtn.snp.makeConstraints { (make) in
                make.width.equalTo(92)
            }
            
            let secondBtn = makeBtn(withText: "собрать снова")
            hStack.addArrangedSubview(secondBtn)
            
            let tap1 = UITapGestureRecognizer(target: self, action: #selector(nextAssemblyState))
            let tap2 = UITapGestureRecognizer(target: self, action: #selector(nextAssemblyState))
            firstBtn.addGestureRecognizer(tap1)
            secondBtn.addGestureRecognizer(tap2)
        }
    }
    
    //MARK: - setupAddingBlock
    func setupAddingBlock() {
        addingBlock.snp.makeConstraints { (make) in
            if assemblyBlockCurrentState == .first {
                make.width.equalTo(stackView).dividedBy(2)
            } else {
                make.width.equalTo(stackView).multipliedBy(0.35)
            }
        }
        
        // box with dashed border
        let box = UIView()
        addingBlock.addSubview(box)
        
        box.snp.makeConstraints { (make) in
            make.edges.equalTo(addingBlock).inset(UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 5))
        }
        
        box.layoutIfNeeded()
        box.addDashedBorder()
        
        //vStack
        let vStack = UIStackView()
        vStack.axis = .vertical
        vStack.alignment = .center
        
        box.addSubview(vStack)
        
        vStack.snp.makeConstraints { (make) in
            make.edges.equalTo(box).inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        
        if addingBlockCurrentState == .first {
            // label
            let label = UILabel()
            label.text = "Если у вас есть этот набор, отметьте его, чтоб мы могли учитывать его детали для сборки других моделей"
            label.numberOfLines = 0
            label.textColor = UIColor.black.withAlphaComponent(0.5)
            label.font = UIFont(name: "Montserrat", size: 10)!
            label.textAlignment = .center
            
            vStack.addArrangedSubview(label)
            
            label.snp.makeConstraints { (make) in
                if assemblyBlockCurrentState == .first {
                    make.width.equalTo(vStack).inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
                } else {
                    make.width.equalTo(vStack).inset(UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5))
                }
            }
        } else {
            let hStack = UIStackView()
            hStack.axis = .horizontal
            hStack.alignment = .center
            hStack.distribution = .equalSpacing
            vStack.addArrangedSubview(hStack)
            
            hStack.snp.makeConstraints { (make) in
                make.width.equalTo(vStack)
            }
            
            let leftBlock = UIView()
            hStack.addArrangedSubview(leftBlock)
            leftBlock.snp.makeConstraints { (make) in
                make.width.equalTo(48)
            }
            
            // checkmark in circle
            let checkmark = UIImageView(image: UIImage(named: "checkmark"))
            leftBlock.addSubview(checkmark)
            checkmark.snp.makeConstraints { (make) in
                make.centerX.equalTo(leftBlock)
            }
            
            let circleLayer = CAShapeLayer()
            circleLayer.path = UIBezierPath(arcCenter: checkmark.center, radius: 24, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true).cgPath
            circleLayer.strokeColor = UIColor(named: "yellow")?.cgColor
            circleLayer.lineWidth = 9
            circleLayer.fillColor = UIColor.clear.cgColor
            checkmark.layer.addSublayer(circleLayer)
            
            checkmark.snp.makeConstraints { (make) in
                make.center.equalTo(leftBlock)
            }
            
            // count label in circle
            let countCircle = UIView()
            leftBlock.addSubview(countCircle)
            
            countCircle.snp.makeConstraints { (make) in
                make.centerY.equalTo(leftBlock)
                make.centerX.equalTo(leftBlock).offset(26)
                make.size.equalTo(27)
            }
            
            let circleLayer2 = CAShapeLayer()
            circleLayer2.path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 27, height: 27)).cgPath
            circleLayer2.strokeColor = UIColor(named: "yellow")?.cgColor
            circleLayer2.fillColor = UIColor.white.cgColor
            circleLayer2.lineWidth = 4
            countCircle.layer.addSublayer(circleLayer2)
            
            countItemsLabel.text = String(itemsQuantity)
            countItemsLabel.font = UIFont(name: "Montserrat-Bold", size: 18)!
            countCircle.addSubview(countItemsLabel)
            
            countItemsLabel.snp.makeConstraints { (make) in
                make.center.equalTo(countCircle)
            }
            
            // delete button
            let deleteBtn = UIButton()
            deleteBtn.setImage(UIImage(named: "delete"), for: .normal)
            if assemblyBlockCurrentState == .first {
                deleteBtn.setTitle("  удалить", for: .normal)
                deleteBtn.titleLabel?.font = UIFont(name: "Montserrat", size: 10)!
                deleteBtn.setTitleColor(.black, for: .normal)
            }
            hStack.addArrangedSubview(deleteBtn)
            let tap = UITapGestureRecognizer(target: self, action: #selector(deleteItem))
            deleteBtn.addGestureRecognizer(tap)
        }
        
        
        // btn
        let btn: UIButton
        if addingBlockCurrentState == .first {
            btn = makeBtn(withText: "у меня есть")
            let tap = UITapGestureRecognizer(target: self, action: #selector(secondAddingState))
            btn.addGestureRecognizer(tap)
        } else {
            if assemblyBlockCurrentState == .first {
                btn = makeBtn(withText: "добавить еще")
            } else {
                btn = makeBtn(withText: "добавить")
            }
            let tap = UITapGestureRecognizer(target: self, action: #selector(addItem))
            btn.addGestureRecognizer(tap)
        }
        
        
        vStack.addArrangedSubview(btn)
        
        btn.snp.makeConstraints { (make) in
            make.width.equalTo(vStack)
            make.height.equalTo(33)
        }
    }
    
    func refreshBlocks() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        assemblyBlock = UIView()
        addingBlock = UIView()
        
        setupStackView()
        setupAssemblyBlock()
        setupAddingBlock()
    }

    func makeBtn(withText text: String) -> UIButton {
        let btn = UIButton()
        btn.backgroundColor = UIColor(named: "yellow")!
        btn.layer.cornerRadius = 15
        btn.setTitle(text, for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel!.font = UIFont(name: "Montserrat-SemiBold", size: 12)
        
        return btn
    }
    
    @objc func nextAssemblyState() {
        switch assemblyBlockCurrentState {
        case .first:
            assemblyBlockCurrentState = .second
            print("assemblyBlockCurrentState is second")
        case .second:
            assemblyBlockCurrentState = .third
            date = Date()
            print("assemblyBlockCurrentState is third")
        case .third:
            assemblyBlockCurrentState = .first
            print("assemblyBlockCurrentState is first")
        }
    }
    
    @objc func secondAddingState() {
        addingBlockCurrentState = .second
        itemsQuantity += 1
        print("addingBlockCurrentState is second")
    }
    
    @objc func addItem() {
        itemsQuantity += 1
    }
    
    @objc func deleteItem() {
        if itemsQuantity == 1 {
            addingBlockCurrentState = .first
        }
        itemsQuantity -= 1
    }
}

extension UIView {
  func addDashedBorder() {
    let color = UIColor.black.cgColor

    let shapeLayer:CAShapeLayer = CAShapeLayer()
    let frameSize = self.frame.size
    let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height - 16)

    shapeLayer.bounds = shapeRect
    shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2 - 8)
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.strokeColor = color
    shapeLayer.lineWidth = 0.5
    shapeLayer.lineJoin = CAShapeLayerLineJoin.round
    shapeLayer.lineDashPattern = [1,2]
    shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath

    self.layer.addSublayer(shapeLayer)
    }
}
