//
//  DataProvider.swift
//  TabelView+Networking
//
//  Created by petar on 03.10.2023.
//


//класс необходимый для загрузки данных в фоновом режиме
import UIKit

class DataProvider: NSObject{
    
    //свойсво класса которое захватывает текущий путь к файлу
    var fileLocation: ((URL) -> ())?
    
    //свойство значения прогресссса загрузки
    var onProgress: ((Double) -> ())?

    //cоздаем объект для натройки сесси
    private var downloadTask: URLSessionDownloadTask!
    
    
    
    //создаем лениваю приватную переменную ждя настройки конфигураций данных в фоне
    private lazy var backgroundSession: URLSession = {
        //свойство config будет определять поведение сесси при загрузки и выгрузки данных
        //создаем экземпляр класса URLSessionConfiguration
        //для возможномти загрузки в фоне вызываем метод background - в параметры передаем итндификатор приложения
        let config = URLSessionConfiguration.background(withIdentifier: "Hello")
        config.isDiscretionary = true      //свойство определяет могут ли фоновые задачи быть запланированны по усматрению системы (для передачи больших данных ставим тру)
        config.sessionSendsLaunchEvents = true    //по завершению загрузки данных приложение запустится в фоновм режиме
        //возаращаем объект URLSession с параметрами конфигурации сессии( в качетве делегата протокола назаначаю этот класс)
        return URLSession(configuration: config , delegate: self, delegateQueue: nil )
    }()
    
    
    //метод задачи по загрузке данных
    func startDownload(){
        
        //проверяем ссылку на валидность и если он валиден создаем экземпляр URLSession
        if let url = URL(string: "https://speed.hetzner.de/100MB.bin"){
            //объект downloadTask копирует предоставленныз параметрвы конфигурации и использует их для настройки сеанса(конфигурация настроенна в свойстве класса backgroundSession)
            downloadTask = backgroundSession.downloadTask(with: url)
            //earliestBeginDate - гарантирует что загрузка не начнется ранее заданого времени //загрузка не ранее чем через 3 секунды
            downloadTask.earliestBeginDate = Date().addingTimeInterval(3)
            //countOfBytesClientExpectsToSend - определяет наиболее явную верхнюю границу числа байтов которые клиент ожидает отправить
            downloadTask.countOfBytesClientExpectsToSend = 512
            //countOfBytesClientExpectsToReceive - определяет наиболее явную верхнюю границу числа байтов которые клиет ожидает получить
            downloadTask.countOfBytesClientExpectsToReceive = 100 * 1024 * 1024
            downloadTask.resume()
        }
    }
    
    //метод оствновки загрузки
    func stopDownload(){
        downloadTask.cancel()  //отменяет все задачи
    }
}


//расширение для метов делегата для полусения индификтора из AppDelegate
extension DataProvider: URLSessionDelegate{
    //данный метод вызывается по завершению всех фоновых задач помещенных в очередь с нашим интедификаторм приложения который необходимо пердать в AppDelegate
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        
        //создаем константу complitionHandler которой передаем значение итндификатора сессии захваченное из AppDelegate
        //затем обнуляем значение этого свойства  и вызываем исходный блок complitionHandler чтобы уведомить систему что загрузка завершена
        //необходимо выполнить асинхронно
        DispatchQueue.main.async {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate,
                  let complitionHandler = appDelegate.bgSessionComplitionHandler
            else { return }
            
            appDelegate.bgSessionComplitionHandler = nil
            complitionHandler()
        }
    }
}


//РСширене для получения ссылки на файл а также отображения процесса загрузки
extension DataProvider: URLSessionDownloadDelegate{
    
    //обязательный метод
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        //location - место в которое скачен файл
        
        print("Did Finish DownLoading: \(location.absoluteString)") //вывод в консоль локации куза был загружен файл
        
        //чтобы открыть файл для чтения надо это делать в другом потоке
        DispatchQueue.main.async {
            self.fileLocation?(location)
        }
    }
    
    //метод для отображения процесса загрузки
    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        
        guard totalBytesExpectedToWrite != NSURLSessionTransferSizeUnknown else { return }
        
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        print("Download progress: \(progress)")
        DispatchQueue.main.async {
            self.onProgress?(progress)
        }
    }
    
    
}


