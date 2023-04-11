//
//  ViewController.swift
//  Javascript
//
//  Created by Mathew Thomas Li on 4/10/23.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        label.font = UIFont(name: "Neuton-ExtraBold", size: 54)

        let bundleURL = Bundle.main.bundleURL

        webView.loadHTMLString(("<html><head></head><body><h1>ABCDEFGHIJKLMNOP</h1></body></html>"), baseURL: bundleURL)
        
        // Manually adding <link rel=\"stylesheet\" type=\"text/css\" href=\"markup.css\"> applies the styling from markup.css
//        webView.loadHTMLString(("<html><head><link rel=\"stylesheet\" type=\"text/css\" href=\"markup.css\"></head><body><h1>ABCDEFGHIJKLMNOP</h1></body></html>"), baseURL: bundleURL)
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let baseUrl = Bundle.main.path(forResource: "markup", ofType: "css")
        let cssString = try! String(contentsOfFile: baseUrl!).components(separatedBy: .newlines).joined()

        let source = """
              var style = document.createElement('style');
              style.innerHTML = '\(cssString)';
              document.head.appendChild(style);
            """

        let userScript = WKUserScript(source: source,
                                          injectionTime: .atDocumentEnd,
                                          forMainFrameOnly: true)

        let userContentController = WKUserContentController()
        userContentController.addUserScript(userScript)

        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
    }
}
