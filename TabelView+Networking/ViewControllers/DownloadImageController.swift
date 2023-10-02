//
//  DownloadImageController.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import UIKit
import SnapKit

class DownloadImageController: UIViewController {
    
    private let url = "https://funart.top/uploads/posts/2022-08/1659985029_3-funart-pro-p-anime-tyanka-art-krasivo-3.jpg"

    let imageFromNetwork: UIImageView = {
        var view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    let myActivityIndef = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigBar()
        createAllCinstains()
        getImageFromNetwork()
        
    }
    
    private func createNavigBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back(param: )))
        navigationItem.title = "IMAGE"
    }
    
    private func createAllCinstains(){
        
        view.addSubview(imageFromNetwork)
        view.addSubview(myActivityIndef)
        
        imageFromNetwork.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        myActivityIndef.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
    
    
    private func getImageFromNetwork(){
        
        self.myActivityIndef.color = .black
        self.myActivityIndef.isHidden = false   //делам индификатор видимым
        self.myActivityIndef.startAnimating()    //запускаем индификатор
               
        //теперь вызывааем метод прописанный в networkManager для получения изображения из интнрнета, передавая ему url
        NetworkManager.downloadImage(urlImage: url) { image in
            
            //в замыкании омтанавливаем анимацию активити контроллера
            self.myActivityIndef.stopAnimating()
            //присваиваем переданную картинку UIImageView
            self.imageFromNetwork.image = image
        }
               

    }

    
    @objc private func back(param: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
}
