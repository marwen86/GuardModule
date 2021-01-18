//
//  Copyright © 2019 Highthem ©. All rights reserved.
//

import UIKit

final class FeedItemCellController: FeedItemView {
	private let intercator: FeedCellInteractorProtocol
	private var cell: FeedItemCell?
    private var id: UUID?
	
	init(intercator: FeedCellInteractorProtocol) {
		self.intercator = intercator
	}
	
	func view(in tableView: UITableView) -> UITableViewCell {
		cell = tableView.dequeueReusableCell()
        intercator.didRequestImage()
		return cell!
	}
	
	func preload() {
        intercator.didRequestImage()
	}
	
	func cancelLoad() {
		releaseCellForReuse()
        intercator.didCancelImageRequest()
	}
	
    func display(_ viewModel: FeedItemViewModel) {
		cell?.title.text = viewModel.title
		cell?.thumbnail.setImageAnimated(viewModel.image)
        cell?.publicationDate.text = viewModel.publicationDate
        cell?.thumbnail.makeRounded()
	}

    func didSelect() {
        // TODO
    }
	
	private func releaseCellForReuse() {
		cell = nil
	}
}
