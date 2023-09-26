//
//  WebViewController.swift
//  TabelView+Networking
//
//  Created by petar on 26.09.2023.
//

import UIKit
import WebKit
import SnapKit

class WebViewController: UIViewController, WKUIDelegate {

    var selectCourse: String
    var courseURL: String


    var webView: WKWebView!
    
    override func loadView() {
        super.loadView()
        createNavigBar()
        let config = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: config)
        webView.uiDelegate = self
        view.addSubview(webView)
        
        webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        guard let url = URL(string: courseURL) else { return }
        let request = URLRequest(url: url)
        print(request)
        webView.load(request)
    }
    
    
    private func createNavigBar(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(back(param: )))
        navigationItem.title = selectCourse
    }
    
    @objc private func back(param: UIBarButtonItem){
        navigationController?.popViewController(animated: true)
    }
    
    //кастомный инициализатор чтобы передать данные о названии курса и его ссылке
    init(selectCourse: String, courseURL: String) {
        self.selectCourse = selectCourse
        self.courseURL = courseURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

