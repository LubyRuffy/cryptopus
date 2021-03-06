# encoding: utf-8

#  Copyright (c) 2008-2017, Puzzle ITC GmbH. This file is part of
#  Cryptopus and licensed under the Affero General Public License version 3 or later.
#  See the COPYING file at the top-level directory or at
#  https://github.com/puzzle/cryptopus.

class UserSeeder

  def seed_root
    User.seed_once(:username) do |u|
      u.uid = 0
      u.username = 'root'
      u.givenname = 'root'
      u.auth = 'db'
      u.admin = true
      u.password = CryptUtils.one_way_crypt('password')
      create_keypair(u)
    end
  end

  def seed_users(usernames, admin = false)
    usernames.each do |username|
      seed_user(username, admin)
    end
  end

  def seed_admins(usernames)
    seed_users(usernames, true)
  end

  private
  def seed_user(username, admin = false)
    User.seed_once(:username) do |u|
      u.username = username.to_s
      u.givenname = username.to_s.capitalize
      u.surname = Faker::Name.last_name
      u.auth = 'db'
      u.password = CryptUtils.one_way_crypt('password')
      u.admin = admin
      create_keypair(u)
    end
  end

  def create_keypair(user)
    keypair = CryptUtils.new_keypair
    uncrypted_private_key = CryptUtils.get_private_key_from_keypair(keypair)
    user.public_key = CryptUtils.get_public_key_from_keypair(keypair)
    user.private_key = CryptUtils.encrypt_private_key( uncrypted_private_key, 'password' )
  end

end
