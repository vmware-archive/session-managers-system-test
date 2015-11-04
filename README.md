# Session Managers System Tests
[![Dependency Status](https://gemnasium.com/gopivotal/session-managers-system-test.svg)](https://gemnasium.com/gopivotal/session-managers-system-test)

The purpose of this repository is to exercise the [Session Managers][] together with their dependencies and associated services to ensure that the whole package works together correctly.

## Running Tests
To run the tests, do the following:

```bash
bundle install
bundle exec rake
```
The jar files for Session Managers are in a publicly accessible location, but checking for the latest versions requires you to authenticate with AWS. The credentials are not used for any other purpose.


## Contributing
[Pull requests][] are welcome; see the [contributor guidelines][] for details.

## License
This system test is released under version 2.0 of the [Apache License][].

[Apache License]: http://www.apache.org/licenses/LICENSE-2.0
[contributor guidelines]: CONTRIBUTING.md
[Pull requests]: http://help.github.com/send-pull-requests
[Redis Manager]: https://github.com/gopivotal/session-
[Session Managers]: https://github.com/gopivotal/session-managers
