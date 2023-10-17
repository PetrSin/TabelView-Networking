//
//  ResponseDataAlamofierImageController.swift
//  TabelView+Networking
//
//  Created by petar on 17.10.2023.
//

import UIKit
import SnapKit
import Alamofire

class ResponseDataAlamofierImageController: UIViewController {
    
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
        fechImageWichAlamofire()
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
    
    
    private func fechImageWichAlamofire(){
        
        self.myActivityIndef.color = .black
        self.myActivityIndef.isHidden = false   //делам индификатор видимым
        self.myActivityIndef.startAnimating()    //запускаем индификатор
             
        //создаю реквест на аламофайре и на получение выбираю респонсДата
        AF.request(url).responseData { responseData in
        
            
            //прописываю проверку через switch - выбрав метод result который выведет либо данные либо ошибку с сервера
            switch responseData.result{
            //удачное получение данных --- в скобочках переменная в которую будет переданно значение полученное с сервера
            case .success(let data):
                guard let image = UIImage(data: data) else { return }   //проверкай передаю полученне данные в переменную
                self.myActivityIndef.stopAnimating()   //останавливаю индикатор прогрузки
                self.imageFromNetwork.image = image
            case .failure(let error):
                
                print(error)
            }
            
        }
    }

    
    @objc private func back(param: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
}

