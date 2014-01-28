# Redis Manager System Tests
[![Build Status](https://travis-ci.org/gopivotal/redis-manager-system-test.png?branch=master)](https://travis-ci.org/gopivotal/redis-manager-system-test)

The purpose of this repository is to exercise the [Redis Manager][] together with its dependencies and associated services to ensure that the whole package works together correctly.

## Running Tests
To run the tests, do the following:

```bash
bundle install
bundle exec rake
```

## Contributing
[Pull requests][] are welcome; see the [contributor guidelines][] for details.

## License
This buildpack is released under version 2.0 of the [Apache License][].

[Apache License]: http://www.apache.org/licenses/LICENSE-2.0
[contributor guidelines]: CONTRIBUTING.md
[Pull requests]: http://help.github.com/send-pull-requests
[Redis Manager]: https://github.com/gopivotal/redis-manager
