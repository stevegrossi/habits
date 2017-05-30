# Start phantomjs for integration tests
phantomjs --wd --webdriver-logfile=/tmp/phantomjs.log > /dev/null 2>&1 &

MIX_ENV=test mix test
