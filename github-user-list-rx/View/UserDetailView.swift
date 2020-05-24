//
//  UserDetailView.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/24.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import UIKit

class UserDetailView: UIView {
  private let padding: CGFloat = 16.0
  private let iconSize: CGSize = CGSize(width: 45, height: 45)
  private let imageHeight: CGFloat = 200

  private(set) lazy var avatarImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { (make) in
      make.height.equalTo(imageHeight)
    }
    return imageView
  }()

  private(set) var nameLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 25)
    return label
  }()

  private(set) var bioLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  private var middleBorderView: UIView = {
    let view = UIView()
    view.backgroundColor = .systemGray
    return view
  }()

  private lazy var personaIconView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "person.fill")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal))
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { (make) in
      make.width.equalTo(iconSize.width)
      make.height.equalTo(iconSize.height)
    }
    return imageView
  }()

  private(set) var loginLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  private(set) var staffBadge: StaffBadgeView = {
    let view = StaffBadgeView()
    view.isHidden = true
    return view
  }()

  private lazy var locationIconView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "location.fill")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal))
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { (make) in
      make.width.equalTo(iconSize.width)
      make.height.equalTo(iconSize.height)
    }
    return imageView
  }()

  private(set) var locationLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  private lazy var blogIconView: UIImageView = {
    let imageView = UIImageView(image: UIImage(systemName: "link")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal))
    imageView.contentMode = .scaleAspectFit
    imageView.snp.makeConstraints { (make) in
      make.width.equalTo(iconSize.width)
      make.height.equalTo(iconSize.height)
    }
    return imageView
  }()

  private(set) var blogTextView: UITextView = {
    let textView = UITextView()
    textView.isEditable = false
    textView.isScrollEnabled = false
    textView.textContainer.lineFragmentPadding = 0
    textView.font = UIFont.systemFont(ofSize: 15)
    textView.dataDetectorTypes = .link
    return textView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupSubview()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupSubview() {
    let imageStackView = UIStackView(arrangedSubviews: [avatarImageView, nameLabel, bioLabel])
    imageStackView.axis = .vertical
    imageStackView.spacing = padding
    imageStackView.distribution = .equalSpacing

    addSubview(imageStackView)
    imageStackView.snp.makeConstraints { (make) in
      make.top.leading.trailing.equalToSuperview().inset(padding)
    }

    addSubview(middleBorderView)
    middleBorderView.snp.makeConstraints { (make) in
      make.top.equalTo(imageStackView.snp.bottom).offset(padding)
      make.leading.trailing.equalToSuperview().inset(padding)
      make.height.equalTo(1)
    }

    let loginStackView = UIStackView(arrangedSubviews: [loginLabel, staffBadge])
    loginStackView.axis = .vertical
    loginStackView.distribution = .equalSpacing
    loginStackView.alignment = .leading

    let personaStackView = UIStackView(arrangedSubviews: [personaIconView, loginStackView])
    personaStackView.axis = .horizontal
    personaStackView.spacing = padding

    let locationStackView = UIStackView(arrangedSubviews: [locationIconView, locationLabel])
    locationStackView.axis = .horizontal
    locationStackView.spacing = padding

    let blogStackView = UIStackView(arrangedSubviews: [blogIconView, blogTextView])
    blogStackView.axis = .horizontal
    blogStackView.spacing = padding
    blogStackView.alignment = .center

    let detailStackView = UIStackView(arrangedSubviews: [personaStackView, locationStackView, blogStackView])
    detailStackView.axis = .vertical
    detailStackView.spacing = padding

    addSubview(detailStackView)
    detailStackView.snp.makeConstraints { (make) in
      make.top.equalTo(middleBorderView.snp.bottom).offset(padding)
      make.leading.trailing.equalToSuperview().inset(padding)
    }
  }
}
