//
//  github_user_list_tests.swift
//  github-user-list-rxTests
//
//  Created by Steven Zeng on 2020/5/22.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
import Moya
@testable import github_user_list_rx

class github_user_list_tests: XCTestCase {

  let viewModel = UserListViewModel()
  var disposeBag = DisposeBag()

  var scheduler: TestScheduler!
  var output: UserListViewModel.Output!

  override func setUpWithError() throws {
    scheduler = TestScheduler(initialClock: 0)
    let refreshTrigger = scheduler.createHotObservable(
      [
        .next(100, ())
      ]
    ).asDriver(onErrorJustReturn: ())

    let input = UserListViewModel.Input(
      provider: MoyaProvider<GitHub>(stubClosure: { (service) -> StubBehavior in
        return .immediate
      }),
      refreshTrigger: refreshTrigger,
      nextPageSignal: .empty()
    )

    output = viewModel.transform(input: input)
  }

  func testIndicator() throws {
    let observer = scheduler.createObserver(Bool.self)

    output.isLoading.drive(observer).disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<Bool>>] = [
      .next(0, false),
      .next(100, true),
      .next(100, false),

    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }

  func testUsersCount() throws {
    let observer = scheduler.createObserver(Int.self)

    output.userList.map { $0.count }.bind(to: observer).disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<Int>>] = [
      .next(0, 0),
      .next(100, 10),
    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }

  func testUserData() throws {
    let observer = scheduler.createObserver(User?.self)

    output.userList.map { $0.first }.bind(to: observer).disposed(by: disposeBag)

    scheduler.start()

    let exceptEvents: [Recorded<Event<User?>>] = [
      .next(0, nil),
      .next(100, User(
        login: "mojombo",
        id: 1, avatarURL:
        URL(string: "https://avatars0.githubusercontent.com/u/1?v=4")!,
        isAdmin: true)
      ),
    ]

    XCTAssertEqual(observer.events, exceptEvents)
  }
}
