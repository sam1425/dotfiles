#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/cursorfont.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char *argv[]) {
    Display *d = XOpenDisplay(NULL);
    if (!d) {
        fprintf(stderr, "Cannot open display\n");
        return 1;
    }

    int screen = DefaultScreen(d);
    Window root = RootWindow(d, screen);

    // Default cursor
    unsigned int cursor_font = XC_crosshair;
    if (argc > 1) {
        if (strcmp(argv[1], "tcross") == 0) cursor_font = XC_tcross;
        else if (strcmp(argv[1], "ptr") == 0) cursor_font = XC_left_ptr;
        else if (strcmp(argv[1], "cross") == 0) cursor_font = XC_crosshair;
    }
    Cursor cursor = XCreateFontCursor(d, cursor_font);

    // Magnifier settings
    int zoom = 16; // each pixel is 16x16
    int size = 13; // 13x13 grid of pixels
    int win_size = zoom * size;

    XSetWindowAttributes attrs;
    attrs.override_redirect = True; 
    attrs.background_pixel = BlackPixel(d, screen);

    Window win = XCreateWindow(d, root, 0, 0, win_size, win_size, 0, 
                                CopyFromParent, InputOutput, CopyFromParent,
                                CWOverrideRedirect | CWBackPixel, &attrs);
    XMapWindow(d, win);

    // Grab the mouse and keyboard globally
    XGrabPointer(d, root, False, ButtonPressMask, GrabModeAsync, GrabModeAsync, None, cursor, CurrentTime);
    XGrabKeyboard(d, root, False, GrabModeAsync, GrabModeAsync, CurrentTime);

    GC gc = XCreateGC(d, win, 0, NULL);
    XImage *img;
    XEvent ev;
    int x, y, dummy_i;
    unsigned int dummy_u;
    Window dummy_w;

    while (1) {
        // Handle events
        while (XPending(d)) {
            XNextEvent(d, &ev);
            if (ev.type == ButtonPress) {
                // Get color at mouse exactly when clicked
                XQueryPointer(d, root, &dummy_w, &dummy_w, &x, &y, &dummy_i, &dummy_i, &dummy_u);
                img = XGetImage(d, root, x, y, 1, 1, AllPlanes, ZPixmap);
                if (img) {
                    unsigned long pixel = XGetPixel(img, 0, 0);
                    // Standard X11 pixel format is usually 0xRRGGBB
                    printf("#%02lx%02lx%02lx\n", (pixel >> 16) & 0xff, (pixel >> 8) & 0xff, pixel & 0xff);
                    XDestroyImage(img);
                }
                goto cleanup;
            }
            if (ev.type == KeyPress) goto cleanup;
        }

        // Get mouse pos and move window
        XQueryPointer(d, root, &dummy_w, &dummy_w, &x, &y, &dummy_i, &dummy_i, &dummy_u);
        
        // Edge detection: if near right/bottom, flip to left/top
        int screen_w = DisplayWidth(d, screen);
        int screen_h = DisplayHeight(d, screen);
        int win_x = (x + win_size + 40 > screen_w) ? x - win_size - 20 : x + 20;
        int win_y = (y + win_size + 40 > screen_h) ? y - win_size - 20 : y + 20;
        XMoveWindow(d, win, win_x, win_y);

        // Capture area
        img = XGetImage(d, root, x - (size/2), y - (size/2), size, size, AllPlanes, ZPixmap);
        if (img) {
            for (int iy = 0; iy < size; iy++) {
                for (int ix = 0; ix < size; ix++) {
                    XSetForeground(d, gc, XGetPixel(img, ix, iy));
                    XFillRectangle(d, win, gc, ix * zoom, iy * zoom, zoom, zoom);
                }
            }
            XDestroyImage(img);
        }

        // Draw Crosshair (Red border around center pixel)
        XSetForeground(d, gc, 0xFF0000);
        XDrawRectangle(d, win, gc, (size/2) * zoom, (size/2) * zoom, zoom - 1, zoom - 1);
        XDrawRectangle(d, win, gc, (size/2) * zoom + 1, (size/2) * zoom + 1, zoom - 3, zoom - 3);
        
        XFlush(d);
        usleep(10000); // 100 FPS
    }

cleanup:
    XUngrabPointer(d, CurrentTime);
    XUngrabKeyboard(d, CurrentTime);
    XFreeGC(d, gc);
    XDestroyWindow(d, win);
    XCloseDisplay(d);
    return 0;
}
