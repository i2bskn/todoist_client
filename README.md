# TodoistClient

[![Gem Version](https://badge.fury.io/rb/todoist_client.svg)](http://badge.fury.io/rb/todoist_client)

Todoist API Client.

## Installation

Add this line to your application's Gemfile:

    gem 'todoist_client'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install todoist_client

## Usage

#### API Token

Copy from account setting in Todoist.

```
TodoistClient.api_token = 'some_api_token'
```

#### Project

```
# create project
project = TodoistClient::Project.create(name: "SomeProject")
puts [project.id, project.name].join(":") # => 123:SomeProject

project = TodoistClient::Project.find(some_id)
project.name = "OtherProject"
project.save # => update
project.delete # => delete

TodoistClient::Project.all.each do |project|
  # number of uncompleted tasks
  puts project.uncompleted_items.size
end
```

#### Item

```
# create item
item = TodoistClient::Item.create(content: "SomeTask")
puts [item.id, item.content] # => 123:SomeTask

item = TodoistClient::Item.find(some_id)
item.finished? # => false (if incomplete item)
item.content = "OtherTask"
item.save # => update
item.complete # => to complete
item.uncomplete # => to uncomplete
item.delete # => delete

project = TodoistClient::Project.find(some_id)
TodoistClient::Item.uncompleted(project).each do |item|
  item.complete
end

# only premium user
TodoistClient::Item.completed_items.each do |completed_item|
  puts [completed_item.completed_date.to_s, completed_item.content].join(":")
end
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/todoist_client/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
