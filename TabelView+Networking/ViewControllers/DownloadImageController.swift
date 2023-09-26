//
//  DownloadImageController.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import UIKit
import SnapKit

class DownloadImageController: UIViewController {

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
               
               
        //делаем проверку на валидность url адреса при нажатии на кнопку
        guard let url = URL(string:"https://funart.top/uploads/posts/2022-08/1659985029_3-funart-pro-p-anime-tyanka-art-krasivo-3.jpg") else { return } //проверяем присвоится ли адрес переменной url если нет то просто выходим из метода
               
        //создаем экземпляр класса URLSession и вызываем метод shared
        let session = URLSession.shared
               
        //dataTask - данный метод создает задачу на получение содержимого по указанному url
        session.dataTask(with: url) { data, response, error in
        //данные содержатся в data, делаем проверку на извлечение данных
        if let data = data, let image = UIImage(data: data){
        //чтобы оновить задачу по обновления интерфейса, ее необходимо передать в основной поток и сделать загрузку интерфейса асинхронной
            DispatchQueue.main.async {
                self.myActivityIndef.stopAnimating() //при получении изоюражения индификатор останавливается и скрывается
                self.imageFromNetwork.image = image   //передаем полученное изображение UIImageView
                }
                       
            }
        }.resume()   //метод не будет запущен без указания этого метода
    }

    
    @objc private func back(param: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
}
