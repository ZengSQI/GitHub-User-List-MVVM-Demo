//
//  UserDetail.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/22.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import Foundation

struct UserDetail: Codable {
  let login: String
  let id: Int
  let avatarURL: URL
  let isAdmin: Bool
  let name: String?
  let bio: String?
  let location: String?
  let blog: URL?

  enum CodingKeys: String, CodingKey {
    case login
    case id
    case avatarURL = "avatar_url"
    case isAdmin = "site_admin"
    case name
    case bio
    case location
    case blog
  }
}
