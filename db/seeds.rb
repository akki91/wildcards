# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Status.create([{name:"Open"},{name:"Closed"}])
PullRequestType.create([{name:"Bug"},{name:"Feature"}])
Check.create([{name:"Test"},{name:"Documentation"},{name:"QA Passed"},{name:"Code Quality"}])
Profile.create([{name:"DEVELOPER"},{name:"QA"}])
