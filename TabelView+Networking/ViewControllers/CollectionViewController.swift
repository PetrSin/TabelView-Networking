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
}



private let url = "https://jsonplaceholder.typicode.com/posts"
private let urlUploadImage = "https://api.imgur.com/3/image"   //ссылка на сервер для загузки изображения

class CollectionViewController: UIViewController {

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
        }
    }
}

//раширения для интендификатора ячеки
extension CollectionViewController{
    static let idCell = "MyCell"
}

