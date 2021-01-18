//
//  FeedDetailViewController.swift
//  Guardian-UI
//
//  Created by Youssef Marouane on 18/01/2021.
//

import UIKit
import WebKit

public class FeedDetailViewController: UIViewController, FeedLoadingView, FeedErrorView {
   
    var interactor: FeedDetailInteractorProtocol?
    @IBOutlet private(set) public var webView: WKWebView?
    @IBOutlet private(set) public var errorView: ErrorView?
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
       interactor?.didRequestFeedRefresh()
    }

    public func display(_ viewModel: FeedLoadingViewModel) {
        
    }
    
    public func display(_ viewModel: FeedErrorViewModel) {
        errorView?.message = viewModel.message
    }
    
    public func setView(_ viewModel: FeedDetailViewModel) {
        webView?.loadHTMLString(viewModel.feedDetail.main+viewModel.feedDetail.body, baseURL: nil)
    }
}
