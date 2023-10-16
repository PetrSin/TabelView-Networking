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
}
