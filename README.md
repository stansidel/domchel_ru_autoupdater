# Script updating first message on Domchel.ru site

## Prerequisites

* Ruby 2.1.1
* [phantomjs](http://phantomjs.org)

## Usage

1. Clone the script.
2. Run `bundle install`.
3. Set env variables `DOMCHEL_EMAIL`, `DOMCHEL_PASSWORD` and `DOMCHEL_REPORT_TO_EMAILS` in the `~/.profile` file.
j. Add the `domchel_message_updater.rb` file to cron.

`.profile` example:

    export DOMCHEL_EMAIL=me@example.com
    export DOMCHEL_PASSWORD=my_secret_password
    export DOMCHEL_REPORT_TO_EMAILS=me@example.com  # Emails to send successful update reports to, comma separated

## Return status codes

* 0 - successfully updated
* 1 - unable to authorize
* 2 - there were errors on the site when updating
* 3 - no need for update yet (updated recently)

