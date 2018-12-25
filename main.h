#include <libnotify/notification.h>
#include <gtk/gtk.h>

// Action callback called when the notification/buttons are clicked. Schedules
// the next notification
void cb_reset_timer(NotifyNotification* notif, char* action, gpointer user_data);

// Waits and then displays the notification. The parameter should point to a
// u_int32_t whose value is the wait time.
void *notif_sched(void *param);