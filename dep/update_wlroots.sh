#!/bin/sh
rm -f wlroots.lua
cat <<'END' >> wlroots.lua
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
END
rm -f wlroots.in.h
for f in $(find $WLR_DIR -name '*.h' -exec sh -c "echo \${0#$WLR_DIR}" {} \;); do
	echo "#include <$f>" >> wlroots.in.h
done
PROTOS=(content-type-v1-protocol.h cursor-shape-v1-protocol.h fullscreen-shell-unstable-v1-protocol.h wlr-layer-shell-unstable-v1-protocol.h wlr-output-power-management-unstable-v1-protocol.h pointer-constraints-unstable-v1-protocol.h tablet-v2-protocol.h tearing-control-v1-protocol.h xdg-shell-protocol.h)
SHIMMED=(stdio.h stdlib.h string.h wayland-util.h wayland-client-protocol.h wayland-server-protocol.h wayland-server-core.h pthread.h pixman.h libinput.h EGL/egl.h EGL/eglext.h GLES2/gl2.h vulkan/vulkan_core.h xcb/xcb.h xcb/xcb_ewmh.h xcb/xcb_icccm.h xkbcommon/xkbcommon.h)
mkdir EGL GLES2 vulkan xcb xkbcommon
for f in ${PROTOS[@]}; do touch $f; done
for f in ${SHIMMED[@]}; do touch $f; done
cat wlroots.in.h | gcc -I . -I $CMAKE_INCLUDE_PATH -I $WLR_DIR -DWLR_USE_UNSTABLE -E - | sed '/^#/d; /^ *$/d; /^extern .*;$/d; /^extern/,/;$/d; s/static //g' >> wlroots.lua
rm wlroots.in.h
for f in ${PROTOS[@]}; do rm $f; done
for f in ${SHIMMED[@]}; do rm $f; done
rm -r EGL GLES2 vulkan xcb xkbcommon
cat <<'END' >> wlroots.lua
]]

--[[@class wlroots_ffi: { [string]: function }]]

--[[@type wlroots_ffi]]
local ret = ffi.load("libwlroots-0.18.so")
return ret

END

