//
//   .swift
//  TabelView+Networking
//
//  Created by petar on 20.10.2023.
//

import UIKit
import SnapKit

class DownloadImageBGViewController: UIViewController {
    
    private let url = "https://ru.myanimeshelf.com/upload/dynamic/2010-11/21/630172.jpg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"     //сыллка загрузки большого изображения

    let imagevView: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let progressTextLabel: UILabel = {
        var view = UILabel()
        view.text = "HEllO WORLD"
        view.font = .systemFont(ofSize: 30, weight: .bold)
        view.textColor = .black
        view.textAlignment = .center
        return view
    }()
    
    let progressView: UIProgressView = {
        var view = UIProgressView(progressViewStyle: .default)
        view.tintColor = .green
        view.isHidden = false
        return view
    }()
    
    let activivtyIndicator: UIActivityIndicatorView = {
        var view = UIActivityIndicatorView(style: .large)
        view.color = .black
        view.startAnimating()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configViewElements()
        createNavigBar()
        //fetchDataWithAlamofier()
        downloadImageWithProgress()
    }
    
    
    
    //обычний метод поучения изображения с сервера и подставления его во UIImageView
    private func fetchDataWithAlamofier(){
        //вызвваю заранее созданный метод для получения изображения
        AlamofireNetworkRequest.downloadImageAlamofire(url: url) { image in
            //скрываю все ui эллементы на экране
            self.activivtyIndicator.isHidden = true
            self.progressView.isHidden = true
            self.progressTextLabel.isHidden = true
            //предаю полученное изображение на imagevView
            self.imagevView.image = image
            self.downloadImageWithProgress()
        }
    }
    
    //метод загрузки в фоне изображения с отображения прогресса загрузки
    private func downloadImageWithProgress(){
        //подставляю данные процесса загрузки
        //делаю через замыкание подставление значений
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.isHidden = false      //делаю его видимым
            self.progressView.progress = Float(progress)    //подставлю значение в шкалу загрузки
        }
        AlamofireNetworkRequest.completed = { complited in
            self.progressTextLabel.isHidden = false
            self.progressTextLabel.text = complited
        }
        
        //вызываю метод лоя загрузки изображения в фоне
        AlamofireNetworkRequest.downloadImageWithAlamofireProgress(url: largeImageUrl) { image in
            //скрываю все UI эллемнты отогражения загрузки
            self.activivtyIndicator.isHidden = true
            self.progressView.isHidden = true
            self.progressTextLabel.isHidden = true
            //достаю из комплишн хендлера полученное изображение
            self.imagevView.image = image
        }
    }
    
    
    private func configViewElements(){
        
        view.addSubview(imagevView)
        view.addSubview(progressTextLabel)
        view.addSubview(progressView)
        view.addSubview(activivtyIndicator)
        
        
        imagevView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        progressTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(150)
            make.height.equalTo(50)
            make.width.equalTo(250)
        }
        
        activivtyIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        progressView.snp.makeConstraints { make in
            make.top.equalTo(activivtyIndicator).inset(100)
            make.centerX.equalToSuperview()
            make.height.equalTo(10)
            make.width.equalTo(250)
        }
        
    }
    
    private func createNavigBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back(param: )))
        navigationItem.title = "ALAMOFIRE"
    }
    
    @objc private func back(param: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }


}
