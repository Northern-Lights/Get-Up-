# getup

`getup` is an application for delivering reminders for a user to get up and stretch/take a short break, periodically. It should save people back problems in the long run.

## Behavior

By default, `getup` will deliver a notification every 45 minutes. The time starts over when the notification is dismissed by either clicking the "Dismiss" action or the notification itself (default action.) The notification can be snoozed for 3 minutes by clicking the "Snooze" button.

The notification and snooze times can be set on the command line to override the defaults:

`getup -t seconds -s seconds`

where `-t` is the notification time and `-s` is the snooze time, in seconds.

## Notes

Unfortunately, in Gnome it appears that if the notification hides itself back into the message center, either by timeout or by mousing over it and then mousing away from it, then the only thing that can be done is to click on the notification, i.e. performing the default action. The notifications are set to have no timeout, but it looks like they still hide themselves after 10 seconds or so.

## OS X
The deprecated app for OS X is now located in the `osx` directory.
