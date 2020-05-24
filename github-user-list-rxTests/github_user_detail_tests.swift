//
//  github_user_detail_tests.swift
//  github-user-list-rxTests
//
//  Created by Steven Zeng on 2020/5/24.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import RxCocoa
import Moya
@testable import github_user_list_rx

class github_user_detail_tests: XCTestCase {
  let viewModel = UserDetailViewModel()
  var disposeBag = DisposeBag()

  var scheduler: TestScheduler!
  var output: UserDetailViewModel.Output!

  override func setUpWithError() throws {
    scheduler = TestScheduler(initialClock: 0)

    let loadTrigger = scheduler.createHotObservable(
      [
        .next(100, ())
      ]
    ).asDriver(onErrorJustReturn: ())

    let input = UserDetailViewModel.Input(
      loadTrigger: loadTrigger,
      provider: MoyaProvider<GitHub>(stubClosure: { (service) -> StubBehavior in
        return .immediate
      }),
      login: ""
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

  func testUserDetailData() throws {
    let nameObserver = scheduler.createObserver(String?.self)
    let bioObserver = scheduler.createObserver(String?.self)
    let locationObserver = scheduler.createObserver(String?.self)
    let blogObserver = scheduler.createObserver(String.self)

    output.nameText.bind(to: nameObserver).disposed(by: disposeBag)
    output.bioText.bind(to: bioObserver).disposed(by: disposeBag)
    output.locationText.bind(to: locationObserver).disposed(by: disposeBag)
    output.blogText.bind(to: blogObserver).disposed(by: disposeBag)

    scheduler.start()

    let nameExceptEvents: [Recorded<Event<String?>>] = [
      .next(0, nil),
      .next(100, "Tom Preston-Werner"),
    ]

    let bioExceptEvents: [Recorded<Event<String?>>] = [
      .next(0, nil),
      .next(100, nil),
    ]

    let locationExceptEvents: [Recorded<Event<String?>>] = [
      .next(0, nil),
      .next(100, "San Francisco"),
    ]

    let blogExceptEvents: [Recorded<Event<String>>] = [
      .next(0, ""),
      .next(100, "http://tom.preston-werner.com"),
    ]

    XCTAssertEqual(nameObserver.events, nameExceptEvents)
    XCTAssertEqual(bioObserver.events, bioExceptEvents)
    XCTAssertEqual(locationObserver.events, locationExceptEvents)
    XCTAssertEqual(blogObserver.events, blogExceptEvents)
  }
}
