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
    
        //по умолчанию происходит get запрос
        //если необходимо создать опрелеленный запрос в request указваем параметор mettod
        //AF.request(url, method: .post)
        AF.request(url, method: .get).responseJSON { response in
            
            //демаем проверку по статус коду
            //у ответа сервера получаем статус код
            guard let statusCode = response.response?.statusCode else { return }
            print("SC --- \(statusCode)")
            
            //проверяем статус код диапазоном
            //если статус код от 200 до 300 включительно
            //получить значение у ответа сервера и вывести на экран
            if (200..<300).contains(statusCode){
                let value = response.value
                print("value: ", value ?? "nil")
            }else{
                //в случае статус кода указывающего на ошибку
                //создаем переменную хронящуу в себе ошибку
                //выводим ошибку на экран
                let error = response.error
                print("ERROR - ", error ?? "error")
            }
        }
    }
}
