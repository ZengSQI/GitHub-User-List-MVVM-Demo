//
//  UserListViewController.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/22.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import UIKit
import Moya
import RxSwift
import RxCocoa
import RxDataSources

class UserListViewController: UIViewController {
  private let disposeBag = DisposeBag()
  private var viewModel: UserListViewModel?

  private var tableView: UITableView = {
    let tableView = UITableView()
    return tableView
  }()

  private let dataSource = RxTableViewSectionedReloadDataSource<UserListSection>(
    configureCell: {  (dataSource, tableView, indexPath, item) -> UITableViewCell in
      let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? UserTableViewCell ?? UserTableViewCell(style: .default, reuseIdentifier: "UserCell")
      cell.bindViewModel(user: item)
      return cell
    }
  )

  override func viewDidLoad() {
    super.viewDidLoad()
    title = "GitHub Users"
    setupSubview()
    bindViewModel()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView.frame = CGRect(x: view.safeAreaInsets.left, y: view.bounds.minY, width: view.safeAreaLayoutGuide.layoutFrame.width, height: view.bounds.height)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let indexPath = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }

  private func setupSubview() {
    view.addSubview(tableView)
  }

  private func bindViewModel() {
    let viewModel = UserListViewModel()
    self.viewModel = viewModel

    let nextPageSignal = tableView.rx.reachedBottom(offset: 120.0).asSignal()

    let input = UserListViewModel.Input(
      provider: MoyaProvider<GitHub>(),
      refreshSignal: .of(()),
      nextPageSignal: nextPageSignal
    )
    let output = viewModel.transform(input: input)

    output
      .userList
      .map { [UserListSection(header: "", items: $0)] }
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)

    tableView.rx.modelSelected(User.self)
      .subscribe(onNext: { [weak self] (user) in
        let controller = UserDetailViewController(user: user)
        self?.navigationController?.pushViewController(controller, animated: true)
      }).disposed(by: disposeBag)
  }
}
