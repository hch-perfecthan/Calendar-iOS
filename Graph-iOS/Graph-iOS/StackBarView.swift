//
//  StackBarView.swift
//  Graph-iOS
//
//  Created by Chang-Hoon Han on 2021/07/12.
//  Copyright © 2021 Chang-Hoon Han. All rights reserved.
//

import UIKit

class StackBarView: UIView {
    
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    
    /**
     * https://sujinnaljin.medium.com/swift-%EC%BB%A4%EC%8A%A4%ED%85%80-%EB%B7%B0-xib-%EC%97%B0%EA%B2%B0%ED%95%98%EA%B8%B0-files-owner-vs-custom-class-89984ef73a59
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    func initUI() {
        if let view = Bundle.main.loadNibNamed("StackBarView", owner: self, options: nil)?.first as? UIView {//UINib(nibName: "StackBarView", bundle: nil).instantiate(withOwner: self, options: nil).first as? UIView {
            view.frame = self.bounds
            addSubview(view)
        }
    }
}
