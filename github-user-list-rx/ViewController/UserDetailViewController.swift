//
//  UserDetailViewController.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/24.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya
import Nuke

class UserDetailViewController: UIViewController {
  private var disposeBag = DisposeBag()
  private var viewModel: UserDetailViewModel?

  private let user: User

  private var userDetailView: UserDetailView = {
    let view = UserDetailView()
    return view
  }()

  private lazy var activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(style: .large)
    activityIndicatorView.startAnimating()
    activityIndicatorView.hidesWhenStopped = true
    return activityIndicatorView
  }()

  init(user: User) {
    self.user = user
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSubview()
    bindViewModel()
  }

  private func setupSubview() {
    view.backgroundColor = .systemBackground
    view.addSubview(userDetailView)
    userDetailView.snp.makeConstraints { (make) in
      make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
    }
    view.addSubview(activityIndicatorView)
    activityIndicatorView.center = view.center
  }

  private func bindViewModel() {
    // setup user data
    Nuke.loadImage(with: ImageRequest(url: user.avatarURL, processors: [ImageProcessors.Circle()]), into: userDetailView.avatarImageView)
    userDetailView.loginLabel.text = user.login
    userDetailView.staffBadge.isHidden = !user.isAdmin

    let viewModel = UserDetailViewModel()
    self.viewModel = viewModel

    let input = UserDetailViewModel.Input(
      provider: MoyaProvider<GitHub>(),
      login: user.login
    )
    let output = viewModel.transform(input: input)

    output.nameText.bind(to: userDetailView.nameLabel.rx.text).disposed(by: disposeBag)
    output.bioText.bind(to: userDetailView.bioLabel.rx.text).disposed(by: disposeBag)
    output.locationText.bind(to: userDetailView.locationLabel.rx.text).disposed(by: disposeBag)
    output.blogText.bind(to: userDetailView.blogTextView.rx.text).disposed(by: disposeBag)
    output.isLoading.drive(activityIndicatorView.rx.isAnimating).disposed(by: disposeBag)

    output.errorRelay
      .subscribe(onNext: { [weak self] (error) in
        if let error = error as? MoyaError, let githubError = try? error.response?.map(GitHubError.self) {
          self?.errorAlert(message: githubError.message)
        } else {
          self?.errorAlert(message: error.localizedDescription)
        }
      }).disposed(by: disposeBag)
  }
}
