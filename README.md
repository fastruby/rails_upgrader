# Rails Upgrader

[![Build Status](https://travis-ci.org/fastruby/rails_upgrader.svg?branch=master)](https://travis-ci.org/fastruby/rails_upgrader)

This gem helps you automate the migration to strong parameters.

## Installation

Add this line to your application's Gemfile:

```ruby
group :development do
  gem 'rails_upgrader'
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rails_upgrader

## Usage

`rails_upgrader COMMAND`

Commands:

- `go`: attempt to upgrade your models and controllers in place.

- `dry-run`: write strong parameter migrations in the terminal.

- `dry-run --file`: write strong parameter migrations to `all_strong_params.rb` file.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/fastruby/rails_upgrader](https://github.com/fastruby/rails_upgrader). This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

When Submitting a Pull Request:

* If your PR closes any open GitHub issues, please include `Closes #XXXX` in your comment

* Please include a summary of the change and which issue is fixed or which feature is introduced.

* If changes to the behavior are made, clearly describe what changes.

* If changes to the UI are made, please include screenshots of the before and after.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
