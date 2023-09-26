//
//  CollectionCell.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import UIKit
import SnapKit

class CollectionCell: UICollectionViewCell {
    
    var cellLabel: UILabel = {
        var view = UILabel()
        view.font = .systemFont(ofSize: 30)
        view.textColor = .white
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI(){
        contentView.backgroundColor = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1)
        contentView.layer.cornerRadius = 30
        
        contentView.addSubview(cellLabel)
        
        cellLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
