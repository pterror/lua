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
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/util/addon.h
	struct wlr_addon_set {
		// private state
		struct wl_list addons;
	};
	struct wlr_addon;
	struct wlr_addon_interface {
		const char *name;
		// Has to call wlr_addon_finish()
		void (*destroy)(struct wlr_addon *addon);
	};
	struct wlr_addon {
		const struct wlr_addon_interface *impl;
		// private state
		const void *owner;
		struct wl_list link;
	};
	void wlr_addon_set_init(struct wlr_addon_set *set);
	void wlr_addon_set_finish(struct wlr_addon_set *set);
	void wlr_addon_init(struct wlr_addon *addon, struct wlr_addon_set *set, const void *owner, const struct wlr_addon_interface *impl);
	void wlr_addon_finish(struct wlr_addon *addon);
	struct wlr_addon *wlr_addon_find(struct wlr_addon_set *set, const void *owner, const struct wlr_addon_interface *impl);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/util/box.h
	struct wlr_box {
		int x, y;
		int width, height;
	};
	struct wlr_fbox {
		double x, y;
		double width, height;
	};
	void wlr_box_closest_point(const struct wlr_box *box, double x, double y, double *dest_x, double *dest_y);
	bool wlr_box_intersection(struct wlr_box *dest, const struct wlr_box *box_a, const struct wlr_box *box_b);
	bool wlr_box_contains_point(const struct wlr_box *box, double x, double y);
	bool wlr_box_empty(const struct wlr_box *box);
	void wlr_box_transform(struct wlr_box *dest, const struct wlr_box *box, enum wl_output_transform transform, int width, int height);
	bool wlr_fbox_empty(const struct wlr_fbox *box);
	void wlr_fbox_transform(struct wlr_fbox *dest, const struct wlr_fbox *box, enum wl_output_transform transform, double width, double height);
	// #ifdef WLR_USE_UNSTABLE
	bool wlr_box_equal(const struct wlr_box *a, const struct wlr_box *b);
	bool wlr_fbox_equal(const struct wlr_fbox *a, const struct wlr_fbox *b);
	// #endif
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/util/edges.h
	enum wlr_edges {
		WLR_EDGE_NONE = 0,
		WLR_EDGE_TOP = 1 << 0,
		WLR_EDGE_BOTTOM = 1 << 1,
		WLR_EDGE_LEFT = 1 << 2,
		WLR_EDGE_RIGHT = 1 << 3,
	};
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/util/log.h
	enum wlr_log_importance {
		WLR_SILENT = 0,
		WLR_ERROR = 1,
		WLR_INFO = 2,
		WLR_DEBUG = 3,
		WLR_LOG_IMPORTANCE_LAST,
	};
	typedef void (*wlr_log_func_t)(enum wlr_log_importance importance, const char *fmt, va_list args);
	void wlr_log_init(enum wlr_log_importance verbosity, wlr_log_func_t callback);
	enum wlr_log_importance wlr_log_get_verbosity(void);
	void _wlr_log(enum wlr_log_importance verbosity, const char *format, ...);
	void _wlr_vlog(enum wlr_log_importance verbosity, const char *format, va_list args);
	// https://github.com/servo/pixman/blob/958bd334b3c17f529c80f2eeef4224f45c62f292/pixman/pixman.h#L497-L523
	typedef struct pixman_region32_data	pixman_region32_data_t;
	typedef struct pixman_box32		pixman_box32_t;
	typedef struct pixman_rectangle32	pixman_rectangle32_t;
	typedef struct pixman_region32		pixman_region32_t;
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
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/util/array.h
	void array_remove_at(struct wl_array *arr, size_t offset, size_t size);
	bool array_realloc(struct wl_array *arr, size_t size);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/util/env.h
	bool env_parse_bool(const char *option);
	size_t env_parse_switch(const char *option, const char **switches);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/util/global.h
	void wlr_global_destroy_safe(struct wl_global *global);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/util/rect_union.h
	struct rect_union {
		pixman_box32_t bounding_box; // Always up-to-date bounding box
		pixman_region32_t region; // Updated only on _evaluate()
		struct wl_array unsorted; // pixman_box32_t
		bool alloc_failure; // If this is true, fall back to computing a bounding box
	};
	void rect_union_init(struct rect_union *r);
	void rect_union_finish(struct rect_union *r);
	void rect_union_add(struct rect_union *r, pixman_box32_t box);
	const pixman_region32_t *rect_union_evaluate(struct rect_union *r);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/util/set.h
	ssize_t set_add(uint32_t values[], size_t *len, size_t cap, uint32_t target);
	ssize_t set_remove(uint32_t values[], size_t *len, size_t cap, uint32_t target);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/util/shm.h
	int create_shm_file(void);
	int allocate_shm_file(size_t size);
	bool allocate_shm_file_pair(size_t size, int *rw_fd, int *ro_fd);
	// https://github.com/bminor/glibc/blob/master/time/bits/types/struct_timespec.h
	struct timespec {
	  int64_t /*__time_t*/ tv_sec;
  	int64_t /*__syscall_slong_t*/ tv_nsec;
	};
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/util/time.h
	int64_t get_current_time_msec(void);
	int64_t timespec_to_msec(const struct timespec *a);
	int64_t timespec_to_nsec(const struct timespec *a);
	void timespec_from_nsec(struct timespec *r, int64_t nsec);
	void timespec_sub(struct timespec *r, const struct timespec *a, const struct timespec *b);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/util/token.h
	bool generate_token(char out[33 /* 32 + trailing null byte */]);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/util/utf8.h
	bool is_utf8(const char *string);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/util/region.h
	void wlr_region_scale(pixman_region32_t *dst, const pixman_region32_t *src, float scale);
	void wlr_region_scale_xy(pixman_region32_t *dst, const pixman_region32_t *src, float scale_x, float scale_y);
	void wlr_region_transform(pixman_region32_t *dst, const pixman_region32_t *src, enum wl_output_transform transform, int width, int height);
	void wlr_region_expand(pixman_region32_t *dst, const pixman_region32_t *src, int distance);
	void wlr_region_rotated_bounds(pixman_region32_t *dst, const pixman_region32_t *src, float rotation, int ox, int oy);
	bool wlr_region_confine(const pixman_region32_t *region, double x1, double y1, double x2, double y2, double *x2_out, double *y2_out);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/util/transform.h
	enum wl_output_transform wlr_output_transform_invert(enum wl_output_transform tr);
	enum wl_output_transform wlr_output_transform_compose(enum wl_output_transform tr_a, enum wl_output_transform tr_b);
	void wlr_output_transform_coords(enum wl_output_transform tr, int *x, int *y);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_alpha_modifier_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_surface;
	struct wlr_alpha_modifier_surface_v1_state {
		double multiplier; // between 0 and 1
	};
	struct wlr_alpha_modifier_v1 {
		struct wl_global *global;
		// private state
		struct wl_listener display_destroy;
	};
	struct wlr_alpha_modifier_v1 *wlr_alpha_modifier_v1_create(struct wl_display *display);
	const struct wlr_alpha_modifier_surface_v1_state *wlr_alpha_modifier_v1_get_surface_state(struct wlr_surface *surface);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_buffer.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		bool dropped;
		size_t n_locks;
		bool accessing_data_ptr;
		struct {
			struct wl_signal destroy;
			struct wl_signal release;
		} events;
		struct wlr_addon_set addons;
	};
	void wlr_buffer_drop(struct wlr_buffer *buffer);
	struct wlr_buffer *wlr_buffer_lock(struct wlr_buffer *buffer);
	void wlr_buffer_unlock(struct wlr_buffer *buffer);
	bool wlr_buffer_get_dmabuf(struct wlr_buffer *buffer, struct wlr_dmabuf_attributes *attribs);
	bool wlr_buffer_get_shm(struct wlr_buffer *buffer, struct wlr_shm_attributes *attribs);
	struct wlr_buffer *wlr_buffer_try_from_resource(struct wl_resource *resource);
	enum wlr_buffer_data_ptr_access_flag {
		WLR_BUFFER_DATA_PTR_ACCESS_READ = 1 << 0,
		WLR_BUFFER_DATA_PTR_ACCESS_WRITE = 1 << 1,
	};
	bool wlr_buffer_begin_data_ptr_access(struct wlr_buffer *buffer, uint32_t flags, void **data, uint32_t *format, size_t *stride);
	void wlr_buffer_end_data_ptr_access(struct wlr_buffer *buffer);
	struct wlr_client_buffer {
		struct wlr_buffer base;
		struct wlr_texture *texture;
		struct wlr_buffer *source;
		// private state
		struct wl_listener source_destroy;
		struct wl_listener renderer_destroy;
		size_t n_ignore_locks;
	};
	struct wlr_client_buffer *wlr_client_buffer_get(struct wlr_buffer *buffer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_compositor.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		uint32_t committed; // enum wlr_surface_state_field
		// Sequence number of the surface state. Incremented on each commit, may
		// overflow.
		uint32_t seq;
		struct wlr_buffer *buffer;
		int32_t dx, dy; // relative to previous position
		pixman_region32_t surface_damage, buffer_damage; // clipped to bounds
		pixman_region32_t opaque, input;
		enum wl_output_transform transform;
		int32_t scale;
		struct wl_list frame_callback_list; // wl_resource
		int width, height; // in surface-local coordinates
		int buffer_width, buffer_height;
		struct wl_list subsurfaces_below;
		struct wl_list subsurfaces_above;
		struct {
			bool has_src, has_dst;
			// In coordinates after scale/transform are applied, but before the
			// destination rectangle is applied
			struct wlr_fbox src;
			int dst_width, dst_height; // in surface-local coordinates
		} viewport;
		// Number of locks that prevent this surface state from being committed.
		size_t cached_state_locks;
		struct wl_list cached_state_link; // wlr_surface.cached
		// Sync'ed object states, one per struct wlr_surface_synced
		struct wl_array synced; // void *
	};
	struct wlr_surface_role {
		const char *name;
		bool no_object;
		void (*client_commit)(struct wlr_surface *surface);
		void (*commit)(struct wlr_surface *surface);
		void (*unmap)(struct wlr_surface *surface);
		void (*destroy)(struct wlr_surface *surface);
	};
	struct wlr_surface_output {
		struct wlr_surface *surface;
		struct wlr_output *output;
		struct wl_list link; // wlr_surface.current_outputs
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
		struct wl_list cached; // wlr_surface_state.cached_link
		bool mapped;
		const struct wlr_surface_role *role;
		struct wl_resource *role_resource;
		struct {
			struct wl_signal client_commit;
			struct wl_signal commit;
			struct wl_signal map;
			struct wl_signal unmap;
			struct wl_signal new_subsurface; // struct wlr_subsurface
			struct wl_signal destroy;
		} events;
		struct wl_list current_outputs; // wlr_surface_output.link
		struct wlr_addon_set addons;
		void *data;
		// private state
		struct wl_listener role_resource_destroy;
		struct {
			int32_t scale;
			enum wl_output_transform transform;
			int width, height;
			int buffer_width, buffer_height;
		} previous;
		bool unmap_commit;
		bool opaque;
		bool handling_commit;
		bool pending_rejected;
		int32_t preferred_buffer_scale;
		bool preferred_buffer_transform_sent;
		enum wl_output_transform preferred_buffer_transform;
		struct wl_list synced; // wlr_surface_synced.link
		size_t synced_len;
		struct wl_resource *pending_buffer_resource;
		struct wl_listener pending_buffer_resource_destroy;
	};
	struct wlr_renderer;
	struct wlr_compositor {
		struct wl_global *global;
		struct wlr_renderer *renderer; // may be NULL
		struct wl_listener display_destroy;
		struct wl_listener renderer_destroy;
		struct {
			struct wl_signal new_surface;
			struct wl_signal destroy;
		} events;
	};
	typedef void (*wlr_surface_iterator_func_t)(struct wlr_surface *surface, int sx, int sy, void *data);
	bool wlr_surface_set_role(struct wlr_surface *surface, const struct wlr_surface_role *role, struct wl_resource *error_resource, uint32_t error_code);
	void wlr_surface_set_role_object(struct wlr_surface *surface, struct wl_resource *role_resource);
	void wlr_surface_map(struct wlr_surface *surface);
	void wlr_surface_unmap(struct wlr_surface *surface);
	void wlr_surface_reject_pending(struct wlr_surface *surface, struct wl_resource *resource, uint32_t code, const char *msg, ...);
	bool wlr_surface_has_buffer(struct wlr_surface *surface);
	bool wlr_surface_state_has_buffer(const struct wlr_surface_state *state);
	struct wlr_texture *wlr_surface_get_texture(struct wlr_surface *surface);
	struct wlr_surface *wlr_surface_get_root_surface(struct wlr_surface *surface);
	bool wlr_surface_point_accepts_input(struct wlr_surface *surface, double sx, double sy);
	struct wlr_surface *wlr_surface_surface_at(struct wlr_surface *surface, double sx, double sy, double *sub_x, double *sub_y);
	void wlr_surface_send_enter(struct wlr_surface *surface, struct wlr_output *output);
	void wlr_surface_send_leave(struct wlr_surface *surface, struct wlr_output *output);
	void wlr_surface_send_frame_done(struct wlr_surface *surface, const struct timespec *when);
	void wlr_surface_get_extents(struct wlr_surface *surface, struct wlr_box *box);
	struct wlr_surface *wlr_surface_from_resource(struct wl_resource *resource);
	void wlr_surface_for_each_surface(struct wlr_surface *surface, wlr_surface_iterator_func_t iterator, void *user_data);
	void wlr_surface_get_effective_damage(struct wlr_surface *surface, pixman_region32_t *damage);
	void wlr_surface_get_buffer_source_box(struct wlr_surface *surface, struct wlr_fbox *box);
	uint32_t wlr_surface_lock_pending(struct wlr_surface *surface);
	void wlr_surface_unlock_cached(struct wlr_surface *surface, uint32_t seq);
	void wlr_surface_set_preferred_buffer_scale(struct wlr_surface *surface, int32_t scale);
	void wlr_surface_set_preferred_buffer_transform(struct wlr_surface *surface, enum wl_output_transform transform);
	struct wlr_surface_synced_impl {
		size_t state_size;
		void (*init_state)(void *state);
		void (*finish_state)(void *state);
		void (*move_state)(void *dst, void *src);
	};
	struct wlr_surface_synced {
		struct wlr_surface *surface;
		const struct wlr_surface_synced_impl *impl;
		struct wl_list link; // wlr_surface.synced
		size_t index;
	};
	bool wlr_surface_synced_init(struct wlr_surface_synced *synced, struct wlr_surface *surface, const struct wlr_surface_synced_impl *impl, void *pending, void *current);
	void wlr_surface_synced_finish(struct wlr_surface_synced *synced);
	void *wlr_surface_synced_get_state(struct wlr_surface_synced *synced, const struct wlr_surface_state *state);
	const pixman_region32_t *wlr_region_from_resource(struct wl_resource *resource);
	struct wlr_compositor *wlr_compositor_create(struct wl_display *display, uint32_t version, struct wlr_renderer *renderer);
	void wlr_compositor_set_renderer(struct wlr_compositor *compositor, struct wlr_renderer *renderer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_content_type_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_surface;
	struct wlr_content_type_manager_v1 {
		struct wl_global *global;
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
		// private state
		struct wl_listener display_destroy;
	};
	struct wlr_content_type_manager_v1 *wlr_content_type_manager_v1_create(struct wl_display *display, uint32_t version);
	enum wp_content_type_v1_type wlr_surface_get_content_type_v1(struct wlr_content_type_manager_v1 *manager, struct wlr_surface *surface);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_cursor.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
	bool wlr_cursor_warp(struct wlr_cursor *cur, struct wlr_input_device *dev, double lx, double ly);
	void wlr_cursor_absolute_to_layout_coords(struct wlr_cursor *cur, struct wlr_input_device *dev, double x, double y, double *lx, double *ly);
	void wlr_cursor_warp_closest(struct wlr_cursor *cur, struct wlr_input_device *dev, double x, double y);
	void wlr_cursor_warp_absolute(struct wlr_cursor *cur, struct wlr_input_device *dev, double x, double y);
	void wlr_cursor_move(struct wlr_cursor *cur, struct wlr_input_device *dev, double delta_x, double delta_y);
	void wlr_cursor_set_buffer(struct wlr_cursor *cur, struct wlr_buffer *buffer, int32_t hotspot_x, int32_t hotspot_y, float scale);
	void wlr_cursor_unset_image(struct wlr_cursor *cur);
	void wlr_cursor_set_xcursor(struct wlr_cursor *cur, struct wlr_xcursor_manager *manager, const char *name);
	void wlr_cursor_set_surface(struct wlr_cursor *cur, struct wlr_surface *surface, int32_t hotspot_x, int32_t hotspot_y);
	void wlr_cursor_attach_input_device(struct wlr_cursor *cur, struct wlr_input_device *dev);
	void wlr_cursor_detach_input_device(struct wlr_cursor *cur, struct wlr_input_device *dev);
	void wlr_cursor_attach_output_layout(struct wlr_cursor *cur, struct wlr_output_layout *l);
	void wlr_cursor_map_to_output(struct wlr_cursor *cur, struct wlr_output *output);
	void wlr_cursor_map_input_to_output(struct wlr_cursor *cur, struct wlr_input_device *dev, struct wlr_output *output);
	void wlr_cursor_map_to_region(struct wlr_cursor *cur, const struct wlr_box *box);
	void wlr_cursor_map_input_to_region(struct wlr_cursor *cur, struct wlr_input_device *dev, const struct wlr_box *box);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_cursor_shape_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_cursor_shape_manager_v1 {
		struct wl_global *global;
		struct {
			struct wl_signal request_set_shape; // struct wlr_cursor_shape_manager_v1_request_set_shape_event
			struct wl_signal destroy;
		} events;
		void *data;
		// private state
		struct wl_listener display_destroy;
	};
	enum wlr_cursor_shape_manager_v1_device_type {
		WLR_CURSOR_SHAPE_MANAGER_V1_DEVICE_TYPE_POINTER,
		WLR_CURSOR_SHAPE_MANAGER_V1_DEVICE_TYPE_TABLET_TOOL,
	};
	struct wlr_cursor_shape_manager_v1_request_set_shape_event {
		struct wlr_seat_client *seat_client;
		enum wlr_cursor_shape_manager_v1_device_type device_type;
		// NULL if device_type is not TABLET_TOOL
		struct wlr_tablet_v2_tablet_tool *tablet_tool;
		uint32_t serial;
		enum wp_cursor_shape_device_v1_shape shape;
	};
	struct wlr_cursor_shape_manager_v1 *wlr_cursor_shape_manager_v1_create(struct wl_display *display, uint32_t version);
	const char *wlr_cursor_shape_v1_name(enum wp_cursor_shape_device_v1_shape shape);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_damage_ring.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_box;
	struct wlr_damage_ring_buffer {
		struct wlr_buffer *buffer;
		struct wl_listener destroy;
		pixman_region32_t damage;
		struct wlr_damage_ring *ring;
		struct wl_list link; // wlr_damage_ring.buffers
	};
	struct wlr_damage_ring {
		int32_t width, height;
		// Difference between the current buffer and the previous one
		pixman_region32_t current;
		// private state
		pixman_region32_t previous[2 /* WLR_DAMAGE_RING_PREVIOUS_LEN */];
		size_t previous_idx;
		struct wl_list buffers; // wlr_damage_ring_buffer.link
	};
	void wlr_damage_ring_init(struct wlr_damage_ring *ring);
	void wlr_damage_ring_finish(struct wlr_damage_ring *ring);
	void wlr_damage_ring_set_bounds(struct wlr_damage_ring *ring, int32_t width, int32_t height);
	bool wlr_damage_ring_add(struct wlr_damage_ring *ring, const pixman_region32_t *damage);
	bool wlr_damage_ring_add_box(struct wlr_damage_ring *ring, const struct wlr_box *box);
	void wlr_damage_ring_add_whole(struct wlr_damage_ring *ring);
	void wlr_damage_ring_rotate(struct wlr_damage_ring *ring);
	void wlr_damage_ring_get_buffer_damage(struct wlr_damage_ring *ring, int buffer_age, pixman_region32_t *damage);
	void wlr_damage_ring_rotate_buffer(struct wlr_damage_ring *ring, struct wlr_buffer *buffer, pixman_region32_t *damage);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_data_control_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_data_control_manager_v1 {
		struct wl_global *global;
		struct wl_list devices; // wlr_data_control_device_v1.link
		struct {
			struct wl_signal destroy;
			struct wl_signal new_device; // wlr_data_control_device_v1
		} events;
		struct wl_listener display_destroy;
	};
	struct wlr_data_control_device_v1 {
		struct wl_resource *resource;
		struct wlr_data_control_manager_v1 *manager;
		struct wl_list link; // wlr_data_control_manager_v1.devices
		struct wlr_seat *seat;
		struct wl_resource *selection_offer_resource; // current selection offer
		struct wl_resource *primary_selection_offer_resource; // current primary selection offer
		struct wl_listener seat_destroy;
		struct wl_listener seat_set_selection;
		struct wl_listener seat_set_primary_selection;
	};
	struct wlr_data_control_manager_v1 *wlr_data_control_manager_v1_create(struct wl_display *display);
	void wlr_data_control_device_v1_destroy(struct wlr_data_control_device_v1 *device);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_seat.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_surface;
	struct wlr_serial_range {
		uint32_t min_incl;
		uint32_t max_incl;
	};
	struct wlr_serial_ringset {
		struct wlr_serial_range data[128 /* WLR_SERIAL_RINGSET_SIZE */];
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
		bool needs_touch_frame;
		struct {
			int32_t acc_discrete[2];
			int32_t last_discrete[2];
			double acc_axis[2];
		} value120;
	};
	struct wlr_touch_point {
		int32_t touch_id;
		struct wlr_surface *surface; // may be NULL if destroyed
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
		void (*enter)(struct wlr_seat_pointer_grab *grab, struct wlr_surface *surface, double sx, double sy);
		void (*clear_focus)(struct wlr_seat_pointer_grab *grab);
		void (*motion)(struct wlr_seat_pointer_grab *grab, uint32_t time_msec, double sx, double sy);
		uint32_t (*button)(struct wlr_seat_pointer_grab *grab, uint32_t time_msec, uint32_t button, enum wl_pointer_button_state state);
		void (*axis)(struct wlr_seat_pointer_grab *grab, uint32_t time_msec, enum wl_pointer_axis orientation, double value, int32_t value_discrete, enum wl_pointer_axis_source source, enum wl_pointer_axis_relative_direction relative_direction);
		void (*frame)(struct wlr_seat_pointer_grab *grab);
		void (*cancel)(struct wlr_seat_pointer_grab *grab);
	};
	struct wlr_seat_keyboard_grab;
	struct wlr_keyboard_grab_interface {
		void (*enter)(struct wlr_seat_keyboard_grab *grab, struct wlr_surface *surface, const uint32_t keycodes[], size_t num_keycodes, const struct wlr_keyboard_modifiers *modifiers);
		void (*clear_focus)(struct wlr_seat_keyboard_grab *grab);
		void (*key)(struct wlr_seat_keyboard_grab *grab, uint32_t time_msec, uint32_t key, uint32_t state);
		void (*modifiers)(struct wlr_seat_keyboard_grab *grab, const struct wlr_keyboard_modifiers *modifiers);
		void (*cancel)(struct wlr_seat_keyboard_grab *grab);
	};
	struct wlr_seat_touch_grab;
	struct wlr_touch_grab_interface {
		uint32_t (*down)(struct wlr_seat_touch_grab *grab, uint32_t time_msec, struct wlr_touch_point *point);
		uint32_t (*up)(struct wlr_seat_touch_grab *grab, uint32_t time_msec, struct wlr_touch_point *point);
		void (*motion)(struct wlr_seat_touch_grab *grab, uint32_t time_msec, struct wlr_touch_point *point);
		void (*enter)(struct wlr_seat_touch_grab *grab, uint32_t time_msec, struct wlr_touch_point *point);
		void (*frame)(struct wlr_seat_touch_grab *grab);
		// Cancel grab
		void (*cancel)(struct wlr_seat_touch_grab *grab);
		// Send wl_touch.cancel
		void (*wl_cancel)(struct wlr_seat_touch_grab *grab, struct wlr_seat_client *seat_client);
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
		bool sent_axis_source;
		enum wl_pointer_axis_source cached_axis_source;
		uint32_t buttons[16 /* WLR_POINTER_BUTTONS_CAP */];
		size_t button_count;
		uint32_t grab_button;
		uint32_t grab_serial;
		uint32_t grab_time;
		struct wl_listener surface_destroy;
		struct {
			struct wl_signal focus_change; // struct wlr_seat_pointer_focus_change_event
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
			struct wl_signal focus_change; // struct wlr_seat_keyboard_focus_change_event
		} events;
	};
	struct wlr_seat_touch_state {
		struct wlr_seat *seat;
		struct wl_list touch_points; // wlr_touch_point.link
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
		struct wl_list selection_offers; // wlr_data_offer.link
		struct wlr_primary_selection_source *primary_selection_source;
		uint32_t primary_selection_serial;
		// `drag` goes away before `drag_source`, when the implicit grab ends
		struct wlr_drag *drag;
		struct wlr_data_source *drag_source;
		uint32_t drag_serial;
		struct wl_list drag_offers; // wlr_data_offer.link
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
			// struct wlr_seat_pointer_request_set_cursor_event
			struct wl_signal request_set_cursor;
			struct wl_signal request_set_selection; // struct wlr_seat_request_set_selection_event
			// Called after the data source is set for the selection.
			struct wl_signal set_selection;
			struct wl_signal request_set_primary_selection; // struct wlr_seat_request_set_primary_selection_event
			// Called after the primary selection source object is set.
			struct wl_signal set_primary_selection;
			// struct wlr_seat_request_start_drag_event
			struct wl_signal request_start_drag;
			struct wl_signal start_drag; // struct wlr_drag
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
	struct wlr_seat_client *wlr_seat_client_for_wl_client(struct wlr_seat *wlr_seat, struct wl_client *wl_client);
	void wlr_seat_set_capabilities(struct wlr_seat *wlr_seat, uint32_t capabilities);
	void wlr_seat_set_name(struct wlr_seat *wlr_seat, const char *name);
	bool wlr_seat_pointer_surface_has_focus(struct wlr_seat *wlr_seat, struct wlr_surface *surface);
	void wlr_seat_pointer_enter(struct wlr_seat *wlr_seat, struct wlr_surface *surface, double sx, double sy);
	void wlr_seat_pointer_clear_focus(struct wlr_seat *wlr_seat);
	void wlr_seat_pointer_send_motion(struct wlr_seat *wlr_seat, uint32_t time_msec, double sx, double sy);
	uint32_t wlr_seat_pointer_send_button(struct wlr_seat *wlr_seat, uint32_t time_msec, uint32_t button, enum wl_pointer_button_state state);
	void wlr_seat_pointer_send_axis(struct wlr_seat *wlr_seat, uint32_t time_msec, enum wl_pointer_axis orientation, double value, int32_t value_discrete, enum wl_pointer_axis_source source, enum wl_pointer_axis_relative_direction relative_direction);
	void wlr_seat_pointer_send_frame(struct wlr_seat *wlr_seat);
	void wlr_seat_pointer_notify_enter(struct wlr_seat *wlr_seat, struct wlr_surface *surface, double sx, double sy);
	void wlr_seat_pointer_notify_clear_focus(struct wlr_seat *wlr_seat);
	void wlr_seat_pointer_warp(struct wlr_seat *wlr_seat, double sx, double sy);
	void wlr_seat_pointer_notify_motion(struct wlr_seat *wlr_seat, uint32_t time_msec, double sx, double sy);
	uint32_t wlr_seat_pointer_notify_button(struct wlr_seat *wlr_seat, uint32_t time_msec, uint32_t button, enum wl_pointer_button_state state);
	void wlr_seat_pointer_notify_axis(struct wlr_seat *wlr_seat, uint32_t time_msec, enum wl_pointer_axis orientation, double value, int32_t value_discrete, enum wl_pointer_axis_source source, enum wl_pointer_axis_relative_direction relative_direction);
	void wlr_seat_pointer_notify_frame(struct wlr_seat *wlr_seat);
	void wlr_seat_pointer_start_grab(struct wlr_seat *wlr_seat, struct wlr_seat_pointer_grab *grab);
	void wlr_seat_pointer_end_grab(struct wlr_seat *wlr_seat);
	bool wlr_seat_pointer_has_grab(struct wlr_seat *seat);
	void wlr_seat_set_keyboard(struct wlr_seat *seat, struct wlr_keyboard *keyboard);
	struct wlr_keyboard *wlr_seat_get_keyboard(struct wlr_seat *seat);
	void wlr_seat_keyboard_send_key(struct wlr_seat *seat, uint32_t time_msec, uint32_t key, uint32_t state);
	void wlr_seat_keyboard_send_modifiers(struct wlr_seat *seat, const struct wlr_keyboard_modifiers *modifiers);
	void wlr_seat_keyboard_enter(struct wlr_seat *seat, struct wlr_surface *surface, const uint32_t keycodes[], size_t num_keycodes, const struct wlr_keyboard_modifiers *modifiers);
	void wlr_seat_keyboard_clear_focus(struct wlr_seat *wlr_seat);
	void wlr_seat_keyboard_notify_key(struct wlr_seat *seat, uint32_t time_msec, uint32_t key, uint32_t state);
	void wlr_seat_keyboard_notify_modifiers(struct wlr_seat *seat, const struct wlr_keyboard_modifiers *modifiers);
	void wlr_seat_keyboard_notify_enter(struct wlr_seat *seat, struct wlr_surface *surface, const uint32_t keycodes[], size_t num_keycodes, const struct wlr_keyboard_modifiers *modifiers);
	void wlr_seat_keyboard_notify_clear_focus(struct wlr_seat *wlr_seat);
	void wlr_seat_keyboard_start_grab(struct wlr_seat *wlr_seat, struct wlr_seat_keyboard_grab *grab);
	void wlr_seat_keyboard_end_grab(struct wlr_seat *wlr_seat);
	bool wlr_seat_keyboard_has_grab(struct wlr_seat *seat);
	struct wlr_touch_point *wlr_seat_touch_get_point(struct wlr_seat *seat, int32_t touch_id);
	void wlr_seat_touch_point_focus(struct wlr_seat *seat, struct wlr_surface *surface, uint32_t time_msec, int32_t touch_id, double sx, double sy);
	void wlr_seat_touch_point_clear_focus(struct wlr_seat *seat, uint32_t time_msec, int32_t touch_id);
	uint32_t wlr_seat_touch_send_down(struct wlr_seat *seat, struct wlr_surface *surface, uint32_t time_msec, int32_t touch_id, double sx, double sy);
	uint32_t wlr_seat_touch_send_up(struct wlr_seat *seat, uint32_t time_msec, int32_t touch_id);
	void wlr_seat_touch_send_motion(struct wlr_seat *seat, uint32_t time_msec, int32_t touch_id, double sx, double sy);
	void wlr_seat_touch_send_cancel(struct wlr_seat *seat, struct wlr_seat_client *seat_client);
	void wlr_seat_touch_send_frame(struct wlr_seat *seat);
	uint32_t wlr_seat_touch_notify_down(struct wlr_seat *seat, struct wlr_surface *surface, uint32_t time_msec, int32_t touch_id, double sx, double sy);
	uint32_t wlr_seat_touch_notify_up(struct wlr_seat *seat, uint32_t time_msec, int32_t touch_id);
	void wlr_seat_touch_notify_motion(struct wlr_seat *seat, uint32_t time_msec, int32_t touch_id, double sx, double sy);
	void wlr_seat_touch_notify_cancel(struct wlr_seat *seat, struct wlr_seat_client *seat_client);
	void wlr_seat_touch_notify_frame(struct wlr_seat *seat);
	int wlr_seat_touch_num_points(struct wlr_seat *seat);
	void wlr_seat_touch_start_grab(struct wlr_seat *wlr_seat, struct wlr_seat_touch_grab *grab);
	void wlr_seat_touch_end_grab(struct wlr_seat *wlr_seat);
	bool wlr_seat_touch_has_grab(struct wlr_seat *seat);
	bool wlr_seat_validate_pointer_grab_serial(struct wlr_seat *seat, struct wlr_surface *origin, uint32_t serial);
	bool wlr_seat_validate_touch_grab_serial(struct wlr_seat *seat, struct wlr_surface *origin, uint32_t serial, struct wlr_touch_point **point_ptr);
	uint32_t wlr_seat_client_next_serial(struct wlr_seat_client *client);
	bool wlr_seat_client_validate_event_serial(struct wlr_seat_client *client, uint32_t serial);
	struct wlr_seat_client *wlr_seat_client_from_resource(struct wl_resource *resource);
	struct wlr_seat_client *wlr_seat_client_from_pointer_resource(struct wl_resource *resource);
	bool wlr_surface_accepts_touch(struct wlr_surface *surface, struct wlr_seat *wlr_seat);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_data_device.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		struct wl_list link; // wlr_seat.{selection_offers,drag_offers}
		uint32_t actions;
		enum wl_data_device_manager_dnd_action preferred_action;
		bool in_ask;
		struct wl_listener source_destroy;
	};
	struct wlr_data_source_impl {
		void (*send)(struct wlr_data_source *source, const char *mime_type, int32_t fd);
		void (*accept)(struct wlr_data_source *source, uint32_t serial, const char *mime_type);
		void (*destroy)(struct wlr_data_source *source);
		void (*dnd_drop)(struct wlr_data_source *source);
		void (*dnd_finish)(struct wlr_data_source *source);
		void (*dnd_action)(struct wlr_data_source *source, enum wl_data_device_manager_dnd_action action);
	};
	struct wlr_data_source {
		const struct wlr_data_source_impl *impl;
		// source metadata
		struct wl_array mime_types;
		int32_t actions;
		// source status
		bool accepted;
		// drag'n'drop status
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
		struct wlr_drag_icon *icon; // can be NULL
		struct wlr_surface *focus; // can be NULL
		struct wlr_data_source *source; // can be NULL
		bool started, dropped, cancelling;
		int32_t grab_touch_id, touch_id; // if WLR_DRAG_GRAB_TOUCH
		struct {
			struct wl_signal focus;
			struct wl_signal motion; // struct wlr_drag_motion_event
			struct wl_signal drop; // struct wlr_drag_drop_event
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
	struct wlr_data_device_manager *wlr_data_device_manager_create(struct wl_display *display);
	void wlr_seat_request_set_selection(struct wlr_seat *seat, struct wlr_seat_client *client, struct wlr_data_source *source, uint32_t serial);
	void wlr_seat_set_selection(struct wlr_seat *seat, struct wlr_data_source *source, uint32_t serial);
	struct wlr_drag *wlr_drag_create(struct wlr_seat_client *seat_client, struct wlr_data_source *source, struct wlr_surface *icon_surface);
	void wlr_seat_request_start_drag(struct wlr_seat *seat, struct wlr_drag *drag, struct wlr_surface *origin, uint32_t serial);
	void wlr_seat_start_drag(struct wlr_seat *seat, struct wlr_drag *drag, uint32_t serial);
	void wlr_seat_start_pointer_drag(struct wlr_seat *seat, struct wlr_drag *drag, uint32_t serial);
	void wlr_seat_start_touch_drag(struct wlr_seat *seat, struct wlr_drag *drag, uint32_t serial, struct wlr_touch_point *point);
	void wlr_data_source_init(struct wlr_data_source *source, const struct wlr_data_source_impl *impl);
	void wlr_data_source_send(struct wlr_data_source *source, const char *mime_type, int32_t fd);
	void wlr_data_source_accept(struct wlr_data_source *source, uint32_t serial, const char *mime_type);
	void wlr_data_source_destroy(struct wlr_data_source *source);
	void wlr_data_source_dnd_drop(struct wlr_data_source *source);
	void wlr_data_source_dnd_finish(struct wlr_data_source *source);
	void wlr_data_source_dnd_action(struct wlr_data_source *source, enum wl_data_device_manager_dnd_action action);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/drm_format_set.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_drm_format {
		// The actual DRM format, from `drm_fourcc.h`
		uint32_t format;
		// The number of modifiers
		size_t len;
		// The capacity of the array; do not use.
		size_t capacity;
		// The actual modifiers
		uint64_t *modifiers;
	};
	void wlr_drm_format_finish(struct wlr_drm_format *format);
	struct wlr_drm_format_set {
		// The number of formats
		size_t len;
		// The capacity of the array; private to wlroots
		size_t capacity;
		// A pointer to an array of `struct wlr_drm_format *` of length `len`.
		struct wlr_drm_format *formats;
	};
	void wlr_drm_format_set_finish(struct wlr_drm_format_set *set);
	const struct wlr_drm_format *wlr_drm_format_set_get(const struct wlr_drm_format_set *set, uint32_t format);
	bool wlr_drm_format_set_has(const struct wlr_drm_format_set *set, uint32_t format, uint64_t modifier);
	bool wlr_drm_format_set_add(struct wlr_drm_format_set *set, uint32_t format, uint64_t modifier);
	bool wlr_drm_format_set_intersect(struct wlr_drm_format_set *dst, const struct wlr_drm_format_set *a, const struct wlr_drm_format_set *b);
	bool wlr_drm_format_set_union(struct wlr_drm_format_set *dst, const struct wlr_drm_format_set *a, const struct wlr_drm_format_set *b);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/dmabuf.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_dmabuf_attributes {
		int32_t width, height;
		uint32_t format; // FourCC code, see DRM_FORMAT_* in <drm_fourcc.h>
		uint64_t modifier; // see DRM_FORMAT_MOD_* in <drm_fourcc.h>
		int n_planes;
		uint32_t offset[4 /* WLR_DMABUF_MAX_PLANES */];
		uint32_t stride[4 /* WLR_DMABUF_MAX_PLANES */];
		int fd[4 /* WLR_DMABUF_MAX_PLANES */];
	};
	void wlr_dmabuf_attributes_finish(struct wlr_dmabuf_attributes *attribs);
	bool wlr_dmabuf_attributes_copy(struct wlr_dmabuf_attributes *dst, const struct wlr_dmabuf_attributes *src);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_drm.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_renderer;
	struct wlr_drm_buffer {
		struct wlr_buffer base;
		struct wl_resource *resource; // can be NULL if the client destroyed it
		struct wlr_dmabuf_attributes dmabuf;
		struct wl_listener release;
	};
	struct wlr_drm { // Deprecated: this protocol is legacy and superseded by linux-dmabuf. The implementation will be dropped in a future wlroots version.
		struct wl_global *global;
		struct {
			struct wl_signal destroy;
		} events;
		// private state
		char *node_name;
		struct wlr_drm_format_set formats;
		struct wl_listener display_destroy;
	};
	struct wlr_drm_buffer *wlr_drm_buffer_try_from_resource(struct wl_resource *resource);
	struct wlr_drm *wlr_drm_create(struct wl_display *display, struct wlr_renderer *renderer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_drm_lease_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_backend;
	struct wlr_output;
	struct wlr_drm_lease_v1_manager {
		struct wl_list devices; // wlr_drm_lease_device_v1.link
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
		struct wl_list connectors; // wlr_drm_lease_connector_v1.link
		struct wl_list leases; // wlr_drm_lease_v1.link
		struct wl_list requests; // wlr_drm_lease_request_v1.link
		struct wl_list link; // wlr_drm_lease_v1_manager.devices
		struct wl_listener backend_destroy;
		void *data;
	};
	struct wlr_drm_lease_v1;
	struct wlr_drm_lease_connector_v1 {
		struct wl_list resources; // wl_resource_get_link()
		struct wlr_output *output;
		struct wlr_drm_lease_device_v1 *device;
		/** NULL if no client is currently leasing this connector */
		struct wlr_drm_lease_v1 *active_lease;
		struct wl_listener destroy;
		struct wl_list link; // wlr_drm_lease_device_v1.connectors
	};
	struct wlr_drm_lease_request_v1 {
		struct wl_resource *resource;
		struct wlr_drm_lease_device_v1 *device;
		struct wlr_drm_lease_connector_v1 **connectors;
		size_t n_connectors;
		struct wl_resource *lease_resource;
		bool invalid;
		struct wl_list link; // wlr_drm_lease_device_v1.requests
	};
	struct wlr_drm_lease_v1 {
		struct wl_resource *resource;
		struct wlr_drm_lease *drm_lease;
		struct wlr_drm_lease_device_v1 *device;
		struct wlr_drm_lease_connector_v1 **connectors;
		size_t n_connectors;
		struct wl_list link; // wlr_drm_lease_device_v1.leases
		struct wl_listener destroy;
		void *data;
	};
	struct wlr_drm_lease_v1_manager *wlr_drm_lease_v1_manager_create(struct wl_display *display, struct wlr_backend *backend);
	bool wlr_drm_lease_v1_manager_offer_output(struct wlr_drm_lease_v1_manager *manager, struct wlr_output *output);
	void wlr_drm_lease_v1_manager_withdraw_output(struct wlr_drm_lease_v1_manager *manager, struct wlr_output *output);
	struct wlr_drm_lease_v1 *wlr_drm_lease_request_v1_grant(struct wlr_drm_lease_request_v1 *request);
	void wlr_drm_lease_request_v1_reject(struct wlr_drm_lease_request_v1 *request);
	void wlr_drm_lease_v1_revoke(struct wlr_drm_lease_v1 *lease);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_export_dmabuf_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_export_dmabuf_manager_v1 {
		struct wl_global *global;
		struct wl_list frames; // wlr_export_dmabuf_frame_v1.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal destroy;
		} events;
	};
	struct wlr_export_dmabuf_frame_v1 {
		struct wl_resource *resource;
		struct wlr_export_dmabuf_manager_v1 *manager;
		struct wl_list link; // wlr_export_dmabuf_manager_v1.frames
		struct wlr_output *output;
		bool cursor_locked;
		struct wl_listener output_commit;
		struct wl_listener output_destroy;
	};
	struct wlr_export_dmabuf_manager_v1 *wlr_export_dmabuf_manager_v1_create(struct wl_display *display);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_ext_foreign_toplevel_list_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_ext_foreign_toplevel_list_v1 {
		struct wl_global *global;
		struct wl_list resources; // wl_resource_get_link()
		struct wl_list toplevels; // ext_foreign_toplevel_handle_v1.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_ext_foreign_toplevel_handle_v1 {
		struct wlr_ext_foreign_toplevel_list_v1 *list;
		struct wl_list resources; // wl_resource_get_link()
		struct wl_list link; // wlr_ext_foreign_toplevel_list_v1.toplevels
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
	struct wlr_ext_foreign_toplevel_list_v1 *wlr_ext_foreign_toplevel_list_v1_create(struct wl_display *display, uint32_t version);
	struct wlr_ext_foreign_toplevel_handle_v1 *wlr_ext_foreign_toplevel_handle_v1_create(struct wlr_ext_foreign_toplevel_list_v1 *list, const struct wlr_ext_foreign_toplevel_handle_v1_state *state);
	void wlr_ext_foreign_toplevel_handle_v1_destroy(struct wlr_ext_foreign_toplevel_handle_v1 *toplevel);
	void wlr_ext_foreign_toplevel_handle_v1_update_state(struct wlr_ext_foreign_toplevel_handle_v1 *toplevel, const struct wlr_ext_foreign_toplevel_handle_v1_state *state);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_foreign_toplevel_management_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_foreign_toplevel_manager_v1 {
		struct wl_event_loop *event_loop;
		struct wl_global *global;
		struct wl_list resources; // wl_resource_get_link()
		struct wl_list toplevels; // wlr_foreign_toplevel_handle_v1.link
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
		struct wl_list link; // wlr_foreign_toplevel_handle_v1.outputs
		struct wlr_output *output;
		struct wlr_foreign_toplevel_handle_v1 *toplevel;
		// private state
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
		struct wl_list outputs; // wlr_foreign_toplevel_v1_output.link
		uint32_t state; // enum wlr_foreign_toplevel_v1_state
		struct {
			// struct wlr_foreign_toplevel_handle_v1_maximized_event
			struct wl_signal request_maximize;
			// struct wlr_foreign_toplevel_handle_v1_minimized_event
			struct wl_signal request_minimize;
			// struct wlr_foreign_toplevel_handle_v1_activated_event
			struct wl_signal request_activate;
			// struct wlr_foreign_toplevel_handle_v1_fullscreen_event
			struct wl_signal request_fullscreen;
			struct wl_signal request_close;
			// struct wlr_foreign_toplevel_handle_v1_set_rectangle_event
			struct wl_signal set_rectangle;
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_foreign_toplevel_handle_v1_maximized_event {
		struct wlr_foreign_toplevel_handle_v1 *toplevel;
		bool maximized;
	};
	struct wlr_foreign_toplevel_handle_v1_minimized_event {
		struct wlr_foreign_toplevel_handle_v1 *toplevel;
		bool minimized;
	};
	struct wlr_foreign_toplevel_handle_v1_activated_event {
		struct wlr_foreign_toplevel_handle_v1 *toplevel;
		struct wlr_seat *seat;
	};
	struct wlr_foreign_toplevel_handle_v1_fullscreen_event {
		struct wlr_foreign_toplevel_handle_v1 *toplevel;
		bool fullscreen;
		struct wlr_output *output;
	};
	struct wlr_foreign_toplevel_handle_v1_set_rectangle_event {
		struct wlr_foreign_toplevel_handle_v1 *toplevel;
		struct wlr_surface *surface;
		int32_t x, y, width, height;
	};
	struct wlr_foreign_toplevel_manager_v1 *wlr_foreign_toplevel_manager_v1_create(struct wl_display *display);
	struct wlr_foreign_toplevel_handle_v1 *wlr_foreign_toplevel_handle_v1_create(struct wlr_foreign_toplevel_manager_v1 *manager);
	void wlr_foreign_toplevel_handle_v1_destroy(struct wlr_foreign_toplevel_handle_v1 *toplevel);
	void wlr_foreign_toplevel_handle_v1_set_title(struct wlr_foreign_toplevel_handle_v1 *toplevel, const char *title);
	void wlr_foreign_toplevel_handle_v1_set_app_id(struct wlr_foreign_toplevel_handle_v1 *toplevel, const char *app_id);
	void wlr_foreign_toplevel_handle_v1_output_enter(struct wlr_foreign_toplevel_handle_v1 *toplevel, struct wlr_output *output);
	void wlr_foreign_toplevel_handle_v1_output_leave(struct wlr_foreign_toplevel_handle_v1 *toplevel, struct wlr_output *output);
	void wlr_foreign_toplevel_handle_v1_set_maximized(struct wlr_foreign_toplevel_handle_v1 *toplevel, bool maximized);
	void wlr_foreign_toplevel_handle_v1_set_minimized(struct wlr_foreign_toplevel_handle_v1 *toplevel, bool minimized);
	void wlr_foreign_toplevel_handle_v1_set_activated(struct wlr_foreign_toplevel_handle_v1 *toplevel, bool activated);
	void wlr_foreign_toplevel_handle_v1_set_fullscreen(struct wlr_foreign_toplevel_handle_v1* toplevel, bool fullscreen);
	void wlr_foreign_toplevel_handle_v1_set_parent( struct wlr_foreign_toplevel_handle_v1 *toplevel, struct wlr_foreign_toplevel_handle_v1 *parent);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_fractional_scale_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_surface;
	struct wlr_fractional_scale_manager_v1 {
		struct wl_global *global;
		struct {
			struct wl_signal destroy;
		} events;
		// private state
		struct wl_listener display_destroy;
	};
	void wlr_fractional_scale_v1_notify_scale(struct wlr_surface *surface, double scale);
	struct wlr_fractional_scale_manager_v1 *wlr_fractional_scale_manager_v1_create(struct wl_display *display, uint32_t version);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_fullscreen_shell_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_fullscreen_shell_v1 {
		struct wl_global *global;
		struct {
			struct wl_signal destroy;
			// struct wlr_fullscreen_shell_v1_present_surface_event
			struct wl_signal present_surface;
		} events;
		struct wl_listener display_destroy;
		void *data;
	};
	struct wlr_fullscreen_shell_v1_present_surface_event {
		struct wl_client *client;
		struct wlr_surface *surface; // can be NULL
		enum zwp_fullscreen_shell_v1_present_method method;
		struct wlr_output *output; // can be NULL
	};
	struct wlr_fullscreen_shell_v1 *wlr_fullscreen_shell_v1_create(struct wl_display *display);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_gamma_control_v1.h
	struct wlr_output;
	struct wlr_output_state;
	struct wlr_gamma_control_manager_v1 {
		struct wl_global *global;
		struct wl_list controls; // wlr_gamma_control_v1.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal destroy;
			struct wl_signal set_gamma; // struct wlr_gamma_control_manager_v1_set_gamma_event
		} events;
		void *data;
	};
	struct wlr_gamma_control_manager_v1_set_gamma_event {
		struct wlr_output *output;
		struct wlr_gamma_control_v1 *control; // may be NULL
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
	struct wlr_gamma_control_manager_v1 *wlr_gamma_control_manager_v1_create(struct wl_display *display);
	struct wlr_gamma_control_v1 *wlr_gamma_control_manager_v1_get_control(struct wlr_gamma_control_manager_v1 *manager, struct wlr_output *output);
	bool wlr_gamma_control_v1_apply(struct wlr_gamma_control_v1 *gamma_control, struct wlr_output_state *output_state);
	void wlr_gamma_control_v1_send_failed_and_destroy(struct wlr_gamma_control_v1 *gamma_control);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_idle_inhibit_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_idle_inhibit_manager_v1 {
		struct wl_list inhibitors; // wlr_idle_inhibit_inhibitor_v1.link
		struct wl_global *global;
		struct wl_listener display_destroy;
		struct {
			struct wl_signal new_inhibitor; // struct wlr_idle_inhibitor_v1
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_idle_inhibitor_v1 {
		struct wlr_surface *surface;
		struct wl_resource *resource;
		struct wl_listener surface_destroy;
		struct wl_list link; // wlr_idle_inhibit_manager_v1.inhibitors
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_idle_inhibit_manager_v1 *wlr_idle_inhibit_v1_create(struct wl_display *display);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_idle_notify_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_seat;
	struct wlr_idle_notifier_v1 {
		struct wl_global *global;
		// private state
		bool inhibited;
		struct wl_list notifications; // wlr_idle_notification_v1.link
		struct wl_listener display_destroy;
	};
	struct wlr_idle_notifier_v1 *wlr_idle_notifier_v1_create(struct wl_display *display);
	void wlr_idle_notifier_v1_set_inhibited(struct wlr_idle_notifier_v1 *notifier, bool inhibited);
	void wlr_idle_notifier_v1_notify_activity(struct wlr_idle_notifier_v1 *notifier, struct wlr_seat *seat);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_input_device.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	enum wlr_button_state {
		WLR_BUTTON_RELEASED,
		WLR_BUTTON_PRESSED,
	};
	enum wlr_input_device_type {
		WLR_INPUT_DEVICE_KEYBOARD, // struct wlr_keyboard
		WLR_INPUT_DEVICE_POINTER, // struct wlr_pointer
		WLR_INPUT_DEVICE_TOUCH, // struct wlr_touch
		WLR_INPUT_DEVICE_TABLET, // struct wlr_tablet
		WLR_INPUT_DEVICE_TABLET_PAD, // struct wlr_tablet_pad
		WLR_INPUT_DEVICE_SWITCH, // struct wlr_switch
	};
	struct wlr_input_device {
		enum wlr_input_device_type type;
		char *name; // may be NULL
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
	};
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_input_method_v2.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		bool active; // pending compositor-side state
		bool client_active; // state known to the client
		uint32_t current_serial; // received in last commit call
		struct wl_list popup_surfaces;
		struct wlr_input_method_keyboard_grab_v2 *keyboard_grab;
		struct wl_list link;
		struct wl_listener seat_client_destroy;
		struct {
			struct wl_signal commit; // struct wlr_input_method_v2
			struct wl_signal new_popup_surface; // struct wlr_input_popup_surface_v2
			struct wl_signal grab_keyboard; // struct wlr_input_method_keyboard_grab_v2
			struct wl_signal destroy; // struct wlr_input_method_v2
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
			struct wl_signal destroy; // struct wlr_input_method_keyboard_grab_v2
		} events;
	};
	struct wlr_input_method_manager_v2 {
		struct wl_global *global;
		struct wl_list input_methods; // struct wlr_input_method_v2.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal input_method; // struct wlr_input_method_v2
			struct wl_signal destroy; // struct wlr_input_method_manager_v2
		} events;
	};
	struct wlr_input_method_manager_v2 *wlr_input_method_manager_v2_create(struct wl_display *display);
	void wlr_input_method_v2_send_activate(struct wlr_input_method_v2 *input_method);
	void wlr_input_method_v2_send_deactivate(struct wlr_input_method_v2 *input_method);
	void wlr_input_method_v2_send_surrounding_text(struct wlr_input_method_v2 *input_method, const char *text, uint32_t cursor, uint32_t anchor);
	void wlr_input_method_v2_send_content_type(struct wlr_input_method_v2 *input_method, uint32_t hint, uint32_t purpose);
	void wlr_input_method_v2_send_text_change_cause(struct wlr_input_method_v2 *input_method, uint32_t cause);
	void wlr_input_method_v2_send_done(struct wlr_input_method_v2 *input_method);
	void wlr_input_method_v2_send_unavailable(struct wlr_input_method_v2 *input_method);
	struct wlr_input_popup_surface_v2 *wlr_input_popup_surface_v2_try_from_wlr_surface(struct wlr_surface *surface);
	void wlr_input_popup_surface_v2_send_text_input_rectangle(struct wlr_input_popup_surface_v2 *popup_surface, struct wlr_box *sbox);
	void wlr_input_method_keyboard_grab_v2_send_key(struct wlr_input_method_keyboard_grab_v2 *keyboard_grab, uint32_t time, uint32_t key, uint32_t state);
	void wlr_input_method_keyboard_grab_v2_send_modifiers(struct wlr_input_method_keyboard_grab_v2 *keyboard_grab, struct wlr_keyboard_modifiers *modifiers);
	void wlr_input_method_keyboard_grab_v2_set_keyboard(struct wlr_input_method_keyboard_grab_v2 *keyboard_grab, struct wlr_keyboard *keyboard);
	void wlr_input_method_keyboard_grab_v2_destroy(struct wlr_input_method_keyboard_grab_v2 *keyboard_grab);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_keyboard.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		xkb_led_index_t led_indexes[3 /* WLR_LED_COUNT */];
		xkb_mod_index_t mod_indexes[8 /* WLR_MODIFIER_COUNT */];
		uint32_t leds;
		uint32_t keycodes[32 /* WLR_KEYBOARD_KEYS_CAP */];
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
		bool update_state; // if backend doesn't update modifiers on its own
		enum wl_keyboard_key_state state;
	};
	struct wlr_keyboard *wlr_keyboard_from_input_device(struct wlr_input_device *input_device);
	bool wlr_keyboard_set_keymap(struct wlr_keyboard *kb, struct xkb_keymap *keymap);
	bool wlr_keyboard_keymaps_match(struct xkb_keymap *km1, struct xkb_keymap *km2);
	void wlr_keyboard_set_repeat_info(struct wlr_keyboard *kb, int32_t rate_hz, int32_t delay_ms);
	void wlr_keyboard_led_update(struct wlr_keyboard *keyboard, uint32_t leds);
	uint32_t wlr_keyboard_get_modifiers(struct wlr_keyboard *keyboard);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_keyboard_group.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_keyboard_group {
		struct wlr_keyboard keyboard;
		struct wl_list devices; // keyboard_group_device.link
		struct wl_list keys; // keyboard_group_key.link
		struct {
			struct wl_signal enter;
			struct wl_signal leave;
		} events;
		void *data;
	};
	struct wlr_keyboard_group *wlr_keyboard_group_create(void);
	struct wlr_keyboard_group *wlr_keyboard_group_from_wlr_keyboard(struct wlr_keyboard *keyboard);
	bool wlr_keyboard_group_add_keyboard(struct wlr_keyboard_group *group, struct wlr_keyboard *keyboard);
	void wlr_keyboard_group_remove_keyboard(struct wlr_keyboard_group *group, struct wlr_keyboard *keyboard);
	void wlr_keyboard_group_destroy(struct wlr_keyboard_group *group);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_keyboard_shortcuts_inhibit_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_keyboard_shortcuts_inhibit_manager_v1 {
		// wlr_keyboard_shortcuts_inhibitor_v1.link
		struct wl_list inhibitors;
		struct wl_global *global;
		struct wl_listener display_destroy;
		struct {
			struct wl_signal new_inhibitor; // struct wlr_keyboard_shortcuts_inhibitor_v1
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_keyboard_shortcuts_inhibitor_v1 {
		struct wlr_surface *surface;
		struct wlr_seat *seat;
		bool active;
		struct wl_resource *resource;
		struct wl_listener surface_destroy;
		struct wl_listener seat_destroy;
		// wlr_keyboard_shortcuts_inhibit_manager_v1.inhibitors
		struct wl_list link;
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_keyboard_shortcuts_inhibit_manager_v1 *wlr_keyboard_shortcuts_inhibit_v1_create(struct wl_display *display);
	void wlr_keyboard_shortcuts_inhibitor_v1_activate(struct wlr_keyboard_shortcuts_inhibitor_v1 *inhibitor);
	void wlr_keyboard_shortcuts_inhibitor_v1_deactivate(struct wlr_keyboard_shortcuts_inhibitor_v1 *inhibitor);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_layer_shell_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_layer_shell_v1 {
		struct wl_global *global;
		struct wl_listener display_destroy;
		struct {
			// Note: the output may be NULL. In this case, it is your
			// responsibility to assign an output before returning.
			struct wl_signal new_surface; // struct wlr_layer_surface_v1
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
		uint32_t committed; // enum wlr_layer_surface_v1_state_field
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
		struct wl_list link; // wlr_layer_surface_v1.configure_list
		uint32_t serial;
		uint32_t width, height;
	};
	struct wlr_layer_surface_v1 {
		struct wlr_surface *surface;
		struct wlr_output *output;
		struct wl_resource *resource;
		struct wlr_layer_shell_v1 *shell;
		struct wl_list popups; // wlr_xdg_popup.link
		char *namespace;
		bool configured;
		struct wl_list configure_list;
		struct wlr_layer_surface_v1_state current, pending;
		// Whether the surface is ready to receive configure events
		bool initialized;
		// Whether the latest commit is an initial commit
		bool initial_commit;
		struct {
			struct wl_signal destroy;
			struct wl_signal new_popup;
		} events;
		void *data;
		// private state
		struct wlr_surface_synced synced;
	};
	struct wlr_layer_shell_v1 *wlr_layer_shell_v1_create(struct wl_display *display, uint32_t version);
	uint32_t wlr_layer_surface_v1_configure(struct wlr_layer_surface_v1 *surface, uint32_t width, uint32_t height);
	void wlr_layer_surface_v1_destroy(struct wlr_layer_surface_v1 *surface);
	struct wlr_layer_surface_v1 *wlr_layer_surface_v1_try_from_wlr_surface(struct wlr_surface *surface);
	void wlr_layer_surface_v1_for_each_surface(struct wlr_layer_surface_v1 *surface, wlr_surface_iterator_func_t iterator, void *user_data);
	void wlr_layer_surface_v1_for_each_popup_surface(struct wlr_layer_surface_v1 *surface, wlr_surface_iterator_func_t iterator, void *user_data);
	struct wlr_surface *wlr_layer_surface_v1_surface_at(struct wlr_layer_surface_v1 *surface, double sx, double sy, double *sub_x, double *sub_y);
	struct wlr_surface *wlr_layer_surface_v1_popup_surface_at(struct wlr_layer_surface_v1 *surface, double sx, double sy, double *sub_x, double *sub_y);
	struct wlr_layer_surface_v1 *wlr_layer_surface_v1_from_resource(struct wl_resource *resource);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_linux_dmabuf_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_surface;
	struct wlr_dmabuf_v1_buffer {
		struct wlr_buffer base;
		struct wl_resource *resource; // can be NULL if the client destroyed it
		struct wlr_dmabuf_attributes attributes;
		// private state
		struct wl_listener release;
	};
	struct wlr_dmabuf_v1_buffer *wlr_dmabuf_v1_buffer_try_from_buffer_resource(struct wl_resource *buffer_resource);
	struct wlr_linux_dmabuf_feedback_v1 {
		dev_t main_device;
		struct wl_array tranches; // struct wlr_linux_dmabuf_feedback_v1_tranche
	};
	struct wlr_linux_dmabuf_feedback_v1_tranche {
		dev_t target_device;
		uint32_t flags; // bitfield of enum zwp_linux_dmabuf_feedback_v1_tranche_flags
		struct wlr_drm_format_set formats;
	};
	struct wlr_linux_dmabuf_v1 {
		struct wl_global *global;
		struct {
			struct wl_signal destroy;
		} events;
		// private state
		struct wlr_linux_dmabuf_feedback_v1_compiled *default_feedback;
		struct wlr_drm_format_set default_formats; // for legacy clients
		struct wl_list surfaces; // wlr_linux_dmabuf_v1_surface.link
		int main_device_fd; // to sanity check FDs sent by clients, -1 if unavailable
		struct wl_listener display_destroy;
		bool (*check_dmabuf_callback)(struct wlr_dmabuf_attributes *attribs, void *data);
		void *check_dmabuf_callback_data;
	};
	struct wlr_linux_dmabuf_v1 *wlr_linux_dmabuf_v1_create(struct wl_display *display, uint32_t version, const struct wlr_linux_dmabuf_feedback_v1 *default_feedback);
	struct wlr_linux_dmabuf_v1 *wlr_linux_dmabuf_v1_create_with_renderer(struct wl_display *display, uint32_t version, struct wlr_renderer *renderer);
	void wlr_linux_dmabuf_v1_set_check_dmabuf_callback(struct wlr_linux_dmabuf_v1 *linux_dmabuf, bool (*callback)(struct wlr_dmabuf_attributes *attribs, void *data), void *data);
	bool wlr_linux_dmabuf_v1_set_surface_feedback(struct wlr_linux_dmabuf_v1 *linux_dmabuf, struct wlr_surface *surface, const struct wlr_linux_dmabuf_feedback_v1 *feedback);
	struct wlr_linux_dmabuf_feedback_v1_tranche *wlr_linux_dmabuf_feedback_add_tranche(struct wlr_linux_dmabuf_feedback_v1 *feedback);
	void wlr_linux_dmabuf_feedback_v1_finish(struct wlr_linux_dmabuf_feedback_v1 *feedback);
	struct wlr_linux_dmabuf_feedback_v1_init_options {
		struct wlr_renderer *main_renderer;
		struct wlr_output *scanout_primary_output;
		const struct wlr_output_layer_feedback_event *output_layer_feedback_event;
	};
	bool wlr_linux_dmabuf_feedback_v1_init_with_options(struct wlr_linux_dmabuf_feedback_v1 *feedback, const struct wlr_linux_dmabuf_feedback_v1_init_options *options);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_linux_drm_syncobj_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_linux_drm_syncobj_surface_v1_state {
		struct wlr_drm_syncobj_timeline *acquire_timeline;
		uint64_t acquire_point;
		struct wlr_drm_syncobj_timeline *release_timeline;
		uint64_t release_point;
	};
	struct wlr_linux_drm_syncobj_manager_v1 {
		struct wl_global *global;
		// private state
		int drm_fd;
		struct wl_listener display_destroy;
	};
	struct wlr_linux_drm_syncobj_manager_v1 *wlr_linux_drm_syncobj_manager_v1_create(struct wl_display *display, uint32_t version, int drm_fd);
	struct wlr_linux_drm_syncobj_surface_v1_state *wlr_linux_drm_syncobj_v1_get_surface_state(struct wlr_surface *surface);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_matrix.h
	/* This is a deprecated interface of wlroots. It will be removed in a future version. */
	struct wlr_box;
	void wlr_matrix_identity(float mat[9]);
	void wlr_matrix_multiply(float mat[9], const float a[9], const float b[9]);
	void wlr_matrix_transpose(float mat[9], const float a[9]);
	void wlr_matrix_translate(float mat[9], float x, float y);
	void wlr_matrix_scale(float mat[9], float x, float y);
	void wlr_matrix_rotate(float mat[9], float rad);
	void wlr_matrix_transform(float mat[9], enum wl_output_transform transform);
	void wlr_matrix_project_box(float mat[9], const struct wlr_box *box, enum wl_output_transform transform, float rotation, const float projection[9]);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_output.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	enum wlr_output_mode_aspect_ratio {
		WLR_OUTPUT_MODE_ASPECT_RATIO_NONE,
		WLR_OUTPUT_MODE_ASPECT_RATIO_4_3,
		WLR_OUTPUT_MODE_ASPECT_RATIO_16_9,
		WLR_OUTPUT_MODE_ASPECT_RATIO_64_27,
		WLR_OUTPUT_MODE_ASPECT_RATIO_256_135,
	};
	struct wlr_output_mode {
		int32_t width, height;
		int32_t refresh; // mHz
		bool preferred;
		enum wlr_output_mode_aspect_ratio picture_aspect_ratio;
		struct wl_list link;
	};
	struct wlr_output_cursor {
		struct wlr_output *output;
		double x, y;
		bool enabled;
		bool visible;
		uint32_t width, height;
		struct wlr_fbox src_box;
		enum wl_output_transform transform;
		int32_t hotspot_x, hotspot_y;
		struct wlr_texture *texture;
		bool own_texture;
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
		uint32_t committed; // enum wlr_output_state_field
		// Set to true to allow output reconfiguration to occur which may result
		// in temporary output disruptions and content misrepresentations.
		bool allow_reconfiguration;
		pixman_region32_t damage; // output-buffer-local coordinates
		bool enabled;
		float scale;
		enum wl_output_transform transform;
		bool adaptive_sync_enabled;
		uint32_t render_format;
		enum wl_output_subpixel subpixel;
		struct wlr_buffer *buffer;
		bool tearing_page_flip;
		enum wlr_output_state_mode_type mode_type;
		struct wlr_output_mode *mode;
		struct {
			int32_t width, height;
			int32_t refresh; // mHz, may be zero
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
		char *description; // may be NULL
		char *make, *model, *serial; // may be NULL
		int32_t phys_width, phys_height; // mm
		// Note: some backends may have zero modes
		struct wl_list modes; // wlr_output_mode.link
		struct wlr_output_mode *current_mode;
		int32_t width, height;
		int32_t refresh; // mHz, may be zero
		bool enabled;
		float scale;
		enum wl_output_subpixel subpixel;
		enum wl_output_transform transform;
		enum wlr_output_adaptive_sync_status adaptive_sync_status;
		uint32_t render_format;
		bool adaptive_sync_supported;
		bool needs_frame;
		bool frame_pending;
		bool non_desktop;
		uint32_t commit_seq;
		struct {
			struct wl_signal frame;
			struct wl_signal damage; // struct wlr_output_event_damage
			struct wl_signal needs_frame;
			struct wl_signal precommit; // struct wlr_output_event_precommit
			struct wl_signal commit; // struct wlr_output_event_commit
			struct wl_signal present; // struct wlr_output_event_present
			struct wl_signal bind; // struct wlr_output_event_bind
			struct wl_signal description;
			struct wl_signal request_state; // struct wlr_output_event_request_state
			struct wl_signal destroy;
		} events;
		struct wl_event_source *idle_frame;
		struct wl_event_source *idle_done;
		int attach_render_locks; // number of locks forcing rendering
		struct wl_list cursors; // wlr_output_cursor.link
		struct wlr_output_cursor *hardware_cursor;
		struct wlr_swapchain *cursor_swapchain;
		struct wlr_buffer *cursor_front_buffer;
		int software_cursor_locks; // number of locks forcing software cursors
		struct wl_list layers; // wlr_output_layer.link
		struct wlr_allocator *allocator;
		struct wlr_renderer *renderer;
		struct wlr_swapchain *swapchain;
		struct wl_listener display_destroy;
		struct wlr_addon_set addons;
		void *data;
	};
	struct wlr_output_event_damage {
		struct wlr_output *output;
		const pixman_region32_t *damage; // output-buffer-local coordinates
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
		bool presented;
		struct timespec *when;
		unsigned seq;
		int refresh; // nsec
		uint32_t flags; // enum wlr_output_present_flag
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
	bool wlr_output_init_render(struct wlr_output *output, struct wlr_allocator *allocator, struct wlr_renderer *renderer);
	struct wlr_output_mode *wlr_output_preferred_mode(struct wlr_output *output);
	void wlr_output_set_name(struct wlr_output *output, const char *name);
	void wlr_output_set_description(struct wlr_output *output, const char *desc);
	void wlr_output_schedule_done(struct wlr_output *output);
	void wlr_output_destroy(struct wlr_output *output);
	void wlr_output_transformed_resolution(struct wlr_output *output, int *width, int *height);
	void wlr_output_effective_resolution(struct wlr_output *output, int *width, int *height);
	bool wlr_output_test_state(struct wlr_output *output, const struct wlr_output_state *state);
	bool wlr_output_commit_state(struct wlr_output *output, const struct wlr_output_state *state);
	void wlr_output_schedule_frame(struct wlr_output *output);
	size_t wlr_output_get_gamma_size(struct wlr_output *output);
	struct wlr_output *wlr_output_from_resource(struct wl_resource *resource);
	void wlr_output_lock_attach_render(struct wlr_output *output, bool lock);
	void wlr_output_lock_software_cursors(struct wlr_output *output, bool lock);
	void wlr_output_add_software_cursors_to_render_pass(struct wlr_output *output, struct wlr_render_pass *render_pass, const pixman_region32_t *damage);
	const struct wlr_drm_format_set *wlr_output_get_primary_formats(struct wlr_output *output, uint32_t buffer_caps);
	bool wlr_output_is_direct_scanout_allowed(struct wlr_output *output);
	struct wlr_output_cursor *wlr_output_cursor_create(struct wlr_output *output);
	bool wlr_output_cursor_set_buffer(struct wlr_output_cursor *cursor, struct wlr_buffer *buffer, int32_t hotspot_x, int32_t hotspot_y);
	bool wlr_output_cursor_move(struct wlr_output_cursor *cursor, double x, double y);
	void wlr_output_cursor_destroy(struct wlr_output_cursor *cursor);
	void wlr_output_state_init(struct wlr_output_state *state);
	void wlr_output_state_finish(struct wlr_output_state *state);
	void wlr_output_state_set_enabled(struct wlr_output_state *state, bool enabled);
	void wlr_output_state_set_mode(struct wlr_output_state *state, struct wlr_output_mode *mode);
	void wlr_output_state_set_custom_mode(struct wlr_output_state *state, int32_t width, int32_t height, int32_t refresh);
	void wlr_output_state_set_scale(struct wlr_output_state *state, float scale);
	void wlr_output_state_set_transform(struct wlr_output_state *state, enum wl_output_transform transform);
	void wlr_output_state_set_adaptive_sync_enabled(struct wlr_output_state *state, bool enabled);
	void wlr_output_state_set_render_format(struct wlr_output_state *state, uint32_t format);
	void wlr_output_state_set_subpixel(struct wlr_output_state *state, enum wl_output_subpixel subpixel);
	void wlr_output_state_set_buffer(struct wlr_output_state *state, struct wlr_buffer *buffer);
	bool wlr_output_state_set_gamma_lut(struct wlr_output_state *state, size_t ramp_size, const uint16_t *r, const uint16_t *g, const uint16_t *b);
	void wlr_output_state_set_damage(struct wlr_output_state *state, const pixman_region32_t *damage);
	void wlr_output_state_set_layers(struct wlr_output_state *state, struct wlr_output_layer_state *layers, size_t layers_len);
	bool wlr_output_state_copy(struct wlr_output_state *dst, const struct wlr_output_state *src);
	bool wlr_output_configure_primary_swapchain(struct wlr_output *output, const struct wlr_output_state *state, struct wlr_swapchain **swapchain);
	struct wlr_render_pass *wlr_output_begin_render_pass(struct wlr_output *output, struct wlr_output_state *state, int *buffer_age, struct wlr_buffer_pass_options *render_options);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_output_layer.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_output_layer {
		struct wl_list link; // wlr_output.layers
		struct wlr_addon_set addons;
		struct {
			struct wl_signal feedback; // struct wlr_output_layer_feedback_event
		} events;
		void *data;
		// private state
		struct wlr_fbox src_box;
		struct wlr_box dst_box;
	};
	struct wlr_output_layer_state {
		struct wlr_output_layer *layer;
		struct wlr_buffer *buffer;
		struct wlr_fbox src_box;
		struct wlr_box dst_box;
		const pixman_region32_t *damage;
		bool accepted;
	};
	struct wlr_output_layer_feedback_event {
		dev_t target_device;
		const struct wlr_drm_format_set *formats;
	};
	struct wlr_output_layer *wlr_output_layer_create(struct wlr_output *output);
	void wlr_output_layer_destroy(struct wlr_output_layer *layer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_output_layout.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_box;
	struct wlr_output_layout {
		struct wl_list outputs;
		struct wl_display *display;
		struct {
			struct wl_signal add; // struct wlr_output_layout_output
			struct wl_signal change;
			struct wl_signal destroy;
		} events;
		void *data;
		// private state
		struct wl_listener display_destroy;
	};
	struct wlr_output_layout_output {
		struct wlr_output_layout *layout;
		struct wlr_output *output;
		int x, y;
		struct wl_list link;
		bool auto_configured;
		struct {
			struct wl_signal destroy;
		} events;
		// private state
		struct wlr_addon addon;
		struct wl_listener commit;
	};
	struct wlr_output_layout *wlr_output_layout_create(struct wl_display *display);
	void wlr_output_layout_destroy(struct wlr_output_layout *layout);
	struct wlr_output_layout_output *wlr_output_layout_get(struct wlr_output_layout *layout, struct wlr_output *reference);
	struct wlr_output *wlr_output_layout_output_at(struct wlr_output_layout *layout, double lx, double ly);
	struct wlr_output_layout_output *wlr_output_layout_add(struct wlr_output_layout *layout, struct wlr_output *output, int lx, int ly);
	struct wlr_output_layout_output *wlr_output_layout_add_auto(struct wlr_output_layout *layout, struct wlr_output *output);
	void wlr_output_layout_remove(struct wlr_output_layout *layout, struct wlr_output *output);
	void wlr_output_layout_output_coords(struct wlr_output_layout *layout, struct wlr_output *reference, double *lx, double *ly);
	bool wlr_output_layout_contains_point(struct wlr_output_layout *layout, struct wlr_output *reference, int lx, int ly);
	bool wlr_output_layout_intersects(struct wlr_output_layout *layout, struct wlr_output *reference, const struct wlr_box *target_lbox);
	void wlr_output_layout_closest_point(struct wlr_output_layout *layout, struct wlr_output *reference, double lx, double ly, double *dest_lx, double *dest_ly);
	void wlr_output_layout_get_box(struct wlr_output_layout *layout, struct wlr_output *reference, struct wlr_box *dest_box);
	struct wlr_output *wlr_output_layout_get_center_output(struct wlr_output_layout *layout);
	enum wlr_direction {
		WLR_DIRECTION_UP = 1 << 0,
		WLR_DIRECTION_DOWN = 1 << 1,
		WLR_DIRECTION_LEFT = 1 << 2,
		WLR_DIRECTION_RIGHT = 1 << 3,
	};
	struct wlr_output *wlr_output_layout_adjacent_output(struct wlr_output_layout *layout, enum wlr_direction direction, struct wlr_output *reference, double ref_lx, double ref_ly);
	struct wlr_output *wlr_output_layout_farthest_output(struct wlr_output_layout *layout, enum wlr_direction direction, struct wlr_output *reference, double ref_lx, double ref_ly);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_output_management_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_output_manager_v1 {
		struct wl_display *display;
		struct wl_global *global;
		struct wl_list resources; // wl_resource_get_link()
		struct wl_list heads; // wlr_output_head_v1.link
		uint32_t serial;
		bool current_configuration_dirty;
		struct {
			struct wl_signal apply; // struct wlr_output_configuration_v1
			struct wl_signal test; // struct wlr_output_configuration_v1
			struct wl_signal destroy;
		} events;
		struct wl_listener display_destroy;
		void *data;
	};
	struct wlr_output_head_v1_state {
		struct wlr_output *output;
		bool enabled;
		struct wlr_output_mode *mode;
		struct {
			int32_t width, height;
			int32_t refresh;
		} custom_mode;
		int32_t x, y;
		enum wl_output_transform transform;
		float scale;
		bool adaptive_sync_enabled;
	};
	struct wlr_output_head_v1 {
		struct wlr_output_head_v1_state state;
		struct wlr_output_manager_v1 *manager;
		struct wl_list link; // wlr_output_manager_v1.heads
		struct wl_list resources; // wl_resource_get_link()
		struct wl_list mode_resources; // wl_resource_get_link()
		struct wl_listener output_destroy;
	};
	struct wlr_output_configuration_v1 {
		struct wl_list heads; // wlr_output_configuration_head_v1.link
		// client state
		struct wlr_output_manager_v1 *manager;
		uint32_t serial;
		bool finalized; // client has requested to apply the config
		bool finished; // feedback has been sent by the compositor
		struct wl_resource *resource; // can be NULL if destroyed early
	};
	struct wlr_output_configuration_head_v1 {
		struct wlr_output_head_v1_state state;
		struct wlr_output_configuration_v1 *config;
		struct wl_list link; // wlr_output_configuration_v1.heads
		// client state
		struct wl_resource *resource; // can be NULL if finalized or disabled
		struct wl_listener output_destroy;
	};
	struct wlr_output_manager_v1 *wlr_output_manager_v1_create(struct wl_display *display);
	void wlr_output_manager_v1_set_configuration(struct wlr_output_manager_v1 *manager, struct wlr_output_configuration_v1 *config);
	struct wlr_output_configuration_v1 *wlr_output_configuration_v1_create(void);
	void wlr_output_configuration_v1_destroy(struct wlr_output_configuration_v1 *config);
	void wlr_output_configuration_v1_send_succeeded(struct wlr_output_configuration_v1 *config);
	void wlr_output_configuration_v1_send_failed(struct wlr_output_configuration_v1 *config);
	struct wlr_output_configuration_head_v1 *wlr_output_configuration_head_v1_create(struct wlr_output_configuration_v1 *config, struct wlr_output *output);
	void wlr_output_head_v1_state_apply(const struct wlr_output_head_v1_state *head_state, struct wlr_output_state *output_state);
	struct wlr_backend_output_state *wlr_output_configuration_v1_build_state(const struct wlr_output_configuration_v1 *config, size_t *states_len);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_output_power_management_v1.h
	struct wlr_output_power_manager_v1 {
		struct wl_global *global;
		struct wl_list output_powers; // wlr_output_power_v1.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal set_mode; // struct wlr_output_power_v1_set_mode_event
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_output_power_v1 {
		struct wl_resource *resource;
		struct wlr_output *output;
		struct wlr_output_power_manager_v1 *manager;
		struct wl_list link; // wlr_output_power_manager_v1.output_powers
		struct wl_listener output_destroy_listener;
		struct wl_listener output_commit_listener;
		void *data;
	};
	struct wlr_output_power_v1_set_mode_event {
		struct wlr_output *output;
		enum zwlr_output_power_v1_mode mode;
	};
	struct wlr_output_power_manager_v1 *wlr_output_power_manager_v1_create(struct wl_display *display);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_output_swapchain_manager.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_backend;
	struct wlr_backend_output_state;
	struct wlr_output_swapchain_manager {
		struct wlr_backend *backend;
		// private state
		struct wl_array outputs; // struct wlr_output_swapchain_manager_output
	};
	void wlr_output_swapchain_manager_init(struct wlr_output_swapchain_manager *manager, struct wlr_backend *backend);
	bool wlr_output_swapchain_manager_prepare(struct wlr_output_swapchain_manager *manager, const struct wlr_backend_output_state *states, size_t states_len);
	struct wlr_swapchain *wlr_output_swapchain_manager_get_swapchain(struct wlr_output_swapchain_manager *manager, struct wlr_output *output);
	void wlr_output_swapchain_manager_apply(struct wlr_output_swapchain_manager *manager);
	void wlr_output_swapchain_manager_finish(struct wlr_output_swapchain_manager *manager);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_pointer.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_pointer_impl;
	struct wlr_pointer {
		struct wlr_input_device base;
		const struct wlr_pointer_impl *impl;
		char *output_name;
		struct {
			struct wl_signal motion; // struct wlr_pointer_motion_event
			struct wl_signal motion_absolute; // struct wlr_pointer_motion_absolute_event
			struct wl_signal button; // struct wlr_pointer_button_event
			struct wl_signal axis; // struct wlr_pointer_axis_event
			struct wl_signal frame;
			struct wl_signal swipe_begin; // struct wlr_pointer_swipe_begin_event
			struct wl_signal swipe_update; // struct wlr_pointer_swipe_update_event
			struct wl_signal swipe_end; // struct wlr_pointer_swipe_end_event
			struct wl_signal pinch_begin; // struct wlr_pointer_pinch_begin_event
			struct wl_signal pinch_update; // struct wlr_pointer_pinch_update_event
			struct wl_signal pinch_end; // struct wlr_pointer_pinch_end_event
			struct wl_signal hold_begin; // struct wlr_pointer_hold_begin_event
			struct wl_signal hold_end; // struct wlr_pointer_hold_end_event
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
		// From 0..1
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
		bool cancelled;
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
		bool cancelled;
	};
	struct wlr_pointer_hold_begin_event {
		struct wlr_pointer *pointer;
		uint32_t time_msec;
		uint32_t fingers;
	};
	struct wlr_pointer_hold_end_event {
		struct wlr_pointer *pointer;
		uint32_t time_msec;
		bool cancelled;
	};
	struct wlr_pointer *wlr_pointer_from_input_device(struct wlr_input_device *input_device);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_pointer_constraints_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		uint32_t committed; // enum wlr_pointer_constraint_v1_state_field
		pixman_region32_t region;
		// only valid for locked_pointer
		struct {
			bool enabled;
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
		struct wl_list link; // wlr_pointer_constraints_v1.constraints
		struct {
			struct wl_signal set_region;
			struct wl_signal destroy;
		} events;
		void *data;
		// private state
		struct wl_listener surface_commit;
		struct wl_listener surface_destroy;
		struct wl_listener seat_destroy;
		struct wlr_surface_synced synced;
	};
	struct wlr_pointer_constraints_v1 {
		struct wl_global *global;
		struct wl_list constraints; // wlr_pointer_constraint_v1.link
		struct {
			struct wl_signal new_constraint;
		} events;
		struct wl_listener display_destroy;
		void *data;
	};
	struct wlr_pointer_constraints_v1 *wlr_pointer_constraints_v1_create(struct wl_display *display);
	struct wlr_pointer_constraint_v1 *wlr_pointer_constraints_v1_constraint_for_surface(struct wlr_pointer_constraints_v1 *pointer_constraints, struct wlr_surface *surface, struct wlr_seat *seat);
	void wlr_pointer_constraint_v1_send_activated(struct wlr_pointer_constraint_v1 *constraint);
	void wlr_pointer_constraint_v1_send_deactivated(struct wlr_pointer_constraint_v1 *constraint);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_pointer_gestures_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_surface;
	struct wlr_pointer_gestures_v1 {
		struct wl_global *global;
		struct wl_list swipes; // wl_resource_get_link()
		struct wl_list pinches; // wl_resource_get_link()
		struct wl_list holds; // wl_resource_get_link()
		struct wl_listener display_destroy;
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_pointer_gestures_v1 *wlr_pointer_gestures_v1_create(struct wl_display *display);
	void wlr_pointer_gestures_v1_send_swipe_begin(struct wlr_pointer_gestures_v1 *gestures, struct wlr_seat *seat, uint32_t time_msec, uint32_t fingers);
	void wlr_pointer_gestures_v1_send_swipe_update(struct wlr_pointer_gestures_v1 *gestures, struct wlr_seat *seat, uint32_t time_msec, double dx, double dy);
	void wlr_pointer_gestures_v1_send_swipe_end(struct wlr_pointer_gestures_v1 *gestures, struct wlr_seat *seat, uint32_t time_msec, bool cancelled);
	void wlr_pointer_gestures_v1_send_pinch_begin(struct wlr_pointer_gestures_v1 *gestures, struct wlr_seat *seat, uint32_t time_msec, uint32_t fingers);
	void wlr_pointer_gestures_v1_send_pinch_update(struct wlr_pointer_gestures_v1 *gestures, struct wlr_seat *seat, uint32_t time_msec, double dx, double dy, double scale, double rotation);
	void wlr_pointer_gestures_v1_send_pinch_end(struct wlr_pointer_gestures_v1 *gestures, struct wlr_seat *seat, uint32_t time_msec, bool cancelled);
	void wlr_pointer_gestures_v1_send_hold_begin(struct wlr_pointer_gestures_v1 *gestures, struct wlr_seat *seat, uint32_t time_msec, uint32_t fingers);
	void wlr_pointer_gestures_v1_send_hold_end(struct wlr_pointer_gestures_v1 *gestures, struct wlr_seat *seat, uint32_t time_msec, bool cancelled);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_presentation_time.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		struct wl_list resources; // wl_resource_get_link()
		// Only when the wlr_presentation_surface_textured_on_output() or
		// wlr_presentation_surface_scanned_out_on_output() helper has been called.
		struct wlr_output *output;
		bool output_committed;
		uint32_t output_commit_seq;
		bool zero_copy;
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
		uint32_t flags; // enum wp_presentation_feedback_kind
	};
	struct wlr_backend;
	struct wlr_presentation *wlr_presentation_create(struct wl_display *display, struct wlr_backend *backend);
	struct wlr_presentation_feedback *wlr_presentation_surface_sampled(struct wlr_surface *surface);
	void wlr_presentation_feedback_send_presented(struct wlr_presentation_feedback *feedback, const struct wlr_presentation_event *event);
	void wlr_presentation_feedback_destroy(struct wlr_presentation_feedback *feedback);
	void wlr_presentation_event_from_output(struct wlr_presentation_event *event, const struct wlr_output_event_present *output_event);
	void wlr_presentation_surface_textured_on_output(struct wlr_surface *surface, struct wlr_output *output);
	void wlr_presentation_surface_scanned_out_on_output(struct wlr_surface *surface, struct wlr_output *output);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_primary_selection.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_primary_selection_source;
	struct wlr_primary_selection_source_impl {
		void (*send)(struct wlr_primary_selection_source *source, const char *mime_type, int fd);
		void (*destroy)(struct wlr_primary_selection_source *source);
	};
	struct wlr_primary_selection_source {
		const struct wlr_primary_selection_source_impl *impl;
		// source metadata
		struct wl_array mime_types;
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
	};
	void wlr_primary_selection_source_init(struct wlr_primary_selection_source *source, const struct wlr_primary_selection_source_impl *impl);
	void wlr_primary_selection_source_destroy(struct wlr_primary_selection_source *source);
	void wlr_primary_selection_source_send(struct wlr_primary_selection_source *source, const char *mime_type, int fd);
	void wlr_seat_request_set_primary_selection(struct wlr_seat *seat, struct wlr_seat_client *client, struct wlr_primary_selection_source *source, uint32_t serial);
	void wlr_seat_set_primary_selection(struct wlr_seat *seat, struct wlr_primary_selection_source *source, uint32_t serial);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_region.h
	/* This is a deprecated interface of wlroots. It will be removed in a future version. wlr/types/wlr_compositor.h should be used instead. */
	struct wl_resource;
	const pixman_region32_t *wlr_region_from_resource(struct wl_resource *resource);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_relative_pointer_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_relative_pointer_manager_v1 {
		struct wl_global *global;
		struct wl_list relative_pointers; // wlr_relative_pointer_v1.link
		struct {
			struct wl_signal destroy;
			struct wl_signal new_relative_pointer; // struct wlr_relative_pointer_v1
		} events;
		struct wl_listener display_destroy_listener;
		void *data;
	};
	struct wlr_relative_pointer_v1 {
		struct wl_resource *resource;
		struct wl_resource *pointer_resource;
		struct wlr_seat *seat;
		struct wl_list link; // wlr_relative_pointer_manager_v1.relative_pointers
		struct {
			struct wl_signal destroy;
		} events;
		struct wl_listener seat_destroy;
		struct wl_listener pointer_destroy;
		void *data;
	};
	struct wlr_relative_pointer_manager_v1 *wlr_relative_pointer_manager_v1_create(struct wl_display *display);
	void wlr_relative_pointer_manager_v1_send_relative_motion(struct wlr_relative_pointer_manager_v1 *manager, struct wlr_seat *seat, uint64_t time_usec, double dx, double dy, double dx_unaccel, double dy_unaccel);
	struct wlr_relative_pointer_v1 *wlr_relative_pointer_v1_from_resource(struct wl_resource *resource);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/pass.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
	bool wlr_render_pass_submit(struct wlr_render_pass *render_pass);
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
	void wlr_render_pass_add_texture(struct wlr_render_pass *render_pass, const struct wlr_render_texture_options *options);
	struct wlr_render_color {
		float r, g, b, a;
	};
	struct wlr_render_rect_options {
		struct wlr_box box;
		struct wlr_render_color color;
		const pixman_region32_t *clip;
		enum wlr_render_blend_mode blend_mode;
	};
	void wlr_render_pass_add_rect(struct wlr_render_pass *render_pass, const struct wlr_render_rect_options *options);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_scene.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
	typedef bool (*wlr_scene_buffer_point_accepts_input_func_t)(struct wlr_scene_buffer *buffer, double *sx, double *sy);
	typedef void (*wlr_scene_buffer_iterator_func_t)(struct wlr_scene_buffer *buffer, int sx, int sy, void *user_data);
	enum wlr_scene_node_type {
		WLR_SCENE_NODE_TREE,
		WLR_SCENE_NODE_RECT,
		WLR_SCENE_NODE_BUFFER,
	};
	struct wlr_scene_node {
		enum wlr_scene_node_type type;
		struct wlr_scene_tree *parent;
		struct wl_list link; // wlr_scene_tree.children
		bool enabled;
		int x, y; // relative to parent
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
		struct wlr_addon_set addons;
		// private state
		pixman_region32_t visible;
	};
	enum wlr_scene_debug_damage_option {
		WLR_SCENE_DEBUG_DAMAGE_NONE,
		WLR_SCENE_DEBUG_DAMAGE_RERENDER,
		WLR_SCENE_DEBUG_DAMAGE_HIGHLIGHT
	};
	struct wlr_scene_tree {
		struct wlr_scene_node node;
		struct wl_list children; // wlr_scene_node.link
	};
	struct wlr_scene {
		struct wlr_scene_tree tree;
		struct wl_list outputs; // wlr_scene_output.link
		// May be NULL
		struct wlr_linux_dmabuf_v1 *linux_dmabuf_v1;
		// private state
		struct wl_listener linux_dmabuf_v1_destroy;
		enum wlr_scene_debug_damage_option debug_damage_option;
		bool direct_scanout;
		bool calculate_visibility;
		bool highlight_transparent_region;
	};
	struct wlr_scene_surface {
		struct wlr_scene_buffer *buffer;
		struct wlr_surface *surface;
		// private state
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
		bool direct_scanout;
	};
	struct wlr_scene_buffer {
		struct wlr_scene_node node;
		// May be NULL
		struct wlr_buffer *buffer;
		struct {
			struct wl_signal outputs_update; // struct wlr_scene_outputs_update_event
			struct wl_signal output_enter; // struct wlr_scene_output
			struct wl_signal output_leave; // struct wlr_scene_output
			struct wl_signal output_sample; // struct wlr_scene_output_sample_event
			struct wl_signal frame_done; // struct timespec
		} events;
		// May be NULL
		wlr_scene_buffer_point_accepts_input_func_t point_accepts_input;
		struct wlr_scene_output *primary_output;
		float opacity;
		enum wlr_scale_filter_mode filter_mode;
		struct wlr_fbox src_box;
		int dst_width, dst_height;
		enum wl_output_transform transform;
		pixman_region32_t opaque_region;
		// private state
		uint64_t active_outputs;
		struct wlr_texture *texture;
		struct wlr_linux_dmabuf_feedback_v1_init_options prev_feedback_options;
		bool own_buffer;
		int buffer_width, buffer_height;
		bool buffer_is_opaque;
		struct wl_listener buffer_release;
		struct wl_listener renderer_destroy;
	};
	struct wlr_scene_output {
		struct wlr_output *output;
		struct wl_list link; // wlr_scene.outputs
		struct wlr_scene *scene;
		struct wlr_addon addon;
		struct wlr_damage_ring damage_ring;
		int x, y;
		struct {
			struct wl_signal destroy;
		} events;
		// private state
		pixman_region32_t pending_commit_damage;
		uint8_t index;
		bool prev_scanout;
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
		// private state
		struct wl_listener tree_destroy;
		struct wl_listener layer_surface_destroy;
		struct wl_listener layer_surface_map;
		struct wl_listener layer_surface_unmap;
	};
	void wlr_scene_node_destroy(struct wlr_scene_node *node);
	void wlr_scene_node_set_enabled(struct wlr_scene_node *node, bool enabled);
	void wlr_scene_node_set_position(struct wlr_scene_node *node, int x, int y);
	void wlr_scene_node_place_above(struct wlr_scene_node *node, struct wlr_scene_node *sibling);
	void wlr_scene_node_place_below(struct wlr_scene_node *node, struct wlr_scene_node *sibling);
	void wlr_scene_node_raise_to_top(struct wlr_scene_node *node);
	void wlr_scene_node_lower_to_bottom(struct wlr_scene_node *node);
	void wlr_scene_node_reparent(struct wlr_scene_node *node, struct wlr_scene_tree *new_parent);
	bool wlr_scene_node_coords(struct wlr_scene_node *node, int *lx, int *ly);
	void wlr_scene_node_for_each_buffer(struct wlr_scene_node *node, wlr_scene_buffer_iterator_func_t iterator, void *user_data);
	struct wlr_scene_node *wlr_scene_node_at(struct wlr_scene_node *node, double lx, double ly, double *nx, double *ny);
	struct wlr_scene *wlr_scene_create(void);
	void wlr_scene_set_linux_dmabuf_v1(struct wlr_scene *scene, struct wlr_linux_dmabuf_v1 *linux_dmabuf_v1);
	struct wlr_scene_tree *wlr_scene_tree_create(struct wlr_scene_tree *parent);
	struct wlr_scene_surface *wlr_scene_surface_create(struct wlr_scene_tree *parent, struct wlr_surface *surface);
	struct wlr_scene_buffer *wlr_scene_buffer_from_node(struct wlr_scene_node *node);
	struct wlr_scene_tree *wlr_scene_tree_from_node(struct wlr_scene_node *node);
	struct wlr_scene_rect *wlr_scene_rect_from_node(struct wlr_scene_node *node);
	struct wlr_scene_surface *wlr_scene_surface_try_from_buffer(struct wlr_scene_buffer *scene_buffer);
	struct wlr_scene_rect *wlr_scene_rect_create(struct wlr_scene_tree *parent, int width, int height, const float color[4]);
	void wlr_scene_rect_set_size(struct wlr_scene_rect *rect, int width, int height);
	void wlr_scene_rect_set_color(struct wlr_scene_rect *rect, const float color[4]);
	struct wlr_scene_buffer *wlr_scene_buffer_create(struct wlr_scene_tree *parent, struct wlr_buffer *buffer);
	void wlr_scene_buffer_set_buffer(struct wlr_scene_buffer *scene_buffer, struct wlr_buffer *buffer);
	void wlr_scene_buffer_set_buffer_with_damage(struct wlr_scene_buffer *scene_buffer, struct wlr_buffer *buffer, const pixman_region32_t *region);
	void wlr_scene_buffer_set_opaque_region(struct wlr_scene_buffer *scene_buffer, const pixman_region32_t *region);
	void wlr_scene_buffer_set_source_box(struct wlr_scene_buffer *scene_buffer, const struct wlr_fbox *box);
	void wlr_scene_buffer_set_dest_size(struct wlr_scene_buffer *scene_buffer, int width, int height);
	void wlr_scene_buffer_set_transform(struct wlr_scene_buffer *scene_buffer, enum wl_output_transform transform);
	void wlr_scene_buffer_set_opacity(struct wlr_scene_buffer *scene_buffer, float opacity);
	void wlr_scene_buffer_set_filter_mode(struct wlr_scene_buffer *scene_buffer, enum wlr_scale_filter_mode filter_mode);
	void wlr_scene_buffer_send_frame_done(struct wlr_scene_buffer *scene_buffer, struct timespec *now);
	struct wlr_scene_output *wlr_scene_output_create(struct wlr_scene *scene, struct wlr_output *output);
	void wlr_scene_output_destroy(struct wlr_scene_output *scene_output);
	void wlr_scene_output_set_position(struct wlr_scene_output *scene_output, int lx, int ly);
	struct wlr_scene_output_state_options {
		struct wlr_scene_timer *timer;
		struct wlr_color_transform *color_transform;
		struct wlr_swapchain *swapchain;
	};
	bool wlr_scene_output_commit(struct wlr_scene_output *scene_output, const struct wlr_scene_output_state_options *options);
	bool wlr_scene_output_build_state(struct wlr_scene_output *scene_output, struct wlr_output_state *state, const struct wlr_scene_output_state_options *options);
	int64_t wlr_scene_timer_get_duration_ns(struct wlr_scene_timer *timer);
	void wlr_scene_timer_finish(struct wlr_scene_timer *timer);
	void wlr_scene_output_send_frame_done(struct wlr_scene_output *scene_output, struct timespec *now);
	void wlr_scene_output_for_each_buffer(struct wlr_scene_output *scene_output, wlr_scene_buffer_iterator_func_t iterator, void *user_data);
	struct wlr_scene_output *wlr_scene_get_scene_output(struct wlr_scene *scene, struct wlr_output *output);
	struct wlr_scene_output_layout *wlr_scene_attach_output_layout(struct wlr_scene *scene, struct wlr_output_layout *output_layout);
	void wlr_scene_output_layout_add_output(struct wlr_scene_output_layout *sol, struct wlr_output_layout_output *lo, struct wlr_scene_output *so);
	struct wlr_scene_tree *wlr_scene_subsurface_tree_create(struct wlr_scene_tree *parent, struct wlr_surface *surface);
	void wlr_scene_subsurface_tree_set_clip(struct wlr_scene_node *node, const struct wlr_box *clip);
	struct wlr_scene_tree *wlr_scene_xdg_surface_create(struct wlr_scene_tree *parent, struct wlr_xdg_surface *xdg_surface);
	struct wlr_scene_layer_surface_v1 *wlr_scene_layer_surface_v1_create(struct wlr_scene_tree *parent, struct wlr_layer_surface_v1 *layer_surface);
	void wlr_scene_layer_surface_v1_configure(struct wlr_scene_layer_surface_v1 *scene_layer_surface, const struct wlr_box *full_area, struct wlr_box *usable_area);
	struct wlr_scene_tree *wlr_scene_drag_icon_create(struct wlr_scene_tree *parent, struct wlr_drag_icon *drag_icon);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_screencopy_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_screencopy_manager_v1 {
		struct wl_global *global;
		struct wl_list frames; // wlr_screencopy_frame_v1.link
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
		struct wl_list link; // wlr_screencopy_manager_v1.frames
		uint32_t shm_format, dmabuf_format; // DRM format codes
		struct wlr_box box;
		int shm_stride;
		bool overlay_cursor, cursor_locked;
		bool with_damage;
		enum wlr_buffer_cap buffer_cap;
		struct wlr_buffer *buffer;
		struct wlr_output *output;
		struct wl_listener output_commit;
		struct wl_listener output_destroy;
		struct wl_listener output_enable;
		void *data;
	};
	struct wlr_screencopy_manager_v1 *wlr_screencopy_manager_v1_create(struct wl_display *display);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_security_context_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_security_context_manager_v1 {
		struct wl_global *global;
		struct {
			struct wl_signal destroy;
			struct wl_signal commit; // struct wlr_security_context_v1_commit_event
		} events;
		void *data;
		// private state
		struct wl_list contexts; // wlr_security_context_v1.link
		struct wl_listener display_destroy;
	};
	struct wlr_security_context_v1_state {
		char *sandbox_engine; // may be NULL
		char *app_id; // may be NULL
		char *instance_id; // may be NULL
	};
	struct wlr_security_context_v1_commit_event {
		const struct wlr_security_context_v1_state *state;
		struct wl_client *parent_client;
	};
	struct wlr_security_context_manager_v1 *wlr_security_context_manager_v1_create(struct wl_display *display);
	const struct wlr_security_context_v1_state *wlr_security_context_manager_v1_lookup_client(struct wlr_security_context_manager_v1 *manager, const struct wl_client *client);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_server_decoration.h
	/* This protocol is obsolete and will be removed in a future version. The recommended replacement is xdg-decoration. */
	enum wlr_server_decoration_manager_mode {
		WLR_SERVER_DECORATION_MANAGER_MODE_NONE = 0,
		WLR_SERVER_DECORATION_MANAGER_MODE_CLIENT = 1,
		WLR_SERVER_DECORATION_MANAGER_MODE_SERVER = 2,
	};
	struct wlr_server_decoration_manager {
		struct wl_global *global;
		struct wl_list resources; // wl_resource_get_link()
		struct wl_list decorations; // wlr_server_decoration.link
		uint32_t default_mode; // enum wlr_server_decoration_manager_mode
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
		uint32_t mode; // enum wlr_server_decoration_manager_mode
		struct {
			struct wl_signal destroy;
			struct wl_signal mode;
		} events;
		struct wl_listener surface_destroy_listener;
		void *data;
	};
	struct wlr_server_decoration_manager *wlr_server_decoration_manager_create(struct wl_display *display);
	void wlr_server_decoration_manager_set_default_mode(struct wlr_server_decoration_manager *manager, uint32_t default_mode);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_session_lock_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_session_lock_manager_v1 {
		struct wl_global *global;
		struct {
			struct wl_signal new_lock; // struct wlr_session_lock_v1
			struct wl_signal destroy;
		} events;
		void *data;
		// private state
		struct wl_listener display_destroy;
	};
	struct wlr_session_lock_v1 {
		struct wl_resource *resource;
		struct wl_list surfaces; // struct wlr_session_lock_surface_v1.link
		struct {
			struct wl_signal new_surface; // struct wlr_session_lock_surface_v1
			struct wl_signal unlock;
			struct wl_signal destroy;
		} events;
		void *data;
		// private state
		bool locked_sent;
	};
	struct wlr_session_lock_surface_v1_state {
		uint32_t width, height;
		uint32_t configure_serial;
	};
	struct wlr_session_lock_surface_v1_configure {
		struct wl_list link; // wlr_session_lock_surface_v1.configure_list
		uint32_t serial;
		uint32_t width, height;
	};
	struct wlr_session_lock_surface_v1 {
		struct wl_resource *resource;
		struct wl_list link; // wlr_session_lock_v1.surfaces
		struct wlr_output *output;
		struct wlr_surface *surface;
		bool configured;
		struct wl_list configure_list; // wlr_session_lock_surface_v1_configure.link
		struct wlr_session_lock_surface_v1_state current;
		struct wlr_session_lock_surface_v1_state pending;
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
		// private state
		struct wlr_surface_synced synced;
		struct wl_listener output_destroy;
	};
	struct wlr_session_lock_manager_v1 *wlr_session_lock_manager_v1_create(struct wl_display *display);
	void wlr_session_lock_v1_send_locked(struct wlr_session_lock_v1 *lock);
	void wlr_session_lock_v1_destroy(struct wlr_session_lock_v1 *lock);
	uint32_t wlr_session_lock_surface_v1_configure(struct wlr_session_lock_surface_v1 *lock_surface, uint32_t width, uint32_t height);
	struct wlr_session_lock_surface_v1 *wlr_session_lock_surface_v1_try_from_wlr_surface(struct wlr_surface *surface);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_shm.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_renderer;
	struct wlr_shm {
		struct wl_global *global;
		// private state
		uint32_t *formats;
		size_t formats_len;
		struct wl_listener display_destroy;
	};
	struct wlr_shm *wlr_shm_create(struct wl_display *display, uint32_t version, const uint32_t *formats, size_t formats_len);
	struct wlr_shm *wlr_shm_create_with_renderer(struct wl_display *display, uint32_t version, struct wlr_renderer *renderer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_single_pixel_buffer_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_single_pixel_buffer_manager_v1 {
		struct wl_global *global;
		// private state
		struct wl_listener display_destroy;
	};
	struct wlr_single_pixel_buffer_manager_v1 *wlr_single_pixel_buffer_manager_v1_create(struct wl_display *display);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_subcompositor.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_subsurface_parent_state {
		int32_t x, y;
		struct wl_list link;
		// private state
		struct wlr_surface_synced *synced;
	};
	struct wlr_subsurface {
		struct wl_resource *resource;
		struct wlr_surface *surface;
		struct wlr_surface *parent;
		struct wlr_subsurface_parent_state current, pending;
		uint32_t cached_seq;
		bool has_cache;
		bool synchronized;
		bool added;
		struct wl_listener surface_client_commit;
		struct wl_listener parent_destroy;
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
		// private state
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
	struct wlr_subsurface *wlr_subsurface_try_from_wlr_surface(struct wlr_surface *surface);
	struct wlr_subcompositor *wlr_subcompositor_create(struct wl_display *display);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_switch.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_switch_impl;
	struct wlr_switch {
		struct wlr_input_device base;
		const struct wlr_switch_impl *impl;
		struct {
			struct wl_signal toggle; // struct wlr_switch_toggle_event
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
	struct wlr_switch *wlr_switch_from_input_device(struct wlr_input_device *input_device);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_tablet_pad.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_tablet_pad_impl;
	struct wlr_tablet_pad {
		struct wlr_input_device base;
		const struct wlr_tablet_pad_impl *impl;
		struct {
			struct wl_signal button;
			struct wl_signal ring;
			struct wl_signal strip;
			struct wl_signal attach_tablet; // struct wlr_tablet_tool
		} events;
		size_t button_count;
		size_t ring_count;
		size_t strip_count;
		struct wl_list groups; // wlr_tablet_pad_group.link
		struct wl_array paths; // char *
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
	struct wlr_tablet_pad *wlr_tablet_pad_from_input_device(struct wlr_input_device *);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_tablet_tool.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		// Capabilities
		bool tilt;
		bool pressure;
		bool distance;
		bool rotation;
		bool slider;
		bool wheel;
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_tablet_impl;
	struct wlr_tablet {
		struct wlr_input_device base;
		const struct wlr_tablet_impl *impl;
		uint16_t usb_vendor_id, usb_product_id; // zero if unset
		double width_mm, height_mm;
		struct {
			struct wl_signal axis; // struct wlr_tablet_tool_axis_event
			struct wl_signal proximity; // struct wlr_tablet_tool_proximity_event
			struct wl_signal tip; // struct wlr_tablet_tool_tip_event
			struct wl_signal button; // struct wlr_tablet_tool_button_event
		} events;
		struct wl_array paths; // char *
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
		// From 0..1
		double x, y;
		// Relative to last event
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
		// From 0..1
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
		// From 0..1
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
	struct wlr_tablet *wlr_tablet_from_input_device(struct wlr_input_device *input_device);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_tablet_v2.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		struct wl_list clients; // wlr_tablet_manager_client_v2.link
		struct wl_list seats; // wlr_tablet_seat_v2.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_tablet_v2_tablet {
		struct wl_list link; // wlr_tablet_seat_v2.tablets
		struct wlr_tablet *wlr_tablet;
		struct wlr_input_device *wlr_device;
		struct wl_list clients; // wlr_tablet_client_v2.tablet_link
		struct wl_listener tablet_destroy;
		struct wlr_tablet_client_v2 *current_client;
	};
	struct wlr_tablet_v2_tablet_tool {
		struct wl_list link; // wlr_tablet_seat_v2.tablets
		struct wlr_tablet_tool *wlr_tool;
		struct wl_list clients; // wlr_tablet_tool_client_v2.tool_link
		struct wl_listener tool_destroy;
		struct wlr_tablet_tool_client_v2 *current_client;
		struct wlr_surface *focused_surface;
		struct wl_listener surface_destroy;
		struct wlr_tablet_tool_v2_grab *grab;
		struct wlr_tablet_tool_v2_grab default_grab;
		uint32_t proximity_serial;
		bool is_down;
		uint32_t down_serial;
		size_t num_buttons;
		uint32_t pressed_buttons[16 /* WLR_TABLET_V2_TOOL_BUTTONS_CAP */];
		uint32_t pressed_serials[16 /* WLR_TABLET_V2_TOOL_BUTTONS_CAP */];
		struct {
			struct wl_signal set_cursor; // struct wlr_tablet_v2_event_cursor
		} events;
	};
	struct wlr_tablet_v2_tablet_pad {
		struct wl_list link; // wlr_tablet_seat_v2.pads
		struct wlr_tablet_pad *wlr_pad;
		struct wlr_input_device *wlr_device;
		struct wl_list clients; // wlr_tablet_pad_client_v2.pad_link
		size_t group_count;
		uint32_t *groups;
		struct wl_listener pad_destroy;
		struct wlr_tablet_pad_client_v2 *current_client;
		struct wlr_tablet_pad_v2_grab *grab;
		struct wlr_tablet_pad_v2_grab default_grab;
		struct {
			struct wl_signal button_feedback; // struct wlr_tablet_v2_event_feedback
			struct wl_signal strip_feedback; // struct wlr_tablet_v2_event_feedback
			struct wl_signal ring_feedback; // struct wlr_tablet_v2_event_feedback
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
	struct wlr_tablet_v2_tablet *wlr_tablet_create(struct wlr_tablet_manager_v2 *manager, struct wlr_seat *wlr_seat, struct wlr_input_device *wlr_device);
	struct wlr_tablet_v2_tablet_pad *wlr_tablet_pad_create(struct wlr_tablet_manager_v2 *manager, struct wlr_seat *wlr_seat, struct wlr_input_device *wlr_device);
	struct wlr_tablet_v2_tablet_tool *wlr_tablet_tool_create(struct wlr_tablet_manager_v2 *manager, struct wlr_seat *wlr_seat, struct wlr_tablet_tool *wlr_tool);
	struct wlr_tablet_manager_v2 *wlr_tablet_v2_create(struct wl_display *display);
	void wlr_send_tablet_v2_tablet_tool_proximity_in(struct wlr_tablet_v2_tablet_tool *tool, struct wlr_tablet_v2_tablet *tablet, struct wlr_surface *surface);
	void wlr_send_tablet_v2_tablet_tool_down(struct wlr_tablet_v2_tablet_tool *tool);
	void wlr_send_tablet_v2_tablet_tool_up(struct wlr_tablet_v2_tablet_tool *tool);
	void wlr_send_tablet_v2_tablet_tool_motion(struct wlr_tablet_v2_tablet_tool *tool, double x, double y);
	void wlr_send_tablet_v2_tablet_tool_pressure(struct wlr_tablet_v2_tablet_tool *tool, double pressure);
	void wlr_send_tablet_v2_tablet_tool_distance(struct wlr_tablet_v2_tablet_tool *tool, double distance);
	void wlr_send_tablet_v2_tablet_tool_tilt(struct wlr_tablet_v2_tablet_tool *tool, double x, double y);
	void wlr_send_tablet_v2_tablet_tool_rotation(struct wlr_tablet_v2_tablet_tool *tool, double degrees);
	void wlr_send_tablet_v2_tablet_tool_slider(struct wlr_tablet_v2_tablet_tool *tool, double position);
	void wlr_send_tablet_v2_tablet_tool_wheel(struct wlr_tablet_v2_tablet_tool *tool, double degrees, int32_t clicks);
	void wlr_send_tablet_v2_tablet_tool_proximity_out(struct wlr_tablet_v2_tablet_tool *tool);
	void wlr_send_tablet_v2_tablet_tool_button(struct wlr_tablet_v2_tablet_tool *tool, uint32_t button, enum zwp_tablet_pad_v2_button_state state);
	void wlr_tablet_v2_tablet_tool_notify_proximity_in(struct wlr_tablet_v2_tablet_tool *tool, struct wlr_tablet_v2_tablet *tablet, struct wlr_surface *surface);
	void wlr_tablet_v2_tablet_tool_notify_down(struct wlr_tablet_v2_tablet_tool *tool);
	void wlr_tablet_v2_tablet_tool_notify_up(struct wlr_tablet_v2_tablet_tool *tool);
	void wlr_tablet_v2_tablet_tool_notify_motion(struct wlr_tablet_v2_tablet_tool *tool, double x, double y);
	void wlr_tablet_v2_tablet_tool_notify_pressure(struct wlr_tablet_v2_tablet_tool *tool, double pressure);
	void wlr_tablet_v2_tablet_tool_notify_distance(struct wlr_tablet_v2_tablet_tool *tool, double distance);
	void wlr_tablet_v2_tablet_tool_notify_tilt(struct wlr_tablet_v2_tablet_tool *tool, double x, double y);
	void wlr_tablet_v2_tablet_tool_notify_rotation(struct wlr_tablet_v2_tablet_tool *tool, double degrees);
	void wlr_tablet_v2_tablet_tool_notify_slider(struct wlr_tablet_v2_tablet_tool *tool, double position);
	void wlr_tablet_v2_tablet_tool_notify_wheel(struct wlr_tablet_v2_tablet_tool *tool, double degrees, int32_t clicks);
	void wlr_tablet_v2_tablet_tool_notify_proximity_out(struct wlr_tablet_v2_tablet_tool *tool);
	void wlr_tablet_v2_tablet_tool_notify_button(struct wlr_tablet_v2_tablet_tool *tool, uint32_t button, enum zwp_tablet_pad_v2_button_state state);
	struct wlr_tablet_tool_v2_grab_interface {
		void (*proximity_in)(struct wlr_tablet_tool_v2_grab *grab, struct wlr_tablet_v2_tablet *tablet, struct wlr_surface *surface);
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
		void (*button)(struct wlr_tablet_tool_v2_grab *grab, uint32_t button, enum zwp_tablet_pad_v2_button_state state);
		void (*cancel)(struct wlr_tablet_tool_v2_grab *grab);
	};
	void wlr_tablet_tool_v2_start_grab(struct wlr_tablet_v2_tablet_tool *tool, struct wlr_tablet_tool_v2_grab *grab);
	void wlr_tablet_tool_v2_end_grab(struct wlr_tablet_v2_tablet_tool *tool);
	void wlr_tablet_tool_v2_start_implicit_grab(struct wlr_tablet_v2_tablet_tool *tool);
	bool wlr_tablet_tool_v2_has_implicit_grab(struct wlr_tablet_v2_tablet_tool *tool);
	uint32_t wlr_send_tablet_v2_tablet_pad_enter(struct wlr_tablet_v2_tablet_pad *pad, struct wlr_tablet_v2_tablet *tablet, struct wlr_surface *surface);
	void wlr_send_tablet_v2_tablet_pad_button(struct wlr_tablet_v2_tablet_pad *pad, size_t button, uint32_t time, enum zwp_tablet_pad_v2_button_state state);
	void wlr_send_tablet_v2_tablet_pad_strip(struct wlr_tablet_v2_tablet_pad *pad, uint32_t strip, double position, bool finger, uint32_t time);
	void wlr_send_tablet_v2_tablet_pad_ring(struct wlr_tablet_v2_tablet_pad *pad, uint32_t ring, double position, bool finger, uint32_t time);
	uint32_t wlr_send_tablet_v2_tablet_pad_leave(struct wlr_tablet_v2_tablet_pad *pad, struct wlr_surface *surface);
	uint32_t wlr_send_tablet_v2_tablet_pad_mode(struct wlr_tablet_v2_tablet_pad *pad, size_t group, uint32_t mode, uint32_t time);
	uint32_t wlr_tablet_v2_tablet_pad_notify_enter(struct wlr_tablet_v2_tablet_pad *pad, struct wlr_tablet_v2_tablet *tablet, struct wlr_surface *surface);
	void wlr_tablet_v2_tablet_pad_notify_button(struct wlr_tablet_v2_tablet_pad *pad, size_t button, uint32_t time, enum zwp_tablet_pad_v2_button_state state);
	void wlr_tablet_v2_tablet_pad_notify_strip(struct wlr_tablet_v2_tablet_pad *pad, uint32_t strip, double position, bool finger, uint32_t time);
	void wlr_tablet_v2_tablet_pad_notify_ring(struct wlr_tablet_v2_tablet_pad *pad, uint32_t ring, double position, bool finger, uint32_t time);
	uint32_t wlr_tablet_v2_tablet_pad_notify_leave(struct wlr_tablet_v2_tablet_pad *pad, struct wlr_surface *surface);
	uint32_t wlr_tablet_v2_tablet_pad_notify_mode(struct wlr_tablet_v2_tablet_pad *pad, size_t group, uint32_t mode, uint32_t time);
	struct wlr_tablet_pad_v2_grab_interface {
		uint32_t (*enter)(struct wlr_tablet_pad_v2_grab *grab, struct wlr_tablet_v2_tablet *tablet, struct wlr_surface *surface);
		void (*button)(struct wlr_tablet_pad_v2_grab *grab,size_t button, uint32_t time, enum zwp_tablet_pad_v2_button_state state);
		void (*strip)(struct wlr_tablet_pad_v2_grab *grab, uint32_t strip, double position, bool finger, uint32_t time);
		void (*ring)(struct wlr_tablet_pad_v2_grab *grab, uint32_t ring, double position, bool finger, uint32_t time);
		uint32_t (*leave)(struct wlr_tablet_pad_v2_grab *grab, struct wlr_surface *surface);
		uint32_t (*mode)(struct wlr_tablet_pad_v2_grab *grab, size_t group, uint32_t mode, uint32_t time);
		void (*cancel)(struct wlr_tablet_pad_v2_grab *grab);
	};
	void wlr_tablet_v2_end_grab(struct wlr_tablet_v2_tablet_pad *pad);
	void wlr_tablet_v2_start_grab(struct wlr_tablet_v2_tablet_pad *pad, struct wlr_tablet_pad_v2_grab *grab);
	bool wlr_surface_accepts_tablet_v2(struct wlr_surface *surface, struct wlr_tablet_v2_tablet *tablet);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_tearing_control_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
		// private state
		enum wp_tearing_control_v1_presentation_hint previous;
		struct wlr_addon addon;
		struct wlr_surface_synced synced;
		struct wl_listener surface_commit;
	};
	struct wlr_tearing_control_manager_v1 {
		struct wl_global *global;
		struct wl_list surface_hints;  // wlr_tearing_control_v1.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal new_object;  // struct wlr_tearing_control_v1*
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_tearing_control_manager_v1 *wlr_tearing_control_manager_v1_create(struct wl_display *display, uint32_t version);
	enum wp_tearing_control_v1_presentation_hint wlr_tearing_control_manager_v1_surface_hint_from_surface(struct wlr_tearing_control_manager_v1 *manager, struct wlr_surface *surface);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_text_input_v3.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_surface;
	enum wlr_text_input_v3_features {
		WLR_TEXT_INPUT_V3_FEATURE_SURROUNDING_TEXT = 1 << 0,
		WLR_TEXT_INPUT_V3_FEATURE_CONTENT_TYPE = 1 << 1,
		WLR_TEXT_INPUT_V3_FEATURE_CURSOR_RECTANGLE = 1 << 2,
	};
	struct wlr_text_input_v3_state {
		struct {
			char *text; // NULL is allowed and equivalent to empty string
			uint32_t cursor;
			uint32_t anchor;
		} surrounding;
		uint32_t text_change_cause;
		struct {
			uint32_t hint;
			uint32_t purpose;
		} content_type;
		struct wlr_box cursor_rectangle;
		uint32_t features; // bitfield of enum wlr_text_input_v3_features
	};
	struct wlr_text_input_v3 {
		struct wlr_seat *seat; // becomes null when seat destroyed
		struct wl_resource *resource;
		struct wlr_surface *focused_surface;
		struct wlr_text_input_v3_state pending;
		struct wlr_text_input_v3_state current;
		uint32_t current_serial; // next in line to send
		bool pending_enabled;
		bool current_enabled;
		// supported in the current text input, more granular than surface
		uint32_t active_features; // bitfield of enum wlr_text_input_v3_features
		struct wl_list link;
		struct wl_listener surface_destroy;
		struct wl_listener seat_destroy;
		struct {
			struct wl_signal enable; // struct wlr_text_input_v3
			struct wl_signal commit; // struct wlr_text_input_v3
			struct wl_signal disable; // struct wlr_text_input_v3
			struct wl_signal destroy; // struct wlr_text_input_v3
		} events;
	};
	struct wlr_text_input_manager_v3 {
		struct wl_global *global;
		struct wl_list text_inputs; // struct wlr_text_input_v3.resource.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal text_input; // struct wlr_text_input_v3
			struct wl_signal destroy; // struct wlr_input_method_manager_v3
		} events;
	};
	struct wlr_text_input_manager_v3 *wlr_text_input_manager_v3_create(struct wl_display *wl_display);
	// Sends enter to the surface and saves it
	void wlr_text_input_v3_send_enter(struct wlr_text_input_v3 *text_input,
		struct wlr_surface *wlr_surface);
	// Sends leave to the currently focused surface and clears it
	void wlr_text_input_v3_send_leave(struct wlr_text_input_v3 *text_input);
	void wlr_text_input_v3_send_preedit_string(struct wlr_text_input_v3 *text_input, const char *text, int32_t cursor_begin, int32_t cursor_end);
	void wlr_text_input_v3_send_commit_string(struct wlr_text_input_v3 *text_input, const char *text);
	void wlr_text_input_v3_send_delete_surrounding_text(struct wlr_text_input_v3 *text_input, uint32_t before_length, uint32_t after_length);
	void wlr_text_input_v3_send_done(struct wlr_text_input_v3 *text_input);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_touch.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_touch_impl;
	struct wlr_touch {
		struct wlr_input_device base;
		const struct wlr_touch_impl *impl;
		char *output_name;
		double width_mm, height_mm;
		struct {
			struct wl_signal down; // struct wlr_touch_down_event
			struct wl_signal up; // struct wlr_touch_up_event
			struct wl_signal motion; // struct wlr_touch_motion_event
			struct wl_signal cancel; // struct wlr_touch_cancel_event
			struct wl_signal frame;
		} events;
		void *data;
	};
	struct wlr_touch_down_event {
		struct wlr_touch *touch;
		uint32_t time_msec;
		int32_t touch_id;
		// From 0..1
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
		// From 0..1
		double x, y;
	};
	struct wlr_touch_cancel_event {
		struct wlr_touch *touch;
		uint32_t time_msec;
		int32_t touch_id;
	};
	struct wlr_touch *wlr_touch_from_input_device(struct wlr_input_device *input_device);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_transient_seat_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_seat;
	struct wlr_transient_seat_v1 {
		struct wl_resource *resource;
		struct wlr_seat *seat;
		// private state
		struct wl_listener seat_destroy;
	};
	struct wlr_transient_seat_manager_v1 {
		struct wl_global *global;
		struct wl_listener display_destroy;
		struct {
			struct wl_signal create_seat; // struct wlr_transient_seat_v1
		} events;
	};
	struct wlr_transient_seat_manager_v1 *wlr_transient_seat_manager_v1_create(struct wl_display *display);
	void wlr_transient_seat_v1_ready(struct wlr_transient_seat_v1 *seat, struct wlr_seat *wlr_seat);
	void wlr_transient_seat_v1_deny(struct wlr_transient_seat_v1 *seat);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_viewporter.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_viewporter {
		struct wl_global *global;
		struct {
			struct wl_signal destroy;
		} events;
		struct wl_listener display_destroy;
	};
	struct wlr_viewporter *wlr_viewporter_create(struct wl_display *display);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_virtual_keyboard_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_virtual_keyboard_manager_v1 {
		struct wl_global *global;
		struct wl_list virtual_keyboards; // wlr_virtual_keyboard_v1.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal new_virtual_keyboard; // struct wlr_virtual_keyboard_v1
			struct wl_signal destroy;
		} events;
	};
	struct wlr_virtual_keyboard_v1 {
		struct wlr_keyboard keyboard;
		struct wl_resource *resource;
		struct wlr_seat *seat;
		bool has_keymap;
		struct wl_list link; // wlr_virtual_keyboard_manager_v1.virtual_keyboards
	};
	struct wlr_virtual_keyboard_manager_v1* wlr_virtual_keyboard_manager_v1_create(struct wl_display *display);
	struct wlr_virtual_keyboard_v1 *wlr_input_device_get_virtual_keyboard(struct wlr_input_device *wlr_dev);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_virtual_pointer_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_virtual_pointer_manager_v1 {
		struct wl_global *global;
		struct wl_list virtual_pointers; // wlr_virtual_pointer_v1.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal new_virtual_pointer; // struct wlr_virtual_pointer_v1_new_pointer_event
			struct wl_signal destroy;
		} events;
	};
	struct wlr_virtual_pointer_v1 {
		struct wlr_pointer pointer;
		struct wl_resource *resource;
		// Vertical and horizontal
		struct wlr_pointer_axis_event axis_event[2];
		enum wl_pointer_axis axis;
		bool axis_valid[2];
		struct wl_list link; // wlr_virtual_pointer_manager_v1.virtual_pointers
	};
	struct wlr_virtual_pointer_v1_new_pointer_event {
		struct wlr_virtual_pointer_v1 *new_pointer;
		// Suggested by client; may be NULL.
		struct wlr_seat *suggested_seat;
		struct wlr_output *suggested_output;
	};
	struct wlr_virtual_pointer_manager_v1* wlr_virtual_pointer_manager_v1_create(struct wl_display *display);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_xcursor_manager.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_xcursor_manager_theme {
		float scale;
		struct wlr_xcursor_theme *theme;
		struct wl_list link;
	};
	struct wlr_xcursor_manager {
		char *name;
		uint32_t size;
		struct wl_list scaled_themes; // wlr_xcursor_manager_theme.link
	};
	struct wlr_xcursor_manager *wlr_xcursor_manager_create(const char *name, uint32_t size);
	void wlr_xcursor_manager_destroy(struct wlr_xcursor_manager *manager);
	bool wlr_xcursor_manager_load(struct wlr_xcursor_manager *manager, float scale);
	struct wlr_xcursor *wlr_xcursor_manager_get_xcursor(struct wlr_xcursor_manager *manager, const char *name, float scale);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_xdg_activation_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_xdg_activation_token_v1 {
		struct wlr_xdg_activation_v1 *activation;
		// The source surface that created the token.
		struct wlr_surface *surface; // can be NULL
		struct wlr_seat *seat; // can be NULL
		// The serial for the input event that created the token.
		uint32_t serial; // invalid if seat is NULL
		// The application ID to be activated. This is just a hint.
		char *app_id; // can be NULL
		struct wl_list link; // wlr_xdg_activation_v1.tokens
		void *data;
		struct {
			struct wl_signal destroy;
		} events;
		// private state
		char *token;
		struct wl_resource *resource; // can be NULL
		struct wl_event_source *timeout; // can be NULL
		struct wl_listener seat_destroy;
		struct wl_listener surface_destroy;
	};
	struct wlr_xdg_activation_v1 {
		uint32_t token_timeout_msec; // token timeout in milliseconds (0 to disable)
		struct wl_list tokens; // wlr_xdg_activation_token_v1.link
		struct {
			struct wl_signal destroy;
			struct wl_signal request_activate; // struct wlr_xdg_activation_v1_request_activate_event
			struct wl_signal new_token; // struct wlr_xdg_activation_token_v1
		} events;
		// private state
		struct wl_display *display;
		struct wl_global *global;
		struct wl_listener display_destroy;
	};
	struct wlr_xdg_activation_v1_request_activate_event {
		struct wlr_xdg_activation_v1 *activation;
		struct wlr_xdg_activation_token_v1 *token;
		struct wlr_surface *surface;
	};
	struct wlr_xdg_activation_v1 *wlr_xdg_activation_v1_create(struct wl_display *display);
	struct wlr_xdg_activation_token_v1 *wlr_xdg_activation_token_v1_create(struct wlr_xdg_activation_v1 *activation);
	void wlr_xdg_activation_token_v1_destroy(struct wlr_xdg_activation_token_v1 *token);
	struct wlr_xdg_activation_token_v1 *wlr_xdg_activation_v1_find_token(struct wlr_xdg_activation_v1 *activation, const char *token_str);
	const char *wlr_xdg_activation_token_v1_get_name(struct wlr_xdg_activation_token_v1 *token);
	struct wlr_xdg_activation_token_v1 *wlr_xdg_activation_v1_add_token(struct wlr_xdg_activation_v1 *activation, const char *token_str);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_xdg_decoration_v1.h
	enum wlr_xdg_toplevel_decoration_v1_mode {
		WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_NONE = 0,
		WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_CLIENT_SIDE = 1,
		WLR_XDG_TOPLEVEL_DECORATION_V1_MODE_SERVER_SIDE = 2,
	};
	struct wlr_xdg_decoration_manager_v1 {
		struct wl_global *global;
		struct wl_list decorations; // wlr_xdg_toplevel_decoration.link
		struct wl_listener display_destroy;
		struct {
			struct wl_signal new_toplevel_decoration; // struct wlr_xdg_toplevel_decoration
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_xdg_toplevel_decoration_v1_configure {
		struct wl_list link; // wlr_xdg_toplevel_decoration.configure_list
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
		struct wl_list link; // wlr_xdg_decoration_manager_v1.link
		struct wlr_xdg_toplevel_decoration_v1_state current, pending;
		enum wlr_xdg_toplevel_decoration_v1_mode scheduled_mode;
		enum wlr_xdg_toplevel_decoration_v1_mode requested_mode;
		struct wl_list configure_list; // wlr_xdg_toplevel_decoration_v1_configure.link
		struct {
			struct wl_signal destroy;
			struct wl_signal request_mode;
		} events;
		void *data;
		// private state
		struct wl_listener toplevel_destroy;
		struct wl_listener surface_configure;
		struct wl_listener surface_ack_configure;
		struct wlr_surface_synced synced;
	};
	struct wlr_xdg_decoration_manager_v1 *wlr_xdg_decoration_manager_v1_create(struct wl_display *display);
	uint32_t wlr_xdg_toplevel_decoration_v1_set_mode(struct wlr_xdg_toplevel_decoration_v1 *decoration, enum wlr_xdg_toplevel_decoration_v1_mode mode);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_xdg_foreign_registry.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_xdg_foreign_registry {
		struct wl_list exported_surfaces; // struct wlr_xdg_foreign_exported_surface
		struct wl_listener display_destroy;
		struct {
			struct wl_signal destroy;
		} events;
	};
	struct wlr_xdg_foreign_exported {
		struct wl_list link; // wlr_xdg_foreign_registry.exported_surfaces
		struct wlr_xdg_foreign_registry *registry;
		struct wlr_surface *surface;
		char handle[37 /* WLR_XDG_FOREIGN_HANDLE_SIZE */];
		struct {
			struct wl_signal destroy;
		} events;
	};
	struct wlr_xdg_foreign_registry *wlr_xdg_foreign_registry_create(struct wl_display *display);
	bool wlr_xdg_foreign_exported_init(struct wlr_xdg_foreign_exported *surface, struct wlr_xdg_foreign_registry *registry);
	struct wlr_xdg_foreign_exported *wlr_xdg_foreign_registry_find_by_handle(struct wlr_xdg_foreign_registry *registry, const char *handle);
	void wlr_xdg_foreign_exported_finish(struct wlr_xdg_foreign_exported *surface);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_xdg_foreign_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_xdg_foreign_v1 {
		struct {
			struct wl_global *global;
			struct wl_list objects; // wlr_xdg_exported_v1.link or wlr_xdg_imported_v1.link
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
		struct wl_list link; // wlr_xdg_foreign_v1.exporter.objects
	};
	struct wlr_xdg_imported_v1 {
		struct wlr_xdg_foreign_exported *exported;
		struct wl_listener exported_destroyed;
		struct wl_resource *resource;
		struct wl_list link; // wlr_xdg_foreign_v1.importer.objects
		struct wl_list children;
	};
	struct wlr_xdg_imported_child_v1 {
		struct wlr_xdg_imported_v1 *imported;
		struct wlr_surface *surface;
		struct wl_list link; // wlr_xdg_imported_v1.children
		struct wl_listener xdg_toplevel_destroy;
		struct wl_listener xdg_toplevel_set_parent;
	};
	struct wlr_xdg_foreign_v1 *wlr_xdg_foreign_v1_create(struct wl_display *display, struct wlr_xdg_foreign_registry *registry);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_xdg_foreign_v2.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_xdg_foreign_v2 {
		struct {
			struct wl_global *global;
			struct wl_list objects; // wlr_xdg_exported_v2.link or wlr_xdg_imported_v2.link
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
		struct wl_list link; // wlr_xdg_foreign_v2.exporter.objects
	};
	struct wlr_xdg_imported_v2 {
		struct wlr_xdg_foreign_exported *exported;
		struct wl_listener exported_destroyed;
		struct wl_resource *resource;
		struct wl_list link; // wlr_xdg_foreign_v2.importer.objects
		struct wl_list children;
	};
	struct wlr_xdg_imported_child_v2 {
		struct wlr_xdg_imported_v2 *imported;
		struct wlr_surface *surface;
		struct wl_list link; // wlr_xdg_imported_v2.children
		struct wl_listener xdg_toplevel_destroy;
		struct wl_listener xdg_toplevel_set_parent;
	};
	struct wlr_xdg_foreign_v2 *wlr_xdg_foreign_v2_create(struct wl_display *display, struct wlr_xdg_foreign_registry *registry);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_xdg_output_v1.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
	struct wlr_xdg_output_manager_v1 *wlr_xdg_output_manager_v1_create(struct wl_display *display, struct wlr_output_layout *layout);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/types/wlr_xdg_shell.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_xdg_shell {
		struct wl_global *global;
		uint32_t version;
		struct wl_list clients;
		struct wl_list popup_grabs;
		uint32_t ping_timeout;
		struct wl_listener display_destroy;
		struct {
			struct wl_signal new_surface; // struct wlr_xdg_surface
			struct wl_signal new_toplevel; // struct wlr_xdg_toplevel
			struct wl_signal new_popup; // struct wlr_xdg_popup
			struct wl_signal destroy;
		} events;
		void *data;
	};
	struct wlr_xdg_client {
		struct wlr_xdg_shell *shell;
		struct wl_resource *resource;
		struct wl_client *client;
		struct wl_list surfaces;
		struct wl_list link; // wlr_xdg_shell.clients
		uint32_t ping_serial;
		struct wl_event_source *ping_timer;
	};
	struct wlr_xdg_positioner_rules {
		struct wlr_box anchor_rect;
		enum xdg_positioner_anchor anchor;
		enum xdg_positioner_gravity gravity;
		enum xdg_positioner_constraint_adjustment constraint_adjustment;
		bool reactive;
		bool has_parent_configure_serial;
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
		// Position of the popup relative to the upper left corner of
		// the window geometry of the parent surface
		struct wlr_box geometry;
		bool reactive;
	};
	enum wlr_xdg_popup_configure_field {
		WLR_XDG_POPUP_CONFIGURE_REPOSITION_TOKEN = 1 << 0,
	};
	struct wlr_xdg_popup_configure {
		uint32_t fields; // enum wlr_xdg_popup_configure_field
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
		struct wl_list grab_link; // wlr_xdg_popup_grab.popups
		// private state
		struct wlr_surface_synced synced;
	};
	// each seat gets a popup grab
	struct wlr_xdg_popup_grab {
		struct wl_client *client;
		struct wlr_seat_pointer_grab pointer_grab;
		struct wlr_seat_keyboard_grab keyboard_grab;
		struct wlr_seat_touch_grab touch_grab;
		struct wlr_seat *seat;
		struct wl_list popups;
		struct wl_list link; // wlr_xdg_shell.popup_grabs
		struct wl_listener seat_destroy;
	};
	enum wlr_xdg_surface_role {
		WLR_XDG_SURFACE_ROLE_NONE,
		WLR_XDG_SURFACE_ROLE_TOPLEVEL,
		WLR_XDG_SURFACE_ROLE_POPUP,
	};
	struct wlr_xdg_toplevel_state {
		bool maximized, fullscreen, resizing, activated, suspended;
		uint32_t tiled; // enum wlr_edges
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
		uint32_t fields; // enum wlr_xdg_toplevel_configure_field
		bool maximized, fullscreen, resizing, activated, suspended;
		uint32_t tiled; // enum wlr_edges
		int32_t width, height;
		struct {
			int32_t width, height;
		} bounds;
		uint32_t wm_capabilities; // enum wlr_xdg_toplevel_wm_capabilities
	};
	struct wlr_xdg_toplevel_requested {
		bool maximized, minimized, fullscreen;
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
		// private state
		struct wlr_surface_synced synced;
	};
	struct wlr_xdg_surface_configure {
		struct wlr_xdg_surface *surface;
		struct wl_list link; // wlr_xdg_surface.configure_list
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
		struct wl_list link; // wlr_xdg_client.surfaces
		enum wlr_xdg_surface_role role;
		struct wl_resource *role_resource;
		// NULL if the role resource is inert
		union {
			struct wlr_xdg_toplevel *toplevel;
			struct wlr_xdg_popup *popup;
		};
		struct wl_list popups; // wlr_xdg_popup.link
		bool configured;
		struct wl_event_source *configure_idle;
		uint32_t scheduled_serial;
		struct wl_list configure_list;
		struct wlr_xdg_surface_state current, pending;
		// Whether the surface is ready to receive configure events
		bool initialized;
		// Whether the latest commit is an initial commit
		bool initial_commit;
		struct {
			struct wl_signal destroy;
			struct wl_signal ping_timeout;
			struct wl_signal new_popup;
			// for protocol extensions
			struct wl_signal configure; // struct wlr_xdg_surface_configure
			struct wl_signal ack_configure; // struct wlr_xdg_surface_configure
		} events;
		void *data;
		// private state
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
	struct wlr_xdg_shell *wlr_xdg_shell_create(struct wl_display *display, uint32_t version);
	struct wlr_xdg_surface *wlr_xdg_surface_from_resource(struct wl_resource *resource);
	struct wlr_xdg_popup *wlr_xdg_popup_from_resource(struct wl_resource *resource);
	struct wlr_xdg_toplevel *wlr_xdg_toplevel_from_resource(struct wl_resource *resource);
	struct wlr_xdg_positioner *wlr_xdg_positioner_from_resource(struct wl_resource *resource);
	void wlr_xdg_surface_ping(struct wlr_xdg_surface *surface);
	uint32_t wlr_xdg_toplevel_set_size(struct wlr_xdg_toplevel *toplevel, int32_t width, int32_t height);
	uint32_t wlr_xdg_toplevel_set_activated(struct wlr_xdg_toplevel *toplevel, bool activated);
	uint32_t wlr_xdg_toplevel_set_maximized(struct wlr_xdg_toplevel *toplevel, bool maximized);
	uint32_t wlr_xdg_toplevel_set_fullscreen(struct wlr_xdg_toplevel *toplevel, bool fullscreen);
	uint32_t wlr_xdg_toplevel_set_resizing(struct wlr_xdg_toplevel *toplevel, bool resizing);
	uint32_t wlr_xdg_toplevel_set_tiled(struct wlr_xdg_toplevel *toplevel, uint32_t tiled_edges);
	uint32_t wlr_xdg_toplevel_set_bounds(struct wlr_xdg_toplevel *toplevel, int32_t width, int32_t height);
	uint32_t wlr_xdg_toplevel_set_wm_capabilities(struct wlr_xdg_toplevel *toplevel, uint32_t caps);
	uint32_t wlr_xdg_toplevel_set_suspended(struct wlr_xdg_toplevel *toplevel, bool suspended);
	void wlr_xdg_toplevel_send_close(struct wlr_xdg_toplevel *toplevel);
	bool wlr_xdg_toplevel_set_parent(struct wlr_xdg_toplevel *toplevel, 		struct wlr_xdg_toplevel *parent);
	void wlr_xdg_popup_destroy(struct wlr_xdg_popup *popup);
	void wlr_xdg_popup_get_position(struct wlr_xdg_popup *popup, double *popup_sx, double *popup_sy);
	bool wlr_xdg_positioner_is_complete(struct wlr_xdg_positioner *positioner);
	void wlr_xdg_positioner_rules_get_geometry(const struct wlr_xdg_positioner_rules *rules, struct wlr_box *box);
	void wlr_xdg_positioner_rules_unconstrain_box(const struct wlr_xdg_positioner_rules *rules, const struct wlr_box *constraint, struct wlr_box *box);
	void wlr_xdg_popup_get_toplevel_coords(struct wlr_xdg_popup *popup, int popup_sx, int popup_sy, int *toplevel_sx, int *toplevel_sy);
	void wlr_xdg_popup_unconstrain_from_box(struct wlr_xdg_popup *popup, const struct wlr_box *toplevel_space_box);
	struct wlr_surface *wlr_xdg_surface_surface_at(struct wlr_xdg_surface *surface, double sx, double sy, double *sub_x, double *sub_y);
	struct wlr_surface *wlr_xdg_surface_popup_surface_at(struct wlr_xdg_surface *surface, double sx, double sy, double *sub_x, double *sub_y);
	struct wlr_xdg_surface *wlr_xdg_surface_try_from_wlr_surface(struct wlr_surface *surface);
	struct wlr_xdg_toplevel *wlr_xdg_toplevel_try_from_wlr_surface(struct wlr_surface *surface);
	struct wlr_xdg_popup *wlr_xdg_popup_try_from_wlr_surface(struct wlr_surface *surface);
	void wlr_xdg_surface_get_geometry(struct wlr_xdg_surface *surface, struct wlr_box *box);
	void wlr_xdg_surface_for_each_surface(struct wlr_xdg_surface *surface, wlr_surface_iterator_func_t iterator, void *user_data);
	void wlr_xdg_surface_for_each_popup_surface(struct wlr_xdg_surface *surface, wlr_surface_iterator_func_t iterator, void *user_data);
	uint32_t wlr_xdg_surface_schedule_configure(struct wlr_xdg_surface *surface);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/xcursor.h
	struct wlr_xcursor_image {
		uint32_t width; /* actual width */
		uint32_t height; /* actual height */
		uint32_t hotspot_x; /* hot-spot x (must be inside image) */
		uint32_t hotspot_y; /* hot-spot y (must be inside image) */
		uint32_t delay; /* animation delay to next frame (ms) */
		uint8_t *buffer; /* pixel data */
	};
	struct wlr_xcursor {
		unsigned int image_count;
		struct wlr_xcursor_image **images;
		char *name;
		uint32_t total_delay; /* total duration of the animation in ms */
	};
	struct wlr_xcursor_theme {
		unsigned int cursor_count;
		struct wlr_xcursor **cursors;
		char *name;
		int size;
	};
	struct wlr_xcursor_theme *wlr_xcursor_theme_load(const char *name, int size);
	void wlr_xcursor_theme_destroy(struct wlr_xcursor_theme *theme);
	struct wlr_xcursor *wlr_xcursor_theme_get_cursor(struct wlr_xcursor_theme *theme, const char *name);
	int wlr_xcursor_frame(struct wlr_xcursor *cursor, uint32_t time);
	const char *wlr_xcursor_get_resize_name(enum wlr_edges edges);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/backend.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_session;
	struct wlr_backend_impl;
	struct wlr_backend_output_state {
		struct wlr_output *output;
		struct wlr_output_state base;
	};
	struct wlr_backend {
		const struct wlr_backend_impl *impl;
		struct {
			// Raised when destroyed
			struct wl_signal destroy;
			struct wl_signal new_input;
			struct wl_signal new_output;
		} events;
	};
	struct wlr_backend *wlr_backend_autocreate(struct wl_event_loop *loop, struct wlr_session **session_ptr);
	bool wlr_backend_start(struct wlr_backend *backend);
	void wlr_backend_destroy(struct wlr_backend *backend);
	int wlr_backend_get_drm_fd(struct wlr_backend *backend);
	bool wlr_backend_test(struct wlr_backend *backend, const struct wlr_backend_output_state *states, size_t states_len);
	bool wlr_backend_commit(struct wlr_backend *backend, const struct wlr_backend_output_state *states, size_t states_len);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/backend/drm.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
	struct wlr_backend *wlr_drm_backend_create(struct wlr_session *session, struct wlr_device *dev, struct wlr_backend *parent);
	bool wlr_backend_is_drm(struct wlr_backend *backend);
	bool wlr_output_is_drm(struct wlr_output *output);
	struct wlr_backend *wlr_drm_backend_get_parent(struct wlr_backend *backend);
	uint32_t wlr_drm_connector_get_id(struct wlr_output *output);
	int wlr_drm_backend_get_non_master_fd(struct wlr_backend *backend);
	struct wlr_drm_lease *wlr_drm_create_lease(struct wlr_output **outputs, size_t n_outputs, int *lease_fd);
	void wlr_drm_lease_terminate(struct wlr_drm_lease *lease);
	struct wlr_output_mode *wlr_drm_connector_add_mode(struct wlr_output *output, const drmModeModeInfo *mode);
	const drmModeModeInfo *wlr_drm_mode_get_info(struct wlr_output_mode *mode);
	enum wl_output_transform wlr_drm_connector_get_panel_orientation(struct wlr_output *output);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/backend/headless.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_backend *wlr_headless_backend_create(struct wl_event_loop *loop);
	struct wlr_output *wlr_headless_add_output(struct wlr_backend *backend, unsigned int width, unsigned int height);
	bool wlr_backend_is_headless(struct wlr_backend *backend);
	bool wlr_output_is_headless(struct wlr_output *output);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/backend/libinput.h
	struct wlr_input_device;
	struct wlr_backend *wlr_libinput_backend_create(struct wlr_session *session);
	struct libinput_device *wlr_libinput_get_device_handle(struct wlr_input_device *dev);
	bool wlr_backend_is_libinput(struct wlr_backend *backend);
	bool wlr_input_device_is_libinput(struct wlr_input_device *device);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/backend/multi.h
	struct wlr_backend *wlr_multi_backend_create(struct wl_event_loop *loop);
	bool wlr_multi_backend_add(struct wlr_backend *multi, struct wlr_backend *backend);
	void wlr_multi_backend_remove(struct wlr_backend *multi, struct wlr_backend *backend);
	bool wlr_backend_is_multi(struct wlr_backend *backend);
	bool wlr_multi_is_empty(struct wlr_backend *backend);
	void wlr_multi_for_each_backend(struct wlr_backend *backend, void (*callback)(struct wlr_backend *backend, void *data), void *data);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/backend/session.h
	struct libseat;
	struct wlr_device {
		int fd;
		int device_id;
		dev_t dev;
		struct wl_list link; // wlr_session.devices
		struct {
			struct wl_signal change; // struct wlr_device_change_event
			struct wl_signal remove;
		} events;
	};
	struct wlr_session {
		bool active;
		unsigned vtnr;
		char seat[256];
		struct udev *udev;
		struct udev_monitor *mon;
		struct wl_event_source *udev_event;
		struct libseat *seat_handle;
		struct wl_event_source *libseat_event;
		struct wl_list devices; // wlr_device.link
		struct wl_event_loop *event_loop;
		struct wl_listener event_loop_destroy;
		struct {
			struct wl_signal active;
			struct wl_signal add_drm_card; // struct wlr_session_add_event
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
	struct wlr_device *wlr_session_open_file(struct wlr_session *session, const char *path);
	void wlr_session_close_file(struct wlr_session *session, struct wlr_device *device);
	bool wlr_session_change_vt(struct wlr_session *session, unsigned vt);
	ssize_t wlr_session_find_gpus(struct wlr_session *session, size_t ret_len, struct wlr_device **ret);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/backend/wayland.h
	struct wlr_input_device;
	struct wlr_backend *wlr_wl_backend_create(struct wl_event_loop *loop, struct wl_display *remote_display);
	struct wl_display *wlr_wl_backend_get_remote_display(struct wlr_backend *backend);
	struct wlr_output *wlr_wl_output_create(struct wlr_backend *backend);
	struct wlr_output *wlr_wl_output_create_from_surface(struct wlr_backend *backend, struct wl_surface *surface);
	bool wlr_backend_is_wl(struct wlr_backend *backend);
	bool wlr_input_device_is_wl(struct wlr_input_device *device);
	bool wlr_output_is_wl(struct wlr_output *output);
	void wlr_wl_output_set_title(struct wlr_output *output, const char *title);
	void wlr_wl_output_set_app_id(struct wlr_output *output, const char *app_id);
	struct wl_surface *wlr_wl_output_get_surface(struct wlr_output *output);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/backend/x11.h
	struct wlr_input_device;
	struct wlr_backend *wlr_x11_backend_create(struct wl_event_loop *loop, const char *x11_display);
	struct wlr_output *wlr_x11_output_create(struct wlr_backend *backend);
	bool wlr_backend_is_x11(struct wlr_backend *backend);
	bool wlr_input_device_is_x11(struct wlr_input_device *device);
	bool wlr_output_is_x11(struct wlr_output *output);
	void wlr_x11_output_set_title(struct wlr_output *output, const char *title);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/interfaces/wlr_buffer.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	 struct wlr_buffer_impl {
		void (*destroy)(struct wlr_buffer *buffer);
		bool (*get_dmabuf)(struct wlr_buffer *buffer,
			struct wlr_dmabuf_attributes *attribs);
		bool (*get_shm)(struct wlr_buffer *buffer,
			struct wlr_shm_attributes *attribs);
		bool (*begin_data_ptr_access)(struct wlr_buffer *buffer, uint32_t flags,
			void **data, uint32_t *format, size_t *stride);
		void (*end_data_ptr_access)(struct wlr_buffer *buffer);
	};
	struct wlr_buffer_resource_interface {
		const char *name;
		bool (*is_instance)(struct wl_resource *resource);
		struct wlr_buffer *(*from_resource)(struct wl_resource *resource);
	};
	void wlr_buffer_init(struct wlr_buffer *buffer, const struct wlr_buffer_impl *impl, int width, int height);
	void wlr_buffer_register_resource_interface(const struct wlr_buffer_resource_interface *iface);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/interfaces/wlr_keyboard.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_keyboard_impl {
		const char *name;
		void (*led_update)(struct wlr_keyboard *keyboard, uint32_t leds);
	};
	void wlr_keyboard_init(struct wlr_keyboard *keyboard, const struct wlr_keyboard_impl *impl, const char *name);
	void wlr_keyboard_finish(struct wlr_keyboard *keyboard);
	void wlr_keyboard_notify_key(struct wlr_keyboard *keyboard, struct wlr_keyboard_key_event *event);
	void wlr_keyboard_notify_modifiers(struct wlr_keyboard *keyboard, uint32_t mods_depressed, uint32_t mods_latched, uint32_t mods_locked, uint32_t group);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/interfaces/wlr_output.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_output_cursor_size {
		int width, height;
	};
	struct wlr_output_impl {
		bool (*set_cursor)(struct wlr_output *output, struct wlr_buffer *buffer, int hotspot_x, int hotspot_y);
		bool (*move_cursor)(struct wlr_output *output, int x, int y);
		void (*destroy)(struct wlr_output *output);
		bool (*test)(struct wlr_output *output, const struct wlr_output_state *state);
		bool (*commit)(struct wlr_output *output, const struct wlr_output_state *state);
		size_t (*get_gamma_size)(struct wlr_output *output);
		const struct wlr_drm_format_set *(*get_cursor_formats)(struct wlr_output *output, uint32_t buffer_caps);
		const struct wlr_output_cursor_size *(*get_cursor_sizes)(struct wlr_output *output, size_t *len);
		const struct wlr_drm_format_set *(*get_primary_formats)(struct wlr_output *output, uint32_t buffer_caps);
	};
	void wlr_output_init(struct wlr_output *output, struct wlr_backend *backend, const struct wlr_output_impl *impl, struct wl_event_loop *event_loop, const struct wlr_output_state *state);
	void wlr_output_update_needs_frame(struct wlr_output *output);
	void wlr_output_send_frame(struct wlr_output *output);
	void wlr_output_send_present(struct wlr_output *output, struct wlr_output_event_present *event);
	void wlr_output_send_request_state(struct wlr_output *output, const struct wlr_output_state *state);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/interfaces/wlr_pointer.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_pointer_impl {
		const char *name;
	};
	void wlr_pointer_init(struct wlr_pointer *pointer, const struct wlr_pointer_impl *impl, const char *name);
	void wlr_pointer_finish(struct wlr_pointer *pointer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/interfaces/wlr_switch.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_switch_impl {
		const char *name;
	};
	void wlr_switch_init(struct wlr_switch *switch_device, const struct wlr_switch_impl *impl, const char *name);
	void wlr_switch_finish(struct wlr_switch *switch_device);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/interfaces/wlr_tablet_pad.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_tablet_pad_impl {
		const char *name;
	};
	void wlr_tablet_pad_init(struct wlr_tablet_pad *pad, const struct wlr_tablet_pad_impl *impl, const char *name);
	void wlr_tablet_pad_finish(struct wlr_tablet_pad *pad);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/interfaces/wlr_tablet_tool.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_tablet_impl {
		const char *name;
	};
	void wlr_tablet_init(struct wlr_tablet *tablet, const struct wlr_tablet_impl *impl, const char *name);
	void wlr_tablet_finish(struct wlr_tablet *tablet);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/interfaces/wlr_touch.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_touch_impl {
		const char *name;
	};
	void wlr_touch_init(struct wlr_touch *touch, const struct wlr_touch_impl *impl, const char *name);
	void wlr_touch_finish(struct wlr_touch *touch);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/allocator.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_allocator;
	struct wlr_backend;
	struct wlr_drm_format;
	struct wlr_renderer;
	struct wlr_allocator_interface {
		struct wlr_buffer *(*create_buffer)(struct wlr_allocator *alloc, int width, int height, const struct wlr_drm_format *format);
		void (*destroy)(struct wlr_allocator *alloc);
	};
	void wlr_allocator_init(struct wlr_allocator *alloc, const struct wlr_allocator_interface *impl, uint32_t buffer_caps);
	struct wlr_allocator {
		const struct wlr_allocator_interface *impl;
		// Capabilities of the buffers created with this allocator
		uint32_t buffer_caps;
		struct {
			struct wl_signal destroy;
		} events;
	};
	struct wlr_allocator *wlr_allocator_autocreate(struct wlr_backend *backend, struct wlr_renderer *renderer);
	void wlr_allocator_destroy(struct wlr_allocator *alloc);
	struct wlr_buffer *wlr_allocator_create_buffer(struct wlr_allocator *alloc, int width, int height, const struct wlr_drm_format *format);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/color.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_color_transform;
	struct wlr_color_transform *wlr_color_transform_init_linear_to_icc(const void *data, size_t size);
	struct wlr_color_transform *wlr_color_transform_init_srgb(void);
	void wlr_color_transform_ref(struct wlr_color_transform *tr);
	void wlr_color_transform_unref(struct wlr_color_transform *tr);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/drm_syncobj.h
	struct wlr_drm_syncobj_timeline {
		int drm_fd;
		uint32_t handle;
		// private state
		size_t n_refs;
	};
	struct wlr_drm_syncobj_timeline_waiter {
		struct {
			struct wl_signal ready;
		} events;
		// private state
		int ev_fd;
		struct wl_event_source *event_source;
	};
	struct wlr_drm_syncobj_timeline *wlr_drm_syncobj_timeline_create(int drm_fd);
	struct wlr_drm_syncobj_timeline *wlr_drm_syncobj_timeline_import(int drm_fd, int drm_syncobj_fd);
	struct wlr_drm_syncobj_timeline *wlr_drm_syncobj_timeline_ref(struct wlr_drm_syncobj_timeline *timeline);
	void wlr_drm_syncobj_timeline_unref(struct wlr_drm_syncobj_timeline *timeline);
	bool wlr_drm_syncobj_timeline_check(struct wlr_drm_syncobj_timeline *timeline, uint64_t point, uint32_t flags, bool *result);
	bool wlr_drm_syncobj_timeline_waiter_init(struct wlr_drm_syncobj_timeline_waiter *waiter, struct wlr_drm_syncobj_timeline *timeline, uint64_t point, uint32_t flags, struct wl_event_loop *loop);
	void wlr_drm_syncobj_timeline_waiter_finish(struct wlr_drm_syncobj_timeline_waiter *waiter);
	int wlr_drm_syncobj_timeline_export_sync_file(struct wlr_drm_syncobj_timeline *timeline, uint64_t src_point);
	bool wlr_drm_syncobj_timeline_import_sync_file(struct wlr_drm_syncobj_timeline *timeline, uint64_t dst_point, int sync_file_fd);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/egl.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_egl;
	struct wlr_egl *wlr_egl_create_with_context(EGLDisplay display, EGLContext context);
	EGLDisplay wlr_egl_get_display(struct wlr_egl *egl);
	EGLContext wlr_egl_get_context(struct wlr_egl *egl);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/gles2.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_egl;
	struct wlr_renderer *wlr_gles2_renderer_create_with_drm_fd(int drm_fd);
	struct wlr_renderer *wlr_gles2_renderer_create(struct wlr_egl *egl);
	struct wlr_egl *wlr_gles2_renderer_get_egl(struct wlr_renderer *renderer);
	bool wlr_gles2_renderer_check_ext(struct wlr_renderer *renderer, const char *ext);
	GLuint wlr_gles2_renderer_get_buffer_fbo(struct wlr_renderer *renderer, struct wlr_buffer *buffer);
	struct wlr_gles2_texture_attribs {
		GLenum target; /* either GL_TEXTURE_2D or GL_TEXTURE_EXTERNAL_OES */
		GLuint tex;
		bool has_alpha;
	};
	bool wlr_renderer_is_gles2(struct wlr_renderer *wlr_renderer);
	bool wlr_render_timer_is_gles2(struct wlr_render_timer *timer);
	bool wlr_texture_is_gles2(struct wlr_texture *texture);
	void wlr_gles2_texture_get_attribs(struct wlr_texture *texture, struct wlr_gles2_texture_attribs *attribs);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/interface.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_box;
	struct wlr_fbox;
	struct wlr_renderer_impl {
		const struct wlr_drm_format_set *(*get_texture_formats)(struct wlr_renderer *renderer, uint32_t buffer_caps);
		const struct wlr_drm_format_set *(*get_render_formats)(struct wlr_renderer *renderer);
		void (*destroy)(struct wlr_renderer *renderer);
		int (*get_drm_fd)(struct wlr_renderer *renderer);
		struct wlr_texture *(*texture_from_buffer)(struct wlr_renderer *renderer, struct wlr_buffer *buffer);
		struct wlr_render_pass *(*begin_buffer_pass)(struct wlr_renderer *renderer, struct wlr_buffer *buffer, const struct wlr_buffer_pass_options *options);
		struct wlr_render_timer *(*render_timer_create)(struct wlr_renderer *renderer);
	};
	void wlr_renderer_init(struct wlr_renderer *renderer, const struct wlr_renderer_impl *impl, uint32_t render_buffer_caps);
	struct wlr_texture_impl {
		bool (*update_from_buffer)(struct wlr_texture *texture, struct wlr_buffer *buffer, const pixman_region32_t *damage);
		bool (*read_pixels)(struct wlr_texture *texture, const struct wlr_texture_read_pixels_options *options);
		uint32_t (*preferred_read_format)(struct wlr_texture *texture);
		void (*destroy)(struct wlr_texture *texture);
	};
	void wlr_texture_init(struct wlr_texture *texture, struct wlr_renderer *rendener, const struct wlr_texture_impl *impl, uint32_t width, uint32_t height);
	struct wlr_render_pass {
		const struct wlr_render_pass_impl *impl;
	};
	void wlr_render_pass_init(struct wlr_render_pass *pass, const struct wlr_render_pass_impl *impl);
	struct wlr_render_pass_impl {
		bool (*submit)(struct wlr_render_pass *pass);
		void (*add_texture)(struct wlr_render_pass *pass, const struct wlr_render_texture_options *options);
		/* Implementers are also guaranteed that options->box is nonempty */
		void (*add_rect)(struct wlr_render_pass *pass, const struct wlr_render_rect_options *options);
	};
	struct wlr_render_timer {
		const struct wlr_render_timer_impl *impl;
	};
	struct wlr_render_timer_impl {
		int (*get_duration_ns)(struct wlr_render_timer *timer);
		void (*destroy)(struct wlr_render_timer *timer);
	};
	void wlr_render_texture_options_get_src_box(const struct wlr_render_texture_options *options, struct wlr_fbox *box);
	void wlr_render_texture_options_get_dst_box(const struct wlr_render_texture_options *options, struct wlr_box *box);
	float wlr_render_texture_options_get_alpha(const struct wlr_render_texture_options *options);
	void wlr_render_rect_options_get_box(const struct wlr_render_rect_options *options, const struct wlr_buffer *buffer, struct wlr_box *box);
	void wlr_texture_read_pixels_options_get_src_box(const struct wlr_texture_read_pixels_options *options, const struct wlr_texture *texture, struct wlr_box *box);
	void *wlr_texture_read_pixel_options_get_data(const struct wlr_texture_read_pixels_options *options);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/pixman.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_renderer *wlr_pixman_renderer_create(void);
	bool wlr_renderer_is_pixman(struct wlr_renderer *wlr_renderer);
	bool wlr_texture_is_pixman(struct wlr_texture *texture);
	pixman_image_t *wlr_pixman_renderer_get_buffer_image(struct wlr_renderer *wlr_renderer, struct wlr_buffer *wlr_buffer);
	pixman_image_t *wlr_pixman_texture_get_image(struct wlr_texture *wlr_texture);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/swapchain.h
	struct wlr_swapchain_slot {
		struct wlr_buffer *buffer;
		bool acquired; // waiting for release
		int age;
		struct wl_listener release;
	};
	struct wlr_swapchain {
		struct wlr_allocator *allocator; // NULL if destroyed
		int width, height;
		struct wlr_drm_format format;
		struct wlr_swapchain_slot slots[4 /* WLR_SWAPCHAIN_CAP */];
		struct wl_listener allocator_destroy;
	};
	struct wlr_swapchain *wlr_swapchain_create(struct wlr_allocator *alloc, int width, int height, const struct wlr_drm_format *format);
	void wlr_swapchain_destroy(struct wlr_swapchain *swapchain);
	struct wlr_buffer *wlr_swapchain_acquire(struct wlr_swapchain *swapchain, int *age);
	bool wlr_swapchain_has_buffer(struct wlr_swapchain *swapchain, struct wlr_buffer *buffer);
	void wlr_swapchain_set_buffer_submitted(struct wlr_swapchain *swapchain, struct wlr_buffer *buffer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/vulkan.h
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
	bool wlr_renderer_is_vk(struct wlr_renderer *wlr_renderer);
	bool wlr_texture_is_vk(struct wlr_texture *texture);
	void wlr_vk_texture_get_image_attribs(struct wlr_texture *texture, struct wlr_vk_image_attribs *attribs);
	bool wlr_vk_texture_has_alpha(struct wlr_texture *texture);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/wlr_renderer.h
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
			bool output_color_transform;
		} features;
		// private state
		const struct wlr_renderer_impl *impl;
	};
	struct wlr_renderer *wlr_renderer_autocreate(struct wlr_backend *backend);
	const struct wlr_drm_format_set *wlr_renderer_get_texture_formats(struct wlr_renderer *r, uint32_t buffer_caps);
	bool wlr_renderer_init_wl_display(struct wlr_renderer *r, struct wl_display *wl_display);
	bool wlr_renderer_init_wl_shm(struct wlr_renderer *r, struct wl_display *wl_display);
	int wlr_renderer_get_drm_fd(struct wlr_renderer *r);
	void wlr_renderer_destroy(struct wlr_renderer *renderer);
	struct wlr_render_timer *wlr_render_timer_create(struct wlr_renderer *renderer);
	int wlr_render_timer_get_duration_ns(struct wlr_render_timer *timer);
	void wlr_render_timer_destroy(struct wlr_render_timer *timer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/render/wlr_texture.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
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
	bool wlr_texture_read_pixels(struct wlr_texture *texture, const struct wlr_texture_read_pixels_options *options);
	uint32_t wlr_texture_preferred_read_format(struct wlr_texture *texture);
	struct wlr_texture *wlr_texture_from_pixels(struct wlr_renderer *renderer, uint32_t fmt, uint32_t stride, uint32_t width, uint32_t height, const void *data);
	struct wlr_texture *wlr_texture_from_dmabuf(struct wlr_renderer *renderer, struct wlr_dmabuf_attributes *attribs);
	bool wlr_texture_update_from_buffer(struct wlr_texture *texture, struct wlr_buffer *buffer, const pixman_region32_t *damage);
	void wlr_texture_destroy(struct wlr_texture *texture);
	struct wlr_texture *wlr_texture_from_buffer(struct wlr_renderer *renderer, struct wlr_buffer *buffer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/xwayland/server.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_xwayland_server_options {
		bool lazy;
		bool enable_wm;
		bool no_touch_pointer_emulation;
		bool force_xrandr_emulation;
		int terminate_delay; // in seconds, 0 to terminate immediately
	};
	struct wlr_xwayland_server {
		pid_t pid;
		struct wl_client *client;
		struct wl_event_source *pipe_source;
		int wm_fd[2], wl_fd[2];
		bool ready;
		time_t server_start;
		// Anything above display is reset on Xwayland restart, rest is conserved
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
	struct wlr_xwayland_server *wlr_xwayland_server_create(struct wl_display *display, struct wlr_xwayland_server_options *options);
	void wlr_xwayland_server_destroy(struct wlr_xwayland_server *server);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/xwayland/shell.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	 struct wlr_xwayland_shell_v1 {
		struct wl_global *global;
		struct {
			struct wl_signal destroy;
			struct wl_signal new_surface; // struct wlr_xwayland_surface_v1
		} events;
		// private state
		struct wl_client *client;
		struct wl_list surfaces; // wlr_xwayland_surface_v1.link
		struct wl_listener display_destroy;
		struct wl_listener client_destroy;
	};
	struct wlr_xwayland_surface_v1 {
		struct wlr_surface *surface;
		uint64_t serial;
		// private state
		struct wl_resource *resource;
		struct wl_list link;
		struct wlr_xwayland_shell_v1 *shell;
		bool added;
	};
	struct wlr_xwayland_shell_v1 *wlr_xwayland_shell_v1_create(struct wl_display *display, uint32_t version);
	void wlr_xwayland_shell_v1_destroy(struct wlr_xwayland_shell_v1 *shell);
	void wlr_xwayland_shell_v1_set_client(struct wlr_xwayland_shell_v1 *shell, struct wl_client *client);
	struct wlr_surface *wlr_xwayland_shell_v1_surface_from_serial(struct wlr_xwayland_shell_v1 *shell, uint64_t serial);
	
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/wlr/xwayland/xwayland.h
	/* This an unstable interface of wlroots. No guarantees are made regarding the future consistency of this API. */
	struct wlr_box;
	struct wlr_xwm;
	struct wlr_data_source;
	struct wlr_drag;
	struct wlr_xwayland {
		struct wlr_xwayland_server *server;
		bool own_server;
		struct wlr_xwm *xwm;
		struct wlr_xwayland_shell_v1 *shell_v1;
		struct wlr_xwayland_cursor *cursor;
		const char *display_name;
		struct wl_display *wl_display;
		struct wlr_compositor *compositor;
		struct wlr_seat *seat;
		struct {
			struct wl_signal ready;
			struct wl_signal new_surface; // struct wlr_xwayland_surface
			struct wl_signal remove_startup_info; // struct wlr_xwayland_remove_startup_info_event
		} events;
		int (*user_event_handler)(struct wlr_xwm *xwm, xcb_generic_event_t *event);
		void *data;
		// private state
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
		bool override_redirect;
		char *title;
		char *class;
		char *instance;
		char *role;
		char *startup_id;
		pid_t pid;
		bool has_utf8_title;
		struct wl_list children; // wlr_xwayland_surface.parent_link
		struct wlr_xwayland_surface *parent;
		struct wl_list parent_link; // wlr_xwayland_surface.children
		xcb_atom_t *window_type;
		size_t window_type_len;
		xcb_atom_t *protocols;
		size_t protocols_len;
		uint32_t decorations;
		xcb_icccm_wm_hints_t *hints;
		xcb_size_hints_t *size_hints;
		xcb_ewmh_wm_strut_partial_t *strut_partial;
		bool pinging;
		struct wl_event_source *ping_timer;
		// _NET_WM_STATE
		bool modal;
		bool fullscreen;
		bool maximized_vert, maximized_horz;
		bool minimized;
		bool withdrawn;
		bool has_alpha;
		struct {
			struct wl_signal destroy;
			struct wl_signal request_configure; // struct wlr_xwayland_surface_configure_event
			struct wl_signal request_move;
			struct wl_signal request_resize; // struct wlr_xwayland_resize_event
			struct wl_signal request_minimize; // struct wlr_xwayland_minimize_event
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
			/* can be used to set initial maximized/fullscreen geometry */
			struct wl_signal map_request;
			struct wl_signal ping_timeout;
		} events;
		void *data;
	};
	struct wlr_xwayland_surface_configure_event {
		struct wlr_xwayland_surface *surface;
		int16_t x, y;
		uint16_t width, height;
		uint16_t mask; // xcb_config_window_t
	};
	struct wlr_xwayland_remove_startup_info_event  {
		const char *id;
		xcb_window_t window;
	};
	struct wlr_xwayland_resize_event {
		struct wlr_xwayland_surface *surface;
		uint32_t edges;
	};
	struct wlr_xwayland_minimize_event {
		struct wlr_xwayland_surface *surface;
		bool minimize;
	};
	struct wlr_xwayland *wlr_xwayland_create(struct wl_display *wl_display, struct wlr_compositor *compositor, bool lazy);
	struct wlr_xwayland *wlr_xwayland_create_with_server(struct wl_display *display, struct wlr_compositor *compositor, struct wlr_xwayland_server *server);
	void wlr_xwayland_destroy(struct wlr_xwayland *wlr_xwayland);
	void wlr_xwayland_set_cursor(struct wlr_xwayland *wlr_xwayland, uint8_t *pixels, uint32_t stride, uint32_t width, uint32_t height, int32_t hotspot_x, int32_t hotspot_y);
	void wlr_xwayland_surface_activate(struct wlr_xwayland_surface *surface, bool activated);
	void wlr_xwayland_surface_restack(struct wlr_xwayland_surface *surface, struct wlr_xwayland_surface *sibling, enum xcb_stack_mode_t mode);
	void wlr_xwayland_surface_configure(struct wlr_xwayland_surface *surface, int16_t x, int16_t y, uint16_t width, uint16_t height);
	void wlr_xwayland_surface_close(struct wlr_xwayland_surface *surface);
	void wlr_xwayland_surface_set_withdrawn(struct wlr_xwayland_surface *surface, bool withdrawn);
	void wlr_xwayland_surface_set_minimized(struct wlr_xwayland_surface *surface, bool minimized);
	void wlr_xwayland_surface_set_maximized(struct wlr_xwayland_surface *surface, bool maximized);
	void wlr_xwayland_surface_set_fullscreen(struct wlr_xwayland_surface *surface, bool fullscreen);
	void wlr_xwayland_set_seat(struct wlr_xwayland *xwayland, struct wlr_seat *seat);
	struct wlr_xwayland_surface *wlr_xwayland_surface_try_from_wlr_surface(struct wlr_surface *surface);
	void wlr_xwayland_surface_ping(struct wlr_xwayland_surface *surface);
	bool wlr_xwayland_surface_override_redirect_wants_focus(const struct wlr_xwayland_surface *xsurface);
	enum wlr_xwayland_icccm_input_model wlr_xwayland_surface_icccm_input_model(const struct wlr_xwayland_surface *xsurface);
	void wlr_xwayland_set_workareas(struct wlr_xwayland *wlr_xwayland, const struct wlr_box *workareas, size_t num_workareas);
	xcb_connection_t *wlr_xwayland_get_xwm_connection(struct wlr_xwayland *wlr_xwayland);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/backend/backend.h
	uint32_t backend_get_buffer_caps(struct wlr_backend *backend);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/backend/headless.h
	struct wlr_headless_backend {
		struct wlr_backend backend;
		struct wl_event_loop *event_loop;
		struct wl_list outputs;
		struct wl_listener event_loop_destroy;
		bool started;
	};
	struct wlr_headless_output {
		struct wlr_output wlr_output;
		struct wlr_headless_backend *backend;
		struct wl_list link;
		struct wl_event_source *frame_timer;
		int frame_delay; // ms
	};
	struct wlr_headless_backend *headless_backend_from_backend(struct wlr_backend *wlr_backend);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/backend/libinput.h
	struct wlr_libinput_backend {
		struct wlr_backend backend;
		struct wlr_session *session;
		struct libinput *libinput_context;
		struct wl_event_source *input_event;
		struct wl_listener session_destroy;
		struct wl_listener session_signal;
		struct wl_list devices; // wlr_libinput_device.link
	};
	struct wlr_libinput_input_device {
		struct libinput_device *handle;
		struct wlr_keyboard keyboard;
		struct wlr_pointer pointer;
		struct wlr_switch switch_device;
		struct wlr_touch touch;
		struct wlr_tablet tablet;
		struct wl_list tablet_tools; // see backend/libinput/tablet_tool.c
		struct wlr_tablet_pad tablet_pad;
		struct wl_list link;
	};
	uint32_t usec_to_msec(uint64_t usec);
	void handle_libinput_event(struct wlr_libinput_backend *state, struct libinput_event *event);
	void destroy_libinput_input_device(struct wlr_libinput_input_device *dev);
	const char *get_libinput_device_name(struct libinput_device *device);
	extern const struct wlr_keyboard_impl libinput_keyboard_impl;
	extern const struct wlr_pointer_impl libinput_pointer_impl;
	extern const struct wlr_switch_impl libinput_switch_impl;
	extern const struct wlr_tablet_impl libinput_tablet_impl;
	extern const struct wlr_tablet_pad_impl libinput_tablet_pad_impl;
	extern const struct wlr_touch_impl libinput_touch_impl;
	void init_device_keyboard(struct wlr_libinput_input_device *dev);
	struct wlr_libinput_input_device *device_from_keyboard(struct wlr_keyboard *kb);
	void handle_keyboard_key(struct libinput_event *event, struct wlr_keyboard *kb);
	void init_device_pointer(struct wlr_libinput_input_device *dev);
	struct wlr_libinput_input_device *device_from_pointer(struct wlr_pointer *kb);
	void handle_pointer_motion(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_motion_abs(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_button(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_axis(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_axis_value120(struct libinput_event *event, struct wlr_pointer *pointer, enum wl_pointer_axis_source source);
	void handle_pointer_swipe_begin(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_swipe_update(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_swipe_end(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_pinch_begin(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_pinch_update(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_pinch_end(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_hold_begin(struct libinput_event *event, struct wlr_pointer *pointer);
	void handle_pointer_hold_end(struct libinput_event *event, struct wlr_pointer *pointer);
	void init_device_switch(struct wlr_libinput_input_device *dev);
	struct wlr_libinput_input_device *device_from_switch(struct wlr_switch *switch_device);
	void handle_switch_toggle(struct libinput_event *event, struct wlr_switch *switch_device);
	void init_device_touch(struct wlr_libinput_input_device *dev);
	struct wlr_libinput_input_device *device_from_touch(struct wlr_touch *touch);
	void handle_touch_down(struct libinput_event *event, struct wlr_touch *touch);
	void handle_touch_up(struct libinput_event *event, struct wlr_touch *touch);
	void handle_touch_motion(struct libinput_event *event, struct wlr_touch *touch);
	void handle_touch_cancel(struct libinput_event *event, struct wlr_touch *touch);
	void handle_touch_frame(struct libinput_event *event, struct wlr_touch *touch);
	void init_device_tablet(struct wlr_libinput_input_device *dev);
	void finish_device_tablet(struct wlr_libinput_input_device *dev);
	struct wlr_libinput_input_device *device_from_tablet(struct wlr_tablet *tablet);
	void handle_tablet_tool_axis(struct libinput_event *event, struct wlr_tablet *tablet);
	void handle_tablet_tool_proximity(struct libinput_event *event, struct wlr_tablet *tablet);
	void handle_tablet_tool_tip(struct libinput_event *event, struct wlr_tablet *tablet);
	void handle_tablet_tool_button(struct libinput_event *event, struct wlr_tablet *tablet);
	void init_device_tablet_pad(struct wlr_libinput_input_device *dev);
	void finish_device_tablet_pad(struct wlr_libinput_input_device *dev);
	struct wlr_libinput_input_device *device_from_tablet_pad(struct wlr_tablet_pad *tablet_pad);
	void handle_tablet_pad_button(struct libinput_event *event, struct wlr_tablet_pad *tablet_pad);
	void handle_tablet_pad_ring(struct libinput_event *event, struct wlr_tablet_pad *tablet_pad);
	void handle_tablet_pad_strip(struct libinput_event *event, struct wlr_tablet_pad *tablet_pad);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/backend/multi.h
	struct wlr_multi_backend {
		struct wlr_backend backend;
		struct wl_list backends;
		struct wl_listener event_loop_destroy;
		struct {
			struct wl_signal backend_add;
			struct wl_signal backend_remove;
		} events;
	};
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/backend/wayland.h
	struct wlr_wl_backend {
		struct wlr_backend backend;
		/* local state */
		bool started;
		struct wl_event_loop *event_loop;
		struct wl_list outputs;
		int drm_fd;
		struct wl_list buffers; // wlr_wl_buffer.link
		size_t requested_outputs;
		struct wl_listener event_loop_destroy;
		char *activation_token;
		/* remote state */
		struct wl_display *remote_display;
		bool own_remote_display;
		struct wl_event_source *remote_display_src;
		struct wl_registry *registry;
		struct wl_compositor *compositor;
		struct xdg_wm_base *xdg_wm_base;
		struct zxdg_decoration_manager_v1 *zxdg_decoration_manager_v1;
		struct zwp_pointer_gestures_v1 *zwp_pointer_gestures_v1;
		struct wp_presentation *presentation;
		struct wl_shm *shm;
		struct zwp_linux_dmabuf_v1 *zwp_linux_dmabuf_v1;
		struct zwp_relative_pointer_manager_v1 *zwp_relative_pointer_manager_v1;
		struct wl_list seats; // wlr_wl_seat.link
		struct zwp_tablet_manager_v2 *tablet_manager;
		struct wlr_drm_format_set shm_formats;
		struct wlr_drm_format_set linux_dmabuf_v1_formats;
		struct wl_drm *legacy_drm;
		struct xdg_activation_v1 *activation_v1;
		struct wl_subcompositor *subcompositor;
		struct wp_viewporter *viewporter;
		char *drm_render_name;
	};
	struct wlr_wl_buffer {
		struct wlr_buffer *buffer;
		struct wl_buffer *wl_buffer;
		bool released;
		struct wl_list link; // wlr_wl_backend.buffers
		struct wl_listener buffer_destroy;
	};
	struct wlr_wl_presentation_feedback {
		struct wlr_wl_output *output;
		struct wl_list link;
		struct wp_presentation_feedback *feedback;
		uint32_t commit_seq;
	};
	struct wlr_wl_output_layer {
		struct wlr_addon addon;
		struct wl_surface *surface;
		struct wl_subsurface *subsurface;
		struct wp_viewport *viewport;
		bool mapped;
	};
	struct wlr_wl_output {
		struct wlr_output wlr_output;
		struct wlr_wl_backend *backend;
		struct wl_list link;
		struct wl_surface *surface;
		bool own_surface;
		struct wl_callback *frame_callback;
		struct xdg_surface *xdg_surface;
		struct xdg_toplevel *xdg_toplevel;
		struct zxdg_toplevel_decoration_v1 *zxdg_toplevel_decoration_v1;
		struct wl_list presentation_feedbacks;
		char *title;
		char *app_id;
		int32_t requested_width, requested_height; // 0 if not requested
		uint32_t configure_serial;
		bool has_configure_serial;
		bool configured;
		bool initialized;
		// If not NULL, the host compositor hasn't acknowledged the unmapping yet;
		// ignore all configure events
		struct wl_callback *unmap_callback;
		uint32_t enter_serial;
		struct {
			struct wlr_wl_pointer *pointer;
			struct wl_surface *surface;
			int32_t hotspot_x, hotspot_y;
		} cursor;
	};
	struct wlr_wl_pointer {
		struct wlr_pointer wlr_pointer;
		struct wlr_wl_seat *seat;
		struct wlr_wl_output *output;
		enum wl_pointer_axis_source axis_source;
		int32_t axis_discrete;
		uint32_t fingers; // trackpad gesture
		enum wl_pointer_axis_relative_direction axis_relative_direction;
		struct wl_listener output_destroy;
		struct wl_list link;
	};
	struct wlr_wl_touch_points {
		int32_t ids[64];
		size_t len;
	};
	struct wlr_wl_seat {
		char *name;
		struct wl_seat *wl_seat;
		uint32_t global_name;
		struct wlr_wl_backend *backend;
		struct wl_keyboard *wl_keyboard;
		struct wlr_keyboard wlr_keyboard;
		struct wl_pointer *wl_pointer;
		struct wlr_wl_pointer *active_pointer;
		struct wl_list pointers; // wlr_wl_pointer.link
		struct zwp_pointer_gesture_swipe_v1 *gesture_swipe;
		struct zwp_pointer_gesture_pinch_v1 *gesture_pinch;
		struct zwp_pointer_gesture_hold_v1 *gesture_hold;
		struct zwp_relative_pointer_v1 *relative_pointer;
		struct wl_touch *wl_touch;
		struct wlr_touch wlr_touch;
		struct wlr_wl_touch_points touch_points;
		struct zwp_tablet_seat_v2 *zwp_tablet_seat_v2;
		struct zwp_tablet_v2 *zwp_tablet_v2;
		struct wlr_tablet wlr_tablet;
		struct zwp_tablet_tool_v2 *zwp_tablet_tool_v2;
		struct wlr_tablet_tool wlr_tablet_tool;
		struct zwp_tablet_pad_v2 *zwp_tablet_pad_v2;
		struct wlr_tablet_pad wlr_tablet_pad;
		struct wl_list link; // wlr_wl_backend.seats
	};
	struct wlr_wl_backend *get_wl_backend_from_backend(struct wlr_backend *backend);
	struct wlr_wl_output *get_wl_output_from_surface(struct wlr_wl_backend *wl, struct wl_surface *surface);
	void update_wl_output_cursor(struct wlr_wl_output *output);
	void init_seat_keyboard(struct wlr_wl_seat *seat);
	void init_seat_pointer(struct wlr_wl_seat *seat);
	void finish_seat_pointer(struct wlr_wl_seat *seat);
	void create_pointer(struct wlr_wl_seat *seat, struct wlr_wl_output *output);
	void init_seat_touch(struct wlr_wl_seat *seat);
	void init_seat_tablet(struct wlr_wl_seat *seat);
	void finish_seat_tablet(struct wlr_wl_seat *seat);
	bool create_wl_seat(struct wl_seat *wl_seat, struct wlr_wl_backend *wl, uint32_t global_name);
	void destroy_wl_seat(struct wlr_wl_seat *seat);
	void destroy_wl_buffer(struct wlr_wl_buffer *buffer);
	extern const struct wlr_pointer_impl wl_pointer_impl;
	extern const struct wlr_tablet_pad_impl wl_tablet_pad_impl;
	extern const struct wlr_tablet_impl wl_tablet_impl;
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/backend/x11.h
	struct wlr_x11_backend;
	struct wlr_x11_output {
		struct wlr_output wlr_output;
		struct wlr_x11_backend *x11;
		struct wl_list link; // wlr_x11_backend.outputs
		xcb_window_t win;
		xcb_present_event_t present_event_id;
		int32_t win_width, win_height;
		struct wlr_pointer pointer;
		struct wlr_touch touch;
		struct wl_list touchpoints; // wlr_x11_touchpoint.link
		struct wl_list buffers; // wlr_x11_buffer.link
		pixman_region32_t exposed;
		uint64_t last_msc;
		struct {
			struct wlr_swapchain *swapchain;
			xcb_render_picture_t pic;
		} cursor;
	};
	struct wlr_x11_touchpoint {
		uint32_t x11_id;
		int wayland_id;
		struct wl_list link; // wlr_x11_output.touch_points
	};
	struct wlr_x11_backend {
		struct wlr_backend backend;
		struct wl_event_loop *event_loop;
		bool started;
		xcb_connection_t *xcb;
		xcb_screen_t *screen;
		xcb_depth_t *depth;
		xcb_visualid_t visualid;
		xcb_colormap_t colormap;
		xcb_cursor_t transparent_cursor;
		xcb_render_pictformat_t argb32;
		bool have_shm;
		bool have_dri3;
		uint32_t dri3_major_version, dri3_minor_version;
		size_t requested_outputs;
		struct wl_list outputs; // wlr_x11_output.link
		struct wlr_keyboard keyboard;
		int drm_fd;
		struct wlr_drm_format_set dri3_formats;
		struct wlr_drm_format_set shm_formats;
		const struct wlr_x11_format *x11_format;
		struct wlr_drm_format_set primary_dri3_formats;
		struct wlr_drm_format_set primary_shm_formats;
		struct wl_event_source *event_source;
		struct {
			xcb_atom_t wm_protocols;
			xcb_atom_t wm_delete_window;
			xcb_atom_t net_wm_name;
			xcb_atom_t utf8_string;
			xcb_atom_t variable_refresh;
		} atoms;
		// The time we last received an event
		xcb_timestamp_t time;
		// #if HAVE_XCB_ERRORS
		xcb_errors_context_t *errors_context;
		// #endif
		uint8_t present_opcode;
		uint8_t xinput_opcode;
		struct wl_listener event_loop_destroy;
	};
	struct wlr_x11_buffer {
		struct wlr_x11_backend *x11;
		struct wlr_buffer *buffer;
		xcb_pixmap_t pixmap;
		struct wl_list link; // wlr_x11_output.buffers
		struct wl_listener buffer_destroy;
		size_t n_busy;
	};
	struct wlr_x11_format {
		uint32_t drm;
		uint8_t depth, bpp;
	};
	struct wlr_x11_backend *get_x11_backend_from_backend(struct wlr_backend *wlr_backend);
	struct wlr_x11_output *get_x11_output_from_window_id(struct wlr_x11_backend *x11, xcb_window_t window);
	extern const struct wlr_keyboard_impl x11_keyboard_impl;
	extern const struct wlr_pointer_impl x11_pointer_impl;
	extern const struct wlr_touch_impl x11_touch_impl;
	void handle_x11_xinput_event(struct wlr_x11_backend *x11, xcb_ge_generic_event_t *event);
	void update_x11_pointer_position(struct wlr_x11_output *output, xcb_timestamp_t time);
	void handle_x11_configure_notify(struct wlr_x11_output *output, xcb_configure_notify_event_t *event);
	void handle_x11_present_event(struct wlr_x11_backend *x11, xcb_ge_generic_event_t *event);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/interfaces/wlr_input_device.h
	void wlr_input_device_init(struct wlr_input_device *wlr_device, enum wlr_input_device_type type, const char *name);
	void wlr_input_device_finish(struct wlr_input_device *wlr_device);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/allocator/allocator.h
	struct wlr_allocator *allocator_autocreate_with_drm_fd(uint32_t backend_caps, struct wlr_renderer *renderer, int drm_fd);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/allocator/drm_dumb.h
	struct wlr_drm_dumb_buffer {
		struct wlr_buffer base;
		struct wl_list link; // wlr_drm_dumb_allocator.buffers
		int drm_fd; // -1 if the allocator has been destroyed
		struct wlr_dmabuf_attributes dmabuf;
		uint32_t format;
		uint32_t handle;
		uint32_t stride;
		uint32_t width, height;
		uint64_t size;
		void *data;
	};
	struct wlr_drm_dumb_allocator {
		struct wlr_allocator base;
		struct wl_list buffers; // wlr_drm_dumb_buffer.link
		int drm_fd;
	};
	struct wlr_allocator *wlr_drm_dumb_allocator_create(int fd);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/allocator/gbm.h
	struct wlr_gbm_buffer {
		struct wlr_buffer base;
		struct wl_list link; // wlr_gbm_allocator.buffers
		struct gbm_bo *gbm_bo; // NULL if the gbm_device has been destroyed
		struct wlr_dmabuf_attributes dmabuf;
	};
	struct wlr_gbm_allocator {
		struct wlr_allocator base;
		int fd;
		struct gbm_device *gbm_device;
		struct wl_list buffers; // wlr_gbm_buffer.link
	};
	struct wlr_allocator *wlr_gbm_allocator_create(int drm_fd);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/allocator/shm.h
	struct wlr_shm_buffer {
		struct wlr_buffer base;
		struct wlr_shm_attributes shm;
		void *data;
		size_t size;
	};
	struct wlr_shm_allocator {
		struct wlr_allocator base;
	};
	struct wlr_allocator *wlr_shm_allocator_create(void);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/color.h
	struct wlr_color_transform_lut3d {
		float *lut_3d;
		size_t dim_len;
	};
	enum wlr_color_transform_type {
		COLOR_TRANSFORM_SRGB,
		COLOR_TRANSFORM_LUT_3D,
	};
	struct wlr_color_transform {
		int ref_count;
		struct wlr_addon_set addons; // per-renderer helper state
		enum wlr_color_transform_type type;
		struct wlr_color_transform_lut3d lut3d;
	};
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/dmabuf.h
	bool dmabuf_check_sync_file_import_export(void);
	bool dmabuf_import_sync_file(int dmabuf_fd, uint32_t flags, int sync_file_fd);
	int dmabuf_export_sync_file(int dmabuf_fd, uint32_t flags);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/drm_format_set.h
	void wlr_drm_format_init(struct wlr_drm_format *fmt, uint32_t format);
	bool wlr_drm_format_has(const struct wlr_drm_format *fmt, uint64_t modifier);
	bool wlr_drm_format_add(struct wlr_drm_format *fmt, uint64_t modifier);
	bool wlr_drm_format_copy(struct wlr_drm_format *dst, const struct wlr_drm_format *src);
	bool wlr_drm_format_intersect(struct wlr_drm_format *dst, const struct wlr_drm_format *a, const struct wlr_drm_format *b);
	bool wlr_drm_format_set_copy(struct wlr_drm_format_set *dst, const struct wlr_drm_format_set *src);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/egl.h
	struct wlr_egl {
		EGLDisplay display;
		EGLContext context;
		EGLDeviceEXT device; // may be EGL_NO_DEVICE_EXT
		struct gbm_device *gbm_device;
		struct {
			// Display extensions
			bool KHR_image_base;
			bool EXT_image_dma_buf_import;
			bool EXT_image_dma_buf_import_modifiers;
			bool IMG_context_priority;
			bool EXT_create_context_robustness;
			// Device extensions
			bool EXT_device_drm;
			bool EXT_device_drm_render_node;
			// Client extensions
			bool EXT_device_query;
			bool KHR_platform_gbm;
			bool EXT_platform_device;
			bool KHR_display_reference;
		} exts;
		struct {
			PFNEGLGETPLATFORMDISPLAYEXTPROC eglGetPlatformDisplayEXT;
			PFNEGLCREATEIMAGEKHRPROC eglCreateImageKHR;
			PFNEGLDESTROYIMAGEKHRPROC eglDestroyImageKHR;
			PFNEGLQUERYDMABUFFORMATSEXTPROC eglQueryDmaBufFormatsEXT;
			PFNEGLQUERYDMABUFMODIFIERSEXTPROC eglQueryDmaBufModifiersEXT;
			PFNEGLDEBUGMESSAGECONTROLKHRPROC eglDebugMessageControlKHR;
			PFNEGLQUERYDISPLAYATTRIBEXTPROC eglQueryDisplayAttribEXT;
			PFNEGLQUERYDEVICESTRINGEXTPROC eglQueryDeviceStringEXT;
			PFNEGLQUERYDEVICESEXTPROC eglQueryDevicesEXT;
		} procs;
		bool has_modifiers;
		struct wlr_drm_format_set dmabuf_texture_formats;
		struct wlr_drm_format_set dmabuf_render_formats;
	};
	struct wlr_egl_context {
		EGLDisplay display;
		EGLContext context;
		EGLSurface draw_surface;
		EGLSurface read_surface;
	};
	struct wlr_egl *wlr_egl_create_with_drm_fd(int drm_fd);
	void wlr_egl_destroy(struct wlr_egl *egl);
	EGLImageKHR wlr_egl_create_image_from_dmabuf(struct wlr_egl *egl, struct wlr_dmabuf_attributes *attributes, bool *external_only);
	const struct wlr_drm_format_set *wlr_egl_get_dmabuf_texture_formats(struct wlr_egl *egl);
	const struct wlr_drm_format_set *wlr_egl_get_dmabuf_render_formats(struct wlr_egl *egl);
	bool wlr_egl_destroy_image(struct wlr_egl *egl, EGLImageKHR image);
	int wlr_egl_dup_drm_fd(struct wlr_egl *egl);
	bool wlr_egl_restore_context(struct wlr_egl_context *context);
	bool wlr_egl_make_current(struct wlr_egl *egl, struct wlr_egl_context *save_context);
	bool wlr_egl_unset_current(struct wlr_egl *egl);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/gles2.h
	// mesa ships old GL headers that don't include this type, so for distros that use headers from
	// mesa we need to def it ourselves until they update.
	// https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/23144
	typedef void (*PFNGLGETINTEGER64VEXTPROC)(GLenum pname, GLint64 *data);
	struct wlr_gles2_pixel_format {
		uint32_t drm_format;
		// optional field, if empty then internalformat = format
		GLint gl_internalformat;
		GLint gl_format, gl_type;
	};
	struct wlr_gles2_tex_shader {
		GLuint program;
		GLint proj;
		GLint tex_proj;
		GLint tex;
		GLint alpha;
		GLint pos_attrib;
	};
	struct wlr_gles2_renderer {
		struct wlr_renderer wlr_renderer;
		struct wlr_egl *egl;
		int drm_fd;
		struct wlr_drm_format_set shm_texture_formats;
		const char *exts_str;
		struct {
			bool EXT_read_format_bgra;
			bool KHR_debug;
			bool OES_egl_image_external;
			bool OES_egl_image;
			bool EXT_texture_type_2_10_10_10_REV;
			bool OES_texture_half_float_linear;
			bool EXT_texture_norm16;
			bool EXT_disjoint_timer_query;
		} exts;
		struct {
			PFNGLEGLIMAGETARGETTEXTURE2DOESPROC glEGLImageTargetTexture2DOES;
			PFNGLDEBUGMESSAGECALLBACKKHRPROC glDebugMessageCallbackKHR;
			PFNGLDEBUGMESSAGECONTROLKHRPROC glDebugMessageControlKHR;
			PFNGLPOPDEBUGGROUPKHRPROC glPopDebugGroupKHR;
			PFNGLPUSHDEBUGGROUPKHRPROC glPushDebugGroupKHR;
			PFNGLEGLIMAGETARGETRENDERBUFFERSTORAGEOESPROC glEGLImageTargetRenderbufferStorageOES;
			PFNGLGETGRAPHICSRESETSTATUSKHRPROC glGetGraphicsResetStatusKHR;
			PFNGLGENQUERIESEXTPROC glGenQueriesEXT;
			PFNGLDELETEQUERIESEXTPROC glDeleteQueriesEXT;
			PFNGLQUERYCOUNTEREXTPROC glQueryCounterEXT;
			PFNGLGETQUERYOBJECTIVEXTPROC glGetQueryObjectivEXT;
			PFNGLGETQUERYOBJECTUI64VEXTPROC glGetQueryObjectui64vEXT;
			PFNGLGETINTEGER64VEXTPROC glGetInteger64vEXT;
		} procs;
		struct {
			struct {
				GLuint program;
				GLint proj;
				GLint color;
				GLint pos_attrib;
			} quad;
			struct wlr_gles2_tex_shader tex_rgba;
			struct wlr_gles2_tex_shader tex_rgbx;
			struct wlr_gles2_tex_shader tex_ext;
		} shaders;
		struct wl_list buffers; // wlr_gles2_buffer.link
		struct wl_list textures; // wlr_gles2_texture.link
	};
	struct wlr_gles2_render_timer {
		struct wlr_render_timer base;
		struct wlr_gles2_renderer *renderer;
		struct timespec cpu_start;
		struct timespec cpu_end;
		GLuint id;
		GLint64 gl_cpu_end;
	};
	struct wlr_gles2_buffer {
		struct wlr_buffer *buffer;
		struct wlr_gles2_renderer *renderer;
		struct wl_list link; // wlr_gles2_renderer.buffers
		bool external_only;
		EGLImageKHR image;
		GLuint rbo;
		GLuint fbo;
		GLuint tex;
		struct wlr_addon addon;
	};
	struct wlr_gles2_texture {
		struct wlr_texture wlr_texture;
		struct wlr_gles2_renderer *renderer;
		struct wl_list link; // wlr_gles2_renderer.textures
		GLenum target;
		// If this texture is imported from a buffer, the texture is does not own
		// these states. These cannot be destroyed along with the texture in this
		// case.
		GLuint tex;
		GLuint fbo;
		bool has_alpha;
		uint32_t drm_format; // for mutable textures only, used to interpret upload data
		struct wlr_gles2_buffer *buffer; // for DMA-BUF imports only
	};
	struct wlr_gles2_render_pass {
		struct wlr_render_pass base;
		struct wlr_gles2_buffer *buffer;
		float projection_matrix[9];
		struct wlr_egl_context prev_ctx;
		struct wlr_gles2_render_timer *timer;
	};
	bool is_gles2_pixel_format_supported(const struct wlr_gles2_renderer *renderer, const struct wlr_gles2_pixel_format *format);
	const struct wlr_gles2_pixel_format *get_gles2_format_from_drm(uint32_t fmt);
	const struct wlr_gles2_pixel_format *get_gles2_format_from_gl(GLint gl_format, GLint gl_type, bool alpha);
	void get_gles2_shm_formats(const struct wlr_gles2_renderer *renderer, struct wlr_drm_format_set *out);
	GLuint gles2_buffer_get_fbo(struct wlr_gles2_buffer *buffer);
	struct wlr_gles2_renderer *gles2_get_renderer(struct wlr_renderer *wlr_renderer);
	struct wlr_gles2_render_timer *gles2_get_render_timer(struct wlr_render_timer *timer);
	struct wlr_gles2_texture *gles2_get_texture(		struct wlr_texture *wlr_texture);
	struct wlr_gles2_buffer *gles2_buffer_get_or_create(struct wlr_gles2_renderer *renderer, struct wlr_buffer *wlr_buffer);
	struct wlr_texture *gles2_texture_from_buffer(struct wlr_renderer *wlr_renderer, struct wlr_buffer *buffer);
	void gles2_texture_destroy(struct wlr_gles2_texture *texture);
	void push_gles2_debug_(struct wlr_gles2_renderer *renderer, const char *file, const char *func);
	void pop_gles2_debug(struct wlr_gles2_renderer *renderer);
	struct wlr_gles2_render_pass *begin_gles2_buffer_pass(struct wlr_gles2_buffer *buffer, struct wlr_egl_context *prev_ctx, struct wlr_gles2_render_timer *timer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/pixel_format.h
	struct wlr_pixel_format_info {
		uint32_t drm_format;
		uint32_t opaque_substitute;
		uint32_t bytes_per_block;
		uint32_t block_width, block_height;
	};
	const struct wlr_pixel_format_info *drm_get_pixel_format_info(uint32_t fmt);
	uint32_t pixel_format_info_pixels_per_block(const struct wlr_pixel_format_info *info);
	int32_t pixel_format_info_min_stride(const struct wlr_pixel_format_info *info, int32_t width);
	bool pixel_format_info_check_stride(const struct wlr_pixel_format_info *info, int32_t stride, int32_t width);
	uint32_t convert_wl_shm_format_to_drm(enum wl_shm_format fmt);
	enum wl_shm_format convert_drm_format_to_wl_shm(uint32_t fmt);
	bool pixel_format_has_alpha(uint32_t fmt);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/pixman.h
	struct wlr_pixman_pixel_format {
		uint32_t drm_format;
		pixman_format_code_t pixman_format;
	};
	struct wlr_pixman_buffer;
	struct wlr_pixman_renderer {
		struct wlr_renderer wlr_renderer;
		struct wl_list buffers; // wlr_pixman_buffer.link
		struct wl_list textures; // wlr_pixman_texture.link
		struct wlr_drm_format_set drm_formats;
	};
	struct wlr_pixman_buffer {
		struct wlr_buffer *buffer;
		struct wlr_pixman_renderer *renderer;
		pixman_image_t *image;
		struct wl_listener buffer_destroy;
		struct wl_list link; // wlr_pixman_renderer.buffers
	};
	struct wlr_pixman_texture {
		struct wlr_texture wlr_texture;
		struct wlr_pixman_renderer *renderer;
		struct wl_list link; // wlr_pixman_renderer.textures
		pixman_image_t *image;
		pixman_format_code_t format;
		const struct wlr_pixel_format_info *format_info;
		void *data; // if created via texture_from_pixels
		struct wlr_buffer *buffer; // if created via texture_from_buffer
	};
	struct wlr_pixman_render_pass {
		struct wlr_render_pass base;
		struct wlr_pixman_buffer *buffer;
	};
	pixman_format_code_t get_pixman_format_from_drm(uint32_t fmt);
	uint32_t get_drm_format_from_pixman(pixman_format_code_t fmt);
	const uint32_t *get_pixman_drm_formats(size_t *len);
	bool begin_pixman_data_ptr_access(struct wlr_buffer *buffer, pixman_image_t **image_ptr, uint32_t flags);
	struct wlr_pixman_render_pass *begin_pixman_render_pass(struct wlr_pixman_buffer *buffer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/vulkan.h
	struct wlr_vk_descriptor_pool;
	struct wlr_vk_texture;
	struct wlr_vk_instance {
		VkInstance instance;
		VkDebugUtilsMessengerEXT messenger;
		struct {
			// FIXME:
			void */*PFN_vkCreateDebugUtilsMessengerEXT*/ createDebugUtilsMessengerEXT;
			void */*PFN_vkDestroyDebugUtilsMessengerEXT*/ destroyDebugUtilsMessengerEXT;
		} api;
	};
	struct wlr_vk_instance *vulkan_instance_create(bool debug);
	void vulkan_instance_destroy(struct wlr_vk_instance *ini);
	// Logical vulkan device state.
	struct wlr_vk_device {
		struct wlr_vk_instance *instance;
		VkPhysicalDevice phdev;
		VkDevice dev;
		int drm_fd;
		bool implicit_sync_interop;
		bool sampler_ycbcr_conversion;
		// we only ever need one queue for rendering and transfer commands
		uint32_t queue_family;
		VkQueue queue;
		struct {
			// FIXME:
			void */*PFN_vkGetMemoryFdPropertiesKHR*/ vkGetMemoryFdPropertiesKHR;
			void */*PFN_vkWaitSemaphoresKHR*/ vkWaitSemaphoresKHR;
			void */*PFN_vkGetSemaphoreCounterValueKHR*/ vkGetSemaphoreCounterValueKHR;
			void */*PFN_vkGetSemaphoreFdKHR*/ vkGetSemaphoreFdKHR;
			void */*PFN_vkImportSemaphoreFdKHR*/ vkImportSemaphoreFdKHR;
			void */*PFN_vkQueueSubmit2KHR*/ vkQueueSubmit2KHR;
		} api;
		uint32_t format_prop_count;
		struct wlr_vk_format_props *format_props;
		struct wlr_drm_format_set dmabuf_render_formats;
		struct wlr_drm_format_set dmabuf_texture_formats;
		struct wlr_drm_format_set shm_texture_formats;
	};
	VkPhysicalDevice vulkan_find_drm_phdev(struct wlr_vk_instance *ini, int drm_fd);
	int vulkan_open_phdev_drm_fd(VkPhysicalDevice phdev);
	struct wlr_vk_device *vulkan_device_create(struct wlr_vk_instance *ini, VkPhysicalDevice phdev);
	void vulkan_device_destroy(struct wlr_vk_device *dev);
	int vulkan_find_mem_type(struct wlr_vk_device *device, VkMemoryPropertyFlags flags, uint32_t req_bits);
	struct wlr_vk_format {
		uint32_t drm;
		VkFormat vk;
		VkFormat vk_srgb; // sRGB version of the format, or 0 if nonexistent
		bool is_ycbcr;
	};
	extern const VkImageUsageFlags vulkan_render_usage, vulkan_shm_tex_usage, vulkan_dma_tex_usage;
	const struct wlr_vk_format *vulkan_get_format_list(size_t *len);
	const struct wlr_vk_format *vulkan_get_format_from_drm(uint32_t drm_format);
	struct wlr_vk_format_modifier_props {
		VkDrmFormatModifierPropertiesEXT props;
		VkExtent2D max_extent;
		bool has_mutable_srgb;
	};
	struct wlr_vk_format_props {
		struct wlr_vk_format format;
		struct {
			VkExtent2D max_extent;
			VkFormatFeatureFlags features;
			bool has_mutable_srgb;
		} shm;
		struct {
			uint32_t render_mod_count;
			struct wlr_vk_format_modifier_props *render_mods;
			uint32_t texture_mod_count;
			struct wlr_vk_format_modifier_props *texture_mods;
		} dmabuf;
	};
	void vulkan_format_props_query(struct wlr_vk_device *dev, const struct wlr_vk_format *format);
	const struct wlr_vk_format_modifier_props *vulkan_format_props_find_modifier(const struct wlr_vk_format_props *props, uint64_t mod, bool render);
	void vulkan_format_props_finish(struct wlr_vk_format_props *props);
	struct wlr_vk_pipeline_layout_key {
		const struct wlr_vk_format *ycbcr_format;
		enum wlr_scale_filter_mode filter_mode;
	};
	struct wlr_vk_pipeline_layout {
		struct wlr_vk_pipeline_layout_key key;
		VkPipelineLayout vk;
		VkDescriptorSetLayout ds;
		VkSampler sampler;
		// for YCbCr pipelines only
		struct {
			VkSamplerYcbcrConversion conversion;
			VkFormat format;
		} ycbcr;
		struct wl_list link; // struct wlr_vk_renderer.pipeline_layouts
	};
	enum wlr_vk_texture_transform {
		WLR_VK_TEXTURE_TRANSFORM_IDENTITY = 0,
		WLR_VK_TEXTURE_TRANSFORM_SRGB = 1,
	};
	enum wlr_vk_shader_source {
		WLR_VK_SHADER_SOURCE_TEXTURE,
		WLR_VK_SHADER_SOURCE_SINGLE_COLOR,
	};
	enum wlr_vk_output_transform {
		WLR_VK_OUTPUT_TRANSFORM_INVERSE_SRGB = 0,
		WLR_VK_OUTPUT_TRANSFORM_LUT3D = 1,
	};
	struct wlr_vk_pipeline_key {
		struct wlr_vk_pipeline_layout_key layout;
		enum wlr_vk_shader_source source;
		enum wlr_render_blend_mode blend_mode;
		// only used if source is texture
		enum wlr_vk_texture_transform texture_transform;
	};
	struct wlr_vk_pipeline {
		struct wlr_vk_pipeline_key key;
		VkPipeline vk;
		const struct wlr_vk_pipeline_layout *layout;
		struct wlr_vk_render_format_setup *setup;
		struct wl_list link; // struct wlr_vk_render_format_setup
	};
	struct wlr_vk_render_format_setup {
		struct wl_list link; // wlr_vk_renderer.render_format_setups
		const struct wlr_vk_format *render_format; // used in renderpass
		bool use_blending_buffer;
		VkRenderPass render_pass;
		VkPipeline output_pipe_srgb;
		VkPipeline output_pipe_lut3d;
		struct wlr_vk_renderer *renderer;
		struct wl_list pipelines; // struct wlr_vk_pipeline.link
	};
	struct wlr_vk_render_buffer {
		struct wlr_buffer *wlr_buffer;
		struct wlr_addon addon;
		struct wlr_vk_renderer *renderer;
		struct wl_list link; // wlr_vk_renderer.buffers
		VkDeviceMemory memories[4 /* WLR_DMABUF_MAX_PLANES */];
		uint32_t mem_count;
		VkImage image;
		struct {
			struct wlr_vk_render_format_setup *render_setup;
			VkImageView image_view;
			VkFramebuffer framebuffer;
			bool transitioned;
		} srgb;
		struct {
			struct wlr_vk_render_format_setup *render_setup;
			VkImageView image_view;
			VkFramebuffer framebuffer;
			bool transitioned;
			VkImage blend_image;
			VkImageView blend_image_view;
			VkDeviceMemory blend_memory;
			VkDescriptorSet blend_descriptor_set;
			struct wlr_vk_descriptor_pool *blend_attachment_pool;
			bool blend_transitioned;
		} plain;
	};
	bool vulkan_setup_plain_framebuffer(struct wlr_vk_render_buffer *buffer, const struct wlr_dmabuf_attributes *dmabuf);
	struct wlr_vk_command_buffer {
		VkCommandBuffer vk;
		bool recording;
		uint64_t timeline_point;
		struct wl_list destroy_textures; // wlr_vk_texture.destroy_link
		struct wl_list stage_buffers; // wlr_vk_shared_buffer.link
		struct wlr_color_transform *color_transform;
		VkSemaphore binary_semaphore;
	};
	// Vulkan wlr_renderer implementation on top of a wlr_vk_device.
	struct wlr_vk_renderer {
		struct wlr_renderer wlr_renderer;
		struct wlr_backend *backend;
		struct wlr_vk_device *dev;
		VkCommandPool command_pool;
		VkShaderModule vert_module;
		VkShaderModule tex_frag_module;
		VkShaderModule quad_frag_module;
		VkShaderModule output_module;
		struct wl_list pipeline_layouts; // struct wlr_vk_pipeline_layout.link
		// for blend->output subpass
		VkPipelineLayout output_pipe_layout;
		VkDescriptorSetLayout output_ds_srgb_layout;
		VkDescriptorSetLayout output_ds_lut3d_layout;
		VkSampler output_sampler_lut3d;
		// descriptor set indicating dummy 1x1x1 image, for use in the lut3d slot
		VkDescriptorSet output_ds_lut3d_dummy;
		struct wlr_vk_descriptor_pool *output_ds_lut3d_dummy_pool;
		size_t last_output_pool_size;
		struct wl_list output_descriptor_pools; // wlr_vk_descriptor_pool.link
		// dummy sampler to bind when output shader is not using a lookup table
		VkImage dummy3d_image;
		VkDeviceMemory dummy3d_mem;
		VkImageView dummy3d_image_view;
		bool dummy3d_image_transitioned;
		VkSemaphore timeline_semaphore;
		uint64_t timeline_point;
		size_t last_pool_size;
		struct wl_list descriptor_pools; // wlr_vk_descriptor_pool.link
		struct wl_list render_format_setups; // wlr_vk_render_format_setup.link
		struct wl_list textures; // wlr_vk_texture.link
		// Textures to return to foreign queue
		struct wl_list foreign_textures; // wlr_vk_texture.foreign_link
		struct wl_list render_buffers; // wlr_vk_render_buffer.link
		struct wl_list color_transforms; // wlr_vk_color_transform.link
		// Pool of command buffers
		struct wlr_vk_command_buffer command_buffers[64 /*VULKAN_COMMAND_BUFFERS_CAP*/];
		struct {
			struct wlr_vk_command_buffer *cb;
			uint64_t last_timeline_point;
			struct wl_list buffers; // wlr_vk_shared_buffer.link
		} stage;
		struct {
			bool initialized;
			uint32_t drm_format;
			uint32_t width, height;
			VkImage dst_image;
			VkDeviceMemory dst_img_memory;
		} read_pixels_cache;
	};
	// vertex shader push constant range data
	struct wlr_vk_vert_pcr_data {
		float mat4[4][4];
		float uv_off[2];
		float uv_size[2];
	};
	struct wlr_vk_frag_output_pcr_data {
		float lut_3d_offset;
		float lut_3d_scale;
	};
	struct wlr_vk_texture_view {
		struct wl_list link; // struct wlr_vk_texture.views
		const struct wlr_vk_pipeline_layout *layout;
		VkDescriptorSet ds;
		VkImageView image_view;
		struct wlr_vk_descriptor_pool *ds_pool;
	};
	struct wlr_vk_pipeline *setup_get_or_create_pipeline(struct wlr_vk_render_format_setup *setup, const struct wlr_vk_pipeline_key *key);
	struct wlr_vk_pipeline_layout *get_or_create_pipeline_layout(struct wlr_vk_renderer *renderer, const struct wlr_vk_pipeline_layout_key *key);
	struct wlr_vk_texture_view *vulkan_texture_get_or_create_view(struct wlr_vk_texture *texture, const struct wlr_vk_pipeline_layout *layout);
	struct wlr_renderer *vulkan_renderer_create_for_device(struct wlr_vk_device *dev);
	VkCommandBuffer vulkan_record_stage_cb(struct wlr_vk_renderer *renderer);
	bool vulkan_submit_stage_wait(struct wlr_vk_renderer *renderer);
	struct wlr_vk_render_pass {
		struct wlr_render_pass base;
		struct wlr_vk_renderer *renderer;
		struct wlr_vk_render_buffer *render_buffer;
		struct wlr_vk_command_buffer *command_buffer;
		struct rect_union updated_region;
		VkPipeline bound_pipeline;
		float projection[9];
		bool failed;
		bool srgb_pathway; // if false, rendering via intermediate blending buffer
		struct wlr_color_transform *color_transform;
	};
	struct wlr_vk_render_pass *vulkan_begin_render_pass(struct wlr_vk_renderer *renderer, struct wlr_vk_render_buffer *buffer, const struct wlr_buffer_pass_options *options);
	struct wlr_vk_buffer_span vulkan_get_stage_span(struct wlr_vk_renderer *renderer, VkDeviceSize size, VkDeviceSize alignment);
	struct wlr_vk_descriptor_pool *vulkan_alloc_texture_ds(struct wlr_vk_renderer *renderer, VkDescriptorSetLayout ds_layout, VkDescriptorSet *ds);
	struct wlr_vk_descriptor_pool *vulkan_alloc_blend_ds(struct wlr_vk_renderer *renderer, VkDescriptorSet *ds);
	void vulkan_free_ds(struct wlr_vk_renderer *renderer, struct wlr_vk_descriptor_pool *pool, VkDescriptorSet ds);
	struct wlr_vk_format_props *vulkan_format_props_from_drm(struct wlr_vk_device *dev, uint32_t drm_format);
	struct wlr_vk_renderer *vulkan_get_renderer(struct wlr_renderer *r);
	struct wlr_vk_command_buffer *vulkan_acquire_command_buffer(struct wlr_vk_renderer *renderer);
	uint64_t vulkan_end_command_buffer(struct wlr_vk_command_buffer *cb, struct wlr_vk_renderer *renderer);
	void vulkan_reset_command_buffer(struct wlr_vk_command_buffer *cb);
	bool vulkan_wait_command_buffer(struct wlr_vk_command_buffer *cb, struct wlr_vk_renderer *renderer);
	bool vulkan_sync_render_buffer(struct wlr_vk_renderer *renderer, struct wlr_vk_render_buffer *render_buffer, struct wlr_vk_command_buffer *cb);
	bool vulkan_sync_foreign_texture(struct wlr_vk_texture *texture);
	bool vulkan_read_pixels(struct wlr_vk_renderer *vk_renderer, VkFormat src_format, VkImage src_image, uint32_t drm_format, uint32_t stride, uint32_t width, uint32_t height, uint32_t src_x, uint32_t src_y, uint32_t dst_x, uint32_t dst_y, void *data);
	// State (e.g. image texture) associated with a surface.
	struct wlr_vk_texture {
		struct wlr_texture wlr_texture;
		struct wlr_vk_renderer *renderer;
		uint32_t mem_count;
		VkDeviceMemory memories[4 /* WLR_DMABUF_MAX_PLANES */];
		VkImage image;
		const struct wlr_vk_format *format;
		enum wlr_vk_texture_transform transform;
		struct wlr_vk_command_buffer *last_used_cb; // to track when it can be destroyed
		bool dmabuf_imported;
		bool owned; // if dmabuf_imported: whether we have ownership of the image
		bool transitioned; // if dma_imported: whether we transitioned it away from preinit
		bool has_alpha; // whether the image is has alpha channel
		bool using_mutable_srgb; // is this accessed through _SRGB format view
		struct wl_list foreign_link; // wlr_vk_renderer.foreign_textures
		struct wl_list destroy_link; // wlr_vk_command_buffer.destroy_textures
		struct wl_list link; // wlr_vk_renderer.textures
		// If imported from a wlr_buffer
		struct wlr_buffer *buffer;
		struct wlr_addon buffer_addon;
		// For DMA-BUF implicit sync interop
		VkSemaphore foreign_semaphores[4 /* WLR_DMABUF_MAX_PLANES */];
		struct wl_list views; // struct wlr_vk_texture_ds.link
	};
	struct wlr_vk_texture *vulkan_get_texture(struct wlr_texture *wlr_texture);
	VkImage vulkan_import_dmabuf(struct wlr_vk_renderer *renderer, const struct wlr_dmabuf_attributes *attribs, VkDeviceMemory mems[4 /* WLR_DMABUF_MAX_PLANES */], uint32_t *n_mems, bool for_render, bool *using_mutable_srgb);
	struct wlr_texture *vulkan_texture_from_buffer(struct wlr_renderer *wlr_renderer, struct wlr_buffer *buffer);
	void vulkan_texture_destroy(struct wlr_vk_texture *texture);
	struct wlr_vk_descriptor_pool {
		VkDescriptorPool pool;
		uint32_t free; // number of textures that can be allocated
		struct wl_list link; // wlr_vk_renderer.descriptor_pools
	};
	struct wlr_vk_allocation {
		VkDeviceSize start;
		VkDeviceSize size;
	};
	// List of suballocated staging buffers.
	// Used to upload to/read from device local images.
	struct wlr_vk_shared_buffer {
		struct wl_list link; // wlr_vk_renderer.stage.buffers or wlr_vk_command_buffer.stage_buffers
		VkBuffer buffer;
		VkDeviceMemory memory;
		VkDeviceSize buf_size;
		void *cpu_mapping;
		struct wl_array allocs; // struct wlr_vk_allocation
	};
	// Suballocated range on a buffer.
	struct wlr_vk_buffer_span {
		struct wlr_vk_shared_buffer *buffer;
		struct wlr_vk_allocation alloc;
	};
	// Lookup table for a color transform
	struct wlr_vk_color_transform {
		struct wlr_addon addon; // owned by: wlr_vk_renderer
		struct wl_list link; // wlr_vk_renderer, list of all color transforms
		struct {
			VkImage image;
			VkImageView image_view;
			VkDeviceMemory memory;
			VkDescriptorSet ds;
			struct wlr_vk_descriptor_pool *ds_pool;
		} lut_3d;
	};
	void vk_color_transform_destroy(struct wlr_addon *addon);
	const char *vulkan_strerror(VkResult err);
	void vulkan_change_layout(VkCommandBuffer cb, VkImage img, VkImageLayout ol, VkPipelineStageFlags srcs, VkAccessFlags srca, VkImageLayout nl, VkPipelineStageFlags dsts, VkAccessFlags dsta);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/render/wlr_renderer.h
	struct wlr_renderer *renderer_autocreate_with_drm_fd(int drm_fd);
	const struct wlr_drm_format_set *wlr_renderer_get_render_formats(struct wlr_renderer *renderer);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_buffer.h
	struct wlr_readonly_data_buffer {
		struct wlr_buffer base;
		const void *data;
		uint32_t format;
		size_t stride;
		void *saved_data;
	};
	struct wlr_readonly_data_buffer *readonly_data_buffer_create(uint32_t format, size_t stride, uint32_t width, uint32_t height, const void *data);
	bool readonly_data_buffer_drop(struct wlr_readonly_data_buffer *buffer);
	struct wlr_dmabuf_buffer {
		struct wlr_buffer base;
		struct wlr_dmabuf_attributes dmabuf;
		bool saved;
	};
	struct wlr_dmabuf_buffer *dmabuf_buffer_create(struct wlr_dmabuf_attributes *dmabuf);
	bool dmabuf_buffer_drop(struct wlr_dmabuf_buffer *buffer);
	bool buffer_is_opaque(struct wlr_buffer *buffer);
	struct wlr_client_buffer *wlr_client_buffer_create(struct wlr_buffer *buffer, struct wlr_renderer *renderer);
	bool wlr_client_buffer_apply_damage(struct wlr_client_buffer *client_buffer, struct wlr_buffer *next, const pixman_region32_t *damage);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_data_device.h
	struct wlr_client_data_source {
		struct wlr_data_source source;
		struct wlr_data_source_impl impl;
		struct wl_resource *resource;
		bool finalized;
	};
	extern const struct wlr_surface_role drag_icon_surface_role;
	struct wlr_data_offer *data_offer_create(struct wl_resource *device_resource, struct wlr_data_source *source, enum wlr_data_offer_type type);
	void data_offer_update_action(struct wlr_data_offer *offer);
	void data_offer_destroy(struct wlr_data_offer *offer);
	struct wlr_client_data_source *client_data_source_create(struct wl_client *client, uint32_t version, uint32_t id, struct wl_list *resource_list);
	struct wlr_client_data_source *client_data_source_from_resource(struct wl_resource *resource);
	void data_source_notify_finish(struct wlr_data_source *source);
	struct wlr_seat_client *seat_client_from_data_device_resource(struct wl_resource *resource);
	void seat_client_send_selection(struct wlr_seat_client *seat_client);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_keyboard.h
	void keyboard_key_update(struct wlr_keyboard *keyboard, struct wlr_keyboard_key_event *event);
	bool keyboard_modifier_update(struct wlr_keyboard *keyboard);
	void keyboard_led_update(struct wlr_keyboard *keyboard);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_matrix.h
	void matrix_projection(float mat[9], int width, int height, enum wl_output_transform transform);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_output.h
	void output_pending_resolution(struct wlr_output *output, const struct wlr_output_state *state, int *width, int *height);
	bool output_pending_enabled(struct wlr_output *output, const struct wlr_output_state *state);
	bool output_pick_format(struct wlr_output *output, const struct wlr_drm_format_set *display_formats, struct wlr_drm_format *format, uint32_t fmt);
	bool output_ensure_buffer(struct wlr_output *output, struct wlr_output_state *state, bool *new_back_buffer);
	bool output_cursor_set_texture(struct wlr_output_cursor *cursor, struct wlr_texture *texture, bool own_texture, const struct wlr_fbox *src_box, int dst_width, int dst_height, enum wl_output_transform transform, int32_t hotspot_x, int32_t hotspot_y);
	void output_defer_present(struct wlr_output *output, struct wlr_output_event_present event);
	bool output_prepare_commit(struct wlr_output *output, const struct wlr_output_state *state);
	void output_apply_commit(struct wlr_output *output, const struct wlr_output_state *state);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_region.h
	struct wl_client;
	struct wl_resource *region_create(struct wl_client *client, uint32_t version, uint32_t id);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_scene.h
	struct wlr_scene *scene_node_get_root(struct wlr_scene_node *node);
	void scene_surface_set_clip(struct wlr_scene_surface *surface, struct wlr_box *clip);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_seat.h
	extern const struct wlr_pointer_grab_interface default_pointer_grab_impl;
	extern const struct wlr_keyboard_grab_interface default_keyboard_grab_impl;
	extern const struct wlr_touch_grab_interface default_touch_grab_impl;
	void seat_client_create_pointer(struct wlr_seat_client *seat_client, uint32_t version, uint32_t id);
	void seat_client_create_inert_pointer(struct wl_client *client, uint32_t version, uint32_t id);
	void seat_client_destroy_pointer(struct wl_resource *resource);
	void seat_client_send_pointer_leave_raw(struct wlr_seat_client *seat_client, struct wlr_surface *surface);
	void seat_client_create_keyboard(struct wlr_seat_client *seat_client, uint32_t version, uint32_t id);
	void seat_client_create_inert_keyboard(struct wl_client *client, uint32_t version, uint32_t id);
	void seat_client_destroy_keyboard(struct wl_resource *resource);
	void seat_client_send_keyboard_leave_raw(struct wlr_seat_client *seat_client, struct wlr_surface *surface);
	void seat_client_create_touch(struct wlr_seat_client *seat_client, uint32_t version, uint32_t id);
	void seat_client_create_inert_touch(struct wl_client *client, uint32_t version, uint32_t id);
	void seat_client_destroy_touch(struct wl_resource *resource);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_subcompositor.h
	void subsurface_consider_map(struct wlr_subsurface *subsurface);
	void subsurface_handle_parent_commit(struct wlr_subsurface *subsurface);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_tablet_v2.h
	struct wlr_tablet_seat_v2 {
		struct wl_list link; // wlr_tablet_manager_v2.seats
		struct wlr_seat *wlr_seat;
		struct wlr_tablet_manager_v2 *manager;
		struct wl_list tablets; // wlr_tablet_v2_tablet.link
		struct wl_list tools;
		struct wl_list pads;
		struct wl_list clients; // wlr_tablet_seat_v2_client.link
		struct wl_listener seat_destroy;
	};
	struct wlr_tablet_seat_client_v2 {
		struct wl_list seat_link;
		struct wl_list client_link;
		struct wl_client *wl_client;
		struct wl_resource *resource;
		struct wlr_tablet_manager_client_v2 *client;
		struct wlr_seat_client *seat_client;
		struct wl_listener seat_client_destroy;
		struct wl_list tools; // wlr_tablet_tool_client_v2.link
		struct wl_list tablets; // wlr_tablet_client_v2.link
		struct wl_list pads; // wlr_tablet_pad_client_v2.link
	};
	struct wlr_tablet_client_v2 {
		struct wl_list seat_link; // wlr_tablet_seat_client_v2.tablet
		struct wl_list tablet_link; // wlr_tablet_v2_tablet.clients
		struct wl_client *client;
		struct wl_resource *resource;
	};
	struct wlr_tablet_pad_client_v2 {
		struct wl_list seat_link;
		struct wl_list pad_link;
		struct wl_client *client;
		struct wl_resource *resource;
		struct wlr_tablet_v2_tablet_pad *pad;
		struct wlr_tablet_seat_client_v2 *seat;
		size_t button_count;
		size_t group_count;
		struct wl_resource **groups;
		size_t ring_count;
		struct wl_resource **rings;
		size_t strip_count;
		struct wl_resource **strips;
	};
	struct wlr_tablet_tool_client_v2 {
		struct wl_list seat_link;
		struct wl_list tool_link;
		struct wl_client *client;
		struct wl_resource *resource;
		struct wlr_tablet_v2_tablet_tool *tool;
		struct wlr_tablet_seat_client_v2 *seat;
		struct wl_event_source *frame_source;
	};
	struct wlr_tablet_client_v2 *tablet_client_from_resource(struct wl_resource *resource);
	void destroy_tablet_v2(struct wl_resource *resource);
	void add_tablet_client(struct wlr_tablet_seat_client_v2 *seat, struct wlr_tablet_v2_tablet *tablet);
	void destroy_tablet_pad_v2(struct wl_resource *resource);
	struct wlr_tablet_pad_client_v2 *tablet_pad_client_from_resource(struct wl_resource *resource);
	void add_tablet_pad_client(struct wlr_tablet_seat_client_v2 *seat, struct wlr_tablet_v2_tablet_pad *pad);
	void destroy_tablet_tool_v2(struct wl_resource *resource);
	struct wlr_tablet_tool_client_v2 *tablet_tool_client_from_resource(struct wl_resource *resource);
	void add_tablet_tool_client(struct wlr_tablet_seat_client_v2 *seat, struct wlr_tablet_v2_tablet_tool *tool);
	struct wlr_tablet_seat_client_v2 *tablet_seat_client_from_resource(struct wl_resource *resource);
	void tablet_seat_client_v2_destroy(struct wl_resource *resource);
	struct wlr_tablet_seat_v2 *get_or_create_tablet_seat(struct wlr_tablet_manager_v2 *manager, struct wlr_seat *wlr_seat);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/types/wlr_xdg_shell.h
	void create_xdg_surface(struct wlr_xdg_client *client, struct wlr_surface *wlr_surface, uint32_t id);
	void destroy_xdg_surface(struct wlr_xdg_surface *surface);
	bool set_xdg_surface_role(struct wlr_xdg_surface *surface, enum wlr_xdg_surface_role role);
	void set_xdg_surface_role_object(struct wlr_xdg_surface *surface, struct wl_resource *role_resource);
	void create_xdg_positioner(struct wlr_xdg_client *client, uint32_t id);
	void create_xdg_popup(struct wlr_xdg_surface *surface, struct wlr_xdg_surface *parent, struct wlr_xdg_positioner *positioner, uint32_t id);
	void reset_xdg_popup(struct wlr_xdg_popup *popup);
	void destroy_xdg_popup(struct wlr_xdg_popup *popup);
	void handle_xdg_popup_client_commit(struct wlr_xdg_popup *popup);
	struct wlr_xdg_popup_configure *send_xdg_popup_configure(struct wlr_xdg_popup *popup);
	void handle_xdg_popup_ack_configure(struct wlr_xdg_popup *popup, struct wlr_xdg_popup_configure *configure);
	void create_xdg_toplevel(struct wlr_xdg_surface *surface, uint32_t id);
	void reset_xdg_toplevel(struct wlr_xdg_toplevel *toplevel);
	void destroy_xdg_toplevel(struct wlr_xdg_toplevel *toplevel);
	void handle_xdg_toplevel_client_commit(struct wlr_xdg_toplevel *toplevel);
	struct wlr_xdg_toplevel_configure *send_xdg_toplevel_configure(struct wlr_xdg_toplevel *toplevel);
	void handle_xdg_toplevel_ack_configure(struct wlr_xdg_toplevel *toplevel, struct wlr_xdg_toplevel_configure *configure);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/xcursor/cursor_data.h
	// is in wlroots/cursor_data.lua
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/xcursor/xcursor.h
	/*
	 * Copyright © 2002 Keith Packard
	 *
	 * Permission is hereby granted, free of charge, to any person obtaining
	 * a copy of this software and associated documentation files (the
	 * "Software"), to deal in the Software without restriction, including
	 * without limitation the rights to use, copy, modify, merge, publish,
	 * distribute, sublicense, and/or sell copies of the Software, and to
	 * permit persons to whom the Software is furnished to do so, subject to
	 * the following conditions:
	 *
	 * The above copyright notice and this permission notice (including the
	 * next paragraph) shall be included in all copies or substantial
	 * portions of the Software.
	 *
	 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
	 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
	 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
	 * NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
	 * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
	 * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
	 * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	 * SOFTWARE.
	 */
	 struct xcursor_image {
		uint32_t version; /* version of the image data */
		uint32_t size; /* nominal size for matching */
		uint32_t width; /* actual width */
		uint32_t height; /* actual height */
		uint32_t xhot; /* hot spot x (must be inside image) */
		uint32_t yhot; /* hot spot y (must be inside image) */
		uint32_t delay; /* animation delay to next frame (ms) */
		uint32_t *pixels; /* pointer to pixels */
	};
	struct xcursor_images {
		int nimage; /* number of images */
		struct xcursor_image **images; /* array of XcursorImage pointers */
		char *name; /* name used to load images */
	};
	void xcursor_images_destroy(struct xcursor_images *images);
	void xcursor_load_theme(const char *theme, int size, void (*load_callback)(struct xcursor_images *, void *), void *user_data);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/xwayland/selection.h
	struct wlr_primary_selection_source;
	struct wlr_xwm_selection;
	struct wlr_drag;
	struct wlr_data_source;
	struct wlr_xwm_selection_transfer {
		struct wlr_xwm_selection *selection;
		bool incr;
		bool flush_property_on_delete;
		bool property_set;
		struct wl_array source_data;
		int wl_client_fd;
		struct wl_event_source *event_source;
		struct wl_list link;
		// when sending to x11
		xcb_selection_request_event_t request;
		// when receiving from x11
		int property_start;
		xcb_get_property_reply_t *property_reply;
		xcb_window_t incoming_window;
	};
	struct wlr_xwm_selection {
		struct wlr_xwm *xwm;
		xcb_atom_t atom;
		xcb_window_t window;
		xcb_window_t owner;
		xcb_timestamp_t timestamp;
		struct wl_list incoming;
		struct wl_list outgoing;
	};
	struct wlr_xwm_selection_transfer *xwm_selection_find_incoming_transfer_by_window(struct wlr_xwm_selection *selection, xcb_window_t window);
	void xwm_selection_transfer_remove_event_source(struct wlr_xwm_selection_transfer *transfer);
	void xwm_selection_transfer_close_wl_client_fd(struct wlr_xwm_selection_transfer *transfer);
	void xwm_selection_transfer_destroy_property_reply(struct wlr_xwm_selection_transfer *transfer);
	void xwm_selection_transfer_init(struct wlr_xwm_selection_transfer *transfer, struct wlr_xwm_selection *selection);
	void xwm_selection_transfer_destroy(struct wlr_xwm_selection_transfer *transfer);
	void xwm_selection_transfer_destroy_outgoing(struct wlr_xwm_selection_transfer *transfer);
	xcb_atom_t xwm_mime_type_to_atom(struct wlr_xwm *xwm, char *mime_type);
	char *xwm_mime_type_from_atom(struct wlr_xwm *xwm, xcb_atom_t atom);
	struct wlr_xwm_selection *xwm_get_selection(struct wlr_xwm *xwm, xcb_atom_t selection_atom);
	void xwm_send_incr_chunk(struct wlr_xwm_selection_transfer *transfer);
	void xwm_handle_selection_request(struct wlr_xwm *xwm, xcb_selection_request_event_t *req);
	void xwm_handle_selection_destroy_notify(struct wlr_xwm *xwm, xcb_destroy_notify_event_t *event);
	void xwm_get_incr_chunk(struct wlr_xwm_selection_transfer *transfer);
	void xwm_handle_selection_notify(struct wlr_xwm *xwm, xcb_selection_notify_event_t *event);
	int xwm_handle_xfixes_selection_notify(struct wlr_xwm *xwm, xcb_xfixes_selection_notify_event_t *event);
	bool data_source_is_xwayland(struct wlr_data_source *wlr_source);
	bool primary_selection_source_is_xwayland(struct wlr_primary_selection_source *wlr_source);
	void xwm_seat_handle_start_drag(struct wlr_xwm *xwm, struct wlr_drag *drag);
	void xwm_selection_init(struct wlr_xwm_selection *selection, struct wlr_xwm *xwm, xcb_atom_t atom);
	void xwm_selection_finish(struct wlr_xwm_selection *selection);
	// https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/include/xwayland/xwm.h
	enum atom_name {
		WL_SURFACE_ID,
		WL_SURFACE_SERIAL,
		WM_DELETE_WINDOW,
		WM_PROTOCOLS,
		WM_HINTS,
		WM_NORMAL_HINTS,
		WM_SIZE_HINTS,
		WM_WINDOW_ROLE,
		MOTIF_WM_HINTS,
		UTF8_STRING,
		WM_S0,
		NET_SUPPORTED,
		NET_WM_CM_S0,
		NET_WM_PID,
		NET_WM_NAME,
		NET_WM_STATE,
		NET_WM_STRUT_PARTIAL,
		NET_WM_WINDOW_TYPE,
		WM_TAKE_FOCUS,
		WINDOW,
		NET_ACTIVE_WINDOW,
		NET_WM_MOVERESIZE,
		NET_SUPPORTING_WM_CHECK,
		NET_WM_STATE_FOCUSED,
		NET_WM_STATE_MODAL,
		NET_WM_STATE_FULLSCREEN,
		NET_WM_STATE_MAXIMIZED_VERT,
		NET_WM_STATE_MAXIMIZED_HORZ,
		NET_WM_STATE_HIDDEN,
		NET_WM_PING,
		WM_CHANGE_STATE,
		WM_STATE,
		CLIPBOARD,
		PRIMARY,
		WL_SELECTION,
		TARGETS,
		CLIPBOARD_MANAGER,
		INCR,
		TEXT,
		TIMESTAMP,
		DELETE,
		NET_STARTUP_ID,
		NET_STARTUP_INFO,
		NET_STARTUP_INFO_BEGIN,
		NET_WM_WINDOW_TYPE_NORMAL,
		NET_WM_WINDOW_TYPE_UTILITY,
		NET_WM_WINDOW_TYPE_TOOLTIP,
		NET_WM_WINDOW_TYPE_DND,
		NET_WM_WINDOW_TYPE_DROPDOWN_MENU,
		NET_WM_WINDOW_TYPE_POPUP_MENU,
		NET_WM_WINDOW_TYPE_COMBO,
		NET_WM_WINDOW_TYPE_MENU,
		NET_WM_WINDOW_TYPE_NOTIFICATION,
		NET_WM_WINDOW_TYPE_SPLASH,
		NET_WM_WINDOW_TYPE_DESKTOP,
		DND_SELECTION,
		DND_AWARE,
		DND_STATUS,
		DND_POSITION,
		DND_ENTER,
		DND_LEAVE,
		DND_DROP,
		DND_FINISHED,
		DND_PROXY,
		DND_TYPE_LIST,
		DND_ACTION_MOVE,
		DND_ACTION_COPY,
		DND_ACTION_ASK,
		DND_ACTION_PRIVATE,
		NET_CLIENT_LIST,
		NET_CLIENT_LIST_STACKING,
		NET_WORKAREA,
		ATOM_LAST // keep last
	};
	struct wlr_xwm {
		struct wlr_xwayland *xwayland;
		struct wl_event_source *event_source;
		struct wlr_seat *seat;
		uint32_t ping_timeout;
		xcb_atom_t atoms[ATOM_LAST];
		xcb_connection_t *xcb_conn;
		xcb_screen_t *screen;
		xcb_window_t window;
		xcb_visualid_t visual_id;
		xcb_colormap_t colormap;
		xcb_render_pictformat_t render_format_id;
		xcb_cursor_t cursor;
		struct wlr_xwm_selection clipboard_selection;
		struct wlr_xwm_selection primary_selection;
		struct wlr_xwm_selection dnd_selection;
		struct wlr_xwayland_surface *focus_surface;
		// Surfaces in creation order
		struct wl_list surfaces; // wlr_xwayland_surface.link
		// Surfaces in bottom-to-top stacking order, for _NET_CLIENT_LIST_STACKING
		struct wl_list surfaces_in_stack_order; // wlr_xwayland_surface.stack_link
		struct wl_list unpaired_surfaces; // wlr_xwayland_surface.unpaired_link
		struct wl_list pending_startup_ids; // pending_startup_id
		struct wlr_drag *drag;
		struct wlr_xwayland_surface *drag_focus;
		const xcb_query_extension_reply_t *xfixes;
		const xcb_query_extension_reply_t *xres;
		uint32_t xfixes_major_version;
		// #if HAVE_XCB_ERRORS
		xcb_errors_context_t *errors_context;
		// #endif
		unsigned int last_focus_seq;
		struct wl_listener compositor_new_surface;
		struct wl_listener compositor_destroy;
		struct wl_listener shell_v1_new_surface;
		struct wl_listener seat_set_selection;
		struct wl_listener seat_set_primary_selection;
		struct wl_listener seat_start_drag;
		struct wl_listener seat_drag_focus;
		struct wl_listener seat_drag_motion;
		struct wl_listener seat_drag_drop;
		struct wl_listener seat_drag_destroy;
		struct wl_listener seat_drag_source_destroy;
	};
	struct wlr_xwm *xwm_create(struct wlr_xwayland *wlr_xwayland, int wm_fd);
	void xwm_destroy(struct wlr_xwm *xwm);
	void xwm_set_cursor(struct wlr_xwm *xwm, const uint8_t *pixels, uint32_t stride, uint32_t width, uint32_t height, int32_t hotspot_x, int32_t hotspot_y);
	int xwm_handle_selection_event(struct wlr_xwm *xwm, xcb_generic_event_t *event);
	int xwm_handle_selection_client_message(struct wlr_xwm *xwm, xcb_client_message_event_t *ev);
	void xwm_set_seat(struct wlr_xwm *xwm, struct wlr_seat *seat);
	char *xwm_get_atom_name(struct wlr_xwm *xwm, xcb_atom_t atom);
	bool xwm_atoms_contains(struct wlr_xwm *xwm, xcb_atom_t *atoms, size_t num_atoms, enum atom_name needle);
	xcb_void_cookie_t xwm_send_event_with_size(xcb_connection_t *c, uint8_t propagate, xcb_window_t destination, uint32_t event_mask, const void *event, uint32_t length);
]]
--[[@type wlroots_ffi]]
return ffi.load("libwlroots-0.18.so")
