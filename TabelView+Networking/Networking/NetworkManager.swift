//
//  NetworkManager.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import UIKit

class NetworkManager{
    
    //делаю методы статик чтобы обращаться к ним напрямую
    static func getAction(url: String){
        guard let url = URL(string: url) else { return }
        
        let session = URLSession.shared
      
        //data - данные с сервера
        //response - ответ с сервера
        //error - ошибки в процессе
        session.dataTask(with: url) { data, response, error in
            guard
                let data = data
            else { return }
            print(data)
            
            //переобразование данных получаемых с сервера
            do{
                let json = try JSONSerialization.jsonObject(with: data)  //преобразовываем json из данных в data
                print(json)
            }catch{
                print(error)   //в случае ошибки выводим ошибку
            }
            
        }.resume()      //важно необходимо инициализировать сессию
    }
    
    
    
    static func postAction(url: String){
        //проверяем url
        guard let url = URL(string: url  ) else { return }
        //в отличии от get запроса в post запросе необходимо передать данные
        //создаем словарь с даннвми которые будут переданны на сервер
        let userData = ["Coure": "Networking", "Leeson": "Get and Post requests"] //слварь с двнными которые можно поместить в тело запроса
        var request = URLRequest(url: url)  //создаем экземпляр класса URLRequest где в инициализацию передаю ссыллку провереннную в начале метода
        request.httpMethod = "POST"  //пережде чем сделать запрос, необходимо указать его метод
        
        //прежде чем отправить пользовательские данные на сервер их необходимо преобразовать в json формат
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData) else { return } //преобразовываю словарь в json формат при помощи JSONSerialization( try - на случай ошибки)( через гвард тк на выходе опционал)
        
        //после преобразования данных необзодимо поместить их в тело запроса
        request.httpBody = httpBody
        //добавляю в запрос необходимые параметры
        //(значение, то для какого заголока вводятся эти параметры)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        //теперь необходимо создать сессию для отправки данных на сервер
        //создаю экземпляр класса urlsession
        let session = URLSession.shared
        //создаем дататаск но с инициализатором URLrequest
        //передаем ему созданный ранее request
        session.dataTask(with: request) { data, response, error in
            //проверяем полученные данные
            guard let data = data, let response = response else { return }
            print(response)  //вывожу в консоль ответ сервера
            //<NSHTTPURLResponse: 0x6000002da200> { URL: https://jsonplaceholder.typicode.com/posts } { Status Code: 201, Headers }
            //статус код 201 - созданно, сл запись на сервер добавленнна
            
            //преобразую данные с сервера и в случаее ошибки - отлавливаю
            do{
                let json = try JSONSerialization.jsonObject(with: data)//преаращаю данные с сервера в json
                print(json)
            }catch{
                print(error)   //в случае ошибки выывожу ошибку
            }
        }.resume()  //запускаю сессию
    }
    
    
    //метод заппускается при переходе на DovnloadImageController
    //для передачи данных между контроллерами необходимо испоьзовать замыкание в параметрах функции
    //замыкание принемает UIImage и ничего не возвращает (обязательно прописать перед параметрами @escaping)
    static func downloadImage(urlImage: String, completion: @escaping (_ image: UIImage)->()){
        
        //делаем проверку на валидность url адреса при нажатии на кнопку
        guard let url = URL(string: urlImage) else { return } //проверяем присвоится ли адрес переменной url если нет то просто выходим из метода
               
        //создаем экземпляр класса URLSession и вызываем метод shared
        let session = URLSession.shared
               
        //dataTask - данный метод создает задачу на получение содержимого по указанному url
        session.dataTask(with: url) { data, response, error in
        //данные содержатся в data, делаем проверку на извлечение данных
        if let data = data, let image = UIImage(data: data){
        //чтобы оновить задачу по обновления интерфейса, ее необходимо передать в основной поток и сделать загрузку интерфейса асинхронной
            DispatchQueue.main.async {
                //передавая данне на другой контроллер вызываем замыкание из параметров функции
                //completion асинхронно в основной очереди захватывает параметр полученный с сервера и передаст его в другой контроллер
                completion(image)
                
                }
                       
            }
        }.resume()   //метод не будет запущен без указания этого метода
    }
    
    
    //метод будет вызываться при переходе на экран с курсами
    //параметры - сыллка на апи с курсами, замыкание для передачи данных (массив полученых данных с серваера и метод reloadData для таблицы)
    static func fetchDataCourse(url: String, comletion: @escaping (_ courses: [Course])->()){
        
        
        let jsonURLString = url
        guard let url = URL(string: jsonURLString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            
            do{
                let decoder = JSONDecoder()                 //создаю экземпляр декодера
                decoder.keyDecodingStrategy = .convertFromSnakeCase  //вызываю свойство keyDecodingStrategy и выбираю параметр convertFromSnakeCase
                
                //создаю новый массив courses
                let courses = try decoder.decode([Course].self, from: data)
                //вызывааю комплишен для передачи массива
                comletion(courses)
                
            }catch{
                 print("error serialozation json - \(error)")
            }
        }.resume()
    }
    
}

