//
//  DetailViewController.swift
//  Project7
//
//  Created by Oluwabusayo Olorunnipa on 7/13/21.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let detailItem = detailItem else { return }
        
        let html = """
            <html>
            <head>
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <style> body { font-size: 150%; } </style>
            </head>
            <body>
            <p><b>\(detailItem.title)</b></p>
            <p><b>Number of signatures : </b>\(detailItem.signatureCount)</p>
            <p>\(detailItem.body)</p>
            </body>
            </html>
            """
        
        webView.loadHTMLString(html, baseURL: nil)

 
    }
    

}
