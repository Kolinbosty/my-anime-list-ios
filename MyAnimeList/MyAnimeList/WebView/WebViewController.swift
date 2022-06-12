//
//  WebViewController.swift
//  MyAnimeList
//
//  Created by Alex Lin 公司 on 2022/6/12.
//

import UIKit
import WebKit

public class WebViewController: UIViewController {

    public enum ExtraDecision {
        case made
        case pass
    }

    public private(set) weak var webView: WKWebView!
    private weak var progressView: UIProgressView!
    private weak var bottomView: UIView!
    public private(set) var bottomViewHeightConstraint: NSLayoutConstraint!

    open var changeTitleFromWebView: Bool { true }

    private var isCustomTitle: Bool = false

    // Observer
    private var progressObserver: NSKeyValueObservation?
    private var loadingObserver: NSKeyValueObservation?
    private var titleObserver: NSKeyValueObservation?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
        setupNaviItems()
    }

    public init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
        setupNaviItems()
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startListeningWebView()
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopListeningWebView()
    }

    /// 如果需要多作其餘的網址的判斷，覆寫這個，並在下了決定的時候回傳 made，如果都沒做決定就回傳 pass。
    /// - Returns: Extra Decision Block
    open var extraDecision: (WKWebView, WKNavigationAction, @escaping (WKNavigationActionPolicy) -> Void) -> ExtraDecision {
        // Default
        return { _, _, _ in return .pass }
    }

    open func setupNaviItems() {}

    func configCustomNaviTitle(title: String) {
        isCustomTitle = true

        // Navi
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactAppearance = appearance

        // Title
        self.title = title
    }
}

extension WebViewController {
    public func load(_ url: URL?) {
        guard let url = url else { return }

        webView.load(.init(url: url))
    }
}

// MARK: - WK
extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }

        // Check extra decision
        guard extraDecision(webView, navigationAction, decisionHandler) == .pass else {
            // Already made decision, just skip
            return
        }

        // Conditions
        let scheme = url.scheme?.lowercased()
        let isHTTP = (scheme == "http") || (scheme == "https")
        let isStore = url.absoluteString.contains("//itunes.apple.com/") || url.absoluteString.contains("//apps.apple.com/")
        let isExternal = isStore || !isHTTP

        if isExternal {
            // Loading with Safari
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            // Loading with webview
            decisionHandler(.allow)
        }
    }
}

extension WebViewController: WKUIDelegate {
    // 處理收到另開分頁的 Loading
    public func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        // Load request without create webView
        if let targetFrame = navigationAction.targetFrame, targetFrame.isMainFrame {
            webView.load(navigationAction.request)
        }

        return nil
    }

    // 以下三個 Method 必須要實作才會有作用，處理 default JS 的 command。
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {

        // Create native alert
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let confirmString = "Confirm"
        let confirmAction = UIAlertAction(title: confirmString, style: .default) { (action) in
            completionHandler()
        }
        alertController.addAction(confirmAction)

        // Present
        self.present(alertController, animated: true, completion: nil)
    }

    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {

        // Create native confirm
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        let confirmString = "Confirm"
        let confirmAction = UIAlertAction(title: confirmString, style: .default) { (action) in
            completionHandler(true)
        }
        alertController.addAction(confirmAction)

        let cancelString = "Cancel"
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel) { (action) in
            completionHandler(false)
        }
        alertController.addAction(cancelAction)

        // Present
        self.present(alertController, animated: true, completion: nil)
    }

    public func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {

        // Create native prompt
        let alertController = UIAlertController(title: nil, message: prompt, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = defaultText
        }

        weak var weakAlertController = alertController
        let confirmString = "Comfirm"
        let confirmAction = UIAlertAction(title: confirmString, style: .default) { action in
            let textField = weakAlertController?.textFields?[0] as UITextField?
            completionHandler(textField?.text)
        }
        alertController.addAction(confirmAction)

        let cancelString = "Cancel"
        let cancelAction = UIAlertAction(title: cancelString, style: .cancel) { _ in
            completionHandler(nil)
        }
        alertController.addAction(cancelAction)

        // Present
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - KVO
extension WebViewController {
    private func startListeningWebView() {
        // Update progress
        progressObserver = webView.observe(\.estimatedProgress) { [weak self]  (webView, _) in
            guard let self = self else { return }
            self.progressView.progress = Float(webView.estimatedProgress)
        }

        // Show/hide progressView
        loadingObserver = webView.observe(\.isLoading) { [weak self] (webView, _) in
            guard let self = self else { return }
            self.progressView.isHidden = !webView.isLoading
        }

        // Navi titlle
        if !isCustomTitle {
            titleObserver = webView.observe(\.title, changeHandler: { [weak self] (webView, _) in
                guard let self = self, self.changeTitleFromWebView else { return }
                self.title = webView.title
            })
        }
    }

    private func stopListeningWebView() {
        progressObserver = nil
        loadingObserver = nil
        titleObserver = nil
    }
}

// MARK: - Create UI
extension WebViewController {
    private func setupUI() {
        // Create
        createWebView()
        createProgressView()
        createBottomView()

        // Layout
        setupConstraint()
    }

    private func createWebView() {
        guard webView == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let config = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.uiDelegate = self
        webView.navigationDelegate = self

        // Add
        view.addSubview(webView)
        self.webView = webView
    }

    private func createProgressView() {
        guard progressView == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.isHidden = true // Default hidden

        // Add
        view.addSubview(progressView)
        self.progressView = progressView
    }

    private func createBottomView() {
        guard bottomView == nil else {
            assert(false, "Error: Already Created!")
            return
        }

        // Create
        let bottomView = UIView()
        bottomView.translatesAutoresizingMaskIntoConstraints = false

        // Add
        view.addSubview(bottomView)
        self.bottomView = bottomView
    }

    private func setupConstraint() {
        NSLayoutConstraint.activate([
            // Progress
            progressView.topAnchor.constraint(equalTo: view.topAnchor),
            progressView.leftAnchor.constraint(equalTo: view.leftAnchor),
            progressView.rightAnchor.constraint(equalTo: view.rightAnchor),
            // WebView
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor),
            // BottomView
            bottomView.topAnchor.constraint(equalTo: webView.bottomAnchor),
            bottomView.leftAnchor.constraint(equalTo: view.leftAnchor),
            bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])

        // BottomView Height
        bottomViewHeightConstraint = bottomView.heightAnchor.constraint(equalToConstant: 0.0)
        bottomViewHeightConstraint.isActive = true
    }
}
