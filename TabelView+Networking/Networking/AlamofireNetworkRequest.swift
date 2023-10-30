//
//  AlamofireNetworkRequest.swift
//  TabelView+Networking
//
//  Created by petar on 10.10.2023.
//




import Foundation
import UIKit
import Alamofire

//класс для работы с alamofire 
class AlamofireNetworkRequest {
    
    //для предачи данных процесса загрузки на DownloadImageBGViewController необходимы два статичных свочтва поторые будут захватывать данне и передавать их
    static var onProgress: ((Double) -> ())?  //тип данных замыкание с даблом и обязяанно быть опционалом (тут будет процесс хода загрузки для прогресс вью)
    static var completed: ((String) -> ())?   //тут будет статус загрузки
    
   //изменяю список параметров методат sendRequest для добавления комплишина для передачи данных в табоицу
    static func sendRequest(url: String, comletion: @escaping (_ courses: [Course])->()){
        
        guard let url = URL(string: url) else { return }
    
       
        AF.request(url, method: .get).validate().responseJSON { response in
            
            //тк полученный ответ с сервера имеет тип словарь Any, его нобходимо привести к словрью String:Any
            switch response.result{
            case .success(let value):
                //объявляю массив для данных полученных из интернета и пропущеных через модель
                var courses = [Course]()
                //в список после использования метода будут добавленны все полученные данные из интернета
                courses = Course.getArray(from: value)!
                //вызываю комплишн для передачи данных
                comletion(courses)
                
            case .failure(let error):
                print(error)
            }
           
        }
    }
    
    //метод для загрузки json с сервера
    static func getCoursesJson(url: String){
        
        //выполняю запрос для получения курсов с сервера в формате json
        AF.request(url).responseData { responseDara in
            
            switch responseDara.result{
            case .success(let data):
                //проверям получение данных и переводим их в string через кодировку
                guard let stringData = String(data: data, encoding: .utf8) else { return }
                print(stringData)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //метод для получения строки с сервера
    static func getStringAalamofire(url: String){
        
        AF.request(url).responseString { responseString in
            //в данном методе не нужно делать проверку гвардом тк прийдет точно стринг
            switch responseString.result{
            case .success(let massage):
                print(massage)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //метод получения данных с сервера без обработки и отдает их в том виде которм они получены
    //result -- отсудствует
    static func justResponse(url: String){
        
        AF.request(url).response { response in
            //тк отсудствует result делаем проверку через guard и вызываем методы конвертации у полученных значений
            //перврщаем полученные данные сначала в дату потом изи даты в строку
            guard
                let data = response.data,
                let string = String(data: data, encoding: .utf8)
            else { return }
            print(string)
        }
    }
    
    
    
    //метод для загрузки данны в фотне / реализованн в DownloadImageBGViewController
    //реализован комплишн хендлер для переноса полученных данных на другой эеран
    static func downloadImageAlamofire(url: String, complition: @escaping (_ image: UIImage) -> ()){
        
        AF.request(url).responseData { responseData in
            
            //свичем проверям полученные данные
            switch responseData.result{
            case .success(let data):
                //в случае успешного получения данных пытыюсь на их основе создать экземпляр UIImage
                guard let image = UIImage(data: data) else { return }
                //комплишн хендлером отправляю их дальше
                complition(image)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    //создаю метод для контроля процесса загруки
    static func downloadImageWithAlamofireProgress(url: String, complition: @escaping(_ image: UIImage) -> () ){
        //проверяю url
        guard let url = URL(string: url) else { return }
        
        //создю запрос
        //validate -- указываю для создании валидации
        //вызываю downloadProgress с замыканием -> на выходе получаю progress это экземпляр класса Progress который входит в класс Foundation
        //класс Progress имеет пять свойст которые предоставляют данные в процессе загрузки
        AF.request(url).validate().downloadProgress { (progress) in
            print("общий объем загружаемых файлов: ", progress.totalUnitCount)
            print("информици о загруженном объеме данных: ", progress.completedUnitCount)
            print("fractionCompleted(0.0 - 1.0): ", progress.fractionCompleted)
            print("описание хода загрузки: ", progress.localizedDescription!)
            print("------------------------------------------------------------------------")
            
            
            //передаю необходимые значения чтобы потом отобразить их на вью
            self.onProgress?(progress.fractionCompleted )        //(значение 0.0 - 1.0)
            self.completed?(progress.localizedDescription)
            
            
        }.response { response in     //получене ответа от сервера по пулчаемому изображению
            
            guard let data = response.data, let image = UIImage(data: data) else { return }
            
            //передаю изображение в комплишн хэндлер асинхронно в основном потоке
            DispatchQueue.main.async {
                complition(image)
            }
        }
    }
    
    
    //метод POST запроса на alamofire
    static func postRequestWithAlamofire(url: String, comletion: @escaping (_ courses: [Course])->()){
        //валидация url адреса
        guard let url = URL(string: url) else { return }
        
        //создание свойства с параметрами которые будут отправленны на сервер
        //тип словаря [String: Any] - это тот тип с котроым работает alamofire
        let userData: [String: Any] = ["name": "Network Request",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "number_of_lessons": 18,
                                       "number_of_tests": 10]
        
        //создаю запрос с указвним типа запроса и пердавапемых параметров
        AF.request(url, method: .post, parameters: userData).responseJSON { responseJSON in
            
            //делам проверку успешности запроса
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("status code -  " ,statusCode)
            
            //через свич проверям успешное получение данных и в случае успеха расскладываем их
            switch responseJSON.result{
            case .success(let value):
                print(value)
                //для того чтобы с объектом можно было работать необхоимо его привести к необходимым данным
                //если приведения объекта value (имеющего тип Any) к необходимому типу проходит успешно, то создаем объект course в который передаем приобразованные данные и парсим их по структуре Course
                guard let jsonObject = value as? [String: Any], 
                        let course = Course(json: jsonObject)  else { return }
                
                //создаем массив с типом Course чтобы добавить полученные данные и преобазованные в необходимый тип
                var courses = [Course]()
                courses.append(course)
                
                //передаем данный массив дальше через комплишн хендлер
                comletion(courses)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
    
    //PUT request метод для обнавления данных на сервере
    static func putRequestWithAlamofire(url: String, comletion: @escaping (_ courses: [Course])->()){
        
        guard let url = URL(string: url) else { return }
         
        //всталяю новые данные которые обновляю на сервере
        let userData: [String: Any] = ["name": "Network Request  1-1-1-1-1-1-1",
                                       "link": "https://swiftbook.ru/contents/our-first-applications/",
                                       "imageUrl": "https://swiftbook.ru/wp-content/uploads/sites/2/2018/08/notifications-course-with-background.png",
                                       "number_of_lessons": 18,
                                       "number_of_tests": 10]
        
        //меняю  метод запроса на .put
        AF.request(url, method: .put, parameters: userData).responseJSON { responseJSON in
            
            //делам проверку успешности запроса
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("status code -  " ,statusCode)
            print(responseJSON)
           
            switch responseJSON.result{
            case .success(let value):
                print(value)
                guard let jsonObject = value as? [String: Any],
                        let course = Course(json: jsonObject)  else { return }
                
                var courses = [Course]()
                courses.append(course)
                comletion(courses)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
