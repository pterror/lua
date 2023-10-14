local ffi = require("ffi")

-- TODO: fix up gc

local mod = {}

--[[@type xlib_ffi]]
local xlib_ffi = ffi.load("X11")

--[[@type xlib_tst_ffi]]
local xlib_tst_ffi = ffi.load("Xtst")

--[[macro definitions: https://github.com/mirror/libX11/blob/bccd787a565d3a88673bfc06574c1939f98d8d72/include/X11/Xlib.h]]

--[[consider renaming to X11_name]]
ffi.cdef [[
	typedef int Status;
	typedef bool Bool;
	typedef uint64_t XID; // source says 64 bit is only for server
	// but testing says otherwise
	typedef uint64_t Mask;
	typedef uint64_t Atom;
	typedef uint64_t VisualID;
	typedef uint64_t Time;
	typedef XID Window;
	typedef XID Drawable;
	typedef XID Font;
	typedef XID Pixmap;
	typedef XID Cursor;
	typedef XID Colormap;
	typedef XID GContext;
	typedef XID KeySym;
	typedef unsigned char KeyCode;

	typedef char *XPointer;

	typedef struct _XDisplay Display;

	typedef struct _XIC *XIC;
	typedef struct _XIM *XIM;

	typedef void (*XIMProc)(XIM, XPointer, XPointer);
	typedef Bool (*XICProc)(XIC, XPointer, XPointer);
	typedef void (*XIDProc)(Display*, XPointer, XPointer);

	typedef struct _XrmHashBucketRec *XrmHashBucket;
	typedef XrmHashBucket *XrmHashTable;
	typedef XrmHashTable XrmSearchList[];
	typedef struct _XrmHashBucketRec *XrmDatabase;

	typedef unsigned long XRecordClientSpec;
	typedef unsigned long XRecordContext;
	typedef struct _XRecordInterceptData XRecordInterceptData;
	typedef void (*XRecordInterceptProc)(XPointer closure, XRecordInterceptData *recorded_data);

	typedef struct _XExtData {
		int number;
		struct _XExtData *next;
		int (*free_private)(struct _XExtData *extension);
		XPointer private_data;
	} XExtData;

	typedef struct {
		short	lbearing;
		short	rbearing;
		short	width;
		short	ascent;
		short	descent;
		unsigned short attributes;
	} XCharStruct;

	typedef struct {
		Atom name;
		unsigned long card32;
	} XFontProp;

	typedef struct {
		XExtData	*ext_data;
		Font fid;
		unsigned direction;
		unsigned min_char_or_byte2;
		unsigned max_char_or_byte2;
		unsigned min_byte1;
		unsigned max_byte1;
		Bool all_chars_exist;
		unsigned default_char;
		int n_properties;
		XFontProp *properties;
		XCharStruct min_bounds;
		XCharStruct max_bounds;
		XCharStruct *per_char;
		int ascent;
		int descent;
	} XFontStruct;

	typedef struct {
		unsigned char byte1;
		unsigned char byte2;
	} XChar2b;

	typedef struct _XOM *XOM;
	typedef struct _XOC *XOC, *XFontSet;

	typedef struct {
		int x, y;
		int width, height;
		int border_width;
		Window sibling;
		int stack_mode;
	} XWindowChanges;

	typedef struct {
		unsigned long pixel;
		unsigned short red, green, blue;
		char flags;
		char pad;
	} XColor;

	typedef struct {
		short x1, y1, x2, y2;
	} XSegment;

	typedef struct {
		short x, y;
	} XPoint;

	typedef struct {
		short x, y;
		unsigned short width, height;
	} XRectangle;

	typedef struct {
		short x, y;
		unsigned short width, height;
		short angle1, angle2;
	} XArc;

	typedef struct {
		XRectangle max_ink_extent;
		XRectangle max_logical_extent;
	} XFontSetExtents;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		Window root;
		Window subwindow;
		Time time;
		int x, y;
		int x_root, y_root;
		unsigned int state;
		unsigned int keycode;
		Bool same_screen;
	} XKeyEvent;
	typedef XKeyEvent XKeyPressedEvent;
	typedef XKeyEvent XKeyReleasedEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		Window root;
		Window subwindow;
		Time time;
		int x, y;
		int x_root, y_root;
		unsigned int state;
		unsigned int button;
		Bool same_screen;
	} XButtonEvent;
	typedef XButtonEvent XButtonPressedEvent;
	typedef XButtonEvent XButtonReleasedEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		Window root;
		Window subwindow;
		Time time;
		int x, y;
		int x_root, y_root;
		unsigned int state;
		char is_hint;
		Bool same_screen;
	} XMotionEvent;
	typedef XMotionEvent XPointerMovedEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		Window root;
		Window subwindow;
		Time time;
		int x, y;
		int x_root, y_root;
		int mode;
		int detail;
		Bool same_screen;
		Bool focus;
		unsigned int state;
	} XCrossingEvent;
	typedef XCrossingEvent XEnterWindowEvent;
	typedef XCrossingEvent XLeaveWindowEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		int mode;
		int detail;
	} XFocusChangeEvent;
	typedef XFocusChangeEvent XFocusInEvent;
	typedef XFocusChangeEvent XFocusOutEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		char key_vector[32];
	} XKeymapEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		int x, y;
		int width, height;
		int count;
	} XExposeEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Drawable drawable;
		int x, y;
		int width, height;
		int count;
		int major_code;
		int minor_code;
	} XGraphicsExposeEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Drawable drawable;
		int major_code;
		int minor_code;
	} XNoExposeEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		int state;
	} XVisibilityEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window parent;
		Window window;
		int x, y;
		int width, height;
		int border_width;
		Bool override_redirect;
	} XCreateWindowEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window event;
		Window window;
	} XDestroyWindowEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window event;
		Window window;
		Bool from_configure;
	} XUnmapEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window event;
		Window window;
		Bool override_redirect;
	} XMapEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window parent;
		Window window;
	} XMapRequestEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window event;
		Window window;
		Window parent;
		int x, y;
		Bool override_redirect;
	} XReparentEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window event;
		Window window;
		int x, y;
		int width, height;
		int border_width;
		Window above;
		Bool override_redirect;
	} XConfigureEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window event;
		Window window;
		int x, y;
	} XGravityEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		int width, height;
	} XResizeRequestEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window parent;
		Window window;
		int x, y;
		int width, height;
		int border_width;
		Window above;
		int detail;
		unsigned long value_mask;
	} XConfigureRequestEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window event;
		Window window;
		int place;
	} XCirculateEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window parent;
		Window window;
		int place;
	} XCirculateRequestEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		Atom atom;
		Time time;
		int state;
	} XPropertyEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		Atom selection;
		Time time;
	} XSelectionClearEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window owner;
		Window requestor;
		Atom selection;
		Atom target;
		Atom property;
		Time time;
	} XSelectionRequestEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window requestor;
		Atom selection;
		Atom target;
		Atom property;
		Time time;
	} XSelectionEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		Colormap colormap;
		Bool new;
		int state;
	} XColormapEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		Atom message_type;
		int format;
		union {
			char b[20];
			short s[10];
			long l[5];
		} data;
	} XClientMessageEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
		int request;
		int first_keycode;
		int count;
	} XMappingEvent;

	typedef struct {
		int type;
		Display *display;
		XID resourceid;
		unsigned long serial;
		unsigned char error_code;
		unsigned char request_code;
		unsigned char minor_code;
	} XErrorEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		Window window;
	} XAnyEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		int extension;
		int evtype;
	} XGenericEvent;

	typedef struct {
		int type;
		unsigned long serial;
		Bool send_event;
		Display *display;
		int extension;
		int evtype;
		unsigned int cookie;
		void *data;
	} XGenericEventCookie;

	typedef union _XEvent {
		int type;
		XAnyEvent xany;
		XKeyEvent xkey;
		XButtonEvent xbutton;
		XMotionEvent xmotion;
		XCrossingEvent xcrossing;
		XFocusChangeEvent xfocus;
		XExposeEvent xexpose;
		XGraphicsExposeEvent xgraphicsexpose;
		XNoExposeEvent xnoexpose;
		XVisibilityEvent xvisibility;
		XCreateWindowEvent xcreatewindow;
		XDestroyWindowEvent xdestroywindow;
		XUnmapEvent xunmap;
		XMapEvent xmap;
		XMapRequestEvent xmaprequest;
		XReparentEvent xreparent;
		XConfigureEvent xconfigure;
		XGravityEvent xgravity;
		XResizeRequestEvent xresizerequest;
		XConfigureRequestEvent xconfigurerequest;
		XCirculateEvent xcirculate;
		XCirculateRequestEvent xcirculaterequest;
		XPropertyEvent xproperty;
		XSelectionClearEvent xselectionclear;
		XSelectionRequestEvent xselectionrequest;
		XSelectionEvent xselection;
		XColormapEvent xcolormap;
		XClientMessageEvent xclient;
		XMappingEvent xmapping;
		XErrorEvent xerror;
		XKeymapEvent xkeymap;
		XGenericEvent xgeneric;
		XGenericEventCookie xcookie;
		long pad[24];
	} XEvent;

	typedef struct {
		XExtData *ext_data;
		VisualID visualid;
		int class;
		unsigned long red_mask, green_mask, blue_mask;
		int bits_per_rgb;
		int map_entries;
	} Visual;

	typedef struct {
		int function;
		unsigned long plane_mask;
		unsigned long foreground;
		unsigned long background;
		int line_width;
		int line_style;
		int cap_style;
		int join_style;
		int fill_style;
		int fill_rule;
		int arc_mode;
		Pixmap tile;
		Pixmap stipple;
		int ts_x_origin;
		int ts_y_origin;
		Font font;
		int subwindow_mode;
		Bool graphics_exposures;
		int clip_x_origin;
		int clip_y_origin;
		Pixmap clip_mask;
		int dash_offset;
		char dashes;
	} XGCValues;

	typedef struct _XGC {
			XExtData *ext_data;
			GContext gid;
			// omitted: other private fields
	} *GC;

	typedef struct {
		int depth;
		int nvisuals;
		Visual *visuals;
	} Depth;

	typedef struct {
		XExtData *ext_data;
		struct _XDisplay *display;
		Window root;
		int width, height;
		int mwidth, mheight;
		int ndepths;
		Depth *depths;
		int root_depth;
		Visual *root_visual;
		GC default_gc;
		Colormap cmap;
		unsigned long white_pixel;
		unsigned long black_pixel;
		int max_maps, min_maps;
		int backing_store;
		Bool save_unders;
		long root_input_mask;
	} Screen;

	typedef struct {
		XExtData *ext_data;
		int depth;
		int bits_per_pixel;
		int scanline_pad;
	} ScreenFormat;

	typedef struct {
		Pixmap background_pixmap;
		unsigned long background_pixel;
		Pixmap border_pixmap;
		unsigned long border_pixel;
		int bit_gravity;
		int win_gravity;
		int backing_store;
		unsigned long backing_planes;
		unsigned long backing_pixel;
		Bool save_under;
		long event_mask;
		long do_not_propagate_mask;
		Bool override_redirect;
		Colormap colormap;
		Cursor cursor;
	} XSetWindowAttributes;

	typedef struct {
		Time time;
		short x, y;
	} XTimeCoord;

	// internal; libX11-specific
	struct _XDisplay {
		XExtData *ext_data;
		struct _XPrivate *private1;
		int fd;
		int private2;
		int proto_major_version;
		int proto_minor_version;
		const char *vendor;
		XID private3;
		XID private4;
		XID private5;
		int private6;
		XID (*resource_alloc)(struct _XDisplay*);
		int byte_order;
		int bitmap_unit;
		int bitmap_pad;
		int bitmap_bit_order;
		int nformats;
		ScreenFormat *pixmap_format;
		int private8;
		int release;
		struct _XPrivate *private9, *private10;
		int qlen;
		unsigned long last_request_read;
		unsigned long request;
		XPointer private11;
		XPointer private12;
		XPointer private13;
		XPointer private14;
		unsigned max_request_size;
		struct _XrmHashBucketRec *db;
		int (*private15)(struct _XDisplay*);
		const char *display_name;
		int default_screen;
		int nscreens;
		Screen *screens;
		unsigned long motion_buffer;
		unsigned long private16;
		int min_keycode;
		int max_keycode;
		XPointer private17;
		XPointer private18;
		int private19;
		const char *xdefaults;
		// omitted: other private fields
	};

	typedef struct {
		int x, y;
		int width, height;
		int border_width;
		int depth;
		Visual *visual;
		Window root;
		int class;
		int bit_gravity;
		int win_gravity;
		int backing_store;
		unsigned long backing_planes;
		unsigned long backing_pixel;
		Bool save_under;
		Colormap colormap;
		Bool map_installed;
		int map_state;
		long all_event_masks;
		long your_event_mask;
		long do_not_propagate_mask;
		Bool override_redirect;
		Screen *screen;
	} XWindowAttributes;

	typedef struct {
		long flags;
		int x, y;
		int width, height;
		int min_width, min_height;
		int max_width, max_height;
		int width_inc, height_inc;
		struct { int x; int y; } min_aspect, max_aspect;
		int base_width, base_height;
		int win_gravity;
	} XSizeHints;

	typedef struct {
		const char *res_name;
		const char *res_class;
	} XClassHint;

	typedef struct {
		const unsigned char *value;
		Atom encoding;
		int format;
		unsigned long nitems;
	} XTextProperty;

	typedef struct _XComposeStatus {
		XPointer compose_ptr;
		int chars_matched;
	} XComposeStatus;

	typedef struct {
		unsigned char first;
		unsigned char last;
	} XRecordRange8;
	
	typedef struct {
		unsigned short first;
		unsigned short last;
	} XRecordRange16;
	
	typedef struct {
		XRecordRange8 ext_major;
		XRecordRange16 ext_minor;
	} XRecordExtRange;
	
	typedef struct {
		XRecordRange8 core_requests;
		XRecordRange8 core_replies;
		XRecordExtRange ext_requests;
		XRecordExtRange ext_replies;
		XRecordRange8 delivered_events;
		XRecordRange8 device_events;
		XRecordRange8 errors;
		Bool client_started;
		Bool client_died;
	} XRecordRange;

	typedef struct {
		XRecordClientSpec client;
		unsigned long nranges;
		XRecordRange **ranges;
	} XRecordClientInfo;

	typedef struct {
		Bool enabled;
		int datum_flags;
		unsigned long nclients;
		XRecordClientInfo **client_info;
	} XRecordState;

	struct _XRecordInterceptData {
		XID id_base;
		Time server_time;
		unsigned long client_seq;
		int category;
		Bool client_swapped;
		unsigned char *data;
		unsigned long data_len;
	};

	int XFree(void *data);
	void (*XSetErrorHandler(void (*handler)(Display *, XErrorEvent *)))();
	Display *XOpenDisplay(const char* display_name);
	int XCloseDisplay(Display *display);

	int XFlush(Display *display);
	int XSync(Display *display, Bool discard);
	int XEventsQueued(Display *display, int mode);
	int XPending(Display *display);
	int XGrabServer(Display *display);
	int XUngrabServer(Display *display);
	int XGetErrorText(Display *display, int code, char *buffer_return, int length);
	Status XQueryTree(Display* display, Window w, Window* root_return, Window* parent_return, Window** children_return, unsigned int *nchildren_return);
	int XSelectInput(Display *display, Window w, long event_mask);
	Status XGetWindowAttributes(Display *display, Window w, XWindowAttributes *window_attributes_return);
	Status XGetGeometry(Display *display, Drawable d, Window *root_return, int *x_return, int *y_return, unsigned int *width_return, unsigned int *height_return, unsigned int *border_width_return, unsigned int *depth_return);
	Window XCreateWindow(Display *display, Window parent, int x, int y, unsigned int width, unsigned int height, unsigned int border_width, int depth, unsigned int class, Visual *visual, unsigned long valuemask, XSetWindowAttributes *attributes);
	Window XCreateSimpleWindow(Display *display, Window parent, int x, int y, unsigned int width, unsigned int height, unsigned int border_width, unsigned long border, unsigned long background);
	int XChangeSaveSet(Display *display, Window w, int change_mode);
	int XAddToSaveSet(Display *display, Window w);
	int XRemoveFromSaveSet(Display *display, Window w);
	Status XSetWMProtocols(Display *display, Window w, Atom *protocols, int count);
	Status XGetWMProtocols(Display *display, Window w, Atom **protocols_return, int *count_return);
	int XMapWindow(Display *display, Window w);
	int XMapRaised(Display *display, Window w);
	int XMapSubwindows(Display *display, Window w);
	int XUnmapWindow(Display *display, Window w);
	int XUnmapSubwindows(Display *display, Window w);
	int XDestroyWindow(Display *display, Window w);
	int XDestroySubwindows(Display *display, Window w);
	int XSetCloseDownMode(Display *display, int close_mode);
	int XKillClient(Display *display, XID resource);
	int XReparentWindow(Display *display, Window w, Window parent, int x, int y);
	Status XSendEvent(Display *display, Window w, Bool propagate, long event_mask, XEvent *event_send);
	unsigned long XDisplayMotionBufferSize(Display *display);
	XTimeCoord *XGetMotionEvents(Display *display, Window w, Time start, Time stop, int *nevents_return);
	int XClearArea(Display *display, Window w, int x, int y, unsigned width, unsigned height, Bool exposures);
	int XClearWindow(Display *display, Window w);
	int XSetState(Display *display, GC gc, unsigned long foreground, unsigned int background, int function, unsigned long plane_mask);
	int XSetFunction(Display *display, GC gc, int function);
	int XSetPlaneMask(Display *display, GC gc, unsigned long plane_mask);
	int XSetForeground(Display *display, GC gc, unsigned long foreground);
	int XSetBackground(Display *display, GC gc, unsigned long background);
	int XDrawString(Display *display, Drawable d, GC gc, int x, int y, const char *string, int length);
	int XDrawString16(Display *display, Drawable d, GC gc, int x, int y, const XChar2b *string, int length);
	int XFillRectangle(Display *display, Drawable d, GC gc, int x, int y, unsigned int width, unsigned int height);
	int XFillRectangles(Display *display, Drawable d, GC gc, XRectangle *rectangles, int nrectangles);
	int XFillPolygon(Display *display, Drawable d, GC gc, XPoint *points, int npoints, int shape, int mode);
	int XFillArc(Display *display, Drawable d, GC gc, int x, int y, unsigned int width, unsigned int height, int angle1, int angle2);
	int XFillArcs(Display *display, Drawable d, GC gc, XArc *arcs, int narcs);
	int XNextEvent(Display *display, XEvent *event_return);
	int XPeekEvent(Display *display, XEvent *event_return);
	int XWindowEvent(Display *display, Window w, long event_mask, XEvent *event_return);
	Bool XCheckWindowEvent(Display *display, Window w, long event_mask, XEvent *event_return);
	int XMaskEvent(Display *display, long event_mask, XEvent *event_return);
	Bool XCheckMaskEvent(Display *display, long event_mask, XEvent *event_return);
	Bool XCheckTypedEvent(Display *display, int event_type, XEvent *event_return);
	Bool XCheckTypedWindowEvent(Display *display, Window w, int event_type, XEvent *event_return);
	Atom XInternAtom(Display *display, const char *atom_name, Bool only_if_exists);
	Status XInternAtoms(Display *display, const char **names, int count, Bool only_if_exists, Atom *atoms_return);
	const char *XGetAtomName(Display *display, Atom atom);
	Status XGetAtomNames(Display *display, Atom *atoms, int count, const char **names_return);
	XFontSet XCreateFontSet(Display *display, const char *base_font_name_list, const char ***missing_charset_list_return, int *missing_charset_count_return, const char **def_string_return);
	void XFreeFontSet(Display *display, XFontSet font_set);
	XFontSetExtents *XExtentsOfFontSet(XFontSet font_set);
	int XFontsOfFontSet(XFontSet font_set, XFontStruct ***font_struct_list_return, const char ***font_name_list_return);
	const char *XBaseFontNameListOfFontSet(XFontSet font_set);
	const char *XLocaleOfFontSet(XFontSet font_set);
	Bool XContextDependentDrawing(XFontSet font_set);
	Bool XContextualDrawing(XFontSet font_set);
	Bool XDirectionalDependentDrawing(XFontSet font_set);
	Font XLoadFont(Display *display, const char *name);
	XFontStruct *XQueryFont(Display *display, XID font_ID);
	XFontStruct *XLoadQueryFont(Display *display, const char *name);
	int XFreeFont(Display *display, XFontStruct *font_struct);
	Bool XGetFontProperty(XFontStruct *font_struct, Atom atom, unsigned long *value_return);
	int XUnloadFont(Display *display, Font font);
	int XGetWindowProperty(Display *display, Window w, Atom property, long long_offset, long long_length, Bool delete, Atom req_type, Atom *actual_type_return, int *actual_format_return, unsigned long *nitems_return, unsigned long *bytes_after_return, unsigned char **prop_return);
	Atom *XListProperties(Display *display, Window w, int *num_prop_return);
	int XChangeProperty(Display *display, Window w, Atom property, Atom type, int format, int mode, unsigned char *data, int nelements);
	int XRotateWindowProperties(Display *display, Window w, Atom properties[], int num_prop, int npositions);
	int XDeleteProperty(Display *display, Window w, Atom property);
	XOC XCreateOC(XOM om);
	void XDestroyOC(XOC oc);
	char * XSetOCValues(XOC oc, ...);
	char * XGetOCValues(XOC oc, ...);
	XOM XOMOfOC(XOC oc);
	Status XStringListToTextProperty(const char **list, int count, XTextProperty *text_prop_return);
	Status XTextPropertyToStringList(XTextProperty *text_prop, const char ***list_return, int *count_return);
	void XFreeStringList(const char **list);
	Pixmap XCreatePixmap(Display *display, Drawable d, unsigned int width, unsigned int height, unsigned int depth);
	int XFreePixmap(Display *display, Pixmap pixmap);
	int XReadBitmapFile(Display *display, Drawable d, const char *filename, unsigned int *width_return, unsigned int *height_return, Pixmap *bitmap_return, int *x_hot_return, int *y_hot_return);
	int XReadBitmapFileData(const char *filename, unsigned int *width_return, unsigned int *height_return, unsigned char *data_return, int *x_hot_return, int *y_hot_return);
	int XWriteBitmapFile(Display *display, char *filename, Pixmap bitmap, unsigned int width, unsigned int height, int x_hot, int y_hot);
	Pixmap XCreatePixmapFromBitmapData(Display *display, Drawable d, char *data, unsigned int width, unsigned int height, unsigned long fg, unsigned long bg, unsigned int depth);
	Pixmap XCreateBitmapFromData(Display *display, Drawable d, char *data, unsigned int width, unsigned int height);
	int XCopyArea(Display *display, Drawable src, Drawable dest, GC gc, int src_x, int src_y, unsigned int width, unsigned height, int dest_x, int dest_y);
	int XCopyPlane(Display *display, Drawable src, Drawable dest, GC gc, int src_x, int src_y, unsigned width, int height, int dest_x, int dest_y, unsigned long plane);
	int XTextWidth(XFontStruct *font_struct, const char *string, int count);
	int XTextWidth16(XFontStruct *font_struct, XChar2b *string, int count);
	Status XAllocColor(Display *display, Colormap colormap, XColor *screen_in_out);
	Status XAllocNamedColor(Display *display, Colormap colormap, char *color_name, XColor *screen_def_return, XColor *exact_def_return);
	Status XAllocColorCells(Display *display, Colormap colormap, Bool contig, unsigned long plane_masks_return[], unsigned int nplanes, unsigned long pixels_return[], unsigned int npixels);
	Status XAllocColorPlanes(Display *display, Colormap colormap, Bool contig, unsigned long pixels_return[], int ncolors, int nreds, int ngreens, int nblues, unsigned long *rmask_return, unsigned long *gmask_return, unsigned long *bmask_return);
	int XFreeColors(Display *display, Colormap colormap, unsigned long pixels[], int npixels, unsigned long planes);
	GC XCreateGC(Display *display, Drawable d, unsigned long valuemask, XGCValues *values);
	int XCopyGC(Display *display, GC src, unsigned long valuemask, GC dest);
	int XChangeGC(Display *display, GC gc, unsigned long valuemask, XGCValues *values);
	Status XGetGCValues(Display *display, GC gc, unsigned long valuemask, XGCValues *values_return);
	int XFreeGC(Display *display, GC gc);
	GContext XGContextFromGC(GC gc);
	XSizeHints *XAllocSizeHints(void);
	void XSetWMNormalHints(Display *display, Window w, XSizeHints *hints);
	Status XGetWMNormalHints(Display *display, Window w, XSizeHints *hints_return, long *supplied_return);
	void XSetWMSizeHints(Display *display, Window w, XSizeHints *hints, Atom property);
	Status XGetWMSizeHints(Display *display, Window w, XSizeHints *hints_return, long *supplied_return, Atom property);
	XClassHint *XAllocClassHint(void);
	void XSetClassHint(Display *display, Window w, XClassHint *class_hints);
	Status XGetClassHint(Display *display, Window w, XClassHint *class_hints_return);
	void XSetWMName(Display *display, Window w, XTextProperty *text_prop);
	Status XGetWMName(Display *display, Window w, XTextProperty *text_prop_return);
	int XStoreName(Display *display, Window w, const char *window_name);
	Status XFetchName(Display *display, Window w, const char **window_name_return);
	void XSetWMClientMachine(Display *display, Window w, XTextProperty *text_prop);
	Status XGetWMClientMachine(Display *display, Window w, XTextProperty *text_prop_return);
	int XmbTextExtents(XFontSet font_set, const char *string, int num_bytes, XRectangle *overall_ink_return, XRectangle *overall_logical_return);
	int XwcTextExtents(XFontSet font_set, const wchar_t *string, int num_wchars, XRectangle *overall_ink_return, XRectangle *overall_logical_return);
	int Xutf8TextExtents(XFontSet font_set, const char *string, int num_bytes, XRectangle *overall_ink_return, XRectangle *overall_logical_return);
	int XConfigureWindow(Display *display, Window w, unsigned value_mask, XWindowChanges *changes);
	int XMoveWindow(Display *display, Window w, int x, int y);
	int XResizeWindow(Display *display, Window w, unsigned width, unsigned height);
	int XMoveResizeWindow(Display *display, Window w, int x, int y, unsigned width, unsigned height);
	int XSetWindowBorderWidth(Display *display, Window w, unsigned width);
	int XSetInputFocus(Display *display, Window focus, int revert_to, Time time);
	int XGetInputFocus(Display *display, Window *focus_return, int *revert_to_return);
	int XGrabButton(Display *display, unsigned int button, unsigned int modifiers, Window grab_window, Bool owner_events, unsigned int event_mask, int pointer_mode, int keyboard_mode, Window confine_to, Cursor cursor);
	int XUngrabButton(Display *display, unsigned int button, unsigned int modifiers, Window grab_window);
	int XGrabKey(Display *display, int keycode, unsigned int modifiers, Window grab_window, Bool owner_events, int pointer_mode, int keyboard_mode);
	int XUngrabKey(Display *display, int keycode, unsigned int modifiers, Window grab_window);
	KeySym XStringToKeysym(char *string);
	char *XKeysymToString(KeySym keysym);
	KeySym XKeycodeToKeysym(Display *display, KeyCode keycode, int index);
	KeyCode XKeysymToKeycode(Display *display, KeySym keysym);
	void XConvertCase(KeySym keysym, KeySym *lower_return, KeySym *upper_return);
	int XWarpPointer(Display *display, Window src_w, Window dest_w, int src_x, int src_y, unsigned int src_width, unsigned int src_height, int dest_x, int dest_y);
	int XGrabPointer(Display *display, Window grab_window, Bool owner_events, unsigned int event_mask, int pointer_mode, int keyboard_mode, Window confine_to, Cursor cursor, Time time);
	int XUngrabPointer(Display *display, Time time);
	int XChangeActivePointerGrab(Display *display, unsigned int event_mask, Cursor cursor, Time time);
	KeySym XLookupKeysym(XKeyEvent *key_event, int index);
	int XRefreshKeyboardMapping(XMappingEvent *event_map);
	int XLookupString(XKeyEvent *event_struct, char *buffer_return, int bytes_buffer, KeySym *keysym_return, XComposeStatus *status_in_out);
	int XRebindKeysym(Display *display, KeySym keysym, KeySym list[], int mod_count, unsigned char *string, int num_bytes);
	Bool XFilterEvent(XEvent *event, Window w);
	int XmbLookupString(XIC ic, XKeyPressedEvent *event, char *buffer_return, int bytes_buffer, KeySym *keysym_return, Status *status_return);
	int XwcLookupString(XIC ic, XKeyPressedEvent *event, wchar_t *buffer_return, int wchars_buffer, KeySym *keysym_return, Status *status_return);
	int Xutf8LookupString(XIC ic, XKeyPressedEvent *event, char *buffer_return, int bytes_buffer, KeySym *keysym_return, Status *status_return);
	XIM XOpenIM(Display *display, XrmDatabase db, char *res_name, char *res_class);
	Status XCloseIM(XIM im);
	char *XSetIMValues(XIM im, ...);
	char *XGetIMValues(XIM im, ...);
	Display *XDisplayOfIM(XIM im);
	char *XLocaleOfIM(XIM im);
	Bool XRegisterIMInstantiateCallback(Display *display, XrmDatabase db, char *res_name, char *res_class, XIDProc callback, XPointer client_data);
	Bool XUnregisterIMInstantiateCallback(Display *display, XrmDatabase db, char *res_name, char *res_class, XIDProc callback, XPointer client_data);
	XIC XCreateIC(XIM im, ...);
	void XDestroyIC(XIC ic);
	XIM XIMOfIC(XIC ic);
	void XSetICFocus(XIC ic);
	void XUnsetICFocus(XIC ic);
	char * XSetICValues(XIC ic, ...);
	char * XGetICValues(XIC ic, ...);
	char *XmbResetIC(XIC ic);
	wchar_t *XwcResetIC(XIC ic);
	char *Xutf8ResetIC(XIC ic);

	Status XRecordQueryVersion(Display *display, int cmajor_return, int cminor_return);
	XRecordContext XRecordCreateContext(Display *display, int datum_flags, XRecordClientSpec *clients, int nclients, XRecordRange **ranges, int nranges);
	XRecordRange *XRecordAllocRange(void);
	Status XRecordRegisterClients(Display *display, XRecordContext context, int datum_flags, XRecordClientSpec *clients, int nclients, XRecordRange *ranges, int nranges);
	Status XRecordUnRegisterClients(Display *display, XRecordContext context, XRecordClientSpec *clients, int nclients);
	Status XRecordGetContext(Display *display, XRecordContext context, XRecordState **state_return);
	void XRecordFreeState(XRecordState *state);
	Status XRecordEnableContext(Display *display, XRecordContext context, XRecordInterceptProc callback, XPointer closure);
	Status XRecordEnableContextAsync(Display *display, XRecordContext context, XRecordInterceptProc callback, XPointer closure);
	void XRecordProcessReplies(Display *display);
	void XRecordFreeData(XRecordInterceptData *data);
	Status XRecordDisableContext(Display *display, XRecordContext context);
	XID XRecordIdBaseMask(Display *display);
	Status XRecordFreeContext(Display *display, XRecordContext context);
]]

--[[private fields omitted]]

--[[@class xlib_status_c]]
--[[@class xlib_id_c]]
--[[@class xlib_mask_c]]
--[[@class xlib_atom_c]]
--[[@class xlib_visualid_c]]
--[[@class xlib_time_c]]
--[[@class xlib_window_c: xlib_drawable_c]]
--[[@class xlib_drawable_c: xlib_id_c]]
--[[@class xlib_font_c: xlib_id_c]]
--[[@class xlib_pixmap_c: xlib_drawable_c]]
--[[@class xlib_cursor_c: xlib_id_c]]
--[[@class xlib_colormap_c: xlib_id_c]]
--[[@class xlib_gcontext_c: xlib_id_c]]
--[[@class xlib_key_sym_c: xlib_id_c]]
--[[@class xlib_key_code_c]]
--[[@class xlib_pointer_c]]

--[[@class xlib_im_c]]
--[[@class xlib_ic_c]]

--[[@alias xlib_im_proc_c fun(im: xlib_im_c, a: xlib_pointer_c, b: xlib_pointer_c)]]
--[[@alias xlib_ic_proc_c fun(ic: xlib_ic_c, a: xlib_pointer_c, b: xlib_pointer_c): boolean]]
--[[@alias xlib_id_proc_c fun(d: xlib_display_c, a: xlib_pointer_c, b: xlib_pointer_c)]]

--[[@class xlib_rm_database_c]]

--[[Per character font metric information]]
--[[@class xlib_char_struct_c]]
--[[@field lbearing integer]]
--[[@field rbearing integer]]
--[[@field width integer]]
--[[@field ascent integer]]
--[[@field descent integer]]
--[[@field attributes integer]]

--[[To allow arbitrary information with fonts, there are additional properties returned.]]
--[[@class xlib_font_prop_c]]
--[[@field name xlib_atom_c]]
--[[@field card32 integer]]

--[[@class xlib_font_struct_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field fid xlib_font_c]]
--[[@field direction integer]]
--[[@field min_char_or_byte2 integer]]
--[[@field max_char_or_byte2 integer]]
--[[@field min_byte1 integer]]
--[[@field max_byte1 integer]]
--[[@field all_chars_exist boolean]]
--[[@field default_char integer]]
--[[@field n_properties integer]]
--[[@field properties ptr_c<xlib_font_prop_c>]]
--[[@field min_bounds xlib_char_struct_c]]
--[[@field max_bounds xlib_char_struct_c]]
--[[@field per_char ptr_c<xlib_char_struct_c>]]
--[[@field ascent integer]]
--[[@field descent integer]]

--[[@class xlib_font_set_extents_c]]
--[[@field max_ink_extent xlib_rectangle_c]]
--[[@field max_logical_extent xlib_rectangle_c]]

--[[@class xlib_om_c]]

--[[@class xlib_oc_c]]

--[[@class xlib_font_set_c]]

--[[@class xlib_window_changes_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field window xlib_window_c]]
--[[@field stack_mode xlib_window_stacking_method]]

--[[@class xlib_color_c]]
--[[@field pixel integer]]
--[[@field red integer]]
--[[@field green integer]]
--[[@field blue integer]]
--[[@field flags xlib_store_color_flag]]

--[[@class xlib_segment_c]]
--[[@field x1 integer]]
--[[@field y1 integer]]
--[[@field x2 integer]]
--[[@field y2 integer]]

--[[@class xlib_point_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xlib_rectangle_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]

--[[@class xlib_arc_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field angle1 integer]]
--[[@field angle2 integer]]

--[[@class _xlib_base_event_c]]
--[[@field type xlib_event_type]]
--[[@field serial integer]]
--[[@field send_event boolean]]
--[[@field display ptr_c<xlib_display_c>]]

--[[@class xlib_any_event_c: _xlib_base_event_c]]
--[[@field window xlib_window_c]]

--[[@class _xlib_positioned_event_c: xlib_any_event_c]]
--[[@field root xlib_window_c]]
--[[@field subwindow xlib_window_c]]
--[[@field time xlib_time_c ms]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field x_root integer]]
--[[@field y_root integer]]

--[[@class xlib_key_event_c: _xlib_positioned_event_c]]
--[[@field type 2|3]]
--[[@field state xlib_key_button_mask]]
--[[@field keycode xlib_key_code_c]]
--[[@field same_screen boolean]]

--[[@class xlib_key_pressed_event_c: xlib_key_event_c]]
--[[@field type 2]]

--[[@class xlib_key_released_event_c: xlib_key_event_c]]
--[[@field type 3]]

--[[@class xlib_button_event_c: _xlib_positioned_event_c]]
--[[@field type 4|5]]
--[[@field state xlib_key_button_mask]]
--[[@field button xlib_button]]
--[[@field same_screen boolean]]

--[[@class xlib_button_pressed_event_c: xlib_button_event_c]]
--[[@field type 4]]

--[[@class xlib_button_released_event_c: xlib_button_event_c]]
--[[@field type 5]]

--[[@class xlib_motion_event_c: _xlib_positioned_event_c]]
--[[@field type 6]]
--[[@field state xlib_key_button_mask]]
--[[@field is_hint xlib_notify_hint_mode]]
--[[@field same_screen boolean]]

--[[@class xlib_pointer_moved_event_c: xlib_motion_event_c]]

--[[@class xlib_crossing_event_c: _xlib_positioned_event_c]]
--[[@field type 7|8]]
--[[@field mode xlib_notify_mode cannot be `while_grabbed`]]
--[[@field detail xlib_notify_detail]]
--[[@field same_screen boolean]]
--[[@field focus boolean]]

--[[@class xlib_enter_window_event_c: xlib_crossing_event_c]]
--[[@field type 7]]

--[[@class xlib_leave_window_event_c: xlib_crossing_event_c]]
--[[@field type 8]]

--[[@class xlib_focus_change_event_c: xlib_any_event_c]]
--[[@field type 9|10]]
--[[@field mode xlib_notify_mode]]
--[[@field detail xlib_notify_detail]]

--[[@class xlib_focus_in_event_c: xlib_focus_change_event_c]]
--[[@field type 9]]

--[[@class xlib_focus_out_event_c: xlib_focus_change_event_c]]
--[[@field type 10]]

--[[@class xlib_keymap_event_c: xlib_any_event_c]]
--[[@field type 11]]
--[[@field key_vector integer[] length 32]]

--[[@class xlib_expose_event_c: xlib_any_event_c]]
--[[@field type 12]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field count integer]]

--[[@class xlib_graphics_expose_event_c: _xlib_base_event_c]]
--[[@field type 13]]
--[[@field drawable xlib_drawable_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field count integer]]
--[[@field major_code xlib_request_code `copy_area` or `copy_plane`]]
--[[@field minor_code integer]]

--[[@class xlib_no_expose_event_c: _xlib_base_event_c]]
--[[@field type 14]]
--[[@field drawable xlib_drawable_c]]
--[[@field major_code xlib_request_code `copy_area` or `copy_plane`]]
--[[@field minor_code integer]]

--[[@class xlib_visibility_event_c: xlib_any_event_c]]
--[[@field type 15]]
--[[@field state integer]]

--[[@class xlib_create_window_event_c: _xlib_base_event_c]]
--[[@field type 16]]
--[[@field parent xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field override_redirect boolean]]

--[[@class xlib_destroy_window_event_c: _xlib_base_event_c]]
--[[@field type 17]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]

--[[@class xlib_unmap_event_c: _xlib_base_event_c]]
--[[@field type 18]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field from_configure boolean]]

--[[@class xlib_map_event_c: _xlib_base_event_c]]
--[[@field type 19]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field override_redirect boolean]]

--[[@class xlib_map_request_event_c: _xlib_base_event_c]]
--[[@field type 20]]
--[[@field parent xlib_window_c]]
--[[@field window xlib_window_c]]

--[[@class xlib_reparent_event_c: _xlib_base_event_c]]
--[[@field type 21]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field parent xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field override_redirect boolean]]

--[[@class xlib_configure_event_c: _xlib_base_event_c]]
--[[@field type 22]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field above xlib_window_c]]
--[[@field override_redirect boolean]]

--[[@class xlib_configure_request_event_c: _xlib_base_event_c]]
--[[@field type 23]]
--[[@field parent xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field above xlib_window_c]]
--[[@field detail xlib_window_stacking_method]]
--[[@field value_mask integer]]

--[[@class xlib_gravity_event_c: _xlib_base_event_c]]
--[[@field type 24]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xlib_resize_request_event_c: xlib_any_event_c]]
--[[@field type 25]]
--[[@field width integer]]
--[[@field height integer]]

--[[@class xlib_circulate_event_c: _xlib_base_event_c]]
--[[@field type 26]]
--[[@field event xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field place xlib_circulate_request_type]]

--[[@class xlib_circulate_request_event_c: _xlib_base_event_c]]
--[[@field type 27]]
--[[@field parent xlib_window_c]]
--[[@field window xlib_window_c]]
--[[@field place xlib_circulate_request_type]]

--[[@class xlib_property_event_c: xlib_any_event_c]]
--[[@field type 28]]
--[[@field atom xlib_atom_c]]
--[[@field time xlib_time_c]]
--[[@field state xlib_property_notification_type]]

--[[@class xlib_selection_clear_event_c: xlib_any_event_c]]
--[[@field type 29]]
--[[@field atom xlib_atom_c]]
--[[@field time xlib_time_c]]

--[[@class xlib_selection_request_event_c: _xlib_base_event_c]]
--[[@field type 30]]
--[[@field owner xlib_window_c]]
--[[@field requestor xlib_window_c]]
--[[@field selection xlib_atom_c]]
--[[@field target xlib_atom_c]]
--[[@field property xlib_atom_c can be `nil`]]
--[[@field time xlib_time_c]]

--[[@class xlib_selection_event_c: _xlib_base_event_c]]
--[[@field type 31]]
--[[@field requestor xlib_window_c]]
--[[@field selection xlib_atom_c]]
--[[@field target xlib_atom_c]]
--[[@field property xlib_atom_c can be `nil`]]

--[[@class xlib_colormap_event_c: xlib_any_event_c]]
--[[@field type 32]]
--[[@field colormap xlib_colormap_c can be `nil`]]
--[[@field new boolean]]
--[[@field state xlib_colormap_notification_type]]

--[[union `b`, `s`, `l`]]
--[[@class xlib_client_message_event_c: xlib_any_event_c]]
--[[@field type 33]]
--[[@field message_type xlib_atom_c]]
--[[@field format integer]]
--[[@field b integer[] ]]
--[[@field s integer[] ]]
--[[@field l integer[] ]]

--[[@class xlib_mapping_event_c: xlib_any_event_c]]
--[[@field type 34]]
--[[@field request xlib_mapping_type]]
--[[@field first_keycode integer]]
--[[@field count integer]]

--[[@class xlib_error_event_c]]
--[[@field type integer]]
--[[@field display ptr_c<xlib_display_c>]]
--[[@field resourceid xlib_id_c]]
--[[@field serial integer]]
--[[@field error_code integer]]
--[[@field request_code integer major opcode]]
--[[@field minor_code integer minor opcode]]

--[[@class xlib_generic_event_c: _xlib_base_event_c]]
--[[@field type 35]]
--[[@field extension integer]]
--[[@field evtype integer]]

--[[@class xlib_generic_event_cookie_c: xlib_generic_event_c]]
--[[@field cookie integer]]
--[[@field data ffi.cdata*]]


--[[@class xlib_event_c]]
--[[@field type xlib_event_type]]
--[[@field xany xlib_any_event_c]]
--[[@field xkey xlib_key_event_c]]
--[[@field xbutton xlib_button_event_c]]
--[[@field xmotion xlib_motion_event_c]]
--[[@field xcrossing xlib_crossing_event_c]]
--[[@field xfocus xlib_focus_change_event_c]]
--[[@field xexpose xlib_expose_event_c]]
--[[@field xgraphicsexpose xlib_graphics_expose_event_c]]
--[[@field xnoexpose xlib_no_expose_event_c]]
--[[@field xvisibility xlib_visibility_event_c]]
--[[@field xcreatewindow xlib_create_window_event_c]]
--[[@field xdestroywindow xlib_destroy_window_event_c]]
--[[@field xunmap xlib_unmap_event_c]]
--[[@field xmap xlib_map_event_c]]
--[[@field xmaprequest xlib_map_request_event_c]]
--[[@field xreparent xlib_reparent_event_c]]
--[[@field xconfigure xlib_configure_event_c]]
--[[@field xgravity xlib_gravity_event_c]]
--[[@field xresizerequest xlib_resize_request_event_c]]
--[[@field xconfigurerequest xlib_configure_request_event_c]]
--[[@field xcirculate xlib_circulate_event_c]]
--[[@field xcirculaterequest xlib_circulate_request_event_c]]
--[[@field xproperty xlib_property_event_c]]
--[[@field xselectionclear xlib_selection_clear_event_c]]
--[[@field xselectionrequest xlib_selection_request_event_c]]
--[[@field xselection xlib_selection_event_c]]
--[[@field xcolormap xlib_colormap_event_c]]
--[[@field xclient xlib_client_message_event_c]]
--[[@field xmapping xlib_mapping_event_c]]
--[[@field xerror xlib_error_event_c]]
--[[@field xkeymap xlib_keymap_event_c]]
--[[@field xgeneric xlib_generic_event_c]]
--[[@field xcookie xlib_generic_event_cookie_c]]

--[[Extensions need a way to hang private data on some structures.]]
--[[@class xlib_ext_data_c]]
--[[@field number integer number returned by XRegisterExtension]]
--[[@field next? ptr_c<xlib_ext_data_c>]]
--[[@field free_private fun(extension: ptr_c<xlib_ext_data_c>)]]
--[[@field private_data ptr_c<unknown>]]

--[[Visual structure; contains information about colormapping possible.]]
--[[@class xlib_visual_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field visualid xlib_visualid_c]]
--[[@field class integer e.g. monochrome]]
--[[@field red_mask integer]]
--[[@field green_mask integer]]
--[[@field blue_mask integer]]
--[[@field bits_per_rgb integer]]
--[[@field map_entries integer]]

--[[@class xlib_gc_values_c]]
--[[@field function integer logical operation]]
--[[@field plane_mask integer plane mask]]
--[[@field foreground integer foreground pixel]]
--[[@field background integer background pixel]]
--[[@field line_width integer line width]]
--[[@field line_style xlib_line_style]]
--[[@field cap_style xlib_cap_style]]
--[[@field join_style integer xlib_join_style]]
--[[@field fill_style integer xlib_fill_style]]
--[[@field fill_rule integer xlib_fill_rule]]
--[[@field arc_mode integer xlib_arc_mode]]
--[[@field tile xlib_pixmap_c for tiling operations]]
--[[@field stipple xlib_pixmap_c stipple 1 plane pixmap for stippling]]
--[[@field ts_x_origin integer offset for tile or stipple operations]]
--[[@field ts_y_origin integer]]
--[[@field font xlib_font_c default text font for text operations]]
--[[@field subwindow_mode xlib_subwindow_mode]]
--[[@field graphics_exposures boolean should exposures be generated]]
--[[@field clip_x_origin integer origin for clipping]]
--[[@field clip_y_origin integer]]
--[[@field clip_mask xlib_pixmap_c bitmap clipping; other calls for rects]]
--[[@field dash_offset integer patterned/dashed line information]]
--[[@field dashes integer char]]

--[[Graphics context.  ]]
--[[The contents of this structure are implementation dependent.  ]]
--[[A GC should be treated as opaque by application code.]]
--[[@class xlib__gc_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field gid xlib_gcontext_c]]

--[[@alias xlib_gc_c ptr_c<xlib__gc_c>]]

--[[Depth structure; contains information for each possible depth.]]
--[[@class xlib_depth_c]]
--[[@field depth integer]]
--[[@field nvisuals integer]]
--[[@field visuals xlib_visual_c[] ]]

--[[@class xlib_screen_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field display ptr_c<xlib_display_c> parent]]
--[[@field root xlib_window_c]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field mwidth integer millimeters]]
--[[@field mheight integer millimeters]]
--[[@field ndepths integer]]
--[[@field depths xlib_depth_c[] ]]
--[[@field root_depth integer bits per pixel]]
--[[@field root_visual ptr_c<xlib_visual_c>]]
--[[@field default_gc xlib_gc_c GC for the root visual]]
--[[@field cmap xlib_colormap_c default color map]]
--[[@field white_pixel integer white pixel value]]
--[[@field black_pixel integer black pixel value]]
--[[@field max_maps integer max color map]]
--[[@field min_maps integer min color map]]
--[[@field backing_store xlib_backing_store]]
--[[@field save_unders boolean]]
--[[@field root_input_mask integer]]

--[[Format structure; describes ZFormat data the screen will understand.]]
--[[@class xlib_screen_format_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field depth integer]]
--[[@field bits_per_pixel integer]]
--[[@field scanline_pad integer]]

--[[@class xlib_set_window_attributes_c]]
--[[@field background_pixmap xlib_pixmap_c can be `None` or `ParentRelative`]]
--[[@field background_pixel integer]]
--[[@field border_pixmap xlib_pixmap_c]]
--[[@field border_pixel integer]]
--[[@field bit_gravity xlib_gravity]]
--[[@field win_gravity xlib_gravity]]
--[[@field backing_store xlib_backing_store]]
--[[@field backing_planes integer planes to be preserved if possible]]
--[[@field backing_pixel integer value to use in restoring planes]]
--[[@field save_under boolean should bits under be saved? (popups)]]
--[[@field event_mask xlib_input_event_mask saved events mask]]
--[[@field do_not_propagate_mask integer]]
--[[@field override_redirect boolean]]
--[[@field colormap xlib_colormap_c]]
--[[@field cursor xlib_cursor_c can be `None`]]

--[[@class xlib_time_coord_c]]
--[[@field time xlib_time_c]]
--[[@field x integer]]
--[[@field y integer]]

--[[@class xlib_display_c]]
--[[@field ext_data ptr_c<xlib_ext_data_c>]]
--[[@field fd fd_c]]
--[[@field proto_major_version integer]]
--[[@field proto_minor_version integer]]
--[[@field vendor string]]
--[[@field resource_alloc fun(display: ptr_c<xlib_display_c>): xlib_id_c]]
--[[@field byte_order xlib_bit_byte_order]]
--[[@field bitmap_unit integer]]
--[[@field bitmap_pad integer]]
--[[@field bitmap_bit_order xlib_bit_byte_order]]
--[[@field nformats integer]]
--[[@field pixmap_format ptr_c<xlib_screen_format_c>]]
--[[@field release integer]]
--[[@field qlen integer]]
--[[@field last_request_read integer]]
--[[@field request integer]]
--[[@field max_request_size integer]]
--[[@field display_name string]]
--[[@field default_screen integer]]
--[[@field nscreens integer]]
--[[@field screens xlib_screen_c[] ]]
--[[@field motion_buffer integer]]
--[[@field min_keycode xlib_key_code_c]]
--[[@field max_keycode xlib_key_code_c]]
--[[@field xdefaults string]]

-- unused fields should stay for plugin dx
--[[@class xlib_window_attributes_c]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer]]
--[[@field height integer]]
--[[@field border_width integer]]
--[[@field depth integer]]
--[[@field visual ptr_c<xlib_visual_c>]]
--[[@field root xlib_window_c]]
--[[@field class integer TODO: enum?]]
--[[@field bit_gravity xlib_gravity]]
--[[@field win_gravity xlib_gravity]]
--[[@field backing_store xlib_backing_store]]
--[[@field backing_planes integer]]
--[[@field backing_pixel integer]]
--[[@field save_under boolean]]
--[[@field colormap xlib_colormap_c]]
--[[@field map_installed boolean]]
--[[@field map_state xlib_map_state]]
--[[@field all_event_masks xlib_input_event_mask]]
--[[@field your_event_mask xlib_input_event_mask]]
--[[@field do_not_propagate_mask xlib_input_event_mask]]
--[[@field override_redirect boolean]]
--[[@field screen ptr_c<xlib_screen_c>]]

--[[@class xlib_size_hints_c]]
--[[@field flags xlib_size_flag marks which fields in this structure are defined]]
--[[@field x integer]]
--[[@field y integer]]
--[[@field width integer should set so old wms don't mess up]]
--[[@field height integer should set so old wms don't mess up]]
--[[@field min_width integer]]
--[[@field min_height integer]]
--[[@field max_width integer]]
--[[@field max_height integer]]
--[[@field width_inc integer]]
--[[@field height_inc integer]]
--[[@field min_aspect { x: integer; y: integer; }]]
--[[@field max_aspect { x: integer; y: integer; }]]
--[[@field base_width integer]]
--[[@field base_height integer]]
--[[@field win_gravity xlib_gravity]]

--[[@class xlib_class_hint_c]]
--[[@field res_name string]]
--[[@field res_class string]]

--[[new structure for manipulating `TEXT` properties  ]]
--[[used with `WM_NAME`, `WM_ICON_NAME`, `WM_CLIENT_MACHINE`, and `WM_COMMAND`.]]
--[[@class xlib_text_property_c]]
--[[@field value string]]
--[[@field encoding xlib_atom_c]]
--[[@field format 8|16|32]]
--[[@field nitems integer]]

--[[@class xlib_compose_status_c]]
--[[@field compose_ptr xlib_pointer_c state table pointer]]
--[[@field matched integer match state]]

--[[@class xlib_record_client_spec_c: integer]]
--[[@class xlib_record_context_c: integer]]

--[[@alias xlib_record_intercept_proc_c fun(closure: ffi.cdata*, recorded_data: ptr_c<xlib_record_intercept_data_c>)]]

--[[@class xlib_record_range_8_c]]
--[[@field first integer]]
--[[@field last integer]]

--[[@class xlib_record_range_16_c]]
--[[@field first integer]]
--[[@field last integer]]

--[[@class xlib_record_ext_range_c]]
--[[@field ext_major xlib_record_range_8_c]]
--[[@field ext_minor xlib_record_range_16_c]]

--[[@class xlib_record_range_c]]
--[[@field core_requests xlib_record_range_8_c core X requests]]
--[[@field core_replies xlib_record_range_8_c core X replies]]
--[[@field ext_requests xlib_record_ext_range_c extension requests]]
--[[@field ext_replies xlib_record_ext_range_c extension replies]]
--[[@field delivered_events xlib_record_range_8_c delivered core and ext events]]
--[[@field device_events xlib_record_range_8_c all core and ext device events]]
--[[@field errors xlib_record_range_8_c  core X and ext errors]]
--[[@field client_started boolean connection setup reply]]
--[[@field client_died boolean notice of client disconnect]]

--[[@class xlib_record_client_info_c]]
--[[@field client xlib_record_client_spec_c]]
--[[@field nranges integer]]
--[[@field ranges ptr_c<xlib_record_range_c[]> ]]

--[[@class xlib_record_state_c]]
--[[@field enabled boolean]]
--[[@field datum_flags xlib_record_datum_flag]]
--[[@field nclients integer]]
--[[@field client_info ptr_c<xlib_record_client_info_c[]> ]]

--[[@class xlib_record_intercept_data_c]]
--[[@field id_base xlib_id_c]]
--[[@field server_time xlib_time_c]]
--[[@field client_seq integer]]
--[[@field category integer]]
--[[@field client_swapped boolean]]
--[[@field data string]]
--[[@field data_len integer in 4-byte units]]

--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.none_window = 0 --[[@type xlib_window_c]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.none_cursor = 0 --[[@type xlib_cursor_c]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.none_pixmap = 0 --[[@type xlib_pixmap_c]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.none_atom = 0 --[[@type xlib_atom_c]]

--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.parent_relative = 1 --[[@type xlib_pixmap_c]] --[[background pixmap in `CreateWindow` and `ChangeWindowAttributes`]]
--[[border pixmap in `CreateWindow` and `ChangeWindowAttributes`  ]]
--[[special visualid and special window class passed total `CreateWindow`]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.copy_from_parent = 0 --[[@type xlib_pixmap_c]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.pointer_window = 0 --[[@type xlib_window_c]] --[[destination window in `SendEvent`]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.input_focus = 1 --[[@type xlib_window_c]] --[[destination window in `SendEvent`]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.pointer_root = 1 --[[@type xlib_window_c]] --[[focus window in `SetInputFocus` - root window of pointer's parent screen]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.any_property_type = 0 --[[@type xlib_atom_c]] --[[passed to `GetProperty`]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.any_key = 0 --[[@type xlib_key_code_c]] --[[passed to `GrabKey`]]
mod.all_temporary = 0 --[[passed to `KillClient`]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.current_time = 0 --[[@type xlib_time_c]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
mod.no_symbol = 0 --[[@type xlib_key_sym_c]]

--[[@enum xlib_events_queued_mode]]
mod.events_queued_mode = { queued_already = 0, queued_after_reading = 1, queued_after_flush = 2 }

--[[@enum xlib_input_event_mask]]
mod.input_event_mask = {
	no_event = 0x0,
	key_press = 0x1,
	key_release = 0x2,
	button_press = 0x4,
	button_release = 0x8,
	enter_window = 0x10,
	leave_window = 0x20,
	pointer_motion = 0x40,
	pointer_motion_hint = 0x80,
	button1_motion = 0x100,
	button2_motion = 0x200,
	button3_motion = 0x400,
	button4_motion = 0x800,
	button5_motion = 0x1000,
	button_motion = 0x2000,
	keymap_state = 0x4000,
	exposure = 0x8000,
	visibility_change = 0x10000,
	structure_notify = 0x20000,
	resize_redirect = 0x40000,
	substructure_notify = 0x80000,
	substructure_redirect = 0x100000,
	focus_change = 0x200000,
	property_change = 0x400000,
	colormap_change = 0x800000,
	owner_grab_button = 0x1000000,
}

--[[@enum xlib_event_type]]
mod.event_type = {
	error = 0, --[[@deprecated]]
	reply = 0, --[[@deprecated]]
	key_press = 2,
	key_release = 3,
	button_press = 4,
	button_release = 5,
	motion_notify = 6,
	enter_notify = 7,
	leave_notify = 8,
	focus_in = 9,
	focus_out = 10,
	keymap_notify = 11,
	expose = 12,
	graphics_expose = 13,
	no_expose = 14,
	visibility_notify = 15,
	create_notify = 16,
	destroy_notify = 17,
	unmap_notify = 18,
	map_notify = 19,
	map_request = 20,
	reparent_notify = 21,
	configure_notify = 22,
	configure_request = 23,
	gravity_notify = 24,
	resize_request = 25,
	circulate_notify = 26,
	circulate_request = 27,
	property_notify = 28,
	selection_clear = 29,
	selection_request = 30,
	selection_notify = 31,
	colormap_notify = 32,
	client_message = 33,
	mapping_notify = 34,
	generic_event = 35,
}

--[[key masks and button masks]]
--[[@enum xlib_key_button_mask]]
mod.key_button_mask = {
	shift = 0x1, lock = 0x2, control = 0x4,
	mod1 = 0x8, mod2 = 0x10, mod3 = 0x20, mod4 = 0x40, mod5 = 0x80,
	button_1 = 0x100, button_2 = 0x200, button_3 = 0x400, button_4 = 0x800, button_5 = 0x1000,
	any_modifier = 0x8000, --[[used in `GrabButton`, `GrabKey`]]
}

--[[@enum xlib_key_map_index]]
mod.key_map_index = { shift = 0, lock = 1, control = 2, mod_1 = 3, mod_2 = 4, mod_3 = 5, mod_4 = 6, mod_5 = 7 }
--[[@enum xlib_button]]
mod.button = { any = 0, _1 = 1, _2 = 2, _3 = 3, _4 = 4, _5 = 5 }
--[[@enum xlib_notify_mode]]
mod.notify_mode = { normal = 0, grab = 1, ungrab = 2, while_grabbed = 3 }
--[[@enum xlib_notify_hint_mode]]
mod.notify_hint_mode = { normal = 0, hint = 1 }

--[[@enum xlib_notify_detail]]
mod.notify_detail = {
	ancestor = 0, virtual = 1, inferior = 2, nonlinear = 3, nonlinear_virtual = 4,
	pointer = 5, pointer_root = 6, none = 7,
}

--[[@enum xlib_visibility_notification_type]]
mod.visibility_notification_type = { unobscured = 0, partially_obscured = 1, fully_obscured = 2 }
--[[@enum xlib_circulate_request_type]]
mod.circulation_request_type = { place_on_top = 0, place_on_bottom = 1 }
--[[@enum xlib_protocol_family]]
mod.protocol_family = { ipv4 = 0, decnet = 1, chaos = 2, server_interpreted = 5, ipv6 = 6 }
--[[@enum xlib_property_notification_type]]
mod.property_notification_type = { new_value = 0, delete = 1 }
--[[@enum xlib_colormap_notification_type]]
mod.colormap_notification_type = { uninstalled = 0, installed = 1 }
--[[@enum xlib_grab_mode]]
mod.grab_mode = { sync = 0, async = 1 }
--[[@enum xlib_grab_status]]
mod.grab_status = { success = 0, already_grabbed = 1, invalid_type = 2, not_viewable = 3, frozen = 4 }

--[[@enum xlib_allow_events_mode]]
mod.allow_events_mode = {
	async_pointer = 0, sync_pointer = 1, replay_pointer = 2,
	async_keyboard = 3, sync_keyboard = 4, replay_keyboard = 5,
	async_both = 6, sync_both = 7,
}

--[[@enum xlib_revert_to]]
mod.revert_to = { none = 0, pointer_root = 1, parent = 2 }

--[[@enum xlib_error_code]]
mod.error_code = {
	success = 0, bad_request = 1, bad_value = 2,
	bad_window = 3, bad_pixmap = 4, bad_atom = 5, bad_cursor = 6, bad_font = 7,
	bad_match = 8, bad_drawable = 9, bad_access = 10, bad_alloc = 11, bad_color = 12,
	bad_gc = 13, bad_id_choice = 14, bad_name = 15, bad_length = 16, bad_implementation = 17,
	extension_start = 128, extension_end = 255,
}

--[[@enum xlib_window_class]]
mod.window_class = { copy_from_parent = 0, input_output = 1, input_only = 2 }

--[[@enum xlib_window_attribute]]
mod.window_attribute = {
	back_pixmap = 0x1, back_pixel = 0x2, border_pixmap = 0x4, border_pixel = 0x8,
	bit_gravity = 0x10, win_gravity = 0x20,
	backing_store = 0x40, backing_planes = 0x80, backign_pixel = 0x100,
	override_redirect = 0x200, save_under = 0x400, event_mask = 0x800, dont_propagate = 0x1000,
	colormap = 0x2000, cursor = 0x4000
}

--[[@enum xlib_configure_window_attribute]]
mod.configure_window_attribute = {
	x = 0x1, y = 0x2, width = 0x4, height = 0x8, border_width = 0x10, sibling = 0x20, stack_mode = 0x40
}

--[[bit gravity and window gravity]]
--[[@enum xlib_gravity]]
mod.gravity = {
	forget = 0, --[[bit gravity, not window gravity]]
	unmap = 0, --[[window gravity, not bit gravity]]
	north_west = 1, north = 2, north_east = 3, west = 4, center = 5,
	east = 6, south_west = 7, south = 8, south_east = 9, static = 10,
}

--[[@enum xlib_backing_store]]
mod.backing_store = { not_useful = 0, when_mapped = 1, always = 2 }
--[[@enum xlib_map_state]]
mod.map_state = { is_unmapped = 0, is_unviewable = 1, is_viewable = 2 }
--[[@enum xlib_change_save_set_mode]]
mod.change_save_set_mode = { insert = 0, delete = 1 }
--[[@enum xlib_set_close_down_mode]]
mod.change_close_down_mode = { destroy_all = 0, retain_permanent = 1, retain_temporary = 2 }
--[[@enum xlib_window_stacking_method]]
mod.window_stacking_method = { above = 0, below = 1, top_if = 2, bottom_if = 3, opposite = 4 }
--[[@enum xlib_circulation_direction]]
mod.circulation_direction = { raise_lowest = 0, lower_highest = 1 }
--[[@enum xlib_property_mode]]
mod.property_mode = { replace = 0, prepend = 1, append = 2 }

--[[0 through 7 are the inverse (boolean not) of 15 through 8 respectively]]
--[[@enum xlib_graphics_function]]
mod.graphics_function = {
	clear = 0, --[[false]]
	["and"] = 1, --[[src and dst]]
	and_reverse = 2, --[[src and (not dst)]]
	copy = 3, --[[src]]
	and_inverted = 4, --[[(not src) and dst]]
	noop = 5, --[[dst]]
	xor = 6, --[[src ~= dst]]
	["or"] = 7, --[[src or dst]]
	nor = 8, --[[not src and not dst]]
	equiv = 9, --[[src == dst]]
	invert = 10, --[[not dst]]
	or_reverse = 11, --[[src or not dst]]
	copy_inverted = 12, --[[not src]]
	or_inverted = 13, --[[not src or dst]]
	nand = 14, --[[not src or not dst]]
	set = 15, --[[true]]
}

--[[@enum xlib_line_style]]
mod.line_style = { solid = 0, on_off_dash = 1, double_dash = 2 }
--[[@enum xlib_cap_style]]
mod.cap_style = { not_last = 0, butt = 1, round = 2, projecting = 3 }
--[[@enum xlib_join_style]]
mod.join_style = { miter = 0, round = 1, bevel = 2 }
--[[@enum xlib_fill_style]]
mod.fill_style = { solid = 0, tiled = 1, stippled = 2, opaque_stippled = 3 }
--[[@enum xlib_fill_rule]]
mod.fill_rule = { even_odd = 0, winding = 1 }
--[[@enum xlib_subwindow_mode]]
mod.subwindow_mode = { clip_by_children = 0, include_inferiors = 1 }
--[[@enum xlib_set_clip_rectangles_ordering]]
mod.set_clip_rectangles_ordering = { unsorted = 0, y_sorted = 1, yx_sorted = 2, yx_banded = 3 }

--[[@enum xlib_coordinate_mode]]
mod.coordinate_mode = {
	origin = 0, --[[relative to origin]]
	previous = 1, --[[relative to previous point]]
}

--[[@enum xlib_polygon_shape]]
mod.polygon_shape = {
	complex = 0, --[[paths may intersect]]
	nonconvex = 1, --[[no paths intersect, but not convex]]
	convex = 2, --[[wholly convex]]
}

--[[@enum xlib_arc_mode]]
mod.arc_mode = {
	chord = 0, --[[join endpoints to each other]]
	pie_slice = 1, --[[join endpoints to center]]
}

--[[@enum xlib_gc_component]]
mod.gc_component = {
	["function"] = 0x1, plane_mask = 0x2, foreground = 0x4, background = 0x8,
	line_width = 0x10, line_style = 0x20, cap_style = 0x40, join_style = 0x80, fill_style = 0x100, fill_rule = 0x200,
	tile = 0x400, stipple = 0x800, tile_stip_x_origin = 0x1000, tile_stip_y_origin = 0x2000,
	font = 0x4000, subwindow_mode = 0x8000, graphics_exposures = 0x10000,
	clip_x_origin = 0x20000, clip_y_origin = 0x40000,clip_mask = 0x80000,
	dash_offset = 0x100000, dash_list = 0x200000, arc_mode = 0x400000,
}

--[[@enum xlib_font_draw_direction]]
mod.font_draw_direction = { left_to_right = 0, right_to_left = 1 }

mod.font_change = 255

--[[@enum xlib_image_format]]
mod.image_format = {
	xy_bitmap = 0, --[[depth 1, XYFormat]]
	xy_pixmap = 1, --[[depth == drawable depth]]
	z_pixmap = 2, --[[depth == drawable depth]]
}

--[[@enum xlib_colormap_allocate_mode]]
mod.colormap_allocate_mode = {
	none = 0, --[[create map with no entries]]
	all = 1, --[[allocate entire map writeable]]
}

--[[@enum xlib_store_color_flag]]
mod.store_color_flag = { red = 0x1, green = 0x2, blue = 0x4 }

--[[@enum xlib_query_best_size_class]]
mod.query_best_size_class = {
	cursor_shape = 0, --[[largest size that can be displayed]]
	tile_shape = 1, --[[size tiled fastest]]
	stipple_shape = 2, --[[size stippled fastest]]
}

--[[@enum xlib_key_auto_repeat_mode]]
mod.key_auto_repeat_mode = { off = 0, on = 1, default = 2 }
--[[@enum xlib_keyboard_led_mode]]
mod.keyboard_led_mode = { off = 0, on = 1 }

--[[@enum xlib_change_keyboard_control_mask]]
mod.change_keyboard_control_mask = {
	key_click_percent = 0x1, bell_percent = 0x2, bell_pitch = 0x4, bell_duration = 0x8,
	led = 0x10, led_mode = 0x20, key = 0x40, auto_repeat_mode = 0x80,
}

--[[@enum xlib_mapping_status]]
mod.mapping_status = { succes = 0, busy = 1, failed = 2 }
--[[@enum xlib_mapping_type]]
mod.mapping_type = { modifier = 0, keyboard = 1, pointer = 2 }

--[[@enum xlib_screen_saver_blanking_mode]]
mod.screen_saver_blanking_mode = { dont_prefer = 0, prefer = 1, default = 2 }
mod.disable_screen_saver = 0
mod.disable_scrren_interval = 0

--[[@enum xlib_screen_saver_exposures_mode]]
mod.screen_saver_exposures_mode = { dont_allow = 0, allow = 1, default = 2 }

--[[@enum xlib_force_screen_saver_mode]]
mod.force_screen_saver_mode = { reset = 0, active = 1 }

--[[@enum xlib_change_host_mode]]
mod.change_host_mode = { insert = 0, delete = 1 }

--[[@enum xlib_change_access_control_mode]]
mod.change_access_control_mode = { disable = 0, enable = 1 }

--[[Display classes  ]]
--[[used in opening the connection]]
--[[Note that the statically allocated ones are even numbered]]
--[[and the dynamically changeable ones are odd numbered]]
--[[@enum xlib_display_class]]
mod.display_class = {
	static_gray = 0, gray_scale = 1, static_color = 2, pseudo_color = 3, true_color = 4, direct_color = 5
}

--[[bit order and byte order]]
--[[@enum xlib_bit_byte_order]]
mod.bit_byte_order = { lsb_first = 0, msb_first = 1 }

--[[@enum xlib_request_code]]
mod.request_code = {
	create_window = 1,
	change_window_attributes = 2,
	get_window_attributes = 3,
	destroy_window = 4,
	destroy_subwindows = 5,
	change_save_set = 6,
	reparent_window = 7,
	map_window = 8,
	map_subwindows = 9,
	unmap_window = 10,
	unmap_subwindows = 11,
	configure_window = 12,
	circulate_window = 13,
	get_geometry = 14,
	query_tree = 15,
	intern_atom = 16,
	get_atom_name = 17,
	change_property = 18,
	delete_property = 19,
	get_property = 20,
	list_properties = 21,
	set_selection_owner = 22,
	get_selection_owner = 23,
	convert_selection = 24,
	send_event = 25,
	grab_pointer = 26,
	ungrab_pointer = 27,
	grab_button = 28,
	ungrab_button = 29,
	change_active_pointer_grab = 30,
	grab_keyboard = 31,
	ungrab_keyboard = 32,
	grab_key = 33,
	ungrab_key = 34,
	allow_events = 35,
	grab_server = 36,
	ungrab_server = 37,
	query_pointer = 38,
	get_motion_events = 39,
	translate_coords = 40,
	warp_pointer = 41,
	set_input_focus = 42,
	get_input_focus = 43,
	query_keymap = 44,
	open_font = 45,
	close_font = 46,
	query_font = 47,
	query_text_extents = 48,
	list_fonts = 49,
	list_fonts_with_info = 50,
	set_font_path = 51,
	get_font_path = 52,
	create_pixmap = 53,
	free_pixmap = 54,
	create_gc = 55,
	change_gc = 56,
	copy_gc = 57,
	set_dashes = 58,
	set_clip_rectangles = 59,
	free_gc = 60,
	clear_area = 61,
	copy_area = 62,
	copy_plane = 63,
	poly_point = 64,
	poly_line = 65,
	poly_segment = 66,
	poly_rectangle = 67,
	poly_arc = 68,
	fill_poly = 69,
	poly_fill_rectangle = 70,
	poly_fill_arc = 71,
	put_image = 72,
	get_image = 73,
	poly_text8 = 74,
	poly_text16 = 75,
	image_text8 = 76,
	image_text16 = 77,
	create_colormap = 78,
	free_colormap = 79,
	copy_colormap_and_free = 80,
	install_colormap = 81,
	uninstall_colormap = 82,
	list_installed_colormaps = 83,
	alloc_color = 84,
	alloc_named_color = 85,
	alloc_color_cells = 86,
	alloc_color_planes = 87,
	free_colors = 88,
	store_colors = 89,
	store_named_color = 90,
	query_colors = 91,
	lookup_color = 92,
	create_cursor = 93,
	create_glyph_cursor = 94,
	free_cursor = 95,
	recolor_cursor = 96,
	query_best_size = 97,
	query_extension = 98,
	list_extensions = 99,
	change_keyboard_mapping = 100,
	get_keyboard_mapping = 101,
	change_keyboard_control = 102,
	get_keyboard_control = 103,
	bell = 104,
	change_pointer_control = 105,
	get_pointer_control = 106,
	set_screen_saver = 107,
	get_screen_saver = 108,
	change_hosts = 109,
	list_hosts = 110,
	set_access_control = 111,
	set_close_down_mode = 112,
	kill_client = 113,
	rotate_properties = 114,
	force_screen_saver = 115,
	set_pointer_mapping = 116,
	get_pointer_mapping = 117,
	set_modifier_mapping = 118,
	get_modifier_mapping = 119,
	no_operation = 127,
}

--[[@enum xlib_bitmap_status]]
mod.bitmap_status = { success = 0, open_failed = 1, file_invalid = 2, no_memory = 3 }

--[[u = user specified, p = program specified]]
--[[@enum xlib_size_flag]]
mod.size_flag = {
	us_position = 0x1, us_size = 0x2,
	p_position = 0x4, p_size = 0x8, p_min_size = 0x10, p_max_size = 0x20, p_resize_inc = 0x40, p_aspect = 0x80,
	p_base_size = 0x100, p_win_gravity = 0x200,
}


--[[@enum xlib_record_client_filter]]
mod.record_client_filter = { current = 1, future = 2, all = 3 }
--[[@enum xlib_record_datum_flag]]
mod.record_datum_flag = { none = 0, from_server_time = 0x1, from_client_time = 0x2, from_client_sequence = 0x4 }
--[[@enum xlib_record_category]]
mod.record_category = {
	from_server = 0, from_client = 1, client_started = 2, client_died = 3, start_of_data = 4, end_of_data = 5
}
mod.record_bad_context = 0 --[[@type xlib_record_context_c]]
mod.record_num_errors = 0
mod.record_num_events = 0

--[[@class xlib_ffi]]
--[[@field XFree fun(data: ptr_c<unknown>)]]
--[[@field XSetErrorHandler fun(handler: fun(display: xlib_display_c, error: xlib_error_event_c))]]
--[[@field XOpenDisplay fun(display_name?: string): ptr_c<xlib_display_c>]]
--[[@field XCloseDisplay fun(display: ptr_c<xlib_display_c>)]]
--[[@field XFlush fun(display: ptr_c<xlib_display_c>)]]
--[[@field XSync fun(display: ptr_c<xlib_display_c>, discard: boolean)]]
--[[@field XEventsQueued fun(display: ptr_c<xlib_display_c>, mode: xlib_events_queued_mode): integer]]
--[[@field XPending fun(display: ptr_c<xlib_display_c>): integer equivalent to `XEventsQueued(display, QueuedAfterFlush)`]]
--[[@field XGrabServer fun(display: ptr_c<xlib_display_c>)]]
--[[@field XUngrabServer fun(display: ptr_c<xlib_display_c>)]]
--[[@field XGetErrorText fun(display: ptr_c<xlib_display_c>, code: integer, buffer_return: string_c, length: integer)]]
--[[@field XQueryTree fun(display: ptr_c<xlib_display_c>, w: ptr_c<xlib_window_c>, root_return: ptr_c<xlib_window_c>, parent_return: ptr_c<xlib_window_c>, children_return: ptr_c<xlib_window_c[]>, nchildren_return: ptr_c<integer>): xlib_status_c]]
--[[@field XSelectInput fun(display: ptr_c<xlib_display_c>, window: xlib_window_c, event_mask: xlib_input_event_mask)]]
--[[@field XGetWindowAttributes fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, window_attributes_return: ptr_c<xlib_window_attributes_c>): xlib_status_c]]
--[[@field XGetGeometry fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, root_return: ptr_c<xlib_window_c>, x_return: ptr_c<integer>, y_return: ptr_c<integer>, width_return: ptr_c<integer>, height_return: ptr_c<integer>, border_width_return: ptr_c<integer>, depth_return: ptr_c<integer>): xlib_status_c]]
--[[@field XCreateWindow fun(display: ptr_c<xlib_display_c>, parent: xlib_window_c, x: integer, y: integer, width: integer, height: integer, border_width: integer, depth: integer, class: integer, visual: ptr_c<xlib_visual_c>, valuemask: integer, attributes: ptr_c<xlib_set_window_attributes_c>): xlib_window_c]]
--[[@field XCreateSimpleWindow fun(display: ptr_c<xlib_display_c>, parent: xlib_window_c, x: integer, y: integer, width: integer, height: integer, border_width: integer, border: integer, background: integer): xlib_window_c]]
--[[@field XChangeSaveSet fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, change_mode: xlib_change_save_set_mode)]]
--[[@field XAddToSaveSet fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XRemoveFromSaveSet fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XSetWMProtocols fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, protocols: xlib_atom_c[], count: integer): xlib_status_c]]
--[[@field XGetWMProtocols fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, protocols_return: ptr_c<xlib_atom_c[]>, count_return: ptr_c<integer>): xlib_status_c]]
--[[@field XMapWindow fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XMapRaised fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XMapSubwindows fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XUnmapWindow fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XUnmapSubwindows fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XDestroyWindow fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XDestroySubwindows fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XSetCloseDownMode fun(display: ptr_c<xlib_display_c>, close_mode: xlib_set_close_down_mode)]]
--[[@field XKillClient fun(display: ptr_c<xlib_display_c>, close_mode: xlib_id_c)]]
--[[@field XReparentWindow fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, parent: xlib_window_c, x: integer, y: integer)]]
--[[@field XSendEvent fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, propagate: boolean, event_mask: xlib_input_event_mask, event_send: ptr_c<xlib_event_c>): xlib_status_c]]
--[[@field XDisplayMotionBufferSize fun(display: ptr_c<xlib_display_c>): integer]]
--[[@field XGetMotionEvents fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, start: xlib_time_c, stop: xlib_time_c, nevents_return: ptr_c<integer>): ptr_c<xlib_time_coord_c>]]
--[[@field XClearArea fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, x: integer, y: integer, width: integer, height: integer, exposures: boolean)]]
--[[@field XClearWindow fun(display: ptr_c<xlib_display_c>, w: xlib_window_c)]]
--[[@field XSetState fun(display: ptr_c<xlib_display_c>, gc: xlib_gc_c, foreground: integer, background: integer, function: xlib_graphics_function, plane_mask: integer)]]
--[[@field XSetFunction fun(display: ptr_c<xlib_display_c>, gc: xlib_gc_c, function: xlib_graphics_function)]]
--[[@field XSetPlaneMask fun(display: ptr_c<xlib_display_c>, gc: xlib_gc_c, plane_mask: integer)]]
--[[@field XSetForeground fun(display: ptr_c<xlib_display_c>, gc: xlib_gc_c, foreground: integer)]]
--[[@field XSetBackground fun(display: ptr_c<xlib_display_c>, gc: xlib_gc_c, background: integer)]]
--[[@field XDrawString fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, gc: xlib_gc_c, x: integer, y: integer, string: string, length: integer)]]
--[[@field XDrawString16 fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, gc: xlib_gc_c, x: integer, y: integer, string: string, length: integer)]]
--[[@field XFillRectangle fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, gc: xlib_gc_c, x: integer, y: integer, width: integer, height: integer)]]
--[[@field XFillRectangles fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, gc: xlib_gc_c, rectangles: xlib_rectangle_c[], nrectangles: integer)]]
--[[@field XFillPolygon fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, gc: xlib_gc_c, points: xlib_point_c[], npoints: integer, shape: xlib_polygon_shape, mode: xlib_coordinate_mode)]]
--[[@field XFillArc fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, gc: xlib_gc_c, x: integer, y: integer, width: integer, height: integer, angle1: integer, angle2: integer)]]
--[[@field XFillArcs fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, gc: xlib_gc_c, arcs: xlib_arc_c[], narcs: integer)]]
--[[@field XNextEvent fun(display: ptr_c<xlib_display_c>, event_return: ptr_c<xlib_event_c>)]]
--[[@field XPeekEvent fun(display: ptr_c<xlib_display_c>, event_return: ptr_c<xlib_event_c>)]]
--[[@field XWindowEvent fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, event_mask: xlib_input_event_mask, event_return: ptr_c<xlib_event_c>)]]
--[[@field XCheckWindowEvent fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, event_mask: xlib_input_event_mask, event_return: ptr_c<xlib_event_c>): boolean]]
--[[@field XMaskEvent fun(display: ptr_c<xlib_display_c>, event_mask: xlib_input_event_mask, event_return: ptr_c<xlib_event_c>)]]
--[[@field XCheckMaskEvent fun(display: ptr_c<xlib_display_c>, event_mask: xlib_input_event_mask, event_return: ptr_c<xlib_event_c>): boolean]]
--[[@field XCheckTypedEvent fun(display: ptr_c<xlib_display_c>, event_type: xlib_event_type, event_return: ptr_c<xlib_event_c>): boolean]]
--[[@field XCheckTypedWindowEvent fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, event_type: xlib_event_type, event_return: ptr_c<xlib_event_c>): boolean]]
--[[@field XInternAtom fun(display: ptr_c<xlib_display_c>, atom_name: string, only_if_exists: boolean): xlib_atom_c?]]
--[[@field XInternAtoms fun(display: ptr_c<xlib_display_c>, names: string[], count: integer, only_if_exists: boolean, atoms_return: xlib_atom_c[]): xlib_status_c]]
--[[@field XGetAtomName fun(display: ptr_c<xlib_display_c>, atom: xlib_atom_c): string_c?]]
--[[@field XGetAtomNames fun(display: ptr_c<xlib_display_c>, atoms: xlib_atom_c[], count: integer, names_return: string_c[]): xlib_status_c]]
--[[@field XCreateFontSet fun(display: ptr_c<xlib_display_c>, base_font_name_list: string, missing_charset_list_return: ptr_c<string_c[]>, missing_charset_count_return: ptr_c<integer>, def_string_return: ptr_c<string_c>): xlib_font_set_c]]
--[[@field XFreeFontSet fun(display: ptr_c<xlib_display_c>, font_set: xlib_font_set_c)]]
--[[@field XExtentsOfFontSet fun(font_set: xlib_font_set_c): ptr_c<xlib_font_set_extents_c>]]
--[[@field XFontsOfFontSet fun(font_set: xlib_font_set_c, font_struct_list_return: ptr_c<ptr_c<xlib_font_struct_c>[]>, font_name_list_return: ptr_c<string_c[]>)]]
--[[@field XBaseFontNameListOfFontSet fun(font_set: xlib_font_set_c): ptr_c<string_c>]]
--[[@field XLocaleOfFontSet fun(font_set: xlib_font_set_c): ptr_c<string_c>]]
--[[@field XContextDependentDrawing fun(font_set: xlib_font_set_c): boolean]]
--[[@field XContextualDrawing fun(font_set: xlib_font_set_c): boolean]]
--[[@field XDirectionalDependentDrawing fun(font_set: xlib_font_set_c): boolean]]
--[[@field XLoadFont fun(display: ptr_c<xlib_display_c>, name: string): xlib_font_c]]
--[[@field XQueryFont fun(display: ptr_c<xlib_display_c>, font_ID: xlib_id_c): ptr_c<xlib_font_struct_c>]]
--[[@field XLoadQueryFont fun(display: ptr_c<xlib_display_c>, name: string): ptr_c<xlib_font_struct_c>]]
--[[@field XFreeFont fun(display: ptr_c<xlib_display_c>, font_struct: ptr_c<xlib_font_struct_c>)]]
--[[@field XGetFontProperty fun(font_struct: ptr_c<xlib_font_struct_c>, atom: xlib_atom_c, value_return: ptr_c<integer>): boolean]]
--[[@field XUnloadFont fun(display: ptr_c<xlib_display_c>, font: xlib_font_c)]]
--[[@field XGetWindowProperty fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, property: xlib_atom_c, long_offset: integer, long_length: integer, delete: boolean, req_type: xlib_atom_c, actual_type_return: ptr_c<xlib_atom_c>, actual_format_return: ptr_c<integer>, nitems_return: ptr_c<integer>, bytes_after_return: ptr_c<integer>, prop_return: ptr_c<ptr_c<ffi.cdata*>>)]]
--[[@field XListProperties fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, num_prop_return: ptr_c<integer>): ptr_c<xlib_atom_c>]]
--[[@field XChangeProperty fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, property: xlib_atom_c, type: xlib_atom_c, format: integer, mode: integer, data: ptr_c<ffi.cdata*>, nelements: integer)]]
--[[@field XRotateWindowProperties fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, properties: xlib_atom_c[], num_prop: integer, npositions: integer)]]
--[[@field XDeleteProperty fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, property: xlib_atom_c)]]
--[[@field XCreateOC fun(om: xlib_om_c): xlib_oc_c]]
--[[@field XDestroyOC fun(oc: xlib_oc_c)]]
--[[@field XSetOCValues fun(oc: xlib_oc_c, ...): ptr_c<ffi.cdata*>]]
--[[@field XGetOCValues fun(oc: xlib_oc_c, ...): ptr_c<ffi.cdata*>]]
--[[@field XOMOfOC fun(oc: xlib_oc_c): xlib_om_c]]
--[[@field XStringListToTextProperty fun(list: string[], count: integer, text_prop_return: ptr_c<xlib_text_property_c>): xlib_status_c]]
--[[@field XTextPropertyToStringList fun(text_prop: ptr_c<xlib_text_property_c>, list_return: ptr_c<string_c[]>, count_return: ptr_c<integer>): xlib_status_c]]
--[[@field XFreeStringList fun(list: string[])]]
--[[@field XCreatePixmap fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, width: integer, height: integer, depth: integer): xlib_pixmap_c]]
--[[@field XFreePixmap fun(display: ptr_c<xlib_display_c>, pixmap: xlib_pixmap_c)]]
--[[@field XReadBitmapFile fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, filename: string, width_return: ptr_c<integer>, height_return: ptr_c<integer>, bitmap_return: ptr_c<xlib_pixmap_c>, x_hot_return: ptr_c<integer>, y_hot_return: ptr_c<integer>): xlib_bitmap_status]]
--[[@field XReadBitmapFileData fun(filename: string, width_return: ptr_c<integer>, height_return: ptr_c<integer>, data_return: ffi.cdata*, x_hot_return: ptr_c<integer>, y_hot_return: ptr_c<integer>): integer]]
--[[@field XWriteBitmapFile fun(display: ptr_c<xlib_display_c>, filename: string, bitmap: xlib_pixmap_c, width: integer, height: integer, x_hot: integer, y_hot: integer): xlib_bitmap_status]]
--[[@field XCreatePixmapFromBitmapData fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, data: ffi.cdata*, width: integer, height: integer, fg: integer, bg: integer, depth: integer): xlib_pixmap_c]]
--[[@field XCreateBitmapFromData fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, data: ffi.cdata*, width: integer, height: integer): xlib_pixmap_c]]
--[[@field XCopyArea fun(display: ptr_c<xlib_display_c>, src: xlib_drawable_c, dest: xlib_drawable_c, gc: xlib_gc_c, src_x: integer, src_y: integer, width: integer, height: integer, dest_x: integer, dest_y: integer)]]
--[[@field XCopyPlane fun(display: ptr_c<xlib_display_c>, src: xlib_drawable_c, dest: xlib_drawable_c, gc: xlib_gc_c, src_x: integer, src_y: integer, width: integer, height: integer, dest_x: integer, dest_y: integer, plane: integer)]]
--[[@field XTextWidth fun(font_struct: ptr_c<xlib_font_struct_c>, string: string, count: integer)]]
--[[@field XTextWidth16 fun(font_struct: ptr_c<xlib_font_struct_c>, string: string, count: integer)]]
--[[@field XAllocColor fun(display: ptr_c<xlib_display_c>, colormap: xlib_colormap_c, screen_in_out: ptr_c<xlib_color_c>): xlib_status_c]]
--[[@field XAllocNamedColor fun(display: ptr_c<xlib_display_c>, colormap: xlib_colormap_c, color_name: string, screen_def_return: ptr_c<xlib_color_c>, exact_def_return: ptr_c<xlib_color_c>): xlib_status_c]]
--[[@field XAllocColorCells fun(display: ptr_c<xlib_display_c>, colormap: xlib_colormap_c, contig: boolean, plane_masks_return: integer[], nplanes: integer, pixels_return: integer[], npixels: integer): xlib_status_c]]
--[[@field XAllocColorPlanes fun(display: ptr_c<xlib_display_c>, colormap: xlib_colormap_c, contig: boolean, pixels_return: integer[], ncolors: integer, nreds: integer, ngreens: integer, nblues: integer, rmask_return: ptr_c<integer>, gmask_return: ptr_c<integer>, bmask_return: ptr_c<integer>): xlib_status_c]]
--[[@field XFreeColors fun(display: ptr_c<xlib_display_c>, colormap: xlib_colormap_c, pixels: integer[], npixels: integer, planes: integer)]]
--[[@field XCreateGC fun(display: ptr_c<xlib_display_c>, d: xlib_drawable_c, valuemask: integer, values: ptr_c<xlib_gc_values_c>?): xlib_gc_c]]
--[[@field XCopyGC fun(display: ptr_c<xlib_display_c>, src: xlib_gc_c, valuemask: integer, dest: xlib_gc_c)]]
--[[@field XChangeGC fun(display: ptr_c<xlib_display_c>, gc: xlib_gc_c, valuemask: integer, values: ptr_c<xlib_gc_values_c>)]]
--[[@field XGetGCValues fun(display: ptr_c<xlib_display_c>, gc: xlib_gc_c, valuemask: integer, values_return: ptr_c<xlib_gc_values_c>): xlib_status_c]]
--[[@field XFreeGC fun(display: ptr_c<xlib_display_c>, gc: xlib_gc_c)]]
--[[@field XGContextFromGC fun(gc: xlib_gc_c): xlib_gcontext_c]]
--[[@field XAllocSizeHints fun(): ptr_c<xlib_size_hints_c>]]
--[[@field XSetWMNormalHints fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, hints: ptr_c<xlib_size_hints_c>)]]
--[[@field XGetWMNormalHints fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, hints_return: ptr_c<xlib_size_hints_c>, supplied_return: ptr_c<integer>): xlib_status_c]]
--[[@field XSetWMSizeHints fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, hints: ptr_c<xlib_size_hints_c>, property: xlib_atom_c)]]
--[[@field XGetWMSizeHints fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, hints_return: ptr_c<xlib_size_hints_c>, supplied_return: ptr_c<integer>, property: xlib_atom_c): xlib_status_c]]
--[[@field XAllocClassHint fun(): ptr_c<xlib_class_hint_c>]]
--[[@field XSetClassHint fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, class_hints: ptr_c<xlib_class_hint_c>)]]
--[[@field XGetClassHint fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, class_hints_return: ptr_c<xlib_class_hint_c>): xlib_status_c]]
--[[@field XSetWMName fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, text_prop: ptr_c<xlib_text_property_c>)]]
--[[@field XGetWMName fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, text_prop_return: ptr_c<xlib_text_property_c>): xlib_status_c]]
--[[@field XStoreName fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, window_name: ptr_c<ffi.cdata*>)]]
--[[@field XFetchName fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, window_name_return: ptr_c<ptr_c<ffi.cdata*>>): xlib_status_c]]
--[[@field XSetWMClientMachine fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, text_prop: ptr_c<xlib_text_property_c>)]]
--[[@field XGetWMClientMachine fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, text_prop_return: ptr_c<xlib_text_property_c>): xlib_status_c]]
--[[@field XmbTextExtents fun(font_set: xlib_font_set_c, string: string, num_bytes: integer, overall_ink_return: ptr_c<xlib_rectangle_c>, overall_logical_return: ptr_c<xlib_rectangle_c>)]]
--[[@field XwcTextExtents fun(font_set: xlib_font_set_c, string: ptr_c<integer>, num_wchars: integer, overall_ink_return: ptr_c<xlib_rectangle_c>, overall_logical_return: ptr_c<xlib_rectangle_c>)]]
--[[@field Xutf8TextExtents fun(font_set: xlib_font_set_c, string: string, num_bytes: integer, overall_ink_return: ptr_c<xlib_rectangle_c>, overall_logical_return: ptr_c<xlib_rectangle_c>)]]
--[[@field XConfigureWindow fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, value_mask: integer, changes: ptr_c<xlib_window_changes_c>)]]
--[[@field XMoveWindow fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, x: integer, y): integer]]
--[[@field XResizeWindow fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, width: integer, height: integer)]]
--[[@field XMoveResizeWindow fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, x: integer, y: integer, width: integer, height: integer)]]
--[[@field XSetWindowBorderWidth fun(display: ptr_c<xlib_display_c>, w: xlib_window_c, width: integer)]]
--[[@field XSetInputFocus fun(display: ptr_c<xlib_display_c>, focus: xlib_window_c, revert_to: xlib_revert_to, time: xlib_time_c)]]
--[[@field XGetInputFocus fun(display: ptr_c<xlib_display_c>, focus_return: ptr_c<xlib_window_c>, revert_to_return: ptr_c<xlib_revert_to>)]]
--[[@field XGrabButton fun(display: ptr_c<xlib_display_c>, button: xlib_button, modifiers: xlib_key_button_mask, grab_window: xlib_window_c, owner_events: boolean, event_mask: xlib_input_event_mask, pointer_mode: xlib_grab_mode, keyboard_mode: xlib_grab_mode, confine_to: xlib_window_c, cursor: xlib_cursor_c)]]
--[[@field XUngrabButton fun(display: ptr_c<xlib_display_c>, button: xlib_button, modifiers: xlib_key_button_mask, grab_window: xlib_window_c)]]
--[[@field XGrabKey fun(display: ptr_c<xlib_display_c>, keycode: xlib_key_code_c, modifiers: xlib_key_button_mask, grab_window: xlib_window_c, owner_events: boolean, pointer_mode: xlib_grab_mode, keyboard_mode: xlib_grab_mode)]]
--[[@field XUngrabKey fun(display: ptr_c<xlib_display_c>, keycode: xlib_key_code_c, modifiers: xlib_key_button_mask, grab_window: xlib_window_c)]]
--[[@field XGrabPointer fun(display: ptr_c<xlib_display_c>, grab_window: xlib_window_c, owner_events: boolean, event_mask: xlib_input_event_mask, pointer_mode: xlib_grab_mode, keyboard_mode: xlib_grab_mode, confine_to: xlib_window_c, cursor: xlib_cursor_c, time: xlib_time_c)]]
--[[@field XUngrabPointer fun(display: ptr_c<xlib_display_c>, time: xlib_time_c)]]
--[[@field XChangeActivePointerGrab fun(display: ptr_c<xlib_display_c>, event_mask: xlib_input_event_mask, cursor: xlib_cursor_c, time: xlib_time_c)]]
--[[@field XStringToKeysym fun(string: string): xlib_key_sym_c]]
--[[@field XKeysymToString fun(keysym: xlib_key_sym_c): ptr_c<ffi.cdata*>]]
--[[@field XKeycodeToKeysym fun(display: ptr_c<xlib_display_c>, keycode: xlib_key_code_c, index: integer): xlib_key_sym_c]]
--[[@field XKeysymToKeycode fun(display: ptr_c<xlib_display_c>, keysym: xlib_key_sym_c): xlib_key_code_c]]
--[[@field XConvertCase fun(keysym: xlib_key_sym_c, lower_return: ptr_c<xlib_key_sym_c>, upper_return: ptr_c<xlib_key_sym_c>)]]
--[[@field XWarpPointer fun(display: ptr_c<xlib_display_c>, src_w: xlib_window_c, dest_w: xlib_window_c, src_x: integer, src_y: integer, src_width: integer, src_height: integer, dest_x: integer, dest_y: integer)]]
--[[@field XLookupKeysym fun(key_event: ptr_c<xlib_key_event_c>, index: integer): xlib_key_sym_c]]
--[[@field XRefreshKeyboardMapping fun(event_map: ptr_c<xlib_mapping_event_c>)]]
--[[@field XLookupString fun(event_struct: ptr_c<xlib_key_event_c>, buffer_return: ptr_c<ffi.cdata*>, bytes_buffer: integer, keysym_return: ptr_c<xlib_key_sym_c>, status_in_out?: ptr_c<xlib_compose_status_c>)]]
--[[@field XRebindKeysym fun(display: ptr_c<xlib_display_c>, keysym: xlib_key_sym_c, list: xlib_key_sym_c[], mod_count: integer, string: string, num_bytes: integer)]]
--[[@field XFilterEvent fun(event: ptr_c<xlib_event_c>, w: xlib_window_c): boolean]]
--[[@field XmbLookupString fun(ic: xlib_ic_c, event: ptr_c<xlib_key_pressed_event_c>, buffer_return: ptr_c<ffi.cdata*>, bytes_buffer: integer, keysym_return: ptr_c<xlib_key_sym_c>, status_return: ptr_c<xlib_status_c>)]]
--[[@field XwcLookupString fun(ic: xlib_ic_c, event: ptr_c<xlib_key_pressed_event_c>, buffer_return: ptr_c<ffi.cdata*>, wchars_buffer: integer, keysym_return: ptr_c<xlib_key_sym_c>, status_return: ptr_c<xlib_status_c>)]]
--[[@field Xutf8LookupString fun(ic: xlib_ic_c, event: ptr_c<xlib_key_pressed_event_c>, buffer_return: ptr_c<ffi.cdata*>, bytes_buffer: integer, keysym_return: ptr_c<xlib_key_sym_c>, status_return: ptr_c<xlib_status_c>)]]
--[[@field XOpenIM fun(display: ptr_c<xlib_display_c>, db: xlib_rm_database_c, res_name: ptr_c<ffi.cdata*>, res_class: ptr_c<ffi.cdata*>): xlib_im_c]]
--[[@field XCloseIM fun(im: xlib_im_c): xlib_status_c]]
--[[@field XSetIMValues fun(im: xlib_im_c, ...): ptr_c<ffi.cdata*>]]
--[[@field XGetIMValues fun(im: xlib_im_c, ...): ptr_c<ffi.cdata*>]]
--[[@field XDisplayOfIM fun(im: xlib_im_c): ptr_c<xlib_display_c>]]
--[[@field XLocaleOfIM fun(im: xlib_im_c): ptr_c<ffi.cdata*>]]
--[[@field XRegisterIMInstantiateCallback fun(display: ptr_c<xlib_display_c>, db: xlib_rm_database_c, res_name: ptr_c<ffi.cdata*>, res_class: ptr_c<ffi.cdata*>, callback: xlib_id_proc_c, client_data: xlib_pointer_c?): boolean]]
--[[@field XUnregisterIMInstantiateCallback fun(display: ptr_c<xlib_display_c>, db: xlib_rm_database_c, res_name: ptr_c<ffi.cdata*>, res_class: ptr_c<ffi.cdata*>, callback: xlib_id_proc_c, client_data: xlib_pointer_c?): boolean]]
--[[@field XCreateIC fun(im: xlib_im_c, ...): xlib_ic_c]]
--[[@field XDestroyIC fun(ic: xlib_ic_c)]]
--[[@field XIMOfIC fun(ic: xlib_ic_c): xlib_im_c]]
--[[@field XSetICFocus fun(ic: xlib_ic_c)]]
--[[@field XUnsetICFocus fun(ic: xlib_ic_c)]]
--[[@field XSetICValues fun(ic: xlib_ic_c, ...): ptr_c<ffi.cdata*>]]
--[[@field XGetICValues fun(ic: xlib_ic_c, ...): ptr_c<ffi.cdata*>]]
--[[@field XmbResetIC fun(ic: xlib_ic_c): ptr_c<ffi.cdata*>]]
--[[@field XwcResetIC fun(ic: xlib_ic_c): ptr_c<ffi.cdata*>]]
--[[@field Xutf8ResetIC fun(ic: xlib_ic_c): ptr_c<ffi.cdata*>]]

--[[@class xlib_tst_ffi]]
--[[@field XRecordQueryVersion fun(display: ptr_c<xlib_display_c>, cmajor_return: ptr_c<integer>, cminor_return: ptr_c<integer>): xlib_status_c]]
--[[@field XRecordCreateContext fun(display: ptr_c<xlib_display_c>, datum_flags: xlib_record_datum_flag, clients: ptr_c<xlib_record_client_spec_c>, nclients: integer, ranges: ptr_c<xlib_record_range_c>, nranges: integer): xlib_record_context_c]]
--[[@field XRecordAllocRange fun(): ptr_c<xlib_record_range_c>]]
--[[@field XRecordRegisterClients fun(display: ptr_c<xlib_display_c>, context: xlib_record_context_c, datum_flags: xlib_record_datum_flag, clients: ptr_c<xlib_record_client_spec_c>, nclients: integer, ranges: ptr_c<xlib_record_range_c>, nranges: integer): xlib_status_c]]
--[[@field XRecordUnRegisterClients fun(display: ptr_c<xlib_display_c>, context: xlib_record_context_c, clients: ptr_c<xlib_record_client_spec_c>, nclients: integer): xlib_status_c]]
--[[@field XRecordGetContext fun(display: ptr_c<xlib_display_c>, context: xlib_record_context_c, state_return: ptr_c<ptr_c<xlib_record_state_c>>): xlib_status_c]]
--[[@field XRecordFreeState fun(state: ptr_c<xlib_record_state_c>)]]
--[[@field XRecordEnableContext fun(display: ptr_c<xlib_display_c>, context: xlib_record_context_c, callback: xlib_record_intercept_proc_c, closure: xlib_pointer_c): xlib_status_c]]
--[[@field XRecordEnableContextAsync fun(display: ptr_c<xlib_display_c>, context: xlib_record_context_c, callback: xlib_record_intercept_proc_c, closure: xlib_pointer_c): xlib_status_c]]
--[[@field XRecordProcessReplies fun(display: ptr_c<xlib_display_c>)]]
--[[@field XRecordFreeData fun(data: ptr_c<xlib_record_intercept_data_c>)]]
--[[@field XRecordDisableContext fun(display: ptr_c<xlib_display_c>, context: xlib_record_context_c): xlib_status_c]]
--[[@field XRecordIdBaseMask fun(display: ptr_c<xlib_display_c>): xlib_id_c]]
--[[@field XRecordFreeContext fun(display: ptr_c<xlib_display_c>, context: xlib_record_context_c): xlib_status_c]]

--[=[
.replace(/^\t(.+?) *\b(\w+)\((.+)\);$/gm, (_, r, n, a) => {
		ct=(t,n)=>({"const char *":"string_c","unsigned char *":"ffi.cdata*","char *":"ffi.cdata*",Bool:"boolean",int:"integer",long:"integer","unsigned int":"integer","unsigned long":"integer"}[t])??(
				n.endsWith("_return")&&t.endsWith("*")?`ptr_c<${ct(t.replace(/ *\*$/,""),n.replace(/_return$/,""))}>`:
				n.endsWith("_list")&&t.endsWith("*")?`${ct(t.replace(/ *\*$/,""),n.replace(/_list$/,""))}[]`:
				t.endsWith("*")?`ptr_c<${ct(t.replace(/ *\*$/,""),n)}>`:
				/^Xft/.test(t)?"xft"+t.slice(3).replace(/[A-Z]/g,m=>"_"+m.toLowerCase())+"_c":
				/^[A-Z]+$/.test(t)?"xlib_"+t.slice(t[0]==="X").toLowerCase()+"_c":
				/^[A-Z]/.test(t)?"xlib"+t.slice(t[0]==="X").replace(/[A-Z]/g,m=>"_"+m.toLowerCase())+"_c":
				t);
		return `--[[@field ${n} fun(${a.split(", ").map(a => a.replace(/^(.+?) *(\w+)$/g, (_, t, n) => `${n}: ${ct(t,n)}`)).join(", ")})${/^(int|void)$/.test(r) ? "" : (": " + ct(r,n))}]]`
}).replace(/(\]+)\]\]/, "$1 ]]"))
]=]

--[[@diagnostic disable-next-line: assign-type-mismatch]]
local void_p_c = ffi.typeof("void *[1]") --[[@type fun(value?: ffi.cdata*): ptr_c<ffi.cdata*> ]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local string_p_c = ffi.typeof("const char *[1]") --[[@type fun(value?: string): ptr_c<string_c> ]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local string_a_c = ffi.typeof("const char *[?]") --[[@type fun(length: integer): string_c[] ]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local string_pa_c = ffi.typeof("const char **[1]") --[[@type fun(value?: string[]): ptr_c<string_c[]> ]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local int_p_c = ffi.typeof("int[1]") --[[@type fun(value?: integer): ptr_c<integer>]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local int_a_c = ffi.typeof("int[?]") --[[@type fun(length: integer, value?: integer[]): integer[] ]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local uint_p_c = ffi.typeof("unsigned int[1]") --[[@type fun(value?: integer): ptr_c<integer>]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local ulong_p_c = ffi.typeof("unsigned long[1]") --[[@type fun(value?: integer): ptr_c<integer>]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local ulong_a_c = ffi.typeof("unsigned long[?]") --[[@type fun(length: integer, value?: integer[]): integer[] ]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local window_pa_c = ffi.typeof("Window *[1]") --[[@type fun(): ptr_c<xlib_window_c[]>]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local atom_p_c = ffi.typeof("Atom [1]") --[[@type fun(value?: xlib_atom_c): ptr_c<xlib_atom_c>]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local atom_pa_c = ffi.typeof("Atom *[1]") --[[@type fun(): ptr_c<xlib_atom_c[]>]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local font_struct_pap_c = ffi.typeof("XFontStruct **[1]") --[[@type fun(): ptr_c<ptr_c<xlib_font_struct_c>[]>]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local text_property_p_c = ffi.typeof("XTextProperty[1]") --[[@type fun(value?: xlib_text_property_c): ptr_c<xlib_text_property_c>]]
--[[@diagnostic disable-next-line: assign-type-mismatch]]
local color_p_c = ffi.typeof("XColor[1]") --[[@type fun(value?: {[1]:xlib_color_c}): ptr_c<xlib_color_c>]]

--[[@param data ptr_c<unknown>)]]
mod.free = function (data) xlib_ffi.XFree(data) end

--[[@param handler fun(display: xlib_display_c, error: xlib_error_event_c)]]
mod.set_error_handler = function (handler) xlib_ffi.XSetErrorHandler(handler) end

--[[@param name? string]]
mod.open_display = function (name)
	local display = xlib_ffi.XOpenDisplay(name)
	return display ~= nil and display or nil
end

--[[@class xlib_display]]
local display = {}
display.__index = display
mod.display = display

--[[@param name? string]]
display.new = function (self, name)
	local display_c = mod.open_display(name)
	if not display_c then return nil end
	local display = { --[[@class xlib_display]]
		c = display_c
	}
	return setmetatable(display, self)
end

--[[@param display_ ptr_c<xlib_display_c>]]
mod.close_display = function (display_) xlib_ffi.XCloseDisplay(display_) end
display.close_display = function (self) mod.close_display(self.c) end

display.__gc = display.close_display

--[[@param display_ ptr_c<xlib_display_c>]]
mod.flush = function (display_) xlib_ffi.XFlush(display_) end
display.flush = function (self) return mod.flush(self.c) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param discard boolean]]
mod.sync = function (display_, discard) xlib_ffi.XSync(display_, discard) end
--[[@param discard boolean]]
display.sync = function (self, discard) return mod.sync(self.c, discard) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param mode xlib_events_queued_mode]]
mod.events_queued = function (display_, mode) return xlib_ffi.XEventsQueued(display_, mode) end
--[[@param mode xlib_events_queued_mode]]
display.events_queued = function (self, mode) return mod.events_queued(self.c, mode) end

--[[@param display_ ptr_c<xlib_display_c>]]
mod.pending = function (display_) return xlib_ffi.XPending(display_) end
display.pending = function (self) return mod.pending(self.c) end

--[[@param display_ ptr_c<xlib_display_c>]]
mod.grab_server = function (display_) xlib_ffi.XGrabServer(display_) end
display.grab_server = function (self) return mod.grab_server(self.c) end

--[[@param display_ ptr_c<xlib_display_c>]]
mod.ungrab_server = function (display_) xlib_ffi.XUngrabServer(display_) end
display.ungrab_server = function (self) return mod.ungrab_server(self.c) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param window? xlib_window_c]]
mod.query_tree = function (display_, window)
	window = window or display_[0].screens[display_[0].default_screen].root
	local root = ffi.new("Window[1]") --[[@type ptr_c<xlib_window_c>]]
	local parent = ffi.new("Window[1]") --[[@type ptr_c<xlib_window_c>]]
	local children = window_pa_c()
	local nchildren = uint_p_c()
	if xlib_ffi.XQueryTree(display_, window, root, parent, children, nchildren) == 0 then return nil end
	return { root = root[0], parent = parent[0], children = children[0], nchildren = nchildren[0] }
end
--[[@param window? xlib_window_c]]
display.query_tree = function (self, window) return mod.query_tree(self.c, window) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param window? xlib_window_c]] --[[@param event_mask xlib_input_event_mask]]
mod.select_input = function (display_, window, event_mask)
	window = window or display_[0].screens[display_[0].default_screen].root
	xlib_ffi.XSelectInput(display_, window, event_mask)
end
--[[@param window? xlib_window_c]] --[[@param event_mask xlib_input_event_mask]]
display.select_input = function (self, window, event_mask) return mod.select_input(self.c, window, event_mask) end

local error_text = ffi.new("char[1024]")

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param code integer]]
mod.get_error_text = function (display_, code)
	xlib_ffi.XGetErrorText(display_, code, error_text, 1024)
	return ffi.string(error_text)
end
--[[@param code integer]] --[[@param buffer_return string_c]] --[[@param length integer]]
display.get_error_text = function (self, code, buffer_return, length) return mod.get_error_text(self.c, code) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param parent xlib_window_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param border_width integer]] --[[@param depth integer]] --[[@param class integer]] --[[@param visual ptr_c<xlib_visual_c>]] --[[@param valuemask integer]] --[[@param attributes ptr_c<xlib_set_window_attributes_c>]]
mod.create_window = function (display_, parent, x, y, width, height, border_width, depth, class, visual, valuemask, attributes)
	return xlib_ffi.XCreateWindow(display_, parent, x, y, width, height, border_width, depth, class, visual, valuemask, attributes)
end
--[[@param parent xlib_window_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param border_width integer]] --[[@param depth integer]] --[[@param class integer]] --[[@param visual ptr_c<xlib_visual_c>]] --[[@param valuemask integer]] --[[@param attributes ptr_c<xlib_set_window_attributes_c>]]
display.create_window = function (self, parent, x, y, width, height, border_width, depth, class, visual, valuemask, attributes)
	return mod.create_window(self.c, parent, x, y, width, height, border_width, depth, class, visual, valuemask, attributes)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param parent xlib_window_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param border_width integer]] --[[@param border integer]] --[[@param background integer]]
mod.create_simple_window = function (display_, parent, x, y, width, height, border_width, border, background)
	return xlib_ffi.XCreateSimpleWindow(display_, parent, x, y, width, height, border_width, border, background)
end
--[[@param parent xlib_window_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param border_width integer]] --[[@param border integer]] --[[@param background integer]]
display.create_simple_window = function (self, parent, x, y, width, height, border_width, border, background)
	return mod.create_simple_window(self.c, parent, x, y, width, height, border_width, border, background)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.get_window_attributes = function (display_, w)
	local attrs = ffi.new("XWindowAttributes[1]") --[[@type ptr_c<xlib_window_attributes_c>]]
	xlib_ffi.XGetWindowAttributes(display_, w, attrs)
	return attrs[0]
end
--[[@param w xlib_window_c]]
display.get_window_attributes = function (self, w) return mod.get_window_attributes(self.c, w) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]]
mod.get_geometry = function (display_, d)
	local root = ffi.new("Window[1]") --[[@type ptr_c<xlib_window_c>]]
	local x = int_p_c()
	local y = int_p_c()
	local width = uint_p_c()
	local height = uint_p_c()
	local border_width = uint_p_c()
	local depth = uint_p_c()
	if xlib_ffi.XGetGeometry(display_, d, root, x, y, width, height, border_width, depth) == 0 then return nil end
	return { root = root[0], x = x[0], y = y[0], width = width[0], height = height[0], border_width = border_width[0], depth = depth[0] }
end
--[[@param d xlib_drawable_c]]
display.get_geometry = function (self, d) return mod.get_geometry(self.c, d) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param change_mode xlib_change_save_set_mode]]
mod.change_save_set = function (display_, w, change_mode) xlib_ffi.XChangeSaveSet(display_, w, change_mode) end
--[[@param w xlib_window_c]] --[[@param change_mode xlib_change_save_set_mode]]
display.change_save_set = function (self, w, change_mode) return mod.change_save_set_mode(self.c, w, change_mode) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.add_to_save_set = function (display_, w) xlib_ffi.XAddToSaveSet(display_, w) end
--[[@param w xlib_window_c]]
display.add_to_save_set = function (self, w) return mod.add_to_save_set(self.c, w) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.remove_from_save_set = function (display_, w) xlib_ffi.XRemoveFromSaveSet(display_, w) end
--[[@param w xlib_window_c]]
display.remove_from_save_set = function (self, w) return mod.remove_from_save_set(self.c, w) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param protocols xlib_atom_c[] ]]
mod.set_wm_protocols = function (display_, w, protocols)
	return xlib_ffi.XSetWMProtocols(display_, w, protocols, #protocols) ~= 0 and true or nil
end
--[[@param w xlib_window_c]] --[[@param protocols xlib_atom_c[] ]]
display.set_wm_protocols = function (self, w, protocols) return mod.set_wm_protocols(self.c, w, protocols) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.get_wm_protocols = function (display_, w)
	local protocols = atom_pa_c()
	local count = int_p_c()
	if xlib_ffi.XGetWMProtocols(display_, w, protocols, count) == 0 then return nil end
	return { protocols = protocols[0], count = count[0] }
end
--[[@param w xlib_window_c]]
display.get_wm_protocols = function (self, w) return mod.get_wm_protocols(self.c, w) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.map_window = function (display_, w) xlib_ffi.XMapWindow(display_, w) end
--[[@param w xlib_window_c]]
display.map_window = function (self, w) return mod.map_window(self.c, w) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.map_raised = function (display_, w) xlib_ffi.XMapRaised(display_, w) end
--[[@param w xlib_window_c]]
display.map_raised = function (self, w) return mod.map_raised(self.c, w) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.map_subwindows = function (display_, w) xlib_ffi.XMapSubwindows(display_, w) end
--[[@param w xlib_window_c]]
display.map_subwindows = function (self, w) return mod.map_subwindows(self.c, w) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.unmap_window = function (display_, w) xlib_ffi.XUnmapWindow(display_, w) end
--[[@param w xlib_window_c]]
display.unmap_window = function (self, w) return mod.unmap_window(self.c, w) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.unmap_subwindows = function (display_, w) xlib_ffi.XUnmapSubwindows(display_, w) end
--[[@param w xlib_window_c]]
display.unmap_subwindows = function (self, w) return mod.unmap_subwindows(self.c, w) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.destroy_window = function (display_, w) xlib_ffi.XDestroyWindow(display_, w) end
--[[@param w xlib_window_c]]
display.destroy_window = function (self, w) return mod.destroy_window(self.c, w) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.destroy_subwindows = function (display_, w) xlib_ffi.XDestroySubwindows(display_, w) end
--[[@param w xlib_window_c]]
display.destroy_subwindows = function (self, w) return mod.destroy_subwindows(self.c, w) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param close_mode xlib_set_close_down_mode]]
mod.set_close_down_mode = function (display_, close_mode) xlib_ffi.XSetCloseDownMode(display_, close_mode) end
--[[@param close_mode xlib_set_close_down_mode]]
display.set_close_down_mode = function (self, close_mode) return mod.set_close_down_mode(self.c, close_mode) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param resource xlib_id_c]]
mod.kill_client = function (display_, resource) xlib_ffi.XKillClient(display_, resource) end
--[[@param resource xlib_id_c]]
display.kill_client = function (self, resource) return mod.kill_client(self.c, resource) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param parent xlib_window_c]] --[[@param x? integer]] --[[@param y? integer]]
mod.reparent_window = function (display_, w, parent, x, y)
	xlib_ffi.XReparentWindow(display_, w, parent, x or 0, y or 0)
end
--[[@param w xlib_window_c]] --[[@param parent xlib_window_c]] --[[@param x? integer]] --[[@param y? integer]]
display.reparent_window = function (self, w, parent, x, y) return mod.reparent_window(self.c, w, parent, x, y) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param propagate boolean]] --[[@param event_mask xlib_input_event_mask]] --[[@param event_send ptr_c<xlib_event_c>]]
mod.send_event = function (display_, w, propagate, event_mask, event_send)
	return xlib_ffi.XSendEvent(display_, w, propagate, event_mask, event_send) and true or nil
end
--[[@param w xlib_window_c]] --[[@param propagate boolean]] --[[@param event_mask xlib_input_event_mask]] --[[@param event_send ptr_c<xlib_event_c>]]
display.send_event = function (self, w, propagate, event_mask, event_send)
	return mod.send_event(self.c, w, propagate, event_mask, event_send)
end

--[[@param display_ ptr_c<xlib_display_c>]]
mod.display_motion_buffer_size = function (display_) xlib_ffi.XDisplayMotionBufferSize(display_) end
display.display_motion_buffer_size = function (self) mod.display_motion_buffer_size(self.c) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param start xlib_time_c]] --[[@param stop xlib_time_c]]
mod.get_motion_events = function (display_, w, start, stop)
	local nevents = int_p_c()
	local events = xlib_ffi.XGetMotionEvents(display_, w, start, stop, nevents)
	return { events = events, nevents = nevents[0] }
end
--[[@param w xlib_window_c]] --[[@param start xlib_time_c]] --[[@param stop xlib_time_c]]
display.get_motion_events = function (self, w, start, stop) return mod.get_motion_events(self.c, w, start, stop) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param exposures boolean]]
mod.clear_area = function (display_, w, x, y, width, height, exposures)
	xlib_ffi.XClearArea(display_, w, x, y, width, height, exposures)
end
--[[@param w xlib_window_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param exposures boolean]]
display.clear_area = function (self, w, x, y, width, height, exposures)
	return mod.clear_area(self.c, w, x, y, width, height, exposures)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.clear_window = function (display_, w) xlib_ffi.XClearWindow(display_, w) end
--[[@param w xlib_window_c]]
display.clear_window = function (self, w) return mod.clear_window(self.c, w) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param gc xlib_gc_c]] --[[@param foreground integer]] --[[@param background integer]] --[[@param function_ xlib_graphics_function]] --[[@param plane_mask integer]]
mod.set_state = function (display_, gc, foreground, background, function_, plane_mask)
	xlib_ffi.XSetState(display_, gc, foreground, background, function_, plane_mask)
end
--[[@param gc xlib_gc_c]] --[[@param foreground integer]] --[[@param background integer]] --[[@param function_ xlib_graphics_function]] --[[@param plane_mask integer]]
display.set_state = function (self, gc, foreground, background, function_, plane_mask)
	return mod.set_state(self.c, gc, foreground, background, function_, plane_mask)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param gc xlib_gc_c]] --[[@param function_ xlib_graphics_function]]
mod.set_function = function (display_, gc, function_) xlib_ffi.XSetFunction(display_, gc, function_) end
--[[@param gc xlib_gc_c]] --[[@param function_ xlib_graphics_function]]
display.set_function = function (self, gc, function_) return mod.set_function(self.c, gc, function_) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param gc xlib_gc_c]] --[[@param plane_mask integer]]
mod.set_plane_mask = function (display_, gc, plane_mask) xlib_ffi.XSetPlaneMask(display_, gc, plane_mask) end
--[[@param gc xlib_gc_c]] --[[@param plane_mask integer]]
display.set_plane_mask = function (self, gc, plane_mask) return mod.set_plane_mask(self.c, gc, plane_mask) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param gc xlib_gc_c]] --[[@param foreground integer]]
mod.set_foreground = function (display_, gc, foreground) xlib_ffi.XSetForeground(display_, gc, foreground) end
--[[@param gc xlib_gc_c]] --[[@param foreground integer]]
display.set_foreground = function (self, gc, foreground) return mod.set_foreground(self.c, gc, foreground) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param gc xlib_gc_c]] --[[@param background integer]]
mod.set_background = function (display_, gc, background) xlib_ffi.XSetBackground(display_, gc, background) end
--[[@param gc xlib_gc_c]] --[[@param background integer]]
display.set_background = function (self, gc, background) return mod.set_background(self.c, gc, background) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param x integer]] --[[@param y integer]] --[[@param string string]]
mod.draw_string = function (display_, d, gc, x, y, string)
	xlib_ffi.XDrawString(display_, d, gc, x, y, string, #string)
end
--[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param x integer]] --[[@param y integer]] --[[@param string string]]
display.draw_string = function (self, d, gc, x, y, string) return mod.draw_string(self.c, d, gc, x, y, string) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param x integer]] --[[@param y integer]] --[[@param string string]]
mod.draw_string_16 = function (display_, d, gc, x, y, string)
	if #string % 2 == 0 then io.stderr:write("xlib: length of wide string isn't a multiple of 2") end
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	xlib_ffi.XDrawString16(display_, d, gc, x, y, string, bit.rshift(#string, 1))
end
--[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param x integer]] --[[@param y integer]] --[[@param string string]]
display.draw_string_16 = function (self, d, gc, x, y, string)
	return mod.draw_string_16(self.c, d, gc, x, y, string)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]]
mod.fill_rectangle = function (display_, d, gc, x, y, width, height)
	xlib_ffi.XFillRectangle(display_, d, gc, x, y, width, height)
end
--[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]]
display.fill_rectangle = function (self, d, gc, x, y, width, height)
	return mod.fill_rectangle(self.c, d, gc, x, y, width, height)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param rectangles xlib_rectangle_c[] ]]
mod.fill_rectangles = function (display_, d, gc, rectangles)
	xlib_ffi.XFillRectangles(display_, d, gc, rectangles, #rectangles)
end
--[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param rectangles xlib_rectangle_c[] ]]
display.fill_rectangles = function (self, d, gc, rectangles) return mod.fill_rectangles(self.c, d, gc, rectangles) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param points xlib_point_c[] ]] --[[@param shape? xlib_polygon_shape]] --[[@param mode? xlib_coordinate_mode]]
mod.fill_polygon = function (display_, d, gc, points, shape, mode)
	xlib_ffi.XFillPolygon(display_, d, gc, points, #points, shape or mod.polygon_shape.complex, mode or mod.coordinate_mode.origin)
end
--[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param points xlib_point_c[] ]] --[[@param shape? xlib_polygon_shape]] --[[@param mode? xlib_coordinate_mode]]
display.fill_polygon = function (self, d, gc, points, shape, mode) return mod.fill_polygon(self.c, d, gc, points, shape, mode) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param angle1 integer]] --[[@param angle2 integer]]
mod.fill_arc = function (display_, d, gc, x, y, width, height, angle1, angle2)
	xlib_ffi.XFillArc(display_, d, gc, x, y, width, height, angle1, angle2)
end
--[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param angle1 integer]] --[[@param angle2 integer]]
display.fill_arc = function (self, d, gc, x, y, width, height, angle1, angle2)
	return mod.fill_arc(self.c, d, gc, x, y, width, height, angle1, angle2)
end

-- LINT: doesn't error when it's XFillRectangles (incorrect array type)
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param arcs xlib_arc_c[] ]]
mod.fill_arcs = function (display_, d, gc, arcs) xlib_ffi.XFillArcs(display_, d, gc, arcs, #arcs) end
--[[@param d xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param arcs xlib_arc_c[] ]]
display.fill_arcs = function (self, d, gc, arcs) return mod.fill_arcs(self.c, d, gc, arcs) end

--[[FIXME: this probably doesn't work if you want to keep the old event around]]
local event = ffi.new("XEvent[1]") --[[@type ptr_c<xlib_event_c>]]

--[[@param display_ ptr_c<xlib_display_c>]]
mod.next_event = function (display_) xlib_ffi.XNextEvent(display_, event); return event[0] end
display.next_event = function (self) return mod.next_event(self.c) end
--[[@param display_ ptr_c<xlib_display_c>]]
mod.peek_event = function (display_) xlib_ffi.XPeekEvent(display_, event); return event[0] end
display.peek_event = function (self) return mod.peek_event(self.c) end

local full_mask = bit.bnot(0)

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param event_mask? xlib_input_event_mask]]
mod.window_event = function (display_, w, event_mask) xlib_ffi.XWindowEvent(display_, w, event_mask or full_mask, event); return event[0] end
--[[@param w xlib_window_c]] --[[@param event_mask? xlib_input_event_mask]]
display.window_event = function (self, w, event_mask) return mod.window_event(self.c, w, event_mask) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param event_mask? xlib_input_event_mask]]
mod.check_window_event = function (display_, w, event_mask)
	return xlib_ffi.XCheckWindowEvent(display_, w, event_mask or full_mask, event), event[0]
end
--[[@param w xlib_window_c]] --[[@param event_mask? xlib_input_event_mask]]
display.check_window_event = function (self, w, event_mask) return mod.check_window_event(self.c, w, event_mask) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param event_mask? xlib_input_event_mask]]
mod.mask_event = function (display_, event_mask) xlib_ffi.XMaskEvent(display_, event_mask or full_mask, event); return event[0] end
--[[@param event_mask? xlib_input_event_mask]]
display.mask_event = function (self, event_mask) return mod.mask_event(self.c, event_mask) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param event_mask xlib_input_event_mask]]
mod.check_mask_event = function (display_, event_mask)
	return xlib_ffi.XCheckMaskEvent(display_, event_mask, event), event[0]
end
--[[@param event_mask xlib_input_event_mask]]
display.check_mask_event = function (self, event_mask) return mod.check_mask_event(self.c, event_mask) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param event_type xlib_event_type]]
mod.check_typed_event = function (display_, event_type)
	return xlib_ffi.XCheckTypedEvent(display_, event_type, event), event[0]
end
--[[@param event_type xlib_event_type]]
display.check_typed_event = function (self, event_type) return mod.check_typed_event(self.c, event_type) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param event_type xlib_event_type]]
mod.check_typed_window_event = function (display_, w, event_type)
	return xlib_ffi.XCheckTypedWindowEvent(display_, w, event_type, event), event[0]
end
--[[@param w xlib_window_c]] --[[@param event_type xlib_event_type]]
display.check_typed_window_event = function (self, w, event_type)
	return mod.check_typed_window_event(self.c, w, event_type)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param atom_name string]] --[[@param only_if_exists? boolean]]
mod.intern_atom = function (display_, atom_name, only_if_exists)
	local atom = xlib_ffi.XInternAtom(display_, atom_name, only_if_exists or false)
	return atom ~= nil and atom or nil
end
--[[@param atom_name string]] --[[@param only_if_exists? boolean]]
display.intern_atom = function (self, atom_name, only_if_exists)
	return mod.intern_atom(self.c, atom_name, only_if_exists)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param names string[] ]] --[[@param only_if_exists? boolean]]
mod.intern_atoms = function (display_, names, only_if_exists)
	local atoms = atom_pa_c()
	local status = xlib_ffi.XInternAtoms(display_, names, #names, only_if_exists or false, atoms)
	return status ~= 0, atoms[0]
end
--[[@param names string[] ]] --[[@param only_if_exists? boolean]]
display.intern_atoms = function (self, names, only_if_exists)
	return mod.intern_atoms(self.c, names, only_if_exists)
end

--[[use `XFree` to free the strings]]
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param atom xlib_atom_c]]
mod.get_atom_name = function (display_, atom)
	local name = xlib_ffi.XGetAtomName(display_, atom)
	return name ~= nil and ffi.string(name) or nil
end
--[[@param atom xlib_atom_c]]
display.get_atom_name = function (self, atom) return mod.get_atom_name(self.c, atom) end

--[[use `XFree` to free the strings]]
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param atoms xlib_atom_c[] ]]
mod.get_atom_names = function (display_, atoms)
	local names = string_a_c(#atoms)
	local status = xlib_ffi.XGetAtomNames(display_, atoms, #atoms, names)
	local ret = {} --[[@type (string?)[] ]]
	for i = 0, #atoms - 1 do ret[i] = names[i] ~= nil and ffi.string(names[i]) or nil end
	return status ~= 0, ret
end
--[[@param atoms xlib_atom_c[] ]]
display.get_atom_names = function (self, atoms) return mod.get_atom_names(self.c, atoms) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param base_font_name_list string[] ]]
mod.create_font_set = function (display_, base_font_name_list)
	local missing_charset_list = string_pa_c()
	local missing_charset_count = int_p_c()
	local def_string = string_p_c()
	local font_set = xlib_ffi.XCreateFontSet(display_, table.concat(base_font_name_list, ","), missing_charset_list, missing_charset_count, def_string)
	if font_set == nil then return nil end
	return { font_set = font_set, missing_charset_list = missing_charset_list[0], missing_charset_count = missing_charset_count[0], def_string = def_string[0] }
end
--[[@param base_font_name_list string[] ]]
display.create_font_set = function (self, base_font_name_list)
	return mod.create_font_set(self.c, base_font_name_list)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param font_set xlib_font_set_c]]
mod.free_font_set = function (display_, font_set) xlib_ffi.XFreeFontSet(display_, font_set) end
--[[@param font_set xlib_font_set_c]]
display.free_font_set = function (self, font_set) return mod.free_font_set(self.c, font_set) end
--[[must be freed using `free_font_set`]]
--[[@param font_set xlib_font_set_c]]
mod.extents_of_font_set = function (font_set) return xlib_ffi.XExtentsOfFontSet(font_set)[0] end

--[[@param font_set xlib_font_set_c]]
mod.fonts_of_font_set = function (font_set)
	local font_struct_list = font_struct_pap_c()
	local font_name_list = string_pa_c()
	local nfonts = xlib_ffi.XFontsOfFontSet(font_set, font_struct_list, font_name_list)
	return { font_structs = font_struct_list, font_names = font_name_list, nfonts = nfonts }
end

--[[@param font_set xlib_font_set_c]]
mod.base_font_name_list_of_font_set = function (font_set)
	local names = ffi.string(xlib_ffi.XBaseFontNameListOfFontSet(font_set)) --[[cstring owned by xlib]]
	local ret = {} --[[@type string[] ]]
	for name in names:gmatch("[^,]+") do ret[#ret+1] = name end
	return ret
end

--[[@param font_set xlib_font_set_c]]
mod.locale_of_font_set = function (font_set) return ffi.string(xlib_ffi.XLocaleOfFontSet(font_set)[0]) end
--[[@param font_set xlib_font_set_c]]
mod.context_dependent_drawing = function (font_set) return xlib_ffi.XContextDependentDrawing(font_set) end
--[[@param font_set xlib_font_set_c]]
mod.contextual_drawing = function (font_set) return xlib_ffi.XContextualDrawing(font_set) end
--[[@param font_set xlib_font_set_c]]
mod.directional_dependent_drawing = function (font_set) return xlib_ffi.XDirectionalDependentDrawing(font_set) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param name string]]
mod.load_font = function (display_, name) return xlib_ffi.XLoadFont(display_, name) end
--[[@param name string]]
display.load_font = function (self, name) return mod.load_font(self.c, name) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param font_id xlib_id_c]]
mod.query_font = function (display_, font_id) return xlib_ffi.XQueryFont(display_, font_id) end
--[[@param font_id xlib_id_c]]
display.query_font = function (self, font_id) return mod.query_font(self.c, font_id) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param name string]]
mod.load_query_font = function (display_, name) return xlib_ffi.XLoadQueryFont(display_, name) end
--[[@param name string]]
display.load_query_font = function (self, name) return mod.load_query_font(self.c, name) end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param font_struct ptr_c<xlib_font_struct_c>]]
mod.free_font = function (display_, font_struct) xlib_ffi.XFreeFont(display_, font_struct) end
--[[@param font_struct ptr_c<xlib_font_struct_c>]]
display.free_font = function (self, font_struct) return mod.free_font(self.c, font_struct) end

--[[@param font_struct ptr_c<xlib_font_struct_c>]] --[[@param atom xlib_atom_c]]
mod.get_font_property = function (font_struct, atom)
	local value = ulong_p_c()
	return xlib_ffi.XGetFontProperty(font_struct, atom, value) and value[0] or nil
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param font xlib_font_c]]
mod.unload_font = function (display_, font) return xlib_ffi.XUnloadFont(display_, font) end
--[[@param font xlib_font_c]]
display.unload_font = function (self, font) return mod.unload_font(self.c, font) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param property xlib_atom_c]] --[[@param long_offset integer]] --[[@param long_length integer]] --[[@param delete boolean]] --[[@param req_type xlib_atom_c]]
mod.get_window_property = function (display_, w, property, long_offset, long_length, delete, req_type)
	local actual_type = atom_p_c()
	local actual_format = int_p_c()
	local nitems = ulong_p_c()
	local bytes_after = ulong_p_c()
	local prop = void_p_c()
	xlib_ffi.XGetWindowProperty(display_, w, property, long_offset, long_length, delete, req_type, actual_type, actual_format, nitems, bytes_after, prop)
	if actual_type[0] == 0 then return nil end
	return {
		actual_type = actual_type[0], actual_format = actual_format[0], nitems = nitems[0],
		bytes_after = bytes_after[0], prop = prop[0],
	}
end
--[[@param w xlib_window_c]] --[[@param property xlib_atom_c]] --[[@param long_offset integer]] --[[@param long_length integer]] --[[@param delete boolean]] --[[@param req_type xlib_atom_c]]
display.get_window_property = function (self, w, property, long_offset, long_length, delete, req_type)
	return mod.get_window_property(self.c, w, property, long_offset, long_length, delete, req_type)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.list_properties = function (display_, w)
	local nprops = int_p_c()
	local props = xlib_ffi.XListProperties(display_, w, nprops)
	return { props = props, nprops = nprops[0] }
end
--[[@param w xlib_window_c]]
display.list_properties = function (self, w)
	return mod.list_properties(self.c, w)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param property xlib_atom_c]] --[[@param type xlib_atom_c]] --[[@param format integer]] --[[@param mode xlib_property_mode]] --[[@param data ptr_c<ffi.cdata*>]] --[[@param nelements integer]]
mod.change_property = function (display_, w, property, type, format, mode, data, nelements)
	xlib_ffi.XChangeProperty(display_, w, property, type, format, mode, data, nelements)
end
--[[@param w xlib_window_c]] --[[@param property xlib_atom_c]] --[[@param type xlib_atom_c]] --[[@param format integer]] --[[@param mode xlib_property_mode]] --[[@param data ptr_c<ffi.cdata*>]] --[[@param nelements integer]]
display.change_property = function (self, w, property, type, format, mode, data, nelements)
	return mod.change_property(self.c, w, property, type, format, mode, data, nelements)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param properties xlib_atom_c[] ]]--[[@param npositions integer]]
mod.rotate_window_properties = function (display_, w, properties, npositions)
	xlib_ffi.XRotateWindowProperties(display_, w, properties, #properties, npositions)
end
--[[@param w xlib_window_c]] --[[@param properties xlib_atom_c[] ]] --[[@param npositions integer]]
display.rotate_window_properties = function (self, w, properties, npositions)
	return mod.rotate_window_properties(self.c, w, properties, npositions)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param property xlib_atom_c]]
mod.delete_property = function (display_, w, property) return xlib_ffi.XDeleteProperty(display_, w, property) end
--[[@param w xlib_window_c]] --[[@param property xlib_atom_c]]
display.delete_property = function (self, w, property) return mod.delete_property(self.c, w, property) end
--[[@param om xlib_om_c]]
mod.create_oc = function (om) return xlib_ffi.XCreateOC(om) end
--[[@param oc xlib_oc_c]]
mod.destroy_oc = function (oc) xlib_ffi.XDestroyOC(oc) end
--[[@param oc xlib_oc_c]] --[[@param ... unknown]]
mod.set_oc_values = function (oc, ...) return xlib_ffi.XSetOCValues(oc, ...) end
--[[@param oc xlib_oc_c]] --[[@param ... unknown]]
mod.get_oc_values = function (oc, ...) return xlib_ffi.XGetOCValues(oc, ...) end
--[[@param oc xlib_oc_c]]
mod.om_of_oc = function (oc) return xlib_ffi.XOMOfOC(oc) end

--[[@param list string[] ]]
mod.string_list_to_text_property = function (list)
	local text_prop = text_property_p_c()
	if xlib_ffi.XStringListToTextProperty(list, #list, text_prop) == 0 then return nil end
	return text_prop[0]
end

--[[@param text_prop ptr_c<xlib_text_property_c>]]
mod.text_property_to_string_list = function (text_prop)
	local list = string_pa_c()
	local count = int_p_c()
	if xlib_ffi.XTextPropertyToStringList(text_prop, list, count) == 0 then return nil end
	return { strings = list, nstrings = count }
end

--[[@param list string[] ]]
mod.free_string_list = function (list) return xlib_ffi.XFreeStringList(list) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param width integer]] --[[@param height integer]] --[[@param depth integer]]
mod.create_pixmap = function (display_, d, width, height, depth)
	return xlib_ffi.XCreatePixmap(display_, d, width, height, depth)
end
--[[@param d xlib_drawable_c]] --[[@param width integer]] --[[@param height integer]] --[[@param depth integer]]
display.create_pixmap = function (self, d, width, height, depth)
	return mod.create_pixmap(self.c, d, width, height, depth)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param pixmap xlib_pixmap_c]]
mod.free_pixmap = function (display_, pixmap) return xlib_ffi.XFreePixmap(display_, pixmap) end
--[[@param pixmap xlib_pixmap_c]]
display.free_pixmap = function (self, pixmap) return mod.free_pixmap(self.c, pixmap) end

--[[must free when done using XFreePixmap]]
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param filename string]]
mod.read_bitmap_file = function (display_, d, filename)
	local width = uint_p_c()
	local height = uint_p_c()
	local bitmap = ffi.new("Pixmap[1]") --[[@type ptr_c<xlib_pixmap_c>]]
	local x_hot = int_p_c()
	local y_hot = int_p_c()
	if xlib_ffi.XReadBitmapFile(display_, d, filename, width, height, bitmap, x_hot, y_hot) ~= 0 then return nil end
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	return { bitmap = bitmap[0], width = width[0], height = height[0], x_hot = x_hot[0], y_hot = y_hot[0] }
end
--[[@param d xlib_drawable_c]] --[[@param filename string]]
display.read_bitmap_file = function (self, d, filename)
	return mod.read_bitmap_file(self.c, d, filename)
end

--[[@param filename string]]
mod.read_bitmap_file_data = function (filename)
	local width = uint_p_c()
	local height = uint_p_c()
	local data = void_p_c()
	local x_hot = int_p_c()
	local y_hot = int_p_c()
	if xlib_ffi.XReadBitmapFileData(filename, width, height, data, x_hot, y_hot) ~= 0 then return nil end
	return { data = ffi.gc(data[0], xlib_ffi.XFree), width = width[0], height = height[0], x_hot = x_hot[0], y_hot = y_hot[0] }
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param filename string]] --[[@param bitmap xlib_pixmap_c]] --[[@param width integer]] --[[@param height integer]] --[[@param x_hot integer]] --[[@param y_hot integer]]
mod.write_bitmap_file = function (display_, filename, bitmap, width, height, x_hot, y_hot)
	xlib_ffi.XWriteBitmapFile(display_, filename, bitmap, width, height, x_hot, y_hot)
end
--[[@param filename string]] --[[@param bitmap xlib_pixmap_c]] --[[@param width integer]] --[[@param height integer]] --[[@param x_hot integer]] --[[@param y_hot integer]]
display.write_bitmap_file = function (self, filename, bitmap, width, height, x_hot, y_hot)
	return mod.write_bitmap_file(self.c, filename, bitmap, width, height, x_hot, y_hot)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param data ffi.cdata*]] --[[@param width integer]] --[[@param height integer]] --[[@param fg integer]] --[[@param bg integer]] --[[@param depth integer]]
mod.create_pixmap_from_bitmap_data = function (display_, d, data, width, height, fg, bg, depth)
	return xlib_ffi.XCreatePixmapFromBitmapData(display_, d, data, width, height, fg, bg, depth)
end
--[[@param d xlib_drawable_c]] --[[@param data ffi.cdata*]] --[[@param width integer]] --[[@param height integer]] --[[@param fg integer]] --[[@param bg integer]] --[[@param depth integer]]
display.create_pixmap_from_bitmap_data = function (self, d, data, width, height, fg, bg, depth)
	return mod.create_pixmap_from_bitmap_data(self.c, d, data, width, height, fg, bg, depth)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param data ptr_c<ffi.cdata*>]] --[[@param width integer]] --[[@param height integer]]
mod.create_bitmap_from_data = function (display_, d, data, width, height)
	local pixmap = xlib_ffi.XCreateBitmapFromData(display_, d, data, width, height)
	if pixmap == 0 then return nil end
	--[[@diagnostic disable-next-line: param-type-mismatch]]
	ffi.gc(pixmap, function (c) xlib_ffi.XFreePixmap(display_, c) end)
	return pixmap -- docs don't say to free this
end
--[[@param d xlib_drawable_c]] --[[@param data ptr_c<ffi.cdata*>]] --[[@param width integer]] --[[@param height integer]]
display.create_bitmap_from_data = function (self, d, data, width, height)
	return mod.create_bitmap_from_data(self.c, d, data, width, height)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param src xlib_drawable_c]] --[[@param dest xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param src_x integer]] --[[@param src_y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param dest_x integer]] --[[@param dest_y integer]]
mod.copy_area = function (display_, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y)
	xlib_ffi.XCopyArea(display_, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y)
end
--[[@param src xlib_drawable_c]] --[[@param dest xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param src_x integer]] --[[@param src_y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param dest_x integer]] --[[@param dest_y integer]]
display.copy_area = function (self, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y)
	return mod.copy_area(self.c, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param src xlib_drawable_c]] --[[@param dest xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param src_x integer]] --[[@param src_y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param dest_x integer]] --[[@param dest_y integer]] --[[@param plane integer]]
mod.copy_plane = function (display_, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y, plane)
	xlib_ffi.XCopyPlane(display_, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y, plane)
end
--[[@param src xlib_drawable_c]] --[[@param dest xlib_drawable_c]] --[[@param gc xlib_gc_c]] --[[@param src_x integer]] --[[@param src_y integer]] --[[@param width integer]] --[[@param height integer]] --[[@param dest_x integer]] --[[@param dest_y integer]] --[[@param plane integer]]
display.copy_plane = function (self, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y, plane)
	return mod.copy_plane(self.c, src, dest, gc, src_x, src_y, width, height, dest_x, dest_y, plane)
end

--[[@param font_struct ptr_c<xlib_font_struct_c>]] --[[@param string string]]
mod.text_width = function (font_struct, string)
	return xlib_ffi.XTextWidth(font_struct, string, #string)
end

--[[@param font_struct ptr_c<xlib_font_struct_c>]] --[[@param string string]]
mod.text_width16 = function (font_struct, string)
	return xlib_ffi.XTextWidth16(font_struct, string, bit.rshift(#string, 1))
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param colormap xlib_colormap_c]] --[[@param red integer 0x0000-0xffff]] --[[@param green integer 0x0000-0xffff]] --[[@param blue integer 0x0000-0xffff]]
mod.alloc_color = function (display_, colormap, red, green, blue)
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	local screen = color_p_c({ { red = red, green = green, blue = blue, pixel = 0, flags = 0 } })
	if xlib_ffi.XAllocColor(display_, colormap, screen) == 0 then return nil end
	return screen[0].pixel
end
--[[@param colormap xlib_colormap_c]] --[[@param red integer 0x0000-0xffff]] --[[@param green integer 0x0000-0xffff]] --[[@param blue integer 0x0000-0xffff]]
display.alloc_color = function (self, colormap, red, green, blue)
	return mod.alloc_color(self.c, colormap, red, green, blue)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param colormap xlib_colormap_c]] --[[@param rgb integer 0xrrggbb]]
mod.alloc_color_x = function (display_, colormap, rgb)
	return mod.alloc_color(
		display_, colormap,
		bit.band(bit.rshift(rgb, 8), 0xff00),
		bit.band(rgb, 0xff00),
		bit.band(bit.lshift(rgb, 8), 0xff00)
	)
end
--[[@param colormap xlib_colormap_c]] --[[@param rgb integer 0xrrggbb]]
display.alloc_color_x = function (self, colormap, rgb) return mod.alloc_color_x(self.c, colormap, rgb) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param colormap xlib_colormap_c]] --[[@param color_name string]]
mod.alloc_named_color = function (display_, colormap, color_name)
	local screen_def = color_p_c()
	local exact_def = color_p_c()
	if xlib_ffi.XAllocNamedColor(display_, colormap, color_name, screen_def, exact_def) == 0 then return nil end
	return { screen_def = screen_def, exact_def = exact_def }
end
--[[@param colormap xlib_colormap_c]] --[[@param color_name string]]
display.alloc_named_color = function (self, colormap, color_name)
	return mod.alloc_named_color(self.c, colormap, color_name)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param colormap xlib_colormap_c]] --[[@param contig boolean]] --[[@param nplanes integer]] --[[@param npixels integer >=1]]
mod.alloc_color_cells = function (display_, colormap, contig, nplanes, npixels)
	local plane_masks = ulong_a_c(nplanes)
	local pixels = ulong_a_c(npixels)
	if xlib_ffi.XAllocColorCells(display_, colormap, contig, plane_masks, nplanes, pixels, npixels) then return nil end
	return { plane_masks = plane_masks, pixels = pixels }
end
--[[@param colormap xlib_colormap_c]] --[[@param contig boolean]] --[[@param nplanes integer]] --[[@param npixels integer >=1]]
display.alloc_color_cells = function (self, colormap, contig, nplanes, npixels)
	return mod.alloc_color_cells(self.c, colormap, contig, nplanes, npixels)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param colormap xlib_colormap_c]] --[[@param contig boolean]] --[[@param ncolors integer >=1]] --[[@param nreds integer]] --[[@param ngreens integer]] --[[@param nblues integer]]
mod.alloc_color_planes = function (display_, colormap, contig, ncolors, nreds, ngreens, nblues)
	local pixels = ulong_a_c(ncolors)
	local rmask = ulong_p_c()
	local gmask = ulong_p_c()
	local bmask = ulong_p_c()
	if xlib_ffi.XAllocColorPlanes(display_, colormap, contig, pixels, ncolors, nreds, ngreens, nblues, rmask, gmask, bmask) == 0 then return nil end
	return { pixels = pixels, red_mask = rmask, green_mask = gmask, blue_mask = bmask }
end
--[[@param colormap xlib_colormap_c]] --[[@param contig boolean]] --[[@param ncolors integer >=1]] --[[@param nreds integer]] --[[@param ngreens integer]] --[[@param nblues integer]]
display.alloc_color_planes = function (self, colormap, contig, ncolors, nreds, ngreens, nblues)
	return mod.alloc_color_planes(self.c, colormap, contig, ncolors, nreds, ngreens, nblues)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param colormap xlib_colormap_c]] --[[@param pixels integer[] ]] --[[@param npixels integer]] --[[@param planes integer]]
mod.free_colors = function (display_, colormap, pixels, npixels, planes)
	xlib_ffi.XFreeColors(display_, colormap, pixels, npixels, planes)
end
--[[@param colormap xlib_colormap_c]] --[[@param pixels integer[] ]] --[[@param npixels integer]] --[[@param planes integer]]
display.free_colors = function (self, colormap, pixels, npixels, planes)
	return mod.free_colors(self.c, colormap, pixels, npixels, planes)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param d xlib_drawable_c]] --[[@param valuemask integer]] --[[@param values ptr_c<xlib_gc_values_c>?]]
mod.create_gc = function (display_, d, valuemask, values)
	return xlib_ffi.XCreateGC(display_, d, valuemask, values)
end
--[[@param d xlib_drawable_c]] --[[@param valuemask integer]] --[[@param values ptr_c<xlib_gc_values_c>?]]
display.create_gc = function (self, d, valuemask, values)
	return mod.create_gc(self.c, d, valuemask, values)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param src xlib_gc_c]] --[[@param valuemask integer]] --[[@param dest xlib_gc_c]]
mod.copy_gc = function (display_, src, valuemask, dest)
	return xlib_ffi.XCopyGC(display_, src, valuemask, dest)
end
--[[@param src xlib_gc_c]] --[[@param valuemask integer]] --[[@param dest xlib_gc_c]]
display.copy_gc = function (self, src, valuemask, dest)
	return mod.copy_gc(self.c, src, valuemask, dest)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param gc xlib_gc_c]] --[[@param valuemask integer]] --[[@param values ptr_c<xlib_gc_values_c>]]
mod.change_gc = function (display_, gc, valuemask, values)
	return xlib_ffi.XChangeGC(display_, gc, valuemask, values)
end
--[[@param gc xlib_gc_c]] --[[@param valuemask integer]] --[[@param values ptr_c<xlib_gc_values_c>]]
display.change_gc = function (self, gc, valuemask, values)
	return mod.change_gc(self.c, gc, valuemask, values)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param gc xlib_gc_c]] --[[@param valuemask integer]]
mod.get_gc_values = function (display_, gc, valuemask)
	local values = ffi.new("XGCValues[1]") --[[@type ptr_c<xlib_gc_values_c>]]
	if xlib_ffi.XGetGCValues(display_, gc, valuemask, values) == 0 then return nil end
	return values[0]
end
--[[@param gc xlib_gc_c]] --[[@param valuemask integer]]
display.get_gc_values = function (self, gc, valuemask)
	return mod.get_gc_values(self.c, gc, valuemask)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param gc xlib_gc_c]]
mod.free_gc = function (display_, gc) return xlib_ffi.XFreeGC(display_, gc) end
--[[@param gc xlib_gc_c]]
display.free_gc = function (self, gc) return mod.free_gc(self.c, gc) end
--[[@param gc xlib_gc_c]]
mod.gcontext_from_gc = function (gc) return xlib_ffi.XGContextFromGC(gc) end
mod.alloc_size_hints = function () return xlib_ffi.XAllocSizeHints() end
--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param hints ptr_c<xlib_size_hints_c>]]
mod.set_wm_normal_hints = function (display_, w, hints) return xlib_ffi.XSetWMNormalHints(display_, w, hints) end
--[[@param w xlib_window_c]] --[[@param hints ptr_c<xlib_size_hints_c>]]
display.set_wm_normal_hints = function (self, w, hints) return mod.set_wm_normal_hints(self.c, w, hints) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.get_wm_normal_hints = function (display_, w)
	local hints = ffi.new("XSizeHints[1]") --[[@type ptr_c<xlib_size_hints_c>]]
	local supplied = int_p_c()
	if xlib_ffi.XGetWMNormalHints(display_, w, hints, supplied) == 0 then return nil end
	return {
		hints = hints[0],
		flags = supplied[0] --[[@type xlib_size_flag]]
	}
end
--[[@param w xlib_window_c]]
display.get_wm_normal_hints = function (self, w)
	return mod.get_wm_normal_hints(self.c, w)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param hints ptr_c<xlib_size_hints_c>]] --[[@param property xlib_atom_c]]
mod.set_wm_size_hints = function (display_, w, hints, property)
	return xlib_ffi.XSetWMSizeHints(display_, w, hints, property)
end
--[[@param w xlib_window_c]] --[[@param hints ptr_c<xlib_size_hints_c>]] --[[@param property xlib_atom_c]]
display.set_wm_size_hints = function (self, w, hints, property)
	return mod.set_wm_size_hints(self.c, w, hints, property)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param property xlib_atom_c]]
mod.get_wm_size_hints = function (display_, w, property)
	local hints = ffi.new("XSizeHints[1]") --[[@type ptr_c<xlib_size_hints_c>]]
	local supplied = int_p_c()
	if xlib_ffi.XGetWMSizeHints(display_, w, hints, supplied, property) == 0 then return nil end
	return { hints = hints, flags = supplied }
end
--[[@param w xlib_window_c]] --[[@param property xlib_atom_c]]
display.get_wm_size_hints = function (self, w, property) return mod.get_wm_size_hints(self.c, w, property) end

mod.alloc_class_hint = function () return xlib_ffi.XAllocClassHint() end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param class_hints ptr_c<xlib_class_hint_c>]]
mod.set_class_hint = function (display_, w, class_hints)
	return xlib_ffi.XSetClassHint(display_, w, class_hints)
end
--[[@param w xlib_window_c]] --[[@param class_hints ptr_c<xlib_class_hint_c>]]
display.set_class_hint = function (self, w, class_hints)
	return mod.set_class_hint(self.c, w, class_hints)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.get_class_hint = function (display_, w)
	local class_hints = ffi.new("XClassHint[1]") --[[@type ptr_c<xlib_class_hint_c>]]
	if xlib_ffi.XGetClassHint(display_, w, class_hints) == 0 then return nil end
	return class_hints
end
--[[@param w xlib_window_c]]
display.get_class_hint = function (self, w) return mod.get_class_hint(self.c, w) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param text_prop ptr_c<xlib_text_property_c>]]
mod.set_wm_name = function (display_, w, text_prop)
	return xlib_ffi.XSetWMName(display_, w, text_prop)
end
--[[@param w xlib_window_c]] --[[@param text_prop ptr_c<xlib_text_property_c>]]
display.set_wm_name = function (self, w, text_prop)
	return mod.set_wm_name(self.c, w, text_prop)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.get_wm_name = function (display_, w)
	local text_prop = ffi.new("XTextProperty[1]") --[[@type ptr_c<xlib_text_property_c>]]
	if xlib_ffi.XGetWMName(display_, w, text_prop) == 0 then return nil end
	return text_prop
end
--[[@param w xlib_window_c]]
display.get_wm_name = function (self, w) return mod.get_wm_name(self.c, w) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param window_name ptr_c<ffi.cdata*>]]
mod.store_name = function (display_, w, window_name)
	return xlib_ffi.XStoreName(display_, w, window_name)
end
--[[@param w xlib_window_c]] --[[@param window_name ptr_c<ffi.cdata*>]]
display.store_name = function (self, w, window_name)
	return mod.store_name(self.c, w, window_name)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.fetch_name = function (display_, w)
	local window_name = string_p_c()
	if xlib_ffi.XFetchName(display_, w, window_name) == 0 then return nil end
	return window_name[0]
end
--[[@param w xlib_window_c]]
display.fetch_name = function (self, w) return mod.fetch_name(self.c, w) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param text_prop ptr_c<xlib_text_property_c>]]
mod.set_wm_client_machine = function (display_, w, text_prop)
	return xlib_ffi.XSetWMClientMachine(display_, w, text_prop)
end
--[[@param w xlib_window_c]] --[[@param text_prop ptr_c<xlib_text_property_c>]]
display.set_wm_client_machine = function (self, w, text_prop)
	return mod.set_wm_client_machine(self.c, w, text_prop)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]]
mod.get_wm_client_machine = function (display_, w)
	local text_prop = ffi.new("XTextProperty[1]") --[[@type ptr_c<xlib_text_property_c>]]
	if not xlib_ffi.XGetWMClientMachine(display_, w, text_prop) then return nil end
	return text_prop
end
--[[@param w xlib_window_c]]
display.get_wm_client_machine = function (self, w) return mod.get_wm_client_machine(self.c, w) end

--[[@param font_set xlib_font_set_c]] --[[@param string string]]
mod.mb_text_extents = function (font_set, string)
	local overall_ink = ffi.new("XRectangle[1]") --[[@type ptr_c<xlib_rectangle_c>]]
	local overall_logical = ffi.new("XRectangle[1]") --[[@type ptr_c<xlib_rectangle_c>]]
	xlib_ffi.XmbTextExtents(font_set, string, #string, overall_ink, overall_logical)
	return { ink = overall_ink[0], logical = overall_logical[0] }
end

--[[@param font_set xlib_font_set_c]] --[[@param string ptr_c<integer>]]
mod.wc_text_extents = function (font_set, string)
	local overall_ink = ffi.new("XRectangle[1]") --[[@type ptr_c<xlib_rectangle_c>]]
	local overall_logical = ffi.new("XRectangle[1]") --[[@type ptr_c<xlib_rectangle_c>]]
	xlib_ffi.XwcTextExtents(font_set, ffi.cast("const uint16_t *", string), bit.rshift(#string, 1), overall_ink, overall_logical)
	return { ink = overall_ink[0], logical = overall_logical[0] }
end

--[[@param font_set xlib_font_set_c]] --[[@param string string]]
mod.utf8_text_extents = function (font_set, string)
	local overall_ink = ffi.new("XRectangle[1]") --[[@type ptr_c<xlib_rectangle_c>]]
	local overall_logical = ffi.new("XRectangle[1]") --[[@type ptr_c<xlib_rectangle_c>]]
	xlib_ffi.Xutf8TextExtents(font_set, string, #string, overall_ink, overall_logical)
	return { ink = overall_ink[0], logical = overall_logical[0] }
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param value_mask integer]] --[[@param changes ptr_c<xlib_window_changes_c>]]
mod.configure_window = function (display_, w, value_mask, changes)
	return xlib_ffi.XConfigureWindow(display_, w, value_mask, changes)
end
--[[@param w xlib_window_c]] --[[@param value_mask integer]] --[[@param changes ptr_c<xlib_window_changes_c>]]
display.configure_window = function (self, w, value_mask, changes)
	return mod.configure_window(self.c, w, value_mask, changes)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param x integer]] --[[@param y integer]]
mod.move_window = function (display_, w, x, y)
	return xlib_ffi.XMoveWindow(display_, w, x, y)
end
--[[@param w xlib_window_c]] --[[@param x integer]] --[[@param y integer]]
display.move_window = function (self, w, x, y)
	return mod.move_window(self.c, w, x, y)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param width integer]] --[[@param height integer]]
mod.resize_window = function (display_, w, width, height)
	return xlib_ffi.XResizeWindow(display_, w, width, height)
end
--[[@param w xlib_window_c]] --[[@param width integer]] --[[@param height integer]]
display.resize_window = function (self, w, width, height)
	return mod.resize_window(self.c, w, width, height)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]]
mod.move_resize_window = function (display_, w, x, y, width, height)
	return xlib_ffi.XMoveResizeWindow(display_, w, x, y, width, height)
end
--[[@param w xlib_window_c]] --[[@param x integer]] --[[@param y integer]] --[[@param width integer]] --[[@param height integer]]
display.move_resize_window = function (self, w, x, y, width, height)
	return mod.move_resize_window(self.c, w, x, y, width, height)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param w xlib_window_c]] --[[@param width integer]]
mod.set_window_border_width = function (display_, w, width)
	return xlib_ffi.XSetWindowBorderWidth(display_, w, width)
end
--[[@param w xlib_window_c]] --[[@param width integer]]
display.set_window_border_width = function (self, w, width) return mod.set_window_border_width(self.c, w, width) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param focus xlib_window_c]] --[[@param revert_to xlib_revert_to]] --[[@param time xlib_time_c]]
mod.set_input_focus = function (display_, focus, revert_to, time)
	return xlib_ffi.XSetInputFocus(display_, focus, revert_to, time)
end
--[[@param focus xlib_window_c]] --[[@param revert_to xlib_revert_to]] --[[@param time xlib_time_c]]
display.set_input_focus = function (self, focus, revert_to, time)
	return mod.set_input_focus(self.c, focus, revert_to, time)
end

--[[@param display_ ptr_c<xlib_display_c>]]
mod.get_input_focus = function (display_)
	local focus = ffi.new("Window[1]") --[[@type ptr_c<xlib_window_c>]]
	local revert_to = ffi.new("int[1]") --[[@type ptr_c<integer>]]
	xlib_ffi.XGetInputFocus(display_, focus, revert_to)
	return { focus = focus[0], revert_to = revert_to[0] }
end
display.get_input_focus = function (self) return mod.get_input_focus(self.c) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param button xlib_button]] --[[@param modifiers xlib_key_button_mask]] --[[@param grab_window xlib_window_c]] --[[@param owner_events boolean]] --[[@param event_mask xlib_input_event_mask]] --[[@param pointer_mode xlib_grab_mode]] --[[@param keyboard_mode xlib_grab_mode]] --[[@param confine_to xlib_window_c]] --[[@param cursor xlib_cursor_c]]
mod.grab_button = function (display_, button, modifiers, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor)
	return xlib_ffi.XGrabButton(display_, button, modifiers, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor)
end
--[[@param button xlib_button]] --[[@param modifiers xlib_key_button_mask]] --[[@param grab_window xlib_window_c]] --[[@param owner_events boolean]] --[[@param event_mask xlib_input_event_mask]] --[[@param pointer_mode xlib_grab_mode]] --[[@param keyboard_mode xlib_grab_mode]] --[[@param confine_to xlib_window_c]] --[[@param cursor xlib_cursor_c]]
display.grab_button = function (self, button, modifiers, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor)
	return mod.grab_button(self.c, button, modifiers, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param button xlib_button]] --[[@param modifiers xlib_key_button_mask]] --[[@param grab_window xlib_window_c]]
mod.ungrab_button = function (display_, button, modifiers, grab_window)
	return xlib_ffi.XUngrabButton(display_, button, modifiers, grab_window)
end
--[[@param button xlib_button]] --[[@param modifiers xlib_key_button_mask]] --[[@param grab_window xlib_window_c]]
display.ungrab_button = function (self, button, modifiers, grab_window)
	return mod.ungrab_button(self.c, button, modifiers, grab_window)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param keycode xlib_key_code_c]] --[[@param modifiers xlib_key_button_mask]] --[[@param grab_window xlib_window_c]] --[[@param owner_events boolean]] --[[@param pointer_mode xlib_grab_mode]] --[[@param keyboard_mode xlib_grab_mode]]
mod.grab_key = function (display_, keycode, modifiers, grab_window, owner_events, pointer_mode, keyboard_mode)
	return xlib_ffi.XGrabKey(display_, keycode, modifiers, grab_window, owner_events, pointer_mode, keyboard_mode)
end
--[[@param keycode xlib_key_code_c]] --[[@param modifiers xlib_key_button_mask]] --[[@param grab_window xlib_window_c]] --[[@param owner_events boolean]] --[[@param pointer_mode xlib_grab_mode]] --[[@param keyboard_mode xlib_grab_mode]]
display.grab_key = function (self, keycode, modifiers, grab_window, owner_events, pointer_mode, keyboard_mode)
	return mod.grab_key(self.c, keycode, modifiers, grab_window, owner_events, pointer_mode, keyboard_mode)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param keycode xlib_key_code_c]] --[[@param modifiers xlib_key_button_mask]] --[[@param grab_window xlib_window_c]]
mod.ungrab_key = function (display_, keycode, modifiers, grab_window)
	return xlib_ffi.XUngrabKey(display_, keycode, modifiers, grab_window)
end
--[[@param keycode xlib_key_code_c]] --[[@param modifiers xlib_key_button_mask]] --[[@param grab_window xlib_window_c]]
display.ungrab_key = function (self, keycode, modifiers, grab_window)
	return mod.ungrab_key(self.c, keycode, modifiers, grab_window)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param grab_window xlib_window_c]] --[[@param owner_events boolean]] --[[@param event_mask xlib_input_event_mask]] --[[@param pointer_mode xlib_grab_mode]] --[[@param keyboard_mode xlib_grab_mode]] --[[@param confine_to xlib_window_c]] --[[@param cursor xlib_cursor_c]] --[[@param time xlib_time_c]]
mod.grab_pointer = function (display_, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor, time)
	return xlib_ffi.XGrabPointer(display_, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor, time)
end
--[[@param grab_window xlib_window_c]] --[[@param owner_events boolean]] --[[@param event_mask xlib_input_event_mask]] --[[@param pointer_mode xlib_grab_mode]] --[[@param keyboard_mode xlib_grab_mode]] --[[@param confine_to xlib_window_c]] --[[@param cursor xlib_cursor_c]] --[[@param time xlib_time_c]]
display.grab_pointer = function (self, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor, time)
	return mod.grab_pointer(self.c, grab_window, owner_events, event_mask, pointer_mode, keyboard_mode, confine_to, cursor, time)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param time xlib_time_c]]
mod.ungrab_pointer = function (display_, time)
	return xlib_ffi.XUngrabPointer(display_, time)
end
--[[@param time xlib_time_c]]
display.ungrab_pointer = function (self, time)
	return mod.ungrab_pointer(self.c, time)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param event_mask xlib_input_event_mask]] --[[@param cursor xlib_cursor_c]] --[[@param time xlib_time_c]]
mod.change_active_pointer_grab = function (display_, event_mask, cursor, time)
	return xlib_ffi.XChangeActivePointerGrab(display_, event_mask, cursor, time)
end
--[[@param event_mask xlib_input_event_mask]] --[[@param cursor xlib_cursor_c]] --[[@param time xlib_time_c]]
display.change_active_pointer_grab = function (self, event_mask, cursor, time)
	return mod.change_active_pointer_grab(self.c, event_mask, cursor, time)
end

--[[@return xlib_key_sym_c]] --[[@param string string]]
mod.string_to_keysym = function (string) return xlib_ffi.XStringToKeysym(string) end
--[[@return ptr_c<ffi.cdata*>]] --[[@param keysym xlib_key_sym_c]]
mod.keysym_to_string = function (keysym) return xlib_ffi.XKeysymToString(keysym) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param keycode xlib_key_code_c]] --[[@param index integer]]
mod.keycode_to_keysym = function (display_, keycode, index)
	return xlib_ffi.XKeycodeToKeysym(display_, keycode, index)
end
--[[@param keycode xlib_key_code_c]] --[[@param index integer]]
display.keycode_to_keysym = function (self, keycode, index)
	return mod.keycode_to_keysym(self.c, keycode, index)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param keysym xlib_key_sym_c]]
mod.keysym_to_keycode = function (display_, keysym)
	return xlib_ffi.XKeysymToKeycode(display_, keysym)
end
--[[@param keysym xlib_key_sym_c]]
display.keysym_to_keycode = function (self, keysym)
	return mod.keysym_to_keycode(self.c, keysym)
end

local lower = ffi.new("KeySym[1]") --[[@type ptr_c<xlib_key_sym_c>]]
local upper = ffi.new("KeySym[1]") --[[@type ptr_c<xlib_key_sym_c>]]

--[[@param keysym xlib_key_sym_c]]
mod.convert_case = function (keysym)
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	lower[0] = 0
	--[[@diagnostic disable-next-line: assign-type-mismatch]]
	upper[0] = 0
	xlib_ffi.XConvertCase(keysym, lower, upper)
	return { lower = lower[0], upper = upper[0] }
end
--[[@param keysym xlib_key_sym_c]]
display.convert_case = function (keysym) return mod.convert_case(keysym) end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param src_w xlib_window_c]] --[[@param dest_w xlib_window_c]] --[[@param src_x integer]] --[[@param src_y integer]] --[[@param src_width integer]] --[[@param src_height integer]] --[[@param dest_x integer]] --[[@param dest_y integer]]
mod.warp_pointer = function (display_, src_w, dest_w, src_x, src_y, src_width, src_height, dest_x, dest_y)
	return xlib_ffi.XWarpPointer(display_, src_w, dest_w, src_x, src_y, src_width, src_height, dest_x, dest_y)
end
--[[@param src_w xlib_window_c]] --[[@param dest_w xlib_window_c]] --[[@param src_x integer]] --[[@param src_y integer]] --[[@param src_width integer]] --[[@param src_height integer]] --[[@param dest_x integer]] --[[@param dest_y integer]]
display.warp_pointer = function (self, src_w, dest_w, src_x, src_y, src_width, src_height, dest_x, dest_y)
	return mod.warp_pointer(self.c, src_w, dest_w, src_x, src_y, src_width, src_height, dest_x, dest_y)
end

--[[@return xlib_key_sym_c]] --[[@param key_event ptr_c<xlib_key_event_c>]] --[[@param index integer]]
mod.lookup_keysym = function (key_event, index)
	return xlib_ffi.XLookupKeysym(key_event, index)
end

--[[@param event_map ptr_c<xlib_mapping_event_c>]]
mod.refresh_keyboard_mapping = function (event_map)
	return xlib_ffi.XRefreshKeyboardMapping(event_map)
end

local lookup_string_text = ffi.new("char[64]")

--[[@param event_struct ptr_c<xlib_key_event_c>]] --[[@param status? xlib_compose_status_c]]
mod.lookup_string = function (event_struct, status)
	local keysym = ffi.new("KeySym[1]") --[[@type ptr_c<xlib_key_sym_c>]]
	local status_ = status and ffi.new("XComposeStatus[1]", status) or nil
	local length = xlib_ffi.XLookupString(event_struct, lookup_string_text, 64, keysym, status_)
	return { string = ffi.string(lookup_string_text, length), keysym = keysym[0], status = status_ and status_[0] }
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param keysym xlib_key_sym_c]] --[[@param list xlib_key_sym_c[] ]] --[[@param string string]]
mod.rebind_keysym = function (display_, keysym, list, string)
	return xlib_ffi.XRebindKeysym(display_, keysym, list, #list, string, #string)
end

--[[@return boolean]] --[[@param event xlib_event_c]] --[[@param w xlib_window_c]]
mod.filter_event = function (event, w)
	return xlib_ffi.XFilterEvent(ffi.new("XEvent[1]", event), w)
end

local buffer = ffi.new("char[128]")

--[[@param ic xlib_ic_c]] --[[@param event ptr_c<xlib_key_pressed_event_c>]]
mod.mb_lookup_string = function (ic, event)
	local keysym = ffi.new("KeySym[1]") --[[@type ptr_c<xlib_key_sym_c>]]
	local status = ffi.new("Status[1]") --[[@type ptr_c<xlib_status_c>]]
	xlib_ffi.XmbLookupString(ic, event, buffer, 128, keysym, status)
	return { string = ffi.string(buffer), keysym = keysym[0], status = status[0] }
end

--[[@param ic xlib_ic_c]] --[[@param event ptr_c<xlib_key_pressed_event_c>]]
mod.wc_lookup_string = function (ic, event)
	local keysym = ffi.new("KeySym[1]") --[[@type ptr_c<xlib_key_sym_c>]]
	local status = ffi.new("Status[1]") --[[@type ptr_c<xlib_status_c>]]
	xlib_ffi.XwcLookupString(ic, event, buffer, 64, keysym, status)
	return { string = ffi.string(buffer), keysym = keysym[0], status = status[0] }
end

--[[@param ic xlib_ic_c]] --[[@param event ptr_c<xlib_key_pressed_event_c>]]
mod.utf8_lookup_string = function (ic, event)
	local keysym = ffi.new("KeySym[1]") --[[@type ptr_c<xlib_key_sym_c>]]
	local status = ffi.new("Status[1]") --[[@type ptr_c<xlib_status_c>]]
	xlib_ffi.Xutf8LookupString(ic, event, buffer, 128, keysym, status)
	return { string = ffi.string(buffer), keysym = keysym[0], status = status[0] }
end

--[[@return xlib_im_c]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param db xlib_rm_database_c]] --[[@param res_name ptr_c<ffi.cdata*>]] --[[@param res_class ptr_c<ffi.cdata*>]]
mod.open_im = function (display_, db, res_name, res_class)
	return xlib_ffi.XOpenIM(display_, db, res_name, res_class)
end
--[[@return xlib_im_c]] --[[@param db xlib_rm_database_c]] --[[@param res_name ptr_c<ffi.cdata*>]] --[[@param res_class ptr_c<ffi.cdata*>]]
display.open_im = function (self, db, res_name, res_class)
	return mod.open_im(self.c, db, res_name, res_class)
end

--[[@return xlib_status_c]] --[[@param im xlib_im_c]]
mod.close_im = function (im) return xlib_ffi.XCloseIM(im) end

--[[@param im xlib_im_c]] --[[@param ... unknown]]
mod.set_im_values = function (im, ...)
	local first_failing_arg = xlib_ffi.XSetIMValues(im, ...)
	return first_failing_arg ~= nil and ffi.string(first_failing_arg) or nil
end

--[[@param im xlib_im_c]] --[[@param ... unknown]]
mod.get_im_values = function (im, ...) 
	local first_failing_arg = xlib_ffi.XGetIMValues(im, ...)
	return first_failing_arg ~= nil and ffi.string(first_failing_arg) or nil
end

--[[@param im xlib_im_c]]
mod.display_of_im = function (im) return xlib_ffi.XDisplayOfIM(im)[0] end
--[[@param im xlib_im_c]]
mod.locale_of_im = function (im) return ffi.string(xlib_ffi.XLocaleOfIM(im)) end

--[[@return boolean]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param db xlib_rm_database_c]] --[[@param res_name ptr_c<ffi.cdata*>]] --[[@param res_class ptr_c<ffi.cdata*>]] --[[@param callback xlib_id_proc_c]] --[[@param client_data xlib_pointer_c?]]
mod.register_im_instantiate_callback = function (display_, db, res_name, res_class, callback, client_data)
	return xlib_ffi.XRegisterIMInstantiateCallback(display_, db, res_name, res_class, callback, client_data)
end
--[[@return boolean]] --[[@param db xlib_rm_database_c]] --[[@param res_name ptr_c<ffi.cdata*>]] --[[@param res_class ptr_c<ffi.cdata*>]] --[[@param callback xlib_id_proc_c]] --[[@param client_data xlib_pointer_c?]]
display.register_im_instantiate_callback = function (self, db, res_name, res_class, callback, client_data)
	return mod.register_im_instantiate_callback(self.c, db, res_name, res_class, callback, client_data)
end

--[[@return boolean]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param db xlib_rm_database_c]] --[[@param res_name ptr_c<ffi.cdata*>]] --[[@param res_class ptr_c<ffi.cdata*>]] --[[@param callback xlib_id_proc_c]] --[[@param client_data xlib_pointer_c?]]
mod.unregister_im_instantiate_callback = function (display_, db, res_name, res_class, callback, client_data)
	return xlib_ffi.XUnregisterIMInstantiateCallback(display_, db, res_name, res_class, callback, client_data)
end
--[[@return boolean]] --[[@param db xlib_rm_database_c]] --[[@param res_name ptr_c<ffi.cdata*>]] --[[@param res_class ptr_c<ffi.cdata*>]] --[[@param callback xlib_id_proc_c]] --[[@param client_data xlib_pointer_c?]]
display.unregister_im_instantiate_callback = function (self, db, res_name, res_class, callback, client_data)
	return mod.unregister_im_instantiate_callback(self.c, db, res_name, res_class, callback, client_data)
end

--[[@return xlib_ic_c]] --[[@param im xlib_im_c]] --[[@param ... unknown]]
mod.create_ic = function (im, ...) return xlib_ffi.XCreateIC(im, ...) end
--[[@param ic xlib_ic_c]]
mod.destroy_ic = function (ic) return xlib_ffi.XDestroyIC(ic) end
--[[@param ic xlib_ic_c]]
mod.im_of_ic = function (ic) return xlib_ffi.XIMOfIC(ic) end
--[[@param ic xlib_ic_c]]
mod.set_ic_focus = function (ic) return xlib_ffi.XSetICFocus(ic) end
--[[@param ic xlib_ic_c]]
mod.unset_ic_focus = function (ic) return xlib_ffi.XUnsetICFocus(ic) end

--[[@param ic xlib_ic_c]] --[[@param ... unknown]]
mod.set_ic_values = function (ic, ...)
	local first_failing_arg = xlib_ffi.XSetICValues(ic, ...)
	return first_failing_arg ~= nil and ffi.string(first_failing_arg) or nil
end

--[[@param ic xlib_ic_c]] --[[@param ... unknown]]
mod.get_ic_values = function (ic, ...)
	local first_failing_arg = xlib_ffi.XGetICValues(ic, ...)
	return first_failing_arg ~= nil and ffi.string(first_failing_arg) or nil
end

--[[@param ic xlib_ic_c]]
mod.b_reset_ic = function (ic)
	local ret = xlib_ffi.XmbResetIC(ic)
	local s = ffi.string(ret)
	mod.free(ret)
	return s
end

--[[@param ic xlib_ic_c]]
mod.wc_reset_ic = function (ic)
	local ret = xlib_ffi.XwcResetIC(ic)
	local s = ffi.string(ret)
	mod.free(ret)
	return s
end

--[[@param ic xlib_ic_c]]
mod.utf8_reset_ic = function (ic)
	local ret = xlib_ffi.Xutf8ResetIC(ic)
	local s = ffi.string(ret)
	mod.free(ret)
	return s
end

local cmajor = ffi.new("int[1]") --[[@type ptr_c<integer>]]
local cminor = ffi.new("int[1]") --[[@type ptr_c<integer>]]

--[[@return xlib_status_c]] --[[@param display_ ptr_c<xlib_display_c>]]
mod.record_query_version = function (display_)
	--[[returns nonzero (success) only if the returned version numbers are common to both the library and the server]]
	xlib_tst_ffi.XRecordQueryVersion(display_, cmajor, cminor)
	return { cmajor = cmajor[0], cminor = cminor[0] }
end
--[[@return xlib_status_c]]
display.record_query_version = function (self)
	return mod.record_query_version(self.c)
end

--[[@return xlib_record_context_c]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param datum_flags xlib_record_datum_flag]] --[[@param clients ptr_c<xlib_record_client_spec_c>]] --[[@param nclients integer]] --[[@param ranges ptr_c<xlib_record_range_c>]] --[[@param nranges integer]]
mod.record_create_context = function (display_, datum_flags, clients, nclients, ranges, nranges)
	return xlib_tst_ffi.XRecordCreateContext(display_, datum_flags, clients, nclients, ranges, nranges)
end
--[[@return xlib_record_context_c]] --[[@param datum_flags xlib_record_datum_flag]] --[[@param clients ptr_c<xlib_record_client_spec_c>]] --[[@param nclients integer]] --[[@param ranges ptr_c<xlib_record_range_c>]] --[[@param nranges integer]]
display.record_create_context = function (self, datum_flags, clients, nclients, ranges, nranges)
	return mod.record_create_context(self.c, datum_flags, clients, nclients, ranges, nranges)
end

--[[@return xlib_record_range_c]]
mod.record_alloc_range = function () return xlib_tst_ffi.XRecordAllocRange()[0] end

--[[@return xlib_status_c]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param context xlib_record_context_c]] --[[@param datum_flags xlib_record_datum_flag]] --[[@param clients ptr_c<xlib_record_client_spec_c>]] --[[@param nclients integer]] --[[@param ranges ptr_c<xlib_record_range_c>]] --[[@param nranges integer]]
mod.record_register_clients = function (display_, context, datum_flags, clients, nclients, ranges, nranges)
	return xlib_tst_ffi.XRecordRegisterClients(display_, context, datum_flags, clients, nclients, ranges, nranges)
end
--[[@return xlib_status_c]] --[[@param context xlib_record_context_c]] --[[@param datum_flags xlib_record_datum_flag]] --[[@param clients ptr_c<xlib_record_client_spec_c>]] --[[@param nclients integer]] --[[@param ranges ptr_c<xlib_record_range_c>]] --[[@param nranges integer]]
display.record_register_clients = function (self, context, datum_flags, clients, nclients, ranges, nranges)
	return mod.record_register_clients(self.c, context, datum_flags, clients, nclients, ranges, nranges)
end

--[[@return xlib_status_c]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param context xlib_record_context_c]] --[[@param clients ptr_c<xlib_record_client_spec_c>]] --[[@param nclients integer]]
mod.record_un_register_clients = function (display_, context, clients, nclients)
	return xlib_tst_ffi.XRecordUnRegisterClients(display_, context, clients, nclients)
end
--[[@return xlib_status_c]] --[[@param context xlib_record_context_c]] --[[@param clients ptr_c<xlib_record_client_spec_c>]] --[[@param nclients integer]]
display.record_un_register_clients = function (self, context, clients, nclients)
	return mod.record_un_register_clients(self.c, context, clients, nclients)
end

--[[@param display_ ptr_c<xlib_display_c>]] --[[@param context xlib_record_context_c]]
mod.record_get_context = function (display_, context)
	local state = ffi.new("XRecordState *[1]") --[[@type ptr_c<xlib_record_state_c[]>]]
	xlib_tst_ffi.XRecordGetContext(display_, context, state)
	return state[0]
end
--[[@param context xlib_record_context_c]]
display.record_get_context = function (self, context)
	return mod.record_get_context(self.c, context)
end

--[[@param state xlib_record_state_c]]
mod.record_free_state = function (state) return xlib_tst_ffi.XRecordFreeState(state) end

--[[@return xlib_status_c]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param context xlib_record_context_c]] --[[@param callback xlib_record_intercept_proc_c]] --[[@param closure xlib_pointer_c]]
mod.record_enable_context = function (display_, context, callback, closure)
	return xlib_tst_ffi.XRecordEnableContext(display_, context, callback, closure)
end
--[[@return xlib_status_c]] --[[@param context xlib_record_context_c]] --[[@param callback xlib_record_intercept_proc_c]] --[[@param closure xlib_pointer_c]]
display.record_enable_context = function (self, context, callback, closure)
	return mod.record_enable_context(self.c, context, callback, closure)
end

--[[@return xlib_status_c]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param context xlib_record_context_c]] --[[@param callback xlib_record_intercept_proc_c]] --[[@param closure xlib_pointer_c]]
mod.record_enable_context_async = function (display_, context, callback, closure)
	return xlib_tst_ffi.XRecordEnableContextAsync(display_, context, callback, closure)
end
--[[@return xlib_status_c]] --[[@param context xlib_record_context_c]] --[[@param callback xlib_record_intercept_proc_c]] --[[@param closure xlib_pointer_c]]
display.record_enable_context_async = function (self, context, callback, closure)
	return mod.record_enable_context_async(self.c, context, callback, closure)
end

--[[@param display_ ptr_c<xlib_display_c>]]
mod.record_process_replies = function (display_)
	return xlib_tst_ffi.XRecordProcessReplies(display_)
end

display.record_process_replies = function (self)
	return mod.record_process_replies(self.c)
end

--[[@param data ptr_c<xlib_record_intercept_data_c>]]
mod.record_free_data = function (data)
	return xlib_tst_ffi.XRecordFreeData(data)
end
--[[@param data ptr_c<xlib_record_intercept_data_c>]]
display.record_free_data = function (data)
	return mod.record_free_data(data)
end

--[[@return xlib_status_c]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param context xlib_record_context_c]]
mod.record_disable_context = function (display_, context)
	return xlib_tst_ffi.XRecordDisableContext(display_, context)
end
--[[@return xlib_status_c]] --[[@param context xlib_record_context_c]]
display.record_disable_context = function (self, context)
	return mod.record_disable_context(self.c, context)
end

--[[@return xlib_id_c]] --[[@param display_ ptr_c<xlib_display_c>]]
mod.record_id_base_mask = function (display_)
	return xlib_tst_ffi.XRecordIdBaseMask(display_)
end
--[[@return xlib_id_c]] 
display.record_id_base_mask = function (self)
	return mod.record_id_base_mask(self.c)
end

--[[@return xlib_status_c]] --[[@param display_ ptr_c<xlib_display_c>]] --[[@param context xlib_record_context_c]]
mod.record_free_context = function (display_, context)
	return xlib_tst_ffi.XRecordFreeContext(display_, context)
end
--[[@return xlib_status_c]] --[[@param context xlib_record_context_c]]
display.record_free_context = function (self, context)
	return mod.record_free_context(self.c, context)
end

--[=[
.replace(/^\t(.+?) *\b(\w+)\((.+)\);$/gm, (_, r, n, a) => {
		ct=(t,n)=>({"const char *":"string_c","unsigned char *":"ffi.cdata*","char *":"ffi.cdata*",Bool:"boolean",int:"integer",long:"integer","unsigned int":"integer","unsigned long":"integer"}[t])??(
				n.endsWith("_return")&&t.endsWith("*")?`ptr_c<${ct(t.replace(/ *\*$/,""),n.replace(/_return$/,""))}>`:
				n.endsWith("_list")&&t.endsWith("*")?`${ct(t.replace(/ *\*$/,""),n.replace(/_list$/,""))}[]`:
				t.endsWith("*")?`ptr_c<${ct(t.replace(/ *\*$/,""),n)}>`:
				/^Xft/.test(t)?"xft"+t.slice(3).replace(/[A-Z]/g,m=>"_"+m.toLowerCase())+"_c":
				/^[A-Z]+$/.test(t)?"xlib_"+t.slice(t[0]==="X").toLowerCase()+"_c":
				/^[A-Z]/.test(t)?"xlib"+t.slice(t[0]==="X").replace(/[A-Z]/g,m=>"_"+m.toLowerCase())+"_c":
				t);
		return `\
${/^(int|void)$/.test(r) ? "" : ("--[[@return " + ct(r,n) + "]] ")}\
${a.split(", ").map(a => a.replace(/^(.+?) *(\w+)$/g, (_, t, n) => `--[[@param ${n==="display"?"display_":n.replace(/_return$/,"")} ${ct(t,n)}]]`)).join(" ")}
mod.${n.replace(/[A-Z]/g, "_$&").slice(3).toLowerCase()} = function (\
${a.split(", ").map(a => a.replace(/^.+? *(\w+)$/g, (_,n) => n==="display"?"display_":n)).join(", ")}\
)
		return xlib_ffi.${n}(${a.split(", ").map(a => a.replace(/^.+? *(\w+)$/g, (_,n) => n==="display"?"display_":n)).join(", ")})
end
${/^(int|void)$/.test(r) ? "" : ("--[[@return " + ct(r,n) + "]] ")}\
${a.split(", ").map(a => a.replace(/^(.+?) *(\w+)$/g, (_,t,n) => n==="display"?"":`--[[@param ${n.replace(/_return$/,"")} ${ct(t,n)}]]`)).filter(x=>x).join(" ")}
display.${n.replace(/[A-Z]/g, "_$&").slice(3).toLowerCase()} = function (\
${a.split(", ").map(a => a.replace(/^.+? *(\w+)$/g, (_,n) => n==="display"?"self":n)).join(", ")}\
)
		return mod.${n.replace(/[A-Z]/g, "_$&").slice(3).toLowerCase()}(${a.split(", ").map(a => a.replace(/^.+? *(\w+)$/g, (_,n) => n==="display"?"self.c":n)).join(", ")})
end
`
}).replace(/(\]+)\]\]/, "$1 ]]"))
]=]

-- TODO: bonus goal is to make a canvas-like sandbox

return mod
