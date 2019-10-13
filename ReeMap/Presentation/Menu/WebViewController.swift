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
    
    override func loadView() {
        super.loadView()
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        self.view.sendSubviewToBack(webView)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myBlog = urlString
        guard let url = NSURL(string: myBlog) as? URL else { return }
        guard let request = NSURLRequest(url: url) as? URLRequest else { return }
        webView.load(request)
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        showError(message: R.string.localizable.error_message_network())
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
        showError(message: R.string.localizable.error_message_network())
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.setIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.setIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url?.absoluteString else { return }
        url.hasPrefix("http") ? decisionHandler(.allow) : decisionHandler(.cancel)
    }
}
