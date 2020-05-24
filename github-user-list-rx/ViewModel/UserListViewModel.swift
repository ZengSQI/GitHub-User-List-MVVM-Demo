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
    let refreshTrigger: Driver<Void>
    let nextPageSignal: Signal<Void>
  }

  struct Output {
    let userList: BehaviorRelay<[User]>
    let isLoading: Driver<Bool>
    let errorRelay: PublishRelay<Error>
  }

  func transform(input: Input) -> Output {
    let pageSize = self.pageSize
    let since = BehaviorRelay<Int>(value: 0)
    let activityIndicator = ActivityIndicator()
    let userList = BehaviorRelay<[User]>(value: [])
    let errorRelay = PublishRelay<Error>()

    input
      .refreshTrigger
      .drive(onNext: { since.accept(0) })
      .disposed(by: disposeBag)

    input
      .refreshTrigger
      .drive(onNext: { userList.accept([]) })
      .disposed(by: disposeBag)

    Observable
      .merge(input.refreshTrigger.asObservable(), input.nextPageSignal.asObservable())
      .flatMapFirst {
        input.provider.rx.request(.getUserList(since: since.value, pageSize: pageSize))
          .filterSuccessfulStatusCodes()
          .map([User].self)
          .trackActivity(activityIndicator)
          .catchError { (error) -> Observable<[User]> in
            errorRelay.accept(error)
            return .empty()
        }
      }
      .map { userList.value + $0 }
      .bind(to: userList)
      .disposed(by: disposeBag)

    userList
      .map { $0.last?.id }
      .unwrap()
      .bind(to: since)
      .disposed(by: disposeBag)

    return Output(
      userList: userList,
      isLoading: activityIndicator.asDriver(),
      errorRelay: errorRelay
    )
  }
}
