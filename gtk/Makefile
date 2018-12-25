all:
	gcc -o getup \
		`pkg-config --cflags gtk+-3.0 libnotify` \
		main.c \
		`pkg-config --libs gtk+-3.0 libnotify` \
		-lpthread
