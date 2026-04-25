#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <X11/cursorfont.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct { float r, g, b; } Color;

Color gruvbox[] = {
    {0xCC/255.0, 0x24/255.0, 0x1D/255.0}, // red
    {0xD6/255.0, 0x5D/255.0, 0x0E/255.0}, // orange
    {0xD7/255.0, 0x99/255.0, 0x21/255.0}, // yellow
    {0x98/255.0, 0x97/255.0, 0x1A/255.0}, // green
    {0x68/255.0, 0x9D/255.0, 0x6A/255.0}, // aqua
    {0x45/255.0, 0x85/255.0, 0x88/255.0}, // blue
    {0xB1/255.0, 0x62/255.0, 0x86/255.0}, // purple
};
#define NCOLORS 7

Color lerp_color(Color a, Color b, float t) {
    return (Color){
        a.r + (b.r - a.r) * t,
        a.g + (b.g - a.g) * t,
        a.b + (b.b - a.b) * t,
    };
}

void print_help() {
    printf("Usage: \n"
    "./pixpicker <cursor>\n"
    "             tcross\n"
    "             ptr\n"
    "             cross\n"
    "Keybinds: \n"
    "- r : Gives the picker crosshair a raimbow effect\n"
    "- esc or q : exits the program\n"
    );

}
int main(int argc, char *argv[]) {
    int rgb = 0;
    unsigned long col;
    static float phase = 0.0f;
    //open X11 Display (0)
    Display *d = XOpenDisplay(NULL);
    if (!d) {
        fprintf(stderr, "Cannot open display\n");
        return 1;
    }

    int screen = DefaultScreen(d);
    Window root = RootWindow(d, screen);

    unsigned int CursorFont = XC_crosshair;
    if (argc > 1) {
        if (strcmp(argv[1], "tcross") == 0) CursorFont = XC_tcross;
        else if (strcmp(argv[1], "ptr") == 0) CursorFont = XC_left_ptr;
        else if (strcmp(argv[1], "cross") == 0) CursorFont = XC_crosshair;
        else {CursorFont = XC_crosshair;}
        print_help();
    }
    Cursor cursor = XCreateFontCursor(d, CursorFont);

    // each pixel is 16x16
    // 13x13 grid of pixels
    int zoom = 16;
    int size = 13;
    int win_size = zoom * size;

    XSetWindowAttributes attrs;
    attrs.override_redirect = True;
    attrs.background_pixel = BlackPixel(d, screen);
    /* attrs.event_mask = KeyPressMask | ButtonPressMask; */
    attrs.event_mask = KeyPressMask;

    Window win = XCreateWindow(d, root, 0, 0, win_size, win_size, 0,
                            CopyFromParent, InputOutput, CopyFromParent,
                            CWOverrideRedirect | CWBackPixel | CWEventMask, &attrs);
    XMapWindow(d, win);
    XSetInputFocus(d, win, RevertToParent, CurrentTime);
    // Grab the mouse and keyboard globally
    int kb = XGrabPointer(d, root, False, ButtonPressMask, GrabModeAsync, GrabModeAsync, None, cursor, CurrentTime);
    GC gc = XCreateGC(d, win, 0, NULL);
    Pixmap buf = XCreatePixmap(d, win, win_size, win_size, DefaultDepth(d, screen));
    XImage *img;
    XEvent ev;
    int x, y, dummy_i;
    unsigned int dummy_u;
    Window dummy_w;

    while (1) {
        // Handle events
        while (XPending(d)) {
            XNextEvent(d, &ev);
            if (ev.type == KeyPress) {
                KeySym keysym = XLookupKeysym(&ev.xkey, 0);
                if (keysym == XK_Escape) goto cleanup;
                if (keysym == XK_q) goto cleanup;
                if (keysym == XK_r) rgb = !rgb;
            }
            if (ev.type == ButtonPress) {
                XQueryPointer(d, root, &dummy_w, &dummy_w, &x, &y, &dummy_i, &dummy_i, &dummy_u);
                img = XGetImage(d, root, x, y, 1, 1, AllPlanes, ZPixmap);
                if (img) {
                    unsigned long pixel = XGetPixel(img, 0, 0);
                    printf("#%02lx%02lx%02lx\n", (pixel >> 16) & 0xff, (pixel >> 8) & 0xff, pixel & 0xff);
                    XDestroyImage(img);
                }
                goto cleanup;
            }

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
        int cx = x - (size/2);
        int cy = y - (size/2);
        if (cx < 0) cx = 0;
        if (cy < 0) cy = 0;
        if (cx + size > screen_w) cx = screen_w - size;
        if (cy + size > screen_h) cy = screen_h - size;
        img = XGetImage(d, root, cx, cy, size, size, AllPlanes, ZPixmap);
        if (img) {
            for (int iy = 0; iy < size; iy++) {
                for (int ix = 0; ix < size; ix++) {
                    XSetForeground(d, gc, XGetPixel(img, ix, iy));
                    /* XFillRectangle(d, win, gc, ix * zoom, iy * zoom, zoom, zoom); */
                    XFillRectangle(d, buf, gc, ix * zoom, iy * zoom, zoom, zoom);
                }
            }
            XDestroyImage(img);
        }
        if (rgb){
            phase += 0.01f; // speed, tune to taste
            if (phase >= NCOLORS) phase = 0.0f;
            int idx = (int)phase;
            float t = phase - idx;
            Color c = lerp_color(gruvbox[idx], gruvbox[(idx + 1) % NCOLORS], t);
            col = ((unsigned long)(c.r * 255) << 16) |
            ((unsigned long)(c.g * 255) <<  8) |
            (unsigned long)(c.b * 255);
            // Draw Crosshair (Red border around center pixel)
        }else {
            col = 0xFB4934;
        }
        XSetForeground(d, gc, col);
        XDrawRectangle(d, buf, gc, (size/2) * zoom, (size/2) * zoom, zoom - 1, zoom - 1);
        XDrawRectangle(d, buf, gc, (size/2) * zoom + 1, (size/2) * zoom + 1, zoom - 3, zoom - 3);
        XCopyArea(d, buf, win, gc, 0, 0, win_size, win_size, 0, 0);
        XFlush(d);
        usleep(10000); // 100 FPS
    }

cleanup:
    XUngrabPointer(d, CurrentTime);
    XFreeGC(d, gc);
    XFreePixmap(d, buf);
    XDestroyWindow(d, win);
    XCloseDisplay(d);
    return 0;
}
