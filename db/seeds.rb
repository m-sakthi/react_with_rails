# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(  email: 'admin@sblog.com',
              password: 'admin#123',
              password_confirmation: 'admin#123',
              user_name: 'admin',
              first_name: 'Admin',
              last_name: 'sblog',
              status: 'active',
              activated_at: '2016-11-24 10:32:07')

admin = User.where(email: 'admin@sblog.com').first
admin.add_role :admin