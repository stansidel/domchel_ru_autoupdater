# Script updating first message on Domchel.ru site

## Prerequisites

* Ruby 2.1.1
* [phantomjs](http://phantomjs.org)

## Usage

1. Clone the script.
2. Run `bundle install`.
3. Set env variables `DOMCHEL_EMAIL`, `DOMCHEL_PASSWORD` and `DOMCHEL_REPORT_TO_EMAILS` in the `~/.profile` file.
4. Add the `domchel_message_updater.rb` file to cron.

`.profile` example:

    export DOMCHEL_EMAIL=me@example.com
    export DOMCHEL_PASSWORD=my_secret_password
    export DOMCHEL_REPORT_TO_EMAILS=me@example.com  # Emails to send successful update reports to, comma separated

## Adding script to crontab

To add the script to run as a current user run:

    crontab -e

And then add the following line to the edit window:

    0 * * * *  /bin/bash -l -c 'cd /Users/your_user_name/cron_scripts/domchel_ru_autoupdater && ./domchel_message_updater.rb' > /dev/null 2>&1

where `/Users/your_user_name/cron_scripts/domchel_ru_autoupdater` is the path to your scriptfile.

This line schdules running the script hourly. On each run, the script would check the last update time.
If it's been more than 24 hours since the last update it would try to update the message.
Otherwise it would do nothing.

The script is scheduled hourly, not daily, to deal with some unexpected errors on the server side - 
if it was time to update, but it fails for some reason, it would retry again in an hour.

All the messages from the script is suppressed by the `> /dev/null 2>&1` part of the command above.
For details look [here](http://www.mydigitallife.info/cron-differences-between-devnull-21-and-devnull/)
and [here](http://stackoverflow.com/questions/10508843/what-is-dev-null-21).

## Return status codes

* 0 - successfully updated
* 1 - unable to authorize
* 2 - there were errors on the site when updating
* 3 - no need for update yet (updated recently)

The script saves finish time and exit code to the `.last_run` file on each execution.

