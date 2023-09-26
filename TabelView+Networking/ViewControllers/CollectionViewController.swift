//
//  CollectionViewController.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import UIKit
import SnapKit

private let url = "https://jsonplaceholder.typicode.com/posts"

class CollectionViewController: UIViewController {

    let actiion = ["Download Image", "GET", "POST", "Our Courses", "Upload Image"]
    
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
        return actiion.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollection.dequeueReusableCell(withReuseIdentifier: CollectionViewController.idCell, for: indexPath) as! CollectionCell
        //название ячеек это текст из массива
        cell.cellLabel.text = actiion[indexPath.item]
        
        return cell
    }
    
}

extension CollectionViewController: UICollectionViewDelegate{
    //метод который отвесает за выбранную ячейку
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //передает в переменную название выьранной ячеки
        let action = actiion[indexPath.item]
        
        
        //через конструкцию свич вызываю необходимые контроллеры или вызываю методы из networking
        switch action{
        case "Download Image":
            navigationController?.pushViewController(DownloadImageController(), animated: true)
        case "GET":
            NetworkManager.getAction(url: url)          //юрл прописан в начале файла
        case "POST":
            NetworkManager.postAction(url: url)
        case "Our Courses":
            navigationController?.pushViewController(CoursesPageViewController(), animated: true)
        case "Upload Image":
            print("Upload Image")
        default:
            break
        }
    }
}

//раширения для интендификатора ячеки
extension CollectionViewController{
    static let idCell = "MyCell"
}

