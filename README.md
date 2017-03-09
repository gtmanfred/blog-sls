blog-sls
========

The blog.gtmanfred.com Salt state repo.

[![Build Status](https://travis-ci.org/gtmanfred/blog-sls.svg?branch=master)](https://travis-ci.org/gtmanfred/blog-sls)

Testing
=======

Testing is done with [Test Kitchen](http://kitchen.ci/) for machine setup and [testinfra](https://testinfra.readthedocs.io/en/latest/) for integration tests.

Requirements
------------

- Python
- Ruby
- Docker


```
gem install bundler
bundle install
kitchen test
```
