local ffi = require("ffi")
require("dep.xkbcommon") --[[xkb types]]
require("dep.wayland_server") --[[wl types]]

--[[@class wlroots_ffi]]
ffi.cdef [[
	typedef signed long off_t;
	typedef unsigned /* int */ long dev_t;
	typedef signed long time_t;
	typedef uint32_t xcb_pixmap_t;
	typedef uint32_t xcb_window_t;
	typedef uint32_t xcb_atom_t;
	typedef uint32_t xcb_present_event_t;
	typedef uint32_t xcb_render_picture_t;
	typedef uint32_t xcb_colormap_t;
	typedef uint32_t xcb_visualid_t;
	typedef uint32_t xcb_cursor_t;
	typedef uint32_t xcb_render_pictformat_t;
	typedef uint32_t xcb_timestamp_t;
	typedef unsigned int GLuint;
	typedef unsigned int GLenum;
	typedef int32_t GLint;
	typedef int64_t GLint64;
	// https://github.com/ultimatepp/ultimatepp/blob/602aeae91e000f53107abb774ba265b20e612723/uppsrc/plugin/glew/eglew.h
	typedef void *EGLDisplay;
	typedef void *EGLSurface;
	typedef void *EGLContext;
	typedef void *EGLDeviceEXT;
	typedef void *EGLClientBuffer;
	typedef void *EGLImageKHR;
	typedef void *EGLLabelKHR;
	typedef uint64_t khronos_uint64_t;
	typedef int32_t EGLint;
	typedef unsigned int EGLBoolean;
	typedef unsigned int EGLenum;
	typedef intptr_t EGLAttrib;
	typedef khronos_uint64_t EGLuint64KHR;
	typedef EGLDisplay (*PFNEGLGETPLATFORMDISPLAYEXTPROC)(EGLenum platform, void* native_display, const EGLint* attrib_list);
	typedef EGLImageKHR (*PFNEGLCREATEIMAGEKHRPROC)(EGLDisplay dpy, EGLContext ctx, EGLenum target, EGLClientBuffer buffer, const EGLint* attrib_list);
	typedef EGLBoolean (*PFNEGLDESTROYIMAGEKHRPROC)(EGLDisplay dpy, EGLImageKHR image);
	typedef EGLBoolean (*PFNEGLQUERYDMABUFFORMATSEXTPROC)(EGLDisplay dpy, EGLint max_formats, EGLint* formats, EGLint* num_formats);
	typedef EGLBoolean (*PFNEGLQUERYDMABUFMODIFIERSEXTPROC)(EGLDisplay dpy, EGLint format, EGLint max_modifiers, EGLuint64KHR* modifiers, EGLBoolean* external_only, EGLint* num_modifiers);
	typedef void (*EGLDEBUGPROCKHR)(EGLenum error, const char *command, EGLint messageType, EGLLabelKHR threadLabel, EGLLabelKHR objectLabel, const char* message);
	typedef EGLint (*PFNEGLDEBUGMESSAGECONTROLKHRPROC)(EGLDEBUGPROCKHR callback, const EGLAttrib* attrib_list);
	typedef const char *(*PFNEGLQUERYDEVICESTRINGEXTPROC)(EGLDeviceEXT device, EGLint name);
	typedef EGLBoolean (*PFNEGLQUERYDISPLAYATTRIBEXTPROC)(EGLDisplay dpy, EGLint attribute, EGLAttrib* value);
	typedef EGLBoolean (*PFNEGLQUERYDEVICESEXTPROC)(EGLint max_devices, EGLDeviceEXT* devices, EGLint* num_devices);
	// https://github.com/KhronosGroup/OpenGL-Registry/blob/d2fe2072a3aecf3e9ef1568976e805531b50d959/api/GLES2/gl2ext.h
	typedef char GLchar;
	typedef unsigned char GLboolean;
	typedef int GLsizei;
	typedef uint64_t GLuint64;
	typedef void *GLeglImageOES;
	typedef void (*GLDEBUGPROCKHR)(GLenum source, GLenum type, GLuint id, GLenum severity, GLsizei length, const GLchar *message, const void *userParam);
	typedef void (*PFNGLEGLIMAGETARGETTEXTURE2DOESPROC)(GLenum target, GLeglImageOES image);
	typedef void (*PFNGLDEBUGMESSAGECALLBACKKHRPROC)(GLDEBUGPROCKHR callback, const void *userParam);
	typedef void (*PFNGLDEBUGMESSAGECONTROLKHRPROC)(GLenum source, GLenum type, GLenum severity, GLsizei count, const GLuint *ids, GLboolean enabled);
	typedef void (*PFNGLPOPDEBUGGROUPKHRPROC)(void);
	typedef void (*PFNGLPUSHDEBUGGROUPKHRPROC)(GLenum source, GLuint id, GLsizei length, const GLchar *message);
	typedef void (*PFNGLEGLIMAGETARGETRENDERBUFFERSTORAGEOESPROC)(GLenum target, GLeglImageOES image);
	typedef GLenum (*PFNGLGETGRAPHICSRESETSTATUSKHRPROC)(void);
	typedef void (*PFNGLGENQUERIESEXTPROC)(GLsizei n, GLuint *ids);
	typedef void (*PFNGLDELETEQUERIESEXTPROC)(GLsizei n, const GLuint *ids);
	typedef void (*PFNGLQUERYCOUNTEREXTPROC)(GLuint id, GLenum target);
	typedef void (*PFNGLGETQUERYOBJECTIVEXTPROC)(GLuint id, GLenum pname, GLint *params);
	typedef void (*PFNGLGETQUERYOBJECTUI64VEXTPROC)(GLuint id, GLenum pname, GLuint64 *params);
	typedef struct {
		struct extension_info_t *extensions;
	} xcb_errors_context_t;
	typedef struct xcb_connection_t xcb_connection_t;
	typedef struct {
		int32_t      flags;
		uint32_t     input;
		int32_t      initial_state;
		xcb_pixmap_t icon_pixmap;
		xcb_window_t icon_window;
		int32_t      icon_x, icon_y;
		xcb_pixmap_t icon_mask;
		xcb_window_t window_group;
	} xcb_icccm_wm_hints_t;
	typedef struct {
		uint32_t flags;
		int32_t  x, y;
		int32_t  width, height;
		int32_t  min_width, min_height;
		int32_t  max_width, max_height;
		int32_t  width_inc, height_inc;
		int32_t  min_aspect_num, min_aspect_den;
		int32_t  max_aspect_num, max_aspect_den;
		int32_t  base_width, base_height;
		uint32_t win_gravity;
	} xcb_size_hints_t;
	typedef struct {
		uint8_t response_type;
		uint8_t pad0;
		uint16_t sequence;
		uint32_t pad[7];
		uint32_t full_sequence;
	} xcb_generic_event_t;
	typedef struct {
		uint32_t left;
		uint32_t right;
		uint32_t top;
		uint32_t bottom;
		uint32_t left_start_y;
		uint32_t left_end_y;
		uint32_t right_start_y;
		uint32_t right_end_y;
		uint32_t top_start_x;
		uint32_t top_end_x;
		uint32_t bottom_start_x;
		uint32_t bottom_end_x;
	} xcb_ewmh_wm_strut_partial_t;
	typedef struct {
		xcb_window_t root;
		xcb_colormap_t default_colormap;
		uint32_t white_pixel;
		uint32_t black_pixel;
		uint32_t current_input_masks;
		uint16_t width_in_pixels;
		uint16_t height_in_pixels;
		uint16_t width_in_millimeters;
		uint16_t height_in_millimeters;
		uint16_t min_installed_maps;
		uint16_t max_installed_maps;
		xcb_visualid_t root_visual;
		uint8_t backing_stores;
		uint8_t save_unders;
		uint8_t root_depth;
		uint8_t allowed_depths_len;
	} xcb_screen_t;
	typedef struct {
		uint8_t depth;
		uint8_t pad0;
		uint16_t visuals_len;
		uint8_t pad1[4];
	} xcb_depth_t;
	typedef struct {
		uint8_t response_type;
		uint8_t extension;
		uint16_t sequence;
		uint32_t length;
		uint16_t event_type;
		uint8_t pad0[22];
		uint32_t full_sequence;
	} xcb_ge_generic_event_t;
	typedef struct {
		uint8_t response_type;
		uint8_t pad0;
		uint16_t sequence;
		xcb_window_t event;
		xcb_window_t window;
		xcb_window_t above_sibling;
		int16_t x;
		int16_t y;
		uint16_t width;
		uint16_t height;
		uint16_t border_width;
		uint8_t override_redirect;
		uint8_t pad1;
	} xcb_configure_notify_event_t;
	typedef struct {
		uint8_t response_type;
		uint8_t pad0;
		uint16_t sequence;
		xcb_timestamp_t time;
		xcb_window_t owner;
		xcb_window_t requestor;
		xcb_atom_t selection;
		xcb_atom_t target;
		xcb_atom_t property;
	} xcb_selection_request_event_t;
	typedef struct {
		uint8_t response_type;
		uint8_t format;
		uint16_t sequence;
		uint32_t length;
		xcb_atom_t type;
		uint32_t bytes_after;
		uint32_t value_len;
		uint8_t pad0[12];
	} xcb_get_property_reply_t;
	typedef struct {
		uint8_t response_type;
		uint8_t pad0;
		uint16_t sequence;
		xcb_window_t event;
		xcb_window_t window;
	} xcb_destroy_notify_event_t;
	typedef struct {
		uint8_t response_type;
		uint8_t pad0;
		uint16_t sequence;
		xcb_timestamp_t time;
		xcb_window_t requestor;
		xcb_atom_t selection;
		xcb_atom_t target;
		xcb_atom_t property;
	} xcb_selection_notify_event_t;
	typedef struct xcb_xfixes_selection_notify_event_t {
    uint8_t response_type;
    uint8_t subtype;
    uint16_t sequence;
    xcb_window_t window;
    xcb_window_t owner;
    xcb_atom_t selection;
    xcb_timestamp_t timestamp;
    xcb_timestamp_t selection_timestamp;
    uint8_t pad0[8];
	} xcb_xfixes_selection_notify_event_t;
	typedef struct {
		uint8_t response_type;
		uint8_t pad0;
		uint16_t sequence;
		uint32_t length;
		uint8_t present;
		uint8_t major_opcode;
		uint8_t first_event;
		uint8_t first_error;
	} xcb_query_extension_reply_t;
	typedef union {
		uint8_t data8[20];
		uint16_t data16[10];
		uint32_t data32[5];
	} xcb_client_message_data_t;
	typedef struct {
		uint8_t response_type;
		uint8_t format;
		uint16_t sequence;
		xcb_window_t window;
		xcb_atom_t type;
		xcb_client_message_data_t data;
	} xcb_client_message_event_t;
	typedef struct {
    unsigned int sequence;
	} xcb_void_cookie_t;
	// https://github.com/Ragmaanir/syntaks/blob/1bd845b86666dbe924c1137e9bd74db5fdfebc18/spec/benchmarks/vulkan.expanded.h#L137
	typedef struct VkInstance_T* VkInstance;
	typedef struct VkPhysicalDevice_T* VkPhysicalDevice;
	typedef struct VkDevice_T* VkDevice;
	typedef struct VkQueue_T* VkQueue;
	typedef struct VkSemaphore_T *VkSemaphore;
	typedef struct VkCommandBuffer_T* VkCommandBuffer;
	typedef struct VkFence_T *VkFence;
	typedef struct VkDeviceMemory_T *VkDeviceMemory;
	typedef struct VkBuffer_T *VkBuffer;
	typedef struct VkImage_T *VkImage;
	typedef struct VkEvent_T *VkEvent;
	typedef struct VkQueryPool_T *VkQueryPool;
	typedef struct VkBufferView_T *VkBufferView;
	typedef struct VkImageView_T *VkImageView;
	typedef struct VkShaderModule_T *VkShaderModule;
	typedef struct VkPipelineCache_T *VkPipelineCache;
	typedef struct VkPipelineLayout_T *VkPipelineLayout;
	typedef struct VkRenderPass_T *VkRenderPass;
	typedef struct VkPipeline_T *VkPipeline;
	typedef struct VkDescriptorSetLayout_T *VkDescriptorSetLayout;
	typedef struct VkSampler_T *VkSampler;
	typedef struct VkDescriptorPool_T *VkDescriptorPool;
	typedef struct VkDescriptorSet_T *VkDescriptorSet;
	typedef struct VkFramebuffer_T *VkFramebuffer;
	typedef struct VkCommandPool_T *VkCommandPool;
	typedef struct VkDeviceMemory_T* VkDeviceMemory;
	typedef struct VkFramebuffer_T *VkFramebuffer;
	typedef struct VkDescriptorSet_T *VkDescriptorSet;
	typedef struct VkCommandBuffer_T *VkCommandBuffer;
	typedef struct VkShaderModule_T *VkShaderModule;
	typedef struct VkSamplerYcbcrConversion_T* VkSamplerYcbcrConversion;
	typedef struct VkDebugUtilsMessengerEXT_T *VkDebugUtilsMessengerEXT;
	typedef uint32_t VkFlags;
	typedef uint32_t VkBool32;
	typedef uint64_t VkDeviceSize;
	typedef uint32_t VkSampleMask;
	typedef VkFlags VkMemoryPropertyFlags;
	typedef VkFlags VkImageUsageFlags;
	typedef VkFlags VkFormatFeatureFlags;
	typedef VkFlags VkPipelineStageFlags;
	typedef VkFlags VkAccessFlags;
	typedef struct VkExtent2D {
		uint32_t width;
		uint32_t height;
	} VkExtent2D;
	typedef struct VkDrmFormatModifierPropertiesEXT {
		uint64_t drmFormatModifier;
		uint32_t drmFormatModifierPlaneCount;
		VkFormatFeatureFlags drmFormatModifierTilingFeatures;
	} VkDrmFormatModifierPropertiesEXT;
	typedef enum VkImageLayout {
		VK_IMAGE_LAYOUT_UNDEFINED = 0,
		VK_IMAGE_LAYOUT_GENERAL = 1,
		VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL = 2,
		VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL = 3,
		VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL = 4,
		VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL = 5,
		VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL = 6,
		VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL = 7,
		VK_IMAGE_LAYOUT_PREINITIALIZED = 8,
		VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL = 1000117000,
		VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL = 1000117001,
		VK_IMAGE_LAYOUT_PRESENT_SRC_KHR = 1000001002,
		VK_IMAGE_LAYOUT_SHARED_PRESENT_KHR = 1000111000,
		VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL_KHR = VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL,
		VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL_KHR = VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL,
	} VkImageLayout;
	typedef enum VkResult {
		VK_SUCCESS = 0,
		VK_NOT_READY = 1,
		VK_TIMEOUT = 2,
		VK_EVENT_SET = 3,
		VK_EVENT_RESET = 4,
		VK_INCOMPLETE = 5,
		VK_ERROR_OUT_OF_HOST_MEMORY = -1,
		VK_ERROR_OUT_OF_DEVICE_MEMORY = -2,
		VK_ERROR_INITIALIZATION_FAILED = -3,
		VK_ERROR_DEVICE_LOST = -4,
		VK_ERROR_MEMORY_MAP_FAILED = -5,
		VK_ERROR_LAYER_NOT_PRESENT = -6,
		VK_ERROR_EXTENSION_NOT_PRESENT = -7,
		VK_ERROR_FEATURE_NOT_PRESENT = -8,
		VK_ERROR_INCOMPATIBLE_DRIVER = -9,
		VK_ERROR_TOO_MANY_OBJECTS = -10,
		VK_ERROR_FORMAT_NOT_SUPPORTED = -11,
		VK_ERROR_FRAGMENTED_POOL = -12,
		VK_ERROR_SURFACE_LOST_KHR = -1000000000,
		VK_ERROR_NATIVE_WINDOW_IN_USE_KHR = -1000000001,
		VK_SUBOPTIMAL_KHR = 1000001003,
		VK_ERROR_OUT_OF_DATE_KHR = -1000001004,
		VK_ERROR_INCOMPATIBLE_DISPLAY_KHR = -1000003001,
		VK_ERROR_VALIDATION_FAILED_EXT = -1000011001,
		VK_ERROR_INVALID_SHADER_NV = -1000012000,
		VK_ERROR_OUT_OF_POOL_MEMORY_KHR = -1000069000,
		VK_ERROR_INVALID_EXTERNAL_HANDLE_KHR = -1000072003,
		VK_ERROR_NOT_PERMITTED_EXT = -1000174001,
		VK_RESULT_BEGIN_RANGE = VK_ERROR_FRAGMENTED_POOL,
		VK_RESULT_END_RANGE = VK_INCOMPLETE,
		VK_RESULT_RANGE_SIZE = (VK_INCOMPLETE - VK_ERROR_FRAGMENTED_POOL + 1),
		VK_RESULT_MAX_ENUM = 0x7FFFFFFF
	} VkResult;
	typedef enum VkFormat {
		VK_FORMAT_UNDEFINED = 0,
		VK_FORMAT_R4G4_UNORM_PACK8 = 1,
		VK_FORMAT_R4G4B4A4_UNORM_PACK16 = 2,
		VK_FORMAT_B4G4R4A4_UNORM_PACK16 = 3,
		VK_FORMAT_R5G6B5_UNORM_PACK16 = 4,
		VK_FORMAT_B5G6R5_UNORM_PACK16 = 5,
		VK_FORMAT_R5G5B5A1_UNORM_PACK16 = 6,
		VK_FORMAT_B5G5R5A1_UNORM_PACK16 = 7,
		VK_FORMAT_A1R5G5B5_UNORM_PACK16 = 8,
		VK_FORMAT_R8_UNORM = 9,
		VK_FORMAT_R8_SNORM = 10,
		VK_FORMAT_R8_USCALED = 11,
		VK_FORMAT_R8_SSCALED = 12,
		VK_FORMAT_R8_UINT = 13,
		VK_FORMAT_R8_SINT = 14,
		VK_FORMAT_R8_SRGB = 15,
		VK_FORMAT_R8G8_UNORM = 16,
		VK_FORMAT_R8G8_SNORM = 17,
		VK_FORMAT_R8G8_USCALED = 18,
		VK_FORMAT_R8G8_SSCALED = 19,
		VK_FORMAT_R8G8_UINT = 20,
		VK_FORMAT_R8G8_SINT = 21,
		VK_FORMAT_R8G8_SRGB = 22,
		VK_FORMAT_R8G8B8_UNORM = 23,
		VK_FORMAT_R8G8B8_SNORM = 24,
		VK_FORMAT_R8G8B8_USCALED = 25,
		VK_FORMAT_R8G8B8_SSCALED = 26,
		VK_FORMAT_R8G8B8_UINT = 27,
		VK_FORMAT_R8G8B8_SINT = 28,
		VK_FORMAT_R8G8B8_SRGB = 29,
		VK_FORMAT_B8G8R8_UNORM = 30,
		VK_FORMAT_B8G8R8_SNORM = 31,
		VK_FORMAT_B8G8R8_USCALED = 32,
		VK_FORMAT_B8G8R8_SSCALED = 33,
		VK_FORMAT_B8G8R8_UINT = 34,
		VK_FORMAT_B8G8R8_SINT = 35,
		VK_FORMAT_B8G8R8_SRGB = 36,
		VK_FORMAT_R8G8B8A8_UNORM = 37,
		VK_FORMAT_R8G8B8A8_SNORM = 38,
		VK_FORMAT_R8G8B8A8_USCALED = 39,
		VK_FORMAT_R8G8B8A8_SSCALED = 40,
		VK_FORMAT_R8G8B8A8_UINT = 41,
		VK_FORMAT_R8G8B8A8_SINT = 42,
		VK_FORMAT_R8G8B8A8_SRGB = 43,
		VK_FORMAT_B8G8R8A8_UNORM = 44,
		VK_FORMAT_B8G8R8A8_SNORM = 45,
		VK_FORMAT_B8G8R8A8_USCALED = 46,
		VK_FORMAT_B8G8R8A8_SSCALED = 47,
		VK_FORMAT_B8G8R8A8_UINT = 48,
		VK_FORMAT_B8G8R8A8_SINT = 49,
		VK_FORMAT_B8G8R8A8_SRGB = 50,
		VK_FORMAT_A8B8G8R8_UNORM_PACK32 = 51,
		VK_FORMAT_A8B8G8R8_SNORM_PACK32 = 52,
		VK_FORMAT_A8B8G8R8_USCALED_PACK32 = 53,
		VK_FORMAT_A8B8G8R8_SSCALED_PACK32 = 54,
		VK_FORMAT_A8B8G8R8_UINT_PACK32 = 55,
		VK_FORMAT_A8B8G8R8_SINT_PACK32 = 56,
		VK_FORMAT_A8B8G8R8_SRGB_PACK32 = 57,
		VK_FORMAT_A2R10G10B10_UNORM_PACK32 = 58,
		VK_FORMAT_A2R10G10B10_SNORM_PACK32 = 59,
		VK_FORMAT_A2R10G10B10_USCALED_PACK32 = 60,
		VK_FORMAT_A2R10G10B10_SSCALED_PACK32 = 61,
		VK_FORMAT_A2R10G10B10_UINT_PACK32 = 62,
		VK_FORMAT_A2R10G10B10_SINT_PACK32 = 63,
		VK_FORMAT_A2B10G10R10_UNORM_PACK32 = 64,
		VK_FORMAT_A2B10G10R10_SNORM_PACK32 = 65,
		VK_FORMAT_A2B10G10R10_USCALED_PACK32 = 66,
		VK_FORMAT_A2B10G10R10_SSCALED_PACK32 = 67,
		VK_FORMAT_A2B10G10R10_UINT_PACK32 = 68,
		VK_FORMAT_A2B10G10R10_SINT_PACK32 = 69,
		VK_FORMAT_R16_UNORM = 70,
		VK_FORMAT_R16_SNORM = 71,
		VK_FORMAT_R16_USCALED = 72,
		VK_FORMAT_R16_SSCALED = 73,
		VK_FORMAT_R16_UINT = 74,
		VK_FORMAT_R16_SINT = 75,
		VK_FORMAT_R16_SFLOAT = 76,
		VK_FORMAT_R16G16_UNORM = 77,
		VK_FORMAT_R16G16_SNORM = 78,
		VK_FORMAT_R16G16_USCALED = 79,
		VK_FORMAT_R16G16_SSCALED = 80,
		VK_FORMAT_R16G16_UINT = 81,
		VK_FORMAT_R16G16_SINT = 82,
		VK_FORMAT_R16G16_SFLOAT = 83,
		VK_FORMAT_R16G16B16_UNORM = 84,
		VK_FORMAT_R16G16B16_SNORM = 85,
		VK_FORMAT_R16G16B16_USCALED = 86,
		VK_FORMAT_R16G16B16_SSCALED = 87,
		VK_FORMAT_R16G16B16_UINT = 88,
		VK_FORMAT_R16G16B16_SINT = 89,
		VK_FORMAT_R16G16B16_SFLOAT = 90,
		VK_FORMAT_R16G16B16A16_UNORM = 91,
		VK_FORMAT_R16G16B16A16_SNORM = 92,
		VK_FORMAT_R16G16B16A16_USCALED = 93,
		VK_FORMAT_R16G16B16A16_SSCALED = 94,
		VK_FORMAT_R16G16B16A16_UINT = 95,
		VK_FORMAT_R16G16B16A16_SINT = 96,
		VK_FORMAT_R16G16B16A16_SFLOAT = 97,
		VK_FORMAT_R32_UINT = 98,
		VK_FORMAT_R32_SINT = 99,
		VK_FORMAT_R32_SFLOAT = 100,
		VK_FORMAT_R32G32_UINT = 101,
		VK_FORMAT_R32G32_SINT = 102,
		VK_FORMAT_R32G32_SFLOAT = 103,
		VK_FORMAT_R32G32B32_UINT = 104,
		VK_FORMAT_R32G32B32_SINT = 105,
		VK_FORMAT_R32G32B32_SFLOAT = 106,
		VK_FORMAT_R32G32B32A32_UINT = 107,
		VK_FORMAT_R32G32B32A32_SINT = 108,
		VK_FORMAT_R32G32B32A32_SFLOAT = 109,
		VK_FORMAT_R64_UINT = 110,
		VK_FORMAT_R64_SINT = 111,
		VK_FORMAT_R64_SFLOAT = 112,
		VK_FORMAT_R64G64_UINT = 113,
		VK_FORMAT_R64G64_SINT = 114,
		VK_FORMAT_R64G64_SFLOAT = 115,
		VK_FORMAT_R64G64B64_UINT = 116,
		VK_FORMAT_R64G64B64_SINT = 117,
		VK_FORMAT_R64G64B64_SFLOAT = 118,
		VK_FORMAT_R64G64B64A64_UINT = 119,
		VK_FORMAT_R64G64B64A64_SINT = 120,
		VK_FORMAT_R64G64B64A64_SFLOAT = 121,
		VK_FORMAT_B10G11R11_UFLOAT_PACK32 = 122,
		VK_FORMAT_E5B9G9R9_UFLOAT_PACK32 = 123,
		VK_FORMAT_D16_UNORM = 124,
		VK_FORMAT_X8_D24_UNORM_PACK32 = 125,
		VK_FORMAT_D32_SFLOAT = 126,
		VK_FORMAT_S8_UINT = 127,
		VK_FORMAT_D16_UNORM_S8_UINT = 128,
		VK_FORMAT_D24_UNORM_S8_UINT = 129,
		VK_FORMAT_D32_SFLOAT_S8_UINT = 130,
		VK_FORMAT_BC1_RGB_UNORM_BLOCK = 131,
		VK_FORMAT_BC1_RGB_SRGB_BLOCK = 132,
		VK_FORMAT_BC1_RGBA_UNORM_BLOCK = 133,
		VK_FORMAT_BC1_RGBA_SRGB_BLOCK = 134,
		VK_FORMAT_BC2_UNORM_BLOCK = 135,
		VK_FORMAT_BC2_SRGB_BLOCK = 136,
		VK_FORMAT_BC3_UNORM_BLOCK = 137,
		VK_FORMAT_BC3_SRGB_BLOCK = 138,
		VK_FORMAT_BC4_UNORM_BLOCK = 139,
		VK_FORMAT_BC4_SNORM_BLOCK = 140,
		VK_FORMAT_BC5_UNORM_BLOCK = 141,
		VK_FORMAT_BC5_SNORM_BLOCK = 142,
		VK_FORMAT_BC6H_UFLOAT_BLOCK = 143,
		VK_FORMAT_BC6H_SFLOAT_BLOCK = 144,
		VK_FORMAT_BC7_UNORM_BLOCK = 145,
		VK_FORMAT_BC7_SRGB_BLOCK = 146,
		VK_FORMAT_ETC2_R8G8B8_UNORM_BLOCK = 147,
		VK_FORMAT_ETC2_R8G8B8_SRGB_BLOCK = 148,
		VK_FORMAT_ETC2_R8G8B8A1_UNORM_BLOCK = 149,
		VK_FORMAT_ETC2_R8G8B8A1_SRGB_BLOCK = 150,
		VK_FORMAT_ETC2_R8G8B8A8_UNORM_BLOCK = 151,
		VK_FORMAT_ETC2_R8G8B8A8_SRGB_BLOCK = 152,
		VK_FORMAT_EAC_R11_UNORM_BLOCK = 153,
		VK_FORMAT_EAC_R11_SNORM_BLOCK = 154,
		VK_FORMAT_EAC_R11G11_UNORM_BLOCK = 155,
		VK_FORMAT_EAC_R11G11_SNORM_BLOCK = 156,
		VK_FORMAT_ASTC_4x4_UNORM_BLOCK = 157,
		VK_FORMAT_ASTC_4x4_SRGB_BLOCK = 158,
		VK_FORMAT_ASTC_5x4_UNORM_BLOCK = 159,
		VK_FORMAT_ASTC_5x4_SRGB_BLOCK = 160,
		VK_FORMAT_ASTC_5x5_UNORM_BLOCK = 161,
		VK_FORMAT_ASTC_5x5_SRGB_BLOCK = 162,
		VK_FORMAT_ASTC_6x5_UNORM_BLOCK = 163,
		VK_FORMAT_ASTC_6x5_SRGB_BLOCK = 164,
		VK_FORMAT_ASTC_6x6_UNORM_BLOCK = 165,
		VK_FORMAT_ASTC_6x6_SRGB_BLOCK = 166,
		VK_FORMAT_ASTC_8x5_UNORM_BLOCK = 167,
		VK_FORMAT_ASTC_8x5_SRGB_BLOCK = 168,
		VK_FORMAT_ASTC_8x6_UNORM_BLOCK = 169,
		VK_FORMAT_ASTC_8x6_SRGB_BLOCK = 170,
		VK_FORMAT_ASTC_8x8_UNORM_BLOCK = 171,
		VK_FORMAT_ASTC_8x8_SRGB_BLOCK = 172,
		VK_FORMAT_ASTC_10x5_UNORM_BLOCK = 173,
		VK_FORMAT_ASTC_10x5_SRGB_BLOCK = 174,
		VK_FORMAT_ASTC_10x6_UNORM_BLOCK = 175,
		VK_FORMAT_ASTC_10x6_SRGB_BLOCK = 176,
		VK_FORMAT_ASTC_10x8_UNORM_BLOCK = 177,
		VK_FORMAT_ASTC_10x8_SRGB_BLOCK = 178,
		VK_FORMAT_ASTC_10x10_UNORM_BLOCK = 179,
		VK_FORMAT_ASTC_10x10_SRGB_BLOCK = 180,
		VK_FORMAT_ASTC_12x10_UNORM_BLOCK = 181,
		VK_FORMAT_ASTC_12x10_SRGB_BLOCK = 182,
		VK_FORMAT_ASTC_12x12_UNORM_BLOCK = 183,
		VK_FORMAT_ASTC_12x12_SRGB_BLOCK = 184,
		VK_FORMAT_G8B8G8R8_422_UNORM = 1000156000,
		VK_FORMAT_B8G8R8G8_422_UNORM = 1000156001,
		VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM = 1000156002,
		VK_FORMAT_G8_B8R8_2PLANE_420_UNORM = 1000156003,
		VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM = 1000156004,
		VK_FORMAT_G8_B8R8_2PLANE_422_UNORM = 1000156005,
		VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM = 1000156006,
		VK_FORMAT_R10X6_UNORM_PACK16 = 1000156007,
		VK_FORMAT_R10X6G10X6_UNORM_2PACK16 = 1000156008,
		VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16 = 1000156009,
		VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16 = 1000156010,
		VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16 = 1000156011,
		VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16 = 1000156012,
		VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16 = 1000156013,
		VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16 = 1000156014,
		VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16 = 1000156015,
		VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16 = 1000156016,
		VK_FORMAT_R12X4_UNORM_PACK16 = 1000156017,
		VK_FORMAT_R12X4G12X4_UNORM_2PACK16 = 1000156018,
		VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16 = 1000156019,
		VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16 = 1000156020,
		VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16 = 1000156021,
		VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16 = 1000156022,
		VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16 = 1000156023,
		VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16 = 1000156024,
		VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16 = 1000156025,
		VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16 = 1000156026,
		VK_FORMAT_G16B16G16R16_422_UNORM = 1000156027,
		VK_FORMAT_B16G16R16G16_422_UNORM = 1000156028,
		VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM = 1000156029,
		VK_FORMAT_G16_B16R16_2PLANE_420_UNORM = 1000156030,
		VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM = 1000156031,
		VK_FORMAT_G16_B16R16_2PLANE_422_UNORM = 1000156032,
		VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM = 1000156033,
		VK_FORMAT_PVRTC1_2BPP_UNORM_BLOCK_IMG = 1000054000,
		VK_FORMAT_PVRTC1_4BPP_UNORM_BLOCK_IMG = 1000054001,
		VK_FORMAT_PVRTC2_2BPP_UNORM_BLOCK_IMG = 1000054002,
		VK_FORMAT_PVRTC2_4BPP_UNORM_BLOCK_IMG = 1000054003,
		VK_FORMAT_PVRTC1_2BPP_SRGB_BLOCK_IMG = 1000054004,
		VK_FORMAT_PVRTC1_4BPP_SRGB_BLOCK_IMG = 1000054005,
		VK_FORMAT_PVRTC2_2BPP_SRGB_BLOCK_IMG = 1000054006,
		VK_FORMAT_PVRTC2_4BPP_SRGB_BLOCK_IMG = 1000054007,
		VK_FORMAT_G8B8G8R8_422_UNORM_KHR = VK_FORMAT_G8B8G8R8_422_UNORM,
		VK_FORMAT_B8G8R8G8_422_UNORM_KHR = VK_FORMAT_B8G8R8G8_422_UNORM,
		VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM_KHR = VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM,
		VK_FORMAT_G8_B8R8_2PLANE_420_UNORM_KHR = VK_FORMAT_G8_B8R8_2PLANE_420_UNORM,
		VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM_KHR = VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM,
		VK_FORMAT_G8_B8R8_2PLANE_422_UNORM_KHR = VK_FORMAT_G8_B8R8_2PLANE_422_UNORM,
		VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM_KHR = VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM,
		VK_FORMAT_R10X6_UNORM_PACK16_KHR = VK_FORMAT_R10X6_UNORM_PACK16,
		VK_FORMAT_R10X6G10X6_UNORM_2PACK16_KHR = VK_FORMAT_R10X6G10X6_UNORM_2PACK16,
		VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16_KHR = VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16,
		VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16_KHR = VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16,
		VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16_KHR = VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16,
		VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16_KHR = VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16,
		VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16_KHR = VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16,
		VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16_KHR = VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16,
		VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16_KHR = VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16,
		VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16_KHR = VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16,
		VK_FORMAT_R12X4_UNORM_PACK16_KHR = VK_FORMAT_R12X4_UNORM_PACK16,
		VK_FORMAT_R12X4G12X4_UNORM_2PACK16_KHR = VK_FORMAT_R12X4G12X4_UNORM_2PACK16,
		VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16_KHR = VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16,
		VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16_KHR = VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16,
		VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16_KHR = VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16,
		VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16_KHR = VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16,
		VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16_KHR = VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16,
		VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16_KHR = VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16,
		VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16_KHR = VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16,
		VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16_KHR = VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16,
		VK_FORMAT_G16B16G16R16_422_UNORM_KHR = VK_FORMAT_G16B16G16R16_422_UNORM,
		VK_FORMAT_B16G16R16G16_422_UNORM_KHR = VK_FORMAT_B16G16R16G16_422_UNORM,
		VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM_KHR = VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM,
		VK_FORMAT_G16_B16R16_2PLANE_420_UNORM_KHR = VK_FORMAT_G16_B16R16_2PLANE_420_UNORM,
		VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM_KHR = VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM,
		VK_FORMAT_G16_B16R16_2PLANE_422_UNORM_KHR = VK_FORMAT_G16_B16R16_2PLANE_422_UNORM,
		VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM_KHR = VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM,
	} VkFormat;
	// https://github.com/servo/pixman/blob/958bd334b3c17f529c80f2eeef4224f45c62f292/pixman/pixman.h#L497-L523
	typedef struct pixman_region32_data	pixman_region32_data_t;
	typedef struct pixman_box32 pixman_box32_t;
	typedef struct pixman_rectangle32	pixman_rectangle32_t;
	typedef struct pixman_region32 pixman_region32_t;
	struct pixman_box32 {
		int32_t x1, y1, x2, y2;
	};
	struct pixman_region32 {
		pixman_box32_t          extents;
		pixman_region32_data_t  *data;
	};
	typedef union pixman_image pixman_image_t;
	// https://github.com/Simplewyl2000/stratovirt/blob/d6ca27a8ebd8e6b93ac41e6fde6eed95d481f5ac/util/src/pixman.rs#L41
	typedef enum {
		PIXMAN_a8r8g8b8 = 537036936,
		PIXMAN_x8r8g8b8 = 537004168,
		PIXMAN_a8b8g8r8 = 537102472,
		PIXMAN_x8b8g8r8 = 537069704,
		PIXMAN_b8g8r8a8 = 537430152,
		PIXMAN_b8g8r8x8 = 537397384,
		PIXMAN_r8g8b8a8 = 537495688,
		PIXMAN_r8g8b8x8 = 537462920,
		PIXMAN_x14r6g6b6 = 537003622,
		PIXMAN_x2r10g10b10 = 537004714,
		PIXMAN_a2r10g10b10 = 537012906,
		PIXMAN_x2b10g10r10 = 537070250,
		PIXMAN_a2b10g10r10 = 537078442,
		PIXMAN_a8r8g8b8_sRGB = 537561224,
		PIXMAN_r8g8b8 = 402786440,
		PIXMAN_b8g8r8 = 402851976,
		PIXMAN_r5g6b5 = 268567909,
		PIXMAN_b5g6r5 = 268633445,
		PIXMAN_a1r5g5b5 = 268571989,
		PIXMAN_x1r5g5b5 = 268567893,
		PIXMAN_a1b5g5r5 = 268637525,
		PIXMAN_x1b5g5r5 = 268633429,
		PIXMAN_a4r4g4b4 = 268584004,
		PIXMAN_x4r4g4b4 = 268567620,
		PIXMAN_a4b4g4r4 = 268649540,
		PIXMAN_x4b4g4r4 = 268633156,
		PIXMAN_a8 = 134316032,
		PIXMAN_r3g3b2 = 134349618,
		PIXMAN_b2g3r3 = 134415154,
		PIXMAN_a2r2g2b2 = 134357538,
		PIXMAN_a2b2g2r2 = 134423074,
		PIXMAN_c8 = 134479872,
		PIXMAN_g8 = 134545408,
		PIXMAN_x4a4 = 134299648,
		PIXMAN_a4 = 67190784,
		PIXMAN_r1g2b1 = 67240225,
		PIXMAN_b1g2r1 = 67305761,
		PIXMAN_a1r1g1b1 = 67244305,
		PIXMAN_a1b1g1r1 = 67309841,
		PIXMAN_c4 = 67371008,
		PIXMAN_g4 = 67436544,
		PIXMAN_a1 = 16846848,
		PIXMAN_g1 = 17104896,
		PIXMAN_yuy2 = 268828672,
		PIXMAN_yv12 = 201785344,
	} pixman_format_code_t;
typedef long unsigned int size_t;
typedef unsigned char __u_char;
typedef unsigned short int __u_short;
typedef unsigned int __u_int;
typedef unsigned long int __u_long;
typedef signed char __int8_t;
typedef unsigned char __uint8_t;
typedef signed short int __int16_t;
typedef unsigned short int __uint16_t;
typedef signed int __int32_t;
typedef unsigned int __uint32_t;
typedef signed long int __int64_t;
typedef unsigned long int __uint64_t;
typedef __int8_t __int_least8_t;
typedef __uint8_t __uint_least8_t;
typedef __int16_t __int_least16_t;
typedef __uint16_t __uint_least16_t;
typedef __int32_t __int_least32_t;
typedef __uint32_t __uint_least32_t;
typedef __int64_t __int_least64_t;
typedef __uint64_t __uint_least64_t;
typedef long int __quad_t;
typedef unsigned long int __u_quad_t;
typedef long int __intmax_t;
typedef unsigned long int __uintmax_t;
typedef unsigned long int __dev_t;
typedef unsigned int __uid_t;
typedef unsigned int __gid_t;
typedef unsigned long int __ino_t;
typedef unsigned long int __ino64_t;
typedef unsigned int __mode_t;
typedef unsigned long int __nlink_t;
typedef long int __off_t;
typedef long int __off64_t;
typedef int __pid_t;
typedef struct { int __val[2]; } __fsid_t;
typedef long int __clock_t;
typedef unsigned long int __rlim_t;
typedef unsigned long int __rlim64_t;
typedef unsigned int __id_t;
typedef long int __time_t;
typedef unsigned int __useconds_t;
typedef long int __suseconds_t;
typedef long int __suseconds64_t;
typedef int __daddr_t;
typedef int __key_t;
typedef int __clockid_t;
typedef void * __timer_t;
typedef long int __blksize_t;
typedef long int __blkcnt_t;
typedef long int __blkcnt64_t;
typedef unsigned long int __fsblkcnt_t;
typedef unsigned long int __fsblkcnt64_t;
typedef unsigned long int __fsfilcnt_t;
typedef unsigned long int __fsfilcnt64_t;
typedef long int __fsword_t;
typedef long int __ssize_t;
typedef long int __syscall_slong_t;
typedef unsigned long int __syscall_ulong_t;
typedef __off64_t __loff_t;
typedef char *__caddr_t;
typedef long int __intptr_t;
typedef unsigned int __socklen_t;
typedef int __sig_atomic_t;
typedef __clock_t clock_t;
typedef __time_t time_t;
struct tm
{
  int tm_sec;
  int tm_min;
  int tm_hour;
  int tm_mday;
  int tm_mon;
  int tm_year;
  int tm_wday;
  int tm_yday;
  int tm_isdst;
  long int tm_gmtoff;
  const char *tm_zone;
};
struct timespec
{
  __time_t tv_sec;
  __syscall_slong_t tv_nsec;
};
typedef __clockid_t clockid_t;
typedef __timer_t timer_t;
struct itimerspec
  {
    struct timespec it_interval;
    struct timespec it_value;
  };
struct sigevent;
typedef __pid_t pid_t;
struct __locale_struct
{
  struct __locale_data *__locales[13];
  const unsigned short int *__ctype_b;
  const int *__ctype_tolower;
  const int *__ctype_toupper;
  const char *__names[13];
};
typedef struct __locale_struct *__locale_t;
typedef __locale_t locale_t;
typedef __int8_t int8_t;
typedef __int16_t int16_t;
typedef __int32_t int32_t;
typedef __int64_t int64_t;
typedef __uint8_t uint8_t;
typedef __uint16_t uint16_t;
typedef __uint32_t uint32_t;
typedef __uint64_t uint64_t;
typedef __int_least8_t int_least8_t;
typedef __int_least16_t int_least16_t;
typedef __int_least32_t int_least32_t;
typedef __int_least64_t int_least64_t;
typedef __uint_least8_t uint_least8_t;
typedef __uint_least16_t uint_least16_t;
typedef __uint_least32_t uint_least32_t;
typedef __uint_least64_t uint_least64_t;
typedef signed char int_fast8_t;
typedef long int int_fast16_t;
typedef long int int_fast32_t;
typedef long int int_fast64_t;
typedef unsigned char uint_fast8_t;
typedef unsigned long int uint_fast16_t;
typedef unsigned long int uint_fast32_t;
typedef unsigned long int uint_fast64_t;
typedef long int intptr_t;
typedef unsigned long int uintptr_t;
typedef __intmax_t intmax_t;
typedef __uintmax_t uintmax_t;
struct wlr_box {
 int x, y;
 int width, height;
};
struct wlr_fbox {
 double x, y;
 double width, height;
};
void wlr_box_closest_point(const struct wlr_box *box, double x, double y,
 double *dest_x, double *dest_y);
_Bool
    wlr_box_intersection(struct wlr_box *dest, const struct wlr_box *box_a,
 const struct wlr_box *box_b);
_Bool
    wlr_box_contains_point(const struct wlr_box *box, double x, double y);
_Bool
    wlr_box_empty(const struct wlr_box *box);
void wlr_box_transform(struct wlr_box *dest, const struct wlr_box *box,
 enum wl_output_transform transform, int width, int height);
_Bool
    wlr_fbox_empty(const struct wlr_fbox *box);
void wlr_fbox_transform(struct wlr_fbox *dest, const struct wlr_fbox *box,
 enum wl_output_transform transform, double width, double height);
_Bool
    wlr_box_equal(const struct wlr_box *a, const struct wlr_box *b);
_Bool
    wlr_fbox_equal(const struct wlr_fbox *a, const struct wlr_fbox *b);
struct wlr_renderer;
struct wlr_buffer;
struct wlr_render_pass;
struct wlr_render_timer;
struct wlr_buffer_pass_options {
 struct wlr_render_timer *timer;
 struct wlr_color_transform *color_transform;
};
struct wlr_render_pass *wlr_renderer_begin_buffer_pass(struct wlr_renderer *renderer,
 struct wlr_buffer *buffer, const struct wlr_buffer_pass_options *options);
_Bool
    wlr_render_pass_submit(struct wlr_render_pass *render_pass);
enum wlr_render_blend_mode {
 WLR_RENDER_BLEND_MODE_PREMULTIPLIED,
 WLR_RENDER_BLEND_MODE_NONE,
};
enum wlr_scale_filter_mode {
 WLR_SCALE_FILTER_BILINEAR,
 WLR_SCALE_FILTER_NEAREST,
};
struct wlr_render_texture_options {
 struct wlr_texture *texture;
 struct wlr_fbox src_box;
 struct wlr_box dst_box;
 const float *alpha;
 const pixman_region32_t *clip;
 enum wl_output_transform transform;
 enum wlr_scale_filter_mode filter_mode;
 enum wlr_render_blend_mode blend_mode;
};
void wlr_render_pass_add_texture(struct wlr_render_pass *render_pass,
 const struct wlr_render_texture_options *options);
struct wlr_render_color {
 float r, g, b, a;
};
struct wlr_render_rect_options {
 struct wlr_box box;
 struct wlr_render_color color;
 const pixman_region32_t *clip;
 enum wlr_render_blend_mode blend_mode;
};
void wlr_render_pass_add_rect(struct wlr_render_pass *render_pass,
 const struct wlr_render_rect_options *options);
struct wlr_dmabuf_attributes {
 int32_t width, height;
 uint32_t format;
 uint64_t modifier;
 int n_planes;
 uint32_t offset[4];
 uint32_t stride[4];
 int fd[4];
};
void wlr_dmabuf_attributes_finish(struct wlr_dmabuf_attributes *attribs);
_Bool
    wlr_dmabuf_attributes_copy(struct wlr_dmabuf_attributes *dst,
 const struct wlr_dmabuf_attributes *src);
struct wlr_buffer;
struct wlr_renderer;
struct wlr_texture_impl;
struct wlr_texture {
 const struct wlr_texture_impl *impl;
 uint32_t width, height;
 struct wlr_renderer *renderer;
};
struct wlr_texture_read_pixels_options {
 void *data;
 uint32_t format;
 uint32_t stride;
 uint32_t dst_x, dst_y;
 const struct wlr_box src_box;
};
_Bool
    wlr_texture_read_pixels(struct wlr_texture *texture,
 const struct wlr_texture_read_pixels_options *options);
uint32_t wlr_texture_preferred_read_format(struct wlr_texture *texture);
struct wlr_texture *wlr_texture_from_pixels(struct wlr_renderer *renderer,
 uint32_t fmt, uint32_t stride, uint32_t width, uint32_t height,
 const void *data);
struct wlr_texture *wlr_texture_from_dmabuf(struct wlr_renderer *renderer,
 struct wlr_dmabuf_attributes *attribs);
_Bool
    wlr_texture_update_from_buffer(struct wlr_texture *texture,
 struct wlr_buffer *buffer, const pixman_region32_t *damage);
void wlr_texture_destroy(struct wlr_texture *texture);
struct wlr_texture *wlr_texture_from_buffer(struct wlr_renderer *renderer,
 struct wlr_buffer *buffer);
struct wlr_backend;
struct wlr_renderer_impl;
struct wlr_drm_format_set;
struct wlr_buffer;
struct wlr_box;
struct wlr_fbox;
struct wlr_renderer {
 uint32_t render_buffer_caps;
 struct {
  struct wl_signal destroy;
  struct wl_signal lost;
 } events;
 struct {
 _Bool
      output_color_transform;
 } features;
 const struct wlr_renderer_impl *impl;
};
struct wlr_renderer *wlr_renderer_autocreate(struct wlr_backend *backend);
const struct wlr_drm_format_set *wlr_renderer_get_texture_formats(
 struct wlr_renderer *r, uint32_t buffer_caps);
_Bool
    wlr_renderer_init_wl_display(struct wlr_renderer *r,
 struct wl_display *wl_display);
_Bool
    wlr_renderer_init_wl_shm(struct wlr_renderer *r,
 struct wl_display *wl_display);
int wlr_renderer_get_drm_fd(struct wlr_renderer *r);
void wlr_renderer_destroy(struct wlr_renderer *renderer);
struct wlr_render_timer *wlr_render_timer_create(struct wlr_renderer *renderer);
int wlr_render_timer_get_duration_ns(struct wlr_render_timer *timer);
void wlr_render_timer_destroy(struct wlr_render_timer *timer);
struct wlr_addon_set {
 struct wl_list addons;
};
struct wlr_addon;
struct wlr_addon_interface {
 const char *name;
 void (*destroy)(struct wlr_addon *addon);
};
struct wlr_addon {
 const struct wlr_addon_interface *impl;
 const void *owner;
 struct wl_list link;
};
void wlr_addon_set_init(struct wlr_addon_set *set);
void wlr_addon_set_finish(struct wlr_addon_set *set);
void wlr_addon_init(struct wlr_addon *addon, struct wlr_addon_set *set,
 const void *owner, const struct wlr_addon_interface *impl);
void wlr_addon_finish(struct wlr_addon *addon);
struct wlr_addon *wlr_addon_find(struct wlr_addon_set *set, const void *owner,
 const struct wlr_addon_interface *impl);
struct wlr_buffer;
struct wlr_renderer;
struct wlr_shm_attributes {
 int fd;
 uint32_t format;
 int width, height, stride;
 off_t offset;
};
enum wlr_buffer_cap {
 WLR_BUFFER_CAP_DATA_PTR = 1 << 0,
 WLR_BUFFER_CAP_DMABUF = 1 << 1,
 WLR_BUFFER_CAP_SHM = 1 << 2,
};
struct wlr_buffer {
 const struct wlr_buffer_impl *impl;
 int width, height;
_Bool
     dropped;
 size_t n_locks;
_Bool
     accessing_data_ptr;
 struct {
  struct wl_signal destroy;
  struct wl_signal release;
 } events;
 struct wlr_addon_set addons;
};
void wlr_buffer_drop(struct wlr_buffer *buffer);
struct wlr_buffer *wlr_buffer_lock(struct wlr_buffer *buffer);
void wlr_buffer_unlock(struct wlr_buffer *buffer);
_Bool
    wlr_buffer_get_dmabuf(struct wlr_buffer *buffer,
 struct wlr_dmabuf_attributes *attribs);
_Bool
    wlr_buffer_get_shm(struct wlr_buffer *buffer,
 struct wlr_shm_attributes *attribs);
struct wlr_buffer *wlr_buffer_try_from_resource(struct wl_resource *resource);
enum wlr_buffer_data_ptr_access_flag {
 WLR_BUFFER_DATA_PTR_ACCESS_READ = 1 << 0,
 WLR_BUFFER_DATA_PTR_ACCESS_WRITE = 1 << 1,
};
_Bool
    wlr_buffer_begin_data_ptr_access(struct wlr_buffer *buffer, uint32_t flags,
 void **data, uint32_t *format, size_t *stride);
void wlr_buffer_end_data_ptr_access(struct wlr_buffer *buffer);
struct wlr_client_buffer {
 struct wlr_buffer base;
 struct wlr_texture *texture;
 struct wlr_buffer *source;
 struct wl_listener source_destroy;
 struct wl_listener renderer_destroy;
 size_t n_ignore_locks;
};
struct wlr_client_buffer *wlr_client_buffer_get(struct wlr_buffer *buffer);
enum wlr_output_mode_aspect_ratio {
 WLR_OUTPUT_MODE_ASPECT_RATIO_NONE,
 WLR_OUTPUT_MODE_ASPECT_RATIO_4_3,
 WLR_OUTPUT_MODE_ASPECT_RATIO_16_9,
 WLR_OUTPUT_MODE_ASPECT_RATIO_64_27,
 WLR_OUTPUT_MODE_ASPECT_RATIO_256_135,
};
struct wlr_output_mode {
 int32_t width, height;
 int32_t refresh;
_Bool
     preferred;
 enum wlr_output_mode_aspect_ratio picture_aspect_ratio;
 struct wl_list link;
};
struct wlr_output_cursor {
 struct wlr_output *output;
 double x, y;
_Bool
     enabled;
_Bool
     visible;
 uint32_t width, height;
 struct wlr_fbox src_box;
 enum wl_output_transform transform;
 int32_t hotspot_x, hotspot_y;
 struct wlr_texture *texture;
_Bool
     own_texture;
 struct wl_listener renderer_destroy;
 struct wl_list link;
};
enum wlr_output_adaptive_sync_status {
 WLR_OUTPUT_ADAPTIVE_SYNC_DISABLED,
 WLR_OUTPUT_ADAPTIVE_SYNC_ENABLED,
};
enum wlr_output_state_field {
 WLR_OUTPUT_STATE_BUFFER = 1 << 0,
 WLR_OUTPUT_STATE_DAMAGE = 1 << 1,
 WLR_OUTPUT_STATE_MODE = 1 << 2,
 WLR_OUTPUT_STATE_ENABLED = 1 << 3,
 WLR_OUTPUT_STATE_SCALE = 1 << 4,
 WLR_OUTPUT_STATE_TRANSFORM = 1 << 5,
 WLR_OUTPUT_STATE_ADAPTIVE_SYNC_ENABLED = 1 << 6,
 WLR_OUTPUT_STATE_GAMMA_LUT = 1 << 7,
 WLR_OUTPUT_STATE_RENDER_FORMAT = 1 << 8,
 WLR_OUTPUT_STATE_SUBPIXEL = 1 << 9,
 WLR_OUTPUT_STATE_LAYERS = 1 << 10,
};
enum wlr_output_state_mode_type {
 WLR_OUTPUT_STATE_MODE_FIXED,
 WLR_OUTPUT_STATE_MODE_CUSTOM,
};
struct wlr_output_state {
 uint32_t committed;
_Bool
     allow_reconfiguration;
 pixman_region32_t damage;
_Bool
     enabled;
 float scale;
 enum wl_output_transform transform;
_Bool
     adaptive_sync_enabled;
 uint32_t render_format;
 enum wl_output_subpixel subpixel;
 struct wlr_buffer *buffer;
_Bool
     tearing_page_flip;
 enum wlr_output_state_mode_type mode_type;
 struct wlr_output_mode *mode;
 struct {
  int32_t width, height;
  int32_t refresh;
 } custom_mode;
 uint16_t *gamma_lut;
 size_t gamma_lut_size;
 struct wlr_output_layer_state *layers;
 size_t layers_len;
};
struct wlr_output_impl;
struct wlr_render_pass;
struct wlr_output {
 const struct wlr_output_impl *impl;
 struct wlr_backend *backend;
 struct wl_event_loop *event_loop;
 struct wl_global *global;
 struct wl_list resources;
 char *name;
 char *description;
 char *make, *model, *serial;
 int32_t phys_width, phys_height;
 struct wl_list modes;
 struct wlr_output_mode *current_mode;
 int32_t width, height;
 int32_t refresh;
_Bool
     enabled;
 float scale;
 enum wl_output_subpixel subpixel;
 enum wl_output_transform transform;
 enum wlr_output_adaptive_sync_status adaptive_sync_status;
 uint32_t render_format;
_Bool
     adaptive_sync_supported;
_Bool
     needs_frame;
_Bool
     frame_pending;
_Bool
     non_desktop;
 uint32_t commit_seq;
 struct {
  struct wl_signal frame;
  struct wl_signal damage;
  struct wl_signal needs_frame;
  struct wl_signal precommit;
  struct wl_signal commit;
  struct wl_signal present;
  struct wl_signal bind;
  struct wl_signal description;
  struct wl_signal request_state;
  struct wl_signal destroy;
 } events;
 struct wl_event_source *idle_frame;
 struct wl_event_source *idle_done;
 int attach_render_locks;
 struct wl_list cursors;
 struct wlr_output_cursor *hardware_cursor;
 struct wlr_swapchain *cursor_swapchain;
 struct wlr_buffer *cursor_front_buffer;
 int software_cursor_locks;
 struct wl_list layers;
 struct wlr_allocator *allocator;
 struct wlr_renderer *renderer;
 struct wlr_swapchain *swapchain;
 struct wl_listener display_destroy;
 struct wlr_addon_set addons;
 void *data;
};
struct wlr_output_event_damage {
 struct wlr_output *output;
 const pixman_region32_t *damage;
};
struct wlr_output_event_precommit {
 struct wlr_output *output;
 struct timespec *when;
 const struct wlr_output_state *state;
};
struct wlr_output_event_commit {
 struct wlr_output *output;
 struct timespec *when;
 const struct wlr_output_state *state;
};
enum wlr_output_present_flag {
 WLR_OUTPUT_PRESENT_VSYNC = 0x1,
 WLR_OUTPUT_PRESENT_HW_CLOCK = 0x2,
 WLR_OUTPUT_PRESENT_HW_COMPLETION = 0x4,
 WLR_OUTPUT_PRESENT_ZERO_COPY = 0x8,
};
struct wlr_output_event_present {
 struct wlr_output *output;
 uint32_t commit_seq;
_Bool
     presented;
 struct timespec *when;
 unsigned seq;
 int refresh;
 uint32_t flags;
};
struct wlr_output_event_bind {
 struct wlr_output *output;
 struct wl_resource *resource;
};
struct wlr_output_event_request_state {
 struct wlr_output *output;
 const struct wlr_output_state *state;
};
struct wlr_surface;
void wlr_output_create_global(struct wlr_output *output, struct wl_display *display);
void wlr_output_destroy_global(struct wlr_output *output);
_Bool
    wlr_output_init_render(struct wlr_output *output,
 struct wlr_allocator *allocator, struct wlr_renderer *renderer);
struct wlr_output_mode *wlr_output_preferred_mode(struct wlr_output *output);
void wlr_output_set_name(struct wlr_output *output, const char *name);
void wlr_output_set_description(struct wlr_output *output, const char *desc);
void wlr_output_schedule_done(struct wlr_output *output);
void wlr_output_destroy(struct wlr_output *output);
void wlr_output_transformed_resolution(struct wlr_output *output,
 int *width, int *height);
void wlr_output_effective_resolution(struct wlr_output *output,
 int *width, int *height);
_Bool
    wlr_output_test_state(struct wlr_output *output,
 const struct wlr_output_state *state);
_Bool
    wlr_output_commit_state(struct wlr_output *output,
 const struct wlr_output_state *state);
void wlr_output_schedule_frame(struct wlr_output *output);
size_t wlr_output_get_gamma_size(struct wlr_output *output);
struct wlr_output *wlr_output_from_resource(struct wl_resource *resource);
void wlr_output_lock_attach_render(struct wlr_output *output,
                                                             _Bool
                                                                  lock);
void wlr_output_lock_software_cursors(struct wlr_output *output,
                                                                _Bool
                                                                     lock);
void wlr_output_render_software_cursors(struct wlr_output *output,
 const pixman_region32_t *damage);
void wlr_output_add_software_cursors_to_render_pass(struct wlr_output *output,
 struct wlr_render_pass *render_pass, const pixman_region32_t *damage);
const struct wlr_drm_format_set *wlr_output_get_primary_formats(
 struct wlr_output *output, uint32_t buffer_caps);
_Bool
    wlr_output_is_direct_scanout_allowed(struct wlr_output *output);
struct wlr_output_cursor *wlr_output_cursor_create(struct wlr_output *output);
_Bool
    wlr_output_cursor_set_buffer(struct wlr_output_cursor *cursor,
 struct wlr_buffer *buffer, int32_t hotspot_x, int32_t hotspot_y);
_Bool
    wlr_output_cursor_move(struct wlr_output_cursor *cursor,
 double x, double y);
void wlr_output_cursor_destroy(struct wlr_output_cursor *cursor);
void wlr_output_state_init(struct wlr_output_state *state);
void wlr_output_state_finish(struct wlr_output_state *state);
void wlr_output_state_set_enabled(struct wlr_output_state *state,
_Bool
     enabled);
void wlr_output_state_set_mode(struct wlr_output_state *state,
 struct wlr_output_mode *mode);
void wlr_output_state_set_custom_mode(struct wlr_output_state *state,
 int32_t width, int32_t height, int32_t refresh);
void wlr_output_state_set_scale(struct wlr_output_state *state, float scale);
void wlr_output_state_set_transform(struct wlr_output_state *state,
 enum wl_output_transform transform);
void wlr_output_state_set_adaptive_sync_enabled(struct wlr_output_state *state,
_Bool
     enabled);
void wlr_output_state_set_render_format(struct wlr_output_state *state,
 uint32_t format);
void wlr_output_state_set_subpixel(struct wlr_output_state *state,
 enum wl_output_subpixel subpixel);
void wlr_output_state_set_buffer(struct wlr_output_state *state,
 struct wlr_buffer *buffer);
_Bool
    wlr_output_state_set_gamma_lut(struct wlr_output_state *state,
 size_t ramp_size, const uint16_t *r, const uint16_t *g, const uint16_t *b);
void wlr_output_state_set_damage(struct wlr_output_state *state,
 const pixman_region32_t *damage);
void wlr_output_state_set_layers(struct wlr_output_state *state,
 struct wlr_output_layer_state *layers, size_t layers_len);
_Bool
    wlr_output_state_copy(struct wlr_output_state *dst,
 const struct wlr_output_state *src);
_Bool
    wlr_output_configure_primary_swapchain(struct wlr_output *output,
 const struct wlr_output_state *state, struct wlr_swapchain **swapchain);
struct wlr_render_pass *wlr_output_begin_render_pass(struct wlr_output *output,
 struct wlr_output_state *state, int *buffer_age,
 struct wlr_buffer_pass_options *render_options);
struct wlr_session;
struct wlr_backend_impl;
struct wlr_backend_output_state {
 struct wlr_output *output;
 struct wlr_output_state base;
};
struct wlr_backend {
 const struct wlr_backend_impl *impl;
 struct {
  struct wl_signal destroy;
  struct wl_signal new_input;
  struct wl_signal new_output;
 } events;
};
struct wlr_backend *wlr_backend_autocreate(struct wl_event_loop *loop,
 struct wlr_session **session_ptr);
_Bool
    wlr_backend_start(struct wlr_backend *backend);
void wlr_backend_destroy(struct wlr_backend *backend);
int wlr_backend_get_drm_fd(struct wlr_backend *backend);
_Bool
    wlr_backend_test(struct wlr_backend *backend,
 const struct wlr_backend_output_state *states, size_t states_len);
_Bool
    wlr_backend_commit(struct wlr_backend *backend,
 const struct wlr_backend_output_state *states, size_t states_len);
typedef __u_char u_char;
typedef __u_short u_short;
typedef __u_int u_int;
typedef __u_long u_long;
typedef __quad_t quad_t;
typedef __u_quad_t u_quad_t;
typedef __fsid_t fsid_t;
typedef __loff_t loff_t;
typedef __ino_t ino_t;
typedef __dev_t dev_t;
typedef __gid_t gid_t;
typedef __mode_t mode_t;
typedef __nlink_t nlink_t;
typedef __uid_t uid_t;
typedef __off_t off_t;
typedef __id_t id_t;
typedef __ssize_t ssize_t;
typedef __daddr_t daddr_t;
typedef __caddr_t caddr_t;
typedef __key_t key_t;
typedef unsigned long int ulong;
typedef unsigned short int ushort;
typedef unsigned int uint;
typedef __uint8_t u_int8_t;
typedef __uint16_t u_int16_t;
typedef __uint32_t u_int32_t;
typedef __uint64_t u_int64_t;
typedef int register_t __attribute__ ((__mode__ (__word__)));
__inline __uint16_t
__bswap_16 (__uint16_t __bsx)
{
  return __builtin_bswap16 (__bsx);
}
__inline __uint32_t
__bswap_32 (__uint32_t __bsx)
{
  return __builtin_bswap32 (__bsx);
}
__extension__ __inline __uint64_t
__bswap_64 (__uint64_t __bsx)
{
  return __builtin_bswap64 (__bsx);
}
__inline __uint16_t
__uint16_identity (__uint16_t __x)
{
  return __x;
}
__inline __uint32_t
__uint32_identity (__uint32_t __x)
{
  return __x;
}
__inline __uint64_t
__uint64_identity (__uint64_t __x)
{
  return __x;
}
typedef struct
{
  unsigned long int __val[(1024 / (8 * sizeof (unsigned long int)))];
} __sigset_t;
typedef __sigset_t sigset_t;
struct timeval
{
  __time_t tv_sec;
  __suseconds_t tv_usec;
};
typedef __suseconds_t suseconds_t;
typedef long int __fd_mask;
typedef struct
  {
    __fd_mask __fds_bits[1024 / (8 * (int) sizeof (__fd_mask))];
  } fd_set;
typedef __fd_mask fd_mask;
typedef __blksize_t blksize_t;
typedef __blkcnt_t blkcnt_t;
typedef __fsblkcnt_t fsblkcnt_t;
typedef __fsfilcnt_t fsfilcnt_t;
typedef union
{
  __extension__ unsigned long long int __value64;
  struct
  {
    unsigned int __low;
    unsigned int __high;
  } __value32;
} __atomic_wide_counter;
typedef struct __pthread_internal_list
{
  struct __pthread_internal_list *__prev;
  struct __pthread_internal_list *__next;
} __pthread_list_t;
typedef struct __pthread_internal_slist
{
  struct __pthread_internal_slist *__next;
} __pthread_slist_t;
struct __pthread_mutex_s
{
  int __lock;
  unsigned int __count;
  int __owner;
  unsigned int __nusers;
  int __kind;
  short __spins;
  short __elision;
  __pthread_list_t __list;
};
struct __pthread_rwlock_arch_t
{
  unsigned int __readers;
  unsigned int __writers;
  unsigned int __wrphase_futex;
  unsigned int __writers_futex;
  unsigned int __pad3;
  unsigned int __pad4;
  int __cur_writer;
  int __shared;
  signed char __rwelision;
  unsigned char __pad1[7];
  unsigned long int __pad2;
  unsigned int __flags;
};
struct __pthread_cond_s
{
  __atomic_wide_counter __wseq;
  __atomic_wide_counter __g1_start;
  unsigned int __g_refs[2] ;
  unsigned int __g_size[2];
  unsigned int __g1_orig_size;
  unsigned int __wrefs;
  unsigned int __g_signals[2];
};
typedef unsigned int __tss_t;
typedef unsigned long int __thrd_t;
typedef struct
{
  int __data ;
} __once_flag;
typedef unsigned long int pthread_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_mutexattr_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_condattr_t;
typedef unsigned int pthread_key_t;
typedef int pthread_once_t;
union pthread_attr_t
{
  char __size[56];
  long int __align;
};
typedef union pthread_attr_t pthread_attr_t;
typedef union
{
  struct __pthread_mutex_s __data;
  char __size[40];
  long int __align;
} pthread_mutex_t;
typedef union
{
  struct __pthread_cond_s __data;
  char __size[48];
  __extension__ long long int __align;
} pthread_cond_t;
typedef union
{
  struct __pthread_rwlock_arch_t __data;
  char __size[56];
  long int __align;
} pthread_rwlock_t;
typedef union
{
  char __size[8];
  long int __align;
} pthread_rwlockattr_t;
typedef volatile int pthread_spinlock_t;
typedef union
{
  char __size[32];
  long int __align;
} pthread_barrier_t;
typedef union
{
  char __size[4];
  int __align;
} pthread_barrierattr_t;
struct libseat;
struct wlr_device {
 int fd;
 int device_id;
 dev_t dev;
 struct wl_list link;
 struct {
  struct wl_signal change;
  struct wl_signal remove;
 } events;
};
struct wlr_session {
_Bool
     active;
 unsigned vtnr;
 char seat[256];
 struct udev *udev;
 struct udev_monitor *mon;
 struct wl_event_source *udev_event;
 struct libseat *seat_handle;
 struct wl_event_source *libseat_event;
 struct wl_list devices;
 struct wl_event_loop *event_loop;
 struct wl_listener event_loop_destroy;
 struct {
  struct wl_signal active;
  struct wl_signal add_drm_card;
  struct wl_signal destroy;
 } events;
};
struct wlr_session_add_event {
 const char *path;
};
enum wlr_device_change_type {
 WLR_DEVICE_HOTPLUG = 1,
 WLR_DEVICE_LEASE,
};
struct wlr_device_hotplug_event {
 uint32_t connector_id;
 uint32_t prop_id;
};
struct wlr_device_change_event {
 enum wlr_device_change_type type;
 union {
  struct wlr_device_hotplug_event hotplug;
 };
};
struct wlr_session *wlr_session_create(struct wl_event_loop *loop);
void wlr_session_destroy(struct wlr_session *session);
struct wlr_device *wlr_session_open_file(struct wlr_session *session,
 const char *path);
void wlr_session_close_file(struct wlr_session *session,
 struct wlr_device *device);
_Bool
    wlr_session_change_vt(struct wlr_session *session, unsigned vt);
ssize_t wlr_session_find_gpus(struct wlr_session *session,
 size_t ret_len, struct wlr_device **ret);
struct wlr_drm_backend;
typedef struct _drmModeModeInfo drmModeModeInfo;
struct wlr_drm_lease {
 int fd;
 uint32_t lessee_id;
 struct wlr_drm_backend *backend;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_backend *wlr_drm_backend_create(struct wlr_session *session,
 struct wlr_device *dev, struct wlr_backend *parent);
_Bool
    wlr_backend_is_drm(struct wlr_backend *backend);
_Bool
    wlr_output_is_drm(struct wlr_output *output);
struct wlr_backend *wlr_drm_backend_get_parent(struct wlr_backend *backend);
uint32_t wlr_drm_connector_get_id(struct wlr_output *output);
int wlr_drm_backend_get_non_master_fd(struct wlr_backend *backend);
struct wlr_drm_lease *wlr_drm_create_lease(struct wlr_output **outputs,
 size_t n_outputs, int *lease_fd);
void wlr_drm_lease_terminate(struct wlr_drm_lease *lease);
struct wlr_output_mode *wlr_drm_connector_add_mode(struct wlr_output *output,
 const drmModeModeInfo *mode);
const drmModeModeInfo *wlr_drm_mode_get_info(struct wlr_output_mode *mode);
enum wl_output_transform wlr_drm_connector_get_panel_orientation(
 struct wlr_output *output);
struct wlr_backend *wlr_headless_backend_create(struct wl_event_loop *loop);
struct wlr_output *wlr_headless_add_output(struct wlr_backend *backend,
 unsigned int width, unsigned int height);
_Bool
    wlr_backend_is_headless(struct wlr_backend *backend);
_Bool
    wlr_output_is_headless(struct wlr_output *output);
struct wlr_output_state;
struct wlr_backend_impl {
_Bool
     (*start)(struct wlr_backend *backend);
 void (*destroy)(struct wlr_backend *backend);
 int (*get_drm_fd)(struct wlr_backend *backend);
 uint32_t (*get_buffer_caps)(struct wlr_backend *backend);
_Bool
     (*test)(struct wlr_backend *backend,
  const struct wlr_backend_output_state *states, size_t states_len);
_Bool
     (*commit)(struct wlr_backend *backend,
  const struct wlr_backend_output_state *states, size_t states_len);
};
void wlr_backend_init(struct wlr_backend *backend,
  const struct wlr_backend_impl *impl);
void wlr_backend_finish(struct wlr_backend *backend);
struct wlr_input_device;
struct wlr_backend *wlr_libinput_backend_create(struct wlr_session *session);
struct libinput_device *wlr_libinput_get_device_handle(
  struct wlr_input_device *dev);
_Bool
    wlr_backend_is_libinput(struct wlr_backend *backend);
_Bool
    wlr_input_device_is_libinput(struct wlr_input_device *device);
struct wlr_backend *wlr_multi_backend_create(struct wl_event_loop *loop);
_Bool
    wlr_multi_backend_add(struct wlr_backend *multi,
 struct wlr_backend *backend);
void wlr_multi_backend_remove(struct wlr_backend *multi,
 struct wlr_backend *backend);
_Bool
    wlr_backend_is_multi(struct wlr_backend *backend);
_Bool
    wlr_multi_is_empty(struct wlr_backend *backend);
void wlr_multi_for_each_backend(struct wlr_backend *backend,
  void (*callback)(struct wlr_backend *backend, void *data), void *data);
struct wlr_input_device;
struct wlr_backend *wlr_wl_backend_create(struct wl_event_loop *loop,
  struct wl_display *remote_display);
struct wl_display *wlr_wl_backend_get_remote_display(struct wlr_backend *backend);
struct wlr_output *wlr_wl_output_create(struct wlr_backend *backend);
struct wlr_output *wlr_wl_output_create_from_surface(struct wlr_backend *backend,
  struct wl_surface *surface);
_Bool
    wlr_backend_is_wl(struct wlr_backend *backend);
_Bool
    wlr_input_device_is_wl(struct wlr_input_device *device);
_Bool
    wlr_output_is_wl(struct wlr_output *output);
void wlr_wl_output_set_title(struct wlr_output *output, const char *title);
void wlr_wl_output_set_app_id(struct wlr_output *output, const char *app_id);
struct wl_surface *wlr_wl_output_get_surface(struct wlr_output *output);
struct wlr_input_device;
struct wlr_backend *wlr_x11_backend_create(struct wl_event_loop *loop,
 const char *x11_display);
struct wlr_output *wlr_x11_output_create(struct wlr_backend *backend);
_Bool
    wlr_backend_is_x11(struct wlr_backend *backend);
_Bool
    wlr_input_device_is_x11(struct wlr_input_device *device);
_Bool
    wlr_output_is_x11(struct wlr_output *output);
void wlr_x11_output_set_title(struct wlr_output *output, const char *title);
struct wlr_buffer_impl {
 void (*destroy)(struct wlr_buffer *buffer);
_Bool
     (*get_dmabuf)(struct wlr_buffer *buffer,
  struct wlr_dmabuf_attributes *attribs);
_Bool
     (*get_shm)(struct wlr_buffer *buffer,
  struct wlr_shm_attributes *attribs);
_Bool
     (*begin_data_ptr_access)(struct wlr_buffer *buffer, uint32_t flags,
  void **data, uint32_t *format, size_t *stride);
 void (*end_data_ptr_access)(struct wlr_buffer *buffer);
};
struct wlr_buffer_resource_interface {
 const char *name;
_Bool
     (*is_instance)(struct wl_resource *resource);
 struct wlr_buffer *(*from_resource)(struct wl_resource *resource);
};
void wlr_buffer_init(struct wlr_buffer *buffer,
 const struct wlr_buffer_impl *impl, int width, int height);
void wlr_buffer_register_resource_interface(
 const struct wlr_buffer_resource_interface *iface);
enum wlr_button_state {
 WLR_BUTTON_RELEASED,
 WLR_BUTTON_PRESSED,
};
enum wlr_input_device_type {
 WLR_INPUT_DEVICE_KEYBOARD,
 WLR_INPUT_DEVICE_POINTER,
 WLR_INPUT_DEVICE_TOUCH,
 WLR_INPUT_DEVICE_TABLET,
 WLR_INPUT_DEVICE_TABLET_PAD,
 WLR_INPUT_DEVICE_SWITCH,
};
struct wlr_input_device {
 enum wlr_input_device_type type;
 char *name;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
enum wlr_keyboard_led {
 WLR_LED_NUM_LOCK = 1 << 0,
 WLR_LED_CAPS_LOCK = 1 << 1,
 WLR_LED_SCROLL_LOCK = 1 << 2,
};
enum wlr_keyboard_modifier {
 WLR_MODIFIER_SHIFT = 1 << 0,
 WLR_MODIFIER_CAPS = 1 << 1,
 WLR_MODIFIER_CTRL = 1 << 2,
 WLR_MODIFIER_ALT = 1 << 3,
 WLR_MODIFIER_MOD2 = 1 << 4,
 WLR_MODIFIER_MOD3 = 1 << 5,
 WLR_MODIFIER_LOGO = 1 << 6,
 WLR_MODIFIER_MOD5 = 1 << 7,
};
struct wlr_keyboard_impl;
struct wlr_keyboard_modifiers {
 xkb_mod_mask_t depressed;
 xkb_mod_mask_t latched;
 xkb_mod_mask_t locked;
 xkb_layout_index_t group;
};
struct wlr_keyboard {
 struct wlr_input_device base;
 const struct wlr_keyboard_impl *impl;
 struct wlr_keyboard_group *group;
 char *keymap_string;
 size_t keymap_size;
 int keymap_fd;
 struct xkb_keymap *keymap;
 struct xkb_state *xkb_state;
 xkb_led_index_t led_indexes[3];
 xkb_mod_index_t mod_indexes[8];
 uint32_t leds;
 uint32_t keycodes[32];
 size_t num_keycodes;
 struct wlr_keyboard_modifiers modifiers;
 struct {
  int32_t rate;
  int32_t delay;
 } repeat_info;
 struct {
  struct wl_signal key;
  struct wl_signal modifiers;
  struct wl_signal keymap;
  struct wl_signal repeat_info;
 } events;
 void *data;
};
struct wlr_keyboard_key_event {
 uint32_t time_msec;
 uint32_t keycode;
_Bool
     update_state;
 enum wl_keyboard_key_state state;
};
struct wlr_keyboard *wlr_keyboard_from_input_device(
 struct wlr_input_device *input_device);
_Bool
    wlr_keyboard_set_keymap(struct wlr_keyboard *kb,
 struct xkb_keymap *keymap);
_Bool
    wlr_keyboard_keymaps_match(struct xkb_keymap *km1, struct xkb_keymap *km2);
void wlr_keyboard_set_repeat_info(struct wlr_keyboard *kb, int32_t rate_hz,
 int32_t delay_ms);
void wlr_keyboard_led_update(struct wlr_keyboard *keyboard, uint32_t leds);
uint32_t wlr_keyboard_get_modifiers(struct wlr_keyboard *keyboard);
struct wlr_keyboard_impl {
 const char *name;
 void (*led_update)(struct wlr_keyboard *keyboard, uint32_t leds);
};
void wlr_keyboard_init(struct wlr_keyboard *keyboard,
 const struct wlr_keyboard_impl *impl, const char *name);
void wlr_keyboard_finish(struct wlr_keyboard *keyboard);
void wlr_keyboard_notify_key(struct wlr_keyboard *keyboard,
  struct wlr_keyboard_key_event *event);
void wlr_keyboard_notify_modifiers(struct wlr_keyboard *keyboard,
  uint32_t mods_depressed, uint32_t mods_latched, uint32_t mods_locked,
  uint32_t group);
struct wlr_output_cursor_size {
 int width, height;
};
struct wlr_output_impl {
_Bool
     (*set_cursor)(struct wlr_output *output, struct wlr_buffer *buffer,
  int hotspot_x, int hotspot_y);
_Bool
     (*move_cursor)(struct wlr_output *output, int x, int y);
 void (*destroy)(struct wlr_output *output);
_Bool
     (*test)(struct wlr_output *output, const struct wlr_output_state *state);
_Bool
     (*commit)(struct wlr_output *output, const struct wlr_output_state *state);
 size_t (*get_gamma_size)(struct wlr_output *output);
 const struct wlr_drm_format_set *(*get_cursor_formats)(
  struct wlr_output *output, uint32_t buffer_caps);
 const struct wlr_output_cursor_size *(*get_cursor_sizes)(struct wlr_output *output,
  size_t *len);
 const struct wlr_drm_format_set *(*get_primary_formats)(
  struct wlr_output *output, uint32_t buffer_caps);
};
void wlr_output_init(struct wlr_output *output, struct wlr_backend *backend,
 const struct wlr_output_impl *impl, struct wl_event_loop *event_loop,
 const struct wlr_output_state *state);
void wlr_output_update_needs_frame(struct wlr_output *output);
void wlr_output_send_frame(struct wlr_output *output);
void wlr_output_send_present(struct wlr_output *output,
 struct wlr_output_event_present *event);
void wlr_output_send_request_state(struct wlr_output *output,
 const struct wlr_output_state *state);
struct wlr_pointer_impl;
struct wlr_pointer {
 struct wlr_input_device base;
 const struct wlr_pointer_impl *impl;
 char *output_name;
 struct {
  struct wl_signal motion;
  struct wl_signal motion_absolute;
  struct wl_signal button;
  struct wl_signal axis;
  struct wl_signal frame;
  struct wl_signal swipe_begin;
  struct wl_signal swipe_update;
  struct wl_signal swipe_end;
  struct wl_signal pinch_begin;
  struct wl_signal pinch_update;
  struct wl_signal pinch_end;
  struct wl_signal hold_begin;
  struct wl_signal hold_end;
 } events;
 void *data;
};
struct wlr_pointer_motion_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
 double delta_x, delta_y;
 double unaccel_dx, unaccel_dy;
};
struct wlr_pointer_motion_absolute_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
 double x, y;
};
struct wlr_pointer_button_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
 uint32_t button;
 enum wl_pointer_button_state state;
};
struct wlr_pointer_axis_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
 enum wl_pointer_axis_source source;
 enum wl_pointer_axis orientation;
 enum wl_pointer_axis_relative_direction relative_direction;
 double delta;
 int32_t delta_discrete;
};
struct wlr_pointer_swipe_begin_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
 uint32_t fingers;
};
struct wlr_pointer_swipe_update_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
 uint32_t fingers;
 double dx, dy;
};
struct wlr_pointer_swipe_end_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
_Bool
     cancelled;
};
struct wlr_pointer_pinch_begin_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
 uint32_t fingers;
};
struct wlr_pointer_pinch_update_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
 uint32_t fingers;
 double dx, dy;
 double scale;
 double rotation;
};
struct wlr_pointer_pinch_end_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
_Bool
     cancelled;
};
struct wlr_pointer_hold_begin_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
 uint32_t fingers;
};
struct wlr_pointer_hold_end_event {
 struct wlr_pointer *pointer;
 uint32_t time_msec;
_Bool
     cancelled;
};
struct wlr_pointer *wlr_pointer_from_input_device(
 struct wlr_input_device *input_device);
struct wlr_pointer_impl {
 const char *name;
};
void wlr_pointer_init(struct wlr_pointer *pointer,
  const struct wlr_pointer_impl *impl, const char *name);
void wlr_pointer_finish(struct wlr_pointer *pointer);
struct wlr_switch_impl;
struct wlr_switch {
 struct wlr_input_device base;
 const struct wlr_switch_impl *impl;
 struct {
  struct wl_signal toggle;
 } events;
 void *data;
};
enum wlr_switch_type {
 WLR_SWITCH_TYPE_LID,
 WLR_SWITCH_TYPE_TABLET_MODE,
};
enum wlr_switch_state {
 WLR_SWITCH_STATE_OFF = 0,
 WLR_SWITCH_STATE_ON,
};
struct wlr_switch_toggle_event {
 uint32_t time_msec;
 enum wlr_switch_type switch_type;
 enum wlr_switch_state switch_state;
};
struct wlr_switch *wlr_switch_from_input_device(
 struct wlr_input_device *input_device);
struct wlr_switch_impl {
 const char *name;
};
void wlr_switch_init(struct wlr_switch *switch_device,
 const struct wlr_switch_impl *impl, const char *name);
void wlr_switch_finish(struct wlr_switch *switch_device);
struct wlr_tablet_pad_impl;
struct wlr_tablet_pad {
 struct wlr_input_device base;
 const struct wlr_tablet_pad_impl *impl;
 struct {
  struct wl_signal button;
  struct wl_signal ring;
  struct wl_signal strip;
  struct wl_signal attach_tablet;
 } events;
 size_t button_count;
 size_t ring_count;
 size_t strip_count;
 struct wl_list groups;
 struct wl_array paths;
 void *data;
};
struct wlr_tablet_pad_group {
 struct wl_list link;
 size_t button_count;
 unsigned int *buttons;
 size_t strip_count;
 unsigned int *strips;
 size_t ring_count;
 unsigned int *rings;
 unsigned int mode_count;
};
struct wlr_tablet_pad_button_event {
 uint32_t time_msec;
 uint32_t button;
 enum wlr_button_state state;
 unsigned int mode;
 unsigned int group;
};
enum wlr_tablet_pad_ring_source {
 WLR_TABLET_PAD_RING_SOURCE_UNKNOWN,
 WLR_TABLET_PAD_RING_SOURCE_FINGER,
};
struct wlr_tablet_pad_ring_event {
 uint32_t time_msec;
 enum wlr_tablet_pad_ring_source source;
 uint32_t ring;
 double position;
 unsigned int mode;
};
enum wlr_tablet_pad_strip_source {
 WLR_TABLET_PAD_STRIP_SOURCE_UNKNOWN,
 WLR_TABLET_PAD_STRIP_SOURCE_FINGER,
};
struct wlr_tablet_pad_strip_event {
 uint32_t time_msec;
 enum wlr_tablet_pad_strip_source source;
 uint32_t strip;
 double position;
 unsigned int mode;
};
struct wlr_tablet_pad *wlr_tablet_pad_from_input_device(
 struct wlr_input_device *);
struct wlr_tablet_pad_impl {
 const char *name;
};
void wlr_tablet_pad_init(struct wlr_tablet_pad *pad,
 const struct wlr_tablet_pad_impl *impl, const char *name);
void wlr_tablet_pad_finish(struct wlr_tablet_pad *pad);
enum wlr_tablet_tool_type {
 WLR_TABLET_TOOL_TYPE_PEN = 1,
 WLR_TABLET_TOOL_TYPE_ERASER,
 WLR_TABLET_TOOL_TYPE_BRUSH,
 WLR_TABLET_TOOL_TYPE_PENCIL,
 WLR_TABLET_TOOL_TYPE_AIRBRUSH,
 WLR_TABLET_TOOL_TYPE_MOUSE,
 WLR_TABLET_TOOL_TYPE_LENS,
 WLR_TABLET_TOOL_TYPE_TOTEM,
};
struct wlr_tablet_tool {
 enum wlr_tablet_tool_type type;
 uint64_t hardware_serial;
 uint64_t hardware_wacom;
_Bool
     tilt;
_Bool
     pressure;
_Bool
     distance;
_Bool
     rotation;
_Bool
     slider;
_Bool
     wheel;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_tablet_impl;
struct wlr_tablet {
 struct wlr_input_device base;
 const struct wlr_tablet_impl *impl;
 uint16_t usb_vendor_id, usb_product_id;
 double width_mm, height_mm;
 struct {
  struct wl_signal axis;
  struct wl_signal proximity;
  struct wl_signal tip;
  struct wl_signal button;
 } events;
 struct wl_array paths;
 void *data;
};
enum wlr_tablet_tool_axes {
 WLR_TABLET_TOOL_AXIS_X = 1 << 0,
 WLR_TABLET_TOOL_AXIS_Y = 1 << 1,
 WLR_TABLET_TOOL_AXIS_DISTANCE = 1 << 2,
 WLR_TABLET_TOOL_AXIS_PRESSURE = 1 << 3,
 WLR_TABLET_TOOL_AXIS_TILT_X = 1 << 4,
 WLR_TABLET_TOOL_AXIS_TILT_Y = 1 << 5,
 WLR_TABLET_TOOL_AXIS_ROTATION = 1 << 6,
 WLR_TABLET_TOOL_AXIS_SLIDER = 1 << 7,
 WLR_TABLET_TOOL_AXIS_WHEEL = 1 << 8,
};
struct wlr_tablet_tool_axis_event {
 struct wlr_tablet *tablet;
 struct wlr_tablet_tool *tool;
 uint32_t time_msec;
 uint32_t updated_axes;
 double x, y;
 double dx, dy;
 double pressure;
 double distance;
 double tilt_x, tilt_y;
 double rotation;
 double slider;
 double wheel_delta;
};
enum wlr_tablet_tool_proximity_state {
 WLR_TABLET_TOOL_PROXIMITY_OUT,
 WLR_TABLET_TOOL_PROXIMITY_IN,
};
struct wlr_tablet_tool_proximity_event {
 struct wlr_tablet *tablet;
 struct wlr_tablet_tool *tool;
 uint32_t time_msec;
 double x, y;
 enum wlr_tablet_tool_proximity_state state;
};
enum wlr_tablet_tool_tip_state {
 WLR_TABLET_TOOL_TIP_UP,
 WLR_TABLET_TOOL_TIP_DOWN,
};
struct wlr_tablet_tool_tip_event {
 struct wlr_tablet *tablet;
 struct wlr_tablet_tool *tool;
 uint32_t time_msec;
 double x, y;
 enum wlr_tablet_tool_tip_state state;
};
struct wlr_tablet_tool_button_event {
 struct wlr_tablet *tablet;
 struct wlr_tablet_tool *tool;
 uint32_t time_msec;
 uint32_t button;
 enum wlr_button_state state;
};
struct wlr_tablet *wlr_tablet_from_input_device(
 struct wlr_input_device *input_device);
struct wlr_tablet_impl {
 const char *name;
};
void wlr_tablet_init(struct wlr_tablet *tablet,
 const struct wlr_tablet_impl *impl, const char *name);
void wlr_tablet_finish(struct wlr_tablet *tablet);
struct wlr_touch_impl;
struct wlr_touch {
 struct wlr_input_device base;
 const struct wlr_touch_impl *impl;
 char *output_name;
 double width_mm, height_mm;
 struct {
  struct wl_signal down;
  struct wl_signal up;
  struct wl_signal motion;
  struct wl_signal cancel;
  struct wl_signal frame;
 } events;
 void *data;
};
struct wlr_touch_down_event {
 struct wlr_touch *touch;
 uint32_t time_msec;
 int32_t touch_id;
 double x, y;
};
struct wlr_touch_up_event {
 struct wlr_touch *touch;
 uint32_t time_msec;
 int32_t touch_id;
};
struct wlr_touch_motion_event {
 struct wlr_touch *touch;
 uint32_t time_msec;
 int32_t touch_id;
 double x, y;
};
struct wlr_touch_cancel_event {
 struct wlr_touch *touch;
 uint32_t time_msec;
 int32_t touch_id;
};
struct wlr_touch *wlr_touch_from_input_device(
 struct wlr_input_device *input_device);
struct wlr_touch_impl {
 const char *name;
};
void wlr_touch_init(struct wlr_touch *touch,
 const struct wlr_touch_impl *impl, const char *name);
void wlr_touch_finish(struct wlr_touch *touch);
struct wlr_allocator;
struct wlr_backend;
struct wlr_drm_format;
struct wlr_renderer;
struct wlr_allocator_interface {
 struct wlr_buffer *(*create_buffer)(struct wlr_allocator *alloc,
  int width, int height, const struct wlr_drm_format *format);
 void (*destroy)(struct wlr_allocator *alloc);
};
void wlr_allocator_init(struct wlr_allocator *alloc,
 const struct wlr_allocator_interface *impl, uint32_t buffer_caps);
struct wlr_allocator {
 const struct wlr_allocator_interface *impl;
 uint32_t buffer_caps;
 struct {
  struct wl_signal destroy;
 } events;
};
struct wlr_allocator *wlr_allocator_autocreate(struct wlr_backend *backend,
 struct wlr_renderer *renderer);
void wlr_allocator_destroy(struct wlr_allocator *alloc);
struct wlr_buffer *wlr_allocator_create_buffer(struct wlr_allocator *alloc,
 int width, int height, const struct wlr_drm_format *format);
struct wlr_color_transform;
struct wlr_color_transform *wlr_color_transform_init_linear_to_icc(
 const void *data, size_t size);
struct wlr_color_transform *wlr_color_transform_init_srgb(void);
void wlr_color_transform_ref(struct wlr_color_transform *tr);
void wlr_color_transform_unref(struct wlr_color_transform *tr);
typedef long int ptrdiff_t;
typedef int wchar_t;
typedef struct {
  long long __max_align_ll __attribute__((__aligned__(__alignof__(long long))));
  long double __max_align_ld __attribute__((__aligned__(__alignof__(long double))));
} max_align_t;
struct wlr_drm_format {
 uint32_t format;
 size_t len;
 size_t capacity;
 uint64_t *modifiers;
};
void wlr_drm_format_finish(struct wlr_drm_format *format);
struct wlr_drm_format_set {
 size_t len;
 size_t capacity;
 struct wlr_drm_format *formats;
};
void wlr_drm_format_set_finish(struct wlr_drm_format_set *set);
const struct wlr_drm_format *wlr_drm_format_set_get(
 const struct wlr_drm_format_set *set, uint32_t format);
_Bool
    wlr_drm_format_set_has(const struct wlr_drm_format_set *set,
 uint32_t format, uint64_t modifier);
_Bool
    wlr_drm_format_set_add(struct wlr_drm_format_set *set, uint32_t format,
 uint64_t modifier);
_Bool
    wlr_drm_format_set_intersect(struct wlr_drm_format_set *dst,
 const struct wlr_drm_format_set *a, const struct wlr_drm_format_set *b);
_Bool
    wlr_drm_format_set_union(struct wlr_drm_format_set *dst,
 const struct wlr_drm_format_set *a, const struct wlr_drm_format_set *b);
struct wlr_drm_syncobj_timeline {
 int drm_fd;
 uint32_t handle;
 size_t n_refs;
};
struct wlr_drm_syncobj_timeline_waiter {
 struct {
  struct wl_signal ready;
 } events;
 int ev_fd;
 struct wl_event_source *event_source;
};
struct wlr_drm_syncobj_timeline *wlr_drm_syncobj_timeline_create(int drm_fd);
struct wlr_drm_syncobj_timeline *wlr_drm_syncobj_timeline_import(int drm_fd,
 int drm_syncobj_fd);
struct wlr_drm_syncobj_timeline *wlr_drm_syncobj_timeline_ref(struct wlr_drm_syncobj_timeline *timeline);
void wlr_drm_syncobj_timeline_unref(struct wlr_drm_syncobj_timeline *timeline);
_Bool
    wlr_drm_syncobj_timeline_check(struct wlr_drm_syncobj_timeline *timeline,
 uint64_t point, uint32_t flags,
                                _Bool
                                     *result);
_Bool
    wlr_drm_syncobj_timeline_waiter_init(struct wlr_drm_syncobj_timeline_waiter *waiter,
 struct wlr_drm_syncobj_timeline *timeline, uint64_t point, uint32_t flags,
 struct wl_event_loop *loop);
void wlr_drm_syncobj_timeline_waiter_finish(struct wlr_drm_syncobj_timeline_waiter *waiter);
int wlr_drm_syncobj_timeline_export_sync_file(struct wlr_drm_syncobj_timeline *timeline,
 uint64_t src_point);
_Bool
    wlr_drm_syncobj_timeline_import_sync_file(struct wlr_drm_syncobj_timeline *timeline,
 uint64_t dst_point, int sync_file_fd);
struct wlr_egl;
struct wlr_egl *wlr_egl_create_with_context(EGLDisplay display,
 EGLContext context);
EGLDisplay wlr_egl_get_display(struct wlr_egl *egl);
EGLContext wlr_egl_get_context(struct wlr_egl *egl);
struct wlr_egl;
struct wlr_renderer *wlr_gles2_renderer_create_with_drm_fd(int drm_fd);
struct wlr_renderer *wlr_gles2_renderer_create(struct wlr_egl *egl);
struct wlr_egl *wlr_gles2_renderer_get_egl(struct wlr_renderer *renderer);
_Bool
    wlr_gles2_renderer_check_ext(struct wlr_renderer *renderer, const char *ext);
GLuint wlr_gles2_renderer_get_buffer_fbo(struct wlr_renderer *renderer, struct wlr_buffer *buffer);
struct wlr_gles2_texture_attribs {
 GLenum target;
 GLuint tex;
_Bool
     has_alpha;
};
_Bool
    wlr_renderer_is_gles2(struct wlr_renderer *wlr_renderer);
_Bool
    wlr_render_timer_is_gles2(struct wlr_render_timer *timer);
_Bool
    wlr_texture_is_gles2(struct wlr_texture *texture);
void wlr_gles2_texture_get_attribs(struct wlr_texture *texture,
 struct wlr_gles2_texture_attribs *attribs);
struct wlr_box;
struct wlr_fbox;
struct wlr_renderer_impl {
 const struct wlr_drm_format_set *(*get_texture_formats)(
  struct wlr_renderer *renderer, uint32_t buffer_caps);
 const struct wlr_drm_format_set *(*get_render_formats)(
  struct wlr_renderer *renderer);
 void (*destroy)(struct wlr_renderer *renderer);
 int (*get_drm_fd)(struct wlr_renderer *renderer);
 struct wlr_texture *(*texture_from_buffer)(struct wlr_renderer *renderer,
  struct wlr_buffer *buffer);
 struct wlr_render_pass *(*begin_buffer_pass)(struct wlr_renderer *renderer,
  struct wlr_buffer *buffer, const struct wlr_buffer_pass_options *options);
 struct wlr_render_timer *(*render_timer_create)(struct wlr_renderer *renderer);
};
void wlr_renderer_init(struct wlr_renderer *renderer,
 const struct wlr_renderer_impl *impl, uint32_t render_buffer_caps);
struct wlr_texture_impl {
_Bool
     (*update_from_buffer)(struct wlr_texture *texture,
  struct wlr_buffer *buffer, const pixman_region32_t *damage);
_Bool
     (*read_pixels)(struct wlr_texture *texture,
  const struct wlr_texture_read_pixels_options *options);
 uint32_t (*preferred_read_format)(struct wlr_texture *texture);
 void (*destroy)(struct wlr_texture *texture);
};
void wlr_texture_init(struct wlr_texture *texture, struct wlr_renderer *rendener,
 const struct wlr_texture_impl *impl, uint32_t width, uint32_t height);
struct wlr_render_pass {
 const struct wlr_render_pass_impl *impl;
};
void wlr_render_pass_init(struct wlr_render_pass *pass,
 const struct wlr_render_pass_impl *impl);
struct wlr_render_pass_impl {
_Bool
     (*submit)(struct wlr_render_pass *pass);
 void (*add_texture)(struct wlr_render_pass *pass,
  const struct wlr_render_texture_options *options);
 void (*add_rect)(struct wlr_render_pass *pass,
  const struct wlr_render_rect_options *options);
};
struct wlr_render_timer {
 const struct wlr_render_timer_impl *impl;
};
struct wlr_render_timer_impl {
 int (*get_duration_ns)(struct wlr_render_timer *timer);
 void (*destroy)(struct wlr_render_timer *timer);
};
void wlr_render_texture_options_get_src_box(const struct wlr_render_texture_options *options,
 struct wlr_fbox *box);
void wlr_render_texture_options_get_dst_box(const struct wlr_render_texture_options *options,
 struct wlr_box *box);
float wlr_render_texture_options_get_alpha(const struct wlr_render_texture_options *options);
void wlr_render_rect_options_get_box(const struct wlr_render_rect_options *options,
 const struct wlr_buffer *buffer, struct wlr_box *box);
void wlr_texture_read_pixels_options_get_src_box(
 const struct wlr_texture_read_pixels_options *options,
 const struct wlr_texture *texture, struct wlr_box *box);
void *wlr_texture_read_pixel_options_get_data(
 const struct wlr_texture_read_pixels_options *options);
struct wlr_renderer *wlr_pixman_renderer_create(void);
_Bool
    wlr_renderer_is_pixman(struct wlr_renderer *wlr_renderer);
_Bool
    wlr_texture_is_pixman(struct wlr_texture *texture);
pixman_image_t *wlr_pixman_renderer_get_buffer_image(
    struct wlr_renderer *wlr_renderer, struct wlr_buffer *wlr_buffer);
pixman_image_t *wlr_pixman_texture_get_image(struct wlr_texture *wlr_texture);
struct wlr_swapchain_slot {
 struct wlr_buffer *buffer;
_Bool
     acquired;
 int age;
 struct wl_listener release;
};
struct wlr_swapchain {
 struct wlr_allocator *allocator;
 int width, height;
 struct wlr_drm_format format;
 struct wlr_swapchain_slot slots[4];
 struct wl_listener allocator_destroy;
};
struct wlr_swapchain *wlr_swapchain_create(
 struct wlr_allocator *alloc, int width, int height,
 const struct wlr_drm_format *format);
void wlr_swapchain_destroy(struct wlr_swapchain *swapchain);
struct wlr_buffer *wlr_swapchain_acquire(struct wlr_swapchain *swapchain,
 int *age);
_Bool
    wlr_swapchain_has_buffer(struct wlr_swapchain *swapchain,
 struct wlr_buffer *buffer);
void wlr_swapchain_set_buffer_submitted(struct wlr_swapchain *swapchain,
 struct wlr_buffer *buffer);
struct wlr_vk_image_attribs {
 VkImage image;
 VkImageLayout layout;
 VkFormat format;
};
struct wlr_renderer *wlr_vk_renderer_create_with_drm_fd(int drm_fd);
VkInstance wlr_vk_renderer_get_instance(struct wlr_renderer *renderer);
VkPhysicalDevice wlr_vk_renderer_get_physical_device(struct wlr_renderer *renderer);
VkDevice wlr_vk_renderer_get_device(struct wlr_renderer *renderer);
uint32_t wlr_vk_renderer_get_queue_family(struct wlr_renderer *renderer);
_Bool
    wlr_renderer_is_vk(struct wlr_renderer *wlr_renderer);
_Bool
    wlr_texture_is_vk(struct wlr_texture *texture);
void wlr_vk_texture_get_image_attribs(struct wlr_texture *texture,
 struct wlr_vk_image_attribs *attribs);
_Bool
    wlr_vk_texture_has_alpha(struct wlr_texture *texture);
struct wlr_surface;
struct wlr_alpha_modifier_surface_v1_state {
 double multiplier;
};
struct wlr_alpha_modifier_v1 {
 struct wl_global *global;
 struct wl_listener display_destroy;
};
struct wlr_alpha_modifier_v1 *wlr_alpha_modifier_v1_create(struct wl_display *display);
const struct wlr_alpha_modifier_surface_v1_state *wlr_alpha_modifier_v1_get_surface_state(
 struct wlr_surface *surface);
enum wlr_surface_state_field {
 WLR_SURFACE_STATE_BUFFER = 1 << 0,
 WLR_SURFACE_STATE_SURFACE_DAMAGE = 1 << 1,
 WLR_SURFACE_STATE_BUFFER_DAMAGE = 1 << 2,
 WLR_SURFACE_STATE_OPAQUE_REGION = 1 << 3,
 WLR_SURFACE_STATE_INPUT_REGION = 1 << 4,
 WLR_SURFACE_STATE_TRANSFORM = 1 << 5,
 WLR_SURFACE_STATE_SCALE = 1 << 6,
 WLR_SURFACE_STATE_FRAME_CALLBACK_LIST = 1 << 7,
 WLR_SURFACE_STATE_VIEWPORT = 1 << 8,
 WLR_SURFACE_STATE_OFFSET = 1 << 9,
};
struct wlr_surface_state {
 uint32_t committed;
 uint32_t seq;
 struct wlr_buffer *buffer;
 int32_t dx, dy;
 pixman_region32_t surface_damage, buffer_damage;
 pixman_region32_t opaque, input;
 enum wl_output_transform transform;
 int32_t scale;
 struct wl_list frame_callback_list;
 int width, height;
 int buffer_width, buffer_height;
 struct wl_list subsurfaces_below;
 struct wl_list subsurfaces_above;
 struct {
 _Bool
      has_src, has_dst;
  struct wlr_fbox src;
  int dst_width, dst_height;
 } viewport;
 size_t cached_state_locks;
 struct wl_list cached_state_link;
 struct wl_array synced;
};
struct wlr_surface_role {
 const char *name;
_Bool
     no_object;
 void (*client_commit)(struct wlr_surface *surface);
 void (*commit)(struct wlr_surface *surface);
 void (*unmap)(struct wlr_surface *surface);
 void (*destroy)(struct wlr_surface *surface);
};
struct wlr_surface_output {
 struct wlr_surface *surface;
 struct wlr_output *output;
 struct wl_list link;
 struct wl_listener bind;
 struct wl_listener destroy;
};
struct wlr_surface {
 struct wl_resource *resource;
 struct wlr_compositor *compositor;
 struct wlr_client_buffer *buffer;
 pixman_region32_t buffer_damage;
 pixman_region32_t opaque_region;
 pixman_region32_t input_region;
 struct wlr_surface_state current, pending;
 struct wl_list cached;
_Bool
     mapped;
 const struct wlr_surface_role *role;
 struct wl_resource *role_resource;
 struct {
  struct wl_signal client_commit;
  struct wl_signal commit;
  struct wl_signal map;
  struct wl_signal unmap;
  struct wl_signal new_subsurface;
  struct wl_signal destroy;
 } events;
 struct wl_list current_outputs;
 struct wlr_addon_set addons;
 void *data;
 struct wl_listener role_resource_destroy;
 struct {
  int32_t scale;
  enum wl_output_transform transform;
  int width, height;
  int buffer_width, buffer_height;
 } previous;
_Bool
     unmap_commit;
_Bool
     opaque;
_Bool
     handling_commit;
_Bool
     pending_rejected;
 int32_t preferred_buffer_scale;
_Bool
     preferred_buffer_transform_sent;
 enum wl_output_transform preferred_buffer_transform;
 struct wl_list synced;
 size_t synced_len;
 struct wl_resource *pending_buffer_resource;
 struct wl_listener pending_buffer_resource_destroy;
};
struct wlr_renderer;
struct wlr_compositor {
 struct wl_global *global;
 struct wlr_renderer *renderer;
 struct wl_listener display_destroy;
 struct wl_listener renderer_destroy;
 struct {
  struct wl_signal new_surface;
  struct wl_signal destroy;
 } events;
};
typedef void (*wlr_surface_iterator_func_t)(struct wlr_surface *surface,
 int sx, int sy, void *data);
_Bool
    wlr_surface_set_role(struct wlr_surface *surface, const struct wlr_surface_role *role,
 struct wl_resource *error_resource, uint32_t error_code);
void wlr_surface_set_role_object(struct wlr_surface *surface, struct wl_resource *role_resource);
void wlr_surface_map(struct wlr_surface *surface);
void wlr_surface_unmap(struct wlr_surface *surface);
void wlr_surface_reject_pending(struct wlr_surface *surface, struct wl_resource *resource,
 uint32_t code, const char *msg, ...);
_Bool
    wlr_surface_has_buffer(struct wlr_surface *surface);
_Bool
    wlr_surface_state_has_buffer(const struct wlr_surface_state *state);
struct wlr_texture *wlr_surface_get_texture(struct wlr_surface *surface);
struct wlr_surface *wlr_surface_get_root_surface(struct wlr_surface *surface);
_Bool
    wlr_surface_point_accepts_input(struct wlr_surface *surface,
  double sx, double sy);
struct wlr_surface *wlr_surface_surface_at(struct wlr_surface *surface,
  double sx, double sy, double *sub_x, double *sub_y);
void wlr_surface_send_enter(struct wlr_surface *surface,
  struct wlr_output *output);
void wlr_surface_send_leave(struct wlr_surface *surface,
  struct wlr_output *output);
void wlr_surface_send_frame_done(struct wlr_surface *surface,
  const struct timespec *when);
void wlr_surface_get_extends(struct wlr_surface *surface, struct wlr_box *box);
struct wlr_surface *wlr_surface_from_resource(struct wl_resource *resource);
void wlr_surface_for_each_surface(struct wlr_surface *surface,
 wlr_surface_iterator_func_t iterator, void *user_data);
void wlr_surface_get_effective_damage(struct wlr_surface *surface,
 pixman_region32_t *damage);
void wlr_surface_get_buffer_source_box(struct wlr_surface *surface,
 struct wlr_fbox *box);
uint32_t wlr_surface_lock_pending(struct wlr_surface *surface);
void wlr_surface_unlock_cached(struct wlr_surface *surface, uint32_t seq);
void wlr_surface_set_preferred_buffer_scale(struct wlr_surface *surface,
 int32_t scale);
void wlr_surface_set_preferred_buffer_transform(struct wlr_surface *surface,
 enum wl_output_transform transform);
struct wlr_surface_synced_impl {
 size_t state_size;
 void (*init_state)(void *state);
 void (*finish_state)(void *state);
 void (*move_state)(void *dst, void *src);
};
struct wlr_surface_synced {
 struct wlr_surface *surface;
 const struct wlr_surface_synced_impl *impl;
 struct wl_list link;
 size_t index;
};
_Bool
    wlr_surface_synced_init(struct wlr_surface_synced *synced,
 struct wlr_surface *surface, const struct wlr_surface_synced_impl *impl,
 void *pending, void *current);
void wlr_surface_synced_finish(struct wlr_surface_synced *synced);
void *wlr_surface_synced_get_state(struct wlr_surface_synced *synced,
 const struct wlr_surface_state *state);
const pixman_region32_t *wlr_region_from_resource(struct wl_resource *resource);
struct wlr_compositor *wlr_compositor_create(struct wl_display *display,
 uint32_t version, struct wlr_renderer *renderer);
void wlr_compositor_set_renderer(struct wlr_compositor *compositor,
 struct wlr_renderer *renderer);
struct wlr_surface;
struct wlr_content_type_manager_v1 {
 struct wl_global *global;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
 struct wl_listener display_destroy;
};
struct wlr_content_type_manager_v1 *wlr_content_type_manager_v1_create(
 struct wl_display *display, uint32_t version);
enum wp_content_type_v1_type wlr_surface_get_content_type_v1(
 struct wlr_content_type_manager_v1 *manager, struct wlr_surface *surface);
struct wlr_box;
struct wlr_output_layout {
 struct wl_list outputs;
 struct wl_display *display;
 struct {
  struct wl_signal add;
  struct wl_signal change;
  struct wl_signal destroy;
 } events;
 void *data;
 struct wl_listener display_destroy;
};
struct wlr_output_layout_output {
 struct wlr_output_layout *layout;
 struct wlr_output *output;
 int x, y;
 struct wl_list link;
_Bool
     auto_configured;
 struct {
  struct wl_signal destroy;
 } events;
 struct wlr_addon addon;
 struct wl_listener commit;
};
struct wlr_output_layout *wlr_output_layout_create(struct wl_display *display);
void wlr_output_layout_destroy(struct wlr_output_layout *layout);
struct wlr_output_layout_output *wlr_output_layout_get(
 struct wlr_output_layout *layout, struct wlr_output *reference);
struct wlr_output *wlr_output_layout_output_at(
 struct wlr_output_layout *layout, double lx, double ly);
struct wlr_output_layout_output *wlr_output_layout_add(struct wlr_output_layout *layout,
 struct wlr_output *output, int lx, int ly);
struct wlr_output_layout_output *wlr_output_layout_add_auto(struct wlr_output_layout *layout,
 struct wlr_output *output);
void wlr_output_layout_remove(struct wlr_output_layout *layout,
 struct wlr_output *output);
void wlr_output_layout_output_coords(struct wlr_output_layout *layout,
 struct wlr_output *reference, double *lx, double *ly);
_Bool
    wlr_output_layout_contains_point(struct wlr_output_layout *layout,
 struct wlr_output *reference, int lx, int ly);
_Bool
    wlr_output_layout_intersects(struct wlr_output_layout *layout,
 struct wlr_output *reference, const struct wlr_box *target_lbox);
void wlr_output_layout_closest_point(struct wlr_output_layout *layout,
 struct wlr_output *reference, double lx, double ly,
 double *dest_lx, double *dest_ly);
void wlr_output_layout_get_box(struct wlr_output_layout *layout,
 struct wlr_output *reference, struct wlr_box *dest_box);
struct wlr_output *wlr_output_layout_get_center_output(
 struct wlr_output_layout *layout);
enum wlr_direction {
 WLR_DIRECTION_UP = 1 << 0,
 WLR_DIRECTION_DOWN = 1 << 1,
 WLR_DIRECTION_LEFT = 1 << 2,
 WLR_DIRECTION_RIGHT = 1 << 3,
};
struct wlr_output *wlr_output_layout_adjacent_output(
 struct wlr_output_layout *layout, enum wlr_direction direction,
 struct wlr_output *reference, double ref_lx, double ref_ly);
struct wlr_output *wlr_output_layout_farthest_output(
 struct wlr_output_layout *layout, enum wlr_direction direction,
 struct wlr_output *reference, double ref_lx, double ref_ly);
struct wlr_input_device;
struct wlr_xcursor_manager;
struct wlr_box;
struct wlr_cursor_state;
struct wlr_cursor {
 struct wlr_cursor_state *state;
 double x, y;
 struct {
  struct wl_signal motion;
  struct wl_signal motion_absolute;
  struct wl_signal button;
  struct wl_signal axis;
  struct wl_signal frame;
  struct wl_signal swipe_begin;
  struct wl_signal swipe_update;
  struct wl_signal swipe_end;
  struct wl_signal pinch_begin;
  struct wl_signal pinch_update;
  struct wl_signal pinch_end;
  struct wl_signal hold_begin;
  struct wl_signal hold_end;
  struct wl_signal touch_up;
  struct wl_signal touch_down;
  struct wl_signal touch_motion;
  struct wl_signal touch_cancel;
  struct wl_signal touch_frame;
  struct wl_signal tablet_tool_axis;
  struct wl_signal tablet_tool_proximity;
  struct wl_signal tablet_tool_tip;
  struct wl_signal tablet_tool_button;
 } events;
 void *data;
};
struct wlr_cursor *wlr_cursor_create(void);
void wlr_cursor_destroy(struct wlr_cursor *cur);
_Bool
    wlr_cursor_warp(struct wlr_cursor *cur, struct wlr_input_device *dev,
 double lx, double ly);
void wlr_cursor_absolute_to_layout_coords(struct wlr_cursor *cur,
 struct wlr_input_device *dev, double x, double y, double *lx, double *ly);
void wlr_cursor_warp_closest(struct wlr_cursor *cur,
 struct wlr_input_device *dev, double x, double y);
void wlr_cursor_warp_absolute(struct wlr_cursor *cur,
 struct wlr_input_device *dev, double x, double y);
void wlr_cursor_move(struct wlr_cursor *cur, struct wlr_input_device *dev,
 double delta_x, double delta_y);
void wlr_cursor_set_buffer(struct wlr_cursor *cur, struct wlr_buffer *buffer,
 int32_t hotspot_x, int32_t hotspot_y, float scale);
void wlr_cursor_unset_image(struct wlr_cursor *cur);
void wlr_cursor_set_xcursor(struct wlr_cursor *cur,
 struct wlr_xcursor_manager *manager, const char *name);
void wlr_cursor_set_surface(struct wlr_cursor *cur, struct wlr_surface *surface,
 int32_t hotspot_x, int32_t hotspot_y);
void wlr_cursor_attach_input_device(struct wlr_cursor *cur,
  struct wlr_input_device *dev);
void wlr_cursor_detach_input_device(struct wlr_cursor *cur,
  struct wlr_input_device *dev);
void wlr_cursor_attach_output_layout(struct wlr_cursor *cur,
 struct wlr_output_layout *l);
void wlr_cursor_map_to_output(struct wlr_cursor *cur,
 struct wlr_output *output);
void wlr_cursor_map_input_to_output(struct wlr_cursor *cur,
 struct wlr_input_device *dev, struct wlr_output *output);
void wlr_cursor_map_to_region(struct wlr_cursor *cur, const struct wlr_box *box);
void wlr_cursor_map_input_to_region(struct wlr_cursor *cur,
 struct wlr_input_device *dev, const struct wlr_box *box);
struct wlr_cursor_shape_manager_v1 {
 struct wl_global *global;
 struct {
  struct wl_signal request_set_shape;
  struct wl_signal destroy;
 } events;
 void *data;
 struct wl_listener display_destroy;
};
enum wlr_cursor_shape_manager_v1_device_type {
 WLR_CURSOR_SHAPE_MANAGER_V1_DEVICE_TYPE_POINTER,
 WLR_CURSOR_SHAPE_MANAGER_V1_DEVICE_TYPE_TABLET_TOOL,
};
struct wlr_cursor_shape_manager_v1_request_set_shape_event {
 struct wlr_seat_client *seat_client;
 enum wlr_cursor_shape_manager_v1_device_type device_type;
 struct wlr_tablet_v2_tablet_tool *tablet_tool;
 uint32_t serial;
 enum wp_cursor_shape_device_v1_shape shape;
};
struct wlr_cursor_shape_manager_v1 *wlr_cursor_shape_manager_v1_create(
 struct wl_display *display, uint32_t version);
const char *wlr_cursor_shape_v1_name(enum wp_cursor_shape_device_v1_shape shape);
struct wlr_box;
struct wlr_damage_ring_buffer {
 struct wlr_buffer *buffer;
 struct wl_listener destroy;
 pixman_region32_t damage;
 struct wlr_damage_ring *ring;
 struct wl_list link;
};
struct wlr_damage_ring {
 int32_t width, height;
 pixman_region32_t current;
 pixman_region32_t previous[2];
 size_t previous_idx;
 struct wl_list buffers;
};
void wlr_damage_ring_init(struct wlr_damage_ring *ring);
void wlr_damage_ring_finish(struct wlr_damage_ring *ring);
void wlr_damage_ring_set_bounds(struct wlr_damage_ring *ring,
 int32_t width, int32_t height);
_Bool
    wlr_damage_ring_add(struct wlr_damage_ring *ring,
 const pixman_region32_t *damage);
_Bool
    wlr_damage_ring_add_box(struct wlr_damage_ring *ring,
 const struct wlr_box *box);
void wlr_damage_ring_add_whole(struct wlr_damage_ring *ring);
void wlr_damage_ring_rotate(struct wlr_damage_ring *ring);
void wlr_damage_ring_get_buffer_damage(struct wlr_damage_ring *ring,
 int buffer_age, pixman_region32_t *damage);
void wlr_damage_ring_rotate_buffer(struct wlr_damage_ring *ring,
 struct wlr_buffer *buffer, pixman_region32_t *damage);
struct wlr_surface;
struct wlr_serial_range {
 uint32_t min_incl;
 uint32_t max_incl;
};
struct wlr_serial_ringset {
 struct wlr_serial_range data[128];
 int end;
 int count;
};
struct wlr_seat_client {
 struct wl_client *client;
 struct wlr_seat *seat;
 struct wl_list link;
 struct wl_list resources;
 struct wl_list pointers;
 struct wl_list keyboards;
 struct wl_list touches;
 struct wl_list data_devices;
 struct {
  struct wl_signal destroy;
 } events;
 struct wlr_serial_ringset serials;
_Bool
     needs_touch_frame;
 struct {
  int32_t acc_discrete[2];
  int32_t last_discrete[2];
  double acc_axis[2];
 } value120;
};
struct wlr_touch_point {
 int32_t touch_id;
 struct wlr_surface *surface;
 struct wlr_seat_client *client;
 struct wlr_surface *focus_surface;
 struct wlr_seat_client *focus_client;
 double sx, sy;
 struct wl_listener surface_destroy;
 struct wl_listener focus_surface_destroy;
 struct wl_listener client_destroy;
 struct {
  struct wl_signal destroy;
 } events;
 struct wl_list link;
};
struct wlr_seat_pointer_grab;
struct wlr_pointer_grab_interface {
 void (*enter)(struct wlr_seat_pointer_grab *grab,
   struct wlr_surface *surface, double sx, double sy);
 void (*clear_focus)(struct wlr_seat_pointer_grab *grab);
 void (*motion)(struct wlr_seat_pointer_grab *grab, uint32_t time_msec,
   double sx, double sy);
 uint32_t (*button)(struct wlr_seat_pointer_grab *grab, uint32_t time_msec,
   uint32_t button, enum wl_pointer_button_state state);
 void (*axis)(struct wlr_seat_pointer_grab *grab, uint32_t time_msec,
   enum wl_pointer_axis orientation, double value,
   int32_t value_discrete, enum wl_pointer_axis_source source,
   enum wl_pointer_axis_relative_direction relative_direction);
 void (*frame)(struct wlr_seat_pointer_grab *grab);
 void (*cancel)(struct wlr_seat_pointer_grab *grab);
};
struct wlr_seat_keyboard_grab;
struct wlr_keyboard_grab_interface {
 void (*enter)(struct wlr_seat_keyboard_grab *grab,
   struct wlr_surface *surface, const uint32_t keycodes[],
   size_t num_keycodes, const struct wlr_keyboard_modifiers *modifiers);
 void (*clear_focus)(struct wlr_seat_keyboard_grab *grab);
 void (*key)(struct wlr_seat_keyboard_grab *grab, uint32_t time_msec,
   uint32_t key, uint32_t state);
 void (*modifiers)(struct wlr_seat_keyboard_grab *grab,
   const struct wlr_keyboard_modifiers *modifiers);
 void (*cancel)(struct wlr_seat_keyboard_grab *grab);
};
struct wlr_seat_touch_grab;
struct wlr_touch_grab_interface {
 uint32_t (*down)(struct wlr_seat_touch_grab *grab, uint32_t time_msec,
   struct wlr_touch_point *point);
 uint32_t (*up)(struct wlr_seat_touch_grab *grab, uint32_t time_msec,
   struct wlr_touch_point *point);
 void (*motion)(struct wlr_seat_touch_grab *grab, uint32_t time_msec,
   struct wlr_touch_point *point);
 void (*enter)(struct wlr_seat_touch_grab *grab, uint32_t time_msec,
   struct wlr_touch_point *point);
 void (*frame)(struct wlr_seat_touch_grab *grab);
 void (*cancel)(struct wlr_seat_touch_grab *grab);
 void (*wl_cancel)(struct wlr_seat_touch_grab *grab,
   struct wlr_seat_client *seat_client);
};
struct wlr_seat_touch_grab {
 const struct wlr_touch_grab_interface *interface;
 struct wlr_seat *seat;
 void *data;
};
struct wlr_seat_keyboard_grab {
 const struct wlr_keyboard_grab_interface *interface;
 struct wlr_seat *seat;
 void *data;
};
struct wlr_seat_pointer_grab {
 const struct wlr_pointer_grab_interface *interface;
 struct wlr_seat *seat;
 void *data;
};
struct wlr_seat_pointer_state {
 struct wlr_seat *seat;
 struct wlr_seat_client *focused_client;
 struct wlr_surface *focused_surface;
 double sx, sy;
 struct wlr_seat_pointer_grab *grab;
 struct wlr_seat_pointer_grab *default_grab;
_Bool
     sent_axis_source;
 enum wl_pointer_axis_source cached_axis_source;
 uint32_t buttons[16];
 size_t button_count;
 uint32_t grab_button;
 uint32_t grab_serial;
 uint32_t grab_time;
 struct wl_listener surface_destroy;
 struct {
  struct wl_signal focus_change;
 } events;
};
struct wlr_seat_keyboard_state {
 struct wlr_seat *seat;
 struct wlr_keyboard *keyboard;
 struct wlr_seat_client *focused_client;
 struct wlr_surface *focused_surface;
 struct wl_listener keyboard_destroy;
 struct wl_listener keyboard_keymap;
 struct wl_listener keyboard_repeat_info;
 struct wl_listener surface_destroy;
 struct wlr_seat_keyboard_grab *grab;
 struct wlr_seat_keyboard_grab *default_grab;
 struct {
  struct wl_signal focus_change;
 } events;
};
struct wlr_seat_touch_state {
 struct wlr_seat *seat;
 struct wl_list touch_points;
 uint32_t grab_serial;
 uint32_t grab_id;
 struct wlr_seat_touch_grab *grab;
 struct wlr_seat_touch_grab *default_grab;
};
struct wlr_primary_selection_source;
struct wlr_seat {
 struct wl_global *global;
 struct wl_display *display;
 struct wl_list clients;
 char *name;
 uint32_t capabilities;
 uint32_t accumulated_capabilities;
 struct timespec last_event;
 struct wlr_data_source *selection_source;
 uint32_t selection_serial;
 struct wl_list selection_offers;
 struct wlr_primary_selection_source *primary_selection_source;
 uint32_t primary_selection_serial;
 struct wlr_drag *drag;
 struct wlr_data_source *drag_source;
 uint32_t drag_serial;
 struct wl_list drag_offers;
 struct wlr_seat_pointer_state pointer_state;
 struct wlr_seat_keyboard_state keyboard_state;
 struct wlr_seat_touch_state touch_state;
 struct wl_listener display_destroy;
 struct wl_listener selection_source_destroy;
 struct wl_listener primary_selection_source_destroy;
 struct wl_listener drag_source_destroy;
 struct {
  struct wl_signal pointer_grab_begin;
  struct wl_signal pointer_grab_end;
  struct wl_signal keyboard_grab_begin;
  struct wl_signal keyboard_grab_end;
  struct wl_signal touch_grab_begin;
  struct wl_signal touch_grab_end;
  struct wl_signal request_set_cursor;
  struct wl_signal request_set_selection;
  struct wl_signal set_selection;
  struct wl_signal request_set_primary_selection;
  struct wl_signal set_primary_selection;
  struct wl_signal request_start_drag;
  struct wl_signal start_drag;
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_seat_pointer_request_set_cursor_event {
 struct wlr_seat_client *seat_client;
 struct wlr_surface *surface;
 uint32_t serial;
 int32_t hotspot_x, hotspot_y;
};
struct wlr_seat_request_set_selection_event {
 struct wlr_data_source *source;
 uint32_t serial;
};
struct wlr_seat_request_set_primary_selection_event {
 struct wlr_primary_selection_source *source;
 uint32_t serial;
};
struct wlr_seat_request_start_drag_event {
 struct wlr_drag *drag;
 struct wlr_surface *origin;
 uint32_t serial;
};
struct wlr_seat_pointer_focus_change_event {
 struct wlr_seat *seat;
 struct wlr_surface *old_surface, *new_surface;
 double sx, sy;
};
struct wlr_seat_keyboard_focus_change_event {
 struct wlr_seat *seat;
 struct wlr_surface *old_surface, *new_surface;
};
struct wlr_seat *wlr_seat_create(struct wl_display *display, const char *name);
void wlr_seat_destroy(struct wlr_seat *wlr_seat);
struct wlr_seat_client *wlr_seat_client_for_wl_client(struct wlr_seat *wlr_seat,
  struct wl_client *wl_client);
void wlr_seat_set_capabilities(struct wlr_seat *wlr_seat,
  uint32_t capabilities);
void wlr_seat_set_name(struct wlr_seat *wlr_seat, const char *name);
_Bool
    wlr_seat_pointer_surface_has_focus(struct wlr_seat *wlr_seat,
  struct wlr_surface *surface);
void wlr_seat_pointer_enter(struct wlr_seat *wlr_seat,
  struct wlr_surface *surface, double sx, double sy);
void wlr_seat_pointer_clear_focus(struct wlr_seat *wlr_seat);
void wlr_seat_pointer_send_motion(struct wlr_seat *wlr_seat, uint32_t time_msec,
  double sx, double sy);
uint32_t wlr_seat_pointer_send_button(struct wlr_seat *wlr_seat,
  uint32_t time_msec, uint32_t button, enum wl_pointer_button_state state);
void wlr_seat_pointer_send_axis(struct wlr_seat *wlr_seat, uint32_t time_msec,
  enum wl_pointer_axis orientation, double value,
  int32_t value_discrete, enum wl_pointer_axis_source source,
  enum wl_pointer_axis_relative_direction relative_direction);
void wlr_seat_pointer_send_frame(struct wlr_seat *wlr_seat);
void wlr_seat_pointer_notify_enter(struct wlr_seat *wlr_seat,
  struct wlr_surface *surface, double sx, double sy);
void wlr_seat_pointer_notify_clear_focus(struct wlr_seat *wlr_seat);
void wlr_seat_pointer_warp(struct wlr_seat *wlr_seat, double sx, double sy);
void wlr_seat_pointer_notify_motion(struct wlr_seat *wlr_seat,
  uint32_t time_msec, double sx, double sy);
uint32_t wlr_seat_pointer_notify_button(struct wlr_seat *wlr_seat,
  uint32_t time_msec, uint32_t button, enum wl_pointer_button_state state);
void wlr_seat_pointer_notify_axis(struct wlr_seat *wlr_seat, uint32_t time_msec,
  enum wl_pointer_axis orientation, double value,
  int32_t value_discrete, enum wl_pointer_axis_source source,
  enum wl_pointer_axis_relative_direction relative_direction);
void wlr_seat_pointer_notify_frame(struct wlr_seat *wlr_seat);
void wlr_seat_pointer_start_grab(struct wlr_seat *wlr_seat,
  struct wlr_seat_pointer_grab *grab);
void wlr_seat_pointer_end_grab(struct wlr_seat *wlr_seat);
_Bool
    wlr_seat_pointer_has_grab(struct wlr_seat *seat);
void wlr_seat_set_keyboard(struct wlr_seat *seat, struct wlr_keyboard *keyboard);
struct wlr_keyboard *wlr_seat_get_keyboard(struct wlr_seat *seat);
void wlr_seat_keyboard_send_key(struct wlr_seat *seat, uint32_t time_msec,
  uint32_t key, uint32_t state);
void wlr_seat_keyboard_send_modifiers(struct wlr_seat *seat,
  const struct wlr_keyboard_modifiers *modifiers);
void wlr_seat_keyboard_enter(struct wlr_seat *seat,
  struct wlr_surface *surface, const uint32_t keycodes[], size_t num_keycodes,
  const struct wlr_keyboard_modifiers *modifiers);
void wlr_seat_keyboard_clear_focus(struct wlr_seat *wlr_seat);
void wlr_seat_keyboard_notify_key(struct wlr_seat *seat, uint32_t time_msec,
  uint32_t key, uint32_t state);
void wlr_seat_keyboard_notify_modifiers(struct wlr_seat *seat,
  const struct wlr_keyboard_modifiers *modifiers);
void wlr_seat_keyboard_notify_enter(struct wlr_seat *seat,
  struct wlr_surface *surface, const uint32_t keycodes[], size_t num_keycodes,
  const struct wlr_keyboard_modifiers *modifiers);
void wlr_seat_keyboard_notify_clear_focus(struct wlr_seat *wlr_seat);
void wlr_seat_keyboard_start_grab(struct wlr_seat *wlr_seat,
  struct wlr_seat_keyboard_grab *grab);
void wlr_seat_keyboard_end_grab(struct wlr_seat *wlr_seat);
_Bool
    wlr_seat_keyboard_has_grab(struct wlr_seat *seat);
struct wlr_touch_point *wlr_seat_touch_get_point(struct wlr_seat *seat,
  int32_t touch_id);
void wlr_seat_touch_point_focus(struct wlr_seat *seat,
  struct wlr_surface *surface, uint32_t time_msec,
  int32_t touch_id, double sx, double sy);
void wlr_seat_touch_point_clear_focus(struct wlr_seat *seat, uint32_t time_msec,
  int32_t touch_id);
uint32_t wlr_seat_touch_send_down(struct wlr_seat *seat,
  struct wlr_surface *surface, uint32_t time_msec,
  int32_t touch_id, double sx, double sy);
uint32_t wlr_seat_touch_send_up(struct wlr_seat *seat, uint32_t time_msec,
  int32_t touch_id);
void wlr_seat_touch_send_motion(struct wlr_seat *seat, uint32_t time_msec,
  int32_t touch_id, double sx, double sy);
void wlr_seat_touch_send_cancel(struct wlr_seat *seat,
  struct wlr_seat_client *seat_client);
void wlr_seat_touch_send_frame(struct wlr_seat *seat);
uint32_t wlr_seat_touch_notify_down(struct wlr_seat *seat,
  struct wlr_surface *surface, uint32_t time_msec,
  int32_t touch_id, double sx, double sy);
uint32_t wlr_seat_touch_notify_up(struct wlr_seat *seat, uint32_t time_msec,
  int32_t touch_id);
void wlr_seat_touch_notify_motion(struct wlr_seat *seat, uint32_t time_msec,
  int32_t touch_id, double sx, double sy);
void wlr_seat_touch_notify_cancel(struct wlr_seat *seat,
  struct wlr_seat_client *seat_client);
void wlr_seat_touch_notify_frame(struct wlr_seat *seat);
int wlr_seat_touch_num_points(struct wlr_seat *seat);
void wlr_seat_touch_start_grab(struct wlr_seat *wlr_seat,
  struct wlr_seat_touch_grab *grab);
void wlr_seat_touch_end_grab(struct wlr_seat *wlr_seat);
_Bool
    wlr_seat_touch_has_grab(struct wlr_seat *seat);
_Bool
    wlr_seat_validate_pointer_grab_serial(struct wlr_seat *seat,
 struct wlr_surface *origin, uint32_t serial);
_Bool
    wlr_seat_validate_touch_grab_serial(struct wlr_seat *seat,
 struct wlr_surface *origin, uint32_t serial,
 struct wlr_touch_point **point_ptr);
uint32_t wlr_seat_client_next_serial(struct wlr_seat_client *client);
_Bool
    wlr_seat_client_validate_event_serial(struct wlr_seat_client *client,
 uint32_t serial);
struct wlr_seat_client *wlr_seat_client_from_resource(
 struct wl_resource *resource);
struct wlr_seat_client *wlr_seat_client_from_pointer_resource(
 struct wl_resource *resource);
_Bool
    wlr_surface_accepts_touch(struct wlr_seat *wlr_seat, struct wlr_surface *surface);
struct wlr_data_control_manager_v1 {
 struct wl_global *global;
 struct wl_list devices;
 struct {
  struct wl_signal destroy;
  struct wl_signal new_device;
 } events;
 struct wl_listener display_destroy;
};
struct wlr_data_control_device_v1 {
 struct wl_resource *resource;
 struct wlr_data_control_manager_v1 *manager;
 struct wl_list link;
 struct wlr_seat *seat;
 struct wl_resource *selection_offer_resource;
 struct wl_resource *primary_selection_offer_resource;
 struct wl_listener seat_destroy;
 struct wl_listener seat_set_selection;
 struct wl_listener seat_set_primary_selection;
};
struct wlr_data_control_manager_v1 *wlr_data_control_manager_v1_create(
 struct wl_display *display);
void wlr_data_control_device_v1_destroy(
 struct wlr_data_control_device_v1 *device);
struct wlr_data_device_manager {
 struct wl_global *global;
 struct wl_list data_sources;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
enum wlr_data_offer_type {
 WLR_DATA_OFFER_SELECTION,
 WLR_DATA_OFFER_DRAG,
};
struct wlr_data_offer {
 struct wl_resource *resource;
 struct wlr_data_source *source;
 enum wlr_data_offer_type type;
 struct wl_list link;
 uint32_t actions;
 enum wl_data_device_manager_dnd_action preferred_action;
_Bool
     in_ask;
 struct wl_listener source_destroy;
};
struct wlr_data_source_impl {
 void (*send)(struct wlr_data_source *source, const char *mime_type,
  int32_t fd);
 void (*accept)(struct wlr_data_source *source, uint32_t serial,
  const char *mime_type);
 void (*destroy)(struct wlr_data_source *source);
 void (*dnd_drop)(struct wlr_data_source *source);
 void (*dnd_finish)(struct wlr_data_source *source);
 void (*dnd_action)(struct wlr_data_source *source,
  enum wl_data_device_manager_dnd_action action);
};
struct wlr_data_source {
 const struct wlr_data_source_impl *impl;
 struct wl_array mime_types;
 int32_t actions;
_Bool
     accepted;
 enum wl_data_device_manager_dnd_action current_dnd_action;
 uint32_t compositor_action;
 struct {
  struct wl_signal destroy;
 } events;
};
struct wlr_drag;
struct wlr_drag_icon {
 struct wlr_drag *drag;
 struct wlr_surface *surface;
 struct {
  struct wl_signal destroy;
 } events;
 struct wl_listener surface_destroy;
 void *data;
};
enum wlr_drag_grab_type {
 WLR_DRAG_GRAB_KEYBOARD,
 WLR_DRAG_GRAB_KEYBOARD_POINTER,
 WLR_DRAG_GRAB_KEYBOARD_TOUCH,
};
struct wlr_drag {
 enum wlr_drag_grab_type grab_type;
 struct wlr_seat_keyboard_grab keyboard_grab;
 struct wlr_seat_pointer_grab pointer_grab;
 struct wlr_seat_touch_grab touch_grab;
 struct wlr_seat *seat;
 struct wlr_seat_client *seat_client;
 struct wlr_seat_client *focus_client;
 struct wlr_drag_icon *icon;
 struct wlr_surface *focus;
 struct wlr_data_source *source;
_Bool
     started, dropped, cancelling;
 int32_t grab_touch_id, touch_id;
 struct {
  struct wl_signal focus;
  struct wl_signal motion;
  struct wl_signal drop;
  struct wl_signal destroy;
 } events;
 struct wl_listener source_destroy;
 struct wl_listener seat_client_destroy;
 struct wl_listener icon_destroy;
 void *data;
};
struct wlr_drag_motion_event {
 struct wlr_drag *drag;
 uint32_t time;
 double sx, sy;
};
struct wlr_drag_drop_event {
 struct wlr_drag *drag;
 uint32_t time;
};
struct wlr_data_device_manager *wlr_data_device_manager_create(
 struct wl_display *display);
void wlr_seat_request_set_selection(struct wlr_seat *seat,
 struct wlr_seat_client *client, struct wlr_data_source *source,
 uint32_t serial);
void wlr_seat_set_selection(struct wlr_seat *seat,
 struct wlr_data_source *source, uint32_t serial);
struct wlr_drag *wlr_drag_create(struct wlr_seat_client *seat_client,
 struct wlr_data_source *source, struct wlr_surface *icon_surface);
void wlr_seat_request_start_drag(struct wlr_seat *seat, struct wlr_drag *drag,
 struct wlr_surface *origin, uint32_t serial);
void wlr_seat_start_drag(struct wlr_seat *seat, struct wlr_drag *drag,
 uint32_t serial);
void wlr_seat_start_pointer_drag(struct wlr_seat *seat, struct wlr_drag *drag,
 uint32_t serial);
void wlr_seat_start_touch_drag(struct wlr_seat *seat, struct wlr_drag *drag,
 uint32_t serial, struct wlr_touch_point *point);
void wlr_data_source_init(struct wlr_data_source *source,
 const struct wlr_data_source_impl *impl);
void wlr_data_source_send(struct wlr_data_source *source, const char *mime_type,
 int32_t fd);
void wlr_data_source_accept(struct wlr_data_source *source, uint32_t serial,
 const char *mime_type);
void wlr_data_source_destroy(struct wlr_data_source *source);
void wlr_data_source_dnd_drop(struct wlr_data_source *source);
void wlr_data_source_dnd_finish(struct wlr_data_source *source);
void wlr_data_source_dnd_action(struct wlr_data_source *source,
 enum wl_data_device_manager_dnd_action action);
struct wlr_renderer;
struct wlr_drm_buffer {
 struct wlr_buffer base;
 struct wl_resource *resource;
 struct wlr_dmabuf_attributes dmabuf;
 struct wl_listener release;
};
struct wlr_drm {
 struct wl_global *global;
 struct {
  struct wl_signal destroy;
 } events;
 char *node_name;
 struct wlr_drm_format_set formats;
 struct wl_listener display_destroy;
};
struct wlr_drm_buffer *wlr_drm_buffer_try_from_resource(
 struct wl_resource *resource);
struct wlr_drm *wlr_drm_create(struct wl_display *display,
 struct wlr_renderer *renderer);
struct wlr_backend;
struct wlr_output;
struct wlr_drm_lease_v1_manager {
 struct wl_list devices;
 struct wl_display *display;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal request;
 } events;
};
struct wlr_drm_lease_device_v1 {
 struct wl_list resources;
 struct wl_global *global;
 struct wlr_drm_lease_v1_manager *manager;
 struct wlr_backend *backend;
 struct wl_list connectors;
 struct wl_list leases;
 struct wl_list requests;
 struct wl_list link;
 struct wl_listener backend_destroy;
 void *data;
};
struct wlr_drm_lease_v1;
struct wlr_drm_lease_connector_v1 {
 struct wl_list resources;
 struct wlr_output *output;
 struct wlr_drm_lease_device_v1 *device;
 struct wlr_drm_lease_v1 *active_lease;
 struct wl_listener destroy;
 struct wl_list link;
};
struct wlr_drm_lease_request_v1 {
 struct wl_resource *resource;
 struct wlr_drm_lease_device_v1 *device;
 struct wlr_drm_lease_connector_v1 **connectors;
 size_t n_connectors;
 struct wl_resource *lease_resource;
_Bool
     invalid;
 struct wl_list link;
};
struct wlr_drm_lease_v1 {
 struct wl_resource *resource;
 struct wlr_drm_lease *drm_lease;
 struct wlr_drm_lease_device_v1 *device;
 struct wlr_drm_lease_connector_v1 **connectors;
 size_t n_connectors;
 struct wl_list link;
 struct wl_listener destroy;
 void *data;
};
struct wlr_drm_lease_v1_manager *wlr_drm_lease_v1_manager_create(
 struct wl_display *display, struct wlr_backend *backend);
_Bool
    wlr_drm_lease_v1_manager_offer_output(
 struct wlr_drm_lease_v1_manager *manager, struct wlr_output *output);
void wlr_drm_lease_v1_manager_withdraw_output(
 struct wlr_drm_lease_v1_manager *manager, struct wlr_output *output);
struct wlr_drm_lease_v1 *wlr_drm_lease_request_v1_grant(
 struct wlr_drm_lease_request_v1 *request);
void wlr_drm_lease_request_v1_reject(struct wlr_drm_lease_request_v1 *request);
void wlr_drm_lease_v1_revoke(struct wlr_drm_lease_v1 *lease);
struct wlr_export_dmabuf_manager_v1 {
 struct wl_global *global;
 struct wl_list frames;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
};
struct wlr_export_dmabuf_frame_v1 {
 struct wl_resource *resource;
 struct wlr_export_dmabuf_manager_v1 *manager;
 struct wl_list link;
 struct wlr_output *output;
_Bool
     cursor_locked;
 struct wl_listener output_commit;
 struct wl_listener output_destroy;
};
struct wlr_export_dmabuf_manager_v1 *wlr_export_dmabuf_manager_v1_create(
 struct wl_display *display);
struct wlr_ext_foreign_toplevel_list_v1 {
 struct wl_global *global;
 struct wl_list resources;
 struct wl_list toplevels;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_ext_foreign_toplevel_handle_v1 {
 struct wlr_ext_foreign_toplevel_list_v1 *list;
 struct wl_list resources;
 struct wl_list link;
 char *title;
 char *app_id;
 char *identifier;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_ext_foreign_toplevel_handle_v1_state {
 const char *title;
 const char *app_id;
};
struct wlr_ext_foreign_toplevel_list_v1 *wlr_ext_foreign_toplevel_list_v1_create(
 struct wl_display *display, uint32_t version);
struct wlr_ext_foreign_toplevel_handle_v1 *wlr_ext_foreign_toplevel_handle_v1_create(
 struct wlr_ext_foreign_toplevel_list_v1 *list,
 const struct wlr_ext_foreign_toplevel_handle_v1_state *state);
void wlr_ext_foreign_toplevel_handle_v1_destroy(
 struct wlr_ext_foreign_toplevel_handle_v1 *toplevel);
void wlr_ext_foreign_toplevel_handle_v1_update_state(
 struct wlr_ext_foreign_toplevel_handle_v1 *toplevel,
 const struct wlr_ext_foreign_toplevel_handle_v1_state *state);
struct wlr_foreign_toplevel_manager_v1 {
 struct wl_event_loop *event_loop;
 struct wl_global *global;
 struct wl_list resources;
 struct wl_list toplevels;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
enum wlr_foreign_toplevel_handle_v1_state {
 WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MAXIMIZED = (1 << 0),
 WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_MINIMIZED = (1 << 1),
 WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_ACTIVATED = (1 << 2),
 WLR_FOREIGN_TOPLEVEL_HANDLE_V1_STATE_FULLSCREEN = (1 << 3),
};
struct wlr_foreign_toplevel_handle_v1_output {
 struct wl_list link;
 struct wlr_output *output;
 struct wlr_foreign_toplevel_handle_v1 *toplevel;
 struct wl_listener output_bind;
 struct wl_listener output_destroy;
};
struct wlr_foreign_toplevel_handle_v1 {
 struct wlr_foreign_toplevel_manager_v1 *manager;
 struct wl_list resources;
 struct wl_list link;
 struct wl_event_source *idle_source;
 char *title;
 char *app_id;
 struct wlr_foreign_toplevel_handle_v1 *parent;
 struct wl_list outputs;
 uint32_t state;
 struct {
  struct wl_signal request_maximize;
  struct wl_signal request_minimize;
  struct wl_signal request_activate;
  struct wl_signal request_fullscreen;
  struct wl_signal request_close;
  struct wl_signal set_rectangle;
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_foreign_toplevel_handle_v1_maximized_event {
 struct wlr_foreign_toplevel_handle_v1 *toplevel;
_Bool
     maximized;
};
struct wlr_foreign_toplevel_handle_v1_minimized_event {
 struct wlr_foreign_toplevel_handle_v1 *toplevel;
_Bool
     minimized;
};
struct wlr_foreign_toplevel_handle_v1_activated_event {
 struct wlr_foreign_toplevel_handle_v1 *toplevel;
 struct wlr_seat *seat;
};
struct wlr_foreign_toplevel_handle_v1_fullscreen_event {
 struct wlr_foreign_toplevel_handle_v1 *toplevel;
_Bool
     fullscreen;
 struct wlr_output *output;
};
struct wlr_foreign_toplevel_handle_v1_set_rectangle_event {
 struct wlr_foreign_toplevel_handle_v1 *toplevel;
 struct wlr_surface *surface;
 int32_t x, y, width, height;
};
struct wlr_foreign_toplevel_manager_v1 *wlr_foreign_toplevel_manager_v1_create(
 struct wl_display *display);
struct wlr_foreign_toplevel_handle_v1 *wlr_foreign_toplevel_handle_v1_create(
 struct wlr_foreign_toplevel_manager_v1 *manager);
void wlr_foreign_toplevel_handle_v1_destroy(
 struct wlr_foreign_toplevel_handle_v1 *toplevel);
void wlr_foreign_toplevel_handle_v1_set_title(
 struct wlr_foreign_toplevel_handle_v1 *toplevel, const char *title);
void wlr_foreign_toplevel_handle_v1_set_app_id(
 struct wlr_foreign_toplevel_handle_v1 *toplevel, const char *app_id);
void wlr_foreign_toplevel_handle_v1_output_enter(
 struct wlr_foreign_toplevel_handle_v1 *toplevel, struct wlr_output *output);
void wlr_foreign_toplevel_handle_v1_output_leave(
 struct wlr_foreign_toplevel_handle_v1 *toplevel, struct wlr_output *output);
void wlr_foreign_toplevel_handle_v1_set_maximized(
 struct wlr_foreign_toplevel_handle_v1 *toplevel,
                                                 _Bool
                                                      maximized);
void wlr_foreign_toplevel_handle_v1_set_minimized(
 struct wlr_foreign_toplevel_handle_v1 *toplevel,
                                                 _Bool
                                                      minimized);
void wlr_foreign_toplevel_handle_v1_set_activated(
 struct wlr_foreign_toplevel_handle_v1 *toplevel,
                                                 _Bool
                                                      activated);
void wlr_foreign_toplevel_handle_v1_set_fullscreen(
 struct wlr_foreign_toplevel_handle_v1* toplevel,
                                                 _Bool
                                                      fullscreen);
void wlr_foreign_toplevel_handle_v1_set_parent(
 struct wlr_foreign_toplevel_handle_v1 *toplevel,
 struct wlr_foreign_toplevel_handle_v1 *parent);
struct wlr_surface;
struct wlr_fractional_scale_manager_v1 {
 struct wl_global *global;
 struct {
  struct wl_signal destroy;
 } events;
 struct wl_listener display_destroy;
};
void wlr_fractional_scale_v1_notify_scale(
  struct wlr_surface *surface, double scale);
struct wlr_fractional_scale_manager_v1 *wlr_fractional_scale_manager_v1_create(
  struct wl_display *display, uint32_t version);
struct wlr_fullscreen_shell_v1 {
 struct wl_global *global;
 struct {
  struct wl_signal destroy;
  struct wl_signal present_surface;
 } events;
 struct wl_listener display_destroy;
 void *data;
};
struct wlr_fullscreen_shell_v1_present_surface_event {
 struct wl_client *client;
 struct wlr_surface *surface;
 enum zwp_fullscreen_shell_v1_present_method method;
 struct wlr_output *output;
};
struct wlr_fullscreen_shell_v1 *wlr_fullscreen_shell_v1_create(
 struct wl_display *display);
struct wlr_output;
struct wlr_output_state;
struct wlr_gamma_control_manager_v1 {
 struct wl_global *global;
 struct wl_list controls;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
  struct wl_signal set_gamma;
 } events;
 void *data;
};
struct wlr_gamma_control_manager_v1_set_gamma_event {
 struct wlr_output *output;
 struct wlr_gamma_control_v1 *control;
};
struct wlr_gamma_control_v1 {
 struct wl_resource *resource;
 struct wlr_output *output;
 struct wlr_gamma_control_manager_v1 *manager;
 struct wl_list link;
 uint16_t *table;
 size_t ramp_size;
 struct wl_listener output_destroy_listener;
 void *data;
};
struct wlr_gamma_control_manager_v1 *wlr_gamma_control_manager_v1_create(
 struct wl_display *display);
struct wlr_gamma_control_v1 *wlr_gamma_control_manager_v1_get_control(
 struct wlr_gamma_control_manager_v1 *manager, struct wlr_output *output);
_Bool
    wlr_gamma_control_v1_apply(struct wlr_gamma_control_v1 *gamma_control,
 struct wlr_output_state *output_state);
void wlr_gamma_control_v1_send_failed_and_destroy(struct wlr_gamma_control_v1 *gamma_control);
struct wlr_idle_inhibit_manager_v1 {
 struct wl_list inhibitors;
 struct wl_global *global;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal new_inhibitor;
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_idle_inhibitor_v1 {
 struct wlr_surface *surface;
 struct wl_resource *resource;
 struct wl_listener surface_destroy;
 struct wl_list link;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_idle_inhibit_manager_v1 *wlr_idle_inhibit_v1_create(struct wl_display *display);
struct wlr_seat;
struct wlr_idle_notifier_v1 {
 struct wl_global *global;
_Bool
     inhibited;
 struct wl_list notifications;
 struct wl_listener display_destroy;
};
struct wlr_idle_notifier_v1 *wlr_idle_notifier_v1_create(struct wl_display *display);
void wlr_idle_notifier_v1_set_inhibited(struct wlr_idle_notifier_v1 *notifier,
_Bool
     inhibited);
void wlr_idle_notifier_v1_notify_activity(struct wlr_idle_notifier_v1 *notifier,
 struct wlr_seat *seat);
struct wlr_input_method_v2_preedit_string {
 char *text;
 int32_t cursor_begin;
 int32_t cursor_end;
};
struct wlr_input_method_v2_delete_surrounding_text {
 uint32_t before_length;
 uint32_t after_length;
};
struct wlr_input_method_v2_state {
 struct wlr_input_method_v2_preedit_string preedit;
 char *commit_text;
 struct wlr_input_method_v2_delete_surrounding_text delete;
};
struct wlr_input_method_v2 {
 struct wl_resource *resource;
 struct wlr_seat *seat;
 struct wlr_seat_client *seat_client;
 struct wlr_input_method_v2_state pending;
 struct wlr_input_method_v2_state current;
_Bool
     active;
_Bool
     client_active;
 uint32_t current_serial;
 struct wl_list popup_surfaces;
 struct wlr_input_method_keyboard_grab_v2 *keyboard_grab;
 struct wl_list link;
 struct wl_listener seat_client_destroy;
 struct {
  struct wl_signal commit;
  struct wl_signal new_popup_surface;
  struct wl_signal grab_keyboard;
  struct wl_signal destroy;
 } events;
};
struct wlr_input_popup_surface_v2 {
 struct wl_resource *resource;
 struct wlr_input_method_v2 *input_method;
 struct wl_list link;
 struct wlr_surface *surface;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_input_method_keyboard_grab_v2 {
 struct wl_resource *resource;
 struct wlr_input_method_v2 *input_method;
 struct wlr_keyboard *keyboard;
 struct wl_listener keyboard_keymap;
 struct wl_listener keyboard_repeat_info;
 struct wl_listener keyboard_destroy;
 struct {
  struct wl_signal destroy;
 } events;
};
struct wlr_input_method_manager_v2 {
 struct wl_global *global;
 struct wl_list input_methods;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal input_method;
  struct wl_signal destroy;
 } events;
};
struct wlr_input_method_manager_v2 *wlr_input_method_manager_v2_create(
 struct wl_display *display);
void wlr_input_method_v2_send_activate(
 struct wlr_input_method_v2 *input_method);
void wlr_input_method_v2_send_deactivate(
 struct wlr_input_method_v2 *input_method);
void wlr_input_method_v2_send_surrounding_text(
 struct wlr_input_method_v2 *input_method, const char *text,
 uint32_t cursor, uint32_t anchor);
void wlr_input_method_v2_send_content_type(
 struct wlr_input_method_v2 *input_method, uint32_t hint,
 uint32_t purpose);
void wlr_input_method_v2_send_text_change_cause(
 struct wlr_input_method_v2 *input_method, uint32_t cause);
void wlr_input_method_v2_send_done(struct wlr_input_method_v2 *input_method);
void wlr_input_method_v2_send_unavailable(
 struct wlr_input_method_v2 *input_method);
struct wlr_input_popup_surface_v2 *wlr_input_popup_surface_v2_try_from_wlr_surface(
 struct wlr_surface *surface);
void wlr_input_popup_surface_v2_send_text_input_rectangle(
    struct wlr_input_popup_surface_v2 *popup_surface, struct wlr_box *sbox);
void wlr_input_method_keyboard_grab_v2_send_key(
 struct wlr_input_method_keyboard_grab_v2 *keyboard_grab,
 uint32_t time, uint32_t key, uint32_t state);
void wlr_input_method_keyboard_grab_v2_send_modifiers(
 struct wlr_input_method_keyboard_grab_v2 *keyboard_grab,
 struct wlr_keyboard_modifiers *modifiers);
void wlr_input_method_keyboard_grab_v2_set_keyboard(
 struct wlr_input_method_keyboard_grab_v2 *keyboard_grab,
 struct wlr_keyboard *keyboard);
void wlr_input_method_keyboard_grab_v2_destroy(
 struct wlr_input_method_keyboard_grab_v2 *keyboard_grab);
struct wlr_keyboard_group {
 struct wlr_keyboard keyboard;
 struct wl_list devices;
 struct wl_list keys;
 struct {
  struct wl_signal enter;
  struct wl_signal leave;
 } events;
 void *data;
};
struct wlr_keyboard_group *wlr_keyboard_group_create(void);
struct wlr_keyboard_group *wlr_keyboard_group_from_wlr_keyboard(
  struct wlr_keyboard *keyboard);
_Bool
    wlr_keyboard_group_add_keyboard(struct wlr_keyboard_group *group,
  struct wlr_keyboard *keyboard);
void wlr_keyboard_group_remove_keyboard(struct wlr_keyboard_group *group,
  struct wlr_keyboard *keyboard);
void wlr_keyboard_group_destroy(struct wlr_keyboard_group *group);
struct wlr_keyboard_shortcuts_inhibit_manager_v1 {
 struct wl_list inhibitors;
 struct wl_global *global;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal new_inhibitor;
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_keyboard_shortcuts_inhibitor_v1 {
 struct wlr_surface *surface;
 struct wlr_seat *seat;
_Bool
     active;
 struct wl_resource *resource;
 struct wl_listener surface_destroy;
 struct wl_listener seat_destroy;
 struct wl_list link;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_keyboard_shortcuts_inhibit_manager_v1 *
wlr_keyboard_shortcuts_inhibit_v1_create(struct wl_display *display);
void wlr_keyboard_shortcuts_inhibitor_v1_activate(
 struct wlr_keyboard_shortcuts_inhibitor_v1 *inhibitor);
void wlr_keyboard_shortcuts_inhibitor_v1_deactivate(
 struct wlr_keyboard_shortcuts_inhibitor_v1 *inhibitor);
struct wlr_layer_shell_v1 {
 struct wl_global *global;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal new_surface;
  struct wl_signal destroy;
 } events;
 void *data;
};
enum wlr_layer_surface_v1_state_field {
 WLR_LAYER_SURFACE_V1_STATE_DESIRED_SIZE = 1 << 0,
 WLR_LAYER_SURFACE_V1_STATE_ANCHOR = 1 << 1,
 WLR_LAYER_SURFACE_V1_STATE_EXCLUSIVE_ZONE = 1 << 2,
 WLR_LAYER_SURFACE_V1_STATE_MARGIN = 1 << 3,
 WLR_LAYER_SURFACE_V1_STATE_KEYBOARD_INTERACTIVITY = 1 << 4,
 WLR_LAYER_SURFACE_V1_STATE_LAYER = 1 << 5,
};
struct wlr_layer_surface_v1_state {
 uint32_t committed;
 uint32_t anchor;
 int32_t exclusive_zone;
 struct {
  int32_t top, right, bottom, left;
 } margin;
 enum zwlr_layer_surface_v1_keyboard_interactivity keyboard_interactive;
 uint32_t desired_width, desired_height;
 enum zwlr_layer_shell_v1_layer layer;
 uint32_t configure_serial;
 uint32_t actual_width, actual_height;
};
struct wlr_layer_surface_v1_configure {
 struct wl_list link;
 uint32_t serial;
 uint32_t width, height;
};
struct wlr_layer_surface_v1 {
 struct wlr_surface *surface;
 struct wlr_output *output;
 struct wl_resource *resource;
 struct wlr_layer_shell_v1 *shell;
 struct wl_list popups;
 char *namespace;
_Bool
     configured;
 struct wl_list configure_list;
 struct wlr_layer_surface_v1_state current, pending;
_Bool
     initialized;
_Bool
     initial_commit;
 struct {
  struct wl_signal destroy;
  struct wl_signal new_popup;
 } events;
 void *data;
 struct wlr_surface_synced synced;
};
struct wlr_layer_shell_v1 *wlr_layer_shell_v1_create(struct wl_display *display,
 uint32_t version);
uint32_t wlr_layer_surface_v1_configure(struct wlr_layer_surface_v1 *surface,
  uint32_t width, uint32_t height);
void wlr_layer_surface_v1_destroy(struct wlr_layer_surface_v1 *surface);
struct wlr_layer_surface_v1 *wlr_layer_surface_v1_try_from_wlr_surface(
  struct wlr_surface *surface);
void wlr_layer_surface_v1_for_each_surface(struct wlr_layer_surface_v1 *surface,
  wlr_surface_iterator_func_t iterator, void *user_data);
void wlr_layer_surface_v1_for_each_popup_surface(
  struct wlr_layer_surface_v1 *surface,
  wlr_surface_iterator_func_t iterator, void *user_data);
struct wlr_surface *wlr_layer_surface_v1_surface_at(
  struct wlr_layer_surface_v1 *surface, double sx, double sy,
  double *sub_x, double *sub_y);
struct wlr_surface *wlr_layer_surface_v1_popup_surface_at(
  struct wlr_layer_surface_v1 *surface, double sx, double sy,
  double *sub_x, double *sub_y);
struct wlr_layer_surface_v1 *wlr_layer_surface_v1_from_resource(
  struct wl_resource *resource);
struct stat
  {
    __dev_t st_dev;
    __ino_t st_ino;
    __nlink_t st_nlink;
    __mode_t st_mode;
    __uid_t st_uid;
    __gid_t st_gid;
    int __pad0;
    __dev_t st_rdev;
    __off_t st_size;
    __blksize_t st_blksize;
    __blkcnt_t st_blocks;
    struct timespec st_atim;
    struct timespec st_mtim;
    struct timespec st_ctim;
    __syscall_slong_t __glibc_reserved[3];
  };
struct wlr_surface;
struct wlr_dmabuf_v1_buffer {
 struct wlr_buffer base;
 struct wl_resource *resource;
 struct wlr_dmabuf_attributes attributes;
 struct wl_listener release;
};
struct wlr_dmabuf_v1_buffer *wlr_dmabuf_v1_buffer_try_from_buffer_resource(
 struct wl_resource *buffer_resource);
struct wlr_linux_dmabuf_feedback_v1 {
 dev_t main_device;
 struct wl_array tranches;
};
struct wlr_linux_dmabuf_feedback_v1_tranche {
 dev_t target_device;
 uint32_t flags;
 struct wlr_drm_format_set formats;
};
struct wlr_linux_dmabuf_v1 {
 struct wl_global *global;
 struct {
  struct wl_signal destroy;
 } events;
 struct wlr_linux_dmabuf_feedback_v1_compiled *default_feedback;
 struct wlr_drm_format_set default_formats;
 struct wl_list surfaces;
 int main_device_fd;
 struct wl_listener display_destroy;
_Bool
     (*check_dmabuf_callback)(struct wlr_dmabuf_attributes *attribs, void *data);
 void *check_dmabuf_callback_data;
};
struct wlr_linux_dmabuf_v1 *wlr_linux_dmabuf_v1_create(struct wl_display *display,
 uint32_t version, const struct wlr_linux_dmabuf_feedback_v1 *default_feedback);
struct wlr_linux_dmabuf_v1 *wlr_linux_dmabuf_v1_create_with_renderer(struct wl_display *display,
 uint32_t version, struct wlr_renderer *renderer);
void wlr_linux_dmabuf_v1_set_check_dmabuf_callback(struct wlr_linux_dmabuf_v1 *linux_dmabuf,
_Bool
     (*callback)(struct wlr_dmabuf_attributes *attribs, void *data), void *data);
_Bool
    wlr_linux_dmabuf_v1_set_surface_feedback(
 struct wlr_linux_dmabuf_v1 *linux_dmabuf, struct wlr_surface *surface,
 const struct wlr_linux_dmabuf_feedback_v1 *feedback);
struct wlr_linux_dmabuf_feedback_v1_tranche *wlr_linux_dmabuf_feedback_add_tranche(
 struct wlr_linux_dmabuf_feedback_v1 *feedback);
void wlr_linux_dmabuf_feedback_v1_finish(struct wlr_linux_dmabuf_feedback_v1 *feedback);
struct wlr_linux_dmabuf_feedback_v1_init_options {
 struct wlr_renderer *main_renderer;
 struct wlr_output *scanout_primary_output;
 const struct wlr_output_layer_feedback_event *output_layer_feedback_event;
};
_Bool
    wlr_linux_dmabuf_feedback_v1_init_with_options(struct wlr_linux_dmabuf_feedback_v1 *feedback,
 const struct wlr_linux_dmabuf_feedback_v1_init_options *options);
struct wlr_linux_drm_syncobj_surface_v1_state {
 struct wlr_drm_syncobj_timeline *acquire_timeline;
 uint64_t acquire_point;
 struct wlr_drm_syncobj_timeline *release_timeline;
 uint64_t release_point;
};
struct wlr_linux_drm_syncobj_manager_v1 {
 struct wl_global *global;
 int drm_fd;
 struct wl_listener display_destroy;
};
struct wlr_linux_drm_syncobj_manager_v1 *wlr_linux_drm_syncobj_manager_v1_create(
 struct wl_display *display, uint32_t version, int drm_fd);
struct wlr_linux_drm_syncobj_surface_v1_state *wlr_linux_drm_syncobj_v1_get_surface_state(
 struct wlr_surface *surface);
struct wlr_box;
void wlr_matrix_identity(float mat[9]);
void wlr_matrix_multiply(float mat[9], const float a[9],
 const float b[9]);
void wlr_matrix_transpose(float mat[9], const float a[9]);
void wlr_matrix_translate(float mat[9], float x, float y);
void wlr_matrix_scale(float mat[9], float x, float y);
void wlr_matrix_rotate(float mat[9], float rad);
void wlr_matrix_transform(float mat[9],
 enum wl_output_transform transform);
void wlr_matrix_project_box(float mat[9], const struct wlr_box *box,
 enum wl_output_transform transform, float rotation,
 const float projection[9]);
struct wlr_output_layer {
 struct wl_list link;
 struct wlr_addon_set addons;
 struct {
  struct wl_signal feedback;
 } events;
 void *data;
 struct wlr_fbox src_box;
 struct wlr_box dst_box;
};
struct wlr_output_layer_state {
 struct wlr_output_layer *layer;
 struct wlr_buffer *buffer;
 struct wlr_fbox src_box;
 struct wlr_box dst_box;
 const pixman_region32_t *damage;
_Bool
     accepted;
};
struct wlr_output_layer_feedback_event {
 dev_t target_device;
 const struct wlr_drm_format_set *formats;
};
struct wlr_output_layer *wlr_output_layer_create(struct wlr_output *output);
void wlr_output_layer_destroy(struct wlr_output_layer *layer);
struct wlr_output_manager_v1 {
 struct wl_display *display;
 struct wl_global *global;
 struct wl_list resources;
 struct wl_list heads;
 uint32_t serial;
_Bool
     current_configuration_dirty;
 struct {
  struct wl_signal apply;
  struct wl_signal test;
  struct wl_signal destroy;
 } events;
 struct wl_listener display_destroy;
 void *data;
};
struct wlr_output_head_v1_state {
 struct wlr_output *output;
_Bool
     enabled;
 struct wlr_output_mode *mode;
 struct {
  int32_t width, height;
  int32_t refresh;
 } custom_mode;
 int32_t x, y;
 enum wl_output_transform transform;
 float scale;
_Bool
     adaptive_sync_enabled;
};
struct wlr_output_head_v1 {
 struct wlr_output_head_v1_state state;
 struct wlr_output_manager_v1 *manager;
 struct wl_list link;
 struct wl_list resources;
 struct wl_list mode_resources;
 struct wl_listener output_destroy;
};
struct wlr_output_configuration_v1 {
 struct wl_list heads;
 struct wlr_output_manager_v1 *manager;
 uint32_t serial;
_Bool
     finalized;
_Bool
     finished;
 struct wl_resource *resource;
};
struct wlr_output_configuration_head_v1 {
 struct wlr_output_head_v1_state state;
 struct wlr_output_configuration_v1 *config;
 struct wl_list link;
 struct wl_resource *resource;
 struct wl_listener output_destroy;
};
struct wlr_output_manager_v1 *wlr_output_manager_v1_create(
 struct wl_display *display);
void wlr_output_manager_v1_set_configuration(
 struct wlr_output_manager_v1 *manager,
 struct wlr_output_configuration_v1 *config);
struct wlr_output_configuration_v1 *wlr_output_configuration_v1_create(void);
void wlr_output_configuration_v1_destroy(
 struct wlr_output_configuration_v1 *config);
void wlr_output_configuration_v1_send_succeeded(
 struct wlr_output_configuration_v1 *config);
void wlr_output_configuration_v1_send_failed(
 struct wlr_output_configuration_v1 *config);
struct wlr_output_configuration_head_v1 *
 wlr_output_configuration_head_v1_create(
 struct wlr_output_configuration_v1 *config, struct wlr_output *output);
void wlr_output_head_v1_state_apply(
 const struct wlr_output_head_v1_state *head_state,
 struct wlr_output_state *output_state);
struct wlr_backend_output_state *wlr_output_configuration_v1_build_state(
 const struct wlr_output_configuration_v1 *config, size_t *states_len);
struct wlr_output_power_manager_v1 {
 struct wl_global *global;
 struct wl_list output_powers;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal set_mode;
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_output_power_v1 {
 struct wl_resource *resource;
 struct wlr_output *output;
 struct wlr_output_power_manager_v1 *manager;
 struct wl_list link;
 struct wl_listener output_destroy_listener;
 struct wl_listener output_commit_listener;
 void *data;
};
struct wlr_output_power_v1_set_mode_event {
 struct wlr_output *output;
 enum zwlr_output_power_v1_mode mode;
};
struct wlr_output_power_manager_v1 *wlr_output_power_manager_v1_create(
 struct wl_display *display);
struct wlr_backend;
struct wlr_backend_output_state;
struct wlr_output_swapchain_manager {
 struct wlr_backend *backend;
 struct wl_array outputs;
};
void wlr_output_swapchain_manager_init(struct wlr_output_swapchain_manager *manager,
 struct wlr_backend *backend);
_Bool
    wlr_output_swapchain_manager_prepare(struct wlr_output_swapchain_manager *manager,
 const struct wlr_backend_output_state *states, size_t states_len);
struct wlr_swapchain *wlr_output_swapchain_manager_get_swapchain(
 struct wlr_output_swapchain_manager *manager, struct wlr_output *output);
void wlr_output_swapchain_manager_apply(struct wlr_output_swapchain_manager *manager);
void wlr_output_swapchain_manager_finish(struct wlr_output_swapchain_manager *manager);
struct wlr_seat;
enum wlr_pointer_constraint_v1_type {
 WLR_POINTER_CONSTRAINT_V1_LOCKED,
 WLR_POINTER_CONSTRAINT_V1_CONFINED,
};
enum wlr_pointer_constraint_v1_state_field {
 WLR_POINTER_CONSTRAINT_V1_STATE_REGION = 1 << 0,
 WLR_POINTER_CONSTRAINT_V1_STATE_CURSOR_HINT = 1 << 1,
};
struct wlr_pointer_constraint_v1_state {
 uint32_t committed;
 pixman_region32_t region;
 struct {
 _Bool
      enabled;
  double x, y;
 } cursor_hint;
};
struct wlr_pointer_constraint_v1 {
 struct wlr_pointer_constraints_v1 *pointer_constraints;
 struct wl_resource *resource;
 struct wlr_surface *surface;
 struct wlr_seat *seat;
 enum zwp_pointer_constraints_v1_lifetime lifetime;
 enum wlr_pointer_constraint_v1_type type;
 pixman_region32_t region;
 struct wlr_pointer_constraint_v1_state current, pending;
 struct wl_list link;
 struct {
  struct wl_signal set_region;
  struct wl_signal destroy;
 } events;
 void *data;
 struct wl_listener surface_commit;
 struct wl_listener surface_destroy;
 struct wl_listener seat_destroy;
 struct wlr_surface_synced synced;
};
struct wlr_pointer_constraints_v1 {
 struct wl_global *global;
 struct wl_list constraints;
 struct {
  struct wl_signal new_constraint;
 } events;
 struct wl_listener display_destroy;
 void *data;
};
struct wlr_pointer_constraints_v1 *wlr_pointer_constraints_v1_create(
 struct wl_display *display);
struct wlr_pointer_constraint_v1 *
 wlr_pointer_constraints_v1_constraint_for_surface(
 struct wlr_pointer_constraints_v1 *pointer_constraints,
 struct wlr_surface *surface, struct wlr_seat *seat);
void wlr_pointer_constraint_v1_send_activated(
 struct wlr_pointer_constraint_v1 *constraint);
void wlr_pointer_constraint_v1_send_deactivated(
 struct wlr_pointer_constraint_v1 *constraint);
struct wlr_surface;
struct wlr_pointer_gestures_v1 {
 struct wl_global *global;
 struct wl_list swipes;
 struct wl_list pinches;
 struct wl_list holds;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_pointer_gestures_v1 *wlr_pointer_gestures_v1_create(
 struct wl_display *display);
void wlr_pointer_gestures_v1_send_swipe_begin(
 struct wlr_pointer_gestures_v1 *gestures,
 struct wlr_seat *seat,
 uint32_t time_msec,
 uint32_t fingers);
void wlr_pointer_gestures_v1_send_swipe_update(
 struct wlr_pointer_gestures_v1 *gestures,
 struct wlr_seat *seat,
 uint32_t time_msec,
 double dx,
 double dy);
void wlr_pointer_gestures_v1_send_swipe_end(
 struct wlr_pointer_gestures_v1 *gestures,
 struct wlr_seat *seat,
 uint32_t time_msec,
_Bool
     cancelled);
void wlr_pointer_gestures_v1_send_pinch_begin(
 struct wlr_pointer_gestures_v1 *gestures,
 struct wlr_seat *seat,
 uint32_t time_msec,
 uint32_t fingers);
void wlr_pointer_gestures_v1_send_pinch_update(
 struct wlr_pointer_gestures_v1 *gestures,
 struct wlr_seat *seat,
 uint32_t time_msec,
 double dx,
 double dy,
 double scale,
 double rotation);
void wlr_pointer_gestures_v1_send_pinch_end(
 struct wlr_pointer_gestures_v1 *gestures,
 struct wlr_seat *seat,
 uint32_t time_msec,
_Bool
     cancelled);
void wlr_pointer_gestures_v1_send_hold_begin(
 struct wlr_pointer_gestures_v1 *gestures,
 struct wlr_seat *seat,
 uint32_t time_msec,
 uint32_t fingers);
void wlr_pointer_gestures_v1_send_hold_end(
 struct wlr_pointer_gestures_v1 *gestures,
 struct wlr_seat *seat,
 uint32_t time_msec,
_Bool
     cancelled);
struct wlr_surface;
struct wlr_output;
struct wlr_output_event_present;
struct wlr_presentation {
 struct wl_global *global;
 struct {
  struct wl_signal destroy;
 } events;
 struct wl_listener display_destroy;
};
struct wlr_presentation_feedback {
 struct wl_list resources;
 struct wlr_output *output;
_Bool
     output_committed;
 uint32_t output_commit_seq;
_Bool
     zero_copy;
 struct wl_listener output_commit;
 struct wl_listener output_present;
 struct wl_listener output_destroy;
};
struct wlr_presentation_event {
 struct wlr_output *output;
 uint64_t tv_sec;
 uint32_t tv_nsec;
 uint32_t refresh;
 uint64_t seq;
 uint32_t flags;
};
struct wlr_backend;
struct wlr_presentation *wlr_presentation_create(struct wl_display *display,
 struct wlr_backend *backend);
struct wlr_presentation_feedback *wlr_presentation_surface_sampled(
 struct wlr_surface *surface);
void wlr_presentation_feedback_send_presented(
 struct wlr_presentation_feedback *feedback,
 const struct wlr_presentation_event *event);
void wlr_presentation_feedback_destroy(
 struct wlr_presentation_feedback *feedback);
void wlr_presentation_event_from_output(struct wlr_presentation_event *event,
  const struct wlr_output_event_present *output_event);
void wlr_presentation_surface_textured_on_output(struct wlr_surface *surface,
 struct wlr_output *output);
void wlr_presentation_surface_scanned_out_on_output(struct wlr_surface *surface,
 struct wlr_output *output);
struct wlr_primary_selection_source;
struct wlr_primary_selection_source_impl {
 void (*send)(struct wlr_primary_selection_source *source,
  const char *mime_type, int fd);
 void (*destroy)(struct wlr_primary_selection_source *source);
};
struct wlr_primary_selection_source {
 const struct wlr_primary_selection_source_impl *impl;
 struct wl_array mime_types;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
void wlr_primary_selection_source_init(
 struct wlr_primary_selection_source *source,
 const struct wlr_primary_selection_source_impl *impl);
void wlr_primary_selection_source_destroy(
 struct wlr_primary_selection_source *source);
void wlr_primary_selection_source_send(
 struct wlr_primary_selection_source *source, const char *mime_type,
 int fd);
void wlr_seat_request_set_primary_selection(struct wlr_seat *seat,
 struct wlr_seat_client *client,
 struct wlr_primary_selection_source *source, uint32_t serial);
void wlr_seat_set_primary_selection(struct wlr_seat *seat,
 struct wlr_primary_selection_source *source, uint32_t serial);
struct wlr_primary_selection_v1_device_manager {
 struct wl_global *global;
 struct wl_list devices;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_primary_selection_v1_device {
 struct wlr_primary_selection_v1_device_manager *manager;
 struct wlr_seat *seat;
 struct wl_list link;
 struct wl_list resources;
 struct wl_list offers;
 struct wl_listener seat_destroy;
 struct wl_listener seat_focus_change;
 struct wl_listener seat_set_primary_selection;
 void *data;
};
struct wlr_primary_selection_v1_device_manager *
 wlr_primary_selection_v1_device_manager_create(struct wl_display *display);
struct wl_resource;
const pixman_region32_t *wlr_region_from_resource(struct wl_resource *resource);
struct wlr_relative_pointer_manager_v1 {
 struct wl_global *global;
 struct wl_list relative_pointers;
 struct {
  struct wl_signal destroy;
  struct wl_signal new_relative_pointer;
 } events;
 struct wl_listener display_destroy_listener;
 void *data;
};
struct wlr_relative_pointer_v1 {
 struct wl_resource *resource;
 struct wl_resource *pointer_resource;
 struct wlr_seat *seat;
 struct wl_list link;
 struct {
  struct wl_signal destroy;
 } events;
 struct wl_listener seat_destroy;
 struct wl_listener pointer_destroy;
 void *data;
};
struct wlr_relative_pointer_manager_v1 *wlr_relative_pointer_manager_v1_create(
 struct wl_display *display);
void wlr_relative_pointer_manager_v1_send_relative_motion(
 struct wlr_relative_pointer_manager_v1 *manager, struct wlr_seat *seat,
 uint64_t time_usec, double dx, double dy,
 double dx_unaccel, double dy_unaccel);
struct wlr_relative_pointer_v1 *wlr_relative_pointer_v1_from_resource(
 struct wl_resource *resource);
struct wlr_output;
struct wlr_output_layout;
struct wlr_output_layout_output;
struct wlr_xdg_surface;
struct wlr_layer_surface_v1;
struct wlr_drag_icon;
struct wlr_surface;
struct wlr_scene_node;
struct wlr_scene_buffer;
struct wlr_scene_output_layout;
struct wlr_presentation;
struct wlr_linux_dmabuf_v1;
struct wlr_output_state;
typedef
       _Bool
            (*wlr_scene_buffer_point_accepts_input_func_t)(
 struct wlr_scene_buffer *buffer, double *sx, double *sy);
typedef void (*wlr_scene_buffer_iterator_func_t)(
 struct wlr_scene_buffer *buffer, int sx, int sy, void *user_data);
enum wlr_scene_node_type {
 WLR_SCENE_NODE_TREE,
 WLR_SCENE_NODE_RECT,
 WLR_SCENE_NODE_BUFFER,
};
struct wlr_scene_node {
 enum wlr_scene_node_type type;
 struct wlr_scene_tree *parent;
 struct wl_list link;
_Bool
     enabled;
 int x, y;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
 struct wlr_addon_set addons;
 pixman_region32_t visible;
};
enum wlr_scene_debug_damage_option {
 WLR_SCENE_DEBUG_DAMAGE_NONE,
 WLR_SCENE_DEBUG_DAMAGE_RERENDER,
 WLR_SCENE_DEBUG_DAMAGE_HIGHLIGHT
};
struct wlr_scene_tree {
 struct wlr_scene_node node;
 struct wl_list children;
};
struct wlr_scene {
 struct wlr_scene_tree tree;
 struct wl_list outputs;
 struct wlr_linux_dmabuf_v1 *linux_dmabuf_v1;
 struct wl_listener linux_dmabuf_v1_destroy;
 enum wlr_scene_debug_damage_option debug_damage_option;
_Bool
     direct_scanout;
_Bool
     calculate_visibility;
_Bool
     highlight_transparent_region;
};
struct wlr_scene_surface {
 struct wlr_scene_buffer *buffer;
 struct wlr_surface *surface;
 struct wlr_box clip;
 struct wlr_addon addon;
 struct wl_listener outputs_update;
 struct wl_listener output_enter;
 struct wl_listener output_leave;
 struct wl_listener output_sample;
 struct wl_listener frame_done;
 struct wl_listener surface_destroy;
 struct wl_listener surface_commit;
};
struct wlr_scene_rect {
 struct wlr_scene_node node;
 int width, height;
 float color[4];
};
struct wlr_scene_outputs_update_event {
 struct wlr_scene_output **active;
 size_t size;
};
struct wlr_scene_output_sample_event {
 struct wlr_scene_output *output;
_Bool
     direct_scanout;
};
struct wlr_scene_buffer {
 struct wlr_scene_node node;
 struct wlr_buffer *buffer;
 struct {
  struct wl_signal outputs_update;
  struct wl_signal output_enter;
  struct wl_signal output_leave;
  struct wl_signal output_sample;
  struct wl_signal frame_done;
 } events;
 wlr_scene_buffer_point_accepts_input_func_t point_accepts_input;
 struct wlr_scene_output *primary_output;
 float opacity;
 enum wlr_scale_filter_mode filter_mode;
 struct wlr_fbox src_box;
 int dst_width, dst_height;
 enum wl_output_transform transform;
 pixman_region32_t opaque_region;
 uint64_t active_outputs;
 struct wlr_texture *texture;
 struct wlr_linux_dmabuf_feedback_v1_init_options prev_feedback_options;
_Bool
     own_buffer;
 int buffer_width, buffer_height;
_Bool
     buffer_is_opaque;
 struct wl_listener buffer_release;
 struct wl_listener renderer_destroy;
};
struct wlr_scene_output {
 struct wlr_output *output;
 struct wl_list link;
 struct wlr_scene *scene;
 struct wlr_addon addon;
 struct wlr_damage_ring damage_ring;
 int x, y;
 struct {
  struct wl_signal destroy;
 } events;
 pixman_region32_t pending_commit_damage;
 uint8_t index;
_Bool
     prev_scanout;
 struct wl_listener output_commit;
 struct wl_listener output_damage;
 struct wl_listener output_needs_frame;
 struct wl_list damage_highlight_regions;
 struct wl_array render_list;
};
struct wlr_scene_timer {
 int64_t pre_render_duration;
 struct wlr_render_timer *render_timer;
};
struct wlr_scene_layer_surface_v1 {
 struct wlr_scene_tree *tree;
 struct wlr_layer_surface_v1 *layer_surface;
 struct wl_listener tree_destroy;
 struct wl_listener layer_surface_destroy;
 struct wl_listener layer_surface_map;
 struct wl_listener layer_surface_unmap;
};
void wlr_scene_node_destroy(struct wlr_scene_node *node);
void wlr_scene_node_set_enabled(struct wlr_scene_node *node,
                                                            _Bool
                                                                 enabled);
void wlr_scene_node_set_position(struct wlr_scene_node *node, int x, int y);
void wlr_scene_node_place_above(struct wlr_scene_node *node,
 struct wlr_scene_node *sibling);
void wlr_scene_node_place_below(struct wlr_scene_node *node,
 struct wlr_scene_node *sibling);
void wlr_scene_node_raise_to_top(struct wlr_scene_node *node);
void wlr_scene_node_lower_to_bottom(struct wlr_scene_node *node);
void wlr_scene_node_reparent(struct wlr_scene_node *node,
 struct wlr_scene_tree *new_parent);
_Bool
    wlr_scene_node_coords(struct wlr_scene_node *node, int *lx, int *ly);
void wlr_scene_node_for_each_buffer(struct wlr_scene_node *node,
 wlr_scene_buffer_iterator_func_t iterator, void *user_data);
struct wlr_scene_node *wlr_scene_node_at(struct wlr_scene_node *node,
 double lx, double ly, double *nx, double *ny);
struct wlr_scene *wlr_scene_create(void);
void wlr_scene_set_linux_dmabuf_v1(struct wlr_scene *scene,
 struct wlr_linux_dmabuf_v1 *linux_dmabuf_v1);
struct wlr_scene_tree *wlr_scene_tree_create(struct wlr_scene_tree *parent);
struct wlr_scene_surface *wlr_scene_surface_create(struct wlr_scene_tree *parent,
 struct wlr_surface *surface);
struct wlr_scene_buffer *wlr_scene_buffer_from_node(struct wlr_scene_node *node);
struct wlr_scene_tree *wlr_scene_tree_from_node(struct wlr_scene_node *node);
struct wlr_scene_rect *wlr_scene_rect_from_node(struct wlr_scene_node *node);
struct wlr_scene_surface *wlr_scene_surface_try_from_buffer(
 struct wlr_scene_buffer *scene_buffer);
struct wlr_scene_rect *wlr_scene_rect_create(struct wlr_scene_tree *parent,
  int width, int height, const float color[4]);
void wlr_scene_rect_set_size(struct wlr_scene_rect *rect, int width, int height);
void wlr_scene_rect_set_color(struct wlr_scene_rect *rect, const float color[4]);
struct wlr_scene_buffer *wlr_scene_buffer_create(struct wlr_scene_tree *parent,
 struct wlr_buffer *buffer);
void wlr_scene_buffer_set_buffer(struct wlr_scene_buffer *scene_buffer,
 struct wlr_buffer *buffer);
void wlr_scene_buffer_set_buffer_with_damage(struct wlr_scene_buffer *scene_buffer,
 struct wlr_buffer *buffer, const pixman_region32_t *region);
void wlr_scene_buffer_set_opaque_region(struct wlr_scene_buffer *scene_buffer,
 const pixman_region32_t *region);
void wlr_scene_buffer_set_source_box(struct wlr_scene_buffer *scene_buffer,
 const struct wlr_fbox *box);
void wlr_scene_buffer_set_dest_size(struct wlr_scene_buffer *scene_buffer,
 int width, int height);
void wlr_scene_buffer_set_transform(struct wlr_scene_buffer *scene_buffer,
 enum wl_output_transform transform);
void wlr_scene_buffer_set_opacity(struct wlr_scene_buffer *scene_buffer,
 float opacity);
void wlr_scene_buffer_set_filter_mode(struct wlr_scene_buffer *scene_buffer,
 enum wlr_scale_filter_mode filter_mode);
void wlr_scene_buffer_send_frame_done(struct wlr_scene_buffer *scene_buffer,
 struct timespec *now);
struct wlr_scene_output *wlr_scene_output_create(struct wlr_scene *scene,
 struct wlr_output *output);
void wlr_scene_output_destroy(struct wlr_scene_output *scene_output);
void wlr_scene_output_set_position(struct wlr_scene_output *scene_output,
 int lx, int ly);
struct wlr_scene_output_state_options {
 struct wlr_scene_timer *timer;
 struct wlr_color_transform *color_transform;
 struct wlr_swapchain *swapchain;
};
_Bool
    wlr_scene_output_commit(struct wlr_scene_output *scene_output,
 const struct wlr_scene_output_state_options *options);
_Bool
    wlr_scene_output_build_state(struct wlr_scene_output *scene_output,
 struct wlr_output_state *state, const struct wlr_scene_output_state_options *options);
int64_t wlr_scene_timer_get_duration_ns(struct wlr_scene_timer *timer);
void wlr_scene_timer_finish(struct wlr_scene_timer *timer);
void wlr_scene_output_send_frame_done(struct wlr_scene_output *scene_output,
 struct timespec *now);
void wlr_scene_output_for_each_buffer(struct wlr_scene_output *scene_output,
 wlr_scene_buffer_iterator_func_t iterator, void *user_data);
struct wlr_scene_output *wlr_scene_get_scene_output(struct wlr_scene *scene,
 struct wlr_output *output);
struct wlr_scene_output_layout *wlr_scene_attach_output_layout(struct wlr_scene *scene,
 struct wlr_output_layout *output_layout);
void wlr_scene_output_layout_add_output(struct wlr_scene_output_layout *sol,
 struct wlr_output_layout_output *lo, struct wlr_scene_output *so);
struct wlr_scene_tree *wlr_scene_subsurface_tree_create(
 struct wlr_scene_tree *parent, struct wlr_surface *surface);
void wlr_scene_subsurface_tree_set_clip(struct wlr_scene_node *node,
 const struct wlr_box *clip);
struct wlr_scene_tree *wlr_scene_xdg_surface_create(
 struct wlr_scene_tree *parent, struct wlr_xdg_surface *xdg_surface);
struct wlr_scene_layer_surface_v1 *wlr_scene_layer_surface_v1_create(
 struct wlr_scene_tree *parent, struct wlr_layer_surface_v1 *layer_surface);
void wlr_scene_layer_surface_v1_configure(
 struct wlr_scene_layer_surface_v1 *scene_layer_surface,
 const struct wlr_box *full_area, struct wlr_box *usable_area);
struct wlr_scene_tree *wlr_scene_drag_icon_create(
 struct wlr_scene_tree *parent, struct wlr_drag_icon *drag_icon);
struct wlr_screencopy_manager_v1 {
 struct wl_global *global;
 struct wl_list frames;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_screencopy_v1_client {
 int ref;
 struct wlr_screencopy_manager_v1 *manager;
 struct wl_list damages;
};
struct wlr_screencopy_frame_v1 {
 struct wl_resource *resource;
 struct wlr_screencopy_v1_client *client;
 struct wl_list link;
 uint32_t shm_format, dmabuf_format;
 struct wlr_box box;
 int shm_stride;
_Bool
     overlay_cursor, cursor_locked;
_Bool
     with_damage;
 enum wlr_buffer_cap buffer_cap;
 struct wlr_buffer *buffer;
 struct wlr_output *output;
 struct wl_listener output_commit;
 struct wl_listener output_destroy;
 struct wl_listener output_enable;
 void *data;
};
struct wlr_screencopy_manager_v1 *wlr_screencopy_manager_v1_create(
 struct wl_display *display);
struct wlr_security_context_manager_v1 {
 struct wl_global *global;
 struct {
  struct wl_signal destroy;
  struct wl_signal commit;
 } events;
 void *data;
 struct wl_list contexts;
 struct wl_listener display_destroy;
};
struct wlr_security_context_v1_state {
 char *sandbox_engine;
 char *app_id;
 char *instance_id;
};
struct wlr_security_context_v1_commit_event {
 const struct wlr_security_context_v1_state *state;
 struct wl_client *parent_client;
};
struct wlr_security_context_manager_v1 *wlr_security_context_manager_v1_create(
 struct wl_display *display);
const struct wlr_security_context_v1_state *wlr_security_context_manager_v1_lookup_client(
 struct wlr_security_context_manager_v1 *manager, const struct wl_client *client);
enum wlr_server_decoration_manager_mode {
 WLR_SERVER_DECORATION_MANAGER_MODE_NONE = 0,
 WLR_SERVER_DECORATION_MANAGER_MODE_CLIENT = 1,
 WLR_SERVER_DECORATION_MANAGER_MODE_SERVER = 2,
};
struct wlr_server_decoration_manager {
 struct wl_global *global;
 struct wl_list resources;
 struct wl_list decorations;
 uint32_t default_mode;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal new_decoration;
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_server_decoration {
 struct wl_resource *resource;
 struct wlr_surface *surface;
 struct wl_list link;
 uint32_t mode;
 struct {
  struct wl_signal destroy;
  struct wl_signal mode;
 } events;
 struct wl_listener surface_destroy_listener;
 void *data;
};
struct wlr_server_decoration_manager *wlr_server_decoration_manager_create(
 struct wl_display *display);
void wlr_server_decoration_manager_set_default_mode(
 struct wlr_server_decoration_manager *manager, uint32_t default_mode);
struct wlr_session_lock_manager_v1 {
 struct wl_global *global;
 struct {
  struct wl_signal new_lock;
  struct wl_signal destroy;
 } events;
 void *data;
 struct wl_listener display_destroy;
};
struct wlr_session_lock_v1 {
 struct wl_resource *resource;
 struct wl_list surfaces;
 struct {
  struct wl_signal new_surface;
  struct wl_signal unlock;
  struct wl_signal destroy;
 } events;
 void *data;
_Bool
     locked_sent;
};
struct wlr_session_lock_surface_v1_state {
 uint32_t width, height;
 uint32_t configure_serial;
};
struct wlr_session_lock_surface_v1_configure {
 struct wl_list link;
 uint32_t serial;
 uint32_t width, height;
};
struct wlr_session_lock_surface_v1 {
 struct wl_resource *resource;
 struct wl_list link;
 struct wlr_output *output;
 struct wlr_surface *surface;
_Bool
     configured;
 struct wl_list configure_list;
 struct wlr_session_lock_surface_v1_state current;
 struct wlr_session_lock_surface_v1_state pending;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
 struct wlr_surface_synced synced;
 struct wl_listener output_destroy;
};
struct wlr_session_lock_manager_v1 *wlr_session_lock_manager_v1_create(
 struct wl_display *display);
void wlr_session_lock_v1_send_locked(struct wlr_session_lock_v1 *lock);
void wlr_session_lock_v1_destroy(struct wlr_session_lock_v1 *lock);
uint32_t wlr_session_lock_surface_v1_configure(
 struct wlr_session_lock_surface_v1 *lock_surface,
 uint32_t width, uint32_t height);
struct wlr_session_lock_surface_v1 *wlr_session_lock_surface_v1_try_from_wlr_surface(
 struct wlr_surface *surface);
struct wlr_renderer;
struct wlr_shm {
 struct wl_global *global;
 uint32_t *formats;
 size_t formats_len;
 struct wl_listener display_destroy;
};
struct wlr_shm *wlr_shm_create(struct wl_display *display, uint32_t version,
 const uint32_t *formats, size_t formats_len);
struct wlr_shm *wlr_shm_create_with_renderer(struct wl_display *display,
 uint32_t version, struct wlr_renderer *renderer);
struct wlr_single_pixel_buffer_manager_v1 {
 struct wl_global *global;
 struct wl_listener display_destroy;
};
struct wlr_single_pixel_buffer_manager_v1 *wlr_single_pixel_buffer_manager_v1_create(
 struct wl_display *display);
struct wlr_subsurface_parent_state {
 int32_t x, y;
 struct wl_list link;
 struct wlr_surface_synced *synced;
};
struct wlr_subsurface {
 struct wl_resource *resource;
 struct wlr_surface *surface;
 struct wlr_surface *parent;
 struct wlr_subsurface_parent_state current, pending;
 uint32_t cached_seq;
_Bool
     has_cache;
_Bool
     synchronized;
_Bool
     added;
 struct wl_listener surface_client_commit;
 struct wl_listener parent_destroy;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
 struct wlr_surface_synced parent_synced;
 struct {
  int32_t x, y;
 } previous;
};
struct wlr_subcompositor {
 struct wl_global *global;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
};
struct wlr_subsurface *wlr_subsurface_try_from_wlr_surface(
 struct wlr_surface *surface);
struct wlr_subcompositor *wlr_subcompositor_create(struct wl_display *display);
struct wlr_input_device;
struct wlr_tablet_pad_v2_grab_interface;
struct wlr_tablet_pad_v2_grab {
 const struct wlr_tablet_pad_v2_grab_interface *interface;
 struct wlr_tablet_v2_tablet_pad *pad;
 void *data;
};
struct wlr_tablet_tool_v2_grab_interface;
struct wlr_tablet_tool_v2_grab {
 const struct wlr_tablet_tool_v2_grab_interface *interface;
 struct wlr_tablet_v2_tablet_tool *tool;
 void *data;
};
struct wlr_tablet_client_v2;
struct wlr_tablet_tool_client_v2;
struct wlr_tablet_pad_client_v2;
struct wlr_tablet_manager_v2 {
 struct wl_global *wl_global;
 struct wl_list clients;
 struct wl_list seats;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_tablet_v2_tablet {
 struct wl_list link;
 struct wlr_tablet *wlr_tablet;
 struct wlr_input_device *wlr_device;
 struct wl_list clients;
 struct wl_listener tablet_destroy;
 struct wlr_tablet_client_v2 *current_client;
};
struct wlr_tablet_v2_tablet_tool {
 struct wl_list link;
 struct wlr_tablet_tool *wlr_tool;
 struct wl_list clients;
 struct wl_listener tool_destroy;
 struct wlr_tablet_tool_client_v2 *current_client;
 struct wlr_surface *focused_surface;
 struct wl_listener surface_destroy;
 struct wlr_tablet_tool_v2_grab *grab;
 struct wlr_tablet_tool_v2_grab default_grab;
 uint32_t proximity_serial;
_Bool
     is_down;
 uint32_t down_serial;
 size_t num_buttons;
 uint32_t pressed_buttons[16];
 uint32_t pressed_serials[16];
 struct {
  struct wl_signal set_cursor;
 } events;
};
struct wlr_tablet_v2_tablet_pad {
 struct wl_list link;
 struct wlr_tablet_pad *wlr_pad;
 struct wlr_input_device *wlr_device;
 struct wl_list clients;
 size_t group_count;
 uint32_t *groups;
 struct wl_listener pad_destroy;
 struct wlr_tablet_pad_client_v2 *current_client;
 struct wlr_tablet_pad_v2_grab *grab;
 struct wlr_tablet_pad_v2_grab default_grab;
 struct {
  struct wl_signal button_feedback;
  struct wl_signal strip_feedback;
  struct wl_signal ring_feedback;
 } events;
};
struct wlr_tablet_v2_event_cursor {
 struct wlr_surface *surface;
 uint32_t serial;
 int32_t hotspot_x;
 int32_t hotspot_y;
 struct wlr_seat_client *seat_client;
};
struct wlr_tablet_v2_event_feedback {
 const char *description;
 size_t index;
 uint32_t serial;
};
struct wlr_tablet_v2_tablet *wlr_tablet_create(
 struct wlr_tablet_manager_v2 *manager,
 struct wlr_seat *wlr_seat,
 struct wlr_input_device *wlr_device);
struct wlr_tablet_v2_tablet_pad *wlr_tablet_pad_create(
 struct wlr_tablet_manager_v2 *manager,
 struct wlr_seat *wlr_seat,
 struct wlr_input_device *wlr_device);
struct wlr_tablet_v2_tablet_tool *wlr_tablet_tool_create(
 struct wlr_tablet_manager_v2 *manager,
 struct wlr_seat *wlr_seat,
 struct wlr_tablet_tool *wlr_tool);
struct wlr_tablet_manager_v2 *wlr_tablet_v2_create(struct wl_display *display);
void wlr_send_tablet_v2_tablet_tool_proximity_in(
 struct wlr_tablet_v2_tablet_tool *tool,
 struct wlr_tablet_v2_tablet *tablet,
 struct wlr_surface *surface);
void wlr_send_tablet_v2_tablet_tool_down(struct wlr_tablet_v2_tablet_tool *tool);
void wlr_send_tablet_v2_tablet_tool_up(struct wlr_tablet_v2_tablet_tool *tool);
void wlr_send_tablet_v2_tablet_tool_motion(
 struct wlr_tablet_v2_tablet_tool *tool, double x, double y);
void wlr_send_tablet_v2_tablet_tool_pressure(
 struct wlr_tablet_v2_tablet_tool *tool, double pressure);
void wlr_send_tablet_v2_tablet_tool_distance(
 struct wlr_tablet_v2_tablet_tool *tool, double distance);
void wlr_send_tablet_v2_tablet_tool_tilt(
 struct wlr_tablet_v2_tablet_tool *tool, double x, double y);
void wlr_send_tablet_v2_tablet_tool_rotation(
 struct wlr_tablet_v2_tablet_tool *tool, double degrees);
void wlr_send_tablet_v2_tablet_tool_slider(
 struct wlr_tablet_v2_tablet_tool *tool, double position);
void wlr_send_tablet_v2_tablet_tool_wheel(
 struct wlr_tablet_v2_tablet_tool *tool, double degrees, int32_t clicks);
void wlr_send_tablet_v2_tablet_tool_proximity_out(
 struct wlr_tablet_v2_tablet_tool *tool);
void wlr_send_tablet_v2_tablet_tool_button(
 struct wlr_tablet_v2_tablet_tool *tool, uint32_t button,
 enum zwp_tablet_pad_v2_button_state state);
void wlr_tablet_v2_tablet_tool_notify_proximity_in(
 struct wlr_tablet_v2_tablet_tool *tool,
 struct wlr_tablet_v2_tablet *tablet,
 struct wlr_surface *surface);
void wlr_tablet_v2_tablet_tool_notify_down(struct wlr_tablet_v2_tablet_tool *tool);
void wlr_tablet_v2_tablet_tool_notify_up(struct wlr_tablet_v2_tablet_tool *tool);
void wlr_tablet_v2_tablet_tool_notify_motion(
 struct wlr_tablet_v2_tablet_tool *tool, double x, double y);
void wlr_tablet_v2_tablet_tool_notify_pressure(
 struct wlr_tablet_v2_tablet_tool *tool, double pressure);
void wlr_tablet_v2_tablet_tool_notify_distance(
 struct wlr_tablet_v2_tablet_tool *tool, double distance);
void wlr_tablet_v2_tablet_tool_notify_tilt(
 struct wlr_tablet_v2_tablet_tool *tool, double x, double y);
void wlr_tablet_v2_tablet_tool_notify_rotation(
 struct wlr_tablet_v2_tablet_tool *tool, double degrees);
void wlr_tablet_v2_tablet_tool_notify_slider(
 struct wlr_tablet_v2_tablet_tool *tool, double position);
void wlr_tablet_v2_tablet_tool_notify_wheel(
 struct wlr_tablet_v2_tablet_tool *tool, double degrees, int32_t clicks);
void wlr_tablet_v2_tablet_tool_notify_proximity_out(
 struct wlr_tablet_v2_tablet_tool *tool);
void wlr_tablet_v2_tablet_tool_notify_button(
 struct wlr_tablet_v2_tablet_tool *tool, uint32_t button,
 enum zwp_tablet_pad_v2_button_state state);
struct wlr_tablet_tool_v2_grab_interface {
 void (*proximity_in)(
  struct wlr_tablet_tool_v2_grab *grab,
  struct wlr_tablet_v2_tablet *tablet,
  struct wlr_surface *surface);
 void (*down)(struct wlr_tablet_tool_v2_grab *grab);
 void (*up)(struct wlr_tablet_tool_v2_grab *grab);
 void (*motion)(struct wlr_tablet_tool_v2_grab *grab, double x, double y);
 void (*pressure)(struct wlr_tablet_tool_v2_grab *grab, double pressure);
 void (*distance)(struct wlr_tablet_tool_v2_grab *grab, double distance);
 void (*tilt)(struct wlr_tablet_tool_v2_grab *grab, double x, double y);
 void (*rotation)(struct wlr_tablet_tool_v2_grab *grab, double degrees);
 void (*slider)(struct wlr_tablet_tool_v2_grab *grab, double position);
 void (*wheel)(struct wlr_tablet_tool_v2_grab *grab, double degrees, int32_t clicks);
 void (*proximity_out)(struct wlr_tablet_tool_v2_grab *grab);
 void (*button)(
  struct wlr_tablet_tool_v2_grab *grab, uint32_t button,
  enum zwp_tablet_pad_v2_button_state state);
 void (*cancel)(struct wlr_tablet_tool_v2_grab *grab);
};
void wlr_tablet_tool_v2_start_grab(struct wlr_tablet_v2_tablet_tool *tool, struct wlr_tablet_tool_v2_grab *grab);
void wlr_tablet_tool_v2_end_grab(struct wlr_tablet_v2_tablet_tool *tool);
void wlr_tablet_tool_v2_start_implicit_grab(struct wlr_tablet_v2_tablet_tool *tool);
_Bool
    wlr_tablet_tool_v2_has_implicit_grab(
 struct wlr_tablet_v2_tablet_tool *tool);
uint32_t wlr_send_tablet_v2_tablet_pad_enter(
 struct wlr_tablet_v2_tablet_pad *pad,
 struct wlr_tablet_v2_tablet *tablet,
 struct wlr_surface *surface);
void wlr_send_tablet_v2_tablet_pad_button(
 struct wlr_tablet_v2_tablet_pad *pad, size_t button,
 uint32_t time, enum zwp_tablet_pad_v2_button_state state);
void wlr_send_tablet_v2_tablet_pad_strip(struct wlr_tablet_v2_tablet_pad *pad,
 uint32_t strip, double position,
                                 _Bool
                                      finger, uint32_t time);
void wlr_send_tablet_v2_tablet_pad_ring(struct wlr_tablet_v2_tablet_pad *pad,
 uint32_t ring, double position,
                                _Bool
                                     finger, uint32_t time);
uint32_t wlr_send_tablet_v2_tablet_pad_leave(struct wlr_tablet_v2_tablet_pad *pad,
 struct wlr_surface *surface);
uint32_t wlr_send_tablet_v2_tablet_pad_mode(struct wlr_tablet_v2_tablet_pad *pad,
 size_t group, uint32_t mode, uint32_t time);
uint32_t wlr_tablet_v2_tablet_pad_notify_enter(
 struct wlr_tablet_v2_tablet_pad *pad,
 struct wlr_tablet_v2_tablet *tablet,
 struct wlr_surface *surface);
void wlr_tablet_v2_tablet_pad_notify_button(
 struct wlr_tablet_v2_tablet_pad *pad, size_t button,
 uint32_t time, enum zwp_tablet_pad_v2_button_state state);
void wlr_tablet_v2_tablet_pad_notify_strip(
 struct wlr_tablet_v2_tablet_pad *pad,
 uint32_t strip, double position,
                                 _Bool
                                      finger, uint32_t time);
void wlr_tablet_v2_tablet_pad_notify_ring(
 struct wlr_tablet_v2_tablet_pad *pad,
 uint32_t ring, double position,
                                _Bool
                                     finger, uint32_t time);
uint32_t wlr_tablet_v2_tablet_pad_notify_leave(
 struct wlr_tablet_v2_tablet_pad *pad, struct wlr_surface *surface);
uint32_t wlr_tablet_v2_tablet_pad_notify_mode(
 struct wlr_tablet_v2_tablet_pad *pad,
 size_t group, uint32_t mode, uint32_t time);
struct wlr_tablet_pad_v2_grab_interface {
 uint32_t (*enter)(
  struct wlr_tablet_pad_v2_grab *grab,
  struct wlr_tablet_v2_tablet *tablet,
  struct wlr_surface *surface);
 void (*button)(struct wlr_tablet_pad_v2_grab *grab,size_t button,
  uint32_t time, enum zwp_tablet_pad_v2_button_state state);
 void (*strip)(struct wlr_tablet_pad_v2_grab *grab,
  uint32_t strip, double position,
                                  _Bool
                                       finger, uint32_t time);
 void (*ring)(struct wlr_tablet_pad_v2_grab *grab,
  uint32_t ring, double position,
                                 _Bool
                                      finger, uint32_t time);
 uint32_t (*leave)(struct wlr_tablet_pad_v2_grab *grab,
  struct wlr_surface *surface);
 uint32_t (*mode)(struct wlr_tablet_pad_v2_grab *grab,
  size_t group, uint32_t mode, uint32_t time);
 void (*cancel)(struct wlr_tablet_pad_v2_grab *grab);
};
void wlr_tablet_v2_end_grab(struct wlr_tablet_v2_tablet_pad *pad);
void wlr_tablet_v2_start_grab(struct wlr_tablet_v2_tablet_pad *pad, struct wlr_tablet_pad_v2_grab *grab);
_Bool
    wlr_surface_accepts_tablet_v2(struct wlr_tablet_v2_tablet *tablet,
 struct wlr_surface *surface);
struct wlr_tearing_control_v1 {
 struct wl_client *client;
 struct wl_list link;
 struct wl_resource *resource;
 enum wp_tearing_control_v1_presentation_hint current, pending;
 struct {
  struct wl_signal set_hint;
  struct wl_signal destroy;
 } events;
 struct wlr_surface *surface;
 enum wp_tearing_control_v1_presentation_hint previous;
 struct wlr_addon addon;
 struct wlr_surface_synced synced;
 struct wl_listener surface_commit;
};
struct wlr_tearing_control_manager_v1 {
 struct wl_global *global;
 struct wl_list surface_hints;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal new_object;
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_tearing_control_manager_v1 *wlr_tearing_control_manager_v1_create(
 struct wl_display *display, uint32_t version);
enum wp_tearing_control_v1_presentation_hint
wlr_tearing_control_manager_v1_surface_hint_from_surface(
 struct wlr_tearing_control_manager_v1 *manager,
 struct wlr_surface *surface);
struct wlr_surface;
enum wlr_text_input_v3_features {
 WLR_TEXT_INPUT_V3_FEATURE_SURROUNDING_TEXT = 1 << 0,
 WLR_TEXT_INPUT_V3_FEATURE_CONTENT_TYPE = 1 << 1,
 WLR_TEXT_INPUT_V3_FEATURE_CURSOR_RECTANGLE = 1 << 2,
};
struct wlr_text_input_v3_state {
 struct {
  char *text;
  uint32_t cursor;
  uint32_t anchor;
 } surrounding;
 uint32_t text_change_cause;
 struct {
  uint32_t hint;
  uint32_t purpose;
 } content_type;
 struct wlr_box cursor_rectangle;
 uint32_t features;
};
struct wlr_text_input_v3 {
 struct wlr_seat *seat;
 struct wl_resource *resource;
 struct wlr_surface *focused_surface;
 struct wlr_text_input_v3_state pending;
 struct wlr_text_input_v3_state current;
 uint32_t current_serial;
_Bool
     pending_enabled;
_Bool
     current_enabled;
 uint32_t active_features;
 struct wl_list link;
 struct wl_listener surface_destroy;
 struct wl_listener seat_destroy;
 struct {
  struct wl_signal enable;
  struct wl_signal commit;
  struct wl_signal disable;
  struct wl_signal destroy;
 } events;
};
struct wlr_text_input_manager_v3 {
 struct wl_global *global;
 struct wl_list text_inputs;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal text_input;
  struct wl_signal destroy;
 } events;
};
struct wlr_text_input_manager_v3 *wlr_text_input_manager_v3_create(
 struct wl_display *wl_display);
void wlr_text_input_v3_send_enter(struct wlr_text_input_v3 *text_input,
 struct wlr_surface *wlr_surface);
void wlr_text_input_v3_send_leave(struct wlr_text_input_v3 *text_input);
void wlr_text_input_v3_send_preedit_string(struct wlr_text_input_v3 *text_input,
 const char *text, int32_t cursor_begin, int32_t cursor_end);
void wlr_text_input_v3_send_commit_string(struct wlr_text_input_v3 *text_input,
 const char *text);
void wlr_text_input_v3_send_delete_surrounding_text(
 struct wlr_text_input_v3 *text_input, uint32_t before_length,
 uint32_t after_length);
void wlr_text_input_v3_send_done(struct wlr_text_input_v3 *text_input);
struct wlr_seat;
struct wlr_transient_seat_v1 {
 struct wl_resource *resource;
 struct wlr_seat *seat;
 struct wl_listener seat_destroy;
};
struct wlr_transient_seat_manager_v1 {
 struct wl_global *global;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal create_seat;
 } events;
};
struct wlr_transient_seat_manager_v1 *wlr_transient_seat_manager_v1_create(
  struct wl_display *display);
void wlr_transient_seat_v1_ready(struct wlr_transient_seat_v1 *seat,
  struct wlr_seat *wlr_seat);
void wlr_transient_seat_v1_deny(struct wlr_transient_seat_v1 *seat);
struct wlr_viewporter {
 struct wl_global *global;
 struct {
  struct wl_signal destroy;
 } events;
 struct wl_listener display_destroy;
};
struct wlr_viewporter *wlr_viewporter_create(struct wl_display *display);
struct wlr_virtual_keyboard_manager_v1 {
 struct wl_global *global;
 struct wl_list virtual_keyboards;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal new_virtual_keyboard;
  struct wl_signal destroy;
 } events;
};
struct wlr_virtual_keyboard_v1 {
 struct wlr_keyboard keyboard;
 struct wl_resource *resource;
 struct wlr_seat *seat;
_Bool
     has_keymap;
 struct wl_list link;
};
struct wlr_virtual_keyboard_manager_v1* wlr_virtual_keyboard_manager_v1_create(
 struct wl_display *display);
struct wlr_virtual_keyboard_v1 *wlr_input_device_get_virtual_keyboard(
 struct wlr_input_device *wlr_dev);
struct wlr_virtual_pointer_manager_v1 {
 struct wl_global *global;
 struct wl_list virtual_pointers;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal new_virtual_pointer;
  struct wl_signal destroy;
 } events;
};
struct wlr_virtual_pointer_v1 {
 struct wlr_pointer pointer;
 struct wl_resource *resource;
 struct wlr_pointer_axis_event axis_event[2];
 enum wl_pointer_axis axis;
_Bool
     axis_valid[2];
 struct wl_list link;
};
struct wlr_virtual_pointer_v1_new_pointer_event {
 struct wlr_virtual_pointer_v1 *new_pointer;
 struct wlr_seat *suggested_seat;
 struct wlr_output *suggested_output;
};
struct wlr_virtual_pointer_manager_v1* wlr_virtual_pointer_manager_v1_create(
 struct wl_display *display);
enum wlr_edges {
 WLR_EDGE_NONE = 0,
 WLR_EDGE_TOP = 1 << 0,
 WLR_EDGE_BOTTOM = 1 << 1,
 WLR_EDGE_LEFT = 1 << 2,
 WLR_EDGE_RIGHT = 1 << 3,
};
struct wlr_xcursor_image {
 uint32_t width;
 uint32_t height;
 uint32_t hotspot_x;
 uint32_t hotspot_y;
 uint32_t delay;
 uint8_t *buffer;
};
struct wlr_xcursor {
 unsigned int image_count;
 struct wlr_xcursor_image **images;
 char *name;
 uint32_t total_delay;
};
struct wlr_xcursor_theme {
 unsigned int cursor_count;
 struct wlr_xcursor **cursors;
 char *name;
 int size;
};
struct wlr_xcursor_theme *wlr_xcursor_theme_load(const char *name, int size);
void wlr_xcursor_theme_destroy(struct wlr_xcursor_theme *theme);
struct wlr_xcursor *wlr_xcursor_theme_get_cursor(
 struct wlr_xcursor_theme *theme, const char *name);
int wlr_xcursor_frame(struct wlr_xcursor *cursor, uint32_t time);
const char *wlr_xcursor_get_resize_name(enum wlr_edges edges);
struct wlr_xcursor_manager_theme {
 float scale;
 struct wlr_xcursor_theme *theme;
 struct wl_list link;
};
struct wlr_xcursor_manager {
 char *name;
 uint32_t size;
 struct wl_list scaled_themes;
};
struct wlr_xcursor_manager *wlr_xcursor_manager_create(const char *name,
 uint32_t size);
void wlr_xcursor_manager_destroy(struct wlr_xcursor_manager *manager);
_Bool
    wlr_xcursor_manager_load(struct wlr_xcursor_manager *manager,
 float scale);
struct wlr_xcursor *wlr_xcursor_manager_get_xcursor(
 struct wlr_xcursor_manager *manager, const char *name, float scale);
struct wlr_xdg_activation_token_v1 {
 struct wlr_xdg_activation_v1 *activation;
 struct wlr_surface *surface;
 struct wlr_seat *seat;
 uint32_t serial;
 char *app_id;
 struct wl_list link;
 void *data;
 struct {
  struct wl_signal destroy;
 } events;
 char *token;
 struct wl_resource *resource;
 struct wl_event_source *timeout;
 struct wl_listener seat_destroy;
 struct wl_listener surface_destroy;
};
struct wlr_xdg_activation_v1 {
 uint32_t token_timeout_msec;
 struct wl_list tokens;
 struct {
  struct wl_signal destroy;
  struct wl_signal request_activate;
  struct wl_signal new_token;
 } events;
 struct wl_display *display;
 struct wl_global *global;
 struct wl_listener display_destroy;
};
struct wlr_xdg_activation_v1_request_activate_event {
 struct wlr_xdg_activation_v1 *activation;
 struct wlr_xdg_activation_token_v1 *token;
 struct wlr_surface *surface;
};
struct wlr_xdg_activation_v1 *wlr_xdg_activation_v1_create(
 struct wl_display *display);
struct wlr_xdg_activation_token_v1 *wlr_xdg_activation_token_v1_create(
  struct wlr_xdg_activation_v1 *activation);
void wlr_xdg_activation_token_v1_destroy(
  struct wlr_xdg_activation_token_v1 *token);
struct wlr_xdg_activation_token_v1 *wlr_xdg_activation_v1_find_token(
  struct wlr_xdg_activation_v1 *activation, const char *token_str);
const char *wlr_xdg_activation_token_v1_get_name(
  struct wlr_xdg_activation_token_v1 *token);
struct wlr_xdg_activation_token_v1 *wlr_xdg_activation_v1_add_token(
  struct wlr_xdg_activation_v1 *activation, const char *token_str);
struct wlr_xdg_shell {
 struct wl_global *global;
 uint32_t version;
 struct wl_list clients;
 struct wl_list popup_grabs;
 uint32_t ping_timeout;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal new_surface;
  struct wl_signal new_toplevel;
  struct wl_signal new_popup;
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_xdg_client {
 struct wlr_xdg_shell *shell;
 struct wl_resource *resource;
 struct wl_client *client;
 struct wl_list surfaces;
 struct wl_list link;
 uint32_t ping_serial;
 struct wl_event_source *ping_timer;
};
struct wlr_xdg_positioner_rules {
 struct wlr_box anchor_rect;
 enum xdg_positioner_anchor anchor;
 enum xdg_positioner_gravity gravity;
 enum xdg_positioner_constraint_adjustment constraint_adjustment;
_Bool
     reactive;
_Bool
     has_parent_configure_serial;
 uint32_t parent_configure_serial;
 struct {
  int32_t width, height;
 } size, parent_size;
 struct {
  int32_t x, y;
 } offset;
};
struct wlr_xdg_positioner {
 struct wl_resource *resource;
 struct wlr_xdg_positioner_rules rules;
};
struct wlr_xdg_popup_state {
 struct wlr_box geometry;
_Bool
     reactive;
};
enum wlr_xdg_popup_configure_field {
 WLR_XDG_POPUP_CONFIGURE_REPOSITION_TOKEN = 1 << 0,
};
struct wlr_xdg_popup_configure {
 uint32_t fields;
 struct wlr_box geometry;
 struct wlr_xdg_positioner_rules rules;
 uint32_t reposition_token;
};
struct wlr_xdg_popup {
 struct wlr_xdg_surface *base;
 struct wl_list link;
 struct wl_resource *resource;
 struct wlr_surface *parent;
 struct wlr_seat *seat;
 struct wlr_xdg_popup_configure scheduled;
 struct wlr_xdg_popup_state current, pending;
 struct {
  struct wl_signal destroy;
  struct wl_signal reposition;
 } events;
 struct wl_list grab_link;
 struct wlr_surface_synced synced;
};
struct wlr_xdg_popup_grab {
 struct wl_client *client;
 struct wlr_seat_pointer_grab pointer_grab;
 struct wlr_seat_keyboard_grab keyboard_grab;
 struct wlr_seat_touch_grab touch_grab;
 struct wlr_seat *seat;
 struct wl_list popups;
 struct wl_list link;
 struct wl_listener seat_destroy;
};
enum wlr_xdg_surface_role {
 WLR_XDG_SURFACE_ROLE_NONE,
 WLR_XDG_SURFACE_ROLE_TOPLEVEL,
 WLR_XDG_SURFACE_ROLE_POPUP,
};
struct wlr_xdg_toplevel_state {
_Bool
     maximized, fullscreen, resizing, activated, suspended;
 uint32_t tiled;
 int32_t width, height;
 int32_t max_width, max_height;
 int32_t min_width, min_height;
};
enum wlr_xdg_toplevel_wm_capabilities {
 WLR_XDG_TOPLEVEL_WM_CAPABILITIES_WINDOW_MENU = 1 << 0,
 WLR_XDG_TOPLEVEL_WM_CAPABILITIES_MAXIMIZE = 1 << 1,
 WLR_XDG_TOPLEVEL_WM_CAPABILITIES_FULLSCREEN = 1 << 2,
 WLR_XDG_TOPLEVEL_WM_CAPABILITIES_MINIMIZE = 1 << 3,
};
enum wlr_xdg_toplevel_configure_field {
 WLR_XDG_TOPLEVEL_CONFIGURE_BOUNDS = 1 << 0,
 WLR_XDG_TOPLEVEL_CONFIGURE_WM_CAPABILITIES = 1 << 1,
};
struct wlr_xdg_toplevel_configure {
 uint32_t fields;
_Bool
     maximized, fullscreen, resizing, activated, suspended;
 uint32_t tiled;
 int32_t width, height;
 struct {
  int32_t width, height;
 } bounds;
 uint32_t wm_capabilities;
};
struct wlr_xdg_toplevel_requested {
_Bool
     maximized, minimized, fullscreen;
 struct wlr_output *fullscreen_output;
 struct wl_listener fullscreen_output_destroy;
};
struct wlr_xdg_toplevel {
 struct wl_resource *resource;
 struct wlr_xdg_surface *base;
 struct wlr_xdg_toplevel *parent;
 struct wl_listener parent_unmap;
 struct wlr_xdg_toplevel_state current, pending;
 struct wlr_xdg_toplevel_configure scheduled;
 struct wlr_xdg_toplevel_requested requested;
 char *title;
 char *app_id;
 struct {
  struct wl_signal destroy;
  struct wl_signal request_maximize;
  struct wl_signal request_fullscreen;
  struct wl_signal request_minimize;
  struct wl_signal request_move;
  struct wl_signal request_resize;
  struct wl_signal request_show_window_menu;
  struct wl_signal set_parent;
  struct wl_signal set_title;
  struct wl_signal set_app_id;
 } events;
 struct wlr_surface_synced synced;
};
struct wlr_xdg_surface_configure {
 struct wlr_xdg_surface *surface;
 struct wl_list link;
 uint32_t serial;
 union {
  struct wlr_xdg_toplevel_configure *toplevel_configure;
  struct wlr_xdg_popup_configure *popup_configure;
 };
};
struct wlr_xdg_surface_state {
 uint32_t configure_serial;
 struct wlr_box geometry;
};
struct wlr_xdg_surface {
 struct wlr_xdg_client *client;
 struct wl_resource *resource;
 struct wlr_surface *surface;
 struct wl_list link;
 enum wlr_xdg_surface_role role;
 struct wl_resource *role_resource;
 union {
  struct wlr_xdg_toplevel *toplevel;
  struct wlr_xdg_popup *popup;
 };
 struct wl_list popups;
_Bool
     configured;
 struct wl_event_source *configure_idle;
 uint32_t scheduled_serial;
 struct wl_list configure_list;
 struct wlr_xdg_surface_state current, pending;
_Bool
     initialized;
_Bool
     initial_commit;
 struct {
  struct wl_signal destroy;
  struct wl_signal ping_timeout;
  struct wl_signal new_popup;
  struct wl_signal configure;
  struct wl_signal ack_configure;
 } events;
 void *data;
 struct wlr_surface_synced synced;
 struct wl_listener role_resource_destroy;
};
struct wlr_xdg_toplevel_move_event {
 struct wlr_xdg_toplevel *toplevel;
 struct wlr_seat_client *seat;
 uint32_t serial;
};
struct wlr_xdg_toplevel_resize_event {
 struct wlr_xdg_toplevel *toplevel;
 struct wlr_seat_client *seat;
 uint32_t serial;
 uint32_t edges;
};
struct wlr_xdg_toplevel_show_window_menu_event {
 struct wlr_xdg_toplevel *toplevel;
 struct wlr_seat_client *seat;
 uint32_t serial;
 int32_t x, y;
};
struct wlr_xdg_shell *wlr_xdg_shell_create(struct wl_display *display,
 uint32_t version);
struct wlr_xdg_surface *wlr_xdg_surface_from_resource(
  struct wl_resource *resource);
struct wlr_xdg_popup *wlr_xdg_popup_from_resource(
  struct wl_resource *resource);
struct wlr_xdg_toplevel *wlr_xdg_toplevel_from_resource(
  struct wl_resource *resource);
struct wlr_xdg_positioner *wlr_xdg_positioner_from_resource(
  struct wl_resource *resource);
void wlr_xdg_surface_ping(struct wlr_xdg_surface *surface);
uint32_t wlr_xdg_toplevel_set_size(struct wlr_xdg_toplevel *toplevel,
  int32_t width, int32_t height);
uint32_t wlr_xdg_toplevel_set_activated(struct wlr_xdg_toplevel *toplevel,
 _Bool
      activated);
uint32_t wlr_xdg_toplevel_set_maximized(struct wlr_xdg_toplevel *toplevel,
 _Bool
      maximized);
uint32_t wlr_xdg_toplevel_set_fullscreen(struct wlr_xdg_toplevel *toplevel,
 _Bool
      fullscreen);
uint32_t wlr_xdg_toplevel_set_resizing(struct wlr_xdg_toplevel *toplevel,
 _Bool
      resizing);
uint32_t wlr_xdg_toplevel_set_tiled(struct wlr_xdg_toplevel *toplevel,
  uint32_t tiled_edges);
uint32_t wlr_xdg_toplevel_set_bounds(struct wlr_xdg_toplevel *toplevel,
  int32_t width, int32_t height);
uint32_t wlr_xdg_toplevel_set_wm_capabilities(struct wlr_xdg_toplevel *toplevel,
  uint32_t caps);
uint32_t wlr_xdg_toplevel_set_suspended(struct wlr_xdg_toplevel *toplevel,
 _Bool
      suspended);
void wlr_xdg_toplevel_send_close(struct wlr_xdg_toplevel *toplevel);
_Bool
    wlr_xdg_toplevel_set_parent(struct wlr_xdg_toplevel *toplevel,
 struct wlr_xdg_toplevel *parent);
void wlr_xdg_popup_destroy(struct wlr_xdg_popup *popup);
void wlr_xdg_popup_get_position(struct wlr_xdg_popup *popup,
  double *popup_sx, double *popup_sy);
_Bool
    wlr_xdg_positioner_is_complete(struct wlr_xdg_positioner *positioner);
void wlr_xdg_positioner_rules_get_geometry(
  const struct wlr_xdg_positioner_rules *rules, struct wlr_box *box);
void wlr_xdg_positioner_rules_unconstrain_box(
  const struct wlr_xdg_positioner_rules *rules,
  const struct wlr_box *constraint, struct wlr_box *box);
void wlr_xdg_popup_get_toplevel_coords(struct wlr_xdg_popup *popup,
  int popup_sx, int popup_sy, int *toplevel_sx, int *toplevel_sy);
void wlr_xdg_popup_unconstrain_from_box(struct wlr_xdg_popup *popup,
  const struct wlr_box *toplevel_space_box);
struct wlr_surface *wlr_xdg_surface_surface_at(
  struct wlr_xdg_surface *surface, double sx, double sy,
  double *sub_x, double *sub_y);
struct wlr_surface *wlr_xdg_surface_popup_surface_at(
  struct wlr_xdg_surface *surface, double sx, double sy,
  double *sub_x, double *sub_y);
struct wlr_xdg_surface *wlr_xdg_surface_try_from_wlr_surface(struct wlr_surface *surface);
struct wlr_xdg_toplevel *wlr_xdg_toplevel_try_from_wlr_surface(struct wlr_surface *surface);
struct wlr_xdg_popup *wlr_xdg_popup_try_from_wlr_surface(struct wlr_surface *surface);
void wlr_xdg_surface_get_geometry(struct wlr_xdg_surface *surface,
  struct wlr_box *box);
void wlr_xdg_surface_for_each_surface(struct wlr_xdg_surface *surface,
  wlr_surface_iterator_func_t iterator, void *user_data);
void wlr_xdg_surface_for_each_popup_surface(struct wlr_xdg_surface *surface,
  wlr_surface_iterator_func_t iterator, void *user_data);
uint32_t wlr_xdg_surface_schedule_configure(struct wlr_xdg_surface *surface);
enum wlr_xdg_toplevel_decoration_v1_mode {
 WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_NONE = 0,
 WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_CLIENT_SIDE = 1,
 WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_SERVER_SIDE = 2,
};
struct wlr_xdg_decoration_manager_v1 {
 struct wl_global *global;
 struct wl_list decorations;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal new_toplevel_decoration;
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_xdg_toplevel_decoration_v1_configure {
 struct wl_list link;
 struct wlr_xdg_surface_configure *surface_configure;
 enum wlr_xdg_toplevel_decoration_v1_mode mode;
};
struct wlr_xdg_toplevel_decoration_v1_state {
 enum wlr_xdg_toplevel_decoration_v1_mode mode;
};
struct wlr_xdg_toplevel_decoration_v1 {
 struct wl_resource *resource;
 struct wlr_xdg_toplevel *toplevel;
 struct wlr_xdg_decoration_manager_v1 *manager;
 struct wl_list link;
 struct wlr_xdg_toplevel_decoration_v1_state current, pending;
 enum wlr_xdg_toplevel_decoration_v1_mode scheduled_mode;
 enum wlr_xdg_toplevel_decoration_v1_mode requested_mode;
 struct wl_list configure_list;
 struct {
  struct wl_signal destroy;
  struct wl_signal request_mode;
 } events;
 void *data;
 struct wl_listener toplevel_destroy;
 struct wl_listener surface_configure;
 struct wl_listener surface_ack_configure;
 struct wlr_surface_synced synced;
};
struct wlr_xdg_decoration_manager_v1 *
 wlr_xdg_decoration_manager_v1_create(struct wl_display *display);
uint32_t wlr_xdg_toplevel_decoration_v1_set_mode(
 struct wlr_xdg_toplevel_decoration_v1 *decoration,
 enum wlr_xdg_toplevel_decoration_v1_mode mode);
struct wlr_xdg_foreign_registry {
 struct wl_list exported_surfaces;
 struct wl_listener display_destroy;
 struct {
  struct wl_signal destroy;
 } events;
};
struct wlr_xdg_foreign_exported {
 struct wl_list link;
 struct wlr_xdg_foreign_registry *registry;
 struct wlr_surface *surface;
 char handle[37];
 struct {
  struct wl_signal destroy;
 } events;
};
struct wlr_xdg_foreign_registry *wlr_xdg_foreign_registry_create(
 struct wl_display *display);
_Bool
    wlr_xdg_foreign_exported_init(struct wlr_xdg_foreign_exported *surface,
 struct wlr_xdg_foreign_registry *registry);
struct wlr_xdg_foreign_exported *wlr_xdg_foreign_registry_find_by_handle(
 struct wlr_xdg_foreign_registry *registry, const char *handle);
void wlr_xdg_foreign_exported_finish(struct wlr_xdg_foreign_exported *surface);
struct wlr_xdg_foreign_v1 {
 struct {
  struct wl_global *global;
  struct wl_list objects;
 } exporter, importer;
 struct wl_listener foreign_registry_destroy;
 struct wl_listener display_destroy;
 struct wlr_xdg_foreign_registry *registry;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_xdg_exported_v1 {
 struct wlr_xdg_foreign_exported base;
 struct wl_resource *resource;
 struct wl_listener xdg_toplevel_destroy;
 struct wl_list link;
};
struct wlr_xdg_imported_v1 {
 struct wlr_xdg_foreign_exported *exported;
 struct wl_listener exported_destroyed;
 struct wl_resource *resource;
 struct wl_list link;
 struct wl_list children;
};
struct wlr_xdg_imported_child_v1 {
 struct wlr_xdg_imported_v1 *imported;
 struct wlr_surface *surface;
 struct wl_list link;
 struct wl_listener xdg_toplevel_destroy;
 struct wl_listener xdg_toplevel_set_parent;
};
struct wlr_xdg_foreign_v1 *wlr_xdg_foreign_v1_create(
  struct wl_display *display, struct wlr_xdg_foreign_registry *registry);
struct wlr_xdg_foreign_v2 {
 struct {
  struct wl_global *global;
  struct wl_list objects;
 } exporter, importer;
 struct wl_listener foreign_registry_destroy;
 struct wl_listener display_destroy;
 struct wlr_xdg_foreign_registry *registry;
 struct {
  struct wl_signal destroy;
 } events;
 void *data;
};
struct wlr_xdg_exported_v2 {
 struct wlr_xdg_foreign_exported base;
 struct wl_resource *resource;
 struct wl_listener xdg_toplevel_destroy;
 struct wl_list link;
};
struct wlr_xdg_imported_v2 {
 struct wlr_xdg_foreign_exported *exported;
 struct wl_listener exported_destroyed;
 struct wl_resource *resource;
 struct wl_list link;
 struct wl_list children;
};
struct wlr_xdg_imported_child_v2 {
 struct wlr_xdg_imported_v2 *imported;
 struct wlr_surface *surface;
 struct wl_list link;
 struct wl_listener xdg_toplevel_destroy;
 struct wl_listener xdg_toplevel_set_parent;
};
struct wlr_xdg_foreign_v2 *wlr_xdg_foreign_v2_create(
  struct wl_display *display, struct wlr_xdg_foreign_registry *registry);
struct wlr_xdg_output_v1 {
 struct wlr_xdg_output_manager_v1 *manager;
 struct wl_list resources;
 struct wl_list link;
 struct wlr_output_layout_output *layout_output;
 int32_t x, y;
 int32_t width, height;
 struct wl_listener destroy;
 struct wl_listener description;
};
struct wlr_xdg_output_manager_v1 {
 struct wl_global *global;
 struct wlr_output_layout *layout;
 struct wl_list outputs;
 struct {
  struct wl_signal destroy;
 } events;
 struct wl_listener display_destroy;
 struct wl_listener layout_add;
 struct wl_listener layout_change;
 struct wl_listener layout_destroy;
};
struct wlr_xdg_output_manager_v1 *wlr_xdg_output_manager_v1_create(
 struct wl_display *display, struct wlr_output_layout *layout);
typedef __builtin_va_list __gnuc_va_list;
typedef __gnuc_va_list va_list;
enum wlr_log_importance {
 WLR_SILENT = 0,
 WLR_ERROR = 1,
 WLR_INFO = 2,
 WLR_DEBUG = 3,
 WLR_LOG_IMPORTANCE_LAST,
};
typedef void (*wlr_log_func_t)(enum wlr_log_importance importance,
 const char *fmt, va_list args);
void wlr_log_init(enum wlr_log_importance verbosity, wlr_log_func_t callback);
enum wlr_log_importance wlr_log_get_verbosity(void);
void _wlr_log(enum wlr_log_importance verbosity, const char *format, ...) __attribute__((format(printf, 2, 3)));
void _wlr_vlog(enum wlr_log_importance verbosity, const char *format, va_list args) __attribute__((format(printf, 2, 0)));
void wlr_region_scale(pixman_region32_t *dst, const pixman_region32_t *src,
 float scale);
void wlr_region_scale_xy(pixman_region32_t *dst, const pixman_region32_t *src,
 float scale_x, float scale_y);
void wlr_region_transform(pixman_region32_t *dst, const pixman_region32_t *src,
 enum wl_output_transform transform, int width, int height);
void wlr_region_expand(pixman_region32_t *dst, const pixman_region32_t *src,
 int distance);
void wlr_region_rotated_bounds(pixman_region32_t *dst, const pixman_region32_t *src,
 float rotation, int ox, int oy);
_Bool
    wlr_region_confine(const pixman_region32_t *region, double x1, double y1, double x2,
 double y2, double *x2_out, double *y2_out);
enum wl_output_transform wlr_output_transform_invert(
 enum wl_output_transform tr);
enum wl_output_transform wlr_output_transform_compose(
 enum wl_output_transform tr_a, enum wl_output_transform tr_b);
void wlr_output_transform_coords(enum wl_output_transform tr, int *x, int *y);
struct wlr_xwayland_server_options {
_Bool
     lazy;
_Bool
     enable_wm;
_Bool
     no_touch_pointer_emulation;
_Bool
     force_xrandr_emulation;
 int terminate_delay;
};
struct wlr_xwayland_server {
 pid_t pid;
 struct wl_client *client;
 struct wl_event_source *pipe_source;
 int wm_fd[2], wl_fd[2];
_Bool
     ready;
 time_t server_start;
 int display;
 char display_name[16];
 int x_fd[2];
 struct wl_event_source *x_fd_read_event[2];
 struct wlr_xwayland_server_options options;
 struct wl_display *wl_display;
 struct wl_event_source *idle_source;
 struct {
  struct wl_signal start;
  struct wl_signal ready;
  struct wl_signal destroy;
 } events;
 struct wl_listener client_destroy;
 struct wl_listener display_destroy;
 void *data;
};
struct wlr_xwayland_server_ready_event {
 struct wlr_xwayland_server *server;
 int wm_fd;
};
struct wlr_xwayland_server *wlr_xwayland_server_create(
 struct wl_display *display, struct wlr_xwayland_server_options *options);
void wlr_xwayland_server_destroy(struct wlr_xwayland_server *server);
struct wlr_xwayland_shell_v1 {
 struct wl_global *global;
 struct {
  struct wl_signal destroy;
  struct wl_signal new_surface;
 } events;
 struct wl_client *client;
 struct wl_list surfaces;
 struct wl_listener display_destroy;
 struct wl_listener client_destroy;
};
struct wlr_xwayland_surface_v1 {
 struct wlr_surface *surface;
 uint64_t serial;
 struct wl_resource *resource;
 struct wl_list link;
 struct wlr_xwayland_shell_v1 *shell;
_Bool
     added;
};
struct wlr_xwayland_shell_v1 *wlr_xwayland_shell_v1_create(
 struct wl_display *display, uint32_t version);
void wlr_xwayland_shell_v1_destroy(struct wlr_xwayland_shell_v1 *shell);
void wlr_xwayland_shell_v1_set_client(struct wlr_xwayland_shell_v1 *shell,
 struct wl_client *client);
struct wlr_surface *wlr_xwayland_shell_v1_surface_from_serial(
 struct wlr_xwayland_shell_v1 *shell, uint64_t serial);
struct wlr_box;
struct wlr_xwm;
struct wlr_data_source;
struct wlr_drag;
struct wlr_xwayland {
 struct wlr_xwayland_server *server;
_Bool
     own_server;
 struct wlr_xwm *xwm;
 struct wlr_xwayland_shell_v1 *shell_v1;
 struct wlr_xwayland_cursor *cursor;
 const char *display_name;
 struct wl_display *wl_display;
 struct wlr_compositor *compositor;
 struct wlr_seat *seat;
 struct {
  struct wl_signal ready;
  struct wl_signal new_surface;
  struct wl_signal remove_startup_info;
 } events;
 int (*user_event_handler)(struct wlr_xwm *xwm, xcb_generic_event_t *event);
 void *data;
 struct wl_listener server_start;
 struct wl_listener server_ready;
 struct wl_listener server_destroy;
 struct wl_listener seat_destroy;
 struct wl_listener shell_destroy;
};
enum wlr_xwayland_surface_decorations {
 WLR_XWAYLAND_SURFACE_DECORATIONS_ALL = 0,
 WLR_XWAYLAND_SURFACE_DECORATIONS_NO_BORDER = 1,
 WLR_XWAYLAND_SURFACE_DECORATIONS_NO_TITLE = 2,
};
enum wlr_xwayland_icccm_input_model {
 WLR_ICCCM_INPUT_MODEL_NONE = 0,
 WLR_ICCCM_INPUT_MODEL_PASSIVE = 1,
 WLR_ICCCM_INPUT_MODEL_LOCAL = 2,
 WLR_ICCCM_INPUT_MODEL_GLOBAL = 3,
};
struct wlr_xwayland_surface {
 xcb_window_t window_id;
 struct wlr_xwm *xwm;
 uint32_t surface_id;
 uint64_t serial;
 struct wl_list link;
 struct wl_list stack_link;
 struct wl_list unpaired_link;
 struct wlr_surface *surface;
 struct wlr_addon surface_addon;
 struct wl_listener surface_commit;
 struct wl_listener surface_map;
 struct wl_listener surface_unmap;
 int16_t x, y;
 uint16_t width, height;
_Bool
     override_redirect;
 char *title;
 char *class;
 char *instance;
 char *role;
 char *startup_id;
 pid_t pid;
_Bool
     has_utf8_title;
 struct wl_list children;
 struct wlr_xwayland_surface *parent;
 struct wl_list parent_link;
 xcb_atom_t *window_type;
 size_t window_type_len;
 xcb_atom_t *protocols;
 size_t protocols_len;
 uint32_t decorations;
 xcb_icccm_wm_hints_t *hints;
 xcb_size_hints_t *size_hints;
 xcb_ewmh_wm_strut_partial_t *strut_partial;
_Bool
     pinging;
 struct wl_event_source *ping_timer;
_Bool
     modal;
_Bool
     fullscreen;
_Bool
     maximized_vert, maximized_horz;
_Bool
     minimized;
_Bool
     withdrawn;
_Bool
     has_alpha;
 struct {
  struct wl_signal destroy;
  struct wl_signal request_configure;
  struct wl_signal request_move;
  struct wl_signal request_resize;
  struct wl_signal request_minimize;
  struct wl_signal request_maximize;
  struct wl_signal request_fullscreen;
  struct wl_signal request_activate;
  struct wl_signal associate;
  struct wl_signal dissociate;
  struct wl_signal set_title;
  struct wl_signal set_class;
  struct wl_signal set_role;
  struct wl_signal set_parent;
  struct wl_signal set_startup_id;
  struct wl_signal set_window_type;
  struct wl_signal set_hints;
  struct wl_signal set_decorations;
  struct wl_signal set_strut_partial;
  struct wl_signal set_override_redirect;
  struct wl_signal set_geometry;
  struct wl_signal map_request;
  struct wl_signal ping_timeout;
 } events;
 void *data;
};
struct wlr_xwayland_surface_configure_event {
 struct wlr_xwayland_surface *surface;
 int16_t x, y;
 uint16_t width, height;
 uint16_t mask;
};
struct wlr_xwayland_remove_startup_info_event {
 const char *id;
 xcb_window_t window;
};
struct wlr_xwayland_resize_event {
 struct wlr_xwayland_surface *surface;
 uint32_t edges;
};
struct wlr_xwayland_minimize_event {
 struct wlr_xwayland_surface *surface;
_Bool
     minimize;
};
struct wlr_xwayland *wlr_xwayland_create(struct wl_display *wl_display,
 struct wlr_compositor *compositor,
                                   _Bool
                                        lazy);
struct wlr_xwayland *wlr_xwayland_create_with_server(struct wl_display *display,
 struct wlr_compositor *compositor, struct wlr_xwayland_server *server);
void wlr_xwayland_destroy(struct wlr_xwayland *wlr_xwayland);
void wlr_xwayland_set_cursor(struct wlr_xwayland *wlr_xwayland,
 uint8_t *pixels, uint32_t stride, uint32_t width, uint32_t height,
 int32_t hotspot_x, int32_t hotspot_y);
void wlr_xwayland_surface_activate(struct wlr_xwayland_surface *surface,
_Bool
     activated);
void wlr_xwayland_surface_restack(struct wlr_xwayland_surface *surface,
 struct wlr_xwayland_surface *sibling, enum xcb_stack_mode_t mode);
void wlr_xwayland_surface_configure(struct wlr_xwayland_surface *surface,
 int16_t x, int16_t y, uint16_t width, uint16_t height);
void wlr_xwayland_surface_close(struct wlr_xwayland_surface *surface);
void wlr_xwayland_surface_set_withdrawn(struct wlr_xwayland_surface *surface,
_Bool
     withdrawn);
void wlr_xwayland_surface_set_minimized(struct wlr_xwayland_surface *surface,
_Bool
     minimized);
void wlr_xwayland_surface_set_maximized(struct wlr_xwayland_surface *surface,
_Bool
     maximized);
void wlr_xwayland_surface_set_fullscreen(struct wlr_xwayland_surface *surface,
_Bool
     fullscreen);
void wlr_xwayland_set_seat(struct wlr_xwayland *xwayland,
 struct wlr_seat *seat);
struct wlr_xwayland_surface *wlr_xwayland_surface_try_from_wlr_surface(
 struct wlr_surface *surface);
void wlr_xwayland_surface_ping(struct wlr_xwayland_surface *surface);
_Bool
    wlr_xwayland_or_surface_wants_focus(
 const struct wlr_xwayland_surface *xsurface);
enum wlr_xwayland_icccm_input_model wlr_xwayland_icccm_input_model(
 const struct wlr_xwayland_surface *xsurface);
void wlr_xwayland_set_workareas(struct wlr_xwayland *wlr_xwayland,
 const struct wlr_box *workareas, size_t num_workareas);
xcb_connection_t *wlr_xwayland_get_xwm_connection(
 struct wlr_xwayland *wlr_xwayland);
]]

--[[@class wlroots_ffi: { [string]: function }]]

--[[@type wlroots_ffi]]
local ret = ffi.load("wlroots-0.18.so")
return ret
