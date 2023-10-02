//
//  CoursesPageViewController.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import UIKit
import WebKit
import SnapKit

class CoursesPageViewController: UIViewController {

    var myTabelview = UITableView()
    var courses = [Course]()                    //тк код из блка do имеет ограниченную область видимости делаю его свойством класса
    
    //создаем две переменные в которых будут храниться имя и ссылка выбранного курса
    //через func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    var nameSelectCourse = ""
    var urlSelectCourse = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigBar()
        createTableView()
        fetchData()
        
    }
    private func createTableView(){
        myTabelview = UITableView(frame: .zero, style: .plain)
        myTabelview.register(CourseCell.self, forCellReuseIdentifier: CoursesPageViewController.idCell)
        myTabelview.dataSource = self
        myTabelview.delegate = self
        
        
        view.addSubview(myTabelview)
        myTabelview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    }
    
    
    private func createNavigBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back(param: )))
        navigationItem.title = "Courses"
    }
    
    @objc private func back(param: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
    func fetchData(){

        let jsonURLString = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
        guard let url = URL(string: jsonURLString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            
            do{
                let decoder = JSONDecoder()                 //создаю экземпляр декодера
                decoder.keyDecodingStrategy = .convertFromSnakeCase  //вызываю свойство keyDecodingStrategy и выбираю параметр convertFromSnakeCase
                
                //и вызываю декодирование через уже созданный экземпляр
                self.courses = try decoder.decode([Course].self, from: data)
                
                //метод необходим для перезагрузки данныз в таблице после подставления их с сервера
                DispatchQueue.main.async {
                    self.myTabelview.reloadData()
                }
                
            }catch{
                 print("error serialozation json - \(error)")
            }
        }.resume()
    }
    
    
    //метод для передачи полученных данных в лейбы ячейки
    private func configurateCell(cell: CourseCell, for indexPath: IndexPath){
        let course = courses[indexPath.item]     //создаем констату с конкретным объектом из массива courses в который мы передали данные полученные с сервера
        cell.courseName.text = course.name   //передаем полученные данные с сервера в сыойства ячейки
        //делаем проверку на наличие данных полученых с сервера и в случаае получения поставляем в лейблы таблицы
        if let numberOfLessons = course.numberOfLessons{
            cell.courseNumberOfLesson.text = "Number Of Lessons: \(numberOfLessons)"
        }
        
        
        if let numberOfTest = course.numberOfTests{
            cell.courseNumberOfTest.text = "Number Of Test: \(numberOfTest)"
        }
   
        //работа с данными которые получаем из сети должно происходить асинхронно в глобальном потоке
        DispatchQueue.global().async {
            //получем данные о картинки с сервера и через dataTask вставляем из в ячейку
            guard let url = URL(string: course.imageUrl) else { return }
            guard let imageData = try? Data(contentsOf: url) else { return }  //создаю экземпляр класса Data и получаю данные из url
            
            //отрисовка интерфейса долно происходить асинхронно но в основном потоке
            DispatchQueue.main.async {
                cell.courseImage.image = UIImage(data: imageData)
            }
        }
   
        
    }
    
}



extension CoursesPageViewController{
    static let idCell = "MyCell"
}

extension CoursesPageViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count   //кол-во ячеек равно количеству эллеметов в массиве courses
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //при регистрации ячеки в таблицу указываю класс через который буду работать с ячейками
        let cell = myTabelview.dequeueReusableCell(withIdentifier: CoursesPageViewController.idCell, for: indexPath) as! CourseCell
        
        //вызываем метод написанный ранее для передачи контента в ячеку
        //лучше перед этим вызввать у таблицы метод релоуд дата
        configurateCell(cell: cell, for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]  //в переменную сохраняем элемент массива по которму тапнул пользователь
        
        urlSelectCourse = course.link   //сохраняем в переменную ссылку на выбранный курс
        nameSelectCourse = course.name
        
        //метод который после тапа на ячейку открывает следующий контроллер
        performSelector(inBackground: #selector(presentWebView), with: nil)
    }
    
    //переход на другой экран нужно в маин канале делать
    @objc func presentWebView(){
        DispatchQueue.main.async{
            self.navigationController?.pushViewController(WebViewController(selectCourse: self.nameSelectCourse, courseURL: self.urlSelectCourse), animated: true)
        }
    }
    
    
}

