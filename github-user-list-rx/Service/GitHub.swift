//
//  GitHub.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/22.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import Moya

enum GitHub {
  case getUserList(since: Int, pageSize: Int)
  case getUserDetail(login: String)
}

extension GitHub: TargetType {

  var baseURL: URL {
    return URL(string: "https://api.github.com")!
  }

  var path: String {
    switch self {
    case .getUserList:
      return "/users"
    case let .getUserDetail(login):
      return "/users/\(login)"
    }
  }

  var method: Method {
    switch self {
    case .getUserList, .getUserDetail:
      return .get
    }
  }

  var sampleData: Data {
    return Data()
  }

  var task: Task {
    switch self {
    case let .getUserList(since, pageSize):
      return .requestParameters(parameters: [ "since": since, "per_page": pageSize ], encoding: URLEncoding.default)
    case .getUserDetail:
      return .requestPlain
    }
  }

  var headers: [String : String]? {
    return nil
  }
}
