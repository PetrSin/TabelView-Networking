//
//  Course.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import Foundation

//для того чтобы не нужно было каждый раз приводить типы для проведения их через структуру данных, необходимо прописать нициализатор/оптимизировать для работы с аламофаер
//старая версия
//struct Course: Decodable{
//
//    let id: Int
//    let name: String
//    let link: String
//    let imageUrl: String
//    let numberOfLessons: Int?
//    let numberOfTests: Int?
//}


//новая структура будет работать как с URLSession так и с alamofire

struct Course: Decodable{

    let id: Int?
    let name: String?
    let link: String?
    let imageUrl: String?
    let numberOfLessons: Int?
    let numberOfTests: Int?
    
    
    init?(json: [String:Any]){
        //логикка переноса типов в структуру переносится в инициализатор 
        let id = json["id"] as? Int
        let name = json["name"] as? String
        let link = json["link"] as? String
        let imageUrl = json["imageUrl"] as? String
        let numberOfLessons = json["number_of_lessons"] as? Int
        let numberOfTests = json["number_of_tests"] as? Int
        
        
        self.id = id
        self.name = name
        self.link = link
        self.imageUrl = imageUrl
        self.numberOfLessons = numberOfLessons
        self.numberOfTests = numberOfTests
        }
    
    //метод структуры который будет получать массив и обрабатывать его
    static func getArray(from jsonArray: Any) -> [Course]?{
        
        //создаем переменную и приводим ее типу масива словарей - в случае неудачи возвращаем нилл
        guard let jsonArray = jsonArray as? Array<[String: Any]> else { return nil }
        var courses: [Course] = []
        
        //перенесенно из сетевого слоя аламофайра
        for jsonObject in jsonArray{
            //eсли получается разложить полученные данные через инициализатор то добавляем его в массив который вернем
            if let course = Course(json: jsonObject){
                courses.append(course)
            }
        }
        
        return courses
    }
   
}
