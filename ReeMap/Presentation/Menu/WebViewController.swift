import UIKit
import WebKit

class WebViewController: UIViewController {
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: self.view.frame)
        return webView
    }()
    
    var urlString: String
    
    init(url: String) {
        urlString = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myBlog = urlString
        guard let url = NSURL(string: myBlog) as? URL else { return }
        guard let request = NSURLRequest(url: url) as? URLRequest else { return }
        webView.navigationDelegate = self
        webView.load(request)
        self.view.addSubview(webView)
        self.view.sendSubviewToBack(webView)
        navigationController?.isNavigationBarHidden = false
    }
}

extension WebViewController: WKNavigationDelegate {
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        showError(message: R.string.localizable.error_message_network())
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
