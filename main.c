#include <libnotify/notification.h>
#include <libnotify/notify.h>
#include <unistd.h>
#include <gtk/gtk.h>

#include "main.h"

const char* app_name    = "com.retc3.getup";
u_int32_t   freq_notif  = 45 * 60;
u_int32_t   freq_snooze = 3 * 60;

GtkApplication* app;

void cb_reset_timer(NotifyNotification* notif, char* action, gpointer user_data) {
    pthread_t pt;
    int i = pthread_create(&pt, NULL, notif_sched, user_data);
}

void *notif_sched(void *param) {
    u_int32_t t = *(u_int32_t*)param;
    sleep(t);

    NotifyNotification* notif   = NULL;
    GError*             err     = NULL;
    
    notif = notify_notification_new(
        "Get Up!",
        "Time to get moving!",
        NULL);
    if (!notif) {
        perror("Couldn't create notification");
        exit(1);
    }
    notify_notification_set_timeout(notif, NOTIFY_EXPIRES_NEVER);

    notify_notification_add_action(
        notif, "default", "Default", cb_reset_timer, &freq_notif, NULL);
    
    notify_notification_add_action(
        notif, "snooze", "Snooze", cb_reset_timer, &freq_snooze, NULL);
    
    notify_notification_add_action(
        notif, "dismiss", "Dismiss", cb_reset_timer, &freq_notif, NULL);
    
    if (!notify_notification_show(notif, &err)) {
        perror("Couldn't show notification");
        exit(1);
    }

    if (err) {
        perror("There was an error showing the notification");
        exit(1);
    }
}

// Initialize libnotify, add a dummy window to the app, and schedule the first
// notification
void activate() {
    if (!notify_init(app_name)) {
        perror("Couldn't initialize libnotify");
        exit(1);
    }

    // not shown; for app persistence
    GtkWindow* wnd = (GtkWindow*) gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_application_add_window(app, wnd);

    notif_sched(&freq_notif);
}

// Optionally set notification & snooze times. Exits on bad input
void get_opt(int argc, char *argv[]) {
    int c;
    opterr = 0;

    while ((c = getopt(argc, argv, "t:s:")) != -1) {
        int t = 0;
        switch (c) {
        case 't':
            t = atoi(optarg);
            if (t <= 0) {
                perror("Invalid notification time");
                exit(-1);
            }
            freq_notif = t;
            break;
        case 's':
            t = atoi(optarg);
            if (t <= 0) {
                perror("Invalid snooze time");
                exit(-1);
            }
            freq_snooze = t;
            break;
        default:
            perror("Invalid CLI option");
            exit(-1);
        }
    }
}

int main(int argc, char* argv[], char* envp[]) {
    get_opt(argc, argv);
    app = gtk_application_new((const gchar*)app_name, G_APPLICATION_FLAGS_NONE);
    g_signal_connect(app, "activate", G_CALLBACK (activate), NULL);
    g_application_run((GApplication*) app, 0, NULL);
    return 0;
}
