//
//  UserListSection.swift
//  github-user-list-rx
//
//  Created by Steven Zeng on 2020/5/23.
//  Copyright © 2020 zengsqi. All rights reserved.
//

import RxDataSources

struct UserListSection {
  let header: String
  var items: [User]
}

extension UserListSection: SectionModelType {
  init(original: UserListSection, items: [User]) {
    self = original
    self.items = items
  }
}
