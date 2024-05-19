#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <errno.h>

#include <poll.h>
#include <fcntl.h>
#include <unistd.h>
#include <getopt.h>
#include <pthread.h>

#include <libudev.h>
#include <libinput.h>

#define MAX_BUFFER_LENGTH 512

static int open_restricted(const char *path, int flags, void *user_data) {
	int fd = open(path, flags);
	return fd < 0 ? -errno : fd;
}

static void close_restricted(int fd, void *user_data) { close(fd); }

static const struct libinput_interface interface = { .open_restricted = open_restricted, .close_restricted = close_restricted };

static int handle_events(struct libinput *libinput) {
	int result = -1;
	struct libinput_event *event;
	if (libinput_dispatch(libinput) < 0) return result;
	while ((event = libinput_get_event(libinput)) != NULL) {
		switch (libinput_event_get_type(event)) {
		case LIBINPUT_EVENT_KEYBOARD_KEY:
			struct libinput_event_keyboard *keyboard = libinput_event_get_keyboard_event(event);
			if (libinput_event_keyboard_get_key_state(keyboard) == LIBINPUT_KEY_STATE_PRESSED) {
				printf("%d\n", libinput_event_keyboard_get_key(keyboard));
				fflush(stdout);
			}
			break;
		case LIBINPUT_EVENT_POINTER_BUTTON:
			struct libinput_event_pointer *pointer = libinput_event_get_pointer_event(event);
			if (libinput_event_pointer_get_button_state(pointer) == LIBINPUT_BUTTON_STATE_PRESSED) {
				printf("%d\n", libinput_event_pointer_get_button(pointer));
				fflush(stdout);
			}
			break;
		}
		libinput_event_destroy(event);
		result = 0;
	}
	return result;
}

static int run_mainloop(struct libinput *libinput) {
	struct pollfd fd;
	fd.fd = libinput_get_fd(libinput);
	fd.events = POLLIN;
	fd.revents = 0;
	if (handle_events(libinput) != 0) return -1;
	while (poll(&fd, 1, -1) > -1) handle_events(libinput);
	return 0;
}

int main(int argc, char *argv[]) {
	struct udev *udev = udev_new();
	if (udev == NULL) return 1;
	struct libinput *libinput = libinput_udev_create_context(&interface, NULL, udev);
	if (!libinput) return 2;
	if (libinput_udev_assign_seat(libinput, "seat0") != 0) {
		libinput_unref(libinput);
		udev_unref(udev);
		return 3;
	}
	if (run_mainloop(libinput) < 0) return 4;
	libinput_unref(libinput);
	udev_unref(udev);
	return 0;
}
