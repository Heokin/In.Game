//
//  cell.swift
//  In.GameTestTask
//
//  Created by Stas Dashkevich on 26.03.22.
//

import Foundation
import UIKit
import Alamofire

final class LabelCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: self)
    
    private lazy var label = makeLabel()
    private lazy var gradientView = makeGradientView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gradientView.alpha = 0
        contentView.backgroundColor = .clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.layer.cornerRadius = Constant.cornerRadius
        gradientView.layer.frame = bounds
        contentView.clipsToBounds = true
    }
    
    func configure(entity: Entity) {
        label.text = entity.text
        switch entity.state {
        case .normal:
            contentView.backgroundColor = UIColor.systemGray
        case .selected:
                gradientView.alpha = 1
        }
    }
}

private extension LabelCollectionViewCell {
    
    func prepareUI() {
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(Constant.sideInset)
            make.centerY.equalToSuperview()
        }
    }
    
    
    
    func makeLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        
        return label
    }
    
    func makeGradientView() -> GradientView {
        let view = GradientView(from: .top, to: .bottom, startColor: UIColor.red.withAlphaComponent(0.6), endColor: UIColor.purple.withAlphaComponent(0.6))
//        view.layer.frame = bounds
        contentView.insertSubview(view, at: 0)
        view.alpha = 0
        
        return view
    }
}

extension LabelCollectionViewCell {
    class Entity: Hashable {
        static func == (lhs: LabelCollectionViewCell.Entity, rhs: LabelCollectionViewCell.Entity) -> Bool {
            return lhs.text == rhs.text && lhs.state == rhs.state
        }
        
        let text: String
        var state: State
        
        init(text: String) {
            self.text = text
            self.state = .normal
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(text)
            hasher.combine(state)
        }
    }
}

extension LabelCollectionViewCell {
    enum State {
        case normal, selected
    }
}

private extension LabelCollectionViewCell {
    enum Constant {
        static var sideInset: CGFloat { 10.0 }
        static var cornerRadius: CGFloat { 10.0 }
    }
}
