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
    
    //метод request библиотеки alamofire (один из трех глобальных методов этой либы)
    //для его вызова не нужно создавать экземпляр класса Alamofire, необходимо обратиться напрямую
    static func sendRequest(url: String){
        
        guard let url = URL(string: url) else { return }
    
       //после request вызываем validate для создания валидации
        AF.request(url, method: .get).validate().responseJSON { response in
            
            //проверяем через switch
            //у response есть параметр result который может сказать пришел ответ с ошибкой или с результатом
            switch response.result{
                //удачная связь с сервером с объетом полученого значения (let value)
            case .success(let value):
                print(value)
                //ошибка полученная с сервера с объетом полученого значения (let value)
            case .failure(let error):
                print(error)
            }
           
        }
    }
}
