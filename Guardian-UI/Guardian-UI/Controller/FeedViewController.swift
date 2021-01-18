//
//  FeedViewController.swift
//  Guardian
//
//  Created by Youssef Marouane on 18/01/2021.
//

import UIKit
import GuardianCore

public final class FeedViewController: UITableViewController, FeedLoadingView, FeedErrorView {

    @IBOutlet private(set) public var errorView: ErrorView?

    public var router: FeedRouterLogic?
    var interactor: FeedInteractorProtocol?
    var tableModel = [FeedItemCellController]() {
        didSet { tableView.reloadData() }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        refresh()
    }
    
    @IBAction private func refresh() {
        interactor?.didRequestFeedRefresh()
    }
    
    func display(_ viewModel: FeedViewModel) {
        tableView.reloadData()
    }
    
    public func display(_ viewModel: FeedLoadingViewModel) {
        refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
    
    public func display(_ viewModel: FeedErrorViewModel) {
        errorView?.message = viewModel.message
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cellController(forRowAt: indexPath).view(in: tableView)
    }
    
    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).didSelect()
        router?.goToDetail(url: URL(string:  "https://content.guardianapis.com/football/2020/dec/28/football-and-brexit-a-guide-to-the-new-rules"))
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedItemCellController {
        return tableModel[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}
