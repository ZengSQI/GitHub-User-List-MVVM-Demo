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


  private var disposeBag = DisposeBag()

  private var avatarView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { (make) in
      make.height.width.equalTo(50)
    }
    return imageView
  }()

  private var nameLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  private var staffBadge: UIView = {
    let view = UIView()
    view.backgroundColor = .systemRed
    view.layer.cornerRadius = 10
    let label = UILabel()
    view.addSubview(label)
    label.text = "STAFF"
    label.textColor = .white
    label.font = UIFont.boldSystemFont(ofSize: 12)
    label.snp.makeConstraints { (make) in
      make.top.bottom.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(8)
      make.height.equalTo(20)
    }
    view.isHidden = true
    return view
  }()

  private lazy var nameStackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [nameLabel, staffBadge])
    stackView.axis = .vertical
    stackView.distribution = .equalCentering
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
      make.top.leading.trailing.equalToSuperview().inset(16)
      make.bottom.equalToSuperview().inset(16).priority(.high)
    }
  }

  func bindViewModel(user: User) {
    Nuke.loadImage(with: ImageRequest(url: user.avatarURL, processors: [ImageProcessors.Circle()]), into: avatarView)
    nameLabel.text = user.login
    staffBadge.isHidden = !user.isAdmin
  }
}
