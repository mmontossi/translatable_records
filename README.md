[![Gem Version](https://badge.fury.io/rb/translatable_records.svg)](http://badge.fury.io/rb/translatable_records)
[![Code Climate](https://codeclimate.com/github/museways/translatable_records/badges/gpa.svg)](https://codeclimate.com/github/museways/translatable_records)
[![Build Status](https://travis-ci.org/museways/translatable_records.svg)](https://travis-ci.org/museways/translatable_records)
[![Dependency Status](https://gemnasium.com/museways/translatable_records.svg)](https://gemnasium.com/museways/translatable_records)

# Translatable Records

Fully customizable record translations for rails.

## Why

I did this gem to:

- Have the freedom to customize the translation model.
- Avoid duplication by delegate translatable attributes directly to translation model.
- Use translations other than I18n.available_locales.

## Install

Put this line in your Gemfile:
```ruby
gem 'translatable_records'
```

Then bundle:
```
$ bundle
```

## Configuration

Define wich attributes will be translated in the model:
```ruby
class Product < ActiveRecord::Base
  translate :name
end
```

Generate the translation and migration:
```
$ bundle exec rails g translation product
```

Update your db:
```
$ bundle exec rake db:migrate
```

## Usage

### Accessors

By default will use I18n.locale but you can change it:
```ruby
product.locale = :en
```

Accessor continue working the same:
```ruby
product.name = 'Phone'
```

### Views

If you want to save multiple translations:
```erb
<%= f.fields_for :translations do |ff| %>
  <%= ff.hidden_field :locale %>
  <%= ff.label :name %>
  <%= ff.text_field :name %>
<% end %>
```

## Contributing

Any issue, pull request, comment of any kind is more than welcome!

I will mainly ensure compatibility to Rails, AWS, PostgreSQL, Redis, Elasticsearch and FreeBSD. 

## Credits

This gem is maintained and funded by [museways](https://github.com/museways).

## License

It is free software, and may be redistributed under the terms specified in the MIT-LICENSE file.
