//
//  UserListViewModel.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/22.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import RxSwift
import RxCocoa
import RxSwiftExt
import Moya

class UserListViewModel: ViewModelType {
  private let pageSize = 20

  var disposeBag = DisposeBag()

  struct Input {
    let provider: MoyaProvider<GitHub>
    let refreshSignal: Signal<Void>
    let nextPageSignal: Signal<Void>
  }

  struct Output {
    let userList: BehaviorRelay<[User]>
    let isLoading: Driver<Bool>
  }

  func transform(input: Input) -> Output {
    let pageSize = self.pageSize
    let since = BehaviorRelay<Int>(value: 0)
    let activityIndicator = ActivityIndicator()
    let userList = BehaviorRelay<[User]>(value: [])

    input
      .refreshSignal
      .asObservable()
      .do(onNext: { since.accept(0) })
      .flatMapFirst {
        input.provider.rx.request(.getUserList(since: since.value, pageSize: pageSize))
          .filterSuccessfulStatusCodes()
          .map([User].self)
          .trackActivity(activityIndicator)
      }
      .map { userList.value + $0 }
      .bind(to: userList)
      .disposed(by: disposeBag)

    userList
      .map { $0.last?.id }
      .unwrap()
      .bind(to: since)
      .disposed(by: disposeBag)

    input
      .nextPageSignal
      .asObservable()
      .flatMapFirst {
        input.provider.rx.request(.getUserList(since: since.value, pageSize: pageSize))
          .filterSuccessfulStatusCodes()
          .map([User].self)
          .trackActivity(activityIndicator)
      }
      .map { userList.value + $0 }
      .bind(to: userList)
      .disposed(by: disposeBag)


    return Output(
      userList: userList,
      isLoading: activityIndicator.asDriver()
    )
  }
}
