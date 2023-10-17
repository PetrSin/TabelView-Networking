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
}
