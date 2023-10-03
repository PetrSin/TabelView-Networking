//
//  ImageProperties .swift
//  TabelView+Networking
//
//  Created by petar on 03.10.2023.
//

import UIKit

//для выгрузки изображения на https://imgur.com/ необходима структура где будет ключ и само выгружаемое изображение
struct ImageProperties{
    
    let key:  String
    let data: Data
    
    
    
    //для передачи данных необходим инициализатор
    init?(forKey key: String, withImage image: UIImage) {
        self.key = key
        //метод класса UIImage конвертирующий изображение в Data(тк возврвщает опционал необходима проверка)
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
