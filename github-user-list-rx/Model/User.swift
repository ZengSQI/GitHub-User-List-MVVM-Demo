//
//  User.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/22.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import Foundation

struct User: Codable, Equatable {
  let login: String
  let id: Int
  let avatarURL: URL
  let isAdmin: Bool

  enum CodingKeys: String, CodingKey {
    case login
    case id
    case avatarURL = "avatar_url"
    case isAdmin = "site_admin"
  }
}
