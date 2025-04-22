[![Gem Version](https://badge.fury.io/rb/next_page.svg)](https://badge.fury.io/rb/next_page)
[![RSpec](https://github.com/RockSolt/next_page/actions/workflows/rspec.yml/badge.svg)](https://github.com/RockSolt/next_page/actions/workflows/rspec.yml)
[![RuboCop](https://github.com/RockSolt/next_page/workflows/RuboCop/badge.svg)](https://github.com/RockSolt/next_page/actions?query=workflow%3ARuboCop)
[![Maintainability](https://api.codeclimate.com/v1/badges/0efe1a9b66a0bf161536/maintainability)](https://codeclimate.com/github/RockSolt/next_page/maintainability)

# NextPage
Basic pagination for Rails controllers.

## Usage
Module Pagination provides pagination controllers. It assigns a limit and offset to the resource query and extends the relation with mixin NextPage::PaginationAttributes to provide helper methods for generating links.

### Include the Module
Add an include statement for the module into any controller that needs pagination:

```ruby
include NextPage::Pagination
```

### Invoking Pagination

To paginate a resource pass the resource into method `paginate_resource` then store the return value back in the
resource:

```ruby
@photos = paginate_resource(@photos)
```

The resource is decorated, so this should be the last step.

### Default Results per Page

The default number of results per page can be overridden by specifying a new default with the call:

```ruby
@photos = paginate_resource(@photos, default_limit: 25)
```

### Link Helpers
This gem does not do any rendering. It does provide helper methods for generating links. The resource will include the following additional methods (when the request header Accept is `'application/vnd.api+json'`):
- current_page
- next_page
- total_pages
- per_page

#### Count Query
In some cases (such as grouping), calling count on the query does not provide an accurate representation. If that is the case, then there are two ways to override the default behavior:
- provide a count_query that can resolve the attributes
- specify the following attributes manually: current_page, total_count, and per_page


## Configuration

There is one configuration option: `per_page`.

The option can be set directly...

`NextPage.configuration.per_page = 25`

...or the configuration can be yielded:

```
NextPage.configure do |config|
  config.per_page = 25
end
```

**Results per Page**

If not specified in the configuration, the default value for results per page is 12.

## Installation
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

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
