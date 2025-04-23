[![Gem Version](https://badge.fury.io/rb/next_page.svg)](https://badge.fury.io/rb/next_page)
[![RSpec](https://github.com/RockSolt/next_page/actions/workflows/rspec.yml/badge.svg)](https://github.com/RockSolt/next_page/actions/workflows/rspec.yml)
[![RuboCop](https://github.com/RockSolt/next_page/workflows/RuboCop/badge.svg)](https://github.com/RockSolt/next_page/actions?query=workflow%3ARuboCop)
[![Maintainability](https://api.codeclimate.com/v1/badges/0efe1a9b66a0bf161536/maintainability)](https://codeclimate.com/github/RockSolt/next_page/maintainability)

# NextPage

NextPage provides simple pagination with no frills in less than 100 lines of code. It reads request
parameters, provides an offset and limit to the query, and decorates the ActiveRecord relation
with pagination attributes. 

No more, no less.

```
def index
  @widgets = paginate_resource(Widget.all)
end
```

## Table of Contents

- [Getting Started](#getting-started)
- [Usage](#usage)
  - [Include the Module](#include-the-module)
  - [Invoking Pagination](#invoking-pagination)
  - [Link Helpers](#link-helpers)
    - [Count Query](#count-query)
  - [Request Parameters](#request-parameters)
  - [Default Results per Action](#default-results-per-action)
- [Configuration](#configuration)
- [Contribute](#contribute)
  - [Running Tests](#running-tests)
- [License](#license)

## Getting Started

This gem requires Rails 7.1+ and works with ActiveRecord.

### Installation

Add this line to your application's Gemfile:

```ruby
gem 'next_page'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install next_page
```

## Usage

Module NextPage::Pagination provides pagination controllers. It assigns a limit and offset to the 
resource query and extends the relation with mixin NextPage::PaginationAttributes to provide helper 
methods for generating links.

### Include the Module

Add an include statement for the module into any controller that needs pagination (or the ApplicationController):

```ruby
include NextPage::Pagination
```

### Invoking Pagination

To paginate a resource pass the resource into method `paginate_resource` then store the return value back in the
resource:

```ruby
@photos = paginate_resource(@photos)
```

The resource is decorated, so this needs to be the last step before rendering.

### Link Helpers

This gem does not do any rendering. It does provide helper methods for generating links. The resource will include the following additional methods:
- previous_page
- current_page
- next_page
- total_pages
- total_count
- per_page

The `previous_page` and `last_page` readers will return `nil` on the first and last page, respectively.

#### Count Query

In some cases (such as grouping), calling count on the query does not provide an accurate representation. If that is the case, then there are two ways to override the default behavior:
- provide a count_query that can resolve the attributes
- specify the following attributes manually: current_page, total_count, and per_page

### Request Parameters

In order to control pagingation, the request should pass the `size` and `number` parameters under the
`page` key:

```
?page[size]=10&page[number]=2
```

### Default Results per Action

The default number of results per page can be overridden by specifying a new default with the call:

```ruby
@photos = paginate_resource(@photos, default_limit: 25)
```

## Configuration

There is one configuration option: `default_per_page`.

The option can be set directly...

`NextPage.configuration.default_per_page = 25`

...or the configuration can be yielded:

```
NextPage.configure do |config|
  config.default_per_page = 25
end
```

**Results per Page**

If not specified in the configuration, the default value for results per page is 12.

## Contribute

Feedback, feature requests, proposed changes, and bug reports are welcomed. Please use the 
[issue tracker](https://github.com/RockSolt/next_page/issues) for feedback and feature requests. To 
propose a change directly, please fork the repo and open a pull request. Keep an eye on the actions 
to make sure the tests and Rubocop are passing. [Code Climate](https://codeclimate.com/github/RockSolt/next_page)
is also used manually to assess the codeline.

### Running Tests

Tests are written in RSpec and the dummy app uses a docker database. 

The tests can also be run across all the ruby and Rails combinations using appraisal. The install is a one-time step.

```bash
bundle exec appraisal install
bundle exec appraisal rspec
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
