//
//  CourseCell.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import UIKit
import SnapKit

class CourseCell: UITableViewCell {

    var courseImage: UIImageView = {
        var view = UIImageView()
        view.layer.cornerRadius = 20
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        return view
    }()
    
    var courseName: UILabel = {
        var view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 19, weight: .bold)
        view.numberOfLines = 0
        view.adjustsFontSizeToFitWidth = true
        return view
    }()
    
    var courseNumberOfLesson: UILabel = {
        var view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 17)
        return view
    }()
    
    var courseNumberOfTest: UILabel = {
        var view = UILabel()
        view.textColor = .black
        view.font = .systemFont(ofSize: 17)
        return view
    }()
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createConstrainsForCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func createConstrainsForCell(){
        
        contentView.addSubview(courseImage)
        contentView.addSubview(courseName)
        contentView.addSubview(courseNumberOfLesson)
        contentView.addSubview(courseNumberOfTest)
        
        courseImage.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(150)
        }
        
        courseName.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.left.equalTo(courseImage).inset(175)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        courseNumberOfLesson.snp.makeConstraints { make in
            make.top.equalTo(courseName).inset(50)
            make.left.equalTo(courseImage).inset(175)
        }
        
        courseNumberOfTest.snp.makeConstraints { make in
            make.left.equalTo(courseNumberOfLesson)
            make.top.equalTo(courseNumberOfLesson).inset(25)
        }
    }

}

