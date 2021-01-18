//
//  FeedItemCell.swift
//  eurosport
//
//  Created by IT on 02/12/2019.
//  Copyright © 2019 Marouane Youssef ©. All rights reserved.
//
import UIKit

public final class FeedItemCell: UITableViewCell {

    @IBOutlet private(set) public weak var thumbnail: UIImageView!
    @IBOutlet private(set) public weak var title: UILabel!
    @IBOutlet private(set) public weak var publicationDate: UILabel!
}
