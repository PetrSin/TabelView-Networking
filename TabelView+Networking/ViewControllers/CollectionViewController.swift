//
//  CollectionViewController.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import UIKit
import SnapKit

//создаю энум для перечесления всех возможноз пользовательских нажатий
//необхлжимы констаанты  перечесления использовать в качестве значений массива actiion6 для этого необходимо подписаться на проткол CaseIterable
//данный протокол позволяет вызвать свойсво allCases - которое создает массив из значений этого перечесления
//подписываем перечесление под String чтобы скоректировать тип сзначений массива
enum Actions: String, CaseIterable{
    case downloadImage = "Download Image"
    case get = "GET"
    case post = "POST"
    case ourCourses = "Our Courses"
    case uploadImage = "Upload Image"
    case downloadFile = "Download File"
}



private let url = "https://jsonplaceholder.typicode.com/posts"
private let urlUploadImage = "https://api.imgur.com/3/image"   //ссылка на сервер для загузки изображения

class CollectionViewController: UIViewController {
    
    //создаем аллерт для отопражения загрузки принажатии на "Download File"
    private var alert: UIAlertController!
    
    //создаю экземпляр DataProvider
    private let dataProvaider = DataProvider()

    //let actiion = ["Download Image", "GET", "POST", "Our Courses", "Upload Image"]
    
    let actions = Actions.allCases
    
    let myCollection: UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.scrollDirection = .vertical
        collectionLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 125)
        collectionLayout.minimumLineSpacing = 40                                                //растояние между ячеками
        collectionLayout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 100, right: 0)   //отступы со всех сторон
        var view = UICollectionView(frame: .zero, collectionViewLayout: collectionLayout)
        view.register(CollectionCell.self, forCellWithReuseIdentifier: CollectionViewController.idCell)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigBar()
        configCollectionView()

    }
    
    private func createNavigBar(){
        navigationController?.navigationBar.backgroundColor = UIColor(red: 172/255, green: 172/255, blue: 172/255, alpha: 1)
        navigationItem.title = "Controls"
    }
    
    private func configCollectionView(){
        myCollection.backgroundColor = .white
        myCollection.dataSource = self
        myCollection.delegate = self
        
        view.addSubview(myCollection)
        
        myCollection.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    //метод создания и вызова аллерт контроллера
    private func showAlert(){
        
        
        alert = UIAlertController(title: "Downloading...", message: "0%", preferredStyle: .alert)
        //делаю алерт подлинее
        let hightAlertCost = NSLayoutConstraint(item: alert.view!,
                                                attribute: .height,
                                                relatedBy: .equal,
                                                toItem: nil,
                                                attribute: .notAnAttribute,
                                                multiplier: 0,
                                                constant: 185)
        //подключаю констреинт
        alert.view.addConstraint(hightAlertCost)
        
        //создаю кнопку выхода и добавляю ей функцию отмены загрузки
        let canselAlertButton = UIAlertAction(title: "Cansel", style: .destructive){ (action) in
            self.dataProvaider.stopDownload()
        }
        
        alert.addAction(canselAlertButton)
        
        //через замыкание создаю и вызывваю активити контроллер и прогресс бар
        present(alert, animated: true){
            
            //let sizeActivit = CGSize.init(width: 40, height: 40)   //задаю размер для активити индикатора
            //создаю коардинаты для активити контроллера чтобы он был посередтине аллерт контроллера( - sizeActivitm / 2 тк это коардинаты правой верхней точки)
            //let pointActivit = CGPoint(x: self.alert.view.frame.width / 2 - sizeActivit.width / 2, y: self.alert.view.frame.height / 2 - sizeActivit.height / 2)
            //let indicator = UIActivityIndicatorView(frame: CGRect(origin: pointActivit, size: sizeActivit)) //инициализируем объект с созданными значениями
            let indicator = UIActivityIndicatorView()
            indicator.color = .gray
            indicator.startAnimating()
            
            //y: self.alert.view.frame.height - 44    -- высота котролеера минус высота кнопки
            //let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 5))
            let progressView = UIProgressView()
            progressView.tintColor = .green
            progressView.progress = 0.5
            
            self.alert.view.addSubview(indicator)
            self.alert.view.addSubview(progressView)
            
            //тк не нравится СG переписал на SnapKit
            indicator.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.width.height.equalTo(40)
            }
            
            progressView.snp.makeConstraints { make in
                make.bottom.equalToSuperview().inset(44)  //44 размер кнопки cansel
                make.width.equalToSuperview()
                make.height.equalTo(5)
            }
        }
    }
    
}

extension CollectionViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollection.dequeueReusableCell(withReuseIdentifier: CollectionViewController.idCell, for: indexPath) as! CollectionCell
        //получение текствого значения эллемента перечесления  через rawValue
        //те обращаюсь к массиву элеметов перечесления и вызываю метод для извлечения их значения
        cell.cellLabel.text = actions[indexPath.item].rawValue
        
        return cell
    }
    
}

extension CollectionViewController: UICollectionViewDelegate{
    //метод который отвесает за выбранную ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //передает в переменную название выьранной ячеки
        let action = actions[indexPath.item]
        
        
        //через конструкцию свич вызываю необходимые контроллеры или вызываю методы из networking
        //теперь делаю проверку нажатия не по тексту, а по эллементу массива
        switch action{
        case .downloadImage:
            navigationController?.pushViewController(DownloadImageController(), animated: true)
        case .get:
            NetworkManager.getAction(url: url)          //юрл прописан в начале файла
        case .post:
            NetworkManager.postAction(url: url)
        case .ourCourses:
            navigationController?.pushViewController(CoursesPageViewController(), animated: true)
        case .uploadImage:
            NetworkManager.uploadImage(url: urlUploadImage)
        case .downloadFile:
            showAlert()
            dataProvaider.startDownload()  //по нажатию на кнопку начать загрркзку
            
        }
    }
}

//раширения для интендификатора ячеки
extension CollectionViewController{
    static let idCell = "MyCell"
}

