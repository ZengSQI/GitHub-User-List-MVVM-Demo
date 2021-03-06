//
//  UserTableViewCell.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/23.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import UIKit
import SnapKit
import RxNuke
import Nuke
import RxSwift

class UserTableViewCell: UITableViewCell {
  private let stackSpacing: CGFloat = 10.0
  private let padding: CGFloat = 16.0
  private let avatarSize: CGSize = CGSize(width: 50, height: 50)

  private var disposeBag = DisposeBag()

  private lazy var avatarView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { (make) in
      make.height.equalTo(avatarSize.height)
      make.width.equalTo(avatarSize.width)
    }
    return imageView
  }()

  private var nameLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  private var staffBadge: StaffBadgeView = {
    let view = StaffBadgeView()
    view.isHidden = true
    return view
  }()

  private lazy var nameStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [nameLabel, staffBadge])
    stackView.axis = .vertical
    stackView.distribution = .equalSpacing
    stackView.alignment = .leading
    return stackView
  }()

  private lazy var mainStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [avatarView, nameStackView])
    stackView.axis = .horizontal
    stackView.distribution = .fill
    stackView.spacing = stackSpacing
    return stackView
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSubview()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposeBag = DisposeBag()
  }

  private func setupSubview() {
    addSubview(mainStackView)
    mainStackView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalToSuperview().inset(padding)
      make.bottom.equalToSuperview().inset(padding).priority(.high)
    }
  }

  func bindViewModel(user: User) {
    Nuke.loadImage(with: ImageRequest(url: user.avatarURL, processors: [ImageProcessors.Circle()]), into: avatarView)
    nameLabel.text = user.login
    staffBadge.isHidden = !user.isAdmin
  }
}
