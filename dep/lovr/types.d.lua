--[[@diagnostic disable: redefined-local, unused-local, lowercase-global]]

--[[make luals happy]]
if false then
	local userdata --[[@type userdata]]
	local lightuserdata --[[@type lightuserdata]]

	--[[https://lovr.org/docs/lovr  ]]
	--[[@class lovr]]
	--[[https://lovr.org/docs/lovr.conf  ]]
	--[[Called to read configuration settings at startup.  ]]
	--[[### See also]]
	--[[* [`lovr.load`](lua://lovr.load)]]
	--[[@field conf fun(t: lovr_conf_t)]]
	--[[https://lovr.org/docs/lovr.draw  ]]
	--[[Called continuously to render frames to the display.  ]]
	--[[### See also]]
	--[[* [`lovr.mirror`](lua://lovr.mirror)]]
	--[[* [`lovr.headset.getPass`](lua://lovr.headset.getPass)]]
	--[[* [`lovr.graphics.getWindowPass`](lua://lovr.graphics.getWindowPass)]]
	--[[* [`lovr.graphics.setBackgroundColor`](lua://lovr.graphics.setBackgroundColor)]]
	--[[@field draw fun(pass: lovr_pass): boolean?]]
	--[[https://lovr.org/docs/lovr.errhand  ]]
	--[[Called when an error occurs.  ]]
	--[[### See also]]
	--[[* [`lovr.quit`](lua://lovr.quit)]]
	--[[@field errhand fun(message: string): function]]
	--[[https://lovr.org/docs/lovr.focus  ]]
	--[[Called when the application gains or loses input focus.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.isFocused`](lua://lovr.headset.isFocused)]]
	--[[* [`lovr.visible`](lua://lovr.visible)]]
	--[[@field focus fun(focused: boolean)]]
	--[[https://lovr.org/docs/lovr.keypressed  ]]
	--[[Called when a key is pressed.  ]]
	--[[### See also]]
	--[[* [`lovr.system.wasKeyPressed`](lua://lovr.system.wasKeyPressed)]]
	--[[* [`lovr.keyreleased`](lua://lovr.keyreleased)]]
	--[[* [`lovr.textinput`](lua://lovr.textinput)]]
	--[[* [`lovr.system.isKeyDown`](lua://lovr.system.isKeyDown)]]
	--[[@field keypressed fun(key: lovr_key_code, scancode: number, repeat_: boolean)]]
	--[[https://lovr.org/docs/lovr.keyreleased  ]]
	--[[Called when a key is released.  ]]
	--[[### See also]]
	--[[* [`lovr.system.wasKeyReleased`](lua://lovr.system.wasKeyReleased)]]
	--[[* [`lovr.keypressed`](lua://lovr.keypressed)]]
	--[[* [`lovr.textinput`](lua://lovr.textinput)]]
	--[[* [`lovr.system.isKeyDown`](lua://lovr.system.isKeyDown)]]
	--[[@field keyreleased fun(key: lovr_key_code, scancode: number)]]
	--[[https://lovr.org/docs/lovr.load  ]]
	--[[Called once at startup.  ]]
	--[[### See also]]
	--[[* [`lovr.quit`](lua://lovr.quit)]]
	--[[@field load fun(arg: table<string,string|number>)]]
	--[[https://lovr.org/docs/lovr.log  ]]
	--[[Called when a message is logged.  ]]
	--[[### See also]]
	--[[* [`Pass:text`](lua://lovr_pass.text)]]
	--[[@field log fun(message: string, level: string, tag: string)]]
	--[[https://lovr.org/docs/lovr.mirror  ]]
	--[[Called to render content to the desktop window.  ]]
	--[[### See also]]
	--[[* [`lovr.system.openWindow`](lua://lovr.system.openWindow)]]
	--[[* [`lovr.draw`](lua://lovr.draw)]]
	--[[@field mirror fun(pass: lovr_pass): boolean]]
	--[[https://lovr.org/docs/lovr.mousemoved  ]]
	--[[Called when the mouse is moved.  ]]
	--[[### See also]]
	--[[* [`lovr.mousepressed`](lua://lovr.mousepressed)]]
	--[[* [`lovr.mousereleased`](lua://lovr.mousereleased)]]
	--[[* [`lovr.wheelmoved`](lua://lovr.wheelmoved)]]
	--[[* [`lovr.system.getMouseX`](lua://lovr.system.getMouseX)]]
	--[[* [`lovr.system.getMouseY`](lua://lovr.system.getMouseY)]]
	--[[* [`lovr.system.getMousePosition`](lua://lovr.system.getMousePosition)]]
	--[[@field mousemoved fun(x: number, y: number, dx: number, dy: number)]]
	--[[https://lovr.org/docs/lovr.mousepressed  ]]
	--[[Called when a mouse button is pressed.  ]]
	--[[### See also]]
	--[[* [`lovr.mousereleased`](lua://lovr.mousereleased)]]
	--[[* [`lovr.mousemoved`](lua://lovr.mousemoved)]]
	--[[* [`lovr.wheelmoved`](lua://lovr.wheelmoved)]]
	--[[* [`lovr.system.isMouseDown`](lua://lovr.system.isMouseDown)]]
	--[[@field mousepressed fun(x: number, y: number, button: number)]]
	--[[https://lovr.org/docs/lovr.mousereleased  ]]
	--[[Called when a mouse button is released.  ]]
	--[[### See also]]
	--[[* [`lovr.mousepressed`](lua://lovr.mousepressed)]]
	--[[* [`lovr.mousemoved`](lua://lovr.mousemoved)]]
	--[[* [`lovr.wheelmoved`](lua://lovr.wheelmoved)]]
	--[[* [`lovr.system.isMouseDown`](lua://lovr.system.isMouseDown)]]
	--[[@field mousereleased fun(x: number, y: number, button: number)]]
	--[[https://lovr.org/docs/lovr.permission  ]]
	--[[Called when a permission request is answered.  ]]
	--[[### See also]]
	--[[* [`lovr.system.requestPermission`](lua://lovr.system.requestPermission)]]
	--[[@field permission fun(permission: lovr_permission, granted: boolean)]]
	--[[https://lovr.org/docs/lovr.quit  ]]
	--[[Called before quitting.  ]]
	--[[### See also]]
	--[[* [`lovr.event.quit`](lua://lovr.event.quit)]]
	--[[* [`lovr.load`](lua://lovr.load)]]
	--[[@field quit fun(): boolean]]
	--[[https://lovr.org/docs/lovr.recenter  ]]
	--[[Called when the user recenters the coordinate space.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getBoundsWidth`](lua://lovr.headset.getBoundsWidth)]]
	--[[* [`lovr.headset.getBoundsDepth`](lua://lovr.headset.getBoundsDepth)]]
	--[[* [`lovr.headset.getBoundsDimensions`](lua://lovr.headset.getBoundsDimensions)]]
	--[[* [`lovr.headset.getBoundsGeometry`](lua://lovr.headset.getBoundsGeometry)]]
	--[[* [`lovr.headset.isSeated`](lua://lovr.headset.isSeated)]]
	--[[@field recenter fun()]]
	--[[https://lovr.org/docs/lovr.resize  ]]
	--[[Called when the window is resized.  ]]
	--[[### See also]]
	--[[* [`Pass:getDimensions`](lua://lovr_pass.getDimensions)]]
	--[[* [`Pass:getWidth`](lua://lovr_pass.getWidth)]]
	--[[* [`Pass:getHeight`](lua://lovr_pass.getHeight)]]
	--[[* [`lovr.headset.getDisplayDimensions`](lua://lovr.headset.getDisplayDimensions)]]
	--[[* [`lovr.conf`](lua://lovr.conf)]]
	--[[@field resize fun(width: number, height: number)]]
	--[[https://lovr.org/docs/lovr.restart  ]]
	--[[Called when restarting.  ]]
	--[[### See also]]
	--[[* [`lovr.event.restart`](lua://lovr.event.restart)]]
	--[[* [`lovr.load`](lua://lovr.load)]]
	--[[* [`lovr.quit`](lua://lovr.quit)]]
	--[[@field restart fun(): unknown]]
	--[[https://lovr.org/docs/lovr.run  ]]
	--[[The main entry point.  ]]
	--[[### See also]]
	--[[* [`lovr.load`](lua://lovr.load)]]
	--[[* [`lovr.quit`](lua://lovr.quit)]]
	--[[@field run fun(): function]]
	--[[https://lovr.org/docs/lovr.textinput  ]]
	--[[Called when text has been entered.  ]]
	--[[### See also]]
	--[[* [`lovr.keypressed`](lua://lovr.keypressed)]]
	--[[* [`lovr.keyreleased`](lua://lovr.keyreleased)]]
	--[[@field textinput fun(text: string, code: number)]]
	--[[https://lovr.org/docs/lovr.threaderror  ]]
	--[[Called when an error occurs in a thread.  ]]
	--[[### See also]]
	--[[* [`Thread`](lua://lovr_thread)]]
	--[[* [`Thread:getError`](lua://lovr_thread.getError)]]
	--[[* [`lovr.errhand`](lua://lovr.errhand)]]
	--[[@field threaderror fun(thread: lovr_thread, message: string)]]
	--[[https://lovr.org/docs/lovr.update  ]]
	--[[Called every frame to update the application logic.  ]]
	--[[### See also]]
	--[[* [`lovr.timer.getDelta`](lua://lovr.timer.getDelta)]]
	--[[@field update fun(dt: number)]]
	--[[https://lovr.org/docs/lovr.visible  ]]
	--[[Called when the application gains or loses visibility.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.isVisible`](lua://lovr.headset.isVisible)]]
	--[[* [`lovr.focus`](lua://lovr.focus)]]
	--[[@field visible fun(visible: boolean)]]
	--[[https://lovr.org/docs/lovr.wheelmoved  ]]
	--[[Called when a mouse wheel is moved.  ]]
	--[[### See also]]
	--[[* [`lovr.mousepressed`](lua://lovr.mousepressed)]]
	--[[* [`lovr.mousereleased`](lua://lovr.mousereleased)]]
	--[[* [`lovr.mousemoved`](lua://lovr.mousemoved)]]
	--[[* [`lovr.system.isMouseDown`](lua://lovr.system.isMouseDown)]]
	--[[@field wheelmoved fun(dx: number, dy: number)]]
	lovr = lovr

	--[[https://lovr.org/docs/lovr.conf  ]]
	--[[see also:  ]]
	--[[[`lovr.conf`](lua://lovr.conf)  ]]
	--[[@class lovr_conf_t]]
	--[[@field version string ]]
	--[[@field identity string ]]
	--[[@field saveprecedence boolean ]]
	--[[@field modules lovr_conf_t_modules ]]
	--[[@field audio lovr_conf_t_audio ]]
	--[[@field graphics lovr_conf_t_graphics ]]
	--[[@field headset lovr_conf_t_headset ]]
	--[[@field math lovr_conf_t_math ]]
	--[[@field window lovr_conf_t_window ]]

	--[[https://lovr.org/docs/lovr.conf  ]]
	--[[see also:  ]]
	--[[[`lovr.conf`](lua://lovr.conf)  ]]
	--[[@class lovr_conf_t_modules]]
	--[[@field audio boolean ]]
	--[[@field data boolean ]]
	--[[@field event boolean ]]
	--[[@field graphics boolean ]]
	--[[@field headset boolean ]]
	--[[@field math boolean ]]
	--[[@field physics boolean ]]
	--[[@field system boolean ]]
	--[[@field thread boolean ]]
	--[[@field timer boolean ]]

	--[[https://lovr.org/docs/lovr.conf  ]]
	--[[see also:  ]]
	--[[[`lovr.conf`](lua://lovr.conf)  ]]
	--[[@class lovr_conf_t_audio]]
	--[[@field spatializer string ]]
	--[[@field samplerate number ]]
	--[[@field start boolean ]]

	--[[https://lovr.org/docs/lovr.conf  ]]
	--[[see also:  ]]
	--[[[`lovr.conf`](lua://lovr.conf)  ]]
	--[[@class lovr_conf_t_graphics]]
	--[[@field debug boolean ]]
	--[[@field vsync boolean ]]
	--[[@field stencil boolean ]]
	--[[@field antialias boolean ]]
	--[[@field shadercache boolean ]]

	--[[https://lovr.org/docs/lovr.conf  ]]
	--[[see also:  ]]
	--[[[`lovr.conf`](lua://lovr.conf)  ]]
	--[[@class lovr_conf_t_headset]]
	--[[@field drivers table<string,string|number> ]]
	--[[@field supersample number ]]
	--[[@field seated boolean ]]
	--[[@field antialias boolean ]]
	--[[@field stencil boolean ]]
	--[[@field submitdepth boolean ]]
	--[[@field overlay boolean ]]

	--[[https://lovr.org/docs/lovr.conf  ]]
	--[[see also:  ]]
	--[[[`lovr.conf`](lua://lovr.conf)  ]]
	--[[@class lovr_conf_t_math]]
	--[[@field globals boolean ]]

	--[[https://lovr.org/docs/lovr.conf  ]]
	--[[see also:  ]]
	--[[[`lovr.conf`](lua://lovr.conf)  ]]
	--[[@class lovr_conf_t_window]]
	--[[@field width number ]]
	--[[@field height number ]]
	--[[@field fullscreen boolean ]]
	--[[@field resizable boolean ]]
	--[[@field title string ]]
	--[[@field icon string ]]

	--[[@class lovr_object]]
	local Object_class
	--[[@type lovr_audio_material]]
	local AudioMaterial_class
	--[[@type lovr_audio_share_mode]]
	local AudioShareMode_class
	--[[@type lovr_audio_type]]
	local AudioType_class
	--[[@type lovr_effect]]
	local Effect_class
	--[[@class lovr_source]]
	local Source_class
	--[[@type lovr_time_unit]]
	local TimeUnit_class
	--[[@type lovr_volume_unit]]
	local VolumeUnit_class
	--[[@type lovr_animation_property]]
	local AnimationProperty_class
	--[[@type lovr_attribute_type]]
	local AttributeType_class
	--[[@class lovr_blob]]
	local Blob_class
	--[[@type lovr_channel_layout]]
	local ChannelLayout_class
	--[[@type lovr_default_attribute]]
	local DefaultAttribute_class
	--[[@class lovr_image]]
	local Image_class
	--[[@class lovr_model_data]]
	local ModelData_class
	--[[@type lovr_model_draw_mode]]
	local ModelDrawMode_class
	--[[@class lovr_rasterizer]]
	local Rasterizer_class
	--[[@type lovr_sample_format]]
	local SampleFormat_class
	--[[@type lovr_smooth_mode]]
	local SmoothMode_class
	--[[@class lovr_sound]]
	local Sound_class
	--[[@type lovr_texture_format]]
	local TextureFormat_class
	--[[@type lovr_key_code]]
	local KeyCode_class
	--[[@type lovr_blend_alpha_mode]]
	local BlendAlphaMode_class
	--[[@type lovr_blend_mode]]
	local BlendMode_class
	--[[@class lovr_buffer]]
	local Buffer_class
	--[[@type lovr_compare_mode]]
	local CompareMode_class
	--[[@type lovr_cull_mode]]
	local CullMode_class
	--[[@type lovr_data_layout]]
	local DataLayout_class
	--[[@type lovr_data_type]]
	local DataType_class
	--[[@type lovr_default_shader]]
	local DefaultShader_class
	--[[@type lovr_draw_mode]]
	local DrawMode_class
	--[[@type lovr_draw_style]]
	local DrawStyle_class
	--[[@type lovr_filter_mode]]
	local FilterMode_class
	--[[@class lovr_font]]
	local Font_class
	--[[@type lovr_horizontal_align]]
	local HorizontalAlign_class
	--[[@class lovr_material]]
	local Material_class
	--[[@class lovr_mesh]]
	local Mesh_class
	--[[@type lovr_mesh_storage]]
	local MeshStorage_class
	--[[@class lovr_model]]
	local Model_class
	--[[@type lovr_origin_type]]
	local OriginType_class
	--[[@class lovr_pass]]
	local Pass_class
	--[[@type lovr_pass_type]]
	local PassType_class
	--[[@class lovr_readback]]
	local Readback_class
	--[[@class lovr_sampler]]
	local Sampler_class
	--[[@class lovr_shader]]
	local Shader_class
	--[[@type lovr_shader_stage]]
	local ShaderStage_class
	--[[@type lovr_shader_type]]
	local ShaderType_class
	--[[@type lovr_stack_type]]
	local StackType_class
	--[[@type lovr_stencil_action]]
	local StencilAction_class
	--[[@class lovr_texture]]
	local Texture_class
	--[[@type lovr_texture_feature]]
	local TextureFeature_class
	--[[@type lovr_texture_type]]
	local TextureType_class
	--[[@type lovr_texture_usage]]
	local TextureUsage_class
	--[[@type lovr_vertical_align]]
	local VerticalAlign_class
	--[[@type lovr_winding]]
	local Winding_class
	--[[@type lovr_wrap_mode]]
	local WrapMode_class
	--[[@type lovr_device_axis]]
	local DeviceAxis_class
	--[[@type lovr_device_button]]
	local DeviceButton_class
	--[[@type lovr_device]]
	local Device_class
	--[[@type lovr_headset_driver]]
	local HeadsetDriver_class
	--[[@type lovr_headset_origin]]
	local HeadsetOrigin_class
	--[[@class lovr_layer]]
	local Layer_class
	--[[@type lovr_passthrough_mode]]
	local PassthroughMode_class
	--[[@type lovr_view_mask]]
	local ViewMask_class
	--[[@class lovr_curve]]
	local Curve_class
	--[[@class lovr_mat4]]
	local Mat4_class
	--[[@class lovr_quat]]
	local Quat_class
	--[[@class lovr_random_generator]]
	local RandomGenerator_class
	--[[@class lovr_vec2]]
	local Vec2_class
	--[[@class lovr_vec3]]
	local Vec3_class
	--[[@class lovr_vec4]]
	local Vec4_class
	--[[@class lovr_vectors]]
	local Vectors_class
	--[[@class lovr_ball_joint]]
	local BallJoint_class
	--[[@class lovr_box_shape]]
	local BoxShape_class
	--[[@class lovr_capsule_shape]]
	local CapsuleShape_class
	--[[@class lovr_collider]]
	local Collider_class
	--[[@class lovr_cone_joint]]
	local ConeJoint_class
	--[[@class lovr_contact]]
	local Contact_class
	--[[@class lovr_convex_shape]]
	local ConvexShape_class
	--[[@class lovr_cylinder_shape]]
	local CylinderShape_class
	--[[@class lovr_distance_joint]]
	local DistanceJoint_class
	--[[@class lovr_hinge_joint]]
	local HingeJoint_class
	--[[@class lovr_joint]]
	local Joint_class
	--[[@type lovr_joint_type]]
	local JointType_class
	--[[@class lovr_mesh_shape]]
	local MeshShape_class
	--[[@type lovr_motor_mode]]
	local MotorMode_class
	--[[@class lovr_shape]]
	local Shape_class
	--[[@type lovr_shape_type]]
	local ShapeType_class
	--[[@class lovr_slider_joint]]
	local SliderJoint_class
	--[[@class lovr_sphere_shape]]
	local SphereShape_class
	--[[@class lovr_terrain_shape]]
	local TerrainShape_class
	--[[@class lovr_weld_joint]]
	local WeldJoint_class
	--[[@class lovr_world]]
	local World_class
	--[[@type lovr_permission]]
	local Permission_class
	--[[@class lovr_channel]]
	local Channel_class
	--[[@class lovr_thread]]
	local Thread_class
	--[[https://lovr.org/docs/Object  ]]
	--[[The base object.  ]]
	--[[@class lovr_object]]

	--[[https://lovr.org/docs/Object:release  ]]
	--[[Immediately release the Lua reference to an object.  ]]
	--[[### See also]]
	--[[* [`Object`](lua://lovr_object)]]
	function Object_class:release() end

	--[[https://lovr.org/docs/Object:type  ]]
	--[[Get the type name of the object.  ]]
	--[[### See also]]
	--[[* [`Object`](lua://lovr_object)]]
	--[[@return string type]]
	function Object_class:type() return "" end

	--[[https://lovr.org/docs/lovr.audio  ]]
	--[[@class lovr_audio]]
	lovr.audio = {}

	--[[https://lovr.org/docs/AudioMaterial  ]]
	--[[Different types of audio materials.  ]]
	--[[### See also]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@enum lovr_audio_material]]
	local lovr_audio_material = {
		--[[Generic default audio material.  ]]
		generic = "generic",
		--[[Brick.  ]]
		brick = "brick",
		--[[Carpet.  ]]
		carpet = "carpet",
		--[[Ceramic.  ]]
		ceramic = "ceramic",
		--[[Concrete.  ]]
		concrete = "concrete",
		--[[Glass.  ]]
		glass = "glass",
		--[[Gravel.  ]]
		gravel = "gravel",
		--[[Metal.  ]]
		metal = "metal",
		--[[Plaster.  ]]
		plaster = "plaster",
		--[[Rock.  ]]
		rock = "rock",
		--[[Wood.  ]]
		wood = "wood",
	}

	--[[https://lovr.org/docs/AudioShareMode  ]]
	--[[How audio devices are shared on the system.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.setDevice`](lua://lovr.audio.setDevice)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@enum lovr_audio_share_mode]]
	local lovr_audio_share_mode = {
		--[[Shared mode.  ]]
		shared = "shared",
		--[[Exclusive mode.  ]]
		exclusive = "exclusive",
	}

	--[[https://lovr.org/docs/AudioType  ]]
	--[[Different types of audio devices  ]]
	--[[### See also]]
	--[[* [`lovr.audio.getDevices`](lua://lovr.audio.getDevices)]]
	--[[* [`lovr.audio.setDevice`](lua://lovr.audio.setDevice)]]
	--[[* [`lovr.audio.start`](lua://lovr.audio.start)]]
	--[[* [`lovr.audio.stop`](lua://lovr.audio.stop)]]
	--[[* [`lovr.audio.isStarted`](lua://lovr.audio.isStarted)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@enum lovr_audio_type]]
	local lovr_audio_type = {
		--[[The playback device (speakers, headphones).  ]]
		playback = "playback",
		--[[The capture device (microphone).  ]]
		capture = "capture",
	}

	--[[https://lovr.org/docs/Effect  ]]
	--[[Different types of Source effects.  ]]
	--[[### See also]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@enum lovr_effect]]
	local lovr_effect = {
		--[[Models absorption as sound travels through the air, water, etc.  ]]
		absorption = "absorption",
		--[[Decreases audio volume with distance (1 / max(distance, 1)).  ]]
		attenuation = "attenuation",
		--[[Causes audio to drop off when the Source is occluded by geometry.  ]]
		occlusion = "occlusion",
		--[[Models reverb caused by audio bouncing off of geometry.  ]]
		reverb = "reverb",
		--[[Spatializes the Source using either simple panning or an HRTF.  ]]
		spatialization = "spatialization",
		--[[Causes audio to be heard through walls when occluded, based on audio materials.  ]]
		transmission = "transmission",
	}

	--[[https://lovr.org/docs/lovr.audio.getAbsorption  ]]
	--[[Get the absorption coefficients.  ]]
	--[[### See also]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@return number low]]
	--[[@return number mid]]
	--[[@return number high]]
	function lovr.audio.getAbsorption() return 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.audio.getDevice  ]]
	--[[Get the current audio device.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.getDevices`](lua://lovr.audio.getDevices)]]
	--[[* [`lovr.audio.setDevice`](lua://lovr.audio.setDevice)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param type? lovr_audio_type default=`'playback'`]]
	--[[@return string name]]
	--[[@return userdata id]]
	function lovr.audio.getDevice(type) return "", userdata end

	--[[https://lovr.org/docs/lovr.audio.getDevices  ]]
	--[[Get a list of audio devices.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.setDevice`](lua://lovr.audio.setDevice)]]
	--[[* [`lovr.audio.getDevice`](lua://lovr.audio.getDevice)]]
	--[[* [`lovr.audio.start`](lua://lovr.audio.start)]]
	--[[* [`lovr.audio.stop`](lua://lovr.audio.stop)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param type? lovr_audio_type default=`'playback'`]]
	--[[@return lovr_audio_get_devices_devices[] devices]]
	function lovr.audio.getDevices(type) return {} end

	--[[https://lovr.org/docs/lovr.audio.getDevices  ]]
	--[[see also:  ]]
	--[[[`lovr.audio.getDevices`](lua://lovr.audio.getDevices)  ]]
	--[[@class lovr_audio_get_devices_devices]]
	--[[@field id userdata ]]
	--[[@field name string ]]
	--[[@field default boolean ]]

	--[[https://lovr.org/docs/lovr.audio.getOrientation  ]]
	--[[Get the orientation of the listener.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.getPosition`](lua://lovr.audio.getPosition)]]
	--[[* [`lovr.audio.getPose`](lua://lovr.audio.getPose)]]
	--[[* [`Source:getOrientation`](lua://lovr_source.getOrientation)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function lovr.audio.getOrientation() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.audio.getPose  ]]
	--[[Get the pose of the listener.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.getPosition`](lua://lovr.audio.getPosition)]]
	--[[* [`lovr.audio.getOrientation`](lua://lovr.audio.getOrientation)]]
	--[[* [`Source:getPose`](lua://lovr_source.getPose)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function lovr.audio.getPose() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.audio.getPosition  ]]
	--[[Get the position of the listener.  ]]
	--[[### See also]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function lovr.audio.getPosition() return 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.audio.getSampleRate  ]]
	--[[Get the playback device sample rate.  ]]
	--[[### See also]]
	--[[* [`lovr.conf`](lua://lovr.conf)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@return number rate]]
	function lovr.audio.getSampleRate() return 0 end

	--[[https://lovr.org/docs/lovr.audio.getSpatializer  ]]
	--[[Get the name of the active spatializer  ]]
	--[[### See also]]
	--[[* [`lovr.conf`](lua://lovr.conf)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@return string spatializer]]
	function lovr.audio.getSpatializer() return "" end

	--[[https://lovr.org/docs/lovr.audio.getVolume  ]]
	--[[Get the master volume.  ]]
	--[[### See also]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param units? lovr_volume_unit default=`'linear'`]]
	--[[@return number volume]]
	function lovr.audio.getVolume(units) return 0 end

	--[[https://lovr.org/docs/lovr.audio.isStarted  ]]
	--[[Check if an audio device is started.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.start`](lua://lovr.audio.start)]]
	--[[* [`lovr.audio.stop`](lua://lovr.audio.stop)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param type? lovr_audio_type default=`'playback'`]]
	--[[@return boolean started]]
	function lovr.audio.isStarted(type) return false end

	--[[https://lovr.org/docs/lovr.audio.newSource  ]]
	--[[Create a new Source.  ]]
	--[[### See also]]
	--[[* [`Source:clone`](lua://lovr_source.clone)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param filename string]]
	--[[@param options? lovr_audio_new_source_options]]
	--[[@return lovr_source source]]
	--[[@overload fun(blob: lovr_blob, options?: lovr_audio_new_source_options): lovr_source]]
	--[[@overload fun(sound: lovr_sound, options?: lovr_audio_new_source_options): lovr_source]]
	function lovr.audio.newSource(filename, options) return Source_class end

	--[[https://lovr.org/docs/lovr.audio.newSource  ]]
	--[[see also:  ]]
	--[[[`lovr.audio.newSource`](lua://lovr.audio.newSource)  ]]
	--[[@class lovr_audio_new_source_options]]
	--[[@field decode? boolean default=`false`]]
	--[[@field pitchable? boolean default=`true`]]
	--[[@field spatial? boolean default=`true`]]
	--[[@field effects? table<string,string|number> default=`nil`]]

	--[[https://lovr.org/docs/lovr.audio.setAbsorption  ]]
	--[[Set the absorption coefficients.  ]]
	--[[### See also]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param low number]]
	--[[@param mid number]]
	--[[@param high number]]
	function lovr.audio.setAbsorption(low, mid, high) end

	--[[https://lovr.org/docs/lovr.audio.setDevice  ]]
	--[[Switch audio devices.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.getDevice`](lua://lovr.audio.getDevice)]]
	--[[* [`lovr.audio.getDevices`](lua://lovr.audio.getDevices)]]
	--[[* [`lovr.audio.start`](lua://lovr.audio.start)]]
	--[[* [`lovr.audio.stop`](lua://lovr.audio.stop)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param type? lovr_audio_type default=`'playback'`]]
	--[[@param id? userdata default=`nil`]]
	--[[@param sink? lovr_sound default=`nil`]]
	--[[@param mode? lovr_audio_share_mode default=`shared`]]
	--[[@return boolean success]]
	function lovr.audio.setDevice(type, id, sink, mode) return false end

	--[[https://lovr.org/docs/lovr.audio.setGeometry  ]]
	--[[Set the geometry for audio effects.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.getSpatializer`](lua://lovr.audio.getSpatializer)]]
	--[[* [`Source:setEffectEnabled`](lua://lovr_source.setEffectEnabled)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param vertices table<string,string|number>]]
	--[[@param indices table<string,string|number>]]
	--[[@param material? lovr_audio_material default=`'generic'`]]
	--[[@return boolean success]]
	--[[@overload fun(model: lovr_model, material?: lovr_audio_material): boolean]]
	function lovr.audio.setGeometry(vertices, indices, material) return false end

	--[[https://lovr.org/docs/lovr.audio.setOrientation  ]]
	--[[Set the orientation of the listener.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.setPosition`](lua://lovr.audio.setPosition)]]
	--[[* [`lovr.audio.setPose`](lua://lovr.audio.setPose)]]
	--[[* [`Source:setOrientation`](lua://lovr_source.setOrientation)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(orientation: lovr_quat)]]
	function lovr.audio.setOrientation(angle, ax, ay, az) end

	--[[https://lovr.org/docs/lovr.audio.setPose  ]]
	--[[Set the pose of the listener.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.setPosition`](lua://lovr.audio.setPosition)]]
	--[[* [`lovr.audio.setOrientation`](lua://lovr.audio.setOrientation)]]
	--[[* [`Source:setPose`](lua://lovr_source.setPose)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(position: lovr_vec3, orientation: lovr_quat)]]
	function lovr.audio.setPose(x, y, z, angle, ax, ay, az) end

	--[[https://lovr.org/docs/lovr.audio.setPosition  ]]
	--[[Set the position of the listener.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.setOrientation`](lua://lovr.audio.setOrientation)]]
	--[[* [`lovr.audio.setPose`](lua://lovr.audio.setPose)]]
	--[[* [`Source:setPosition`](lua://lovr_source.setPosition)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(position: lovr_vec3)]]
	function lovr.audio.setPosition(x, y, z) end

	--[[https://lovr.org/docs/lovr.audio.setVolume  ]]
	--[[Set the master volume.  ]]
	--[[### See also]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param volume number]]
	--[[@param units? lovr_volume_unit default=`'linear'`]]
	function lovr.audio.setVolume(volume, units) end

	--[[https://lovr.org/docs/Source  ]]
	--[[A playable sound object.  ]]
	--[[@class lovr_source: lovr_object]]

	--[[https://lovr.org/docs/Source:clone  ]]
	--[[Create an identical copy of the Source.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.newSource`](lua://lovr.audio.newSource)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return lovr_source source]]
	function Source_class:clone() return Source_class end

	--[[https://lovr.org/docs/Source:getDirectivity  ]]
	--[[Get the directivity of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return number weight]]
	--[[@return number power]]
	function Source_class:getDirectivity() return 0, 0 end

	--[[https://lovr.org/docs/Source:getDuration  ]]
	--[[Get the duration of the Source.  ]]
	--[[### See also]]
	--[[* [`Sound:getDuration`](lua://lovr_sound.getDuration)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param unit? lovr_time_unit default=`'seconds'`]]
	--[[@return number duration]]
	function Source_class:getDuration(unit) return 0 end

	--[[https://lovr.org/docs/Source:getOrientation  ]]
	--[[Get the orientation of the Source.  ]]
	--[[### See also]]
	--[[* [`Source:getPosition`](lua://lovr_source.getPosition)]]
	--[[* [`Source:getPose`](lua://lovr_source.getPose)]]
	--[[* [`lovr.audio.getOrientation`](lua://lovr.audio.getOrientation)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Source_class:getOrientation() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Source:getPitch  ]]
	--[[Get the pitch of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return number pitch]]
	function Source_class:getPitch() return 0 end

	--[[https://lovr.org/docs/Source:getPose  ]]
	--[[Get the pose of the Source.  ]]
	--[[### See also]]
	--[[* [`Source:getPosition`](lua://lovr_source.getPosition)]]
	--[[* [`Source:getOrientation`](lua://lovr_source.getOrientation)]]
	--[[* [`lovr.audio.getPose`](lua://lovr.audio.getPose)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Source_class:getPose() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Source:getPosition  ]]
	--[[Get the position of the Source.  ]]
	--[[### See also]]
	--[[* [`Source:getOrientation`](lua://lovr_source.getOrientation)]]
	--[[* [`Source:getPose`](lua://lovr_source.getPose)]]
	--[[* [`lovr.audio.getPosition`](lua://lovr.audio.getPosition)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Source_class:getPosition() return 0, 0, 0 end

	--[[https://lovr.org/docs/Source:getRadius  ]]
	--[[Get the radius of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return number radius]]
	function Source_class:getRadius() return 0 end

	--[[https://lovr.org/docs/Source:getSound  ]]
	--[[Get the Sound object backing the Source.  ]]
	--[[### See also]]
	--[[* [`Source:clone`](lua://lovr_source.clone)]]
	--[[* [`lovr.audio.newSource`](lua://lovr.audio.newSource)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return lovr_sound sound]]
	function Source_class:getSound() return Sound_class end

	--[[https://lovr.org/docs/Source:getVolume  ]]
	--[[Get the volume of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param units? lovr_volume_unit default=`'linear'`]]
	--[[@return number volume]]
	function Source_class:getVolume(units) return 0 end

	--[[https://lovr.org/docs/Source:isEffectEnabled  ]]
	--[[Check if an effect is enabled.  ]]
	--[[### See also]]
	--[[* [`Source:isSpatial`](lua://lovr_source.isSpatial)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param effect lovr_effect]]
	--[[@return boolean enabled]]
	function Source_class:isEffectEnabled(effect) return false end

	--[[https://lovr.org/docs/Source:isLooping  ]]
	--[[Check if the Source is looping.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return boolean looping]]
	function Source_class:isLooping() return false end

	--[[https://lovr.org/docs/Source:isPlaying  ]]
	--[[Check if the Source is playing.  ]]
	--[[### See also]]
	--[[* [`Source:play`](lua://lovr_source.play)]]
	--[[* [`Source:pause`](lua://lovr_source.pause)]]
	--[[* [`Source:stop`](lua://lovr_source.stop)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return boolean playing]]
	function Source_class:isPlaying() return false end

	--[[https://lovr.org/docs/Source:isSpatial  ]]
	--[[Check if the Source is spatial.  ]]
	--[[### See also]]
	--[[* [`Source:isEffectEnabled`](lua://lovr_source.isEffectEnabled)]]
	--[[* [`Source:setEffectEnabled`](lua://lovr_source.setEffectEnabled)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return boolean spatial]]
	function Source_class:isSpatial() return false end

	--[[https://lovr.org/docs/Source:pause  ]]
	--[[Pause the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	function Source_class:pause() end

	--[[https://lovr.org/docs/Source:play  ]]
	--[[Play the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@return boolean success]]
	function Source_class:play() return false end

	--[[https://lovr.org/docs/Source:seek  ]]
	--[[Set the playback position of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param position number]]
	--[[@param unit? lovr_time_unit default=`'seconds'`]]
	function Source_class:seek(position, unit) end

	--[[https://lovr.org/docs/Source:setDirectivity  ]]
	--[[Set the directivity of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param weight number]]
	--[[@param power number]]
	function Source_class:setDirectivity(weight, power) end

	--[[https://lovr.org/docs/Source:setEffectEnabled  ]]
	--[[Enable or disable an effect.  ]]
	--[[### See also]]
	--[[* [`Source:isSpatial`](lua://lovr_source.isSpatial)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param effect lovr_effect]]
	--[[@param enable boolean]]
	function Source_class:setEffectEnabled(effect, enable) end

	--[[https://lovr.org/docs/Source:setLooping  ]]
	--[[Set whether or not the Source loops.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param loop boolean]]
	function Source_class:setLooping(loop) end

	--[[https://lovr.org/docs/Source:setOrientation  ]]
	--[[Set the orientation of the Source.  ]]
	--[[### See also]]
	--[[* [`Source:setPosition`](lua://lovr_source.setPosition)]]
	--[[* [`Source:setPose`](lua://lovr_source.setPose)]]
	--[[* [`lovr.audio.setOrientation`](lua://lovr.audio.setOrientation)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_source, orientation: lovr_quat)]]
	function Source_class:setOrientation(angle, ax, ay, az) end

	--[[https://lovr.org/docs/Source:setPitch  ]]
	--[[Set the pitch of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param pitch number]]
	function Source_class:setPitch(pitch) end

	--[[https://lovr.org/docs/Source:setPose  ]]
	--[[Set the pose of the Source.  ]]
	--[[### See also]]
	--[[* [`Source:setPosition`](lua://lovr_source.setPosition)]]
	--[[* [`Source:setOrientation`](lua://lovr_source.setOrientation)]]
	--[[* [`lovr.audio.setPose`](lua://lovr.audio.setPose)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_source, position: lovr_vec3, orientation: lovr_quat)]]
	function Source_class:setPose(x, y, z, angle, ax, ay, az) end

	--[[https://lovr.org/docs/Source:setPosition  ]]
	--[[Set the position of the Source.  ]]
	--[[### See also]]
	--[[* [`Source:setOrientation`](lua://lovr_source.setOrientation)]]
	--[[* [`Source:setPose`](lua://lovr_source.setPose)]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(self: lovr_source, position: lovr_vec3)]]
	function Source_class:setPosition(x, y, z) end

	--[[https://lovr.org/docs/Source:setRadius  ]]
	--[[Set the radius of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param radius number]]
	function Source_class:setRadius(radius) end

	--[[https://lovr.org/docs/Source:setVolume  ]]
	--[[Set the volume of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param volume number]]
	--[[@param units? lovr_volume_unit default=`'linear'`]]
	function Source_class:setVolume(volume, units) end

	--[[https://lovr.org/docs/Source:stop  ]]
	--[[Stop the Source.  ]]
	--[[### See also]]
	--[[* [`Source:play`](lua://lovr_source.play)]]
	--[[* [`Source:pause`](lua://lovr_source.pause)]]
	--[[* [`Source:isPlaying`](lua://lovr_source.isPlaying)]]
	--[[* [`Source`](lua://lovr_source)]]
	function Source_class:stop() end

	--[[https://lovr.org/docs/Source:tell  ]]
	--[[Get the playback position of the Source.  ]]
	--[[### See also]]
	--[[* [`Source`](lua://lovr_source)]]
	--[[@param unit? lovr_time_unit default=`'seconds'`]]
	--[[@return number position]]
	function Source_class:tell(unit) return 0 end

	--[[https://lovr.org/docs/lovr.audio.start  ]]
	--[[Start an audio device.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.getDevices`](lua://lovr.audio.getDevices)]]
	--[[* [`lovr.audio.setDevice`](lua://lovr.audio.setDevice)]]
	--[[* [`lovr.audio.stop`](lua://lovr.audio.stop)]]
	--[[* [`lovr.audio.isStarted`](lua://lovr.audio.isStarted)]]
	--[[* [`lovr.system.requestPermission`](lua://lovr.system.requestPermission)]]
	--[[* [`lovr.permission`](lua://lovr.permission)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param type? lovr_audio_type default=`'playback'`]]
	--[[@return boolean started]]
	function lovr.audio.start(type) return false end

	--[[https://lovr.org/docs/lovr.audio.stop  ]]
	--[[Stop an audio device.  ]]
	--[[### See also]]
	--[[* [`lovr.audio.getDevices`](lua://lovr.audio.getDevices)]]
	--[[* [`lovr.audio.setDevice`](lua://lovr.audio.setDevice)]]
	--[[* [`lovr.audio.start`](lua://lovr.audio.start)]]
	--[[* [`lovr.audio.isStarted`](lua://lovr.audio.isStarted)]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@param type? lovr_audio_type default=`'playback'`]]
	--[[@return boolean stopped]]
	function lovr.audio.stop(type) return false end

	--[[https://lovr.org/docs/TimeUnit  ]]
	--[[Time units for sound samples.  ]]
	--[[### See also]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@enum lovr_time_unit]]
	local lovr_time_unit = {
		--[[Seconds.  ]]
		seconds = "seconds",
		--[[Frames.  ]]
		frames = "frames",
	}

	--[[https://lovr.org/docs/VolumeUnit  ]]
	--[[Different units of volume.  ]]
	--[[### See also]]
	--[[* [`lovr.audio`](lua://lovr.audio)]]
	--[[@enum lovr_volume_unit]]
	local lovr_volume_unit = {
		--[[Linear volume range.  ]]
		linear = "linear",
		--[[Decibels.  ]]
		db = "db",
	}


	--[[https://lovr.org/docs/lovr.data  ]]
	--[[@class lovr_data]]
	lovr.data = {}

	--[[https://lovr.org/docs/AnimationProperty  ]]
	--[[Different animated properties.  ]]
	--[[### See also]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@enum lovr_animation_property]]
	local lovr_animation_property = {
		--[[Node translation.  ]]
		translation = "translation",
		--[[Node rotation.  ]]
		rotation = "rotation",
		--[[Node scale.  ]]
		scale = "scale",
		--[[Node blend shape weights.  ]]
		weights = "weights",
	}

	--[[https://lovr.org/docs/AttributeType  ]]
	--[[Data types for vertex attributes in meshes.  ]]
	--[[### See also]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@enum lovr_attribute_type]]
	local lovr_attribute_type = {
		--[[Signed 8 bit integers (-128 to 127).  ]]
		i8 = "i8",
		--[[Unsigned 8 bit integers (0 to 255).  ]]
		u8 = "u8",
		--[[Signed 16 bit integers (-32768 to 32767).  ]]
		i16 = "i16",
		--[[Unsigned 16 bit integers (0 to 65535).  ]]
		u16 = "u16",
		--[[Signed 32 bit integers (-2147483648 to 2147483647).  ]]
		i32 = "i32",
		--[[Unsigned 32 bit integers (0 to 429467295).  ]]
		u32 = "u32",
		--[[Floating point numbers.  ]]
		f32 = "f32",
	}

	--[[https://lovr.org/docs/Blob  ]]
	--[[A chunk of binary data.  ]]
	--[[@class lovr_blob: lovr_object]]

	--[[https://lovr.org/docs/Blob:getF32  ]]
	--[[Unpack 32-bit floating point numbers from the Blob.  ]]
	--[[### See also]]
	--[[* [`Blob:getI8`](lua://lovr_blob.getI8)]]
	--[[* [`Blob:getU8`](lua://lovr_blob.getU8)]]
	--[[* [`Blob:getI16`](lua://lovr_blob.getI16)]]
	--[[* [`Blob:getU16`](lua://lovr_blob.getU16)]]
	--[[* [`Blob:getI32`](lua://lovr_blob.getI32)]]
	--[[* [`Blob:getU32`](lua://lovr_blob.getU32)]]
	--[[* [`Blob:getF64`](lua://lovr_blob.getF64)]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@param offset? number default=`0`]]
	--[[@param count? number default=`1`]]
	--[[@return number ...]]
	function Blob_class:getF32(offset, count) return 0 end

	--[[https://lovr.org/docs/Blob:getF64  ]]
	--[[Unpack 64-bit floating point numbers from the Blob.  ]]
	--[[### See also]]
	--[[* [`Blob:getI8`](lua://lovr_blob.getI8)]]
	--[[* [`Blob:getU8`](lua://lovr_blob.getU8)]]
	--[[* [`Blob:getI16`](lua://lovr_blob.getI16)]]
	--[[* [`Blob:getU16`](lua://lovr_blob.getU16)]]
	--[[* [`Blob:getI32`](lua://lovr_blob.getI32)]]
	--[[* [`Blob:getU32`](lua://lovr_blob.getU32)]]
	--[[* [`Blob:getF32`](lua://lovr_blob.getF32)]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@param offset? number default=`0`]]
	--[[@param count? number default=`1`]]
	--[[@return number ...]]
	function Blob_class:getF64(offset, count) return 0 end

	--[[https://lovr.org/docs/Blob:getI16  ]]
	--[[Unpack signed 16-bit integers from the Blob.  ]]
	--[[### See also]]
	--[[* [`Blob:getI8`](lua://lovr_blob.getI8)]]
	--[[* [`Blob:getU8`](lua://lovr_blob.getU8)]]
	--[[* [`Blob:getU16`](lua://lovr_blob.getU16)]]
	--[[* [`Blob:getI32`](lua://lovr_blob.getI32)]]
	--[[* [`Blob:getU32`](lua://lovr_blob.getU32)]]
	--[[* [`Blob:getF32`](lua://lovr_blob.getF32)]]
	--[[* [`Blob:getF64`](lua://lovr_blob.getF64)]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@param offset? number default=`0`]]
	--[[@param count? number default=`1`]]
	--[[@return number ...]]
	function Blob_class:getI16(offset, count) return 0 end

	--[[https://lovr.org/docs/Blob:getI32  ]]
	--[[Unpack signed 32-bit integers from the Blob.  ]]
	--[[### See also]]
	--[[* [`Blob:getI8`](lua://lovr_blob.getI8)]]
	--[[* [`Blob:getU8`](lua://lovr_blob.getU8)]]
	--[[* [`Blob:getI16`](lua://lovr_blob.getI16)]]
	--[[* [`Blob:getU16`](lua://lovr_blob.getU16)]]
	--[[* [`Blob:getU32`](lua://lovr_blob.getU32)]]
	--[[* [`Blob:getF32`](lua://lovr_blob.getF32)]]
	--[[* [`Blob:getF64`](lua://lovr_blob.getF64)]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@param offset? number default=`0`]]
	--[[@param count? number default=`1`]]
	--[[@return number ...]]
	function Blob_class:getI32(offset, count) return 0 end

	--[[https://lovr.org/docs/Blob:getI8  ]]
	--[[Unpack signed 8-bit integers from the Blob.  ]]
	--[[### See also]]
	--[[* [`Blob:getU8`](lua://lovr_blob.getU8)]]
	--[[* [`Blob:getI16`](lua://lovr_blob.getI16)]]
	--[[* [`Blob:getU16`](lua://lovr_blob.getU16)]]
	--[[* [`Blob:getI32`](lua://lovr_blob.getI32)]]
	--[[* [`Blob:getU32`](lua://lovr_blob.getU32)]]
	--[[* [`Blob:getF32`](lua://lovr_blob.getF32)]]
	--[[* [`Blob:getF64`](lua://lovr_blob.getF64)]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@param offset? number default=`0`]]
	--[[@param count? number default=`1`]]
	--[[@return number ...]]
	function Blob_class:getI8(offset, count) return 0 end

	--[[https://lovr.org/docs/Blob:getName  ]]
	--[[Get the label of the Blob.  ]]
	--[[### See also]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@return string name]]
	function Blob_class:getName() return "" end

	--[[https://lovr.org/docs/Blob:getPointer  ]]
	--[[Get a raw pointer to the Blob's data.  ]]
	--[[### See also]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@return userdata pointer]]
	function Blob_class:getPointer() return userdata end

	--[[https://lovr.org/docs/Blob:getSize  ]]
	--[[Get the size of the Blob, in bytes.  ]]
	--[[### See also]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@return number bytes]]
	function Blob_class:getSize() return 0 end

	--[[https://lovr.org/docs/Blob:getString  ]]
	--[[Get the Blob's contents as a string.  ]]
	--[[### See also]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@param offset? number default=`0`]]
	--[[@param size? number default=`nil`]]
	--[[@return string data]]
	function Blob_class:getString(offset, size) return "" end

	--[[https://lovr.org/docs/Blob:getU16  ]]
	--[[Unpack unsigned 16-bit integers from the Blob.  ]]
	--[[### See also]]
	--[[* [`Blob:getI8`](lua://lovr_blob.getI8)]]
	--[[* [`Blob:getU8`](lua://lovr_blob.getU8)]]
	--[[* [`Blob:getI16`](lua://lovr_blob.getI16)]]
	--[[* [`Blob:getI32`](lua://lovr_blob.getI32)]]
	--[[* [`Blob:getU32`](lua://lovr_blob.getU32)]]
	--[[* [`Blob:getF32`](lua://lovr_blob.getF32)]]
	--[[* [`Blob:getF64`](lua://lovr_blob.getF64)]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@param offset? number default=`0`]]
	--[[@param count? number default=`1`]]
	--[[@return number ...]]
	function Blob_class:getU16(offset, count) return 0 end

	--[[https://lovr.org/docs/Blob:getU32  ]]
	--[[Unpack unsigned 32-bit integers from the Blob.  ]]
	--[[### See also]]
	--[[* [`Blob:getI8`](lua://lovr_blob.getI8)]]
	--[[* [`Blob:getU8`](lua://lovr_blob.getU8)]]
	--[[* [`Blob:getI16`](lua://lovr_blob.getI16)]]
	--[[* [`Blob:getU16`](lua://lovr_blob.getU16)]]
	--[[* [`Blob:getI32`](lua://lovr_blob.getI32)]]
	--[[* [`Blob:getF32`](lua://lovr_blob.getF32)]]
	--[[* [`Blob:getF64`](lua://lovr_blob.getF64)]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@param offset? number default=`0`]]
	--[[@param count? number default=`1`]]
	--[[@return number ...]]
	function Blob_class:getU32(offset, count) return 0 end

	--[[https://lovr.org/docs/Blob:getU8  ]]
	--[[Unpack unsigned 8-bit integers from the Blob.  ]]
	--[[### See also]]
	--[[* [`Blob:getI8`](lua://lovr_blob.getI8)]]
	--[[* [`Blob:getI16`](lua://lovr_blob.getI16)]]
	--[[* [`Blob:getU16`](lua://lovr_blob.getU16)]]
	--[[* [`Blob:getI32`](lua://lovr_blob.getI32)]]
	--[[* [`Blob:getU32`](lua://lovr_blob.getU32)]]
	--[[* [`Blob:getF32`](lua://lovr_blob.getF32)]]
	--[[* [`Blob:getF64`](lua://lovr_blob.getF64)]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[@param offset? number default=`0`]]
	--[[@param count? number default=`1`]]
	--[[@return number ...]]
	function Blob_class:getU8(offset, count) return 0 end

	--[[https://lovr.org/docs/ChannelLayout  ]]
	--[[Different channel layouts for Sounds.  ]]
	--[[### See also]]
	--[[* [`lovr.data.newSound`](lua://lovr.data.newSound)]]
	--[[* [`Sound:getFormat`](lua://lovr_sound.getFormat)]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@enum lovr_channel_layout]]
	local lovr_channel_layout = {
		--[[1 channel.  ]]
		mono = "mono",
		--[[2 channels.  The first channel is for the left speaker and the second is for the right.  ]]
		stereo = "stereo",
		--[[4 channels.  Ambisonic channels don't map directly to speakers but instead represent directions in 3D space, sort of like the images of a skybox.  Currently, ambisonic sounds can only be loaded, not played.  ]]
		ambisonic = "ambisonic",
	}

	--[[https://lovr.org/docs/DefaultAttribute  ]]
	--[[Attributes that can be loaded from a model.  ]]
	--[[### See also]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@enum lovr_default_attribute]]
	local lovr_default_attribute = {
		--[[Vertex positions.  ]]
		position = "position",
		--[[Vertex normal vectors.  ]]
		normal = "normal",
		--[[Vertex texture coordinates.  ]]
		uv = "uv",
		--[[Vertex colors.  ]]
		color = "color",
		--[[Vertex tangent vectors.  ]]
		tangent = "tangent",
		--[[Vertex joint indices.  ]]
		joints = "joints",
		--[[Vertex joint weights.  ]]
		weights = "weights",
	}

	--[[https://lovr.org/docs/Image  ]]
	--[[An object that stores pixel data for Textures.  ]]
	--[[@class lovr_image: lovr_object]]

	--[[https://lovr.org/docs/Image:encode  ]]
	--[[Encode the Image as png.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem.write`](lua://lovr.filesystem.write)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@return lovr_blob blob]]
	function Image_class:encode() return Blob_class end

	--[[https://lovr.org/docs/Image:getBlob  ]]
	--[[Get the bytes backing this Image as a `Blob`.  ]]
	--[[### See also]]
	--[[* [`Blob:getPointer`](lua://lovr_blob.getPointer)]]
	--[[* [`Sound:getBlob`](lua://lovr_sound.getBlob)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@return lovr_blob blob]]
	function Image_class:getBlob() return Blob_class end

	--[[https://lovr.org/docs/Image:getDimensions  ]]
	--[[Get the dimensions of the Image.  ]]
	--[[### See also]]
	--[[* [`Image:getWidth`](lua://lovr_image.getWidth)]]
	--[[* [`Image:getHeight`](lua://lovr_image.getHeight)]]
	--[[* [`Texture:getDimensions`](lua://lovr_texture.getDimensions)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@return number width]]
	--[[@return number height]]
	function Image_class:getDimensions() return 0, 0 end

	--[[https://lovr.org/docs/Image:getFormat  ]]
	--[[Get the pixel format of the Image.  ]]
	--[[### See also]]
	--[[* [`TextureFormat`](lua://lovr_textureFormat)]]
	--[[* [`Texture:getFormat`](lua://lovr_texture.getFormat)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@return lovr_texture_format format]]
	function Image_class:getFormat() return TextureFormat_class end

	--[[https://lovr.org/docs/Image:getHeight  ]]
	--[[Get the height of the Image.  ]]
	--[[### See also]]
	--[[* [`Image:getWidth`](lua://lovr_image.getWidth)]]
	--[[* [`Image:getDimensions`](lua://lovr_image.getDimensions)]]
	--[[* [`Texture:getHeight`](lua://lovr_texture.getHeight)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@return number height]]
	function Image_class:getHeight() return 0 end

	--[[https://lovr.org/docs/Image:getPixel  ]]
	--[[Get the value of a pixel of the Image.  ]]
	--[[### See also]]
	--[[* [`Image:setPixel`](lua://lovr_image.setPixel)]]
	--[[* [`Image:mapPixel`](lua://lovr_image.mapPixel)]]
	--[[* [`TextureFormat`](lua://lovr_textureFormat)]]
	--[[* [`Texture:getPixels`](lua://lovr_texture.getPixels)]]
	--[[* [`Texture:setPixels`](lua://lovr_texture.setPixels)]]
	--[[* [`Texture:newReadback`](lua://lovr_texture.newReadback)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@return number r]]
	--[[@return number g]]
	--[[@return number b]]
	--[[@return number a]]
	function Image_class:getPixel(x, y) return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Image:getWidth  ]]
	--[[Get the width of the Image.  ]]
	--[[### See also]]
	--[[* [`Image:getHeight`](lua://lovr_image.getHeight)]]
	--[[* [`Image:getDimensions`](lua://lovr_image.getDimensions)]]
	--[[* [`Texture:getWidth`](lua://lovr_texture.getWidth)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@return number width]]
	function Image_class:getWidth() return 0 end

	--[[https://lovr.org/docs/Image:mapPixel  ]]
	--[[Transform an Image by applying a function to every pixel.  ]]
	--[[### See also]]
	--[[* [`Image:setPixel`](lua://lovr_image.setPixel)]]
	--[[* [`Image:getPixel`](lua://lovr_image.getPixel)]]
	--[[* [`TextureFormat`](lua://lovr_textureFormat)]]
	--[[* [`Texture:setPixels`](lua://lovr_texture.setPixels)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@param callback function]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param w? number default=`image:getWidth()`]]
	--[[@param h? number default=`image:getHeight()`]]
	function Image_class:mapPixel(callback, x, y, w, h) end

	--[[https://lovr.org/docs/Image:paste  ]]
	--[[Copy pixels from another Image to this one.  ]]
	--[[### See also]]
	--[[* [`Image:getPixel`](lua://lovr_image.getPixel)]]
	--[[* [`Image:setPixel`](lua://lovr_image.setPixel)]]
	--[[* [`Texture:setPixels`](lua://lovr_texture.setPixels)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@param source lovr_image]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param fromX? number default=`0`]]
	--[[@param fromY? number default=`0`]]
	--[[@param width? number default=`source:getWidth()`]]
	--[[@param height? number default=`source:getHeight()`]]
	function Image_class:paste(source, x, y, fromX, fromY, width, height) end

	--[[https://lovr.org/docs/Image:setPixel  ]]
	--[[Set the value of a pixel of the Image.  ]]
	--[[### See also]]
	--[[* [`Image:mapPixel`](lua://lovr_image.mapPixel)]]
	--[[* [`Image:getPixel`](lua://lovr_image.getPixel)]]
	--[[* [`TextureFormat`](lua://lovr_textureFormat)]]
	--[[* [`Texture:setPixels`](lua://lovr_texture.setPixels)]]
	--[[* [`Image`](lua://lovr_image)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param r number]]
	--[[@param g number]]
	--[[@param b number]]
	--[[@param a? number default=`1.0`]]
	function Image_class:setPixel(x, y, r, g, b, a) end

	--[[https://lovr.org/docs/ModelData  ]]
	--[[An object that loads and stores data for 3D models.  ]]
	--[[@class lovr_model_data: lovr_object]]

	--[[https://lovr.org/docs/ModelData:getAnimationChannelCount  ]]
	--[[Get the number of channels in an animation.  ]]
	--[[### See also]]
	--[[* [`ModelData:getAnimationNode`](lua://lovr_modelData.getAnimationNode)]]
	--[[* [`ModelData:getAnimationProperty`](lua://lovr_modelData.getAnimationProperty)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return number count]]
	--[[@overload fun(self: lovr_model_data, name: string): number]]
	function ModelData_class:getAnimationChannelCount(index) return 0 end

	--[[https://lovr.org/docs/ModelData:getAnimationCount  ]]
	--[[Get the number of animations in the model.  ]]
	--[[### See also]]
	--[[* [`Model:getAnimationCount`](lua://lovr_model.getAnimationCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getAnimationCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getAnimationDuration  ]]
	--[[Get the duration of an animation.  ]]
	--[[### See also]]
	--[[* [`Model:getAnimationDuration`](lua://lovr_model.getAnimationDuration)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return number duration]]
	--[[@overload fun(self: lovr_model_data, name: string): number]]
	function ModelData_class:getAnimationDuration(index) return 0 end

	--[[https://lovr.org/docs/ModelData:getAnimationKeyframeCount  ]]
	--[[Get the number of keyframes in a channel of an animation.  ]]
	--[[### See also]]
	--[[* [`ModelData:getAnimationSmoothMode`](lua://lovr_modelData.getAnimationSmoothMode)]]
	--[[* [`ModelData:getAnimationKeyframe`](lua://lovr_modelData.getAnimationKeyframe)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@param channel number]]
	--[[@return number count]]
	--[[@overload fun(self: lovr_model_data, name: string, channel: number): number]]
	function ModelData_class:getAnimationKeyframeCount(index, channel) return 0 end

	--[[https://lovr.org/docs/ModelData:getAnimationKeyframe  ]]
	--[[Get a keyframe in a channel of an animation.  ]]
	--[[### See also]]
	--[[* [`ModelData:getAnimationSmoothMode`](lua://lovr_modelData.getAnimationSmoothMode)]]
	--[[* [`ModelData:getAnimationKeyframeCount`](lua://lovr_modelData.getAnimationKeyframeCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@param channel number]]
	--[[@param keyframe number]]
	--[[@return number time]]
	--[[@return number ...]]
	--[[@overload fun(self: lovr_model_data, name: string, channel: number, keyframe: number): number, number]]
	function ModelData_class:getAnimationKeyframe(index, channel, keyframe) return 0, 0 end

	--[[https://lovr.org/docs/ModelData:getAnimationName  ]]
	--[[Get the name of an animation.  ]]
	--[[### See also]]
	--[[* [`Model:getAnimationName`](lua://lovr_model.getAnimationName)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return string name]]
	function ModelData_class:getAnimationName(index) return "" end

	--[[https://lovr.org/docs/ModelData:getAnimationNode  ]]
	--[[Get the node targeted by the channel of an animation.  ]]
	--[[### See also]]
	--[[* [`ModelData:getAnimationProperty`](lua://lovr_modelData.getAnimationProperty)]]
	--[[* [`ModelData:getAnimationSmoothMode`](lua://lovr_modelData.getAnimationSmoothMode)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@param channel number]]
	--[[@return number node]]
	--[[@overload fun(self: lovr_model_data, name: string, channel: number): number]]
	function ModelData_class:getAnimationNode(index, channel) return 0 end

	--[[https://lovr.org/docs/ModelData:getAnimationProperty  ]]
	--[[Get the property targeted by the channel of an animation.  ]]
	--[[### See also]]
	--[[* [`ModelData:getAnimationNode`](lua://lovr_modelData.getAnimationNode)]]
	--[[* [`ModelData:getAnimationSmoothMode`](lua://lovr_modelData.getAnimationSmoothMode)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@param channel number]]
	--[[@return lovr_animation_property property]]
	--[[@overload fun(self: lovr_model_data, name: string, channel: number): lovr_animation_property]]
	function ModelData_class:getAnimationProperty(index, channel) return AnimationProperty_class end

	--[[https://lovr.org/docs/ModelData:getAnimationSmoothMode  ]]
	--[[Get the smooth mode of a channel in an animation.  ]]
	--[[### See also]]
	--[[* [`ModelData:getAnimationNode`](lua://lovr_modelData.getAnimationNode)]]
	--[[* [`ModelData:getAnimationProperty`](lua://lovr_modelData.getAnimationProperty)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@param channel number]]
	--[[@return lovr_smooth_mode smooth]]
	--[[@overload fun(self: lovr_model_data, name: string, channel: number): lovr_smooth_mode]]
	function ModelData_class:getAnimationSmoothMode(index, channel) return SmoothMode_class end

	--[[https://lovr.org/docs/ModelData:getBlendShapeCount  ]]
	--[[Get the number of blend shapes in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getBlendShapeName`](lua://lovr_modelData.getBlendShapeName)]]
	--[[* [`Model:getBlendShapeCount`](lua://lovr_model.getBlendShapeCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getBlendShapeCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getBlendShapeName  ]]
	--[[Get the name of a blend shape in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getBlendShapeCount`](lua://lovr_modelData.getBlendShapeCount)]]
	--[[* [`Model:getBlendShapeName`](lua://lovr_model.getBlendShapeName)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return string name]]
	function ModelData_class:getBlendShapeName(index) return "" end

	--[[https://lovr.org/docs/ModelData:getBlobCount  ]]
	--[[Get the number of Blobs stored in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getBlob`](lua://lovr_modelData.getBlob)]]
	--[[* [`ModelData:getImageCount`](lua://lovr_modelData.getImageCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getBlobCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getBlob  ]]
	--[[Get a Blob in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getBlobCount`](lua://lovr_modelData.getBlobCount)]]
	--[[* [`ModelData:getImage`](lua://lovr_modelData.getImage)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return lovr_blob blob]]
	function ModelData_class:getBlob(index) return Blob_class end

	--[[https://lovr.org/docs/ModelData:getBoundingBox  ]]
	--[[Get the bounding box of the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getWidth`](lua://lovr_modelData.getWidth)]]
	--[[* [`ModelData:getHeight`](lua://lovr_modelData.getHeight)]]
	--[[* [`ModelData:getDepth`](lua://lovr_modelData.getDepth)]]
	--[[* [`ModelData:getDimensions`](lua://lovr_modelData.getDimensions)]]
	--[[* [`ModelData:getCenter`](lua://lovr_modelData.getCenter)]]
	--[[* [`ModelData:getBoundingSphere`](lua://lovr_modelData.getBoundingSphere)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number minx]]
	--[[@return number maxx]]
	--[[@return number miny]]
	--[[@return number maxy]]
	--[[@return number minz]]
	--[[@return number maxz]]
	function ModelData_class:getBoundingBox() return 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getBoundingSphere  ]]
	--[[Get the bounding sphere of the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getWidth`](lua://lovr_modelData.getWidth)]]
	--[[* [`ModelData:getHeight`](lua://lovr_modelData.getHeight)]]
	--[[* [`ModelData:getDepth`](lua://lovr_modelData.getDepth)]]
	--[[* [`ModelData:getDimensions`](lua://lovr_modelData.getDimensions)]]
	--[[* [`ModelData:getCenter`](lua://lovr_modelData.getCenter)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Model:getBoundingSphere`](lua://lovr_model.getBoundingSphere)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number radius]]
	function ModelData_class:getBoundingSphere() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getCenter  ]]
	--[[Get the center of the model's bounding box.  ]]
	--[[### See also]]
	--[[* [`ModelData:getWidth`](lua://lovr_modelData.getWidth)]]
	--[[* [`ModelData:getHeight`](lua://lovr_modelData.getHeight)]]
	--[[* [`ModelData:getDepth`](lua://lovr_modelData.getDepth)]]
	--[[* [`ModelData:getDimensions`](lua://lovr_modelData.getDimensions)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Model:getCenter`](lua://lovr_model.getCenter)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function ModelData_class:getCenter() return 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getDepth  ]]
	--[[Get the depth of the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getWidth`](lua://lovr_modelData.getWidth)]]
	--[[* [`ModelData:getHeight`](lua://lovr_modelData.getHeight)]]
	--[[* [`ModelData:getDimensions`](lua://lovr_modelData.getDimensions)]]
	--[[* [`ModelData:getCenter`](lua://lovr_modelData.getCenter)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Model:getDepth`](lua://lovr_model.getDepth)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number depth]]
	function ModelData_class:getDepth() return 0 end

	--[[https://lovr.org/docs/ModelData:getDimensions  ]]
	--[[Get the dimensions of the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getWidth`](lua://lovr_modelData.getWidth)]]
	--[[* [`ModelData:getHeight`](lua://lovr_modelData.getHeight)]]
	--[[* [`ModelData:getDepth`](lua://lovr_modelData.getDepth)]]
	--[[* [`ModelData:getCenter`](lua://lovr_modelData.getCenter)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Model:getDimensions`](lua://lovr_model.getDimensions)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number width]]
	--[[@return number height]]
	--[[@return number depth]]
	function ModelData_class:getDimensions() return 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getHeight  ]]
	--[[Get the height of the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getWidth`](lua://lovr_modelData.getWidth)]]
	--[[* [`ModelData:getDepth`](lua://lovr_modelData.getDepth)]]
	--[[* [`ModelData:getDimensions`](lua://lovr_modelData.getDimensions)]]
	--[[* [`ModelData:getCenter`](lua://lovr_modelData.getCenter)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Model:getHeight`](lua://lovr_model.getHeight)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number height]]
	function ModelData_class:getHeight() return 0 end

	--[[https://lovr.org/docs/ModelData:getImageCount  ]]
	--[[Get the number of Images stored in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getImage`](lua://lovr_modelData.getImage)]]
	--[[* [`ModelData:getBlobCount`](lua://lovr_modelData.getBlobCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getImageCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getImage  ]]
	--[[Get an Image in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getImageCount`](lua://lovr_modelData.getImageCount)]]
	--[[* [`ModelData:getBlob`](lua://lovr_modelData.getBlob)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return lovr_image image]]
	function ModelData_class:getImage(index) return Image_class end

	--[[https://lovr.org/docs/ModelData:getMaterialCount  ]]
	--[[Get the number of materials in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMaterialName`](lua://lovr_modelData.getMaterialName)]]
	--[[* [`ModelData:getMeshMaterial`](lua://lovr_modelData.getMeshMaterial)]]
	--[[* [`ModelData:getMaterial`](lua://lovr_modelData.getMaterial)]]
	--[[* [`Model:getMaterialCount`](lua://lovr_model.getMaterialCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getMaterialCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getMaterial  ]]
	--[[Get the material properties for a material in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMaterialCount`](lua://lovr_modelData.getMaterialCount)]]
	--[[* [`ModelData:getMeshMaterial`](lua://lovr_modelData.getMeshMaterial)]]
	--[[* [`lovr.graphics.newMaterial`](lua://lovr.graphics.newMaterial)]]
	--[[* [`Model:getMaterial`](lua://lovr_model.getMaterial)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return lovr_data_model_data_get_material_properties properties]]
	--[[@overload fun(self: lovr_model_data, name: string): lovr_data_model_data_get_material_properties]]
	function ModelData_class:getMaterial(index) return {} end

	--[[https://lovr.org/docs/ModelData:getMaterialName  ]]
	--[[Get the name of a material in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMaterialCount`](lua://lovr_modelData.getMaterialCount)]]
	--[[* [`ModelData:getMeshMaterial`](lua://lovr_modelData.getMeshMaterial)]]
	--[[* [`ModelData:getMaterial`](lua://lovr_modelData.getMaterial)]]
	--[[* [`Model:getMaterialName`](lua://lovr_model.getMaterialName)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return string name]]
	function ModelData_class:getMaterialName(index) return "" end

	--[[https://lovr.org/docs/ModelData:getMeshCount  ]]
	--[[Get the number of meshes in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getNodeMeshes`](lua://lovr_modelData.getNodeMeshes)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getMeshCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getMeshDrawMode  ]]
	--[[Get the draw mode of a mesh.  ]]
	--[[### See also]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param mesh number]]
	--[[@return lovr_model_draw_mode mode]]
	function ModelData_class:getMeshDrawMode(mesh) return ModelDrawMode_class end

	--[[https://lovr.org/docs/ModelData:getMeshIndexCount  ]]
	--[[Get the number of vertex indices in a mesh.  ]]
	--[[### See also]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param mesh number]]
	--[[@return number count]]
	function ModelData_class:getMeshIndexCount(mesh) return 0 end

	--[[https://lovr.org/docs/ModelData:getMeshIndexFormat  ]]
	--[[Get the data format of vertex indices in a mesh.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMeshVertexFormat`](lua://lovr_modelData.getMeshVertexFormat)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param mesh number]]
	--[[@return lovr_attribute_type type]]
	--[[@return number blob]]
	--[[@return number offset]]
	--[[@return number stride]]
	function ModelData_class:getMeshIndexFormat(mesh) return AttributeType_class, 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getMeshIndex  ]]
	--[[Get one of the vertex indices in a mesh.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMeshIndexFormat`](lua://lovr_modelData.getMeshIndexFormat)]]
	--[[* [`ModelData:getMeshIndexCount`](lua://lovr_modelData.getMeshIndexCount)]]
	--[[* [`ModelData:getMeshVertex`](lua://lovr_modelData.getMeshVertex)]]
	--[[* [`ModelData:getTriangles`](lua://lovr_modelData.getTriangles)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param mesh number]]
	--[[@param index number]]
	--[[@return number vertexindex]]
	function ModelData_class:getMeshIndex(mesh, index) return 0 end

	--[[https://lovr.org/docs/ModelData:getMeshMaterial  ]]
	--[[Get the index of the material applied to a mesh.  ]]
	--[[### See also]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param mesh number]]
	--[[@return number material]]
	function ModelData_class:getMeshMaterial(mesh) return 0 end

	--[[https://lovr.org/docs/ModelData:getMeshVertexCount  ]]
	--[[Get the number of vertices in a mesh.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMeshIndexCount`](lua://lovr_modelData.getMeshIndexCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param mesh number]]
	--[[@return number count]]
	function ModelData_class:getMeshVertexCount(mesh) return 0 end

	--[[https://lovr.org/docs/ModelData:getMeshVertexFormat  ]]
	--[[Get the vertex format of a mesh.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMeshIndexFormat`](lua://lovr_modelData.getMeshIndexFormat)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param mesh number]]
	--[[@return table<string,string|number> format]]
	function ModelData_class:getMeshVertexFormat(mesh) return {} end

	--[[https://lovr.org/docs/ModelData:getMeshVertex  ]]
	--[[Get the data for a single vertex in a mesh.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMeshVertexFormat`](lua://lovr_modelData.getMeshVertexFormat)]]
	--[[* [`ModelData:getMeshVertexCount`](lua://lovr_modelData.getMeshVertexCount)]]
	--[[* [`ModelData:getMeshIndex`](lua://lovr_modelData.getMeshIndex)]]
	--[[* [`ModelData:getTriangles`](lua://lovr_modelData.getTriangles)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param mesh number]]
	--[[@param vertex number]]
	--[[@return number ...]]
	function ModelData_class:getMeshVertex(mesh, vertex) return 0 end

	--[[https://lovr.org/docs/ModelData:getMetadata  ]]
	--[[Get extra information from the model file.  ]]
	--[[### See also]]
	--[[* [`Model:getMetadata`](lua://lovr_model.getMetadata)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return string metadata]]
	function ModelData_class:getMetadata() return "" end

	--[[https://lovr.org/docs/ModelData:getNodeChildren  ]]
	--[[Get the children of a node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getNodeParent`](lua://lovr_modelData.getNodeParent)]]
	--[[* [`ModelData:getRootNode`](lua://lovr_modelData.getRootNode)]]
	--[[* [`Model:getNodeChildren`](lua://lovr_model.getNodeChildren)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return table<string,string|number> children]]
	--[[@overload fun(self: lovr_model_data, name: string): table<string,string|number>]]
	function ModelData_class:getNodeChildren(index) return {} end

	--[[https://lovr.org/docs/ModelData:getNodeCount  ]]
	--[[Get the number of nodes in the model.  ]]
	--[[### See also]]
	--[[* [`Model:getNodeCount`](lua://lovr_model.getNodeCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getNodeCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getNodeMeshes  ]]
	--[[Get the indices of meshes attached to a node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMeshCount`](lua://lovr_modelData.getMeshCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return table<string,string|number> meshes]]
	--[[@overload fun(self: lovr_model_data, name: string): table<string,string|number>]]
	function ModelData_class:getNodeMeshes(index) return {} end

	--[[https://lovr.org/docs/ModelData:getNodeName  ]]
	--[[Get the name of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodeName`](lua://lovr_model.getNodeName)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return string name]]
	function ModelData_class:getNodeName(index) return "" end

	--[[https://lovr.org/docs/ModelData:getNodeOrientation  ]]
	--[[Get the local orientation of a node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getNodePosition`](lua://lovr_modelData.getNodePosition)]]
	--[[* [`ModelData:getNodeScale`](lua://lovr_modelData.getNodeScale)]]
	--[[* [`ModelData:getNodePose`](lua://lovr_modelData.getNodePose)]]
	--[[* [`ModelData:getNodeTransform`](lua://lovr_modelData.getNodeTransform)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	--[[@overload fun(self: lovr_model_data, name: string): number, number, number, number]]
	function ModelData_class:getNodeOrientation(index) return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getNodeParent  ]]
	--[[Get the parent of a node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getNodeChildren`](lua://lovr_modelData.getNodeChildren)]]
	--[[* [`ModelData:getRootNode`](lua://lovr_modelData.getRootNode)]]
	--[[* [`Model:getNodeParent`](lua://lovr_model.getNodeParent)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return number parent]]
	--[[@overload fun(self: lovr_model_data, name: string): number]]
	function ModelData_class:getNodeParent(index) return 0 end

	--[[https://lovr.org/docs/ModelData:getNodePose  ]]
	--[[Get the local pose of a node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getNodePosition`](lua://lovr_modelData.getNodePosition)]]
	--[[* [`ModelData:getNodeOrientation`](lua://lovr_modelData.getNodeOrientation)]]
	--[[* [`ModelData:getNodeScale`](lua://lovr_modelData.getNodeScale)]]
	--[[* [`ModelData:getNodeTransform`](lua://lovr_modelData.getNodeTransform)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	--[[@overload fun(self: lovr_model_data, name: string): number, number, number, number, number, number, number]]
	function ModelData_class:getNodePose(index) return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getNodePosition  ]]
	--[[Get the local position of a node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getNodeOrientation`](lua://lovr_modelData.getNodeOrientation)]]
	--[[* [`ModelData:getNodeScale`](lua://lovr_modelData.getNodeScale)]]
	--[[* [`ModelData:getNodePose`](lua://lovr_modelData.getNodePose)]]
	--[[* [`ModelData:getNodeTransform`](lua://lovr_modelData.getNodeTransform)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@overload fun(self: lovr_model_data, name: string): number, number, number]]
	function ModelData_class:getNodePosition(index) return 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getNodeScale  ]]
	--[[Get the local scale of a node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getNodePosition`](lua://lovr_modelData.getNodePosition)]]
	--[[* [`ModelData:getNodeOrientation`](lua://lovr_modelData.getNodeOrientation)]]
	--[[* [`ModelData:getNodePose`](lua://lovr_modelData.getNodePose)]]
	--[[* [`ModelData:getNodeTransform`](lua://lovr_modelData.getNodeTransform)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return number sx]]
	--[[@return number sy]]
	--[[@return number sz]]
	--[[@overload fun(self: lovr_model_data, name: string): number, number, number]]
	function ModelData_class:getNodeScale(index) return 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getNodeSkin  ]]
	--[[Get the index of the skin used by a node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getSkinCount`](lua://lovr_modelData.getSkinCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return number skin]]
	--[[@overload fun(self: lovr_model_data, name: string): number]]
	function ModelData_class:getNodeSkin(index) return 0 end

	--[[https://lovr.org/docs/ModelData:getNodeTransform  ]]
	--[[Get the local transform of a node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getNodePosition`](lua://lovr_modelData.getNodePosition)]]
	--[[* [`ModelData:getNodeOrientation`](lua://lovr_modelData.getNodeOrientation)]]
	--[[* [`ModelData:getNodeScale`](lua://lovr_modelData.getNodeScale)]]
	--[[* [`ModelData:getNodePose`](lua://lovr_modelData.getNodePose)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param index number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number sx]]
	--[[@return number sy]]
	--[[@return number sz]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	--[[@overload fun(self: lovr_model_data, name: string): number, number, number, number, number, number, number, number, number, number]]
	function ModelData_class:getNodeTransform(index) return 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/ModelData:getRootNode  ]]
	--[[Get the index of the root node.  ]]
	--[[### See also]]
	--[[* [`ModelData:getNodeCount`](lua://lovr_modelData.getNodeCount)]]
	--[[* [`ModelData:getNodeParent`](lua://lovr_modelData.getNodeParent)]]
	--[[* [`Model:getRootNode`](lua://lovr_model.getRootNode)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number root]]
	function ModelData_class:getRootNode() return 0 end

	--[[https://lovr.org/docs/ModelData:getSkinCount  ]]
	--[[Get the number of skins in the model.  ]]
	--[[### See also]]
	--[[* [`Model:hasJoints`](lua://lovr_model.hasJoints)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getSkinCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getSkinInverseBindMatrix  ]]
	--[[Get the inverse bind matrix for a joint in the skin.  ]]
	--[[### See also]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param skin number]]
	--[[@param joint number]]
	--[[@return number ...]]
	function ModelData_class:getSkinInverseBindMatrix(skin, joint) return 0 end

	--[[https://lovr.org/docs/ModelData:getSkinJoints  ]]
	--[[Get the joints in a skin.  ]]
	--[[### See also]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@param skin number]]
	--[[@return table<string,string|number> joints]]
	function ModelData_class:getSkinJoints(skin) return {} end

	--[[https://lovr.org/docs/ModelData:getTriangleCount  ]]
	--[[Get the total number of triangles in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getTriangles`](lua://lovr_modelData.getTriangles)]]
	--[[* [`ModelData:getVertexCount`](lua://lovr_modelData.getVertexCount)]]
	--[[* [`Model:getTriangleCount`](lua://lovr_model.getTriangleCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getTriangleCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getTriangles  ]]
	--[[Get all the triangles in the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getTriangleCount`](lua://lovr_modelData.getTriangleCount)]]
	--[[* [`ModelData:getVertexCount`](lua://lovr_modelData.getVertexCount)]]
	--[[* [`Model:getTriangles`](lua://lovr_model.getTriangles)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return table<string,string|number> vertices]]
	--[[@return table<string,string|number> indices]]
	function ModelData_class:getTriangles() return {}, {} end

	--[[https://lovr.org/docs/ModelData:getVertexCount  ]]
	--[[Get the total vertex count of the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getTriangles`](lua://lovr_modelData.getTriangles)]]
	--[[* [`ModelData:getTriangleCount`](lua://lovr_modelData.getTriangleCount)]]
	--[[* [`Model:getVertexCount`](lua://lovr_model.getVertexCount)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number count]]
	function ModelData_class:getVertexCount() return 0 end

	--[[https://lovr.org/docs/ModelData:getWidth  ]]
	--[[Get the width of the model.  ]]
	--[[### See also]]
	--[[* [`ModelData:getHeight`](lua://lovr_modelData.getHeight)]]
	--[[* [`ModelData:getDepth`](lua://lovr_modelData.getDepth)]]
	--[[* [`ModelData:getDimensions`](lua://lovr_modelData.getDimensions)]]
	--[[* [`ModelData:getCenter`](lua://lovr_modelData.getCenter)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Model:getWidth`](lua://lovr_model.getWidth)]]
	--[[* [`ModelData`](lua://lovr_modelData)]]
	--[[@return number width]]
	function ModelData_class:getWidth() return 0 end

	--[[https://lovr.org/docs/ModelDrawMode  ]]
	--[[Different draw modes for meshes in ModelDatas.  ]]
	--[[### See also]]
	--[[* [`ModelData:getMeshDrawMode`](lua://lovr_modelData.getMeshDrawMode)]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@enum lovr_model_draw_mode]]
	local lovr_model_draw_mode = {
		--[[Each vertex is draw as a single point.  ]]
		points = "points",
		--[[Every pair of vertices is drawn as a line.  ]]
		lines = "lines",
		--[[Draws a single line through all of the vertices.  ]]
		linestrip = "linestrip",
		--[[Draws a single line through all of the vertices, then connects back to the first vertex.  ]]
		lineloop = "lineloop",
		--[[Vertices are rendered as triangles.  After the first 3 vertices, each subsequent vertex connects to the previous two.  ]]
		strip = "strip",
		--[[Every 3 vertices forms a triangle.  ]]
		triangles = "triangles",
		--[[Vertices are rendered as triangles.  After the first 3 vertices, each subsequent vertex is connected to the previous vertex and the first vertex.  ]]
		fan = "fan",
	}

	--[[https://lovr.org/docs/ModelData:getMaterial  ]]
	--[[see also:  ]]
	--[[[`ModelData:getMaterial`](lua://ModelData:getMaterial)  ]]
	--[[@class lovr_data_model_data_get_material_properties]]
	--[[@field color table<string,string|number> ]]
	--[[@field glow table<string,string|number> ]]
	--[[@field uvShift table<string,string|number> ]]
	--[[@field uvScale table<string,string|number> ]]
	--[[@field metalness number ]]
	--[[@field roughness number ]]
	--[[@field clearcoat number ]]
	--[[@field clearcoatRoughness number ]]
	--[[@field occlusionStrength number ]]
	--[[@field normalScale number ]]
	--[[@field alphaCutoff number ]]
	--[[@field texture number ]]
	--[[@field glowTexture number ]]
	--[[@field occlusionTexture number ]]
	--[[@field metalnessTexture number ]]
	--[[@field roughnessTexture number ]]
	--[[@field clearcoatTexture number ]]
	--[[@field normalTexture number ]]

	--[[https://lovr.org/docs/lovr.data.newBlob  ]]
	--[[Create a new Blob.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem.newBlob`](lua://lovr.filesystem.newBlob)]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@param size number]]
	--[[@param name? string default=`''`]]
	--[[@return lovr_blob blob]]
	--[[@overload fun(contents: string, name?: string): lovr_blob]]
	--[[@overload fun(source: lovr_blob, name?: string): lovr_blob]]
	function lovr.data.newBlob(size, name) return Blob_class end

	--[[https://lovr.org/docs/lovr.data.newImage  ]]
	--[[Create a new Image.  ]]
	--[[### See also]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@param filename string]]
	--[[@return lovr_image image]]
	--[[@overload fun(width: number, height: number, format?: lovr_texture_format, data?: lovr_blob): lovr_image]]
	--[[@overload fun(source: lovr_image): lovr_image]]
	--[[@overload fun(blob: lovr_blob): lovr_image]]
	function lovr.data.newImage(filename) return Image_class end

	--[[https://lovr.org/docs/lovr.data.newModelData  ]]
	--[[Create a new ModelData.  ]]
	--[[### See also]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@param filename string]]
	--[[@return lovr_model_data modelData]]
	--[[@overload fun(blob: lovr_blob): lovr_model_data]]
	function lovr.data.newModelData(filename) return ModelData_class end

	--[[https://lovr.org/docs/lovr.data.newRasterizer  ]]
	--[[Create a new Rasterizer.  ]]
	--[[### See also]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@param size? number default=`32`]]
	--[[@return lovr_rasterizer rasterizer]]
	--[[@overload fun(filename: string, size?: number): lovr_rasterizer]]
	--[[@overload fun(blob: lovr_blob, size?: number): lovr_rasterizer]]
	function lovr.data.newRasterizer(size) return Rasterizer_class end

	--[[https://lovr.org/docs/lovr.data.newSound  ]]
	--[[Create a new Sound.  ]]
	--[[### See also]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@param frames number]]
	--[[@param format? lovr_sample_format default=`'f32'`]]
	--[[@param channels? lovr_channel_layout default=`'stereo'`]]
	--[[@param sampleRate? number default=`48000`]]
	--[[@param contents? unknown default=`nil`]]
	--[[@return lovr_sound sound]]
	--[[@overload fun(filename: string, decode: boolean): lovr_sound]]
	--[[@overload fun(blob: lovr_blob, decode: boolean): lovr_sound]]
	function lovr.data.newSound(frames, format, channels, sampleRate, contents) return Sound_class end

	--[[https://lovr.org/docs/Rasterizer  ]]
	--[[An object that rasterizes glyphs from font files.  ]]
	--[[@class lovr_rasterizer: lovr_object]]

	--[[https://lovr.org/docs/Rasterizer:getAdvance  ]]
	--[[Get the advance of a glyph.  ]]
	--[[### See also]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param character string]]
	--[[@return number advance]]
	--[[@overload fun(self: lovr_rasterizer, codepoint: number): number]]
	function Rasterizer_class:getAdvance(character) return 0 end

	--[[https://lovr.org/docs/Rasterizer:getAscent  ]]
	--[[Get the ascent of the font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getDescent`](lua://lovr_rasterizer.getDescent)]]
	--[[* [`Font:getAscent`](lua://lovr_font.getAscent)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@return number ascent]]
	function Rasterizer_class:getAscent() return 0 end

	--[[https://lovr.org/docs/Rasterizer:getBearing  ]]
	--[[Get the bearing of a glyph.  ]]
	--[[### See also]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param character string]]
	--[[@return number bearing]]
	--[[@overload fun(self: lovr_rasterizer, codepoint: number): number]]
	function Rasterizer_class:getBearing(character) return 0 end

	--[[https://lovr.org/docs/Rasterizer:getBoundingBox  ]]
	--[[Get the bounding box of a glyph, or the font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getWidth`](lua://lovr_rasterizer.getWidth)]]
	--[[* [`Rasterizer:getHeight`](lua://lovr_rasterizer.getHeight)]]
	--[[* [`Rasterizer:getDimensions`](lua://lovr_rasterizer.getDimensions)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param character string]]
	--[[@return number x1]]
	--[[@return number y1]]
	--[[@return number x2]]
	--[[@return number y2]]
	--[[@overload fun(self: lovr_rasterizer, codepoint: number): number, number, number, number]]
	--[[@overload fun(self: lovr_rasterizer): number, number, number, number]]
	function Rasterizer_class:getBoundingBox(character) return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Rasterizer:getCurves  ]]
	--[[Get the bezier curves defining a glyph.  ]]
	--[[### See also]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[* [`Rasterizer:newImage`](lua://lovr_rasterizer.newImage)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param character string]]
	--[[@param three boolean]]
	--[[@return table<string,string|number> curves]]
	--[[@overload fun(self: lovr_rasterizer, codepoint: number, three: boolean): table<string,string|number>]]
	function Rasterizer_class:getCurves(character, three) return {} end

	--[[https://lovr.org/docs/Rasterizer:getDescent  ]]
	--[[Get the descent of the font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getAscent`](lua://lovr_rasterizer.getAscent)]]
	--[[* [`Font:getDescent`](lua://lovr_font.getDescent)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@return number descent]]
	function Rasterizer_class:getDescent() return 0 end

	--[[https://lovr.org/docs/Rasterizer:getDimensions  ]]
	--[[Get the dimensions of a glyph, or the font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getWidth`](lua://lovr_rasterizer.getWidth)]]
	--[[* [`Rasterizer:getHeight`](lua://lovr_rasterizer.getHeight)]]
	--[[* [`Rasterizer:getBoundingBox`](lua://lovr_rasterizer.getBoundingBox)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param character string]]
	--[[@return number width]]
	--[[@return number height]]
	--[[@overload fun(self: lovr_rasterizer, codepoint: number): number, number]]
	--[[@overload fun(self: lovr_rasterizer): number, number]]
	function Rasterizer_class:getDimensions(character) return 0, 0 end

	--[[https://lovr.org/docs/Rasterizer:getFontSize  ]]
	--[[Get the size of the font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getHeight`](lua://lovr_rasterizer.getHeight)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@return number size]]
	function Rasterizer_class:getFontSize() return 0 end

	--[[https://lovr.org/docs/Rasterizer:getGlyphCount  ]]
	--[[Get the number of glyphs stored in the font file.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:hasGlyphs`](lua://lovr_rasterizer.hasGlyphs)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@return number count]]
	function Rasterizer_class:getGlyphCount() return 0 end

	--[[https://lovr.org/docs/Rasterizer:getHeight  ]]
	--[[Get the height of a glyph, or the font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getWidth`](lua://lovr_rasterizer.getWidth)]]
	--[[* [`Rasterizer:getDimensions`](lua://lovr_rasterizer.getDimensions)]]
	--[[* [`Rasterizer:getBoundingBox`](lua://lovr_rasterizer.getBoundingBox)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param character string]]
	--[[@return number height]]
	--[[@overload fun(self: lovr_rasterizer, codepoint: number): number]]
	--[[@overload fun(self: lovr_rasterizer): number]]
	function Rasterizer_class:getHeight(character) return 0 end

	--[[https://lovr.org/docs/Rasterizer:getKerning  ]]
	--[[Get the kerning between two glyphs.  ]]
	--[[### See also]]
	--[[* [`Font:getKerning`](lua://lovr_font.getKerning)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param first string]]
	--[[@param second string]]
	--[[@return number keming]]
	--[[@overload fun(self: lovr_rasterizer, firstCodepoint: number, second: string): number]]
	--[[@overload fun(self: lovr_rasterizer, first: string, secondCodepoint: number): number]]
	--[[@overload fun(self: lovr_rasterizer, firstCodepoint: number, secondCodepoint: number): number]]
	function Rasterizer_class:getKerning(first, second) return 0 end

	--[[https://lovr.org/docs/Rasterizer:getLeading  ]]
	--[[Get the leading of the font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getAscent`](lua://lovr_rasterizer.getAscent)]]
	--[[* [`Rasterizer:getDescent`](lua://lovr_rasterizer.getDescent)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@return number leading]]
	function Rasterizer_class:getLeading() return 0 end

	--[[https://lovr.org/docs/Rasterizer:getWidth  ]]
	--[[Get the width of a glyph, or the font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getHeight`](lua://lovr_rasterizer.getHeight)]]
	--[[* [`Rasterizer:getDimensions`](lua://lovr_rasterizer.getDimensions)]]
	--[[* [`Rasterizer:getBoundingBox`](lua://lovr_rasterizer.getBoundingBox)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param character string]]
	--[[@return number width]]
	--[[@overload fun(self: lovr_rasterizer, codepoint: number): number]]
	--[[@overload fun(self: lovr_rasterizer): number]]
	function Rasterizer_class:getWidth(character) return 0 end

	--[[https://lovr.org/docs/Rasterizer:hasGlyphs  ]]
	--[[Get whether the Rasterizer can rasterize a set of glyphs.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getGlyphCount`](lua://lovr_rasterizer.getGlyphCount)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param ... unknown]]
	--[[@return boolean hasGlyphs]]
	function Rasterizer_class:hasGlyphs(...) return false end

	--[[https://lovr.org/docs/Rasterizer:newImage  ]]
	--[[Get an Image of a rasterized glyph.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getCurves`](lua://lovr_rasterizer.getCurves)]]
	--[[* [`Rasterizer`](lua://lovr_rasterizer)]]
	--[[@param character string]]
	--[[@param spread? number default=`4.0`]]
	--[[@param padding? number default=`spread / 2`]]
	--[[@return lovr_image image]]
	--[[@overload fun(self: lovr_rasterizer, codepoint: number, spread?: number, padding?: number): lovr_image]]
	function Rasterizer_class:newImage(character, spread, padding) return Image_class end

	--[[https://lovr.org/docs/SampleFormat  ]]
	--[[Different data types for samples in a Sound.  ]]
	--[[### See also]]
	--[[* [`lovr.data.newSound`](lua://lovr.data.newSound)]]
	--[[* [`Sound:getFormat`](lua://lovr_sound.getFormat)]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@enum lovr_sample_format]]
	local lovr_sample_format = {
		--[[32 bit floating point samples (between -1.0 and 1.0).  ]]
		f32 = "f32",
		--[[16 bit integer samples (between -32768 and 32767).  ]]
		i16 = "i16",
	}

	--[[https://lovr.org/docs/SmoothMode  ]]
	--[[Different ways to interpolate between animation keyframes.  ]]
	--[[### See also]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@enum lovr_smooth_mode]]
	local lovr_smooth_mode = {
		--[[The animated property will snap to the nearest keyframe.  ]]
		step = "step",
		--[[The animated property will linearly interpolate between keyframes.  ]]
		linear = "linear",
		--[[The animated property will follow a smooth curve between nearby keyframes.  ]]
		cubic = "cubic",
	}

	--[[https://lovr.org/docs/Sound  ]]
	--[[An object that holds raw audio samples.  ]]
	--[[@class lovr_sound: lovr_object]]

	--[[https://lovr.org/docs/Sound:getBlob  ]]
	--[[Get the bytes backing this Sound as a Blob.  ]]
	--[[### See also]]
	--[[* [`Blob:getPointer`](lua://lovr_blob.getPointer)]]
	--[[* [`Image:getBlob`](lua://lovr_image.getBlob)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return lovr_blob blob]]
	function Sound_class:getBlob() return Blob_class end

	--[[https://lovr.org/docs/Sound:getCapacity  ]]
	--[[Get the number of frames that can be written to the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound:getFrameCount`](lua://lovr_sound.getFrameCount)]]
	--[[* [`Sound:getSampleCount`](lua://lovr_sound.getSampleCount)]]
	--[[* [`Source:getDuration`](lua://lovr_source.getDuration)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return number capacity]]
	function Sound_class:getCapacity() return 0 end

	--[[https://lovr.org/docs/Sound:getChannelCount  ]]
	--[[Get the number of channels in the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound:getChannelLayout`](lua://lovr_sound.getChannelLayout)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return number channels]]
	function Sound_class:getChannelCount() return 0 end

	--[[https://lovr.org/docs/Sound:getChannelLayout  ]]
	--[[Get the channel layout of the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound:getChannelCount`](lua://lovr_sound.getChannelCount)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return lovr_channel_layout channels]]
	function Sound_class:getChannelLayout() return ChannelLayout_class end

	--[[https://lovr.org/docs/Sound:getDuration  ]]
	--[[Get the duration of the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound:getFrameCount`](lua://lovr_sound.getFrameCount)]]
	--[[* [`Sound:getSampleCount`](lua://lovr_sound.getSampleCount)]]
	--[[* [`Sound:getSampleRate`](lua://lovr_sound.getSampleRate)]]
	--[[* [`Source:getDuration`](lua://lovr_source.getDuration)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return number duration]]
	function Sound_class:getDuration() return 0 end

	--[[https://lovr.org/docs/Sound:getFormat  ]]
	--[[Get the sample format of the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound:getChannelLayout`](lua://lovr_sound.getChannelLayout)]]
	--[[* [`Sound:getSampleRate`](lua://lovr_sound.getSampleRate)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return lovr_sample_format format]]
	function Sound_class:getFormat() return SampleFormat_class end

	--[[https://lovr.org/docs/Sound:getFrameCount  ]]
	--[[Get the number of frames in the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound:getDuration`](lua://lovr_sound.getDuration)]]
	--[[* [`Sound:getSampleCount`](lua://lovr_sound.getSampleCount)]]
	--[[* [`Sound:getChannelCount`](lua://lovr_sound.getChannelCount)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return number frames]]
	function Sound_class:getFrameCount() return 0 end

	--[[https://lovr.org/docs/Sound:getFrames  ]]
	--[[Read frames from the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@param count? number default=`nil`]]
	--[[@param srcOffset? number default=`0`]]
	--[[@return table<string,string|number> t]]
	--[[@return number count]]
	--[[@overload fun(self: lovr_sound, t: table<string,string|number>, count?: number, srcOffset?: number, dstOffset?: number): table<string,string|number>, number]]
	--[[@overload fun(self: lovr_sound, blob: lovr_blob, count?: number, srcOffset?: number, dstOffset?: number): number]]
	--[[@overload fun(self: lovr_sound, sound: lovr_sound, count?: number, srcOffset?: number, dstOffset?: number): number]]
	function Sound_class:getFrames(count, srcOffset) return {}, 0 end

	--[[https://lovr.org/docs/Sound:getSampleCount  ]]
	--[[Get the number of samples in the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound:getDuration`](lua://lovr_sound.getDuration)]]
	--[[* [`Sound:getFrameCount`](lua://lovr_sound.getFrameCount)]]
	--[[* [`Sound:getChannelCount`](lua://lovr_sound.getChannelCount)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return number samples]]
	function Sound_class:getSampleCount() return 0 end

	--[[https://lovr.org/docs/Sound:getSampleRate  ]]
	--[[Get the sample rate of the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return number frequency]]
	function Sound_class:getSampleRate() return 0 end

	--[[https://lovr.org/docs/Sound:isCompressed  ]]
	--[[Check if the Sound is compressed.  ]]
	--[[### See also]]
	--[[* [`Sound:isStream`](lua://lovr_sound.isStream)]]
	--[[* [`lovr.data.newSound`](lua://lovr.data.newSound)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return boolean compressed]]
	function Sound_class:isCompressed() return false end

	--[[https://lovr.org/docs/Sound:isStream  ]]
	--[[Check if the Sound is a stream.  ]]
	--[[### See also]]
	--[[* [`Sound:isCompressed`](lua://lovr_sound.isCompressed)]]
	--[[* [`lovr.data.newSound`](lua://lovr.data.newSound)]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@return boolean stream]]
	function Sound_class:isStream() return false end

	--[[https://lovr.org/docs/Sound:setFrames  ]]
	--[[Write frames to the Sound.  ]]
	--[[### See also]]
	--[[* [`Sound`](lua://lovr_sound)]]
	--[[@param t table<string,string|number>]]
	--[[@param count? number default=`nil`]]
	--[[@param dstOffset? number default=`0`]]
	--[[@param srcOffset? number default=`0`]]
	--[[@return number count]]
	--[[@overload fun(self: lovr_sound, blob: lovr_blob, count?: number, dstOffset?: number, srcOffset?: number): number]]
	--[[@overload fun(self: lovr_sound, sound: lovr_sound, count?: number, dstOffset?: number, srcOffset?: number): number]]
	function Sound_class:setFrames(t, count, dstOffset, srcOffset) return 0 end

	--[[https://lovr.org/docs/TextureFormat  ]]
	--[[Different pixel formats in `Image` and `Texture` objects.  ]]
	--[[### See also]]
	--[[* [`lovr.data`](lua://lovr.data)]]
	--[[@enum lovr_texture_format]]
	local lovr_texture_format = {
		--[[One 8-bit channel.  1 byte per pixel.  ]]
		r8 = "r8",
		--[[Two 8-bit channels.  2 bytes per pixel.  ]]
		rg8 = "rg8",
		--[[Four 8-bit channels.  4 bytes per pixel.  ]]
		rgba8 = "rgba8",
		--[[One 16-bit channel.  2 bytes per pixel.  ]]
		r16 = "r16",
		--[[Two 16-bit channels.  4 bytes per pixel.  ]]
		rg16 = "rg16",
		--[[Four 16-bit channels.  8 bytes per pixel.  ]]
		rgba16 = "rgba16",
		--[[One 16-bit floating point channel.  2 bytes per pixel.  ]]
		r16f = "r16f",
		--[[Two 16-bit floating point channels.  4 bytes per pixel.  ]]
		rg16f = "rg16f",
		--[[Four 16-bit floating point channels.  8 bytes per pixel.  ]]
		rgba16f = "rgba16f",
		--[[One 32-bit floating point channel.  4 bytes per pixel.  ]]
		r32f = "r32f",
		--[[Two 32-bit floating point channels.  8 bytes per pixel.  ]]
		rg32f = "rg32f",
		--[[Four 32-bit floating point channels.  16 bytes per pixel.  ]]
		rgba32f = "rgba32f",
		--[[Packs three channels into 16 bits.  2 bytes per pixel.  ]]
		rgb565 = "rgb565",
		--[[Packs four channels into 16 bits, with "cutout" alpha.  2 bytes per pixel.  ]]
		rgb5a1 = "rgb5a1",
		--[[Packs four channels into 32 bits.  4 bytes per pixel.  ]]
		rgb10a2 = "rgb10a2",
		--[[Packs three unsigned floating point channels into 32 bits.  4 bytes per pixel.  ]]
		rg11b10f = "rg11b10f",
		--[[One 16-bit depth channel.  2 bytes per pixel.  ]]
		d16 = "d16",
		--[[One 24-bit depth channel and one 8-bit stencil channel.  4 bytes per pixel.  ]]
		d24s8 = "d24s8",
		--[[One 32-bit floating point depth channel.  4 bytes per pixel.  ]]
		d32f = "d32f",
		--[[One 32-bit floating point depth channel and one 8-bit stencil channel.  5 bytes per pixel.  ]]
		d32fs8 = "d32fs8",
		--[[3 channels.  8 bytes per 4x4 block, or 0.5 bytes per pixel.  Good for opaque images.  ]]
		bc1 = "bc1",
		--[[Four channels.  16 bytes per 4x4 block or 1 byte per pixel.  Not good for anything, because it only has 16 distinct levels of alpha.  ]]
		bc2 = "bc2",
		--[[Four channels.  16 bytes per 4x4 block or 1 byte per pixel.  Good for color images with transparency.  ]]
		bc3 = "bc3",
		--[[One unsigned normalized channel.  8 bytes per 4x4 block or 0.5 bytes per pixel.  Good for grayscale images, like heightmaps.  ]]
		bc4u = "bc4u",
		--[[One signed normalized channel.  8 bytes per 4x4 block or 0.5 bytes per pixel.  Similar to bc4u but has a range of -1 to 1.  ]]
		bc4s = "bc4s",
		--[[Two unsigned normalized channels.  16 bytes per 4x4 block, or 1 byte per pixel.  Good for normal maps.  ]]
		bc5u = "bc5u",
		--[[Two signed normalized channels.  16 bytes per 4x4 block or 1 byte per pixel.  Good for normal maps.  ]]
		bc5s = "bc5s",
		--[[Three unsigned floating point channels.  16 bytes per 4x4 block or 1 byte per pixel.  Good for HDR images.  ]]
		bc6uf = "bc6uf",
		--[[Three floating point channels.  16 bytes per 4x4 block or 1 byte per pixel.  Good for HDR images.  ]]
		bc6sf = "bc6sf",
		--[[Four channels.  16 bytes per 4x4 block or 1 byte per pixel.  High quality.  Good for most color images, including transparency.  ]]
		bc7 = "bc7",
		--[[Four channels, 16 bytes per 4x4 block or 1 byte per pixel.  ]]
		astc4x4 = "astc4x4",
		--[[Four channels, 16 bytes per 5x4 block or 0.80 bytes per pixel.  ]]
		astc5x4 = "astc5x4",
		--[[Four channels, 16 bytes per 5x5 block or 0.64 bytes per pixel.  ]]
		astc5x5 = "astc5x5",
		--[[Four channels, 16 bytes per 6x5 block or 0.53 bytes per pixel.  ]]
		astc6x5 = "astc6x5",
		--[[Four channels, 16 bytes per 6x6 block or 0.44 bytes per pixel.  ]]
		astc6x6 = "astc6x6",
		--[[Four channels, 16 bytes per 8x5 block or 0.40 bytes per pixel.  ]]
		astc8x5 = "astc8x5",
		--[[Four channels, 16 bytes per 8x6 block or 0.33 bytes per pixel.  ]]
		astc8x6 = "astc8x6",
		--[[Four channels, 16 bytes per 8x8 block or 0.25 bytes per pixel.  ]]
		astc8x8 = "astc8x8",
		--[[Four channels, 16 bytes per 10x5 block or 0.32 bytes per pixel.  ]]
		astc10x5 = "astc10x5",
		--[[Four channels, 16 bytes per 10x6 block or 0.27 bytes per pixel.  ]]
		astc10x6 = "astc10x6",
		--[[Four channels, 16 bytes per 10x8 block or 0.20 bytes per pixel.  ]]
		astc10x8 = "astc10x8",
		--[[Four channels, 16 bytes per 10x10 block or 0.16 bytes per pixel.  ]]
		astc10x10 = "astc10x10",
		--[[Four channels, 16 bytes per 12x10 block or 0.13 bytes per pixel.  ]]
		astc12x10 = "astc12x10",
		--[[Four channels, 16 bytes per 12x12 block or 0.11 bytes per pixel.  ]]
		astc12x12 = "astc12x12",
	}


	--[[https://lovr.org/docs/lovr.enet  ]]
	--[[@class lovr_enet]]
	lovr.enet = {}


	--[[https://lovr.org/docs/lovr.event  ]]
	--[[@class lovr_event]]
	lovr.event = {}

	--[[https://lovr.org/docs/lovr.event.clear  ]]
	--[[Clear the event queue.  ]]
	--[[### See also]]
	--[[* [`lovr.event`](lua://lovr.event)]]
	function lovr.event.clear() end

	--[[https://lovr.org/docs/KeyCode  ]]
	--[[Keys that can be pressed.  ]]
	--[[### See also]]
	--[[* [`lovr.keypressed`](lua://lovr.keypressed)]]
	--[[* [`lovr.keyreleased`](lua://lovr.keyreleased)]]
	--[[* [`lovr.event`](lua://lovr.event)]]
	--[[@enum lovr_key_code]]
	local lovr_key_code = {
		--[[The A key.  ]]
		a = "a",
		--[[The B key.  ]]
		b = "b",
		--[[The C key.  ]]
		c = "c",
		--[[The D key.  ]]
		d = "d",
		--[[The E key.  ]]
		e = "e",
		--[[The F key.  ]]
		f = "f",
		--[[The G key.  ]]
		g = "g",
		--[[The H key.  ]]
		h = "h",
		--[[The I key.  ]]
		i = "i",
		--[[The J key.  ]]
		j = "j",
		--[[The K key.  ]]
		k = "k",
		--[[The L key.  ]]
		l = "l",
		--[[The M key.  ]]
		m = "m",
		--[[The N key.  ]]
		n = "n",
		--[[The O key.  ]]
		o = "o",
		--[[The P key.  ]]
		p = "p",
		--[[The Q key.  ]]
		q = "q",
		--[[The R key.  ]]
		r = "r",
		--[[The S key.  ]]
		s = "s",
		--[[The T key.  ]]
		t = "t",
		--[[The U key.  ]]
		u = "u",
		--[[The V key.  ]]
		v = "v",
		--[[The W key.  ]]
		w = "w",
		--[[The X key.  ]]
		x = "x",
		--[[The Y key.  ]]
		y = "y",
		--[[The Z key.  ]]
		z = "z",
		--[[The 0 key.  ]]
		["0"] = "0",
		--[[The 1 key.  ]]
		["1"] = "1",
		--[[The 2 key.  ]]
		["2"] = "2",
		--[[The 3 key.  ]]
		["3"] = "3",
		--[[The 4 key.  ]]
		["4"] = "4",
		--[[The 5 key.  ]]
		["5"] = "5",
		--[[The 6 key.  ]]
		["6"] = "6",
		--[[The 7 key.  ]]
		["7"] = "7",
		--[[The 8 key.  ]]
		["8"] = "8",
		--[[The 9 key.  ]]
		["9"] = "9",
		--[[The space bar.  ]]
		space = "space",
		--[[The enter key.  ]]
		["return"] = "return",
		--[[The tab key.  ]]
		tab = "tab",
		--[[The escape key.  ]]
		escape = "escape",
		--[[The backspace key.  ]]
		backspace = "backspace",
		--[[The up arrow key.  ]]
		up = "up",
		--[[The down arrow key.  ]]
		down = "down",
		--[[The left arrow key.  ]]
		left = "left",
		--[[The right arrow key.  ]]
		right = "right",
		--[[The home key.  ]]
		home = "home",
		--[[The end key.  ]]
		["end"] = "end",
		--[[The page up key.  ]]
		pageup = "pageup",
		--[[The page down key.  ]]
		pagedown = "pagedown",
		--[[The insert key.  ]]
		insert = "insert",
		--[[The delete key.  ]]
		delete = "delete",
		--[[The F1 key.  ]]
		f1 = "f1",
		--[[The F2 key.  ]]
		f2 = "f2",
		--[[The F3 key.  ]]
		f3 = "f3",
		--[[The F4 key.  ]]
		f4 = "f4",
		--[[The F5 key.  ]]
		f5 = "f5",
		--[[The F6 key.  ]]
		f6 = "f6",
		--[[The F7 key.  ]]
		f7 = "f7",
		--[[The F8 key.  ]]
		f8 = "f8",
		--[[The F9 key.  ]]
		f9 = "f9",
		--[[The F10 key.  ]]
		f10 = "f10",
		--[[The F11 key.  ]]
		f11 = "f11",
		--[[The F12 key.  ]]
		f12 = "f12",
		--[[The backtick/backquote/grave accent key.  ]]
		["`"] = "`",
		--[[The dash/hyphen/minus key.  ]]
		["-"] = "-",
		--[[The equal sign key.  ]]
		["="] = "=",
		--[[The left bracket key.  ]]
		["["] = "[",
		--[[The right bracket key.  ]]
		["]"] = "]",
		--[[The backslash key.  ]]
		["\\"] = "\\",
		--[[The semicolon key.  ]]
		[";"] = ";",
		--[[The single quote key.  ]]
		["'"] = "'",
		--[[The comma key.  ]]
		[","] = ",",
		--[[The period key.  ]]
		["."] = ".",
		--[[The slash key.  ]]
		["/"] = "/",
		--[[The 0 numpad key.  ]]
		kp0 = "kp0",
		--[[The 1 numpad key.  ]]
		kp1 = "kp1",
		--[[The 2 numpad key.  ]]
		kp2 = "kp2",
		--[[The 3 numpad key.  ]]
		kp3 = "kp3",
		--[[The 4 numpad key.  ]]
		kp4 = "kp4",
		--[[The 5 numpad key.  ]]
		kp5 = "kp5",
		--[[The 6 numpad key.  ]]
		kp6 = "kp6",
		--[[The 7 numpad key.  ]]
		kp7 = "kp7",
		--[[The 8 numpad key.  ]]
		kp8 = "kp8",
		--[[The 9 numpad key.  ]]
		kp9 = "kp9",
		--[[The . numpad key.  ]]
		["kp."] = "kp.",
		--[[The / numpad key.  ]]
		["kp/"] = "kp/",
		--[[The * numpad key.  ]]
		["kp*"] = "kp*",
		--[[The - numpad key.  ]]
		["kp-"] = "kp-",
		--[[The + numpad key.  ]]
		["kp+"] = "kp+",
		--[[The enter numpad key.  ]]
		kpenter = "kpenter",
		--[[The equals numpad key.  ]]
		["kp="] = "kp=",
		--[[The left control key.  ]]
		lctrl = "lctrl",
		--[[The left shift key.  ]]
		lshift = "lshift",
		--[[The left alt key.  ]]
		lalt = "lalt",
		--[[The left OS key (windows, command, super).  ]]
		lgui = "lgui",
		--[[The right control key.  ]]
		rctrl = "rctrl",
		--[[The right shift key.  ]]
		rshift = "rshift",
		--[[The right alt key.  ]]
		ralt = "ralt",
		--[[The right OS key (windows, command, super).  ]]
		rgui = "rgui",
		--[[The caps lock key.  ]]
		capslock = "capslock",
		--[[The scroll lock key.  ]]
		scrolllock = "scrolllock",
		--[[The numlock key.  ]]
		numlock = "numlock",
	}

	--[[https://lovr.org/docs/lovr.event.poll  ]]
	--[[Iterate over unprocessed events in the queue.  ]]
	--[[### See also]]
	--[[* [`lovr.event`](lua://lovr.event)]]
	--[[@return function iterator]]
	function lovr.event.poll() return function() end end

	--[[https://lovr.org/docs/lovr.event.push  ]]
	--[[Manually push an event onto the queue.  ]]
	--[[### See also]]
	--[[* [`lovr.event.poll`](lua://lovr.event.poll)]]
	--[[* [`lovr.event.quit`](lua://lovr.event.quit)]]
	--[[* [`lovr.event`](lua://lovr.event)]]
	--[[@param name string]]
	--[[@param ... unknown]]
	function lovr.event.push(name, ...) end

	--[[https://lovr.org/docs/lovr.event.quit  ]]
	--[[Quit the application.  ]]
	--[[### See also]]
	--[[* [`lovr.quit`](lua://lovr.quit)]]
	--[[* [`lovr.event.poll`](lua://lovr.event.poll)]]
	--[[* [`lovr.event.restart`](lua://lovr.event.restart)]]
	--[[* [`lovr.event`](lua://lovr.event)]]
	--[[@param code? number default=`0`]]
	function lovr.event.quit(code) end

	--[[https://lovr.org/docs/lovr.event.restart  ]]
	--[[Restart the application.  ]]
	--[[### See also]]
	--[[* [`lovr.restart`](lua://lovr.restart)]]
	--[[* [`lovr.event.poll`](lua://lovr.event.poll)]]
	--[[* [`lovr.event.quit`](lua://lovr.event.quit)]]
	--[[* [`lovr.event`](lua://lovr.event)]]
	function lovr.event.restart() end


	--[[https://lovr.org/docs/lovr.filesystem  ]]
	--[[@class lovr_filesystem]]
	lovr.filesystem = {}

	--[[https://lovr.org/docs/lovr.filesystem.append  ]]
	--[[Append content to the end of a file.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param filename string]]
	--[[@param content string]]
	--[[@return number bytes]]
	--[[@overload fun(filename: string, blob: lovr_blob): number]]
	function lovr.filesystem.append(filename, content) return 0 end

	--[[https://lovr.org/docs/lovr.filesystem.createDirectory  ]]
	--[[Create a directory.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path string]]
	--[[@return boolean success]]
	function lovr.filesystem.createDirectory(path) return false end

	--[[https://lovr.org/docs/lovr.filesystem.getAppdataDirectory  ]]
	--[[Get the application data directory.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@return string path]]
	function lovr.filesystem.getAppdataDirectory() return "" end

	--[[https://lovr.org/docs/lovr.filesystem.getDirectoryItems  ]]
	--[[Get a list of files in a directory.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path string]]
	--[[@return table<string,string|number> items]]
	function lovr.filesystem.getDirectoryItems(path) return {} end

	--[[https://lovr.org/docs/lovr.filesystem.getExecutablePath  ]]
	--[[Get the path of the LÖVR executable.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@return string path]]
	function lovr.filesystem.getExecutablePath() return "" end

	--[[https://lovr.org/docs/lovr.filesystem.getIdentity  ]]
	--[[Get the name of the save directory.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@return string identity]]
	function lovr.filesystem.getIdentity() return "" end

	--[[https://lovr.org/docs/lovr.filesystem.getLastModified  ]]
	--[[Get the modification time of a file.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path string]]
	--[[@return number time]]
	function lovr.filesystem.getLastModified(path) return 0 end

	--[[https://lovr.org/docs/lovr.filesystem.getRealDirectory  ]]
	--[[Get the absolute path to a file.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path string]]
	--[[@return string realpath]]
	function lovr.filesystem.getRealDirectory(path) return "" end

	--[[https://lovr.org/docs/lovr.filesystem.getRequirePath  ]]
	--[[Get the require path.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@return string path]]
	function lovr.filesystem.getRequirePath() return "" end

	--[[https://lovr.org/docs/lovr.filesystem.getSaveDirectory  ]]
	--[[Get the location of the save directory.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem.getIdentity`](lua://lovr.filesystem.getIdentity)]]
	--[[* [`lovr.filesystem.getAppdataDirectory`](lua://lovr.filesystem.getAppdataDirectory)]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@return string path]]
	function lovr.filesystem.getSaveDirectory() return "" end

	--[[https://lovr.org/docs/lovr.filesystem.getSize  ]]
	--[[Get the size of a file.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param file string]]
	--[[@return number size]]
	function lovr.filesystem.getSize(file) return 0 end

	--[[https://lovr.org/docs/lovr.filesystem.getSource  ]]
	--[[Get the location of the project source.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@return string path]]
	function lovr.filesystem.getSource() return "" end

	--[[https://lovr.org/docs/lovr.filesystem.getUserDirectory  ]]
	--[[Get the location of the user's home directory.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@return string path]]
	function lovr.filesystem.getUserDirectory() return "" end

	--[[https://lovr.org/docs/lovr.filesystem.getWorkingDirectory  ]]
	--[[Get the current working directory.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@return string path]]
	function lovr.filesystem.getWorkingDirectory() return "" end

	--[[https://lovr.org/docs/lovr.filesystem.isDirectory  ]]
	--[[Check whether a path is a directory.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem.isFile`](lua://lovr.filesystem.isFile)]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path string]]
	--[[@return boolean isDirectory]]
	function lovr.filesystem.isDirectory(path) return false end

	--[[https://lovr.org/docs/lovr.filesystem.isFile  ]]
	--[[Check whether a path is a file.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem.isDirectory`](lua://lovr.filesystem.isDirectory)]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path string]]
	--[[@return boolean isFile]]
	function lovr.filesystem.isFile(path) return false end

	--[[https://lovr.org/docs/lovr.filesystem.isFused  ]]
	--[[Check if the project is fused.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@return boolean fused]]
	function lovr.filesystem.isFused() return false end

	--[[https://lovr.org/docs/lovr.filesystem.load  ]]
	--[[Load a file as Lua code.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param filename string]]
	--[[@param mode? string default=`'bt'`]]
	--[[@return function chunk]]
	function lovr.filesystem.load(filename, mode) return function() end end

	--[[https://lovr.org/docs/lovr.filesystem.mount  ]]
	--[[Mount a directory or archive.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem.unmount`](lua://lovr.filesystem.unmount)]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path string]]
	--[[@param mountpoint? string default=`'/'`]]
	--[[@param append? boolean default=`false`]]
	--[[@param root? string default=`nil`]]
	--[[@return boolean success]]
	function lovr.filesystem.mount(path, mountpoint, append, root) return false end

	--[[https://lovr.org/docs/lovr.filesystem.newBlob  ]]
	--[[Create a new Blob from a file.  ]]
	--[[### See also]]
	--[[* [`lovr.data.newBlob`](lua://lovr.data.newBlob)]]
	--[[* [`Blob`](lua://lovr_blob)]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param filename string]]
	--[[@return lovr_blob blob]]
	function lovr.filesystem.newBlob(filename) return Blob_class end

	--[[https://lovr.org/docs/lovr.filesystem.read  ]]
	--[[Read a file.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param filename string]]
	--[[@param bytes? number default=`-1`]]
	--[[@return string contents]]
	--[[@return number bytes]]
	function lovr.filesystem.read(filename, bytes) return "", 0 end

	--[[https://lovr.org/docs/lovr.filesystem.remove  ]]
	--[[Remove a file or directory.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path string]]
	--[[@return boolean success]]
	function lovr.filesystem.remove(path) return false end

	--[[https://lovr.org/docs/lovr.filesystem.setIdentity  ]]
	--[[Set the name of the save directory.  ]]
	--[[### See also]]
	--[[* [`lovr.conf`](lua://lovr.conf)]]
	--[[* [`lovr.filesystem.getSaveDirectory`](lua://lovr.filesystem.getSaveDirectory)]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param identity string]]
	function lovr.filesystem.setIdentity(identity) end

	--[[https://lovr.org/docs/lovr.filesystem.setRequirePath  ]]
	--[[Set the require path.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path? string default=`nil`]]
	function lovr.filesystem.setRequirePath(path) end

	--[[https://lovr.org/docs/lovr.filesystem.unmount  ]]
	--[[Unmount a mounted archive.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem.mount`](lua://lovr.filesystem.mount)]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param path string]]
	--[[@return boolean success]]
	function lovr.filesystem.unmount(path) return false end

	--[[https://lovr.org/docs/lovr.filesystem.write  ]]
	--[[Write to a file.  ]]
	--[[### See also]]
	--[[* [`lovr.filesystem.append`](lua://lovr.filesystem.append)]]
	--[[* [`lovr.filesystem.getSaveDirectory`](lua://lovr.filesystem.getSaveDirectory)]]
	--[[* [`lovr.filesystem.read`](lua://lovr.filesystem.read)]]
	--[[* [`lovr.filesystem`](lua://lovr.filesystem)]]
	--[[@param filename string]]
	--[[@param content string]]
	--[[@return boolean success]]
	--[[@overload fun(filename: string, blob: lovr_blob): boolean]]
	function lovr.filesystem.write(filename, content) return false end


	--[[https://lovr.org/docs/lovr.graphics  ]]
	--[[@class lovr_graphics]]
	lovr.graphics = {}

	--[[https://lovr.org/docs/BlendAlphaMode  ]]
	--[[Whether premultiplied alpha is enabled.  ]]
	--[[### See also]]
	--[[* [`BlendMode`](lua://lovr_blendMode)]]
	--[[* [`Pass:setBlendMode`](lua://lovr_pass.setBlendMode)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_blend_alpha_mode]]
	local lovr_blend_alpha_mode = {
		--[[Color channel values are multiplied by the alpha channel during blending.  ]]
		alphamultiply = "alphamultiply",
		--[[Color channel values are not multiplied by the alpha.  Instead, it's assumed that the colors have already been multiplied by the alpha.  This should be used if the pixels being drawn have already been blended, or "pre-multiplied".  ]]
		premultiplied = "premultiplied",
	}

	--[[https://lovr.org/docs/BlendMode  ]]
	--[[Blend modes.  ]]
	--[[### See also]]
	--[[* [`BlendAlphaMode`](lua://lovr_blendAlphaMode)]]
	--[[* [`Pass:setBlendMode`](lua://lovr_pass.setBlendMode)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_blend_mode]]
	local lovr_blend_mode = {
		--[[Colors will be mixed based on alpha.  ]]
		alpha = "alpha",
		--[[Colors will be added to the existing color, alpha will not be changed.  ]]
		add = "add",
		--[[Colors will be subtracted from the existing color, alpha will not be changed.  ]]
		subtract = "subtract",
		--[[All color channels will be multiplied together, producing a darkening effect.  ]]
		multiply = "multiply",
		--[[The maximum value of each color channel will be used.  ]]
		lighten = "lighten",
		--[[The minimum value of each color channel will be used.  ]]
		darken = "darken",
		--[[The opposite of multiply: the pixel colors are inverted, multiplied, and inverted again, producing a lightening effect.  ]]
		screen = "screen",
	}

	--[[https://lovr.org/docs/Buffer  ]]
	--[[A block of memory on the GPU.  ]]
	--[[@class lovr_buffer: lovr_object]]

	--[[https://lovr.org/docs/Buffer:clear  ]]
	--[[Clear data in the Buffer.  ]]
	--[[### See also]]
	--[[* [`Texture:clear`](lua://lovr_texture.clear)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@param offset? number default=`0`]]
	--[[@param extent? number default=`nil`]]
	--[[@param value? number default=`0x00000000`]]
	function Buffer_class:clear(offset, extent, value) end

	--[[https://lovr.org/docs/Buffer:getData  ]]
	--[[Get the data in the Buffer.  ]]
	--[[### See also]]
	--[[* [`Buffer:newReadback`](lua://lovr_buffer.newReadback)]]
	--[[* [`Buffer:mapData`](lua://lovr_buffer.mapData)]]
	--[[* [`Readback:getData`](lua://lovr_readback.getData)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@param index? number default=`1`]]
	--[[@param count? number default=`nil`]]
	--[[@return table<string,string|number> t]]
	function Buffer_class:getData(index, count) return {} end

	--[[https://lovr.org/docs/Buffer:getFormat  ]]
	--[[Get the format of the Buffer.  ]]
	--[[### See also]]
	--[[* [`Buffer:getSize`](lua://lovr_buffer.getSize)]]
	--[[* [`Buffer:getLength`](lua://lovr_buffer.getLength)]]
	--[[* [`Buffer:getStride`](lua://lovr_buffer.getStride)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@return lovr_graphics_buffer_get_format_format[] format]]
	function Buffer_class:getFormat() return {} end

	--[[https://lovr.org/docs/Buffer:getLength  ]]
	--[[Get the length of the Buffer.  ]]
	--[[### See also]]
	--[[* [`Buffer:getSize`](lua://lovr_buffer.getSize)]]
	--[[* [`Buffer:getStride`](lua://lovr_buffer.getStride)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@return number length]]
	function Buffer_class:getLength() return 0 end

	--[[https://lovr.org/docs/Buffer:getPointer  ]]
	--[[Get a writable pointer to the Buffer's memory.  ]]
	--[[### See also]]
	--[[* [`Blob:getPointer`](lua://lovr_blob.getPointer)]]
	--[[* [`Buffer:mapData`](lua://lovr_buffer.mapData)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@param offset? number default=`0`]]
	--[[@param extent? number default=`nil`]]
	--[[@return lightuserdata pointer]]
	--[[@deprecated]]
	function Buffer_class:getPointer(offset, extent) return lightuserdata end

	--[[https://lovr.org/docs/Buffer:getSize  ]]
	--[[Get the size of the Buffer, in bytes.  ]]
	--[[### See also]]
	--[[* [`Buffer:getLength`](lua://lovr_buffer.getLength)]]
	--[[* [`Buffer:getStride`](lua://lovr_buffer.getStride)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@return number size]]
	function Buffer_class:getSize() return 0 end

	--[[https://lovr.org/docs/Buffer:getStride  ]]
	--[[Get the stride of the Buffer, in bytes.  ]]
	--[[### See also]]
	--[[* [`Buffer:getSize`](lua://lovr_buffer.getSize)]]
	--[[* [`Buffer:getLength`](lua://lovr_buffer.getLength)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@return number stride]]
	function Buffer_class:getStride() return 0 end

	--[[https://lovr.org/docs/Buffer:isTemporary  ]]
	--[[Check if the Buffer is temporary.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.getBuffer`](lua://lovr.graphics.getBuffer)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@return boolean temporary]]
	--[[@deprecated]]
	function Buffer_class:isTemporary() return false end

	--[[https://lovr.org/docs/Buffer:mapData  ]]
	--[[Get a writable pointer to the Buffer's memory.  ]]
	--[[### See also]]
	--[[* [`Blob:getPointer`](lua://lovr_blob.getPointer)]]
	--[[* [`Buffer:getPointer`](lua://lovr_buffer.getPointer)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@param offset? number default=`0`]]
	--[[@param extent? number default=`nil`]]
	--[[@return lightuserdata pointer]]
	function Buffer_class:mapData(offset, extent) return lightuserdata end

	--[[https://lovr.org/docs/Buffer:newReadback  ]]
	--[[Read back the contents of the Buffer asynchronously.  ]]
	--[[### See also]]
	--[[* [`Buffer:getData`](lua://lovr_buffer.getData)]]
	--[[* [`Texture:newReadback`](lua://lovr_texture.newReadback)]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@param offset? number default=`0`]]
	--[[@param extent? number default=`nil`]]
	--[[@return lovr_readback readback]]
	function Buffer_class:newReadback(offset, extent) return Readback_class end

	--[[https://lovr.org/docs/Buffer:setData  ]]
	--[[Change the data in the Buffer.  ]]
	--[[### See also]]
	--[[* [`Buffer`](lua://lovr_buffer)]]
	--[[@param table table<string,string|number>]]
	--[[@param destinationIndex? number default=`1`]]
	--[[@param sourceIndex? number default=`1`]]
	--[[@param count? number default=`nil`]]
	--[[@overload fun(self: lovr_buffer, ...: number)]]
	--[[@overload fun(self: lovr_buffer, vector: unknown)]]
	--[[@overload fun(self: lovr_buffer, blob: lovr_blob, destinationOffset?: number, sourceOffset?: number, size?: number)]]
	--[[@overload fun(self: lovr_buffer, buffer: lovr_buffer, destinationOffset?: number, sourceOffset?: number, size?: number)]]
	function Buffer_class:setData(table, destinationIndex, sourceIndex, count) end

	--[[https://lovr.org/docs/CompareMode  ]]
	--[[Different ways of performing comparisons.  ]]
	--[[### See also]]
	--[[* [`Pass:setDepthTest`](lua://lovr_pass.setDepthTest)]]
	--[[* [`Pass:setStencilTest`](lua://lovr_pass.setStencilTest)]]
	--[[* [`Pass:setDepthWrite`](lua://lovr_pass.setDepthWrite)]]
	--[[* [`Pass:setStencilWrite`](lua://lovr_pass.setStencilWrite)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_compare_mode]]
	local lovr_compare_mode = {
		--[[The test does not take place, and acts as though it always passes.  ]]
		none = "none",
		--[[The test passes if the values are equal.  ]]
		equal = "equal",
		--[[The test passes if the values are not equal.  ]]
		notequal = "notequal",
		--[[The test passes if the value is less than the existing one.  ]]
		less = "less",
		--[[The test passes if the value is less than or equal to the existing one.  ]]
		lequal = "lequal",
		--[[The test passes if the value is greater than the existing one.  ]]
		greater = "greater",
		--[[The test passes if the value is greater than or equal to the existing one.  ]]
		gequal = "gequal",
	}

	--[[https://lovr.org/docs/Buffer:getFormat  ]]
	--[[see also:  ]]
	--[[[`Buffer:getFormat`](lua://Buffer:getFormat)  ]]
	--[[@class lovr_graphics_buffer_get_format_format]]
	--[[@field name string ]]
	--[[@field type unknown ]]
	--[[@field offset number ]]
	--[[@field length number ]]
	--[[@field stride number ]]

	--[[https://lovr.org/docs/lovr.graphics.compileShader  ]]
	--[[Compile shader code to bytecode.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newShader`](lua://lovr.graphics.newShader)]]
	--[[* [`Shader`](lua://lovr_shader)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param stage lovr_shader_stage]]
	--[[@param source string]]
	--[[@return lovr_blob bytecode]]
	--[[@overload fun(stage: lovr_shader_stage, blob: lovr_blob): lovr_blob]]
	function lovr.graphics.compileShader(stage, source) return Blob_class end

	--[[https://lovr.org/docs/CullMode  ]]
	--[[Different ways of doing face culling.  ]]
	--[[### See also]]
	--[[* [`Winding`](lua://lovr_winding)]]
	--[[* [`Pass:setCullMode`](lua://lovr_pass.setCullMode)]]
	--[[* [`Pass:setWinding`](lua://lovr_pass.setWinding)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_cull_mode]]
	local lovr_cull_mode = {
		--[[Both sides of triangles will be drawn.  ]]
		none = "none",
		--[[Skips rendering the back side of triangles.  ]]
		back = "back",
		--[[Skips rendering the front side of triangles.  ]]
		front = "front",
	}

	--[[https://lovr.org/docs/DataLayout  ]]
	--[[Different ways of padding GPU buffer data.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newBuffer`](lua://lovr.graphics.newBuffer)]]
	--[[* [`Buffer:getFormat`](lua://lovr_buffer.getFormat)]]
	--[[* [`Buffer:getStride`](lua://lovr_buffer.getStride)]]
	--[[* [`DataType`](lua://lovr_dataType)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_data_layout]]
	local lovr_data_layout = {
		--[[The packed layout, without any padding.  ]]
		packed = "packed",
		--[[The std140 layout.  ]]
		std140 = "std140",
		--[[The std430 layout.  ]]
		std430 = "std430",
	}

	--[[https://lovr.org/docs/DataType  ]]
	--[[Different types for `Buffer` fields.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newBuffer`](lua://lovr.graphics.newBuffer)]]
	--[[* [`Buffer:getFormat`](lua://lovr_buffer.getFormat)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_data_type]]
	local lovr_data_type = {
		--[[Four 8-bit signed integers.  ]]
		i8x4 = "i8x4",
		--[[Four 8-bit unsigned integers.  ]]
		u8x4 = "u8x4",
		--[[Four 8-bit signed normalized values.  ]]
		sn8x4 = "sn8x4",
		--[[Four 8-bit unsigned normalized values (aka `color`).  ]]
		un8x4 = "un8x4",
		--[[Three 10-bit unsigned normalized values, and 2 padding bits (aka `normal`).  ]]
		un10x3 = "un10x3",
		--[[One 16-bit signed integer.  ]]
		i16 = "i16",
		--[[Two 16-bit signed integers.  ]]
		i16x2 = "i16x2",
		--[[Four 16-bit signed integers.  ]]
		i16x4 = "i16x4",
		--[[One 16-bit unsigned integer.  ]]
		u16 = "u16",
		--[[Two 16-bit unsigned integers.  ]]
		u16x2 = "u16x2",
		--[[Four 16-bit unsigned integers.  ]]
		u16x4 = "u16x4",
		--[[Two 16-bit signed normalized values.  ]]
		sn16x2 = "sn16x2",
		--[[Four 16-bit signed normalized values.  ]]
		sn16x4 = "sn16x4",
		--[[Two 16-bit unsigned normalized values.  ]]
		un16x2 = "un16x2",
		--[[Four 16-bit unsigned normalized values.  ]]
		un16x4 = "un16x4",
		--[[One 32-bit signed integer (aka `int`).  ]]
		i32 = "i32",
		--[[Two 32-bit signed integers.  ]]
		i32x2 = "i32x2",
		--[[Three 32-bit signed integers.  ]]
		i32x3 = "i32x3",
		--[[Four 32-bit signed integers.  ]]
		i32x4 = "i32x4",
		--[[One 32-bit unsigned integer (aka `uint`).  ]]
		u32 = "u32",
		--[[Two 32-bit unsigned integers.  ]]
		u32x2 = "u32x2",
		--[[Three 32-bit unsigned integers.  ]]
		u32x3 = "u32x3",
		--[[Four 32-bit unsigned integers.  ]]
		u32x4 = "u32x4",
		--[[Two 16-bit floating point numbers.  ]]
		f16x2 = "f16x2",
		--[[Four 16-bit floating point numbers.  ]]
		f16x4 = "f16x4",
		--[[One 32-bit floating point number (aka `float`).  ]]
		f32 = "f32",
		--[[Two 32-bit floating point numbers (aka `vec2`).  ]]
		f32x2 = "f32x2",
		--[[Three 32-bit floating point numbers (aka `vec3`).  ]]
		f32x3 = "f32x3",
		--[[Four 32-bit floating point numbers (aka `vec4`).  ]]
		f32x4 = "f32x4",
		--[[A 2x2 matrix containing four 32-bit floats.  ]]
		mat2 = "mat2",
		--[[A 3x3 matrix containing nine 32-bit floats.  ]]
		mat3 = "mat3",
		--[[A 4x4 matrix containing sixteen 32-bit floats.  ]]
		mat4 = "mat4",
		--[[Like u16, but 1-indexed.  ]]
		index16 = "index16",
		--[[Like u32, but 1-indexed.  ]]
		index32 = "index32",
	}

	--[[https://lovr.org/docs/DefaultShader  ]]
	--[[Built-in shaders.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_default_shader]]
	local lovr_default_shader = {
		--[[Basic shader without lighting that uses colors and a texture.  ]]
		unlit = "unlit",
		--[[Shades triangles based on their normal, resulting in a cool rainbow effect.  ]]
		normal = "normal",
		--[[Renders font glyphs.  ]]
		font = "font",
		--[[Renders cubemaps.  ]]
		cubemap = "cubemap",
		--[[Renders spherical textures.  ]]
		equirect = "equirect",
		--[[Renders a fullscreen triangle.  ]]
		fill = "fill",
	}

	--[[https://lovr.org/docs/DrawMode  ]]
	--[[Different ways to draw mesh vertices.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_draw_mode]]
	local lovr_draw_mode = {
		--[[Each vertex is rendered as a single point.  The size of the point can be controlled using the `pointSize` shader flag, or by writing to the `PointSize` variable in shaders.  The maximum point size is given by the `pointSize` limit from `lovr.graphics.getLimits`.  ]]
		points = "points",
		--[[Pairs of vertices are connected with line segments.  To draw a single line through all of the vertices, an index buffer can be used to repeat vertices.  It is not currently possible to change the width of the lines, although cylinders or capsules can be used as an alternative.  ]]
		lines = "lines",
		--[[Every 3 vertices form a triangle, which is filled in with pixels (unless `Pass:setWireframe` is used).  This mode is the most commonly used.  ]]
		triangles = "triangles",
	}

	--[[https://lovr.org/docs/DrawStyle  ]]
	--[[Different styles to draw shapes.  ]]
	--[[### See also]]
	--[[* [`Pass:plane`](lua://lovr_pass.plane)]]
	--[[* [`Pass:cube`](lua://lovr_pass.cube)]]
	--[[* [`Pass:box`](lua://lovr_pass.box)]]
	--[[* [`Pass:circle`](lua://lovr_pass.circle)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_draw_style]]
	local lovr_draw_style = {
		--[[The shape will be filled in (the default).  ]]
		fill = "fill",
		--[[The shape will be outlined.  ]]
		line = "line",
	}

	--[[https://lovr.org/docs/FilterMode  ]]
	--[[Different ways to smooth textures.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newSampler`](lua://lovr.graphics.newSampler)]]
	--[[* [`Sampler:getFilter`](lua://lovr_sampler.getFilter)]]
	--[[* [`Texture:setPixels`](lua://lovr_texture.setPixels)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_filter_mode]]
	local lovr_filter_mode = {
		--[[A pixelated appearance where the "nearest neighbor" pixel is used.  ]]
		nearest = "nearest",
		--[[A smooth appearance where neighboring pixels are averaged.  ]]
		linear = "linear",
	}

	--[[https://lovr.org/docs/Font  ]]
	--[[A Font used to render text.  ]]
	--[[@class lovr_font: lovr_object]]

	--[[https://lovr.org/docs/Font:getAscent  ]]
	--[[Get the ascent of the Font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getAscent`](lua://lovr_rasterizer.getAscent)]]
	--[[* [`Font:getDescent`](lua://lovr_font.getDescent)]]
	--[[* [`Font:getHeight`](lua://lovr_font.getHeight)]]
	--[[* [`Font:getKerning`](lua://lovr_font.getKerning)]]
	--[[* [`Font:getWidth`](lua://lovr_font.getWidth)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@return number ascent]]
	function Font_class:getAscent() return 0 end

	--[[https://lovr.org/docs/Font:getDescent  ]]
	--[[Get the descent of the Font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getDescent`](lua://lovr_rasterizer.getDescent)]]
	--[[* [`Font:getAscent`](lua://lovr_font.getAscent)]]
	--[[* [`Font:getHeight`](lua://lovr_font.getHeight)]]
	--[[* [`Font:getKerning`](lua://lovr_font.getKerning)]]
	--[[* [`Font:getWidth`](lua://lovr_font.getWidth)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@return number descent]]
	function Font_class:getDescent() return 0 end

	--[[https://lovr.org/docs/Font:getHeight  ]]
	--[[Get the height of the Font.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getLeading`](lua://lovr_rasterizer.getLeading)]]
	--[[* [`Font:getLineSpacing`](lua://lovr_font.getLineSpacing)]]
	--[[* [`Font:setLineSpacing`](lua://lovr_font.setLineSpacing)]]
	--[[* [`Font:getAscent`](lua://lovr_font.getAscent)]]
	--[[* [`Font:getDescent`](lua://lovr_font.getDescent)]]
	--[[* [`Font:getKerning`](lua://lovr_font.getKerning)]]
	--[[* [`Font:getWidth`](lua://lovr_font.getWidth)]]
	--[[* [`Font:getLines`](lua://lovr_font.getLines)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@return number height]]
	function Font_class:getHeight() return 0 end

	--[[https://lovr.org/docs/Font:getKerning  ]]
	--[[Get the kerning between 2 glyphs.  ]]
	--[[### See also]]
	--[[* [`Rasterizer:getKerning`](lua://lovr_rasterizer.getKerning)]]
	--[[* [`Font:getAscent`](lua://lovr_font.getAscent)]]
	--[[* [`Font:getDescent`](lua://lovr_font.getDescent)]]
	--[[* [`Font:getHeight`](lua://lovr_font.getHeight)]]
	--[[* [`Font:getWidth`](lua://lovr_font.getWidth)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@param first string]]
	--[[@param second string]]
	--[[@return number keming]]
	--[[@overload fun(self: lovr_font, firstCodepoint: number, second: string): number]]
	--[[@overload fun(self: lovr_font, first: string, secondCodepoint: number): number]]
	--[[@overload fun(self: lovr_font, firstCodepoint: number, secondCodepoint: number): number]]
	function Font_class:getKerning(first, second) return 0 end

	--[[https://lovr.org/docs/Font:getLines  ]]
	--[[Wrap a string into a sequence of lines.  ]]
	--[[### See also]]
	--[[* [`Font:getWidth`](lua://lovr_font.getWidth)]]
	--[[* [`Font:getHeight`](lua://lovr_font.getHeight)]]
	--[[* [`Pass:text`](lua://lovr_pass.text)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@param string string]]
	--[[@param wrap number]]
	--[[@return table<string,string|number> lines]]
	--[[@overload fun(self: lovr_font, strings: table<string,string|number>, wrap: number): table<string,string|number>]]
	function Font_class:getLines(string, wrap) return {} end

	--[[https://lovr.org/docs/Font:getLineSpacing  ]]
	--[[Get the line spacing of the Font.  ]]
	--[[### See also]]
	--[[* [`Font:getHeight`](lua://lovr_font.getHeight)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@return number spacing]]
	function Font_class:getLineSpacing() return 0 end

	--[[https://lovr.org/docs/Font:getPixelDensity  ]]
	--[[Get the pixel density of the Font.  ]]
	--[[### See also]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@return number density]]
	function Font_class:getPixelDensity() return 0 end

	--[[https://lovr.org/docs/Font:getRasterizer  ]]
	--[[Get the Font's Rasterizer.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newFont`](lua://lovr.graphics.newFont)]]
	--[[* [`lovr.data.newRasterizer`](lua://lovr.data.newRasterizer)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@return lovr_rasterizer rasterizer]]
	function Font_class:getRasterizer() return Rasterizer_class end

	--[[https://lovr.org/docs/Font:getVertices  ]]
	--[[Get the vertices for a piece of text.  ]]
	--[[### See also]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@param string string]]
	--[[@param wrap? number default=`0`]]
	--[[@param halign lovr_horizontal_align]]
	--[[@param valign lovr_vertical_align]]
	--[[@return table<string,string|number> vertices]]
	--[[@return lovr_material material]]
	--[[@overload fun(self: lovr_font, strings: table<string,string|number>, wrap?: number, halign: lovr_horizontal_align, valign: lovr_vertical_align): table<string,string|number>, lovr_material]]
	function Font_class:getVertices(string, wrap, halign, valign) return {}, Material_class end

	--[[https://lovr.org/docs/Font:getWidth  ]]
	--[[Get the width of rendered text.  ]]
	--[[### See also]]
	--[[* [`Font:getAscent`](lua://lovr_font.getAscent)]]
	--[[* [`Font:getDescent`](lua://lovr_font.getDescent)]]
	--[[* [`Font:getHeight`](lua://lovr_font.getHeight)]]
	--[[* [`Font:getKerning`](lua://lovr_font.getKerning)]]
	--[[* [`Font:getLines`](lua://lovr_font.getLines)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@param string string]]
	--[[@return number width]]
	--[[@overload fun(self: lovr_font, strings: table<string,string|number>): number]]
	function Font_class:getWidth(string) return 0 end

	--[[https://lovr.org/docs/Font:setLineSpacing  ]]
	--[[Set the line spacing of the Font.  ]]
	--[[### See also]]
	--[[* [`Font:getHeight`](lua://lovr_font.getHeight)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@param spacing number]]
	function Font_class:setLineSpacing(spacing) end

	--[[https://lovr.org/docs/Font:setPixelDensity  ]]
	--[[Set the pixel density of the Font.  ]]
	--[[### See also]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[@param density number]]
	--[[@overload fun(self: lovr_font)]]
	function Font_class:setPixelDensity(density) end

	--[[https://lovr.org/docs/lovr.graphics.getBackgroundColor  ]]
	--[[Get the background color.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newPass`](lua://lovr.graphics.newPass)]]
	--[[* [`Pass:setClear`](lua://lovr_pass.setClear)]]
	--[[* [`Texture:clear`](lua://lovr_texture.clear)]]
	--[[* [`Pass:fill`](lua://lovr_pass.fill)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@return number r]]
	--[[@return number g]]
	--[[@return number b]]
	--[[@return number a]]
	function lovr.graphics.getBackgroundColor() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.graphics.getBuffer  ]]
	--[[Get a temporary Buffer.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param size number]]
	--[[@return lovr_buffer buffer]]
	--[[@deprecated]]
	--[[@overload fun(blob: lovr_blob): lovr_buffer]]
	--[[@overload fun(format: lovr_graphics_get_buffer_format, length?: number): lovr_buffer]]
	--[[@overload fun(format: lovr_graphics_get_buffer_format, data: table<string,string|number>): lovr_buffer]]
	--[[@overload fun(format: lovr_graphics_get_buffer_format, blob: lovr_blob): lovr_buffer]]
	--[[@overload fun(type: lovr_data_type, length?: number): lovr_buffer]]
	--[[@overload fun(type: lovr_data_type, data: table<string,string|number>): lovr_buffer]]
	--[[@overload fun(type: lovr_data_type, blob: lovr_blob): lovr_buffer]]
	function lovr.graphics.getBuffer(size) return Buffer_class end

	--[[https://lovr.org/docs/lovr.graphics.getBuffer  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.getBuffer`](lua://lovr.graphics.getBuffer)  ]]
	--[[@class lovr_graphics_get_buffer_format]]
	--[[@field layout? lovr_data_layout default=`packed`]]
	--[[@field stride number ]]

	--[[https://lovr.org/docs/lovr.graphics.getDefaultFont  ]]
	--[[Get the default Font.  ]]
	--[[### See also]]
	--[[* [`Pass:text`](lua://lovr_pass.text)]]
	--[[* [`lovr.graphics.newFont`](lua://lovr.graphics.newFont)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@return lovr_font font]]
	function lovr.graphics.getDefaultFont() return Font_class end

	--[[https://lovr.org/docs/lovr.graphics.getDevice  ]]
	--[[Get information about the graphics device and driver.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.getFeatures`](lua://lovr.graphics.getFeatures)]]
	--[[* [`lovr.graphics.getLimits`](lua://lovr.graphics.getLimits)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@return lovr_graphics_get_device_device device]]
	function lovr.graphics.getDevice() return {} end

	--[[https://lovr.org/docs/lovr.graphics.getDevice  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.getDevice`](lua://lovr.graphics.getDevice)  ]]
	--[[@class lovr_graphics_get_device_device]]
	--[[@field id number ]]
	--[[@field vendor number ]]
	--[[@field name string ]]
	--[[@field renderer string ]]
	--[[@field subgroupSize number ]]
	--[[@field discrete boolean ]]

	--[[https://lovr.org/docs/lovr.graphics.getFeatures  ]]
	--[[Get the supported GPU features.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.isFormatSupported`](lua://lovr.graphics.isFormatSupported)]]
	--[[* [`lovr.graphics.getDevice`](lua://lovr.graphics.getDevice)]]
	--[[* [`lovr.graphics.getLimits`](lua://lovr.graphics.getLimits)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@return lovr_graphics_get_features_features features]]
	function lovr.graphics.getFeatures() return {} end

	--[[https://lovr.org/docs/lovr.graphics.getFeatures  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.getFeatures`](lua://lovr.graphics.getFeatures)  ]]
	--[[@class lovr_graphics_get_features_features]]
	--[[@field textureBC boolean ]]
	--[[@field textureASTC boolean ]]
	--[[@field wireframe boolean ]]
	--[[@field depthClamp boolean ]]
	--[[@field depthResolve boolean ]]
	--[[@field indirectDrawFirstInstance boolean ]]
	--[[@field float64 boolean ]]
	--[[@field int64 boolean ]]
	--[[@field int16 boolean ]]

	--[[https://lovr.org/docs/lovr.graphics.getLimits  ]]
	--[[Get the limits of the current GPU.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.isFormatSupported`](lua://lovr.graphics.isFormatSupported)]]
	--[[* [`lovr.graphics.getDevice`](lua://lovr.graphics.getDevice)]]
	--[[* [`lovr.graphics.getFeatures`](lua://lovr.graphics.getFeatures)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@return lovr_graphics_get_limits_limits limits]]
	function lovr.graphics.getLimits() return {} end

	--[[https://lovr.org/docs/lovr.graphics.getLimits  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.getLimits`](lua://lovr.graphics.getLimits)  ]]
	--[[@class lovr_graphics_get_limits_limits]]
	--[[@field textureSize2D number ]]
	--[[@field textureSize3D number ]]
	--[[@field textureSizeCube number ]]
	--[[@field textureLayers number ]]
	--[[@field renderSize table<string,string|number> ]]
	--[[@field uniformBuffersPerStage number ]]
	--[[@field storageBuffersPerStage number ]]
	--[[@field sampledTexturesPerStage number ]]
	--[[@field storageTexturesPerStage number ]]
	--[[@field samplersPerStage number ]]
	--[[@field resourcesPerShader number ]]
	--[[@field uniformBufferRange number ]]
	--[[@field storageBufferRange number ]]
	--[[@field uniformBufferAlign number ]]
	--[[@field storageBufferAlign number ]]
	--[[@field vertexAttributes number ]]
	--[[@field vertexBufferStride number ]]
	--[[@field vertexShaderOutputs number ]]
	--[[@field clipDistances number ]]
	--[[@field cullDistances number ]]
	--[[@field clipAndCullDistances number ]]
	--[[@field workgroupCount table<string,string|number> ]]
	--[[@field workgroupSize table<string,string|number> ]]
	--[[@field totalWorkgroupSize number ]]
	--[[@field computeSharedMemory number ]]
	--[[@field indirectDrawCount number ]]
	--[[@field instances number ]]
	--[[@field anisotropy number ]]
	--[[@field pointSize number ]]

	--[[https://lovr.org/docs/lovr.graphics.getPass  ]]
	--[[Get a temporary Pass.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.submit`](lua://lovr.graphics.submit)]]
	--[[* [`lovr.graphics.getWindowPass`](lua://lovr.graphics.getWindowPass)]]
	--[[* [`lovr.headset.getPass`](lua://lovr.headset.getPass)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param type lovr_pass_type]]
	--[[@return lovr_pass pass]]
	--[[@deprecated]]
	--[[@overload fun(type: lovr_pass_type, texture: lovr_texture): lovr_pass]]
	--[[@overload fun(type: lovr_pass_type, canvas: lovr_graphics_get_pass_canvas): lovr_pass]]
	function lovr.graphics.getPass(type) return Pass_class end

	--[[https://lovr.org/docs/lovr.graphics.getPass  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.getPass`](lua://lovr.graphics.getPass)  ]]
	--[[@class lovr_graphics_get_pass_canvas]]
	--[[@field depth lovr_graphics_get_pass_canvas_depth ]]
	--[[@field samples? number default=`4`]]

	--[[https://lovr.org/docs/lovr.graphics.getPass  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.getPass`](lua://lovr.graphics.getPass)  ]]
	--[[@class lovr_graphics_get_pass_canvas_depth]]
	--[[@field format? lovr_texture_format default=`'d32f'`]]
	--[[@field texture lovr_texture ]]

	--[[https://lovr.org/docs/lovr.graphics.getWindowPass  ]]
	--[[Get the window pass.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@return lovr_pass pass]]
	function lovr.graphics.getWindowPass() return Pass_class end

	--[[https://lovr.org/docs/HorizontalAlign  ]]
	--[[Different ways to horizontally align text.  ]]
	--[[### See also]]
	--[[* [`VerticalAlign`](lua://lovr_verticalAlign)]]
	--[[* [`Pass:text`](lua://lovr_pass.text)]]
	--[[* [`Font:getVertices`](lua://lovr_font.getVertices)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_horizontal_align]]
	local lovr_horizontal_align = {
		--[[Left-aligned text.  ]]
		left = "left",
		--[[Centered text.  ]]
		center = "center",
		--[[Right-aligned text.  ]]
		right = "right",
	}

	--[[https://lovr.org/docs/lovr.graphics.isFormatSupported  ]]
	--[[Check if a Texture format is supported.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.getDevice`](lua://lovr.graphics.getDevice)]]
	--[[* [`lovr.graphics.getFeatures`](lua://lovr.graphics.getFeatures)]]
	--[[* [`lovr.graphics.getLimits`](lua://lovr.graphics.getLimits)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param format lovr_texture_format]]
	--[[@param ... lovr_texture_feature]]
	--[[@return boolean linear]]
	--[[@return boolean srgb]]
	function lovr.graphics.isFormatSupported(format, ...) return false, false end

	--[[https://lovr.org/docs/lovr.graphics.isTimingEnabled  ]]
	--[[Check if timing stats are enabled.  ]]
	--[[### See also]]
	--[[* [`Pass:getStats`](lua://lovr_pass.getStats)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@return boolean enabled]]
	function lovr.graphics.isTimingEnabled() return false end

	--[[https://lovr.org/docs/Material  ]]
	--[[A set of properties and textures that define the properties of a surface.  ]]
	--[[@class lovr_material: lovr_object]]

	--[[https://lovr.org/docs/Material:getProperties  ]]
	--[[Get the properties of the Material.  ]]
	--[[### See also]]
	--[[* [`Material`](lua://lovr_material)]]
	--[[@return table<string,string|number> properties]]
	function Material_class:getProperties() return {} end

	--[[https://lovr.org/docs/Mesh  ]]
	--[[A drawable triangle mesh.  ]]
	--[[@class lovr_mesh: lovr_object]]

	--[[https://lovr.org/docs/Mesh:computeBoundingBox  ]]
	--[[Compute the bounding box of the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getBoundingBox`](lua://lovr_mesh.getBoundingBox)]]
	--[[* [`Mesh:setBoundingBox`](lua://lovr_mesh.setBoundingBox)]]
	--[[* [`Pass:setViewCull`](lua://lovr_pass.setViewCull)]]
	--[[* [`Collider:getAABB`](lua://lovr_collider.getAABB)]]
	--[[* [`Shape:getAABB`](lua://lovr_shape.getAABB)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return boolean updated]]
	function Mesh_class:computeBoundingBox() return false end

	--[[https://lovr.org/docs/Mesh:getBoundingBox  ]]
	--[[Get the bounding box of the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:computeBoundingBox`](lua://lovr_mesh.computeBoundingBox)]]
	--[[* [`Pass:setViewCull`](lua://lovr_pass.setViewCull)]]
	--[[* [`Collider:getAABB`](lua://lovr_collider.getAABB)]]
	--[[* [`Shape:getAABB`](lua://lovr_shape.getAABB)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return number minx]]
	--[[@return number maxx]]
	--[[@return number miny]]
	--[[@return number maxy]]
	--[[@return number minz]]
	--[[@return number maxz]]
	function Mesh_class:getBoundingBox() return 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Mesh:getDrawMode  ]]
	--[[Get the draw mode of the Mesh.  ]]
	--[[### See also]]
	--[[* [`Pass:setMeshMode`](lua://lovr_pass.setMeshMode)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return lovr_draw_mode mode]]
	function Mesh_class:getDrawMode() return DrawMode_class end

	--[[https://lovr.org/docs/Mesh:getIndexBuffer  ]]
	--[[Get the Buffer backing the vertex indices of the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getIndices`](lua://lovr_mesh.getIndices)]]
	--[[* [`Mesh:setIndices`](lua://lovr_mesh.setIndices)]]
	--[[* [`Mesh:getVertexBuffer`](lua://lovr_mesh.getVertexBuffer)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return lovr_buffer buffer]]
	function Mesh_class:getIndexBuffer() return Buffer_class end

	--[[https://lovr.org/docs/Mesh:getIndices  ]]
	--[[Get the vertex indices in the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getIndexBuffer`](lua://lovr_mesh.getIndexBuffer)]]
	--[[* [`Mesh:setIndexBuffer`](lua://lovr_mesh.setIndexBuffer)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return table<string,string|number> t]]
	function Mesh_class:getIndices() return {} end

	--[[https://lovr.org/docs/Mesh:getMaterial  ]]
	--[[Get the Material applied to the Mesh.  ]]
	--[[### See also]]
	--[[* [`Pass:setMaterial`](lua://lovr_pass.setMaterial)]]
	--[[* [`Model:getMaterial`](lua://lovr_model.getMaterial)]]
	--[[* [`lovr.graphics.newMaterial`](lua://lovr.graphics.newMaterial)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return lovr_material material]]
	function Mesh_class:getMaterial() return Material_class end

	--[[https://lovr.org/docs/Mesh:getVertexBuffer  ]]
	--[[Get the Buffer backing the vertices of the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getVertices`](lua://lovr_mesh.getVertices)]]
	--[[* [`Mesh:setVertices`](lua://lovr_mesh.setVertices)]]
	--[[* [`Mesh:getIndexBuffer`](lua://lovr_mesh.getIndexBuffer)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return lovr_buffer buffer]]
	function Mesh_class:getVertexBuffer() return Buffer_class end

	--[[https://lovr.org/docs/Mesh:getVertexCount  ]]
	--[[Get the number of vertices in the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getVertexStride`](lua://lovr_mesh.getVertexStride)]]
	--[[* [`Mesh:getVertexFormat`](lua://lovr_mesh.getVertexFormat)]]
	--[[* [`lovr.graphics.newMesh`](lua://lovr.graphics.newMesh)]]
	--[[* [`Model:getMesh`](lua://lovr_model.getMesh)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return number count]]
	function Mesh_class:getVertexCount() return 0 end

	--[[https://lovr.org/docs/Mesh:getVertexFormat  ]]
	--[[Get the vertex format of the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getVertexCount`](lua://lovr_mesh.getVertexCount)]]
	--[[* [`Mesh:getVertexStride`](lua://lovr_mesh.getVertexStride)]]
	--[[* [`lovr.graphics.newMesh`](lua://lovr.graphics.newMesh)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return lovr_graphics_mesh_get_vertex_format_format[] format]]
	function Mesh_class:getVertexFormat() return {} end

	--[[https://lovr.org/docs/Mesh:getVertexStride  ]]
	--[[Get the size of each vertex in the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getVertexCount`](lua://lovr_mesh.getVertexCount)]]
	--[[* [`Mesh:getVertexFormat`](lua://lovr_mesh.getVertexFormat)]]
	--[[* [`lovr.graphics.newMesh`](lua://lovr.graphics.newMesh)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return number stride]]
	function Mesh_class:getVertexStride() return 0 end

	--[[https://lovr.org/docs/Mesh:getVertices  ]]
	--[[Get the vertices in the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getVertexBuffer`](lua://lovr_mesh.getVertexBuffer)]]
	--[[* [`Mesh:getVertexFormat`](lua://lovr_mesh.getVertexFormat)]]
	--[[* [`Mesh:getIndices`](lua://lovr_mesh.getIndices)]]
	--[[* [`Mesh:setIndices`](lua://lovr_mesh.setIndices)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@param index? number default=`1`]]
	--[[@param count? number default=`nil`]]
	--[[@return table<string,string|number> vertices]]
	function Mesh_class:getVertices(index, count) return {} end

	--[[https://lovr.org/docs/Mesh:setBoundingBox  ]]
	--[[Set or remove the bounding box of the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:computeBoundingBox`](lua://lovr_mesh.computeBoundingBox)]]
	--[[* [`Pass:setViewCull`](lua://lovr_pass.setViewCull)]]
	--[[* [`Collider:getAABB`](lua://lovr_collider.getAABB)]]
	--[[* [`Shape:getAABB`](lua://lovr_shape.getAABB)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@param minx number]]
	--[[@param maxx number]]
	--[[@param miny number]]
	--[[@param maxy number]]
	--[[@param minz number]]
	--[[@param maxz number]]
	--[[@overload fun(self: lovr_mesh)]]
	function Mesh_class:setBoundingBox(minx, maxx, miny, maxy, minz, maxz) end

	--[[https://lovr.org/docs/Mesh:setDrawMode  ]]
	--[[Set the draw mode of the Mesh.  ]]
	--[[### See also]]
	--[[* [`Pass:setMeshMode`](lua://lovr_pass.setMeshMode)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@param mode lovr_draw_mode]]
	function Mesh_class:setDrawMode(mode) end

	--[[https://lovr.org/docs/Mesh:setIndexBuffer  ]]
	--[[Set a Buffer for the Mesh to use for vertex indices.  ]]
	--[[### See also]]
	--[[* [`Mesh:getIndices`](lua://lovr_mesh.getIndices)]]
	--[[* [`Mesh:setIndices`](lua://lovr_mesh.setIndices)]]
	--[[* [`Mesh:getVertexBuffer`](lua://lovr_mesh.getVertexBuffer)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@return lovr_buffer buffer]]
	function Mesh_class:setIndexBuffer() return Buffer_class end

	--[[https://lovr.org/docs/Mesh:setIndices  ]]
	--[[Set the vertex indices of the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getIndexBuffer`](lua://lovr_mesh.getIndexBuffer)]]
	--[[* [`Mesh:setIndexBuffer`](lua://lovr_mesh.setIndexBuffer)]]
	--[[* [`Mesh:setVertices`](lua://lovr_mesh.setVertices)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@param t table<string,string|number>]]
	--[[@overload fun(self: lovr_mesh, blob: lovr_blob, type: lovr_data_type)]]
	--[[@overload fun(self: lovr_mesh)]]
	function Mesh_class:setIndices(t) end

	--[[https://lovr.org/docs/Mesh:setMaterial  ]]
	--[[Set a Material to use when drawing the Mesh.  ]]
	--[[### See also]]
	--[[* [`Pass:setMaterial`](lua://lovr_pass.setMaterial)]]
	--[[* [`Model:getMaterial`](lua://lovr_model.getMaterial)]]
	--[[* [`lovr.graphics.newMaterial`](lua://lovr.graphics.newMaterial)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@param material lovr_material]]
	--[[@overload fun(self: lovr_mesh, texture: lovr_texture)]]
	function Mesh_class:setMaterial(material) end

	--[[https://lovr.org/docs/Mesh:setVertices  ]]
	--[[Set vertices in the Mesh.  ]]
	--[[### See also]]
	--[[* [`Mesh:getVertexBuffer`](lua://lovr_mesh.getVertexBuffer)]]
	--[[* [`Mesh:getVertexFormat`](lua://lovr_mesh.getVertexFormat)]]
	--[[* [`Mesh:getIndices`](lua://lovr_mesh.getIndices)]]
	--[[* [`Mesh:setIndices`](lua://lovr_mesh.setIndices)]]
	--[[* [`Mesh`](lua://lovr_mesh)]]
	--[[@param vertices table<string,string|number>]]
	--[[@param index? number default=`1`]]
	--[[@param count? number default=`nil`]]
	--[[@overload fun(self: lovr_mesh, blob: lovr_blob, index?: number, count?: number)]]
	function Mesh_class:setVertices(vertices, index, count) end

	--[[https://lovr.org/docs/MeshStorage  ]]
	--[[Whether a Mesh stores its data on the CPU or GPU.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newMesh`](lua://lovr.graphics.newMesh)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_mesh_storage]]
	local lovr_mesh_storage = {
		--[[The Mesh will store a copy of the vertices on the CPU.  ]]
		cpu = "cpu",
		--[[The Mesh will not keep a CPU copy, only storing vertices on the GPU.  ]]
		gpu = "gpu",
	}

	--[[https://lovr.org/docs/Mesh:getVertexFormat  ]]
	--[[see also:  ]]
	--[[[`Mesh:getVertexFormat`](lua://Mesh:getVertexFormat)  ]]
	--[[@class lovr_graphics_mesh_get_vertex_format_format]]
	--[[@field [1] string ]]
	--[[@field [2] lovr_data_type ]]
	--[[@field [3] number ]]

	--[[https://lovr.org/docs/Model  ]]
	--[[A 3D model.  ]]
	--[[@class lovr_model: lovr_object]]

	--[[https://lovr.org/docs/Model:animate  ]]
	--[[Animate the Model.  ]]
	--[[### See also]]
	--[[* [`Model:resetNodeTransforms`](lua://lovr_model.resetNodeTransforms)]]
	--[[* [`Model:getAnimationCount`](lua://lovr_model.getAnimationCount)]]
	--[[* [`Model:getAnimationName`](lua://lovr_model.getAnimationName)]]
	--[[* [`Model:getAnimationDuration`](lua://lovr_model.getAnimationDuration)]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:setNodePosition`](lua://lovr_model.setNodePosition)]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:setNodeOrientation`](lua://lovr_model.setNodeOrientation)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:setNodeScale`](lua://lovr_model.setNodeScale)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:setNodeTransform`](lua://lovr_model.setNodeTransform)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param name string]]
	--[[@param time number]]
	--[[@param blend? number default=`1.0`]]
	--[[@overload fun(self: lovr_model, index: number, time: number, blend?: number)]]
	function Model_class:animate(name, time, blend) end

	--[[https://lovr.org/docs/Model:clone  ]]
	--[[Return a lightweight copy of the Model with its own animation state.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newModel`](lua://lovr.graphics.newModel)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return lovr_model model]]
	function Model_class:clone() return Model_class end

	--[[https://lovr.org/docs/Model:getAnimationCount  ]]
	--[[Get the number of animations in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getAnimationName`](lua://lovr_model.getAnimationName)]]
	--[[* [`Model:getAnimationDuration`](lua://lovr_model.getAnimationDuration)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number count]]
	function Model_class:getAnimationCount() return 0 end

	--[[https://lovr.org/docs/Model:getAnimationDuration  ]]
	--[[Get the duration of an animation in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getAnimationCount`](lua://lovr_model.getAnimationCount)]]
	--[[* [`Model:getAnimationName`](lua://lovr_model.getAnimationName)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return number duration]]
	--[[@overload fun(self: lovr_model, name: string): number]]
	function Model_class:getAnimationDuration(index) return 0 end

	--[[https://lovr.org/docs/Model:getAnimationName  ]]
	--[[Get the name of an animation in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getAnimationCount`](lua://lovr_model.getAnimationCount)]]
	--[[* [`Model:getAnimationDuration`](lua://lovr_model.getAnimationDuration)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return string name]]
	function Model_class:getAnimationName(index) return "" end

	--[[https://lovr.org/docs/Model:getBlendShapeCount  ]]
	--[[Get the number of blend shapes in the model.  ]]
	--[[### See also]]
	--[[* [`Model:getBlendShapeName`](lua://lovr_model.getBlendShapeName)]]
	--[[* [`ModelData:getBlendShapeCount`](lua://lovr_modelData.getBlendShapeCount)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number count]]
	function Model_class:getBlendShapeCount() return 0 end

	--[[https://lovr.org/docs/Model:getBlendShapeName  ]]
	--[[Get the name of a blend shape in the model.  ]]
	--[[### See also]]
	--[[* [`Model:getBlendShapeCount`](lua://lovr_model.getBlendShapeCount)]]
	--[[* [`ModelData:getBlendShapeName`](lua://lovr_modelData.getBlendShapeName)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return string name]]
	function Model_class:getBlendShapeName(index) return "" end

	--[[https://lovr.org/docs/Model:getBlendShapeWeight  ]]
	--[[Get the weight of a blend shape.  ]]
	--[[### See also]]
	--[[* [`Model:getBlendShapeCount`](lua://lovr_model.getBlendShapeCount)]]
	--[[* [`Model:getBlendShapeName`](lua://lovr_model.getBlendShapeName)]]
	--[[* [`Model:resetBlendShapes`](lua://lovr_model.resetBlendShapes)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return number weight]]
	--[[@overload fun(self: lovr_model, name: string): number]]
	function Model_class:getBlendShapeWeight(index) return 0 end

	--[[https://lovr.org/docs/Model:getBoundingBox  ]]
	--[[Get the bounding box of the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getWidth`](lua://lovr_model.getWidth)]]
	--[[* [`Model:getHeight`](lua://lovr_model.getHeight)]]
	--[[* [`Model:getDepth`](lua://lovr_model.getDepth)]]
	--[[* [`Model:getDimensions`](lua://lovr_model.getDimensions)]]
	--[[* [`Model:getCenter`](lua://lovr_model.getCenter)]]
	--[[* [`Model:getBoundingSphere`](lua://lovr_model.getBoundingSphere)]]
	--[[* [`ModelData:getBoundingBox`](lua://lovr_modelData.getBoundingBox)]]
	--[[* [`Collider:getAABB`](lua://lovr_collider.getAABB)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number minx]]
	--[[@return number maxx]]
	--[[@return number miny]]
	--[[@return number maxy]]
	--[[@return number minz]]
	--[[@return number maxz]]
	function Model_class:getBoundingBox() return 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Model:getBoundingSphere  ]]
	--[[Get the bounding sphere of the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getWidth`](lua://lovr_model.getWidth)]]
	--[[* [`Model:getHeight`](lua://lovr_model.getHeight)]]
	--[[* [`Model:getDepth`](lua://lovr_model.getDepth)]]
	--[[* [`Model:getDimensions`](lua://lovr_model.getDimensions)]]
	--[[* [`Model:getCenter`](lua://lovr_model.getCenter)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData:getBoundingSphere`](lua://lovr_modelData.getBoundingSphere)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number radius]]
	function Model_class:getBoundingSphere() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Model:getCenter  ]]
	--[[Get the center of the Model's bounding box.  ]]
	--[[### See also]]
	--[[* [`Model:getWidth`](lua://lovr_model.getWidth)]]
	--[[* [`Model:getHeight`](lua://lovr_model.getHeight)]]
	--[[* [`Model:getDepth`](lua://lovr_model.getDepth)]]
	--[[* [`Model:getDimensions`](lua://lovr_model.getDimensions)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData:getCenter`](lua://lovr_modelData.getCenter)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Model_class:getCenter() return 0, 0, 0 end

	--[[https://lovr.org/docs/Model:getData  ]]
	--[[Get the ModelData backing the Model.  ]]
	--[[### See also]]
	--[[* [`lovr.data.newModelData`](lua://lovr.data.newModelData)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return lovr_model_data data]]
	function Model_class:getData() return ModelData_class end

	--[[https://lovr.org/docs/Model:getDepth  ]]
	--[[Get the depth of the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getWidth`](lua://lovr_model.getWidth)]]
	--[[* [`Model:getHeight`](lua://lovr_model.getHeight)]]
	--[[* [`Model:getDimensions`](lua://lovr_model.getDimensions)]]
	--[[* [`Model:getCenter`](lua://lovr_model.getCenter)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData:getDepth`](lua://lovr_modelData.getDepth)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number depth]]
	function Model_class:getDepth() return 0 end

	--[[https://lovr.org/docs/Model:getDimensions  ]]
	--[[Get the dimensions of the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getWidth`](lua://lovr_model.getWidth)]]
	--[[* [`Model:getHeight`](lua://lovr_model.getHeight)]]
	--[[* [`Model:getDepth`](lua://lovr_model.getDepth)]]
	--[[* [`Model:getCenter`](lua://lovr_model.getCenter)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData:getDimensions`](lua://lovr_modelData.getDimensions)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number width]]
	--[[@return number height]]
	--[[@return number depth]]
	function Model_class:getDimensions() return 0, 0, 0 end

	--[[https://lovr.org/docs/Model:getHeight  ]]
	--[[Get the height of the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getWidth`](lua://lovr_model.getWidth)]]
	--[[* [`Model:getDepth`](lua://lovr_model.getDepth)]]
	--[[* [`Model:getDimensions`](lua://lovr_model.getDimensions)]]
	--[[* [`Model:getCenter`](lua://lovr_model.getCenter)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData:getHeight`](lua://lovr_modelData.getHeight)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number height]]
	function Model_class:getHeight() return 0 end

	--[[https://lovr.org/docs/Model:getIndexBuffer  ]]
	--[[Get a Buffer containing the triangle indices in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getVertexBuffer`](lua://lovr_model.getVertexBuffer)]]
	--[[* [`Model:getMesh`](lua://lovr_model.getMesh)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return lovr_buffer buffer]]
	function Model_class:getIndexBuffer() return Buffer_class end

	--[[https://lovr.org/docs/Model:getMaterialCount  ]]
	--[[Get the number of materials in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getMaterialName`](lua://lovr_model.getMaterialName)]]
	--[[* [`Model:getMaterial`](lua://lovr_model.getMaterial)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number count]]
	function Model_class:getMaterialCount() return 0 end

	--[[https://lovr.org/docs/Model:getMaterial  ]]
	--[[Get a Material from the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getMaterialCount`](lua://lovr_model.getMaterialCount)]]
	--[[* [`Model:getMaterialName`](lua://lovr_model.getMaterialName)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param name string]]
	--[[@return lovr_material material]]
	--[[@overload fun(self: lovr_model, index: number): lovr_material]]
	function Model_class:getMaterial(name) return Material_class end

	--[[https://lovr.org/docs/Model:getMaterialName  ]]
	--[[Get the name of a material in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getMaterialCount`](lua://lovr_model.getMaterialCount)]]
	--[[* [`Model:getMaterial`](lua://lovr_model.getMaterial)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return string name]]
	function Model_class:getMaterialName(index) return "" end

	--[[https://lovr.org/docs/Model:getMeshCount  ]]
	--[[Get the number of meshes in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getMesh`](lua://lovr_model.getMesh)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number count]]
	function Model_class:getMeshCount() return 0 end

	--[[https://lovr.org/docs/Model:getMesh  ]]
	--[[Get a Mesh from the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getMeshCount`](lua://lovr_model.getMeshCount)]]
	--[[* [`lovr.graphics.newMesh`](lua://lovr.graphics.newMesh)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return lovr_mesh mesh]]
	function Model_class:getMesh(index) return Mesh_class end

	--[[https://lovr.org/docs/Model:getMetadata  ]]
	--[[Get extra information from the model file.  ]]
	--[[### See also]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return string metadata]]
	function Model_class:getMetadata() return "" end

	--[[https://lovr.org/docs/Model:getNodeChildren  ]]
	--[[Get the children of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodeParent`](lua://lovr_model.getNodeParent)]]
	--[[* [`Model:getRootNode`](lua://lovr_model.getRootNode)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return table<string,string|number> children]]
	--[[@overload fun(self: lovr_model, name: string): table<string,string|number>]]
	function Model_class:getNodeChildren(index) return {} end

	--[[https://lovr.org/docs/Model:getNodeCount  ]]
	--[[Get the number of nodes in the model.  ]]
	--[[### See also]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number count]]
	function Model_class:getNodeCount() return 0 end

	--[[https://lovr.org/docs/Model:getNodeName  ]]
	--[[Get the name of a node in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getNodeCount`](lua://lovr_model.getNodeCount)]]
	--[[* [`Model:getAnimationName`](lua://lovr_model.getAnimationName)]]
	--[[* [`Model:getMaterialName`](lua://lovr_model.getMaterialName)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return string name]]
	function Model_class:getNodeName(index) return "" end

	--[[https://lovr.org/docs/Model:getNodeOrientation  ]]
	--[[Get the orientation of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:setNodePosition`](lua://lovr_model.setNodePosition)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:setNodeScale`](lua://lovr_model.setNodeScale)]]
	--[[* [`Model:getNodePose`](lua://lovr_model.getNodePose)]]
	--[[* [`Model:setNodePose`](lua://lovr_model.setNodePose)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:setNodeTransform`](lua://lovr_model.setNodeTransform)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param origin? lovr_origin_type default=`'root'`]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	--[[@overload fun(self: lovr_model, name: string, origin?: lovr_origin_type): number, number, number, number]]
	function Model_class:getNodeOrientation(index, origin) return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Model:getNodeParent  ]]
	--[[Get the parent of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodeChildren`](lua://lovr_model.getNodeChildren)]]
	--[[* [`Model:getRootNode`](lua://lovr_model.getRootNode)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return number parent]]
	--[[@overload fun(self: lovr_model, name: string): number]]
	function Model_class:getNodeParent(index) return 0 end

	--[[https://lovr.org/docs/Model:getNodePose  ]]
	--[[Get the pose of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:setNodePosition`](lua://lovr_model.setNodePosition)]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:setNodeOrientation`](lua://lovr_model.setNodeOrientation)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:setNodeScale`](lua://lovr_model.setNodeScale)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:setNodeTransform`](lua://lovr_model.setNodeTransform)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param origin? lovr_origin_type default=`'root'`]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	--[[@overload fun(self: lovr_model, name: string, origin?: lovr_origin_type): number, number, number, number, number, number, number]]
	function Model_class:getNodePose(index, origin) return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Model:getNodePosition  ]]
	--[[Get the position of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:setNodeOrientation`](lua://lovr_model.setNodeOrientation)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:setNodeScale`](lua://lovr_model.setNodeScale)]]
	--[[* [`Model:getNodePose`](lua://lovr_model.getNodePose)]]
	--[[* [`Model:setNodePose`](lua://lovr_model.setNodePose)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:setNodeTransform`](lua://lovr_model.setNodeTransform)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param space? lovr_origin_type default=`'root'`]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@overload fun(self: lovr_model, name: string, space?: lovr_origin_type): number, number, number]]
	function Model_class:getNodePosition(index, space) return 0, 0, 0 end

	--[[https://lovr.org/docs/Model:getNodeScale  ]]
	--[[Get the scale of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:setNodePosition`](lua://lovr_model.setNodePosition)]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:setNodeOrientation`](lua://lovr_model.setNodeOrientation)]]
	--[[* [`Model:getNodePose`](lua://lovr_model.getNodePose)]]
	--[[* [`Model:setNodePose`](lua://lovr_model.setNodePose)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:setNodeTransform`](lua://lovr_model.setNodeTransform)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param origin? lovr_origin_type default=`'root'`]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@overload fun(self: lovr_model, name: string, origin?: lovr_origin_type): number, number, number]]
	function Model_class:getNodeScale(index, origin) return 0, 0, 0 end

	--[[https://lovr.org/docs/Model:getNodeTransform  ]]
	--[[Get the transform of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:setNodePosition`](lua://lovr_model.setNodePosition)]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:setNodeOrientation`](lua://lovr_model.setNodeOrientation)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:setNodeScale`](lua://lovr_model.setNodeScale)]]
	--[[* [`Model:getNodePose`](lua://lovr_model.getNodePose)]]
	--[[* [`Model:setNodePose`](lua://lovr_model.setNodePose)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param origin? lovr_origin_type default=`'root'`]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number sx]]
	--[[@return number sy]]
	--[[@return number sz]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	--[[@overload fun(self: lovr_model, name: string, origin?: lovr_origin_type): number, number, number, number, number, number, number, number, number, number]]
	function Model_class:getNodeTransform(index, origin) return 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Model:getRootNode  ]]
	--[[Get the index of the root node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodeCount`](lua://lovr_model.getNodeCount)]]
	--[[* [`Model:getNodeParent`](lua://lovr_model.getNodeParent)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number root]]
	function Model_class:getRootNode() return 0 end

	--[[https://lovr.org/docs/Model:getTextureCount  ]]
	--[[Get the number of textures in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getTexture`](lua://lovr_model.getTexture)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number count]]
	function Model_class:getTextureCount() return 0 end

	--[[https://lovr.org/docs/Model:getTexture  ]]
	--[[Get one of the textures in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getTextureCount`](lua://lovr_model.getTextureCount)]]
	--[[* [`Model:getMaterial`](lua://lovr_model.getMaterial)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@return lovr_texture texture]]
	function Model_class:getTexture(index) return Texture_class end

	--[[https://lovr.org/docs/Model:getTriangleCount  ]]
	--[[Get the total number of triangles in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getTriangles`](lua://lovr_model.getTriangles)]]
	--[[* [`Model:getVertexCount`](lua://lovr_model.getVertexCount)]]
	--[[* [`ModelData:getTriangleCount`](lua://lovr_modelData.getTriangleCount)]]
	--[[* [`Model:getMesh`](lua://lovr_model.getMesh)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number count]]
	function Model_class:getTriangleCount() return 0 end

	--[[https://lovr.org/docs/Model:getTriangles  ]]
	--[[Get all the triangles in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getTriangleCount`](lua://lovr_model.getTriangleCount)]]
	--[[* [`Model:getVertexCount`](lua://lovr_model.getVertexCount)]]
	--[[* [`Model:getMesh`](lua://lovr_model.getMesh)]]
	--[[* [`ModelData:getTriangles`](lua://lovr_modelData.getTriangles)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return table<string,string|number> vertices]]
	--[[@return table<string,string|number> indices]]
	function Model_class:getTriangles() return {}, {} end

	--[[https://lovr.org/docs/Model:getVertexBuffer  ]]
	--[[Get a Buffer containing the vertices in the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getIndexBuffer`](lua://lovr_model.getIndexBuffer)]]
	--[[* [`Model:getMesh`](lua://lovr_model.getMesh)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return lovr_buffer buffer]]
	function Model_class:getVertexBuffer() return Buffer_class end

	--[[https://lovr.org/docs/Model:getVertexCount  ]]
	--[[Get the total vertex count of the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getTriangles`](lua://lovr_model.getTriangles)]]
	--[[* [`Model:getTriangleCount`](lua://lovr_model.getTriangleCount)]]
	--[[* [`ModelData:getVertexCount`](lua://lovr_modelData.getVertexCount)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number count]]
	function Model_class:getVertexCount() return 0 end

	--[[https://lovr.org/docs/Model:getWidth  ]]
	--[[Get the width of the Model.  ]]
	--[[### See also]]
	--[[* [`Model:getHeight`](lua://lovr_model.getHeight)]]
	--[[* [`Model:getDepth`](lua://lovr_model.getDepth)]]
	--[[* [`Model:getDimensions`](lua://lovr_model.getDimensions)]]
	--[[* [`Model:getCenter`](lua://lovr_model.getCenter)]]
	--[[* [`Model:getBoundingBox`](lua://lovr_model.getBoundingBox)]]
	--[[* [`ModelData:getWidth`](lua://lovr_modelData.getWidth)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return number width]]
	function Model_class:getWidth() return 0 end

	--[[https://lovr.org/docs/Model:hasJoints  ]]
	--[[Check if the Model uses joints for skeletal animation.  ]]
	--[[### See also]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@return boolean jointed]]
	function Model_class:hasJoints() return false end

	--[[https://lovr.org/docs/Model:resetBlendShapes  ]]
	--[[Reset blend shape weights.  ]]
	--[[### See also]]
	--[[* [`Model:resetNodeTransforms`](lua://lovr_model.resetNodeTransforms)]]
	--[[* [`Model:getBlendShapeWeight`](lua://lovr_model.getBlendShapeWeight)]]
	--[[* [`Model:setBlendShapeWeight`](lua://lovr_model.setBlendShapeWeight)]]
	--[[* [`Model`](lua://lovr_model)]]
	function Model_class:resetBlendShapes() end

	--[[https://lovr.org/docs/Model:resetNodeTransforms  ]]
	--[[Reset node transforms.  ]]
	--[[### See also]]
	--[[* [`Model:resetBlendShapes`](lua://lovr_model.resetBlendShapes)]]
	--[[* [`Model`](lua://lovr_model)]]
	function Model_class:resetNodeTransforms() end

	--[[https://lovr.org/docs/Model:setBlendShapeWeight  ]]
	--[[Set the weight of a blend shape.  ]]
	--[[### See also]]
	--[[* [`Model:getBlendShapeCount`](lua://lovr_model.getBlendShapeCount)]]
	--[[* [`Model:getBlendShapeName`](lua://lovr_model.getBlendShapeName)]]
	--[[* [`Model:resetBlendShapes`](lua://lovr_model.resetBlendShapes)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param weight number]]
	--[[@overload fun(self: lovr_model, name: string, weight: number)]]
	function Model_class:setBlendShapeWeight(index, weight) end

	--[[https://lovr.org/docs/Model:setNodeOrientation  ]]
	--[[Set or blend the orientation of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:setNodePosition`](lua://lovr_model.setNodePosition)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:setNodeScale`](lua://lovr_model.setNodeScale)]]
	--[[* [`Model:getNodePose`](lua://lovr_model.getNodePose)]]
	--[[* [`Model:setNodePose`](lua://lovr_model.setNodePose)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:setNodeTransform`](lua://lovr_model.setNodeTransform)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@param blend? number default=`1.0`]]
	--[[@overload fun(self: lovr_model, name: string, angle: number, ax: number, ay: number, az: number, blend?: number)]]
	--[[@overload fun(self: lovr_model, index: number, orientation: lovr_quat, blend?: number)]]
	--[[@overload fun(self: lovr_model, name: string, orientation: lovr_quat, blend?: number)]]
	function Model_class:setNodeOrientation(index, angle, ax, ay, az, blend) end

	--[[https://lovr.org/docs/Model:setNodePose  ]]
	--[[Set or blend the pose of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:setNodePosition`](lua://lovr_model.setNodePosition)]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:setNodeOrientation`](lua://lovr_model.setNodeOrientation)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:setNodeScale`](lua://lovr_model.setNodeScale)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:setNodeTransform`](lua://lovr_model.setNodeTransform)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@param blend? number default=`1.0`]]
	--[[@overload fun(self: lovr_model, name: string, x: number, y: number, z: number, angle: number, ax: number, ay: number, az: number, blend?: number)]]
	--[[@overload fun(self: lovr_model, index: number, position: lovr_vec3, orientation: lovr_quat, blend?: number)]]
	--[[@overload fun(self: lovr_model, name: string, position: lovr_vec3, orientation: lovr_quat, blend?: number)]]
	function Model_class:setNodePose(index, x, y, z, angle, ax, ay, az, blend) end

	--[[https://lovr.org/docs/Model:setNodePosition  ]]
	--[[Set or blend the position of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:setNodeOrientation`](lua://lovr_model.setNodeOrientation)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:setNodeScale`](lua://lovr_model.setNodeScale)]]
	--[[* [`Model:getNodePose`](lua://lovr_model.getNodePose)]]
	--[[* [`Model:setNodePose`](lua://lovr_model.setNodePose)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:setNodeTransform`](lua://lovr_model.setNodeTransform)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param blend? number default=`1.0`]]
	--[[@overload fun(self: lovr_model, name: string, x: number, y: number, z: number, blend?: number)]]
	--[[@overload fun(self: lovr_model, index: number, position: lovr_vec3, blend?: number)]]
	--[[@overload fun(self: lovr_model, name: string, position: lovr_vec3, blend?: number)]]
	function Model_class:setNodePosition(index, x, y, z, blend) end

	--[[https://lovr.org/docs/Model:setNodeScale  ]]
	--[[Set or blend the scale of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:setNodePosition`](lua://lovr_model.setNodePosition)]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:setNodeOrientation`](lua://lovr_model.setNodeOrientation)]]
	--[[* [`Model:getNodePose`](lua://lovr_model.getNodePose)]]
	--[[* [`Model:setNodePose`](lua://lovr_model.setNodePose)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:setNodeTransform`](lua://lovr_model.setNodeTransform)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param sx number]]
	--[[@param sy number]]
	--[[@param sz number]]
	--[[@param blend? number default=`1.0`]]
	--[[@overload fun(self: lovr_model, name: string, sx: number, sy: number, sz: number, blend?: number)]]
	--[[@overload fun(self: lovr_model, index: number, scale: lovr_vec3, blend?: number)]]
	--[[@overload fun(self: lovr_model, name: string, scale: lovr_vec3, blend?: number)]]
	function Model_class:setNodeScale(index, sx, sy, sz, blend) end

	--[[https://lovr.org/docs/Model:setNodeTransform  ]]
	--[[Set or blend the transform of a node.  ]]
	--[[### See also]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:setNodePosition`](lua://lovr_model.setNodePosition)]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:setNodeOrientation`](lua://lovr_model.setNodeOrientation)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:setNodeScale`](lua://lovr_model.setNodeScale)]]
	--[[* [`Model:getNodePose`](lua://lovr_model.getNodePose)]]
	--[[* [`Model:setNodePose`](lua://lovr_model.setNodePose)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`Model`](lua://lovr_model)]]
	--[[@param index number]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param sx number]]
	--[[@param sy number]]
	--[[@param sz number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@param blend? number default=`1.0`]]
	--[[@overload fun(self: lovr_model, name: string, x: number, y: number, z: number, sx: number, sy: number, sz: number, angle: number, ax: number, ay: number, az: number, blend?: number)]]
	--[[@overload fun(self: lovr_model, index: number, position: lovr_vec3, scale: lovr_vec3, orientation: lovr_quat, blend?: number)]]
	--[[@overload fun(self: lovr_model, name: string, position: lovr_vec3, scale: lovr_vec3, orientation: lovr_quat, blend?: number)]]
	--[[@overload fun(self: lovr_model, index: number, transform: lovr_mat4, blend?: number)]]
	--[[@overload fun(self: lovr_model, name: string, transform: lovr_mat4, blend?: number)]]
	function Model_class:setNodeTransform(index, x, y, z, sx, sy, sz, angle, ax, ay, az, blend) end

	--[[https://lovr.org/docs/lovr.graphics.newBuffer  ]]
	--[[Create a new Buffer.  ]]
	--[[### See also]]
	--[[* [`Shader:getBufferFormat`](lua://lovr_shader.getBufferFormat)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param size number]]
	--[[@return lovr_buffer buffer]]
	--[[@overload fun(blob: lovr_blob): lovr_buffer]]
	--[[@overload fun(format: lovr_graphics_new_buffer_format, length?: number): lovr_buffer]]
	--[[@overload fun(format: lovr_graphics_new_buffer_format, data: table<string,string|number>): lovr_buffer]]
	--[[@overload fun(format: lovr_graphics_new_buffer_format, blob: lovr_blob): lovr_buffer]]
	--[[@overload fun(type: lovr_data_type, length?: number): lovr_buffer]]
	--[[@overload fun(type: lovr_data_type, data: table<string,string|number>): lovr_buffer]]
	--[[@overload fun(type: lovr_data_type, blob: lovr_blob): lovr_buffer]]
	function lovr.graphics.newBuffer(size) return Buffer_class end

	--[[https://lovr.org/docs/lovr.graphics.newBuffer  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newBuffer`](lua://lovr.graphics.newBuffer)  ]]
	--[[@class lovr_graphics_new_buffer_format]]
	--[[@field layout? lovr_data_layout default=`packed`]]
	--[[@field stride? number ]]

	--[[https://lovr.org/docs/lovr.graphics.newFont  ]]
	--[[Create a new Font.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.getDefaultFont`](lua://lovr.graphics.getDefaultFont)]]
	--[[* [`lovr.data.newRasterizer`](lua://lovr.data.newRasterizer)]]
	--[[* [`Pass:text`](lua://lovr_pass.text)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param filename string]]
	--[[@param size? number default=`32`]]
	--[[@param spread? number default=`4`]]
	--[[@return lovr_font font]]
	--[[@overload fun(blob: lovr_blob, size?: number, spread?: number): lovr_font]]
	--[[@overload fun(size?: number, spread?: number): lovr_font]]
	--[[@overload fun(rasterizer: lovr_rasterizer, spread?: number): lovr_font]]
	function lovr.graphics.newFont(filename, size, spread) return Font_class end

	--[[https://lovr.org/docs/lovr.graphics.newMaterial  ]]
	--[[Create a new Material.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param properties lovr_graphics_new_material_properties]]
	--[[@return lovr_material material]]
	function lovr.graphics.newMaterial(properties) return Material_class end

	--[[https://lovr.org/docs/lovr.graphics.newMaterial  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newMaterial`](lua://lovr.graphics.newMaterial)  ]]
	--[[@class lovr_graphics_new_material_properties]]
	--[[@field color? lovr_vec4 default=`{ 1, 1, 1, 1 }`]]
	--[[@field glow? lovr_vec4 default=`{ 0, 0, 0, 0 }`]]
	--[[@field uvShift? lovr_vec2 default=`{ 0, 0 }`]]
	--[[@field uvScale? lovr_vec2 default=`{ 1, 1 }`]]
	--[[@field metalness? number default=`0`]]
	--[[@field roughness? number default=`0`]]
	--[[@field clearcoat? number default=`0`]]
	--[[@field clearcoatRoughness? number default=`0`]]
	--[[@field occlusionStrength? number default=`1`]]
	--[[@field normalScale? number default=`1`]]
	--[[@field alphaCutoff? number default=`0`]]
	--[[@field texture lovr_texture ]]
	--[[@field glowTexture lovr_texture ]]
	--[[@field metalnessTexture lovr_texture ]]
	--[[@field roughnessTexture lovr_texture ]]
	--[[@field clearcoatTexture lovr_texture ]]
	--[[@field occlusionTexture lovr_texture ]]
	--[[@field normalTexture lovr_texture ]]

	--[[https://lovr.org/docs/lovr.graphics.newMesh  ]]
	--[[Create a new Mesh.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newBuffer`](lua://lovr.graphics.newBuffer)]]
	--[[* [`lovr.graphics.newModel`](lua://lovr.graphics.newModel)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param count number]]
	--[[@param storage? lovr_mesh_storage default=`'cpu'`]]
	--[[@return lovr_mesh mesh]]
	--[[@overload fun(vertices: table<string,string|number>, storage?: lovr_mesh_storage): lovr_mesh]]
	--[[@overload fun(blob: lovr_blob, storage?: lovr_mesh_storage): lovr_mesh]]
	--[[@overload fun(format: table<string,string|number>, count: number, storage?: lovr_mesh_storage): lovr_mesh]]
	--[[@overload fun(format: table<string,string|number>, vertices: table<string,string|number>, storage?: lovr_mesh_storage): lovr_mesh]]
	--[[@overload fun(format: table<string,string|number>, blob: lovr_blob, storage?: lovr_mesh_storage): lovr_mesh]]
	--[[@overload fun(buffer: lovr_buffer): lovr_mesh]]
	function lovr.graphics.newMesh(count, storage) return Mesh_class end

	--[[https://lovr.org/docs/lovr.graphics.newModel  ]]
	--[[Create a new Model.  ]]
	--[[### See also]]
	--[[* [`lovr.data.newModelData`](lua://lovr.data.newModelData)]]
	--[[* [`Pass:draw`](lua://lovr_pass.draw)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param filename string]]
	--[[@param options? lovr_graphics_new_model_options]]
	--[[@return lovr_model model]]
	--[[@overload fun(blob: lovr_blob, options?: lovr_graphics_new_model_options): lovr_model]]
	--[[@overload fun(modelData: lovr_model_data, options?: lovr_graphics_new_model_options): lovr_model]]
	function lovr.graphics.newModel(filename, options) return Model_class end

	--[[https://lovr.org/docs/lovr.graphics.newModel  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newModel`](lua://lovr.graphics.newModel)  ]]
	--[[@class lovr_graphics_new_model_options]]
	--[[@field mipmaps? boolean default=`true`]]
	--[[@field materials? boolean default=`true`]]

	--[[https://lovr.org/docs/lovr.graphics.newPass  ]]
	--[[Create a new Pass.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.submit`](lua://lovr.graphics.submit)]]
	--[[* [`lovr.graphics.getWindowPass`](lua://lovr.graphics.getWindowPass)]]
	--[[* [`lovr.headset.getPass`](lua://lovr.headset.getPass)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param ... lovr_texture]]
	--[[@return lovr_pass pass]]
	--[[@overload fun(canvas: lovr_graphics_new_pass_canvas): lovr_pass]]
	--[[@overload fun(): lovr_pass]]
	function lovr.graphics.newPass(...) return Pass_class end

	--[[https://lovr.org/docs/lovr.graphics.newPass  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newPass`](lua://lovr.graphics.newPass)  ]]
	--[[@class lovr_graphics_new_pass_canvas]]
	--[[@field depth lovr_graphics_new_pass_canvas_depth ]]
	--[[@field samples? number default=`4`]]

	--[[https://lovr.org/docs/lovr.graphics.newPass  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newPass`](lua://lovr.graphics.newPass)  ]]
	--[[@class lovr_graphics_new_pass_canvas_depth]]
	--[[@field format? lovr_texture_format default=`'d32f'`]]
	--[[@field texture lovr_texture ]]

	--[[https://lovr.org/docs/lovr.graphics.newSampler  ]]
	--[[Create a new Sampler.  ]]
	--[[### See also]]
	--[[* [`Pass:setSampler`](lua://lovr_pass.setSampler)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param parameters lovr_graphics_new_sampler_parameters]]
	--[[@return lovr_sampler sampler]]
	function lovr.graphics.newSampler(parameters) return Sampler_class end

	--[[https://lovr.org/docs/lovr.graphics.newSampler  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newSampler`](lua://lovr.graphics.newSampler)  ]]
	--[[@class lovr_graphics_new_sampler_parameters]]
	--[[@field filter? lovr_graphics_new_sampler_parameters_filter default=`'linear'`]]
	--[[@field wrap? lovr_graphics_new_sampler_parameters_wrap default=`'repeat'`]]
	--[[@field compare? lovr_compare_mode default=`'none'`]]
	--[[@field anisotropy? number default=`1`]]
	--[[@field mipmaprange table<string,string|number> ]]

	--[[https://lovr.org/docs/lovr.graphics.newSampler  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newSampler`](lua://lovr.graphics.newSampler)  ]]
	--[[@class lovr_graphics_new_sampler_parameters_filter]]
	--[[@field [1] lovr_filter_mode ]]
	--[[@field [2] lovr_filter_mode ]]
	--[[@field [3] lovr_filter_mode ]]

	--[[https://lovr.org/docs/lovr.graphics.newSampler  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newSampler`](lua://lovr.graphics.newSampler)  ]]
	--[[@class lovr_graphics_new_sampler_parameters_wrap]]
	--[[@field [1] lovr_wrap_mode ]]
	--[[@field [2] lovr_wrap_mode ]]
	--[[@field [3] lovr_wrap_mode ]]

	--[[https://lovr.org/docs/lovr.graphics.newShader  ]]
	--[[Create a new Shader.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.compileShader`](lua://lovr.graphics.compileShader)]]
	--[[* [`ShaderType`](lua://lovr_shaderType)]]
	--[[* [`ShaderStage`](lua://lovr_shaderStage)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param vertex string]]
	--[[@param fragment string]]
	--[[@param options? lovr_graphics_new_shader_options]]
	--[[@return lovr_shader shader]]
	--[[@overload fun(compute: string, options?: lovr_graphics_new_shader_options): lovr_shader]]
	--[[@overload fun(default: lovr_default_shader, options?: lovr_graphics_new_shader_options): lovr_shader]]
	function lovr.graphics.newShader(vertex, fragment, options) return Shader_class end

	--[[https://lovr.org/docs/lovr.graphics.newShader  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newShader`](lua://lovr.graphics.newShader)  ]]
	--[[@class lovr_graphics_new_shader_options]]
	--[[@field flags table<string,string|number> ]]
	--[[@field label string ]]

	--[[https://lovr.org/docs/lovr.graphics.newTexture  ]]
	--[[Create a new Texture.  ]]
	--[[### See also]]
	--[[* [`Texture:newView`](lua://lovr_texture.newView)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param filename string]]
	--[[@param options? lovr_graphics_new_texture_options]]
	--[[@return lovr_texture texture]]
	--[[@overload fun(width: number, height: number, options?: lovr_graphics_new_texture_options): lovr_texture]]
	--[[@overload fun(width: number, height: number, layers: number, options?: lovr_graphics_new_texture_options): lovr_texture]]
	--[[@overload fun(image: string, options?: lovr_graphics_new_texture_options): lovr_texture]]
	--[[@overload fun(images: table<string,string|number>, options?: lovr_graphics_new_texture_options): lovr_texture]]
	--[[@overload fun(blob: lovr_blob, options?: lovr_graphics_new_texture_options): lovr_texture]]
	function lovr.graphics.newTexture(filename, options) return Texture_class end

	--[[https://lovr.org/docs/lovr.graphics.newTexture  ]]
	--[[see also:  ]]
	--[[[`lovr.graphics.newTexture`](lua://lovr.graphics.newTexture)  ]]
	--[[@class lovr_graphics_new_texture_options]]
	--[[@field type lovr_texture_type ]]
	--[[@field format? lovr_texture_format default=`'rgba8'`]]
	--[[@field linear? boolean default=`false`]]
	--[[@field samples? number default=`1`]]
	--[[@field mipmaps? unknown default=`true`]]
	--[[@field usage table<string,string|number> ]]
	--[[@field label string ]]

	--[[https://lovr.org/docs/OriginType  ]]
	--[[Different coordinate spaces for nodes in a Model.  ]]
	--[[### See also]]
	--[[* [`Model:getNodePosition`](lua://lovr_model.getNodePosition)]]
	--[[* [`Model:getNodeOrientation`](lua://lovr_model.getNodeOrientation)]]
	--[[* [`Model:getNodeScale`](lua://lovr_model.getNodeScale)]]
	--[[* [`Model:getNodePose`](lua://lovr_model.getNodePose)]]
	--[[* [`Model:getNodeTransform`](lua://lovr_model.getNodeTransform)]]
	--[[* [`Model:getRootNode`](lua://lovr_model.getRootNode)]]
	--[[* [`Model:getNodeParent`](lua://lovr_model.getNodeParent)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_origin_type]]
	local lovr_origin_type = {
		--[[Transforms are relative to the origin (root) of the Model.  ]]
		root = "root",
		--[[Transforms are relative to the parent of the node.  ]]
		parent = "parent",
	}

	--[[https://lovr.org/docs/Pass  ]]
	--[[A stream of graphics commands.  ]]
	--[[@class lovr_pass: lovr_object]]

	--[[https://lovr.org/docs/Pass:barrier  ]]
	--[[Synchronize compute work.  ]]
	--[[### See also]]
	--[[* [`Pass:compute`](lua://lovr_pass.compute)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	function Pass_class:barrier() end

	--[[https://lovr.org/docs/Pass:beginTally  ]]
	--[[Begin a tally.  ]]
	--[[### See also]]
	--[[* [`Pass:finishTally`](lua://lovr_pass.finishTally)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return number index]]
	function Pass_class:beginTally() return 0 end

	--[[https://lovr.org/docs/Pass:box  ]]
	--[[Draw a box.  ]]
	--[[### See also]]
	--[[* [`Pass:cube`](lua://lovr_pass.cube)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param width? number default=`1`]]
	--[[@param height? number default=`1`]]
	--[[@param depth? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param style? lovr_draw_style default=`'fill'`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, size: lovr_vec3, orientation: lovr_quat, style?: lovr_draw_style)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, style?: lovr_draw_style)]]
	function Pass_class:box(x, y, z, width, height, depth, angle, ax, ay, az, style) end

	--[[https://lovr.org/docs/Pass:capsule  ]]
	--[[Draw a capsule.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param radius? number default=`1.0`]]
	--[[@param length? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param segments? number default=`32`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, scale: lovr_vec3, orientation: lovr_quat, segments?: number)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, segments?: number)]]
	--[[@overload fun(self: lovr_pass, p1: lovr_vec3, p2: lovr_vec3, radius?: number, segments?: number)]]
	function Pass_class:capsule(x, y, z, radius, length, angle, ax, ay, az, segments) end

	--[[https://lovr.org/docs/Pass:circle  ]]
	--[[Draw a circle.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param radius? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param style? lovr_draw_style default=`'fill'`]]
	--[[@param angle1? number default=`0`]]
	--[[@param angle2? number default=`2 * math.pi`]]
	--[[@param segments? number default=`64`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, radius?: number, orientation: lovr_quat, style?: lovr_draw_style, angle1?: number, angle2?: number, segments?: number)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, style?: lovr_draw_style, angle1?: number, angle2?: number, segments?: number)]]
	function Pass_class:circle(x, y, z, radius, angle, ax, ay, az, style, angle1, angle2, segments) end

	--[[https://lovr.org/docs/Pass:compute  ]]
	--[[Run a compute shader.  ]]
	--[[### See also]]
	--[[* [`Pass:barrier`](lua://lovr_pass.barrier)]]
	--[[* [`Pass:setShader`](lua://lovr_pass.setShader)]]
	--[[* [`Pass:send`](lua://lovr_pass.send)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`1`]]
	--[[@param y? number default=`1`]]
	--[[@param z? number default=`1`]]
	--[[@overload fun(self: lovr_pass, buffer: lovr_buffer, offset?: number)]]
	function Pass_class:compute(x, y, z) end

	--[[https://lovr.org/docs/Pass:cone  ]]
	--[[Draw a cone.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param radius? number default=`1`]]
	--[[@param length? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param segments? number default=`64`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, scale: lovr_vec3, orientation: lovr_quat, segments?: number)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, segments?: number)]]
	--[[@overload fun(self: lovr_pass, p1: lovr_vec3, p2: lovr_vec3, radius?: number, segments?: number)]]
	function Pass_class:cone(x, y, z, radius, length, angle, ax, ay, az, segments) end

	--[[https://lovr.org/docs/Pass:cube  ]]
	--[[Draw a cube.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param size? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param style? lovr_draw_style default=`'fill'`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, size?: number, orientation: lovr_quat, style?: lovr_draw_style)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, style?: lovr_draw_style)]]
	function Pass_class:cube(x, y, z, size, angle, ax, ay, az, style) end

	--[[https://lovr.org/docs/Pass:cylinder  ]]
	--[[Draw a cylinder.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param radius? number default=`1`]]
	--[[@param length? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param capped? boolean default=`true`]]
	--[[@param angle1? number default=`0`]]
	--[[@param angle2? number default=`2 * math.pi`]]
	--[[@param segments? number default=`64`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, scale: lovr_vec3, orientation: lovr_quat, capped?: boolean, angle1?: number, angle2?: number, segments?: number)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, capped?: boolean, angle1?: number, angle2?: number, segments?: number)]]
	--[[@overload fun(self: lovr_pass, p1: lovr_vec3, p2: lovr_vec3, radius?: number, capped?: boolean, angle1?: number, angle2?: number, segments?: number)]]
	function Pass_class:cylinder(x, y, z, radius, length, angle, ax, ay, az, capped, angle1, angle2, segments) end

	--[[https://lovr.org/docs/Pass:draw  ]]
	--[[Draw a Model, Mesh, or Texture.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param object unknown]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param scale? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param instances? number default=`1`]]
	--[[@overload fun(self: lovr_pass, object: unknown, position: lovr_vec3, scale?: number, orientation: lovr_quat, instances?: number)]]
	--[[@overload fun(self: lovr_pass, object: unknown, transform: lovr_mat4, instances?: number)]]
	function Pass_class:draw(object, x, y, z, scale, angle, ax, ay, az, instances) end

	--[[https://lovr.org/docs/Pass:fill  ]]
	--[[Draw a fullscreen triangle.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param texture lovr_texture]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:fill(texture) end

	--[[https://lovr.org/docs/Pass:finishTally  ]]
	--[[Finish a tally.  ]]
	--[[### See also]]
	--[[* [`Pass:beginTally`](lua://lovr_pass.beginTally)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return number index]]
	function Pass_class:finishTally() return 0 end

	--[[https://lovr.org/docs/Pass:getCanvas  ]]
	--[[Get the Pass's canvas.  ]]
	--[[### See also]]
	--[[* [`Pass:getClear`](lua://lovr_pass.getClear)]]
	--[[* [`Pass:setClear`](lua://lovr_pass.setClear)]]
	--[[* [`Pass:getWidth`](lua://lovr_pass.getWidth)]]
	--[[* [`Pass:getHeight`](lua://lovr_pass.getHeight)]]
	--[[* [`Pass:getDimensions`](lua://lovr_pass.getDimensions)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return lovr_graphics_pass_get_canvas_canvas canvas]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:getCanvas() return {} end

	--[[https://lovr.org/docs/Pass:getClear  ]]
	--[[Return the clear values of the Pass.  ]]
	--[[### See also]]
	--[[* [`Pass:getCanvas`](lua://lovr_pass.getCanvas)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return table<string,string|number> clears]]
	function Pass_class:getClear() return {} end

	--[[https://lovr.org/docs/Pass:getDimensions  ]]
	--[[Get the dimensions of the Pass's canvas.  ]]
	--[[### See also]]
	--[[* [`Pass:getWidth`](lua://lovr_pass.getWidth)]]
	--[[* [`Pass:getHeight`](lua://lovr_pass.getHeight)]]
	--[[* [`Pass:getViewCount`](lua://lovr_pass.getViewCount)]]
	--[[* [`Pass:getCanvas`](lua://lovr_pass.getCanvas)]]
	--[[* [`Pass:setCanvas`](lua://lovr_pass.setCanvas)]]
	--[[* [`lovr.system.getWindowDimensions`](lua://lovr.system.getWindowDimensions)]]
	--[[* [`lovr.headset.getDisplayDimensions`](lua://lovr.headset.getDisplayDimensions)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return number width]]
	--[[@return number height]]
	function Pass_class:getDimensions() return 0, 0 end

	--[[https://lovr.org/docs/Pass:getHeight  ]]
	--[[Get the height of the Pass's canvas.  ]]
	--[[### See also]]
	--[[* [`Pass:getWidth`](lua://lovr_pass.getWidth)]]
	--[[* [`Pass:getDimensions`](lua://lovr_pass.getDimensions)]]
	--[[* [`Pass:getViewCount`](lua://lovr_pass.getViewCount)]]
	--[[* [`Pass:getCanvas`](lua://lovr_pass.getCanvas)]]
	--[[* [`Pass:setCanvas`](lua://lovr_pass.setCanvas)]]
	--[[* [`lovr.system.getWindowHeight`](lua://lovr.system.getWindowHeight)]]
	--[[* [`lovr.headset.getDisplayHeight`](lua://lovr.headset.getDisplayHeight)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return number height]]
	function Pass_class:getHeight() return 0 end

	--[[https://lovr.org/docs/Pass:getProjection  ]]
	--[[Get the field of view.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getViewAngles`](lua://lovr.headset.getViewAngles)]]
	--[[* [`lovr.headset.getViewCount`](lua://lovr.headset.getViewCount)]]
	--[[* [`Pass:getViewPose`](lua://lovr_pass.getViewPose)]]
	--[[* [`Pass:setViewPose`](lua://lovr_pass.setViewPose)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param view number]]
	--[[@return number left]]
	--[[@return number right]]
	--[[@return number up]]
	--[[@return number down]]
	--[[@overload fun(self: lovr_pass, view: number, matrix: lovr_mat4): lovr_mat4]]
	function Pass_class:getProjection(view) return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Pass:getSampleCount  ]]
	--[[Get the antialiasing setting of a render pass.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return number samples]]
	--[[@deprecated]]
	function Pass_class:getSampleCount() return 0 end

	--[[https://lovr.org/docs/Pass:getScissor  ]]
	--[[Get the scissor rectangle.  ]]
	--[[### See also]]
	--[[* [`Pass:getViewport`](lua://lovr_pass.getViewport)]]
	--[[* [`Pass:setViewport`](lua://lovr_pass.setViewport)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number w]]
	--[[@return number h]]
	function Pass_class:getScissor() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Pass:getStats  ]]
	--[[Get statistics for the Pass.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.isTimingEnabled`](lua://lovr.graphics.isTimingEnabled)]]
	--[[* [`lovr.graphics.setTimingEnabled`](lua://lovr.graphics.setTimingEnabled)]]
	--[[* [`Pass:setViewCull`](lua://lovr_pass.setViewCull)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return lovr_graphics_pass_get_stats_stats stats]]
	function Pass_class:getStats() return {} end

	--[[https://lovr.org/docs/Pass:getTallyBuffer  ]]
	--[[Get the Buffer that tally results will be written to.  ]]
	--[[### See also]]
	--[[* [`Pass:beginTally`](lua://lovr_pass.beginTally)]]
	--[[* [`Pass:finishTally`](lua://lovr_pass.finishTally)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return lovr_buffer buffer]]
	--[[@return number offset]]
	function Pass_class:getTallyBuffer() return Buffer_class, 0 end

	--[[https://lovr.org/docs/Pass:getTarget  ]]
	--[[Get the textures a render pass is rendering to.  ]]
	--[[### See also]]
	--[[* [`Pass:getClear`](lua://lovr_pass.getClear)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return table<string,string|number> target]]
	--[[@deprecated]]
	function Pass_class:getTarget() return {} end

	--[[https://lovr.org/docs/Pass:getType  ]]
	--[[Get the type of the Pass.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return lovr_pass_type type]]
	--[[@deprecated]]
	function Pass_class:getType() return PassType_class end

	--[[https://lovr.org/docs/Pass:getViewCount  ]]
	--[[Returns the view count of a render pass.  ]]
	--[[### See also]]
	--[[* [`Pass:getViewPose`](lua://lovr_pass.getViewPose)]]
	--[[* [`Pass:setViewPose`](lua://lovr_pass.setViewPose)]]
	--[[* [`Pass:getProjection`](lua://lovr_pass.getProjection)]]
	--[[* [`Pass:setProjection`](lua://lovr_pass.setProjection)]]
	--[[* [`lovr.headset.getViewCount`](lua://lovr.headset.getViewCount)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return number views]]
	function Pass_class:getViewCount() return 0 end

	--[[https://lovr.org/docs/Pass:getViewport  ]]
	--[[Get the viewport.  ]]
	--[[### See also]]
	--[[* [`Pass:getScissor`](lua://lovr_pass.getScissor)]]
	--[[* [`Pass:setScissor`](lua://lovr_pass.setScissor)]]
	--[[* [`Pass:getDimensions`](lua://lovr_pass.getDimensions)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number w]]
	--[[@return number h]]
	--[[@return number dmin]]
	--[[@return number dmax]]
	function Pass_class:getViewport() return 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Pass:getViewPose  ]]
	--[[Get the camera pose.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getViewPose`](lua://lovr.headset.getViewPose)]]
	--[[* [`lovr.headset.getViewCount`](lua://lovr.headset.getViewCount)]]
	--[[* [`Pass:getProjection`](lua://lovr_pass.getProjection)]]
	--[[* [`Pass:setProjection`](lua://lovr_pass.setProjection)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param view number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	--[[@overload fun(self: lovr_pass, view: number, matrix: lovr_mat4, invert: boolean): lovr_mat4]]
	function Pass_class:getViewPose(view) return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Pass:getWidth  ]]
	--[[Get the width of the Pass's canvas.  ]]
	--[[### See also]]
	--[[* [`Pass:getHeight`](lua://lovr_pass.getHeight)]]
	--[[* [`Pass:getDimensions`](lua://lovr_pass.getDimensions)]]
	--[[* [`Pass:getViewCount`](lua://lovr_pass.getViewCount)]]
	--[[* [`Pass:getCanvas`](lua://lovr_pass.getCanvas)]]
	--[[* [`Pass:setCanvas`](lua://lovr_pass.setCanvas)]]
	--[[* [`lovr.system.getWindowWidth`](lua://lovr.system.getWindowWidth)]]
	--[[* [`lovr.headset.getDisplayWidth`](lua://lovr.headset.getDisplayWidth)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@return number width]]
	function Pass_class:getWidth() return 0 end

	--[[https://lovr.org/docs/Pass:line  ]]
	--[[Draw a line.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x1 number]]
	--[[@param y1 number]]
	--[[@param z1 number]]
	--[[@param x2 number]]
	--[[@param y2 number]]
	--[[@param z2 number]]
	--[[@param ... unknown]]
	--[[@overload fun(self: lovr_pass, t: table<string,string|number>)]]
	--[[@overload fun(self: lovr_pass, v1: lovr_vec3, v2: lovr_vec3, ...: unknown)]]
	function Pass_class:line(x1, y1, z1, x2, y2, z2, ...) end

	--[[https://lovr.org/docs/Pass:mesh  ]]
	--[[Draw a mesh.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param vertices? lovr_buffer default=`nil`]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param scale? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param start? number default=`1`]]
	--[[@param count? number default=`nil`]]
	--[[@param instances? number default=`1`]]
	--[[@overload fun(self: lovr_pass, vertices?: lovr_buffer, position: lovr_vec3, scales: lovr_vec3, orientation: lovr_quat, start?: number, count?: number, instances?: number)]]
	--[[@overload fun(self: lovr_pass, vertices?: lovr_buffer, transform: lovr_mat4, start?: number, count?: number, instances?: number)]]
	--[[@overload fun(self: lovr_pass, vertices?: lovr_buffer, indices: lovr_buffer, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number, start?: number, count?: number, instances?: number, base?: number)]]
	--[[@overload fun(self: lovr_pass, vertices?: lovr_buffer, indices: lovr_buffer, position: lovr_vec3, scales: lovr_vec3, orientation: lovr_quat, start?: number, count?: number, instances?: number, base?: number)]]
	--[[@overload fun(self: lovr_pass, vertices?: lovr_buffer, indices: lovr_buffer, transform: lovr_mat4, start?: number, count?: number, instances?: number, base?: number)]]
	--[[@overload fun(self: lovr_pass, vertices?: lovr_buffer, indices: lovr_buffer, draws: lovr_buffer, drawcount: number, offset: number, stride: number)]]
	function Pass_class:mesh(vertices, x, y, z, scale, angle, ax, ay, az, start, count, instances) end

	--[[https://lovr.org/docs/Pass:origin  ]]
	--[[Reset the transform to the origin.  ]]
	--[[### See also]]
	--[[* [`Pass:translate`](lua://lovr_pass.translate)]]
	--[[* [`Pass:rotate`](lua://lovr_pass.rotate)]]
	--[[* [`Pass:scale`](lua://lovr_pass.scale)]]
	--[[* [`Pass:transform`](lua://lovr_pass.transform)]]
	--[[* [`Pass:push`](lua://lovr_pass.push)]]
	--[[* [`Pass:pop`](lua://lovr_pass.pop)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	function Pass_class:origin() end

	--[[https://lovr.org/docs/Pass:plane  ]]
	--[[Draw a plane.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param width? number default=`1`]]
	--[[@param height? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param style? lovr_draw_style default=`'fill'`]]
	--[[@param columns? number default=`1`]]
	--[[@param rows? number default=`columns`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, size: lovr_vec2, orientation: lovr_quat, style?: lovr_draw_style, columns?: number, rows?: number)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, style?: lovr_draw_style, columns?: number, rows?: number)]]
	function Pass_class:plane(x, y, z, width, height, angle, ax, ay, az, style, columns, rows) end

	--[[https://lovr.org/docs/Pass:points  ]]
	--[[Draw points.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param ... unknown]]
	--[[@overload fun(self: lovr_pass, t: table<string,string|number>)]]
	--[[@overload fun(self: lovr_pass, v: lovr_vec3, ...: unknown)]]
	function Pass_class:points(x, y, z, ...) end

	--[[https://lovr.org/docs/Pass:pop  ]]
	--[[Pop one of the stacks.  ]]
	--[[### See also]]
	--[[* [`Pass:push`](lua://lovr_pass.push)]]
	--[[* [`StackType`](lua://lovr_stackType)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param stack? lovr_stack_type default=`'transform'`]]
	function Pass_class:pop(stack) end

	--[[https://lovr.org/docs/Pass:push  ]]
	--[[Push state onto a stack.  ]]
	--[[### See also]]
	--[[* [`Pass:pop`](lua://lovr_pass.pop)]]
	--[[* [`StackType`](lua://lovr_stackType)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param stack? lovr_stack_type default=`'transform'`]]
	function Pass_class:push(stack) end

	--[[https://lovr.org/docs/Pass:reset  ]]
	--[[Reset the Pass.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	function Pass_class:reset() end

	--[[https://lovr.org/docs/Pass:rotate  ]]
	--[[Rotate the coordinate system.  ]]
	--[[### See also]]
	--[[* [`Pass:translate`](lua://lovr_pass.translate)]]
	--[[* [`Pass:scale`](lua://lovr_pass.scale)]]
	--[[* [`Pass:transform`](lua://lovr_pass.transform)]]
	--[[* [`Pass:origin`](lua://lovr_pass.origin)]]
	--[[* [`Pass:push`](lua://lovr_pass.push)]]
	--[[* [`Pass:pop`](lua://lovr_pass.pop)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_pass, rotation: lovr_quat)]]
	function Pass_class:rotate(angle, ax, ay, az) end

	--[[https://lovr.org/docs/Pass:roundrect  ]]
	--[[Draw a rounded rectangle.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param width? number default=`1`]]
	--[[@param height? number default=`1`]]
	--[[@param thickness? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param radius? number default=`0`]]
	--[[@param segments? number default=`8`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, size: lovr_vec3, orientation: lovr_quat, radius?: number, segments?: number)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, radius?: number, segments?: number)]]
	function Pass_class:roundrect(x, y, z, width, height, thickness, angle, ax, ay, az, radius, segments) end

	--[[https://lovr.org/docs/Pass:scale  ]]
	--[[Scale the coordinate system.  ]]
	--[[### See also]]
	--[[* [`Pass:translate`](lua://lovr_pass.translate)]]
	--[[* [`Pass:rotate`](lua://lovr_pass.rotate)]]
	--[[* [`Pass:transform`](lua://lovr_pass.transform)]]
	--[[* [`Pass:origin`](lua://lovr_pass.origin)]]
	--[[* [`Pass:push`](lua://lovr_pass.push)]]
	--[[* [`Pass:pop`](lua://lovr_pass.pop)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param sx number]]
	--[[@param sy? number default=`sx`]]
	--[[@param sz? number default=`sx`]]
	--[[@overload fun(self: lovr_pass, scale: lovr_vec3)]]
	function Pass_class:scale(sx, sy, sz) end

	--[[https://lovr.org/docs/Pass:send  ]]
	--[[Set the value of a shader variable.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param name string]]
	--[[@param buffer lovr_buffer]]
	--[[@param offset? number default=`0`]]
	--[[@param extent? number default=`0`]]
	--[[@overload fun(self: lovr_pass, name: string, texture: lovr_texture)]]
	--[[@overload fun(self: lovr_pass, name: string, sampler: lovr_sampler)]]
	--[[@overload fun(self: lovr_pass, name: string, constant: unknown)]]
	--[[@overload fun(self: lovr_pass, binding: number, buffer: lovr_buffer, offset?: number, extent?: number)]]
	--[[@overload fun(self: lovr_pass, binding: number, texture: lovr_texture)]]
	--[[@overload fun(self: lovr_pass, binding: number, sampler: lovr_sampler)]]
	function Pass_class:send(name, buffer, offset, extent) end

	--[[https://lovr.org/docs/Pass:setAlphaToCoverage  ]]
	--[[Enable or disable alpha to coverage.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param enable boolean]]
	function Pass_class:setAlphaToCoverage(enable) end

	--[[https://lovr.org/docs/Pass:setBlendMode  ]]
	--[[Set the blend mode.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param blend lovr_blend_mode]]
	--[[@param alphaBlend lovr_blend_alpha_mode]]
	--[[@overload fun(self: lovr_pass)]]
	--[[@overload fun(self: lovr_pass, index: number, blend: lovr_blend_mode, alphaBlend: lovr_blend_alpha_mode)]]
	--[[@overload fun(self: lovr_pass, index: number)]]
	function Pass_class:setBlendMode(blend, alphaBlend) end

	--[[https://lovr.org/docs/Pass:setCanvas  ]]
	--[[Set the Pass's canvas.  ]]
	--[[### See also]]
	--[[* [`Pass:getClear`](lua://lovr_pass.getClear)]]
	--[[* [`Pass:setClear`](lua://lovr_pass.setClear)]]
	--[[* [`Pass:getWidth`](lua://lovr_pass.getWidth)]]
	--[[* [`Pass:getHeight`](lua://lovr_pass.getHeight)]]
	--[[* [`Pass:getDimensions`](lua://lovr_pass.getDimensions)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param ... lovr_texture]]
	--[[@overload fun(self: lovr_pass, canvas: lovr_graphics_pass_set_canvas_canvas)]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setCanvas(...) end

	--[[https://lovr.org/docs/Pass:setClear  ]]
	--[[Set the clear values of the Pass.  ]]
	--[[### See also]]
	--[[* [`Pass:setCanvas`](lua://lovr_pass.setCanvas)]]
	--[[* [`Texture:clear`](lua://lovr_texture.clear)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param hex number]]
	--[[@overload fun(self: lovr_pass, r: number, g: number, b: number, a?: number)]]
	--[[@overload fun(self: lovr_pass, clear: boolean)]]
	--[[@overload fun(self: lovr_pass, t: table<string,string|number>)]]
	function Pass_class:setClear(hex) end

	--[[https://lovr.org/docs/Pass:setColor  ]]
	--[[Set the color.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param r number]]
	--[[@param g number]]
	--[[@param b number]]
	--[[@param a? number default=`1.0`]]
	--[[@overload fun(self: lovr_pass, t: table<string,string|number>)]]
	--[[@overload fun(self: lovr_pass, hex: number, a?: number)]]
	function Pass_class:setColor(r, g, b, a) end

	--[[https://lovr.org/docs/Pass:setColorWrite  ]]
	--[[Change the color channels affected by drawing.  ]]
	--[[### See also]]
	--[[* [`Pass:setDepthWrite`](lua://lovr_pass.setDepthWrite)]]
	--[[* [`Pass:setStencilWrite`](lua://lovr_pass.setStencilWrite)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param enable boolean]]
	--[[@overload fun(self: lovr_pass, r: boolean, g: boolean, b: boolean, a: boolean)]]
	--[[@overload fun(self: lovr_pass, index: number, enable: boolean)]]
	--[[@overload fun(self: lovr_pass, index: number, r: boolean, g: boolean, b: boolean, a: boolean)]]
	function Pass_class:setColorWrite(enable) end

	--[[https://lovr.org/docs/Pass:setCullMode  ]]
	--[[Control triangle face culling.  ]]
	--[[### See also]]
	--[[* [`Pass:setViewCull`](lua://lovr_pass.setViewCull)]]
	--[[* [`Pass:setWinding`](lua://lovr_pass.setWinding)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param mode lovr_cull_mode]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setCullMode(mode) end

	--[[https://lovr.org/docs/Pass:setDepthClamp  ]]
	--[[Enable or disable depth clamp.  ]]
	--[[### See also]]
	--[[* [`Pass:setDepthTest`](lua://lovr_pass.setDepthTest)]]
	--[[* [`Pass:setDepthWrite`](lua://lovr_pass.setDepthWrite)]]
	--[[* [`Pass:setDepthOffset`](lua://lovr_pass.setDepthOffset)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param enable boolean]]
	function Pass_class:setDepthClamp(enable) end

	--[[https://lovr.org/docs/Pass:setDepthOffset  ]]
	--[[Configure the depth offset.  ]]
	--[[### See also]]
	--[[* [`Pass:setDepthTest`](lua://lovr_pass.setDepthTest)]]
	--[[* [`Pass:setDepthWrite`](lua://lovr_pass.setDepthWrite)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param offset? number default=`0.0`]]
	--[[@param sloped? number default=`0.0`]]
	function Pass_class:setDepthOffset(offset, sloped) end

	--[[https://lovr.org/docs/Pass:setDepthTest  ]]
	--[[Configure the depth test.  ]]
	--[[### See also]]
	--[[* [`Pass:setDepthWrite`](lua://lovr_pass.setDepthWrite)]]
	--[[* [`Pass:setDepthOffset`](lua://lovr_pass.setDepthOffset)]]
	--[[* [`Pass:setDepthClamp`](lua://lovr_pass.setDepthClamp)]]
	--[[* [`Pass:setStencilTest`](lua://lovr_pass.setStencilTest)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param test lovr_compare_mode]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setDepthTest(test) end

	--[[https://lovr.org/docs/Pass:setDepthWrite  ]]
	--[[Set whether draws write to the depth buffer.  ]]
	--[[### See also]]
	--[[* [`Pass:setStencilWrite`](lua://lovr_pass.setStencilWrite)]]
	--[[* [`Pass:setColorWrite`](lua://lovr_pass.setColorWrite)]]
	--[[* [`Pass:setDepthTest`](lua://lovr_pass.setDepthTest)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param write boolean]]
	function Pass_class:setDepthWrite(write) end

	--[[https://lovr.org/docs/Pass:setFont  ]]
	--[[Set the font.  ]]
	--[[### See also]]
	--[[* [`Pass:text`](lua://lovr_pass.text)]]
	--[[* [`lovr.graphics.newFont`](lua://lovr.graphics.newFont)]]
	--[[* [`lovr.graphics.getDefaultFont`](lua://lovr.graphics.getDefaultFont)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param font lovr_font]]
	function Pass_class:setFont(font) end

	--[[https://lovr.org/docs/Pass:setMaterial  ]]
	--[[Set the material.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param material lovr_material]]
	--[[@overload fun(self: lovr_pass, texture: lovr_texture)]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setMaterial(material) end

	--[[https://lovr.org/docs/Pass:setMeshMode  ]]
	--[[Change the way vertices are connected together.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param mode lovr_draw_mode]]
	function Pass_class:setMeshMode(mode) end

	--[[https://lovr.org/docs/Pass:setProjection  ]]
	--[[Set the field of view.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getViewAngles`](lua://lovr.headset.getViewAngles)]]
	--[[* [`lovr.headset.getViewCount`](lua://lovr.headset.getViewCount)]]
	--[[* [`Pass:getViewPose`](lua://lovr_pass.getViewPose)]]
	--[[* [`Pass:setViewPose`](lua://lovr_pass.setViewPose)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param view number]]
	--[[@param left number]]
	--[[@param right number]]
	--[[@param up number]]
	--[[@param down number]]
	--[[@param near? number default=`.01`]]
	--[[@param far? number default=`0.0`]]
	--[[@overload fun(self: lovr_pass, view: number, matrix: lovr_mat4)]]
	function Pass_class:setProjection(view, left, right, up, down, near, far) end

	--[[https://lovr.org/docs/Pass:setSampler  ]]
	--[[Set the sampler.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param filter? lovr_filter_mode default=`'linear'`]]
	--[[@overload fun(self: lovr_pass, sampler: lovr_sampler)]]
	function Pass_class:setSampler(filter) end

	--[[https://lovr.org/docs/Pass:setScissor  ]]
	--[[Set the scissor rectangle.  ]]
	--[[### See also]]
	--[[* [`Pass:getViewport`](lua://lovr_pass.getViewport)]]
	--[[* [`Pass:setViewport`](lua://lovr_pass.setViewport)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param w number]]
	--[[@param h number]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setScissor(x, y, w, h) end

	--[[https://lovr.org/docs/Pass:setShader  ]]
	--[[Set the active Shader.  ]]
	--[[### See also]]
	--[[* [`Pass:send`](lua://lovr_pass.send)]]
	--[[* [`Pass:compute`](lua://lovr_pass.compute)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param shader lovr_shader]]
	--[[@overload fun(self: lovr_pass, default: lovr_default_shader)]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setShader(shader) end

	--[[https://lovr.org/docs/Pass:setStencilTest  ]]
	--[[Configure the stencil test.  ]]
	--[[### See also]]
	--[[* [`Pass:setStencilWrite`](lua://lovr_pass.setStencilWrite)]]
	--[[* [`Pass:setDepthTest`](lua://lovr_pass.setDepthTest)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param test lovr_compare_mode]]
	--[[@param value number]]
	--[[@param mask? number default=`0xff`]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setStencilTest(test, value, mask) end

	--[[https://lovr.org/docs/Pass:setStencilWrite  ]]
	--[[Set whether draws write to the stencil buffer.  ]]
	--[[### See also]]
	--[[* [`Pass:setStencilTest`](lua://lovr_pass.setStencilTest)]]
	--[[* [`Pass:setDepthTest`](lua://lovr_pass.setDepthTest)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param action lovr_stencil_action]]
	--[[@param value? number default=`1`]]
	--[[@param mask? number default=`0xff`]]
	--[[@overload fun(self: lovr_pass, actions: table<string,string|number>, value?: number, mask?: number)]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setStencilWrite(action, value, mask) end

	--[[https://lovr.org/docs/Pass:setTallyBuffer  ]]
	--[[Set the Buffer that tally results will be written to.  ]]
	--[[### See also]]
	--[[* [`Pass:beginTally`](lua://lovr_pass.beginTally)]]
	--[[* [`Pass:finishTally`](lua://lovr_pass.finishTally)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param buffer lovr_buffer]]
	--[[@param offset number]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setTallyBuffer(buffer, offset) end

	--[[https://lovr.org/docs/Pass:setViewCull  ]]
	--[[Enable or disable view frustum culling.  ]]
	--[[### See also]]
	--[[* [`Pass:setCullMode`](lua://lovr_pass.setCullMode)]]
	--[[* [`Mesh:computeBoundingBox`](lua://lovr_mesh.computeBoundingBox)]]
	--[[* [`Mesh:setBoundingBox`](lua://lovr_mesh.setBoundingBox)]]
	--[[* [`Pass:setViewPose`](lua://lovr_pass.setViewPose)]]
	--[[* [`Pass:setProjection`](lua://lovr_pass.setProjection)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param enable boolean]]
	function Pass_class:setViewCull(enable) end

	--[[https://lovr.org/docs/Pass:setViewport  ]]
	--[[Set the viewport.  ]]
	--[[### See also]]
	--[[* [`Pass:getScissor`](lua://lovr_pass.getScissor)]]
	--[[* [`Pass:setScissor`](lua://lovr_pass.setScissor)]]
	--[[* [`Pass:getDimensions`](lua://lovr_pass.getDimensions)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param w number]]
	--[[@param h number]]
	--[[@param dmin? number default=`0.0`]]
	--[[@param dmax? number default=`1.0`]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:setViewport(x, y, w, h, dmin, dmax) end

	--[[https://lovr.org/docs/Pass:setViewPose  ]]
	--[[Set the camera pose.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getViewPose`](lua://lovr.headset.getViewPose)]]
	--[[* [`lovr.headset.getViewCount`](lua://lovr.headset.getViewCount)]]
	--[[* [`Pass:getProjection`](lua://lovr_pass.getProjection)]]
	--[[* [`Pass:setProjection`](lua://lovr_pass.setProjection)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param view number]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_pass, view: number, position: lovr_vec3, orientation: lovr_quat)]]
	--[[@overload fun(self: lovr_pass, view: number, matrix: lovr_mat4, inverted: boolean)]]
	function Pass_class:setViewPose(view, x, y, z, angle, ax, ay, az) end

	--[[https://lovr.org/docs/Pass:setWinding  ]]
	--[[Set the winding direction of triangle vertices.  ]]
	--[[### See also]]
	--[[* [`Pass:setCullMode`](lua://lovr_pass.setCullMode)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param winding lovr_winding]]
	function Pass_class:setWinding(winding) end

	--[[https://lovr.org/docs/Pass:setWireframe  ]]
	--[[Enable or disable wireframe rendering.  ]]
	--[[### See also]]
	--[[* [`Pass:setMeshMode`](lua://lovr_pass.setMeshMode)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param enable boolean]]
	function Pass_class:setWireframe(enable) end

	--[[https://lovr.org/docs/Pass:skybox  ]]
	--[[Draw a skybox.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param skybox lovr_texture]]
	--[[@overload fun(self: lovr_pass)]]
	function Pass_class:skybox(skybox) end

	--[[https://lovr.org/docs/Pass:sphere  ]]
	--[[Draw a sphere.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param radius? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param longitudes? number default=`48`]]
	--[[@param latitudes? number default=`longitudes / 2`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, radius?: number, orientation: lovr_quat, longitudes?: number, latitudes?: number)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, longitudes?: number, latitudes?: number)]]
	function Pass_class:sphere(x, y, z, radius, angle, ax, ay, az, longitudes, latitudes) end

	--[[https://lovr.org/docs/Pass:text  ]]
	--[[Draw text.  ]]
	--[[### See also]]
	--[[* [`Pass:setFont`](lua://lovr_pass.setFont)]]
	--[[* [`lovr.graphics.getDefaultFont`](lua://lovr.graphics.getDefaultFont)]]
	--[[* [`Pass:setShader`](lua://lovr_pass.setShader)]]
	--[[* [`Font:getWidth`](lua://lovr_font.getWidth)]]
	--[[* [`Font:getHeight`](lua://lovr_font.getHeight)]]
	--[[* [`Font:getLines`](lua://lovr_font.getLines)]]
	--[[* [`Font:getVertices`](lua://lovr_font.getVertices)]]
	--[[* [`Font`](lua://lovr_font)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param text string]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param scale? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param wrap? number default=`0`]]
	--[[@param halign? lovr_horizontal_align default=`'center'`]]
	--[[@param valign? lovr_vertical_align default=`'middle'`]]
	--[[@overload fun(self: lovr_pass, text: string, position: lovr_vec3, scale?: number, orientation: lovr_quat, wrap?: number, halign?: lovr_horizontal_align, valign?: lovr_vertical_align)]]
	--[[@overload fun(self: lovr_pass, text: string, transform: lovr_mat4, wrap?: number, halign?: lovr_horizontal_align, valign?: lovr_vertical_align)]]
	--[[@overload fun(self: lovr_pass, colortext: table<string,string|number>, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number, wrap?: number, halign?: lovr_horizontal_align, valign?: lovr_vertical_align)]]
	--[[@overload fun(self: lovr_pass, colortext: table<string,string|number>, position: lovr_vec3, scale?: number, orientation: lovr_quat, wrap?: number, halign?: lovr_horizontal_align, valign?: lovr_vertical_align)]]
	--[[@overload fun(self: lovr_pass, colortext: table<string,string|number>, transform: lovr_mat4, wrap?: number, halign?: lovr_horizontal_align, valign?: lovr_vertical_align)]]
	function Pass_class:text(text, x, y, z, scale, angle, ax, ay, az, wrap, halign, valign) end

	--[[https://lovr.org/docs/Pass:torus  ]]
	--[[Draw a donut.  ]]
	--[[### See also]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param radius? number default=`1`]]
	--[[@param thickness? number default=`1`]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`1`]]
	--[[@param az? number default=`0`]]
	--[[@param tsegments? number default=`64`]]
	--[[@param psegments? number default=`32`]]
	--[[@overload fun(self: lovr_pass, position: lovr_vec3, scale: lovr_vec3, orientation: lovr_quat, tsegments?: number, psegments?: number)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4, tsegments?: number, psegments?: number)]]
	function Pass_class:torus(x, y, z, radius, thickness, angle, ax, ay, az, tsegments, psegments) end

	--[[https://lovr.org/docs/Pass:transform  ]]
	--[[Apply a general transform to the coordinate system.  ]]
	--[[### See also]]
	--[[* [`Pass:translate`](lua://lovr_pass.translate)]]
	--[[* [`Pass:rotate`](lua://lovr_pass.rotate)]]
	--[[* [`Pass:scale`](lua://lovr_pass.scale)]]
	--[[* [`Pass:origin`](lua://lovr_pass.origin)]]
	--[[* [`Pass:push`](lua://lovr_pass.push)]]
	--[[* [`Pass:pop`](lua://lovr_pass.pop)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param sx number]]
	--[[@param sy number]]
	--[[@param sz number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_pass, translation: lovr_vec3, scale: lovr_vec3, rotation: lovr_quat)]]
	--[[@overload fun(self: lovr_pass, transform: lovr_mat4)]]
	function Pass_class:transform(x, y, z, sx, sy, sz, angle, ax, ay, az) end

	--[[https://lovr.org/docs/Pass:translate  ]]
	--[[Translate the coordinate system.  ]]
	--[[### See also]]
	--[[* [`Pass:rotate`](lua://lovr_pass.rotate)]]
	--[[* [`Pass:scale`](lua://lovr_pass.scale)]]
	--[[* [`Pass:transform`](lua://lovr_pass.transform)]]
	--[[* [`Pass:origin`](lua://lovr_pass.origin)]]
	--[[* [`Pass:push`](lua://lovr_pass.push)]]
	--[[* [`Pass:pop`](lua://lovr_pass.pop)]]
	--[[* [`Pass`](lua://lovr_pass)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(self: lovr_pass, translation: lovr_vec3)]]
	function Pass_class:translate(x, y, z) end

	--[[https://lovr.org/docs/PassType  ]]
	--[[Different types of Passes.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.getPass`](lua://lovr.graphics.getPass)]]
	--[[* [`lovr.graphics.submit`](lua://lovr.graphics.submit)]]
	--[[* [`Pass:getType`](lua://lovr_pass.getType)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_pass_type]]
	local lovr_pass_type = {
		--[[A render pass renders graphics to a set of up to four color textures and an optional depth texture.  The textures all need to have the same dimensions and sample counts.  The textures can have multiple layers, and all rendering work will be broadcast to each layer.  Each layer can use a different camera pose, which is used for stereo rendering.  ]]
		render = "render",
		--[[A compute pass runs compute shaders.  Compute passes usually only call `Pass:setShader`, `Pass:send`, and `Pass:compute`.  All of the compute work in a single compute pass is run in parallel, so multiple compute passes should be used if one compute pass needs to happen after a different one.  ]]
		compute = "compute",
		--[[A transfer pass copies data to and from GPU memory in `Buffer` and `Texture` objects. Transfer passes use `Pass:copy`, `Pass:clear`, `Pass:blit`, `Pass:mipmap`, and `Pass:read`. Similar to compute passes, all the work in a transfer pass happens in parallel, so multiple passes should be used if the transfers need to be ordered.  ]]
		transfer = "transfer",
	}

	--[[https://lovr.org/docs/Pass:getCanvas  ]]
	--[[see also:  ]]
	--[[[`Pass:getCanvas`](lua://Pass:getCanvas)  ]]
	--[[@class lovr_graphics_pass_get_canvas_canvas]]
	--[[@field depth unknown ]]
	--[[@field samples number ]]

	--[[https://lovr.org/docs/Pass:getStats  ]]
	--[[see also:  ]]
	--[[[`Pass:getStats`](lua://Pass:getStats)  ]]
	--[[@class lovr_graphics_pass_get_stats_stats]]
	--[[@field draws number ]]
	--[[@field computes number ]]
	--[[@field drawsCulled number ]]
	--[[@field cpuMemoryReserved number ]]
	--[[@field cpuMemoryUsed number ]]
	--[[@field submitTime number ]]
	--[[@field gpuTime number ]]

	--[[https://lovr.org/docs/Pass:setCanvas  ]]
	--[[see also:  ]]
	--[[[`Pass:setCanvas`](lua://Pass:setCanvas)  ]]
	--[[@class lovr_graphics_pass_set_canvas_canvas]]
	--[[@field depth? unknown default=`d32f`]]
	--[[@field samples? number default=`4`]]

	--[[https://lovr.org/docs/lovr.graphics.present  ]]
	--[[Update the desktop window contents.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.submit`](lua://lovr.graphics.submit)]]
	--[[* [`lovr.graphics.getWindowPass`](lua://lovr.graphics.getWindowPass)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	function lovr.graphics.present() end

	--[[https://lovr.org/docs/Readback  ]]
	--[[An asynchronous read of a GPU resource.  ]]
	--[[@class lovr_readback: lovr_object]]

	--[[https://lovr.org/docs/Readback:getBlob  ]]
	--[[Get Readback's data as a Blob.  ]]
	--[[### See also]]
	--[[* [`Readback:getData`](lua://lovr_readback.getData)]]
	--[[* [`Readback:getImage`](lua://lovr_readback.getImage)]]
	--[[* [`Readback`](lua://lovr_readback)]]
	--[[@return lovr_blob blob]]
	function Readback_class:getBlob() return Blob_class end

	--[[https://lovr.org/docs/Readback:getData  ]]
	--[[Get Readback's data as a table.  ]]
	--[[### See also]]
	--[[* [`Readback:getBlob`](lua://lovr_readback.getBlob)]]
	--[[* [`Readback:getImage`](lua://lovr_readback.getImage)]]
	--[[* [`Readback`](lua://lovr_readback)]]
	--[[@return table<string,string|number> data]]
	function Readback_class:getData() return {} end

	--[[https://lovr.org/docs/Readback:getImage  ]]
	--[[Get Readback's data as an Image.  ]]
	--[[### See also]]
	--[[* [`Readback:getData`](lua://lovr_readback.getData)]]
	--[[* [`Readback:getBlob`](lua://lovr_readback.getBlob)]]
	--[[* [`Readback`](lua://lovr_readback)]]
	--[[@return lovr_image image]]
	function Readback_class:getImage() return Image_class end

	--[[https://lovr.org/docs/Readback:isComplete  ]]
	--[[Check if a Readback is complete.  ]]
	--[[### See also]]
	--[[* [`Readback`](lua://lovr_readback)]]
	--[[@return boolean complete]]
	function Readback_class:isComplete() return false end

	--[[https://lovr.org/docs/Readback:wait  ]]
	--[[Wait for the Readback to finish.  ]]
	--[[### See also]]
	--[[* [`Readback`](lua://lovr_readback)]]
	--[[@return boolean waited]]
	function Readback_class:wait() return false end

	--[[https://lovr.org/docs/Sampler  ]]
	--[[An object that controls how texture pixels are read.  ]]
	--[[@class lovr_sampler: lovr_object]]

	--[[https://lovr.org/docs/Sampler:getAnisotropy  ]]
	--[[Get the anisotropy level of the Sampler.  ]]
	--[[### See also]]
	--[[* [`Sampler:getFilter`](lua://lovr_sampler.getFilter)]]
	--[[* [`Sampler:getWrap`](lua://lovr_sampler.getWrap)]]
	--[[* [`Sampler:getCompareMode`](lua://lovr_sampler.getCompareMode)]]
	--[[* [`Sampler:getMipmapRange`](lua://lovr_sampler.getMipmapRange)]]
	--[[* [`Sampler`](lua://lovr_sampler)]]
	--[[@return number anisotropy]]
	function Sampler_class:getAnisotropy() return 0 end

	--[[https://lovr.org/docs/Sampler:getCompareMode  ]]
	--[[Get the compare mode of the Sampler.  ]]
	--[[### See also]]
	--[[* [`Sampler:getFilter`](lua://lovr_sampler.getFilter)]]
	--[[* [`Sampler:getWrap`](lua://lovr_sampler.getWrap)]]
	--[[* [`Sampler:getAnisotropy`](lua://lovr_sampler.getAnisotropy)]]
	--[[* [`Sampler:getMipmapRange`](lua://lovr_sampler.getMipmapRange)]]
	--[[* [`Sampler`](lua://lovr_sampler)]]
	--[[@return lovr_compare_mode compare]]
	function Sampler_class:getCompareMode() return CompareMode_class end

	--[[https://lovr.org/docs/Sampler:getFilter  ]]
	--[[Get the filter mode of the Sampler.  ]]
	--[[### See also]]
	--[[* [`Sampler:getWrap`](lua://lovr_sampler.getWrap)]]
	--[[* [`Sampler:getCompareMode`](lua://lovr_sampler.getCompareMode)]]
	--[[* [`Sampler:getAnisotropy`](lua://lovr_sampler.getAnisotropy)]]
	--[[* [`Sampler:getMipmapRange`](lua://lovr_sampler.getMipmapRange)]]
	--[[* [`Sampler`](lua://lovr_sampler)]]
	--[[@return lovr_filter_mode min]]
	--[[@return lovr_filter_mode mag]]
	--[[@return lovr_filter_mode mip]]
	function Sampler_class:getFilter() return FilterMode_class, FilterMode_class, FilterMode_class end

	--[[https://lovr.org/docs/Sampler:getMipmapRange  ]]
	--[[Get the mipmap range of the Sampler.  ]]
	--[[### See also]]
	--[[* [`Sampler:getFilter`](lua://lovr_sampler.getFilter)]]
	--[[* [`Sampler:getWrap`](lua://lovr_sampler.getWrap)]]
	--[[* [`Sampler:getCompareMode`](lua://lovr_sampler.getCompareMode)]]
	--[[* [`Sampler:getAnisotropy`](lua://lovr_sampler.getAnisotropy)]]
	--[[* [`Sampler`](lua://lovr_sampler)]]
	--[[@return number min]]
	--[[@return number max]]
	function Sampler_class:getMipmapRange() return 0, 0 end

	--[[https://lovr.org/docs/Sampler:getWrap  ]]
	--[[Get the wrap mode of the Sampler.  ]]
	--[[### See also]]
	--[[* [`Sampler:getFilter`](lua://lovr_sampler.getFilter)]]
	--[[* [`Sampler:getCompareMode`](lua://lovr_sampler.getCompareMode)]]
	--[[* [`Sampler:getAnisotropy`](lua://lovr_sampler.getAnisotropy)]]
	--[[* [`Sampler:getMipmapRange`](lua://lovr_sampler.getMipmapRange)]]
	--[[* [`Sampler`](lua://lovr_sampler)]]
	--[[@return lovr_wrap_mode x]]
	--[[@return lovr_wrap_mode y]]
	--[[@return lovr_wrap_mode z]]
	function Sampler_class:getWrap() return WrapMode_class, WrapMode_class, WrapMode_class end

	--[[https://lovr.org/docs/lovr.graphics.setBackgroundColor  ]]
	--[[Set the background color.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newPass`](lua://lovr.graphics.newPass)]]
	--[[* [`Pass:setClear`](lua://lovr_pass.setClear)]]
	--[[* [`Texture:clear`](lua://lovr_texture.clear)]]
	--[[* [`Pass:fill`](lua://lovr_pass.fill)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param r number]]
	--[[@param g number]]
	--[[@param b number]]
	--[[@param a? number default=`1.0`]]
	--[[@overload fun(hex: number, a?: number)]]
	--[[@overload fun(table: table<string,string|number>)]]
	function lovr.graphics.setBackgroundColor(r, g, b, a) end

	--[[https://lovr.org/docs/lovr.graphics.setTimingEnabled  ]]
	--[[Enable or disable timing stats.  ]]
	--[[### See also]]
	--[[* [`Pass:getStats`](lua://lovr_pass.getStats)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param enable boolean]]
	function lovr.graphics.setTimingEnabled(enable) end

	--[[https://lovr.org/docs/Shader  ]]
	--[[GPU program.  ]]
	--[[@class lovr_shader: lovr_object]]

	--[[https://lovr.org/docs/Shader:clone  ]]
	--[[Clone a Shader.  ]]
	--[[### See also]]
	--[[* [`Shader`](lua://lovr_shader)]]
	--[[@param source lovr_shader]]
	--[[@param flags table<string,string|number>]]
	--[[@return lovr_shader shader]]
	function Shader_class:clone(source, flags) return Shader_class end

	--[[https://lovr.org/docs/Shader:getBufferFormat  ]]
	--[[Get the format of a buffer in the Shader.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newBuffer`](lua://lovr.graphics.newBuffer)]]
	--[[* [`Buffer:getFormat`](lua://lovr_buffer.getFormat)]]
	--[[* [`Shader`](lua://lovr_shader)]]
	--[[@param name string]]
	--[[@return table<string,string|number> format]]
	--[[@return number length]]
	function Shader_class:getBufferFormat(name) return {}, 0 end

	--[[https://lovr.org/docs/Shader:getType  ]]
	--[[Get the type of the Shader.  ]]
	--[[### See also]]
	--[[* [`Shader:hasStage`](lua://lovr_shader.hasStage)]]
	--[[* [`lovr.graphics.newShader`](lua://lovr.graphics.newShader)]]
	--[[* [`Shader`](lua://lovr_shader)]]
	--[[@return lovr_shader_type type]]
	function Shader_class:getType() return ShaderType_class end

	--[[https://lovr.org/docs/Shader:getWorkgroupSize  ]]
	--[[Get the workgroup size of a compute shader.  ]]
	--[[### See also]]
	--[[* [`Shader`](lua://lovr_shader)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Shader_class:getWorkgroupSize() return 0, 0, 0 end

	--[[https://lovr.org/docs/Shader:hasAttribute  ]]
	--[[Check if the Shader has a given vertex attribute.  ]]
	--[[### See also]]
	--[[* [`Shader`](lua://lovr_shader)]]
	--[[@param name string]]
	--[[@return boolean exists]]
	--[[@overload fun(self: lovr_shader, location: number): boolean]]
	function Shader_class:hasAttribute(name) return false end

	--[[https://lovr.org/docs/Shader:hasStage  ]]
	--[[Check if the Shader has a given stage.  ]]
	--[[### See also]]
	--[[* [`Shader:getType`](lua://lovr_shader.getType)]]
	--[[* [`Shader`](lua://lovr_shader)]]
	--[[@param stage lovr_shader_stage]]
	--[[@return boolean exists]]
	function Shader_class:hasStage(stage) return false end

	--[[https://lovr.org/docs/ShaderStage  ]]
	--[[Different shader stages.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_shader_stage]]
	local lovr_shader_stage = {
		--[[The vertex stage, which computes transformed vertex positions.  ]]
		vertex = "vertex",
		--[[The fragment stage, which computes pixel colors.  ]]
		fragment = "fragment",
		--[[The compute stage, which performs arbitrary computation.  ]]
		compute = "compute",
	}

	--[[https://lovr.org/docs/ShaderType  ]]
	--[[Different types of Shaders.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newShader`](lua://lovr.graphics.newShader)]]
	--[[* [`Shader:getType`](lua://lovr_shader.getType)]]
	--[[* [`ShaderStage`](lua://lovr_shaderStage)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_shader_type]]
	local lovr_shader_type = {
		--[[A graphics shader with a vertex and pixel stage.  ]]
		graphics = "graphics",
		--[[A compute shader with a single compute stage.  ]]
		compute = "compute",
	}

	--[[https://lovr.org/docs/StackType  ]]
	--[[Types of stacks that can be pushed and popped.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_stack_type]]
	local lovr_stack_type = {
		--[[The transform stack (`Pass:transform`, `Pass:translate`, etc.).  ]]
		transform = "transform",
		--[[Graphics state, like `Pass:setColor`, `Pass:setFont`, etc.  Notably this does not include camera poses/projections or shader variables changed with `Pass:send`.  ]]
		state = "state",
	}

	--[[https://lovr.org/docs/StencilAction  ]]
	--[[Different ways of updating the stencil buffer.  ]]
	--[[### See also]]
	--[[* [`Pass:setStencilWrite`](lua://lovr_pass.setStencilWrite)]]
	--[[* [`Pass:setStencilTest`](lua://lovr_pass.setStencilTest)]]
	--[[* [`Pass:setColorWrite`](lua://lovr_pass.setColorWrite)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_stencil_action]]
	local lovr_stencil_action = {
		--[[Stencil buffer pixels will not be changed by draws.  ]]
		keep = "keep",
		--[[Stencil buffer pixels will be set to zero.  ]]
		zero = "zero",
		--[[Stencil buffer pixels will be replaced with a custom value.  ]]
		replace = "replace",
		--[[Stencil buffer pixels will be incremented each time they're rendered to.  ]]
		increment = "increment",
		--[[Stencil buffer pixels will be decremented each time they're rendered to.  ]]
		decrement = "decrement",
		--[[Similar to increment, but will wrap around to 0 when it exceeds 255.  ]]
		incrementwrap = "incrementwrap",
		--[[Similar to decrement, but will wrap around to 255 when it goes below 0.  ]]
		decrementwrap = "decrementwrap",
		--[[The bits in the stencil buffer pixels will be inverted.  ]]
		invert = "invert",
	}

	--[[https://lovr.org/docs/lovr.graphics.submit  ]]
	--[[Submit recorded graphics work to the GPU.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.wait`](lua://lovr.graphics.wait)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@param ... lovr_pass]]
	--[[@return boolean true_]]
	--[[@overload fun(t: table<string,string|number>): boolean]]
	function lovr.graphics.submit(...) return false end

	--[[https://lovr.org/docs/Texture  ]]
	--[[A multidimensional block of memory on the GPU.  ]]
	--[[@class lovr_texture: lovr_object]]

	--[[https://lovr.org/docs/Texture:clear  ]]
	--[[Clear the Texture to a color.  ]]
	--[[### See also]]
	--[[* [`Buffer:clear`](lua://lovr_buffer.clear)]]
	--[[* [`Texture:setPixels`](lua://lovr_texture.setPixels)]]
	--[[* [`Pass:setClear`](lua://lovr_pass.setClear)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@overload fun(self: lovr_texture, hex: number, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)]]
	--[[@overload fun(self: lovr_texture, r: number, g: number, b: number, a: number, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)]]
	--[[@overload fun(self: lovr_texture, t: table<string,string|number>, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)]]
	--[[@overload fun(self: lovr_texture, v3: lovr_vec3, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)]]
	--[[@overload fun(self: lovr_texture, v4: lovr_vec4, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number)]]
	function Texture_class:clear() end

	--[[https://lovr.org/docs/Texture:generateMipmaps  ]]
	--[[Regenerate mipmaps for a Texture.  ]]
	--[[### See also]]
	--[[* [`Texture:setPixels`](lua://lovr_texture.setPixels)]]
	--[[* [`Texture:getMipmapCount`](lua://lovr_texture.getMipmapCount)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@param base? number default=`1`]]
	--[[@param count? number default=`nil`]]
	function Texture_class:generateMipmaps(base, count) end

	--[[https://lovr.org/docs/Texture:getDimensions  ]]
	--[[Get the dimensions of the Texture.  ]]
	--[[### See also]]
	--[[* [`Texture:getWidth`](lua://lovr_texture.getWidth)]]
	--[[* [`Texture:getHeight`](lua://lovr_texture.getHeight)]]
	--[[* [`Texture:getLayerCount`](lua://lovr_texture.getLayerCount)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return number width]]
	--[[@return number height]]
	--[[@return number layers]]
	function Texture_class:getDimensions() return 0, 0, 0 end

	--[[https://lovr.org/docs/Texture:getFormat  ]]
	--[[Get the format of the Texture.  ]]
	--[[### See also]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return lovr_texture_format format]]
	function Texture_class:getFormat() return TextureFormat_class end

	--[[https://lovr.org/docs/Texture:getHeight  ]]
	--[[Get the height of the Texture, in pixels.  ]]
	--[[### See also]]
	--[[* [`Texture:getWidth`](lua://lovr_texture.getWidth)]]
	--[[* [`Texture:getLayerCount`](lua://lovr_texture.getLayerCount)]]
	--[[* [`Texture:getDimensions`](lua://lovr_texture.getDimensions)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return number height]]
	function Texture_class:getHeight() return 0 end

	--[[https://lovr.org/docs/Texture:getLayerCount  ]]
	--[[Get the layer count of the Texture.  ]]
	--[[### See also]]
	--[[* [`Texture:getWidth`](lua://lovr_texture.getWidth)]]
	--[[* [`Texture:getHeight`](lua://lovr_texture.getHeight)]]
	--[[* [`Texture:getDimensions`](lua://lovr_texture.getDimensions)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return number layers]]
	function Texture_class:getLayerCount() return 0 end

	--[[https://lovr.org/docs/Texture:getMipmapCount  ]]
	--[[Get the number of mipmap levels in the Texture.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newTexture`](lua://lovr.graphics.newTexture)]]
	--[[* [`Sampler:getMipmapRange`](lua://lovr_sampler.getMipmapRange)]]
	--[[* [`Texture:generateMipmaps`](lua://lovr_texture.generateMipmaps)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return number mipmaps]]
	function Texture_class:getMipmapCount() return 0 end

	--[[https://lovr.org/docs/Texture:getParent  ]]
	--[[Get the parent of a texture view.  ]]
	--[[### See also]]
	--[[* [`Texture:isView`](lua://lovr_texture.isView)]]
	--[[* [`Texture:newView`](lua://lovr_texture.newView)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return lovr_texture parent]]
	function Texture_class:getParent() return Texture_class end

	--[[https://lovr.org/docs/Texture:getPixels  ]]
	--[[Get the pixels of the Texture.  ]]
	--[[### See also]]
	--[[* [`Texture:newReadback`](lua://lovr_texture.newReadback)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param layer? number default=`1`]]
	--[[@param mipmap? number default=`1`]]
	--[[@param width? number default=`nil`]]
	--[[@param height? number default=`nil`]]
	--[[@return lovr_image image]]
	function Texture_class:getPixels(x, y, layer, mipmap, width, height) return Image_class end

	--[[https://lovr.org/docs/Texture:getSampleCount  ]]
	--[[Get the number of MSAA samples in the Texture.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newTexture`](lua://lovr.graphics.newTexture)]]
	--[[* [`Pass:getSampleCount`](lua://lovr_pass.getSampleCount)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return number samples]]
	function Texture_class:getSampleCount() return 0 end

	--[[https://lovr.org/docs/Texture:getType  ]]
	--[[Get the type of the Texture.  ]]
	--[[### See also]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return lovr_texture_type type]]
	function Texture_class:getType() return TextureType_class end

	--[[https://lovr.org/docs/Texture:getWidth  ]]
	--[[Get the width of the Texture, in pixels.  ]]
	--[[### See also]]
	--[[* [`Texture:getHeight`](lua://lovr_texture.getHeight)]]
	--[[* [`Texture:getLayerCount`](lua://lovr_texture.getLayerCount)]]
	--[[* [`Texture:getDimensions`](lua://lovr_texture.getDimensions)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return number width]]
	function Texture_class:getWidth() return 0 end

	--[[https://lovr.org/docs/Texture:hasUsage  ]]
	--[[Check if a Texture was created with a set of usage flags.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newTexture`](lua://lovr.graphics.newTexture)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@param ... lovr_texture_usage]]
	--[[@return boolean supported]]
	function Texture_class:hasUsage(...) return false end

	--[[https://lovr.org/docs/Texture:isView  ]]
	--[[Check if a Texture is a texture view.  ]]
	--[[### See also]]
	--[[* [`Texture:getParent`](lua://lovr_texture.getParent)]]
	--[[* [`Texture:newView`](lua://lovr_texture.newView)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@return boolean view]]
	function Texture_class:isView() return false end

	--[[https://lovr.org/docs/Texture:newReadback  ]]
	--[[Read back the contents of the Texture asynchronously.  ]]
	--[[### See also]]
	--[[* [`Texture:getPixels`](lua://lovr_texture.getPixels)]]
	--[[* [`Buffer:newReadback`](lua://lovr_buffer.newReadback)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param layer? number default=`1`]]
	--[[@param mipmap? number default=`1`]]
	--[[@param width? number default=`nil`]]
	--[[@param height? number default=`nil`]]
	--[[@return lovr_readback readback]]
	function Texture_class:newReadback(x, y, layer, mipmap, width, height) return Readback_class end

	--[[https://lovr.org/docs/Texture:newView  ]]
	--[[Create a texture view referencing a parent Texture.  ]]
	--[[### See also]]
	--[[* [`Texture:isView`](lua://lovr_texture.isView)]]
	--[[* [`Texture:getParent`](lua://lovr_texture.getParent)]]
	--[[* [`lovr.graphics.newTexture`](lua://lovr.graphics.newTexture)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@param layer? number default=`1`]]
	--[[@param mipmap? number default=`1`]]
	--[[@return lovr_texture view]]
	--[[@overload fun(self: lovr_texture, type: lovr_texture_type, layer?: number, layerCount?: number, mipmap?: number, mipmapCount?: number): lovr_texture]]
	function Texture_class:newView(layer, mipmap) return Texture_class end

	--[[https://lovr.org/docs/Texture:setPixels  ]]
	--[[Replace pixels in the Texture.  ]]
	--[[### See also]]
	--[[* [`Texture:newReadback`](lua://lovr_texture.newReadback)]]
	--[[* [`Texture:generateMipmaps`](lua://lovr_texture.generateMipmaps)]]
	--[[* [`Image:paste`](lua://lovr_image.paste)]]
	--[[* [`Texture`](lua://lovr_texture)]]
	--[[@param image lovr_image]]
	--[[@param dstx? number default=`0`]]
	--[[@param dsty? number default=`0`]]
	--[[@param dstlayer? number default=`1`]]
	--[[@param dstmipmap? number default=`1`]]
	--[[@param srcx? number default=`0`]]
	--[[@param srcy? number default=`0`]]
	--[[@param srclayer? number default=`1`]]
	--[[@param srcmipmap? number default=`1`]]
	--[[@param width? number default=`nil`]]
	--[[@param height? number default=`nil`]]
	--[[@param layers? number default=`nil`]]
	--[[@overload fun(self: lovr_texture, texture: lovr_texture, dstx?: number, dsty?: number, dstlayer?: number, dstmipmap?: number, srcx?: number, srcy?: number, srclayer?: number, srcmipmap?: number, width?: number, height?: number, layers?: number, srcwidth?: number, srcheight?: number, srcdepth?: number, filter?: lovr_filter_mode)]]
	function Texture_class:setPixels(image, dstx, dsty, dstlayer, dstmipmap, srcx, srcy, srclayer, srcmipmap, width, height, layers) end

	--[[https://lovr.org/docs/TextureFeature  ]]
	--[[Different ways Textures can be used.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_texture_feature]]
	local lovr_texture_feature = {
		--[[The Texture can be sampled (e.g. a `texture2D` or `sampler2D` variable in shaders).  ]]
		sample = "sample",
		--[[The Texture can be used with a `Sampler` using a `FilterMode` of `linear`.  ]]
		filter = "filter",
		--[[The Texture can be rendered to by using it as a target in a render `Pass`.  ]]
		render = "render",
		--[[Blending can be enabled when rendering to this format in a render pass.  ]]
		blend = "blend",
		--[[The Texture can be sent to an image variable in shaders (e.g. `image2D`).  ]]
		storage = "storage",
		--[[Atomic operations can be used on storage textures with this format.  ]]
		atomic = "atomic",
		--[[Source textures in `Pass:blit` can use this format.  ]]
		blitsrc = "blitsrc",
		--[[Destination textures in `Pass:blit` can use this format.  ]]
		blitdst = "blitdst",
	}

	--[[https://lovr.org/docs/TextureType  ]]
	--[[The different types of textures.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_texture_type]]
	local lovr_texture_type = {
		--[[A single 2D image, the most common type.  ]]
		["2d"] = "2d",
		--[[A 3D image, where a sequence of 2D images defines a 3D volume.  Each mipmap level of a 3D texture gets smaller in the x, y, and z axes, unlike cubemap and array textures.  ]]
		["3d"] = "3d",
		--[[Six square 2D images with the same dimensions that define the faces of a cubemap, used for skyboxes or other "directional" images.  ]]
		cube = "cube",
		--[[Array textures are sequences of distinct 2D images that all have the same dimensions.  ]]
		array = "array",
	}

	--[[https://lovr.org/docs/TextureUsage  ]]
	--[[Different operations `Texture` can be used for.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_texture_usage]]
	local lovr_texture_usage = {
		--[[Whether the texture can be sampled from in Shaders (i.e. used in a material, or bound to a variable with a `texture` type, like `texture2D`).  ]]
		sample = "sample",
		--[[Whether the texture can be rendered to (i.e. by using it as a render target in `lovr.graphics.pass`).  ]]
		render = "render",
		--[[Whether the texture can be used as a storage texture for compute operations (i.e. bound to a variable with an `image` type, like `image2D`).  ]]
		storage = "storage",
		--[[Whether the texture can be used for transfer operations like `Texture:setPixels`, `Texture:blit`, etc.  ]]
		transfer = "transfer",
	}

	--[[https://lovr.org/docs/VerticalAlign  ]]
	--[[Different ways to vertically align text.  ]]
	--[[### See also]]
	--[[* [`HorizontalAlign`](lua://lovr_horizontalAlign)]]
	--[[* [`Pass:text`](lua://lovr_pass.text)]]
	--[[* [`Font:getVertices`](lua://lovr_font.getVertices)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_vertical_align]]
	local lovr_vertical_align = {
		--[[Top-aligned text.  ]]
		top = "top",
		--[[Centered text.  ]]
		middle = "middle",
		--[[Bottom-aligned text.  ]]
		bottom = "bottom",
	}

	--[[https://lovr.org/docs/lovr.graphics.wait  ]]
	--[[Stall the CPU until all submitted GPU work is finished.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.submit`](lua://lovr.graphics.submit)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	function lovr.graphics.wait() end

	--[[https://lovr.org/docs/Winding  ]]
	--[[Different triangle windings.  ]]
	--[[### See also]]
	--[[* [`Pass:setWinding`](lua://lovr_pass.setWinding)]]
	--[[* [`Pass:setCullMode`](lua://lovr_pass.setCullMode)]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_winding]]
	local lovr_winding = {
		--[[Clockwise winding.  ]]
		clockwise = "clockwise",
		--[[Counterclockwise winding.  ]]
		counterclockwise = "counterclockwise",
	}

	--[[https://lovr.org/docs/WrapMode  ]]
	--[[Different ways to wrap textures.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics`](lua://lovr.graphics)]]
	--[[@enum lovr_wrap_mode]]
	local lovr_wrap_mode = {
		--[[Pixels will be clamped to the edge, with pixels outside the 0-1 uv range using colors from the nearest edge.  ]]
		clamp = "clamp",
		--[[Tiles the texture.  ]]
		["repeat"] = "repeat",
	}


	--[[https://lovr.org/docs/lovr.headset  ]]
	--[[@class lovr_headset]]
	lovr.headset = {}

	--[[https://lovr.org/docs/lovr.headset.animate  ]]
	--[[Animate a model to match its Device input state.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.newModel`](lua://lovr.headset.newModel)]]
	--[[* [`Model:animate`](lua://lovr_model.animate)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param model lovr_model]]
	--[[@return boolean success]]
	function lovr.headset.animate(model) return false end

	--[[https://lovr.org/docs/DeviceAxis  ]]
	--[[Different axes on an input device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getAxis`](lua://lovr.headset.getAxis)]]
	--[[* [`DeviceButton`](lua://lovr_deviceButton)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@enum lovr_device_axis]]
	local lovr_device_axis = {
		--[[A trigger (1D).  ]]
		trigger = "trigger",
		--[[A thumbstick (2D).  ]]
		thumbstick = "thumbstick",
		--[[A touchpad (2D).  ]]
		touchpad = "touchpad",
		--[[A grip button or grab gesture (1D).  ]]
		grip = "grip",
	}

	--[[https://lovr.org/docs/DeviceButton  ]]
	--[[Different buttons on an input device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@enum lovr_device_button]]
	local lovr_device_button = {
		--[[The trigger button.  ]]
		trigger = "trigger",
		--[[The thumbstick.  ]]
		thumbstick = "thumbstick",
		--[[The touchpad.  ]]
		touchpad = "touchpad",
		--[[The grip button.  ]]
		grip = "grip",
		--[[The menu button.  ]]
		menu = "menu",
		--[[The A button.  ]]
		a = "a",
		--[[The B button.  ]]
		b = "b",
		--[[The X button.  ]]
		x = "x",
		--[[The Y button.  ]]
		y = "y",
		--[[The proximity sensor on a headset.  ]]
		proximity = "proximity",
	}

	--[[https://lovr.org/docs/Device  ]]
	--[[Different types of input devices supported by the `lovr.headset` module.  ]]
	--[[### See also]]
	--[[* [`DeviceAxis`](lua://lovr_deviceAxis)]]
	--[[* [`DeviceButton`](lua://lovr_deviceButton)]]
	--[[* [`lovr.headset.getPose`](lua://lovr.headset.getPose)]]
	--[[* [`lovr.headset.getPosition`](lua://lovr.headset.getPosition)]]
	--[[* [`lovr.headset.getOrientation`](lua://lovr.headset.getOrientation)]]
	--[[* [`lovr.headset.getVelocity`](lua://lovr.headset.getVelocity)]]
	--[[* [`lovr.headset.getAngularVelocity`](lua://lovr.headset.getAngularVelocity)]]
	--[[* [`lovr.headset.getSkeleton`](lua://lovr.headset.getSkeleton)]]
	--[[* [`lovr.headset.isTracked`](lua://lovr.headset.isTracked)]]
	--[[* [`lovr.headset.isDown`](lua://lovr.headset.isDown)]]
	--[[* [`lovr.headset.isTouched`](lua://lovr.headset.isTouched)]]
	--[[* [`lovr.headset.wasPressed`](lua://lovr.headset.wasPressed)]]
	--[[* [`lovr.headset.wasReleased`](lua://lovr.headset.wasReleased)]]
	--[[* [`lovr.headset.getAxis`](lua://lovr.headset.getAxis)]]
	--[[* [`lovr.headset.vibrate`](lua://lovr.headset.vibrate)]]
	--[[* [`lovr.headset.animate`](lua://lovr.headset.animate)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@enum lovr_device]]
	local lovr_device = {
		--[[The headset.  ]]
		head = "head",
		--[[A device representing the floor, at the center of the play area.  The pose of this device in physical space will remain constant, even after recentering.  ]]
		floor = "floor",
		--[[A shorthand for hand/left.  ]]
		left = "left",
		--[[A shorthand for hand/right.  ]]
		right = "right",
		--[[The left hand.  ]]
		["hand/left"] = "hand/left",
		--[[The right hand.  ]]
		["hand/right"] = "hand/right",
		--[[The left hand grip pose, used for held objects.  ]]
		["hand/left/grip"] = "hand/left/grip",
		--[[The right hand grip pose, used for held objects.  ]]
		["hand/right/grip"] = "hand/right/grip",
		--[[The left hand pointer pose, used for pointing or aiming.  ]]
		["hand/left/point"] = "hand/left/point",
		--[[The right hand pointer pose, used for pointing or aiming.  ]]
		["hand/right/point"] = "hand/right/point",
		--[[The left hand pinch pose between the thumb and index fingers, used for precise, close-range interactions.  ]]
		["hand/left/pinch"] = "hand/left/pinch",
		--[[The right hand pinch pose between the thumb and index fingers, used for precise, close-range interactions.  ]]
		["hand/right/pinch"] = "hand/right/pinch",
		--[[The left hand poke pose, on the tip of the index finger or in front of a controller.  ]]
		["hand/left/poke"] = "hand/left/poke",
		--[[The right hand poke pose, on the tip of the index finger or in front of a controller.  ]]
		["hand/right/poke"] = "hand/right/poke",
		--[[A device tracking the left elbow.  ]]
		["elbow/left"] = "elbow/left",
		--[[A device tracking the right elbow.  ]]
		["elbow/right"] = "elbow/right",
		--[[A device tracking the left shoulder.  ]]
		["shoulder/left"] = "shoulder/left",
		--[[A device tracking the right shoulder.  ]]
		["shoulder/right"] = "shoulder/right",
		--[[A device tracking the chest.  ]]
		chest = "chest",
		--[[A device tracking the waist.  ]]
		waist = "waist",
		--[[A device tracking the left knee.  ]]
		["knee/left"] = "knee/left",
		--[[A device tracking the right knee.  ]]
		["knee/right"] = "knee/right",
		--[[A device tracking the left foot or ankle.  ]]
		["foot/left"] = "foot/left",
		--[[A device tracking the right foot or ankle.  ]]
		["foot/right"] = "foot/right",
		--[[A camera device, often used for recording "mixed reality" footage.  ]]
		camera = "camera",
		--[[A tracked keyboard.  ]]
		keyboard = "keyboard",
		--[[The left eye.  ]]
		["eye/left"] = "eye/left",
		--[[The right eye.  ]]
		["eye/right"] = "eye/right",
		--[[The combined eye gaze pose.  The position is between the eyes.  The orientation aligns the -Z axis in the direction the user is looking and the +Y axis to the head's "up" vector. This provides more accurate eye tracking information compared to using the individual eye devices.  ]]
		["eye/gaze"] = "eye/gaze",
	}

	--[[https://lovr.org/docs/lovr.headset.getAngularVelocity  ]]
	--[[Get the angular velocity of a device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getVelocity`](lua://lovr.headset.getVelocity)]]
	--[[* [`lovr.headset.getPosition`](lua://lovr.headset.getPosition)]]
	--[[* [`lovr.headset.getOrientation`](lua://lovr.headset.getOrientation)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function lovr.headset.getAngularVelocity(device) return 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getAxis  ]]
	--[[Get the state of an analog axis on a device.  ]]
	--[[### See also]]
	--[[* [`DeviceAxis`](lua://lovr_deviceAxis)]]
	--[[* [`lovr.headset.isDown`](lua://lovr.headset.isDown)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device lovr_device]]
	--[[@param axis lovr_device_axis]]
	--[[@return number ...]]
	function lovr.headset.getAxis(device, axis) return 0 end

	--[[https://lovr.org/docs/lovr.headset.getBoundsDepth  ]]
	--[[Get the depth of the play area.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getBoundsWidth`](lua://lovr.headset.getBoundsWidth)]]
	--[[* [`lovr.headset.getBoundsDimensions`](lua://lovr.headset.getBoundsDimensions)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number depth]]
	function lovr.headset.getBoundsDepth() return 0 end

	--[[https://lovr.org/docs/lovr.headset.getBoundsDimensions  ]]
	--[[Get the size of the play area.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getBoundsWidth`](lua://lovr.headset.getBoundsWidth)]]
	--[[* [`lovr.headset.getBoundsDepth`](lua://lovr.headset.getBoundsDepth)]]
	--[[* [`lovr.headset.getBoundsGeometry`](lua://lovr.headset.getBoundsGeometry)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number width]]
	--[[@return number depth]]
	function lovr.headset.getBoundsDimensions() return 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getBoundsGeometry  ]]
	--[[Get a list of points that make up the play area boundary.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getBoundsDimensions`](lua://lovr.headset.getBoundsDimensions)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param t? table<string,string|number> default=`nil`]]
	--[[@return table<string,string|number> points]]
	function lovr.headset.getBoundsGeometry(t) return {} end

	--[[https://lovr.org/docs/lovr.headset.getBoundsWidth  ]]
	--[[Get the width of the play area.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getBoundsDepth`](lua://lovr.headset.getBoundsDepth)]]
	--[[* [`lovr.headset.getBoundsDimensions`](lua://lovr.headset.getBoundsDimensions)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number width]]
	function lovr.headset.getBoundsWidth() return 0 end

	--[[https://lovr.org/docs/lovr.headset.getClipDistance  ]]
	--[[Get the near and far clipping planes of the headset.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number near]]
	--[[@return number far]]
	function lovr.headset.getClipDistance() return 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getDeltaTime  ]]
	--[[Get the predicted delta time.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getTime`](lua://lovr.headset.getTime)]]
	--[[* [`lovr.timer.getTime`](lua://lovr.timer.getTime)]]
	--[[* [`lovr.timer.getDelta`](lua://lovr.timer.getDelta)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number dt]]
	function lovr.headset.getDeltaTime() return 0 end

	--[[https://lovr.org/docs/lovr.headset.getDirection  ]]
	--[[Get the direction a device is pointing.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPose`](lua://lovr.headset.getPose)]]
	--[[* [`lovr.headset.getOrientation`](lua://lovr.headset.getOrientation)]]
	--[[* [`lovr.headset.getVelocity`](lua://lovr.headset.getVelocity)]]
	--[[* [`lovr.headset.getAngularVelocity`](lua://lovr.headset.getAngularVelocity)]]
	--[[* [`lovr.headset.isTracked`](lua://lovr.headset.isTracked)]]
	--[[* [`lovr.headset.getDriver`](lua://lovr.headset.getDriver)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function lovr.headset.getDirection(device) return 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getDisplayDimensions  ]]
	--[[Get the dimensions of the headset display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getDisplayWidth`](lua://lovr.headset.getDisplayWidth)]]
	--[[* [`lovr.headset.getDisplayHeight`](lua://lovr.headset.getDisplayHeight)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number width]]
	--[[@return number height]]
	function lovr.headset.getDisplayDimensions() return 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getDisplayFrequencies  ]]
	--[[Get the list of refresh rates supported by the display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.setDisplayFrequency`](lua://lovr.headset.setDisplayFrequency)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return table<string,string|number> frequencies]]
	--[[@deprecated]]
	function lovr.headset.getDisplayFrequencies() return {} end

	--[[https://lovr.org/docs/lovr.headset.getDisplayFrequency  ]]
	--[[Get the refresh rate of the display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number frequency]]
	--[[@deprecated]]
	function lovr.headset.getDisplayFrequency() return 0 end

	--[[https://lovr.org/docs/lovr.headset.getDisplayHeight  ]]
	--[[Get the height of the headset display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getDisplayWidth`](lua://lovr.headset.getDisplayWidth)]]
	--[[* [`lovr.headset.getDisplayDimensions`](lua://lovr.headset.getDisplayDimensions)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number height]]
	function lovr.headset.getDisplayHeight() return 0 end

	--[[https://lovr.org/docs/lovr.headset.getDisplayWidth  ]]
	--[[Get the width of the headset display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getDisplayHeight`](lua://lovr.headset.getDisplayHeight)]]
	--[[* [`lovr.headset.getDisplayDimensions`](lua://lovr.headset.getDisplayDimensions)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number width]]
	function lovr.headset.getDisplayWidth() return 0 end

	--[[https://lovr.org/docs/lovr.headset.getDriver  ]]
	--[[Get the VR API currently in use for a device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getName`](lua://lovr.headset.getName)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return lovr_headset_driver driver]]
	--[[@return string runtime]]
	function lovr.headset.getDriver() return HeadsetDriver_class, "" end

	--[[https://lovr.org/docs/lovr.headset.getHands  ]]
	--[[Get a list of currently tracked hand devices.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return table<string,string|number> hands]]
	function lovr.headset.getHands() return {} end

	--[[https://lovr.org/docs/lovr.headset.getLayers  ]]
	--[[Get the list of active layers.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.newLayer`](lua://lovr.headset.newLayer)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return table<string,string|number> layers]]
	function lovr.headset.getLayers() return {} end

	--[[https://lovr.org/docs/lovr.headset.getName  ]]
	--[[Get the name of the connected headset display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return string name]]
	function lovr.headset.getName() return "" end

	--[[https://lovr.org/docs/lovr.headset.getOrientation  ]]
	--[[Get the orientation of a device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPose`](lua://lovr.headset.getPose)]]
	--[[* [`lovr.headset.getPosition`](lua://lovr.headset.getPosition)]]
	--[[* [`lovr.headset.getDirection`](lua://lovr.headset.getDirection)]]
	--[[* [`lovr.headset.getVelocity`](lua://lovr.headset.getVelocity)]]
	--[[* [`lovr.headset.getAngularVelocity`](lua://lovr.headset.getAngularVelocity)]]
	--[[* [`lovr.headset.isTracked`](lua://lovr.headset.isTracked)]]
	--[[* [`lovr.headset.getDriver`](lua://lovr.headset.getDriver)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function lovr.headset.getOrientation(device) return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getOriginType  ]]
	--[[Get the type of tracking origin of the headset.  ]]
	--[[### See also]]
	--[[* [`HeadsetOrigin`](lua://lovr_headsetOrigin)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return lovr_headset_origin origin]]
	--[[@deprecated]]
	function lovr.headset.getOriginType() return HeadsetOrigin_class end

	--[[https://lovr.org/docs/lovr.headset.getPass  ]]
	--[[Get a Pass that renders to the headset.  ]]
	--[[### See also]]
	--[[* [`lovr.graphics.newPass`](lua://lovr.graphics.newPass)]]
	--[[* [`lovr.graphics.getWindowPass`](lua://lovr.graphics.getWindowPass)]]
	--[[* [`lovr.conf`](lua://lovr.conf)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return lovr_pass pass]]
	function lovr.headset.getPass() return Pass_class end

	--[[https://lovr.org/docs/lovr.headset.getPassthrough  ]]
	--[[Get the current passthrough mode.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPassthroughModes`](lua://lovr.headset.getPassthroughModes)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return lovr_passthrough_mode mode]]
	function lovr.headset.getPassthrough() return PassthroughMode_class end

	--[[https://lovr.org/docs/lovr.headset.getPassthroughModes  ]]
	--[[Get the supported passthrough modes.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPassthrough`](lua://lovr.headset.getPassthrough)]]
	--[[* [`lovr.headset.setPassthrough`](lua://lovr.headset.setPassthrough)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return table<string,string|number> modes]]
	function lovr.headset.getPassthroughModes() return {} end

	--[[https://lovr.org/docs/lovr.headset.getPose  ]]
	--[[Get the pose of a device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPosition`](lua://lovr.headset.getPosition)]]
	--[[* [`lovr.headset.getOrientation`](lua://lovr.headset.getOrientation)]]
	--[[* [`lovr.headset.getVelocity`](lua://lovr.headset.getVelocity)]]
	--[[* [`lovr.headset.getAngularVelocity`](lua://lovr.headset.getAngularVelocity)]]
	--[[* [`lovr.headset.getSkeleton`](lua://lovr.headset.getSkeleton)]]
	--[[* [`lovr.headset.isTracked`](lua://lovr.headset.isTracked)]]
	--[[* [`lovr.headset.getDriver`](lua://lovr.headset.getDriver)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function lovr.headset.getPose(device) return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getPosition  ]]
	--[[Get the position of a device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPose`](lua://lovr.headset.getPose)]]
	--[[* [`lovr.headset.getOrientation`](lua://lovr.headset.getOrientation)]]
	--[[* [`lovr.headset.getVelocity`](lua://lovr.headset.getVelocity)]]
	--[[* [`lovr.headset.getAngularVelocity`](lua://lovr.headset.getAngularVelocity)]]
	--[[* [`lovr.headset.isTracked`](lua://lovr.headset.isTracked)]]
	--[[* [`lovr.headset.getDriver`](lua://lovr.headset.getDriver)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function lovr.headset.getPosition(device) return 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getRefreshRate  ]]
	--[[Get the refresh rate of the headset display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getRefreshRates`](lua://lovr.headset.getRefreshRates)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number rate]]
	function lovr.headset.getRefreshRate() return 0 end

	--[[https://lovr.org/docs/lovr.headset.getRefreshRates  ]]
	--[[Get the list of refresh rates supported by the display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getRefreshRate`](lua://lovr.headset.getRefreshRate)]]
	--[[* [`lovr.headset.setRefreshRate`](lua://lovr.headset.setRefreshRate)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return table<string,string|number> rates]]
	function lovr.headset.getRefreshRates() return {} end

	--[[https://lovr.org/docs/lovr.headset.getSkeleton  ]]
	--[[Get skeletal joint transforms tracked by a device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPose`](lua://lovr.headset.getPose)]]
	--[[* [`lovr.headset.animate`](lua://lovr.headset.animate)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device lovr_device]]
	--[[@return table<string,string|number> transforms]]
	--[[@overload fun(device: lovr_device, t: table<string,string|number>): table<string,string|number>]]
	function lovr.headset.getSkeleton(device) return {} end

	--[[https://lovr.org/docs/lovr.headset.getTexture  ]]
	--[[Get the Texture for the headset display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPass`](lua://lovr.headset.getPass)]]
	--[[* [`lovr.mirror`](lua://lovr.mirror)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return lovr_texture texture]]
	function lovr.headset.getTexture() return Texture_class end

	--[[https://lovr.org/docs/lovr.headset.getTime  ]]
	--[[Get the predicted display time.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getDeltaTime`](lua://lovr.headset.getDeltaTime)]]
	--[[* [`lovr.timer.getTime`](lua://lovr.timer.getTime)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number time]]
	function lovr.headset.getTime() return 0 end

	--[[https://lovr.org/docs/lovr.headset.getVelocity  ]]
	--[[Get the linear velocity of a device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getAngularVelocity`](lua://lovr.headset.getAngularVelocity)]]
	--[[* [`lovr.headset.getPose`](lua://lovr.headset.getPose)]]
	--[[* [`lovr.headset.getPosition`](lua://lovr.headset.getPosition)]]
	--[[* [`lovr.headset.getOrientation`](lua://lovr.headset.getOrientation)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	--[[@return number vx]]
	--[[@return number vy]]
	--[[@return number vz]]
	function lovr.headset.getVelocity(device) return 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getViewAngles  ]]
	--[[Get the field of view angles of a view.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getViewCount`](lua://lovr.headset.getViewCount)]]
	--[[* [`lovr.headset.getViewPose`](lua://lovr.headset.getViewPose)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param view number]]
	--[[@return number left]]
	--[[@return number right]]
	--[[@return number top]]
	--[[@return number bottom]]
	function lovr.headset.getViewAngles(view) return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.headset.getViewCount  ]]
	--[[Get the number of views used for rendering.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getViewPose`](lua://lovr.headset.getViewPose)]]
	--[[* [`lovr.headset.getViewAngles`](lua://lovr.headset.getViewAngles)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return number count]]
	function lovr.headset.getViewCount() return 0 end

	--[[https://lovr.org/docs/lovr.headset.getViewPose  ]]
	--[[Get the pose of one of the views.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getViewCount`](lua://lovr.headset.getViewCount)]]
	--[[* [`lovr.headset.getViewAngles`](lua://lovr.headset.getViewAngles)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param view number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function lovr.headset.getViewPose(view) return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/HeadsetDriver  ]]
	--[[VR APIs.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@enum lovr_headset_driver]]
	local lovr_headset_driver = {
		--[[A VR simulator using keyboard/mouse.  ]]
		desktop = "desktop",
		--[[OpenXR.  ]]
		openxr = "openxr",
	}

	--[[https://lovr.org/docs/HeadsetOrigin  ]]
	--[[Different types of coordinate space origins.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@enum lovr_headset_origin]]
	local lovr_headset_origin = {
		--[[The origin is at the head.  ]]
		head = "head",
		--[[The origin is on the floor.  ]]
		floor = "floor",
	}

	--[[https://lovr.org/docs/lovr.headset.isDown  ]]
	--[[Get the state of a button on a device.  ]]
	--[[### See also]]
	--[[* [`DeviceButton`](lua://lovr_deviceButton)]]
	--[[* [`lovr.headset.wasPressed`](lua://lovr.headset.wasPressed)]]
	--[[* [`lovr.headset.wasReleased`](lua://lovr.headset.wasReleased)]]
	--[[* [`lovr.headset.isTouched`](lua://lovr.headset.isTouched)]]
	--[[* [`lovr.headset.getAxis`](lua://lovr.headset.getAxis)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device lovr_device]]
	--[[@param button lovr_device_button]]
	--[[@return boolean down]]
	function lovr.headset.isDown(device, button) return false end

	--[[https://lovr.org/docs/lovr.headset.isFocused  ]]
	--[[Check if LÖVR has VR input focus.  ]]
	--[[### See also]]
	--[[* [`lovr.focus`](lua://lovr.focus)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return boolean focused]]
	function lovr.headset.isFocused() return false end

	--[[https://lovr.org/docs/lovr.headset.isSeated  ]]
	--[[Check if the coordinate space is standing or seated.  ]]
	--[[### See also]]
	--[[* [`lovr.conf`](lua://lovr.conf)]]
	--[[* [`lovr.recenter`](lua://lovr.recenter)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return boolean seated]]
	function lovr.headset.isSeated() return false end

	--[[https://lovr.org/docs/lovr.headset.isTouched  ]]
	--[[Check if a button on a device is touched.  ]]
	--[[### See also]]
	--[[* [`DeviceButton`](lua://lovr_deviceButton)]]
	--[[* [`lovr.headset.isDown`](lua://lovr.headset.isDown)]]
	--[[* [`lovr.headset.getAxis`](lua://lovr.headset.getAxis)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device lovr_device]]
	--[[@param button lovr_device_button]]
	--[[@return boolean touched]]
	function lovr.headset.isTouched(device, button) return false end

	--[[https://lovr.org/docs/lovr.headset.isTracked  ]]
	--[[Check if a device is currently tracked.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	--[[@return boolean tracked]]
	function lovr.headset.isTracked(device) return false end

	--[[https://lovr.org/docs/lovr.headset.isVisible  ]]
	--[[Check if content is being shown in the headset display.  ]]
	--[[### See also]]
	--[[* [`lovr.visible`](lua://lovr.visible)]]
	--[[* [`lovr.headset.isFocused`](lua://lovr.headset.isFocused)]]
	--[[* [`lovr.focus`](lua://lovr.focus)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@return boolean visible]]
	function lovr.headset.isVisible() return false end

	--[[https://lovr.org/docs/Layer  ]]
	--[[A quad in 3D space.  ]]
	--[[@class lovr_layer: lovr_object]]

	--[[https://lovr.org/docs/Layer:getOrientation  ]]
	--[[Get the orientation of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getPosition`](lua://lovr_layer.getPosition)]]
	--[[* [`Layer:setPosition`](lua://lovr_layer.setPosition)]]
	--[[* [`Layer:getPose`](lua://lovr_layer.getPose)]]
	--[[* [`Layer:setPose`](lua://lovr_layer.setPose)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Layer_class:getOrientation() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Layer:getPass  ]]
	--[[Get the render pass for the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getTexture`](lua://lovr_layer.getTexture)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return lovr_pass pass]]
	function Layer_class:getPass() return Pass_class end

	--[[https://lovr.org/docs/Layer:getPose  ]]
	--[[Get the pose of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getPosition`](lua://lovr_layer.getPosition)]]
	--[[* [`Layer:setPosition`](lua://lovr_layer.setPosition)]]
	--[[* [`Layer:getOrientation`](lua://lovr_layer.getOrientation)]]
	--[[* [`Layer:setOrientation`](lua://lovr_layer.setOrientation)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Layer_class:getPose() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Layer:getPosition  ]]
	--[[Get the position of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getOrientation`](lua://lovr_layer.getOrientation)]]
	--[[* [`Layer:setOrientation`](lua://lovr_layer.setOrientation)]]
	--[[* [`Layer:getPose`](lua://lovr_layer.getPose)]]
	--[[* [`Layer:setPose`](lua://lovr_layer.setPose)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Layer_class:getPosition() return 0, 0, 0 end

	--[[https://lovr.org/docs/Layer:getSharpen  ]]
	--[[Get the sharpening mode of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getSupersample`](lua://lovr_layer.getSupersample)]]
	--[[* [`Layer:setSupersample`](lua://lovr_layer.setSupersample)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return boolean sharpen]]
	function Layer_class:getSharpen() return false end

	--[[https://lovr.org/docs/Layer:getSize  ]]
	--[[Get the size of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return number width]]
	--[[@return number height]]
	function Layer_class:getSize() return 0, 0 end

	--[[https://lovr.org/docs/Layer:getSupersample  ]]
	--[[Get the supersample mode of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getSharpen`](lua://lovr_layer.getSharpen)]]
	--[[* [`Layer:setSharpen`](lua://lovr_layer.setSharpen)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return boolean supersampled]]
	function Layer_class:getSupersample() return false end

	--[[https://lovr.org/docs/Layer:getTexture  ]]
	--[[Get the texture for the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getPass`](lua://lovr_layer.getPass)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return lovr_texture texture]]
	function Layer_class:getTexture() return Texture_class end

	--[[https://lovr.org/docs/Layer:getViewMask  ]]
	--[[Get the view mask of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return lovr_view_mask views]]
	function Layer_class:getViewMask() return ViewMask_class end

	--[[https://lovr.org/docs/Layer:getViewport  ]]
	--[[Get the viewport of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number w]]
	--[[@return number h]]
	function Layer_class:getViewport() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Layer:setOrientation  ]]
	--[[Set the orientation of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getPosition`](lua://lovr_layer.getPosition)]]
	--[[* [`Layer:setPosition`](lua://lovr_layer.setPosition)]]
	--[[* [`Layer:getPose`](lua://lovr_layer.getPose)]]
	--[[* [`Layer:setPose`](lua://lovr_layer.setPose)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_layer, orientation: lovr_quat)]]
	function Layer_class:setOrientation(angle, ax, ay, az) end

	--[[https://lovr.org/docs/Layer:setPose  ]]
	--[[Set the pose of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getPosition`](lua://lovr_layer.getPosition)]]
	--[[* [`Layer:setPosition`](lua://lovr_layer.setPosition)]]
	--[[* [`Layer:getOrientation`](lua://lovr_layer.getOrientation)]]
	--[[* [`Layer:setOrientation`](lua://lovr_layer.setOrientation)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_layer, position: lovr_vec3, orientation: lovr_quat)]]
	function Layer_class:setPose(x, y, z, angle, ax, ay, az) end

	--[[https://lovr.org/docs/Layer:setPosition  ]]
	--[[Set the position of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getOrientation`](lua://lovr_layer.getOrientation)]]
	--[[* [`Layer:setOrientation`](lua://lovr_layer.setOrientation)]]
	--[[* [`Layer:getPose`](lua://lovr_layer.getPose)]]
	--[[* [`Layer:setPose`](lua://lovr_layer.setPose)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	function Layer_class:setPosition(x, y, z) end

	--[[https://lovr.org/docs/Layer:setSharpen  ]]
	--[[Set the sharpening mode of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getSupersample`](lua://lovr_layer.getSupersample)]]
	--[[* [`Layer:setSupersample`](lua://lovr_layer.setSupersample)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@param sharpen boolean]]
	function Layer_class:setSharpen(sharpen) end

	--[[https://lovr.org/docs/Layer:setSize  ]]
	--[[Set the size of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@param width number]]
	--[[@param height number]]
	function Layer_class:setSize(width, height) end

	--[[https://lovr.org/docs/Layer:setSupersample  ]]
	--[[Set the supersample mode of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer:getSharpen`](lua://lovr_layer.getSharpen)]]
	--[[* [`Layer:setSharpen`](lua://lovr_layer.setSharpen)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@param supersampled boolean]]
	function Layer_class:setSupersample(supersampled) end

	--[[https://lovr.org/docs/Layer:setViewMask  ]]
	--[[Set the view mask of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@param views lovr_view_mask]]
	function Layer_class:setViewMask(views) end

	--[[https://lovr.org/docs/Layer:setViewport  ]]
	--[[Set the viewport of the layer.  ]]
	--[[### See also]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param w number]]
	--[[@param h number]]
	function Layer_class:setViewport(x, y, w, h) end

	--[[https://lovr.org/docs/lovr.headset.newLayer  ]]
	--[[Create a new Layer.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getLayers`](lua://lovr.headset.getLayers)]]
	--[[* [`lovr.headset.setLayers`](lua://lovr.headset.setLayers)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param width number]]
	--[[@param height number]]
	--[[@return lovr_layer layer]]
	function lovr.headset.newLayer(width, height) return Layer_class end

	--[[https://lovr.org/docs/lovr.headset.newModel  ]]
	--[[Get a Model for a device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.animate`](lua://lovr.headset.animate)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	--[[@param options? lovr_headset_new_model_options default=`{}`]]
	--[[@return lovr_model model]]
	function lovr.headset.newModel(device, options) return Model_class end

	--[[https://lovr.org/docs/lovr.headset.newModel  ]]
	--[[see also:  ]]
	--[[[`lovr.headset.newModel`](lua://lovr.headset.newModel)  ]]
	--[[@class lovr_headset_new_model_options]]
	--[[@field animated? boolean default=`false`]]

	--[[https://lovr.org/docs/PassthroughMode  ]]
	--[[Passthrough modes.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPassthrough`](lua://lovr.headset.getPassthrough)]]
	--[[* [`lovr.headset.setPassthrough`](lua://lovr.headset.setPassthrough)]]
	--[[* [`lovr.headset.getPassthroughModes`](lua://lovr.headset.getPassthroughModes)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@enum lovr_passthrough_mode]]
	local lovr_passthrough_mode = {
		--[[The headset display will not blend with anything behind it.  Most VR headsets use this mode.  ]]
		opaque = "opaque",
		--[[The real world will blend with the headset display using the alpha channel.  This is supported on VR headsets with camera passthrough, as well as some AR displays.  ]]
		blend = "blend",
		--[[Color values from virtual content will be added to the real world.  This is the most common mode used for AR.  Notably, black pixels will not show up at all.  ]]
		add = "add",
	}

	--[[https://lovr.org/docs/lovr.headset.setClipDistance  ]]
	--[[Set the near and far clipping planes of the headset.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param near number]]
	--[[@param far number]]
	function lovr.headset.setClipDistance(near, far) end

	--[[https://lovr.org/docs/lovr.headset.setDisplayFrequency  ]]
	--[[Set the display refresh rate.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param frequency number]]
	--[[@return boolean success]]
	--[[@deprecated]]
	function lovr.headset.setDisplayFrequency(frequency) return false end

	--[[https://lovr.org/docs/lovr.headset.setLayers  ]]
	--[[Set the list of active layers.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.newLayer`](lua://lovr.headset.newLayer)]]
	--[[* [`Layer`](lua://lovr_layer)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param ... lovr_layer]]
	--[[@overload fun(t: table<string,string|number>)]]
	function lovr.headset.setLayers(...) end

	--[[https://lovr.org/docs/lovr.headset.setPassthrough  ]]
	--[[Change current passthrough mode.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPassthroughModes`](lua://lovr.headset.getPassthroughModes)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param mode lovr_passthrough_mode]]
	--[[@return boolean success]]
	--[[@overload fun(transparent: boolean): boolean]]
	--[[@overload fun(): boolean]]
	function lovr.headset.setPassthrough(mode) return false end

	--[[https://lovr.org/docs/lovr.headset.setRefreshRate  ]]
	--[[Set the display refresh rate.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getRefreshRates`](lua://lovr.headset.getRefreshRates)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param rate number]]
	--[[@return boolean success]]
	function lovr.headset.setRefreshRate(rate) return false end

	--[[https://lovr.org/docs/lovr.headset.start  ]]
	--[[Starts the headset session.  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	function lovr.headset.start() end

	--[[https://lovr.org/docs/lovr.headset.stopVibration  ]]
	--[[Stop vibration on a device.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.vibrate`](lua://lovr.headset.vibrate)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	function lovr.headset.stopVibration(device) end

	--[[https://lovr.org/docs/lovr.headset.submit  ]]
	--[[Submit a frame to the headset display.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getPass`](lua://lovr.headset.getPass)]]
	--[[* [`lovr.headset.getTexture`](lua://lovr.headset.getTexture)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	function lovr.headset.submit() end

	--[[https://lovr.org/docs/lovr.headset.vibrate  ]]
	--[[Make a device go BZZZ!  ]]
	--[[### See also]]
	--[[* [`lovr.headset.stopVibration`](lua://lovr.headset.stopVibration)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device? lovr_device default=`'head'`]]
	--[[@param strength? number default=`1`]]
	--[[@param duration? number default=`.5`]]
	--[[@param frequency? number default=`0`]]
	--[[@return boolean vibrated]]
	function lovr.headset.vibrate(device, strength, duration, frequency) return false end

	--[[https://lovr.org/docs/ViewMask  ]]
	--[[Different eyes a Layer can show up in.  ]]
	--[[### See also]]
	--[[* [`Layer:getViewMask`](lua://lovr_layer.getViewMask)]]
	--[[* [`Layer:setViewMask`](lua://lovr_layer.setViewMask)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@enum lovr_view_mask]]
	local lovr_view_mask = {
		--[[The layer will show up in both eyes.  ]]
		both = "both",
		--[[The layer will only show up in the left eye.  ]]
		left = "left",
		--[[The layer will only show up in the right eye.  ]]
		right = "right",
	}

	--[[https://lovr.org/docs/lovr.headset.wasPressed  ]]
	--[[Check if a button was just pressed.  ]]
	--[[### See also]]
	--[[* [`DeviceButton`](lua://lovr_deviceButton)]]
	--[[* [`lovr.headset.isDown`](lua://lovr.headset.isDown)]]
	--[[* [`lovr.headset.wasReleased`](lua://lovr.headset.wasReleased)]]
	--[[* [`lovr.headset.isTouched`](lua://lovr.headset.isTouched)]]
	--[[* [`lovr.headset.getAxis`](lua://lovr.headset.getAxis)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device lovr_device]]
	--[[@param button lovr_device_button]]
	--[[@return boolean pressed]]
	function lovr.headset.wasPressed(device, button) return false end

	--[[https://lovr.org/docs/lovr.headset.wasReleased  ]]
	--[[Check if a button was just released.  ]]
	--[[### See also]]
	--[[* [`DeviceButton`](lua://lovr_deviceButton)]]
	--[[* [`lovr.headset.isDown`](lua://lovr.headset.isDown)]]
	--[[* [`lovr.headset.wasPressed`](lua://lovr.headset.wasPressed)]]
	--[[* [`lovr.headset.isTouched`](lua://lovr.headset.isTouched)]]
	--[[* [`lovr.headset.getAxis`](lua://lovr.headset.getAxis)]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@param device lovr_device]]
	--[[@param button lovr_device_button]]
	--[[@return boolean released]]
	function lovr.headset.wasReleased(device, button) return false end


	--[[https://lovr.org/docs/lovr.math  ]]
	--[[@class lovr_math]]
	lovr.math = {}

	--[[https://lovr.org/docs/Curve  ]]
	--[[A Bézier curve.  ]]
	--[[@class lovr_curve: lovr_object]]

	--[[https://lovr.org/docs/Curve:addPoint  ]]
	--[[Add a new control point to the Curve.  ]]
	--[[### See also]]
	--[[* [`Curve:getPointCount`](lua://lovr_curve.getPointCount)]]
	--[[* [`Curve:getPoint`](lua://lovr_curve.getPoint)]]
	--[[* [`Curve:setPoint`](lua://lovr_curve.setPoint)]]
	--[[* [`Curve:removePoint`](lua://lovr_curve.removePoint)]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param index? number default=`nil`]]
	function Curve_class:addPoint(x, y, z, index) end

	--[[https://lovr.org/docs/Curve:evaluate  ]]
	--[[Turn a number from 0 to 1 into a point on the Curve.  ]]
	--[[### See also]]
	--[[* [`Curve:getTangent`](lua://lovr_curve.getTangent)]]
	--[[* [`Curve:render`](lua://lovr_curve.render)]]
	--[[* [`Curve:slice`](lua://lovr_curve.slice)]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[@param t number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Curve_class:evaluate(t) return 0, 0, 0 end

	--[[https://lovr.org/docs/Curve:getPointCount  ]]
	--[[Get the number of control points in the Curve.  ]]
	--[[### See also]]
	--[[* [`Curve:getPoint`](lua://lovr_curve.getPoint)]]
	--[[* [`Curve:setPoint`](lua://lovr_curve.setPoint)]]
	--[[* [`Curve:addPoint`](lua://lovr_curve.addPoint)]]
	--[[* [`Curve:removePoint`](lua://lovr_curve.removePoint)]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[@return number count]]
	function Curve_class:getPointCount() return 0 end

	--[[https://lovr.org/docs/Curve:getPoint  ]]
	--[[Get a control point of the Curve.  ]]
	--[[### See also]]
	--[[* [`Curve:getPointCount`](lua://lovr_curve.getPointCount)]]
	--[[* [`Curve:setPoint`](lua://lovr_curve.setPoint)]]
	--[[* [`Curve:addPoint`](lua://lovr_curve.addPoint)]]
	--[[* [`Curve:removePoint`](lua://lovr_curve.removePoint)]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[@param index number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Curve_class:getPoint(index) return 0, 0, 0 end

	--[[https://lovr.org/docs/Curve:getTangent  ]]
	--[[Get the direction of the Curve at a point.  ]]
	--[[### See also]]
	--[[* [`Curve:evaluate`](lua://lovr_curve.evaluate)]]
	--[[* [`Curve:render`](lua://lovr_curve.render)]]
	--[[* [`Curve:slice`](lua://lovr_curve.slice)]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[@param t number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Curve_class:getTangent(t) return 0, 0, 0 end

	--[[https://lovr.org/docs/Curve:removePoint  ]]
	--[[Remove a control point from the Curve.  ]]
	--[[### See also]]
	--[[* [`Curve:getPointCount`](lua://lovr_curve.getPointCount)]]
	--[[* [`Curve:getPoint`](lua://lovr_curve.getPoint)]]
	--[[* [`Curve:setPoint`](lua://lovr_curve.setPoint)]]
	--[[* [`Curve:addPoint`](lua://lovr_curve.addPoint)]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[@param index number]]
	function Curve_class:removePoint(index) end

	--[[https://lovr.org/docs/Curve:render  ]]
	--[[Get a list of points on the Curve.  ]]
	--[[### See also]]
	--[[* [`Curve:evaluate`](lua://lovr_curve.evaluate)]]
	--[[* [`Curve:slice`](lua://lovr_curve.slice)]]
	--[[* [`Pass:points`](lua://lovr_pass.points)]]
	--[[* [`Pass:line`](lua://lovr_pass.line)]]
	--[[* [`Pass:mesh`](lua://lovr_pass.mesh)]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[@param n? number default=`32`]]
	--[[@param t1? number default=`0`]]
	--[[@param t2? number default=`1`]]
	--[[@return table<string,string|number> t]]
	function Curve_class:render(n, t1, t2) return {} end

	--[[https://lovr.org/docs/Curve:setPoint  ]]
	--[[Set a control point of the Curve.  ]]
	--[[### See also]]
	--[[* [`Curve:getPointCount`](lua://lovr_curve.getPointCount)]]
	--[[* [`Curve:getPoint`](lua://lovr_curve.getPoint)]]
	--[[* [`Curve:addPoint`](lua://lovr_curve.addPoint)]]
	--[[* [`Curve:removePoint`](lua://lovr_curve.removePoint)]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[@param index number]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	function Curve_class:setPoint(index, x, y, z) end

	--[[https://lovr.org/docs/Curve:slice  ]]
	--[[Get a new Curve from a slice of an existing one.  ]]
	--[[### See also]]
	--[[* [`Curve:evaluate`](lua://lovr_curve.evaluate)]]
	--[[* [`Curve:render`](lua://lovr_curve.render)]]
	--[[* [`Curve`](lua://lovr_curve)]]
	--[[@param t1 number]]
	--[[@param t2 number]]
	--[[@return lovr_curve curve]]
	function Curve_class:slice(t1, t2) return Curve_class end

	--[[https://lovr.org/docs/lovr.math.drain  ]]
	--[[Drain the temporary vector pool.  ]]
	--[[### See also]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	function lovr.math.drain() end

	--[[https://lovr.org/docs/lovr.math.gammaToLinear  ]]
	--[[Convert a color from gamma space to linear space.  ]]
	--[[### See also]]
	--[[* [`lovr.math.linearToGamma`](lua://lovr.math.linearToGamma)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param gr number]]
	--[[@param gg number]]
	--[[@param gb number]]
	--[[@return number lr]]
	--[[@return number lg]]
	--[[@return number lb]]
	--[[@overload fun(color: table<string,string|number>): number, number, number]]
	--[[@overload fun(x: number): number]]
	function lovr.math.gammaToLinear(gr, gg, gb) return 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.math.getRandomSeed  ]]
	--[[Get the random seed.  ]]
	--[[### See also]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@return number seed]]
	function lovr.math.getRandomSeed() return 0 end

	--[[https://lovr.org/docs/lovr.math.linearToGamma  ]]
	--[[Convert a color from linear space to gamma space.  ]]
	--[[### See also]]
	--[[* [`lovr.math.gammaToLinear`](lua://lovr.math.gammaToLinear)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param lr number]]
	--[[@param lg number]]
	--[[@param lb number]]
	--[[@return number gr]]
	--[[@return number gg]]
	--[[@return number gb]]
	--[[@overload fun(color: table<string,string|number>): number, number, number]]
	--[[@overload fun(x: number): number]]
	function lovr.math.linearToGamma(lr, lg, lb) return 0, 0, 0 end

	--[[https://lovr.org/docs/Mat4  ]]
	--[[A 4x4 matrix.  ]]
	--[[@class lovr_mat4: lovr_object]]

	--[[https://lovr.org/docs/Mat4:equals  ]]
	--[[Check if a matrix equals another matrix.  ]]
	--[[### See also]]
	--[[* [`Vec2:equals`](lua://lovr_vec2.equals)]]
	--[[* [`Vec3:equals`](lua://lovr_vec3.equals)]]
	--[[* [`Vec4:equals`](lua://lovr_vec4.equals)]]
	--[[* [`Quat:equals`](lua://lovr_quat.equals)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param n lovr_mat4]]
	--[[@return boolean equal]]
	function Mat4_class:equals(n) return false end

	--[[https://lovr.org/docs/Mat4:fov  ]]
	--[[Set a projection using raw field of view angles.  ]]
	--[[### See also]]
	--[[* [`Mat4:orthographic`](lua://lovr_mat4.orthographic)]]
	--[[* [`Mat4:perspective`](lua://lovr_mat4.perspective)]]
	--[[* [`Pass:setProjection`](lua://lovr_pass.setProjection)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param left number]]
	--[[@param right number]]
	--[[@param up number]]
	--[[@param down number]]
	--[[@param near number]]
	--[[@param far? number default=`0`]]
	--[[@return lovr_mat4 self]]
	function Mat4_class:fov(left, right, up, down, near, far) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:getOrientation  ]]
	--[[Get the angle/axis rotation of the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4:getPosition`](lua://lovr_mat4.getPosition)]]
	--[[* [`Mat4:getScale`](lua://lovr_mat4.getScale)]]
	--[[* [`Mat4:getPose`](lua://lovr_mat4.getPose)]]
	--[[* [`Mat4:unpack`](lua://lovr_mat4.unpack)]]
	--[[* [`Mat4:set`](lua://lovr_mat4.set)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Mat4_class:getOrientation() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Mat4:getPose  ]]
	--[[Get the position and rotation of the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4:getPosition`](lua://lovr_mat4.getPosition)]]
	--[[* [`Mat4:getOrientation`](lua://lovr_mat4.getOrientation)]]
	--[[* [`Mat4:getScale`](lua://lovr_mat4.getScale)]]
	--[[* [`Mat4:unpack`](lua://lovr_mat4.unpack)]]
	--[[* [`Mat4:set`](lua://lovr_mat4.set)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Mat4_class:getPose() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Mat4:getPosition  ]]
	--[[Get the translation of the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4:getOrientation`](lua://lovr_mat4.getOrientation)]]
	--[[* [`Mat4:getScale`](lua://lovr_mat4.getScale)]]
	--[[* [`Mat4:getPose`](lua://lovr_mat4.getPose)]]
	--[[* [`Mat4:unpack`](lua://lovr_mat4.unpack)]]
	--[[* [`Mat4:set`](lua://lovr_mat4.set)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Mat4_class:getPosition() return 0, 0, 0 end

	--[[https://lovr.org/docs/Mat4:getScale  ]]
	--[[Get the scale factor of the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4:getPosition`](lua://lovr_mat4.getPosition)]]
	--[[* [`Mat4:getOrientation`](lua://lovr_mat4.getOrientation)]]
	--[[* [`Mat4:getPose`](lua://lovr_mat4.getPose)]]
	--[[* [`Mat4:unpack`](lua://lovr_mat4.unpack)]]
	--[[* [`Mat4:set`](lua://lovr_mat4.set)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@return number sx]]
	--[[@return number sy]]
	--[[@return number sz]]
	function Mat4_class:getScale() return 0, 0, 0 end

	--[[https://lovr.org/docs/Mat4:identity  ]]
	--[[Reset the matrix to the identity.  ]]
	--[[### See also]]
	--[[* [`Pass:origin`](lua://lovr_pass.origin)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@return lovr_mat4 self]]
	function Mat4_class:identity() return Mat4_class end

	--[[https://lovr.org/docs/Mat4:invert  ]]
	--[[Invert the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@return lovr_mat4 self]]
	function Mat4_class:invert() return Mat4_class end

	--[[https://lovr.org/docs/Mat4:lookAt  ]]
	--[[Create a view transform that looks from a position to target position.  ]]
	--[[### See also]]
	--[[* [`Mat4:target`](lua://lovr_mat4.target)]]
	--[[* [`Quat:direction`](lua://lovr_quat.direction)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param from lovr_vec3]]
	--[[@param to lovr_vec3]]
	--[[@param up? lovr_vec3 default=`Vec3(0, 1, 0)`]]
	--[[@return lovr_mat4 self]]
	function Mat4_class:lookAt(from, to, up) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:mul  ]]
	--[[Multiply a matrix with another matrix or a vector.  ]]
	--[[### See also]]
	--[[* [`Mat4:translate`](lua://lovr_mat4.translate)]]
	--[[* [`Mat4:rotate`](lua://lovr_mat4.rotate)]]
	--[[* [`Mat4:scale`](lua://lovr_mat4.scale)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param n lovr_mat4]]
	--[[@return lovr_mat4 self]]
	--[[@overload fun(self: lovr_mat4, v3: lovr_vec3): lovr_vec3]]
	--[[@overload fun(self: lovr_mat4, v4: lovr_vec4): lovr_vec4]]
	function Mat4_class:mul(n) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:orthographic  ]]
	--[[Turn the matrix into an orthographic projection.  ]]
	--[[### See also]]
	--[[* [`Mat4:perspective`](lua://lovr_mat4.perspective)]]
	--[[* [`Mat4:fov`](lua://lovr_mat4.fov)]]
	--[[* [`Pass:setProjection`](lua://lovr_pass.setProjection)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param left number]]
	--[[@param right number]]
	--[[@param bottom number]]
	--[[@param top number]]
	--[[@param near number]]
	--[[@param far number]]
	--[[@return lovr_mat4 self]]
	--[[@overload fun(self: lovr_mat4, width: number, height: number, near: number, far: number): lovr_mat4]]
	function Mat4_class:orthographic(left, right, bottom, top, near, far) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:perspective  ]]
	--[[Turn the matrix into a perspective projection.  ]]
	--[[### See also]]
	--[[* [`Mat4:orthographic`](lua://lovr_mat4.orthographic)]]
	--[[* [`Mat4:fov`](lua://lovr_mat4.fov)]]
	--[[* [`Pass:setProjection`](lua://lovr_pass.setProjection)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param fov number]]
	--[[@param aspect number]]
	--[[@param near number]]
	--[[@param far? number default=`0`]]
	--[[@return lovr_mat4 self]]
	function Mat4_class:perspective(fov, aspect, near, far) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:reflect  ]]
	--[[Create a matrix that reflects across a plane.  ]]
	--[[### See also]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param position lovr_vec3]]
	--[[@param normal lovr_vec3]]
	--[[@return lovr_mat4 self]]
	function Mat4_class:reflect(position, normal) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:rotate  ]]
	--[[Rotate the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4:translate`](lua://lovr_mat4.translate)]]
	--[[* [`Mat4:scale`](lua://lovr_mat4.scale)]]
	--[[* [`Mat4:identity`](lua://lovr_mat4.identity)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param q lovr_quat]]
	--[[@return lovr_mat4 self]]
	--[[@overload fun(self: lovr_mat4, angle: number, ax?: number, ay?: number, az?: number): lovr_mat4]]
	function Mat4_class:rotate(q) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:scale  ]]
	--[[Scale the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4:translate`](lua://lovr_mat4.translate)]]
	--[[* [`Mat4:rotate`](lua://lovr_mat4.rotate)]]
	--[[* [`Mat4:identity`](lua://lovr_mat4.identity)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param scale lovr_vec3]]
	--[[@return lovr_mat4 self]]
	--[[@overload fun(self: lovr_mat4, sx: number, sy?: number, sz?: number): lovr_mat4]]
	function Mat4_class:scale(scale) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:set  ]]
	--[[Set the components of the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4:unpack`](lua://lovr_mat4.unpack)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@return lovr_mat4 m]]
	--[[@overload fun(self: lovr_mat4, n: lovr_mat4): lovr_mat4]]
	--[[@overload fun(self: lovr_mat4, x: number, y: number, z: number, sx: number, sy: number, sz: number, angle: number, ax: number, ay: number, az: number): lovr_mat4]]
	--[[@overload fun(self: lovr_mat4, x: number, y: number, z: number, angle: number, ax: number, ay: number, az: number): lovr_mat4]]
	--[[@overload fun(self: lovr_mat4, position: lovr_vec3, scale: lovr_vec3, rotation: lovr_quat): lovr_mat4]]
	--[[@overload fun(self: lovr_mat4, position: lovr_vec3, rotation: lovr_quat): lovr_mat4]]
	--[[@overload fun(self: lovr_mat4, ...: number): lovr_mat4]]
	--[[@overload fun(self: lovr_mat4, d: number): lovr_mat4]]
	function Mat4_class:set() return Mat4_class end

	--[[https://lovr.org/docs/Mat4:target  ]]
	--[[Create a model transform that targets from a position to target position.  ]]
	--[[### See also]]
	--[[* [`Mat4:lookAt`](lua://lovr_mat4.lookAt)]]
	--[[* [`Quat:direction`](lua://lovr_quat.direction)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param from lovr_vec3]]
	--[[@param to lovr_vec3]]
	--[[@param up? lovr_vec3 default=`Vec3(0, 1, 0)`]]
	--[[@return lovr_mat4 self]]
	function Mat4_class:target(from, to, up) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:translate  ]]
	--[[Translate the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4:rotate`](lua://lovr_mat4.rotate)]]
	--[[* [`Mat4:scale`](lua://lovr_mat4.scale)]]
	--[[* [`Mat4:identity`](lua://lovr_mat4.identity)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param v lovr_vec3]]
	--[[@return lovr_mat4 self]]
	--[[@overload fun(self: lovr_mat4, x: number, y: number, z: number): lovr_mat4]]
	function Mat4_class:translate(v) return Mat4_class end

	--[[https://lovr.org/docs/Mat4:transpose  ]]
	--[[Transpose the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@return lovr_mat4 self]]
	function Mat4_class:transpose() return Mat4_class end

	--[[https://lovr.org/docs/Mat4:unpack  ]]
	--[[Get the individual components of the matrix.  ]]
	--[[### See also]]
	--[[* [`Mat4:set`](lua://lovr_mat4.set)]]
	--[[* [`Mat4:getPosition`](lua://lovr_mat4.getPosition)]]
	--[[* [`Mat4:getOrientation`](lua://lovr_mat4.getOrientation)]]
	--[[* [`Mat4:getScale`](lua://lovr_mat4.getScale)]]
	--[[* [`Mat4:getPose`](lua://lovr_mat4.getPose)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[@param raw? boolean default=`false`]]
	--[[@return number ...]]
	function Mat4_class:unpack(raw) return 0 end

	--[[https://lovr.org/docs/lovr.math.mat4  ]]
	--[[Create a temporary Mat4.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newMat4`](lua://lovr.math.newMat4)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@return lovr_mat4 m]]
	--[[@overload fun(n: lovr_mat4): lovr_mat4]]
	--[[@overload fun(position?: lovr_vec3, scale?: lovr_vec3, rotation?: lovr_quat): lovr_mat4]]
	--[[@overload fun(position?: lovr_vec3, rotation?: lovr_quat): lovr_mat4]]
	--[[@overload fun(...: number): lovr_mat4]]
	--[[@overload fun(d: number): lovr_mat4]]
	function lovr.math.mat4() return Mat4_class end

	--[[https://lovr.org/docs/mat4  ]]
	--[[Create a temporary Mat4.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newMat4`](lua://lovr.math.newMat4)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@return lovr_mat4 m]]
	--[[@overload fun(n: lovr_mat4): lovr_mat4]]
	--[[@overload fun(position?: lovr_vec3, scale?: lovr_vec3, rotation?: lovr_quat): lovr_mat4]]
	--[[@overload fun(position?: lovr_vec3, rotation?: lovr_quat): lovr_mat4]]
	--[[@overload fun(...: number): lovr_mat4]]
	--[[@overload fun(d: number): lovr_mat4]]
	function mat4() return Mat4_class end

	--[[https://lovr.org/docs/lovr.math.newCurve  ]]
	--[[Create a new Curve.  ]]
	--[[### See also]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param ... unknown]]
	--[[@return lovr_curve curve]]
	--[[@overload fun(v: lovr_vec3, ...: unknown): lovr_curve]]
	--[[@overload fun(points: table<string,string|number>): lovr_curve]]
	--[[@overload fun(n: number): lovr_curve]]
	function lovr.math.newCurve(x, y, z, ...) return Curve_class end

	--[[https://lovr.org/docs/lovr.math.newMat4  ]]
	--[[Create a new Mat4.  ]]
	--[[### See also]]
	--[[* [`lovr.math.mat4`](lua://lovr.math.mat4)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@return lovr_mat4 m]]
	--[[@overload fun(n: lovr_mat4): lovr_mat4]]
	--[[@overload fun(position?: lovr_vec3, scale?: lovr_vec3, rotation?: lovr_quat): lovr_mat4]]
	--[[@overload fun(position?: lovr_vec3, rotation?: lovr_quat): lovr_mat4]]
	--[[@overload fun(...: number): lovr_mat4]]
	--[[@overload fun(d: number): lovr_mat4]]
	function lovr.math.newMat4() return Mat4_class end

	--[[https://lovr.org/docs/Mat4  ]]
	--[[Create a new Mat4.  ]]
	--[[### See also]]
	--[[* [`lovr.math.mat4`](lua://lovr.math.mat4)]]
	--[[* [`Mat4`](lua://lovr_mat4)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@return lovr_mat4 m]]
	--[[@overload fun(n: lovr_mat4): lovr_mat4]]
	--[[@overload fun(position?: lovr_vec3, scale?: lovr_vec3, rotation?: lovr_quat): lovr_mat4]]
	--[[@overload fun(position?: lovr_vec3, rotation?: lovr_quat): lovr_mat4]]
	--[[@overload fun(...: number): lovr_mat4]]
	--[[@overload fun(d: number): lovr_mat4]]
	function Mat4() return Mat4_class end

	--[[https://lovr.org/docs/lovr.math.newQuat  ]]
	--[[Create a new Quat.  ]]
	--[[### See also]]
	--[[* [`lovr.math.quat`](lua://lovr.math.quat)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`0`]]
	--[[@param az? number default=`0`]]
	--[[@param raw? boolean default=`false`]]
	--[[@return lovr_quat q]]
	--[[@overload fun(r: lovr_quat): lovr_quat]]
	--[[@overload fun(v: lovr_vec3): lovr_quat]]
	--[[@overload fun(v: lovr_vec3, u: lovr_vec3): lovr_quat]]
	--[[@overload fun(m: lovr_mat4): lovr_quat]]
	--[[@overload fun(): lovr_quat]]
	function lovr.math.newQuat(angle, ax, ay, az, raw) return Quat_class end

	--[[https://lovr.org/docs/lovr.math.newRandomGenerator  ]]
	--[[Create a new RandomGenerator.  ]]
	--[[### See also]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@return lovr_random_generator randomGenerator]]
	--[[@overload fun(seed: number): lovr_random_generator]]
	--[[@overload fun(low: number, high: number): lovr_random_generator]]
	function lovr.math.newRandomGenerator() return RandomGenerator_class end

	--[[https://lovr.org/docs/lovr.math.newVec2  ]]
	--[[Create a new Vec2.  ]]
	--[[### See also]]
	--[[* [`lovr.math.vec2`](lua://lovr.math.vec2)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@return lovr_vec2 v]]
	--[[@overload fun(u: lovr_vec2): lovr_vec2]]
	function lovr.math.newVec2(x, y) return Vec2_class end

	--[[https://lovr.org/docs/Vec2  ]]
	--[[Create a new Vec2.  ]]
	--[[### See also]]
	--[[* [`lovr.math.vec2`](lua://lovr.math.vec2)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@return lovr_vec2 v]]
	--[[@overload fun(u: lovr_vec2): lovr_vec2]]
	function Vec2(x, y) return Vec2_class end

	--[[https://lovr.org/docs/lovr.math.newVec3  ]]
	--[[Create a new Vec3.  ]]
	--[[### See also]]
	--[[* [`lovr.math.vec3`](lua://lovr.math.vec3)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@return lovr_vec3 v]]
	--[[@overload fun(u: lovr_vec3): lovr_vec3]]
	--[[@overload fun(m: lovr_mat4): lovr_vec3]]
	--[[@overload fun(q: lovr_quat): lovr_vec3]]
	function lovr.math.newVec3(x, y, z) return Vec3_class end

	--[[https://lovr.org/docs/Vec3  ]]
	--[[Create a new Vec3.  ]]
	--[[### See also]]
	--[[* [`lovr.math.vec3`](lua://lovr.math.vec3)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@return lovr_vec3 v]]
	--[[@overload fun(u: lovr_vec3): lovr_vec3]]
	--[[@overload fun(m: lovr_mat4): lovr_vec3]]
	--[[@overload fun(q: lovr_quat): lovr_vec3]]
	function Vec3(x, y, z) return Vec3_class end

	--[[https://lovr.org/docs/lovr.math.newVec4  ]]
	--[[Create a new Vec4.  ]]
	--[[### See also]]
	--[[* [`lovr.math.vec4`](lua://lovr.math.vec4)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@param w? number default=`x`]]
	--[[@return lovr_vec4 v]]
	--[[@overload fun(u: lovr_vec4): lovr_vec4]]
	function lovr.math.newVec4(x, y, z, w) return Vec4_class end

	--[[https://lovr.org/docs/Vec4  ]]
	--[[Create a new Vec4.  ]]
	--[[### See also]]
	--[[* [`lovr.math.vec4`](lua://lovr.math.vec4)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@param w? number default=`x`]]
	--[[@return lovr_vec4 v]]
	--[[@overload fun(u: lovr_vec4): lovr_vec4]]
	function Vec4(x, y, z, w) return Vec4_class end

	--[[https://lovr.org/docs/lovr.math.noise  ]]
	--[[Generate simplex noise.  ]]
	--[[### See also]]
	--[[* [`lovr.math.random`](lua://lovr.math.random)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x number]]
	--[[@return number noise]]
	--[[@overload fun(x: number, y: number): number]]
	--[[@overload fun(x: number, y: number, z: number): number]]
	--[[@overload fun(x: number, y: number, z: number, w: number): number]]
	function lovr.math.noise(x) return 0 end

	--[[https://lovr.org/docs/Quat  ]]
	--[[A quaternion.  ]]
	--[[@class lovr_quat: lovr_object]]

	--[[https://lovr.org/docs/Quat:conjugate  ]]
	--[[Conjugate (invert) the quaternion.  ]]
	--[[### See also]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[@return lovr_quat self]]
	function Quat_class:conjugate() return Quat_class end

	--[[https://lovr.org/docs/Quat:direction  ]]
	--[[Get the direction of the quaternion.  ]]
	--[[### See also]]
	--[[* [`Mat4:lookAt`](lua://lovr_mat4.lookAt)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[@return lovr_vec3 v]]
	function Quat_class:direction() return Vec3_class end

	--[[https://lovr.org/docs/Quat:equals  ]]
	--[[Check if a quaternion equals another quaternion.  ]]
	--[[### See also]]
	--[[* [`Vec2:equals`](lua://lovr_vec2.equals)]]
	--[[* [`Vec3:equals`](lua://lovr_vec3.equals)]]
	--[[* [`Vec4:equals`](lua://lovr_vec4.equals)]]
	--[[* [`Mat4:equals`](lua://lovr_mat4.equals)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[@param r lovr_quat]]
	--[[@return boolean equal]]
	function Quat_class:equals(r) return false end

	--[[https://lovr.org/docs/Quat:length  ]]
	--[[Get the length of the quaternion.  ]]
	--[[### See also]]
	--[[* [`Quat:normalize`](lua://lovr_quat.normalize)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[@return number length]]
	function Quat_class:length() return 0 end

	--[[https://lovr.org/docs/Quat:mul  ]]
	--[[Multiply a quaternion by another quaternion or a vector.  ]]
	--[[### See also]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[@param r lovr_quat]]
	--[[@return lovr_quat self]]
	--[[@overload fun(self: lovr_quat, v3: lovr_vec3): lovr_vec3]]
	function Quat_class:mul(r) return Quat_class end

	--[[https://lovr.org/docs/Quat:normalize  ]]
	--[[Normalize the length of the quaternion to 1.  ]]
	--[[### See also]]
	--[[* [`Quat:length`](lua://lovr_quat.length)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[@return lovr_quat self]]
	function Quat_class:normalize() return Quat_class end

	--[[https://lovr.org/docs/Quat:set  ]]
	--[[Set the components of the quaternion.  ]]
	--[[### See also]]
	--[[* [`Quat:unpack`](lua://lovr_quat.unpack)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`0`]]
	--[[@param az? number default=`0`]]
	--[[@param raw? boolean default=`false`]]
	--[[@return lovr_quat self]]
	--[[@overload fun(self: lovr_quat, r: lovr_quat): lovr_quat]]
	--[[@overload fun(self: lovr_quat, v: lovr_vec3): lovr_quat]]
	--[[@overload fun(self: lovr_quat, v: lovr_vec3, u: lovr_vec3): lovr_quat]]
	--[[@overload fun(self: lovr_quat, m: lovr_mat4): lovr_quat]]
	--[[@overload fun(self: lovr_quat): lovr_quat]]
	function Quat_class:set(angle, ax, ay, az, raw) return Quat_class end

	--[[https://lovr.org/docs/Quat:slerp  ]]
	--[[Moves this quaternion some amount towards another one.  ]]
	--[[### See also]]
	--[[* [`Vec3:lerp`](lua://lovr_vec3.lerp)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[@param r lovr_quat]]
	--[[@param t number]]
	--[[@return lovr_quat self]]
	function Quat_class:slerp(r, t) return Quat_class end

	--[[https://lovr.org/docs/Quat:unpack  ]]
	--[[Get the components of the quaternion.  ]]
	--[[### See also]]
	--[[* [`Quat:set`](lua://lovr_quat.set)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[@param raw? boolean default=`false`]]
	--[[@return number a]]
	--[[@return number b]]
	--[[@return number c]]
	--[[@return number d]]
	function Quat_class:unpack(raw) return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/lovr.math.quat  ]]
	--[[Create a temporary Quat.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newQuat`](lua://lovr.math.newQuat)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`0`]]
	--[[@param az? number default=`0`]]
	--[[@param raw? boolean default=`false`]]
	--[[@return lovr_quat q]]
	--[[@overload fun(r: lovr_quat): lovr_quat]]
	--[[@overload fun(v: lovr_vec3): lovr_quat]]
	--[[@overload fun(v: lovr_vec3, u: lovr_vec3): lovr_quat]]
	--[[@overload fun(m: lovr_mat4): lovr_quat]]
	--[[@overload fun(): lovr_quat]]
	function lovr.math.quat(angle, ax, ay, az, raw) return Quat_class end

	--[[https://lovr.org/docs/quat  ]]
	--[[Create a temporary Quat.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newQuat`](lua://lovr.math.newQuat)]]
	--[[* [`Quat`](lua://lovr_quat)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param angle? number default=`0`]]
	--[[@param ax? number default=`0`]]
	--[[@param ay? number default=`0`]]
	--[[@param az? number default=`0`]]
	--[[@param raw? boolean default=`false`]]
	--[[@return lovr_quat q]]
	--[[@overload fun(r: lovr_quat): lovr_quat]]
	--[[@overload fun(v: lovr_vec3): lovr_quat]]
	--[[@overload fun(v: lovr_vec3, u: lovr_vec3): lovr_quat]]
	--[[@overload fun(m: lovr_mat4): lovr_quat]]
	--[[@overload fun(): lovr_quat]]
	function quat(angle, ax, ay, az, raw) return Quat_class end

	--[[https://lovr.org/docs/RandomGenerator  ]]
	--[[A pseudo-random number generator.  ]]
	--[[@class lovr_random_generator: lovr_object]]

	--[[https://lovr.org/docs/RandomGenerator:getSeed  ]]
	--[[Get the seed value of the RandomGenerator.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newRandomGenerator`](lua://lovr.math.newRandomGenerator)]]
	--[[* [`RandomGenerator`](lua://lovr_randomGenerator)]]
	--[[@return number low]]
	--[[@return number high]]
	function RandomGenerator_class:getSeed() return 0, 0 end

	--[[https://lovr.org/docs/RandomGenerator:getState  ]]
	--[[Get the current state of the RandomGenerator.  ]]
	--[[### See also]]
	--[[* [`RandomGenerator`](lua://lovr_randomGenerator)]]
	--[[@return string state]]
	function RandomGenerator_class:getState() return "" end

	--[[https://lovr.org/docs/RandomGenerator:random  ]]
	--[[Get a random number.  ]]
	--[[### See also]]
	--[[* [`lovr.math.random`](lua://lovr.math.random)]]
	--[[* [`RandomGenerator:randomNormal`](lua://lovr_randomGenerator.randomNormal)]]
	--[[* [`RandomGenerator`](lua://lovr_randomGenerator)]]
	--[[@return number x]]
	--[[@overload fun(self: lovr_random_generator, high: number): number]]
	--[[@overload fun(self: lovr_random_generator, low: number, high: number): number]]
	function RandomGenerator_class:random() return 0 end

	--[[https://lovr.org/docs/RandomGenerator:randomNormal  ]]
	--[[Get a random number from a normal distribution.  ]]
	--[[### See also]]
	--[[* [`lovr.math.randomNormal`](lua://lovr.math.randomNormal)]]
	--[[* [`RandomGenerator:random`](lua://lovr_randomGenerator.random)]]
	--[[* [`RandomGenerator`](lua://lovr_randomGenerator)]]
	--[[@param sigma? number default=`1`]]
	--[[@param mu? number default=`0`]]
	--[[@return number x]]
	function RandomGenerator_class:randomNormal(sigma, mu) return 0 end

	--[[https://lovr.org/docs/RandomGenerator:setSeed  ]]
	--[[Reinitialize the RandomGenerator with a new seed.  ]]
	--[[### See also]]
	--[[* [`RandomGenerator`](lua://lovr_randomGenerator)]]
	--[[@param seed number]]
	--[[@overload fun(self: lovr_random_generator, low: number, high: number)]]
	function RandomGenerator_class:setSeed(seed) end

	--[[https://lovr.org/docs/RandomGenerator:setState  ]]
	--[[Set the state of the RandomGenerator.  ]]
	--[[### See also]]
	--[[* [`RandomGenerator`](lua://lovr_randomGenerator)]]
	--[[@param state string]]
	function RandomGenerator_class:setState(state) end

	--[[https://lovr.org/docs/lovr.math.random  ]]
	--[[Get a random number.  ]]
	--[[### See also]]
	--[[* [`lovr.math.randomNormal`](lua://lovr.math.randomNormal)]]
	--[[* [`RandomGenerator`](lua://lovr_randomGenerator)]]
	--[[* [`lovr.math.noise`](lua://lovr.math.noise)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@return number x]]
	--[[@overload fun(high: number): number]]
	--[[@overload fun(low: number, high: number): number]]
	function lovr.math.random() return 0 end

	--[[https://lovr.org/docs/lovr.math.randomNormal  ]]
	--[[Get a random number from a normal distribution.  ]]
	--[[### See also]]
	--[[* [`lovr.math.random`](lua://lovr.math.random)]]
	--[[* [`RandomGenerator`](lua://lovr_randomGenerator)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param sigma? number default=`1`]]
	--[[@param mu? number default=`0`]]
	--[[@return number x]]
	function lovr.math.randomNormal(sigma, mu) return 0 end

	--[[https://lovr.org/docs/lovr.math.setRandomSeed  ]]
	--[[Set the random seed.  ]]
	--[[### See also]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param seed number]]
	function lovr.math.setRandomSeed(seed) end

	--[[https://lovr.org/docs/Vec2  ]]
	--[[A 2D vector.  ]]
	--[[@class lovr_vec2: lovr_object]]

	--[[https://lovr.org/docs/Vec2:add  ]]
	--[[Add a vector or a number to the vector.  ]]
	--[[### See also]]
	--[[* [`Vec2:sub`](lua://lovr_vec2.sub)]]
	--[[* [`Vec2:mul`](lua://lovr_vec2.mul)]]
	--[[* [`Vec2:div`](lua://lovr_vec2.div)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param u lovr_vec2]]
	--[[@return lovr_vec2 self]]
	--[[@overload fun(self: lovr_vec2, x: number, y?: number): lovr_vec2]]
	function Vec2_class:add(u) return Vec2_class end

	--[[https://lovr.org/docs/Vec2:angle  ]]
	--[[Get the angle to another vector.  ]]
	--[[### See also]]
	--[[* [`Vec2:distance`](lua://lovr_vec2.distance)]]
	--[[* [`Vec2:length`](lua://lovr_vec2.length)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param u lovr_vec2]]
	--[[@return number angle]]
	--[[@overload fun(self: lovr_vec2, x: number, y: number): number]]
	function Vec2_class:angle(u) return 0 end

	--[[https://lovr.org/docs/Vec2:distance  ]]
	--[[Get the distance to another vector.  ]]
	--[[### See also]]
	--[[* [`Vec2:angle`](lua://lovr_vec2.angle)]]
	--[[* [`Vec2:length`](lua://lovr_vec2.length)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param u lovr_vec2]]
	--[[@return number distance]]
	--[[@overload fun(self: lovr_vec2, x: number, y: number): number]]
	function Vec2_class:distance(u) return 0 end

	--[[https://lovr.org/docs/Vec2:div  ]]
	--[[Divides the vector by a vector or a number.  ]]
	--[[### See also]]
	--[[* [`Vec2:add`](lua://lovr_vec2.add)]]
	--[[* [`Vec2:sub`](lua://lovr_vec2.sub)]]
	--[[* [`Vec2:mul`](lua://lovr_vec2.mul)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param u lovr_vec2]]
	--[[@return lovr_vec2 self]]
	--[[@overload fun(self: lovr_vec2, x: number, y?: number): lovr_vec2]]
	function Vec2_class:div(u) return Vec2_class end

	--[[https://lovr.org/docs/Vec2:dot  ]]
	--[[Get the dot product with another vector.  ]]
	--[[### See also]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param u lovr_vec2]]
	--[[@return number dot]]
	--[[@overload fun(self: lovr_vec2, x: number, y: number): number]]
	function Vec2_class:dot(u) return 0 end

	--[[https://lovr.org/docs/Vec2:equals  ]]
	--[[Check if a vector equals another vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:equals`](lua://lovr_vec3.equals)]]
	--[[* [`Vec4:equals`](lua://lovr_vec4.equals)]]
	--[[* [`Quat:equals`](lua://lovr_quat.equals)]]
	--[[* [`Mat4:equals`](lua://lovr_mat4.equals)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param u lovr_vec2]]
	--[[@return boolean equal]]
	--[[@overload fun(self: lovr_vec2, x: number, y: number): boolean]]
	function Vec2_class:equals(u) return false end

	--[[https://lovr.org/docs/Vec2:length  ]]
	--[[Get the length of the vector.  ]]
	--[[### See also]]
	--[[* [`Vec2:normalize`](lua://lovr_vec2.normalize)]]
	--[[* [`Vec2:distance`](lua://lovr_vec2.distance)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@return number length]]
	function Vec2_class:length() return 0 end

	--[[https://lovr.org/docs/Vec2:lerp  ]]
	--[[Moves this vector some amount towards another one.  ]]
	--[[### See also]]
	--[[* [`Quat:slerp`](lua://lovr_quat.slerp)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param u lovr_vec2]]
	--[[@param t number]]
	--[[@return lovr_vec2 self]]
	--[[@overload fun(self: lovr_vec2, x: number, y: number, t: number): lovr_vec2]]
	function Vec2_class:lerp(u, t) return Vec2_class end

	--[[https://lovr.org/docs/Vec2:mul  ]]
	--[[Multiply the vector by a vector or a number.  ]]
	--[[### See also]]
	--[[* [`Vec2:add`](lua://lovr_vec2.add)]]
	--[[* [`Vec2:sub`](lua://lovr_vec2.sub)]]
	--[[* [`Vec2:div`](lua://lovr_vec2.div)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param u lovr_vec2]]
	--[[@return lovr_vec2 self]]
	--[[@overload fun(self: lovr_vec2, x: number, y?: number): lovr_vec2]]
	function Vec2_class:mul(u) return Vec2_class end

	--[[https://lovr.org/docs/Vec2:normalize  ]]
	--[[Normalize the length of the vector to 1.  ]]
	--[[### See also]]
	--[[* [`Vec2:length`](lua://lovr_vec2.length)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@return lovr_vec2 self]]
	function Vec2_class:normalize() return Vec2_class end

	--[[https://lovr.org/docs/Vec2:set  ]]
	--[[Set the components of the vector.  ]]
	--[[### See also]]
	--[[* [`Vec2:unpack`](lua://lovr_vec2.unpack)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@return lovr_vec2 v]]
	--[[@overload fun(self: lovr_vec2, u: lovr_vec2): lovr_vec2]]
	function Vec2_class:set(x, y) return Vec2_class end

	--[[https://lovr.org/docs/Vec2:sub  ]]
	--[[Subtract a vector or a number from the vector.  ]]
	--[[### See also]]
	--[[* [`Vec2:add`](lua://lovr_vec2.add)]]
	--[[* [`Vec2:mul`](lua://lovr_vec2.mul)]]
	--[[* [`Vec2:div`](lua://lovr_vec2.div)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@param u lovr_vec2]]
	--[[@return lovr_vec2 self]]
	--[[@overload fun(self: lovr_vec2, x: number, y?: number): lovr_vec2]]
	function Vec2_class:sub(u) return Vec2_class end

	--[[https://lovr.org/docs/Vec2:unpack  ]]
	--[[Get the components of the vector.  ]]
	--[[### See also]]
	--[[* [`Vec2:set`](lua://lovr_vec2.set)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[@return number x]]
	--[[@return number y]]
	function Vec2_class:unpack() return 0, 0 end

	--[[### See also]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	Vec2_class.x = 0.0

	--[[### See also]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	Vec2_class.y = 0.0

	--[[https://lovr.org/docs/lovr.math.vec2  ]]
	--[[Create a temporary Vec2.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newVec2`](lua://lovr.math.newVec2)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@return lovr_vec2 v]]
	--[[@overload fun(u: lovr_vec2): lovr_vec2]]
	function lovr.math.vec2(x, y) return Vec2_class end

	--[[https://lovr.org/docs/vec2  ]]
	--[[Create a temporary Vec2.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newVec2`](lua://lovr.math.newVec2)]]
	--[[* [`Vec2`](lua://lovr_vec2)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@return lovr_vec2 v]]
	--[[@overload fun(u: lovr_vec2): lovr_vec2]]
	function vec2(x, y) return Vec2_class end

	--[[https://lovr.org/docs/Vec3  ]]
	--[[A 3D vector.  ]]
	--[[@class lovr_vec3: lovr_object]]

	--[[https://lovr.org/docs/Vec3:add  ]]
	--[[Add a vector or a number to the vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:sub`](lua://lovr_vec3.sub)]]
	--[[* [`Vec3:mul`](lua://lovr_vec3.mul)]]
	--[[* [`Vec3:div`](lua://lovr_vec3.div)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@return lovr_vec3 self]]
	--[[@overload fun(self: lovr_vec3, x: number, y?: number, z?: number): lovr_vec3]]
	function Vec3_class:add(u) return Vec3_class end

	--[[https://lovr.org/docs/Vec3:angle  ]]
	--[[Get the angle to another vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:distance`](lua://lovr_vec3.distance)]]
	--[[* [`Vec3:length`](lua://lovr_vec3.length)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@return number angle]]
	--[[@overload fun(self: lovr_vec3, x: number, y: number, z: number): number]]
	function Vec3_class:angle(u) return 0 end

	--[[https://lovr.org/docs/Vec3:cross  ]]
	--[[Get the cross product with another vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:dot`](lua://lovr_vec3.dot)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@return lovr_vec3 self]]
	--[[@overload fun(self: lovr_vec3, x: number, y: number, z: number): lovr_vec3]]
	function Vec3_class:cross(u) return Vec3_class end

	--[[https://lovr.org/docs/Vec3:distance  ]]
	--[[Get the distance to another vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:angle`](lua://lovr_vec3.angle)]]
	--[[* [`Vec3:length`](lua://lovr_vec3.length)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@return number distance]]
	--[[@overload fun(self: lovr_vec3, x: number, y: number, z: number): number]]
	function Vec3_class:distance(u) return 0 end

	--[[https://lovr.org/docs/Vec3:div  ]]
	--[[Divides the vector by a vector or a number.  ]]
	--[[### See also]]
	--[[* [`Vec3:add`](lua://lovr_vec3.add)]]
	--[[* [`Vec3:sub`](lua://lovr_vec3.sub)]]
	--[[* [`Vec3:mul`](lua://lovr_vec3.mul)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@return lovr_vec3 self]]
	--[[@overload fun(self: lovr_vec3, x: number, y?: number, z?: number): lovr_vec3]]
	function Vec3_class:div(u) return Vec3_class end

	--[[https://lovr.org/docs/Vec3:dot  ]]
	--[[Get the dot product with another vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:cross`](lua://lovr_vec3.cross)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@return number dot]]
	--[[@overload fun(self: lovr_vec3, x: number, y: number, z: number): number]]
	function Vec3_class:dot(u) return 0 end

	--[[https://lovr.org/docs/Vec3:equals  ]]
	--[[Check if a vector equals another vector.  ]]
	--[[### See also]]
	--[[* [`Vec2:equals`](lua://lovr_vec2.equals)]]
	--[[* [`Vec4:equals`](lua://lovr_vec4.equals)]]
	--[[* [`Quat:equals`](lua://lovr_quat.equals)]]
	--[[* [`Mat4:equals`](lua://lovr_mat4.equals)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@return boolean equal]]
	--[[@overload fun(self: lovr_vec3, x: number, y: number, z: number): boolean]]
	function Vec3_class:equals(u) return false end

	--[[https://lovr.org/docs/Vec3:length  ]]
	--[[Get the length of the vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:normalize`](lua://lovr_vec3.normalize)]]
	--[[* [`Vec3:distance`](lua://lovr_vec3.distance)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@return number length]]
	function Vec3_class:length() return 0 end

	--[[https://lovr.org/docs/Vec3:lerp  ]]
	--[[Moves this vector some amount towards another one.  ]]
	--[[### See also]]
	--[[* [`Quat:slerp`](lua://lovr_quat.slerp)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@param t number]]
	--[[@return lovr_vec3 self]]
	--[[@overload fun(self: lovr_vec3, x: number, y: number, z: number, t: number): lovr_vec3]]
	function Vec3_class:lerp(u, t) return Vec3_class end

	--[[https://lovr.org/docs/Vec3:mul  ]]
	--[[Multiply the vector by a vector or a number.  ]]
	--[[### See also]]
	--[[* [`Vec3:add`](lua://lovr_vec3.add)]]
	--[[* [`Vec3:sub`](lua://lovr_vec3.sub)]]
	--[[* [`Vec3:div`](lua://lovr_vec3.div)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@return lovr_vec3 self]]
	--[[@overload fun(self: lovr_vec3, x: number, y?: number, z?: number): lovr_vec3]]
	function Vec3_class:mul(u) return Vec3_class end

	--[[https://lovr.org/docs/Vec3:normalize  ]]
	--[[Normalize the length of the vector to 1.  ]]
	--[[### See also]]
	--[[* [`Vec3:length`](lua://lovr_vec3.length)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@return lovr_vec3 self]]
	function Vec3_class:normalize() return Vec3_class end

	--[[https://lovr.org/docs/Vec3:rotate  ]]
	--[[Apply a rotation to the vector.  ]]
	--[[### See also]]
	--[[* [`Quat:mul`](lua://lovr_quat.mul)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param q lovr_quat]]
	--[[@return lovr_vec3 self]]
	--[[@overload fun(self: lovr_vec3, angle: number, ax: number, ay: number, az: number): lovr_vec3]]
	function Vec3_class:rotate(q) return Vec3_class end

	--[[https://lovr.org/docs/Vec3:set  ]]
	--[[Set the components of the vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:unpack`](lua://lovr_vec3.unpack)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@return lovr_vec3 v]]
	--[[@overload fun(self: lovr_vec3, u: lovr_vec3): lovr_vec3]]
	--[[@overload fun(self: lovr_vec3, q: lovr_quat): lovr_vec3]]
	--[[@overload fun(self: lovr_vec3, m: lovr_mat4): lovr_vec3]]
	function Vec3_class:set(x, y, z) return Vec3_class end

	--[[https://lovr.org/docs/Vec3:sub  ]]
	--[[Subtract a vector or a number from the vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:add`](lua://lovr_vec3.add)]]
	--[[* [`Vec3:mul`](lua://lovr_vec3.mul)]]
	--[[* [`Vec3:div`](lua://lovr_vec3.div)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param u lovr_vec3]]
	--[[@return lovr_vec3 self]]
	--[[@overload fun(self: lovr_vec3, x: number, y?: number, z?: number): lovr_vec3]]
	function Vec3_class:sub(u) return Vec3_class end

	--[[https://lovr.org/docs/Vec3:transform  ]]
	--[[Apply a transform to the vector.  ]]
	--[[### See also]]
	--[[* [`Mat4:mul`](lua://lovr_mat4.mul)]]
	--[[* [`Vec4:transform`](lua://lovr_vec4.transform)]]
	--[[* [`Vec3:rotate`](lua://lovr_vec3.rotate)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@param m lovr_mat4]]
	--[[@return lovr_vec3 self]]
	--[[@overload fun(self: lovr_vec3, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number): lovr_vec3]]
	--[[@overload fun(self: lovr_vec3, translation: lovr_vec3, scale?: number, rotation: lovr_quat): lovr_vec3]]
	function Vec3_class:transform(m) return Vec3_class end

	--[[https://lovr.org/docs/Vec3:unpack  ]]
	--[[Get the components of the vector.  ]]
	--[[### See also]]
	--[[* [`Vec3:set`](lua://lovr_vec3.set)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Vec3_class:unpack() return 0, 0, 0 end

	--[[### See also]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	Vec3_class.x = 0.0

	--[[### See also]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	Vec3_class.y = 0.0

	--[[### See also]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	Vec3_class.z = 0.0

	--[[https://lovr.org/docs/lovr.math.vec3  ]]
	--[[Create a temporary Vec3.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newVec3`](lua://lovr.math.newVec3)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@return lovr_vec3 v]]
	--[[@overload fun(u: lovr_vec3): lovr_vec3]]
	--[[@overload fun(m: lovr_mat4): lovr_vec3]]
	--[[@overload fun(q: lovr_quat): lovr_vec3]]
	function lovr.math.vec3(x, y, z) return Vec3_class end

	--[[https://lovr.org/docs/vec3  ]]
	--[[Create a temporary Vec3.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newVec3`](lua://lovr.math.newVec3)]]
	--[[* [`Vec3`](lua://lovr_vec3)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@return lovr_vec3 v]]
	--[[@overload fun(u: lovr_vec3): lovr_vec3]]
	--[[@overload fun(m: lovr_mat4): lovr_vec3]]
	--[[@overload fun(q: lovr_quat): lovr_vec3]]
	function vec3(x, y, z) return Vec3_class end

	--[[https://lovr.org/docs/Vec4  ]]
	--[[A 4D vector.  ]]
	--[[@class lovr_vec4: lovr_object]]

	--[[https://lovr.org/docs/Vec4:add  ]]
	--[[Add a vector or a number to the vector.  ]]
	--[[### See also]]
	--[[* [`Vec4:sub`](lua://lovr_vec4.sub)]]
	--[[* [`Vec4:mul`](lua://lovr_vec4.mul)]]
	--[[* [`Vec4:div`](lua://lovr_vec4.div)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param u lovr_vec4]]
	--[[@return lovr_vec4 self]]
	--[[@overload fun(self: lovr_vec4, x: number, y?: number, z?: number, w?: number): lovr_vec4]]
	function Vec4_class:add(u) return Vec4_class end

	--[[https://lovr.org/docs/Vec4:angle  ]]
	--[[Get the angle to another vector.  ]]
	--[[### See also]]
	--[[* [`Vec4:distance`](lua://lovr_vec4.distance)]]
	--[[* [`Vec4:length`](lua://lovr_vec4.length)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param u lovr_vec4]]
	--[[@return number angle]]
	--[[@overload fun(self: lovr_vec4, x: number, y: number, z: number, w: number): number]]
	function Vec4_class:angle(u) return 0 end

	--[[https://lovr.org/docs/Vec4:distance  ]]
	--[[Get the distance to another vector.  ]]
	--[[### See also]]
	--[[* [`Vec4:angle`](lua://lovr_vec4.angle)]]
	--[[* [`Vec4:length`](lua://lovr_vec4.length)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param u lovr_vec4]]
	--[[@return number distance]]
	--[[@overload fun(self: lovr_vec4, x: number, y: number, z: number, w: number): number]]
	function Vec4_class:distance(u) return 0 end

	--[[https://lovr.org/docs/Vec4:div  ]]
	--[[Divides the vector by a vector or a number.  ]]
	--[[### See also]]
	--[[* [`Vec4:add`](lua://lovr_vec4.add)]]
	--[[* [`Vec4:sub`](lua://lovr_vec4.sub)]]
	--[[* [`Vec4:mul`](lua://lovr_vec4.mul)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param u lovr_vec4]]
	--[[@return lovr_vec4 self]]
	--[[@overload fun(self: lovr_vec4, x: number, y?: number, z?: number, w?: number): lovr_vec4]]
	function Vec4_class:div(u) return Vec4_class end

	--[[https://lovr.org/docs/Vec4:dot  ]]
	--[[Get the dot product with another vector.  ]]
	--[[### See also]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param u lovr_vec4]]
	--[[@return number dot]]
	--[[@overload fun(self: lovr_vec4, x: number, y: number, z: number, w: number): number]]
	function Vec4_class:dot(u) return 0 end

	--[[https://lovr.org/docs/Vec4:equals  ]]
	--[[Check if a vector equals another vector.  ]]
	--[[### See also]]
	--[[* [`Vec2:equals`](lua://lovr_vec2.equals)]]
	--[[* [`Vec3:equals`](lua://lovr_vec3.equals)]]
	--[[* [`Quat:equals`](lua://lovr_quat.equals)]]
	--[[* [`Mat4:equals`](lua://lovr_mat4.equals)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param u lovr_vec4]]
	--[[@return boolean equal]]
	--[[@overload fun(self: lovr_vec4, x: number, y: number, z: number, w: number): boolean]]
	function Vec4_class:equals(u) return false end

	--[[https://lovr.org/docs/Vec4:length  ]]
	--[[Get the length of the vector.  ]]
	--[[### See also]]
	--[[* [`Vec4:normalize`](lua://lovr_vec4.normalize)]]
	--[[* [`Vec4:distance`](lua://lovr_vec4.distance)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@return number length]]
	function Vec4_class:length() return 0 end

	--[[https://lovr.org/docs/Vec4:lerp  ]]
	--[[Moves this vector some amount towards another one.  ]]
	--[[### See also]]
	--[[* [`Quat:slerp`](lua://lovr_quat.slerp)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param u lovr_vec4]]
	--[[@param t number]]
	--[[@return lovr_vec4 self]]
	--[[@overload fun(self: lovr_vec4, x: number, y: number, z: number, w: number, t: number): lovr_vec4]]
	function Vec4_class:lerp(u, t) return Vec4_class end

	--[[https://lovr.org/docs/Vec4:mul  ]]
	--[[Multiply the vector by a vector or a number.  ]]
	--[[### See also]]
	--[[* [`Vec4:add`](lua://lovr_vec4.add)]]
	--[[* [`Vec4:sub`](lua://lovr_vec4.sub)]]
	--[[* [`Vec4:div`](lua://lovr_vec4.div)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param u lovr_vec4]]
	--[[@return lovr_vec4 self]]
	--[[@overload fun(self: lovr_vec4, x: number, y?: number, z?: number, w?: number): lovr_vec4]]
	function Vec4_class:mul(u) return Vec4_class end

	--[[https://lovr.org/docs/Vec4:normalize  ]]
	--[[Normalize the length of the vector to 1.  ]]
	--[[### See also]]
	--[[* [`Vec4:length`](lua://lovr_vec4.length)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@return lovr_vec4 self]]
	function Vec4_class:normalize() return Vec4_class end

	--[[https://lovr.org/docs/Vec4:set  ]]
	--[[Set the components of the vector.  ]]
	--[[### See also]]
	--[[* [`Vec4:unpack`](lua://lovr_vec4.unpack)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@param w? number default=`x`]]
	--[[@return lovr_vec4 v]]
	--[[@overload fun(self: lovr_vec4, u: lovr_vec4): lovr_vec4]]
	function Vec4_class:set(x, y, z, w) return Vec4_class end

	--[[https://lovr.org/docs/Vec4:sub  ]]
	--[[Subtract a vector or a number from the vector.  ]]
	--[[### See also]]
	--[[* [`Vec4:add`](lua://lovr_vec4.add)]]
	--[[* [`Vec4:mul`](lua://lovr_vec4.mul)]]
	--[[* [`Vec4:div`](lua://lovr_vec4.div)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param u lovr_vec4]]
	--[[@return lovr_vec4 self]]
	--[[@overload fun(self: lovr_vec4, x: number, y?: number, z?: number, w?: number): lovr_vec4]]
	function Vec4_class:sub(u) return Vec4_class end

	--[[https://lovr.org/docs/Vec4:transform  ]]
	--[[Apply a transform to the vector.  ]]
	--[[### See also]]
	--[[* [`Mat4:mul`](lua://lovr_mat4.mul)]]
	--[[* [`Vec3:transform`](lua://lovr_vec3.transform)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@param m lovr_mat4]]
	--[[@return lovr_vec4 self]]
	--[[@overload fun(self: lovr_vec4, x?: number, y?: number, z?: number, scale?: number, angle?: number, ax?: number, ay?: number, az?: number): lovr_vec4]]
	--[[@overload fun(self: lovr_vec4, translation: lovr_vec3, scale?: number, rotation: lovr_quat): lovr_vec4]]
	function Vec4_class:transform(m) return Vec4_class end

	--[[https://lovr.org/docs/Vec4:unpack  ]]
	--[[Get the components of the vector.  ]]
	--[[### See also]]
	--[[* [`Vec4:set`](lua://lovr_vec4.set)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number w]]
	function Vec4_class:unpack() return 0, 0, 0, 0 end

	--[[### See also]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	Vec4_class.x = 0.0

	--[[### See also]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	Vec4_class.y = 0.0

	--[[### See also]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	Vec4_class.z = 0.0

	--[[### See also]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	Vec4_class.w = 0.0

	--[[https://lovr.org/docs/lovr.math.vec4  ]]
	--[[Create a temporary Vec4.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newVec4`](lua://lovr.math.newVec4)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@param w? number default=`x`]]
	--[[@return lovr_vec4 v]]
	--[[@overload fun(u: lovr_vec4): lovr_vec4]]
	function lovr.math.vec4(x, y, z, w) return Vec4_class end

	--[[https://lovr.org/docs/vec4  ]]
	--[[Create a temporary Vec4.  ]]
	--[[### See also]]
	--[[* [`lovr.math.newVec4`](lua://lovr.math.newVec4)]]
	--[[* [`Vec4`](lua://lovr_vec4)]]
	--[[* [`Vectors`](lua://lovr_vectors)]]
	--[[* [`lovr.math`](lua://lovr.math)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`x`]]
	--[[@param z? number default=`x`]]
	--[[@param w? number default=`x`]]
	--[[@return lovr_vec4 v]]
	--[[@overload fun(u: lovr_vec4): lovr_vec4]]
	function vec4(x, y, z, w) return Vec4_class end

	--[[https://lovr.org/docs/Vectors  ]]
	--[[What is your vector victor.  ]]
	--[[@class lovr_vectors: lovr_object]]


	--[[https://lovr.org/docs/lovr.physics  ]]
	--[[@class lovr_physics]]
	lovr.physics = {}

	--[[https://lovr.org/docs/BallJoint  ]]
	--[[A ball and socket joint.  ]]
	--[[@class lovr_ball_joint: lovr_object]]

	--[[https://lovr.org/docs/BoxShape  ]]
	--[[A box Shape.  ]]
	--[[@class lovr_box_shape: lovr_object]]

	--[[https://lovr.org/docs/BoxShape:getDimensions  ]]
	--[[Get the dimensions of the BoxShape.  ]]
	--[[### See also]]
	--[[* [`BoxShape`](lua://lovr_boxShape)]]
	--[[@return number width]]
	--[[@return number height]]
	--[[@return number depth]]
	function BoxShape_class:getDimensions() return 0, 0, 0 end

	--[[https://lovr.org/docs/BoxShape:setDimensions  ]]
	--[[Set the dimensions of the BoxShape.  ]]
	--[[### See also]]
	--[[* [`BoxShape`](lua://lovr_boxShape)]]
	--[[@param width number]]
	--[[@param height number]]
	--[[@param depth number]]
	function BoxShape_class:setDimensions(width, height, depth) end

	--[[https://lovr.org/docs/CapsuleShape  ]]
	--[[A capsule Shape.  ]]
	--[[@class lovr_capsule_shape: lovr_object]]

	--[[https://lovr.org/docs/CapsuleShape:getLength  ]]
	--[[Get the length of the CapsuleShape.  ]]
	--[[### See also]]
	--[[* [`CapsuleShape:getRadius`](lua://lovr_capsuleShape.getRadius)]]
	--[[* [`CapsuleShape:setRadius`](lua://lovr_capsuleShape.setRadius)]]
	--[[* [`CapsuleShape`](lua://lovr_capsuleShape)]]
	--[[@return number length]]
	function CapsuleShape_class:getLength() return 0 end

	--[[https://lovr.org/docs/CapsuleShape:getRadius  ]]
	--[[Get the radius of the CapsuleShape.  ]]
	--[[### See also]]
	--[[* [`CapsuleShape:getLength`](lua://lovr_capsuleShape.getLength)]]
	--[[* [`CapsuleShape:setLength`](lua://lovr_capsuleShape.setLength)]]
	--[[* [`CapsuleShape`](lua://lovr_capsuleShape)]]
	--[[@return number radius]]
	function CapsuleShape_class:getRadius() return 0 end

	--[[https://lovr.org/docs/CapsuleShape:setLength  ]]
	--[[Set the length of the CapsuleShape.  ]]
	--[[### See also]]
	--[[* [`CapsuleShape:getRadius`](lua://lovr_capsuleShape.getRadius)]]
	--[[* [`CapsuleShape:setRadius`](lua://lovr_capsuleShape.setRadius)]]
	--[[* [`CapsuleShape`](lua://lovr_capsuleShape)]]
	--[[@param length number]]
	function CapsuleShape_class:setLength(length) end

	--[[https://lovr.org/docs/CapsuleShape:setRadius  ]]
	--[[Set the radius of the CapsuleShape.  ]]
	--[[### See also]]
	--[[* [`CapsuleShape:getLength`](lua://lovr_capsuleShape.getLength)]]
	--[[* [`CapsuleShape:setLength`](lua://lovr_capsuleShape.setLength)]]
	--[[* [`CapsuleShape`](lua://lovr_capsuleShape)]]
	--[[@param radius number]]
	function CapsuleShape_class:setRadius(radius) end

	--[[https://lovr.org/docs/Collider  ]]
	--[[A single object in a physics simulation.  ]]
	--[[@class lovr_collider: lovr_object]]

	--[[https://lovr.org/docs/Collider:addShape  ]]
	--[[Add a Shape to the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:removeShape`](lua://lovr_collider.removeShape)]]
	--[[* [`Collider:getShapes`](lua://lovr_collider.getShapes)]]
	--[[* [`Collider:getShape`](lua://lovr_collider.getShape)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param shape lovr_shape]]
	function Collider_class:addShape(shape) end

	--[[https://lovr.org/docs/Collider:applyAngularImpulse  ]]
	--[[Apply an angular impulse to the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyTorque`](lua://lovr_collider.applyTorque)]]
	--[[* [`Collider:applyForce`](lua://lovr_collider.applyForce)]]
	--[[* [`Collider:applyLinearImpulse`](lua://lovr_collider.applyLinearImpulse)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(self: lovr_collider, impulse: lovr_vec3)]]
	function Collider_class:applyAngularImpulse(x, y, z) end

	--[[https://lovr.org/docs/Collider:applyForce  ]]
	--[[Apply a force to the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyLinearImpulse`](lua://lovr_collider.applyLinearImpulse)]]
	--[[* [`Collider:applyTorque`](lua://lovr_collider.applyTorque)]]
	--[[* [`Collider:applyAngularImpulse`](lua://lovr_collider.applyAngularImpulse)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(self: lovr_collider, x: number, y: number, z: number, px: number, py: number, pz: number)]]
	--[[@overload fun(self: lovr_collider, force: lovr_vec3)]]
	--[[@overload fun(self: lovr_collider, force: lovr_vec3, position: lovr_vec3)]]
	function Collider_class:applyForce(x, y, z) end

	--[[https://lovr.org/docs/Collider:applyLinearImpulse  ]]
	--[[Apply a linear impulse to the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyForce`](lua://lovr_collider.applyForce)]]
	--[[* [`Collider:applyTorque`](lua://lovr_collider.applyTorque)]]
	--[[* [`Collider:applyAngularImpulse`](lua://lovr_collider.applyAngularImpulse)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(self: lovr_collider, x: number, y: number, z: number, px: number, py: number, pz: number)]]
	--[[@overload fun(self: lovr_collider, impulse: lovr_vec3)]]
	--[[@overload fun(self: lovr_collider, impulse: lovr_vec3, position: lovr_vec3)]]
	function Collider_class:applyLinearImpulse(x, y, z) end

	--[[https://lovr.org/docs/Collider:applyTorque  ]]
	--[[Apply torque to the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyAngularImpulse`](lua://lovr_collider.applyAngularImpulse)]]
	--[[* [`Collider:applyForce`](lua://lovr_collider.applyForce)]]
	--[[* [`Collider:applyLinearImpulse`](lua://lovr_collider.applyLinearImpulse)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(self: lovr_collider, torque: lovr_vec3)]]
	function Collider_class:applyTorque(x, y, z) end

	--[[https://lovr.org/docs/Collider:destroy  ]]
	--[[Destroy the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:isDestroyed`](lua://lovr_collider.isDestroyed)]]
	--[[* [`Collider:setEnabled`](lua://lovr_collider.setEnabled)]]
	--[[* [`World:destroy`](lua://lovr_world.destroy)]]
	--[[* [`Shape:destroy`](lua://lovr_shape.destroy)]]
	--[[* [`Joint:destroy`](lua://lovr_joint.destroy)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	function Collider_class:destroy() end

	--[[https://lovr.org/docs/Collider:getAABB  ]]
	--[[Get the Collider's axis aligned bounding box.  ]]
	--[[### See also]]
	--[[* [`Shape:getAABB`](lua://lovr_shape.getAABB)]]
	--[[* [`World:queryBox`](lua://lovr_world.queryBox)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number minx]]
	--[[@return number maxx]]
	--[[@return number miny]]
	--[[@return number maxy]]
	--[[@return number minz]]
	--[[@return number maxz]]
	function Collider_class:getAABB() return 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getAngularDamping  ]]
	--[[Get the angular damping of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getLinearDamping`](lua://lovr_collider.getLinearDamping)]]
	--[[* [`Collider:setLinearDamping`](lua://lovr_collider.setLinearDamping)]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Collider:setInertia`](lua://lovr_collider.setInertia)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number damping]]
	function Collider_class:getAngularDamping() return 0 end

	--[[https://lovr.org/docs/Collider:getAngularVelocity  ]]
	--[[Get the angular velocity of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getLinearVelocity`](lua://lovr_collider.getLinearVelocity)]]
	--[[* [`Collider:setLinearVelocity`](lua://lovr_collider.setLinearVelocity)]]
	--[[* [`Collider:applyTorque`](lua://lovr_collider.applyTorque)]]
	--[[* [`Collider:getOrientation`](lua://lovr_collider.getOrientation)]]
	--[[* [`Collider:setOrientation`](lua://lovr_collider.setOrientation)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number vx]]
	--[[@return number vy]]
	--[[@return number vz]]
	function Collider_class:getAngularVelocity() return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getAutomaticMass  ]]
	--[[Get whether automatic mass is enabled.  ]]
	--[[### See also]]
	--[[* [`Collider:resetMassData`](lua://lovr_collider.resetMassData)]]
	--[[* [`Collider:getMass`](lua://lovr_collider.getMass)]]
	--[[* [`Collider:setMass`](lua://lovr_collider.setMass)]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Collider:setInertia`](lua://lovr_collider.setInertia)]]
	--[[* [`Collider:getCenterOfMass`](lua://lovr_collider.getCenterOfMass)]]
	--[[* [`Collider:setCenterOfMass`](lua://lovr_collider.setCenterOfMass)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return boolean enabled]]
	function Collider_class:getAutomaticMass() return false end

	--[[https://lovr.org/docs/Collider:getCenterOfMass  ]]
	--[[Get the Collider's local center of mass.  ]]
	--[[### See also]]
	--[[* [`Shape:getCenterOfMass`](lua://lovr_shape.getCenterOfMass)]]
	--[[* [`Collider:getMass`](lua://lovr_collider.getMass)]]
	--[[* [`Collider:setMass`](lua://lovr_collider.setMass)]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Collider:setInertia`](lua://lovr_collider.setInertia)]]
	--[[* [`Collider:getAutomaticMass`](lua://lovr_collider.getAutomaticMass)]]
	--[[* [`Collider:setAutomaticMass`](lua://lovr_collider.setAutomaticMass)]]
	--[[* [`Collider:resetMassData`](lua://lovr_collider.resetMassData)]]
	--[[* [`Shape:getOffset`](lua://lovr_shape.getOffset)]]
	--[[* [`Shape:setOffset`](lua://lovr_shape.setOffset)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Collider_class:getCenterOfMass() return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getDegreesOfFreedom  ]]
	--[[Get the enabled translation/rotation axes.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return string translation]]
	--[[@return string rotation]]
	function Collider_class:getDegreesOfFreedom() return "", "" end

	--[[https://lovr.org/docs/Collider:getFriction  ]]
	--[[Get the friction of the Collider.  ]]
	--[[### See also]]
	--[[* [`Contact:getFriction`](lua://lovr_contact.getFriction)]]
	--[[* [`Contact:setFriction`](lua://lovr_contact.setFriction)]]
	--[[* [`Collider:getRestitution`](lua://lovr_collider.getRestitution)]]
	--[[* [`Collider:setRestitution`](lua://lovr_collider.setRestitution)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number friction]]
	function Collider_class:getFriction() return 0 end

	--[[https://lovr.org/docs/Collider:getGravityScale  ]]
	--[[Get the gravity scale of the Collider.  ]]
	--[[### See also]]
	--[[* [`World:getGravity`](lua://lovr_world.getGravity)]]
	--[[* [`World:setGravity`](lua://lovr_world.setGravity)]]
	--[[* [`Collider:getLinearDamping`](lua://lovr_collider.getLinearDamping)]]
	--[[* [`Collider:setLinearDamping`](lua://lovr_collider.setLinearDamping)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number scale]]
	function Collider_class:getGravityScale() return 0 end

	--[[https://lovr.org/docs/Collider:getInertia  ]]
	--[[Get the inertia of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getMass`](lua://lovr_collider.getMass)]]
	--[[* [`Collider:setMass`](lua://lovr_collider.setMass)]]
	--[[* [`Collider:getCenterOfMass`](lua://lovr_collider.getCenterOfMass)]]
	--[[* [`Collider:setCenterOfMass`](lua://lovr_collider.setCenterOfMass)]]
	--[[* [`Collider:getAutomaticMass`](lua://lovr_collider.getAutomaticMass)]]
	--[[* [`Collider:setAutomaticMass`](lua://lovr_collider.setAutomaticMass)]]
	--[[* [`Collider:resetMassData`](lua://lovr_collider.resetMassData)]]
	--[[* [`Shape:getInertia`](lua://lovr_shape.getInertia)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number dx]]
	--[[@return number dy]]
	--[[@return number dz]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Collider_class:getInertia() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getJoints  ]]
	--[[Get a list of Joints attached to the Collider.  ]]
	--[[### See also]]
	--[[* [`World:getJoints`](lua://lovr_world.getJoints)]]
	--[[* [`Joint:getColliders`](lua://lovr_joint.getColliders)]]
	--[[* [`Joint:destroy`](lua://lovr_joint.destroy)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return table<string,string|number> joints]]
	function Collider_class:getJoints() return {} end

	--[[https://lovr.org/docs/Collider:getLinearDamping  ]]
	--[[Get the linear damping of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getAngularDamping`](lua://lovr_collider.getAngularDamping)]]
	--[[* [`Collider:setAngularDamping`](lua://lovr_collider.setAngularDamping)]]
	--[[* [`Collider:getGravityScale`](lua://lovr_collider.getGravityScale)]]
	--[[* [`Collider:setGravityScale`](lua://lovr_collider.setGravityScale)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number damping]]
	function Collider_class:getLinearDamping() return 0 end

	--[[https://lovr.org/docs/Collider:getLinearVelocityFromLocalPoint  ]]
	--[[Get the linear velocity of a point on the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getLinearVelocity`](lua://lovr_collider.getLinearVelocity)]]
	--[[* [`Collider:getLinearVelocityFromWorldPoint`](lua://lovr_collider.getLinearVelocityFromWorldPoint)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@return number vx]]
	--[[@return number vy]]
	--[[@return number vz]]
	--[[@overload fun(self: lovr_collider, point: number): number, number, number]]
	function Collider_class:getLinearVelocityFromLocalPoint(x, y, z) return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getLinearVelocityFromWorldPoint  ]]
	--[[Get the linear velocity of the Collider at a world space point.  ]]
	--[[### See also]]
	--[[* [`Collider:getLinearVelocity`](lua://lovr_collider.getLinearVelocity)]]
	--[[* [`Collider:getLinearVelocityFromLocalPoint`](lua://lovr_collider.getLinearVelocityFromLocalPoint)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@return number vx]]
	--[[@return number vy]]
	--[[@return number vz]]
	--[[@overload fun(self: lovr_collider, point: lovr_vec3): number, number, number]]
	function Collider_class:getLinearVelocityFromWorldPoint(x, y, z) return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getLinearVelocity  ]]
	--[[Get the linear velocity of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyForce`](lua://lovr_collider.applyForce)]]
	--[[* [`Collider:getLinearVelocityFromLocalPoint`](lua://lovr_collider.getLinearVelocityFromLocalPoint)]]
	--[[* [`Collider:getLinearVelocityFromWorldPoint`](lua://lovr_collider.getLinearVelocityFromWorldPoint)]]
	--[[* [`Collider:getAngularVelocity`](lua://lovr_collider.getAngularVelocity)]]
	--[[* [`Collider:setAngularVelocity`](lua://lovr_collider.setAngularVelocity)]]
	--[[* [`Collider:getPosition`](lua://lovr_collider.getPosition)]]
	--[[* [`Collider:setPosition`](lua://lovr_collider.setPosition)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number vx]]
	--[[@return number vy]]
	--[[@return number vz]]
	function Collider_class:getLinearVelocity() return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getLocalPoint  ]]
	--[[Transform a point from world space to collider space.  ]]
	--[[### See also]]
	--[[* [`Collider:getWorldPoint`](lua://lovr_collider.getWorldPoint)]]
	--[[* [`Collider:getLocalVector`](lua://lovr_collider.getLocalVector)]]
	--[[* [`Collider:getWorldVector`](lua://lovr_collider.getWorldVector)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param wx number]]
	--[[@param wy number]]
	--[[@param wz number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@overload fun(self: lovr_collider, point: lovr_vec3): number, number, number]]
	function Collider_class:getLocalPoint(wx, wy, wz) return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getLocalVector  ]]
	--[[Transform a vector from world space to local space.  ]]
	--[[### See also]]
	--[[* [`Collider:getWorldVector`](lua://lovr_collider.getWorldVector)]]
	--[[* [`Collider:getLocalPoint`](lua://lovr_collider.getLocalPoint)]]
	--[[* [`Collider:getWorldPoint`](lua://lovr_collider.getWorldPoint)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param wx number]]
	--[[@param wy number]]
	--[[@param wz number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@overload fun(self: lovr_collider, vector: lovr_vec3): number, number, number]]
	function Collider_class:getLocalVector(wx, wy, wz) return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getMass  ]]
	--[[Get the mass of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Collider:setInertia`](lua://lovr_collider.setInertia)]]
	--[[* [`Collider:getCenterOfMass`](lua://lovr_collider.getCenterOfMass)]]
	--[[* [`Collider:setCenterOfMass`](lua://lovr_collider.setCenterOfMass)]]
	--[[* [`Collider:getAutomaticMass`](lua://lovr_collider.getAutomaticMass)]]
	--[[* [`Collider:setAutomaticMass`](lua://lovr_collider.setAutomaticMass)]]
	--[[* [`Collider:resetMassData`](lua://lovr_collider.resetMassData)]]
	--[[* [`Shape:getDensity`](lua://lovr_shape.getDensity)]]
	--[[* [`Shape:setDensity`](lua://lovr_shape.setDensity)]]
	--[[* [`Shape:getVolume`](lua://lovr_shape.getVolume)]]
	--[[* [`Shape:getMass`](lua://lovr_shape.getMass)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number mass]]
	function Collider_class:getMass() return 0 end

	--[[https://lovr.org/docs/Collider:getOrientation  ]]
	--[[Get the orientation of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyTorque`](lua://lovr_collider.applyTorque)]]
	--[[* [`Collider:getRawOrientation`](lua://lovr_collider.getRawOrientation)]]
	--[[* [`Collider:getAngularVelocity`](lua://lovr_collider.getAngularVelocity)]]
	--[[* [`Collider:setAngularVelocity`](lua://lovr_collider.setAngularVelocity)]]
	--[[* [`Collider:getPosition`](lua://lovr_collider.getPosition)]]
	--[[* [`Collider:setPosition`](lua://lovr_collider.setPosition)]]
	--[[* [`Collider:getPose`](lua://lovr_collider.getPose)]]
	--[[* [`Collider:setPose`](lua://lovr_collider.setPose)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Collider_class:getOrientation() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getPose  ]]
	--[[Get the pose of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getPosition`](lua://lovr_collider.getPosition)]]
	--[[* [`Collider:getOrientation`](lua://lovr_collider.getOrientation)]]
	--[[* [`Collider:getRawPose`](lua://lovr_collider.getRawPose)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Collider_class:getPose() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getPosition  ]]
	--[[Get the position of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyForce`](lua://lovr_collider.applyForce)]]
	--[[* [`Collider:getRawPosition`](lua://lovr_collider.getRawPosition)]]
	--[[* [`Collider:getLinearVelocity`](lua://lovr_collider.getLinearVelocity)]]
	--[[* [`Collider:setLinearVelocity`](lua://lovr_collider.setLinearVelocity)]]
	--[[* [`Collider:getOrientation`](lua://lovr_collider.getOrientation)]]
	--[[* [`Collider:setOrientation`](lua://lovr_collider.setOrientation)]]
	--[[* [`Collider:getPose`](lua://lovr_collider.getPose)]]
	--[[* [`Collider:setPose`](lua://lovr_collider.setPose)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Collider_class:getPosition() return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getRawOrientation  ]]
	--[[Get the raw orientation of the Collider, without any interpolation.  ]]
	--[[### See also]]
	--[[* [`Collider:getOrientation`](lua://lovr_collider.getOrientation)]]
	--[[* [`Collider:setOrientation`](lua://lovr_collider.setOrientation)]]
	--[[* [`Collider:getRawPosition`](lua://lovr_collider.getRawPosition)]]
	--[[* [`Collider:getPosition`](lua://lovr_collider.getPosition)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Collider_class:getRawOrientation() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getRawPose  ]]
	--[[Get the raw pose of the Collider, without any interpolation.  ]]
	--[[### See also]]
	--[[* [`Collider:getRawPosition`](lua://lovr_collider.getRawPosition)]]
	--[[* [`Collider:getRawOrientation`](lua://lovr_collider.getRawOrientation)]]
	--[[* [`Collider:getPose`](lua://lovr_collider.getPose)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Collider_class:getRawPose() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getRawPosition  ]]
	--[[Get the raw position of the Collider, without any interpolation.  ]]
	--[[### See also]]
	--[[* [`Collider:getPosition`](lua://lovr_collider.getPosition)]]
	--[[* [`Collider:setPosition`](lua://lovr_collider.setPosition)]]
	--[[* [`Collider:getRawOrientation`](lua://lovr_collider.getRawOrientation)]]
	--[[* [`Collider:getOrientation`](lua://lovr_collider.getOrientation)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Collider_class:getRawPosition() return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getRestitution  ]]
	--[[Get the bounciness of the Collider.  ]]
	--[[### See also]]
	--[[* [`Contact:getRestitution`](lua://lovr_contact.getRestitution)]]
	--[[* [`Contact:setRestitution`](lua://lovr_contact.setRestitution)]]
	--[[* [`Collider:getFriction`](lua://lovr_collider.getFriction)]]
	--[[* [`Collider:setFriction`](lua://lovr_collider.setFriction)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return number restitution]]
	function Collider_class:getRestitution() return 0 end

	--[[https://lovr.org/docs/Collider:getShape  ]]
	--[[Get the first Shape attached to the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getShapes`](lua://lovr_collider.getShapes)]]
	--[[* [`Collider:addShape`](lua://lovr_collider.addShape)]]
	--[[* [`Collider:removeShape`](lua://lovr_collider.removeShape)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return lovr_shape shape]]
	function Collider_class:getShape() return Shape_class end

	--[[https://lovr.org/docs/Collider:getShapes  ]]
	--[[Get a list of Shapes attached to the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getShape`](lua://lovr_collider.getShape)]]
	--[[* [`Collider:addShape`](lua://lovr_collider.addShape)]]
	--[[* [`Collider:removeShape`](lua://lovr_collider.removeShape)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return table<string,string|number> shapes]]
	function Collider_class:getShapes() return {} end

	--[[https://lovr.org/docs/Collider:getTag  ]]
	--[[Get the Collider's tag.  ]]
	--[[### See also]]
	--[[* [`World:getTags`](lua://lovr_world.getTags)]]
	--[[* [`World:disableCollisionBetween`](lua://lovr_world.disableCollisionBetween)]]
	--[[* [`World:enableCollisionBetween`](lua://lovr_world.enableCollisionBetween)]]
	--[[* [`World:isCollisionEnabledBetween`](lua://lovr_world.isCollisionEnabledBetween)]]
	--[[* [`lovr.physics.newWorld`](lua://lovr.physics.newWorld)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return string tag]]
	function Collider_class:getTag() return "" end

	--[[https://lovr.org/docs/Collider:getUserData  ]]
	--[[Get the Lua value associated with the Collider.  ]]
	--[[### See also]]
	--[[* [`Shape:getUserData`](lua://lovr_shape.getUserData)]]
	--[[* [`Shape:setUserData`](lua://lovr_shape.setUserData)]]
	--[[* [`Joint:getUserData`](lua://lovr_joint.getUserData)]]
	--[[* [`Joint:setUserData`](lua://lovr_joint.setUserData)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return unknown data]]
	function Collider_class:getUserData() return nil end

	--[[https://lovr.org/docs/Collider:getWorld  ]]
	--[[Get the World the Collider is in.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return lovr_world world]]
	function Collider_class:getWorld() return World_class end

	--[[https://lovr.org/docs/Collider:getWorldPoint  ]]
	--[[Transform a point from local space to world space.  ]]
	--[[### See also]]
	--[[* [`Collider:getLocalPoint`](lua://lovr_collider.getLocalPoint)]]
	--[[* [`Collider:getLocalVector`](lua://lovr_collider.getLocalVector)]]
	--[[* [`Collider:getWorldVector`](lua://lovr_collider.getWorldVector)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@return number wx]]
	--[[@return number wy]]
	--[[@return number wz]]
	--[[@overload fun(self: lovr_collider, point: lovr_vec3): number, number, number]]
	function Collider_class:getWorldPoint(x, y, z) return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:getWorldVector  ]]
	--[[Transform a vector from local space to world space.  ]]
	--[[### See also]]
	--[[* [`Collider:getLocalVector`](lua://lovr_collider.getLocalVector)]]
	--[[* [`Collider:getLocalPoint`](lua://lovr_collider.getLocalPoint)]]
	--[[* [`Collider:getWorldPoint`](lua://lovr_collider.getWorldPoint)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@return number wx]]
	--[[@return number wy]]
	--[[@return number wz]]
	--[[@overload fun(self: lovr_collider, vector: lovr_vec3): number, number, number]]
	function Collider_class:getWorldVector(x, y, z) return 0, 0, 0 end

	--[[https://lovr.org/docs/Collider:isAwake  ]]
	--[[Check if the Collider is awake.  ]]
	--[[### See also]]
	--[[* [`Collider:isSleepingAllowed`](lua://lovr_collider.isSleepingAllowed)]]
	--[[* [`Collider:setSleepingAllowed`](lua://lovr_collider.setSleepingAllowed)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return boolean awake]]
	function Collider_class:isAwake() return false end

	--[[https://lovr.org/docs/Collider:isContinuous  ]]
	--[[Check if the Collider is using continuous collision detection.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return boolean continuous]]
	function Collider_class:isContinuous() return false end

	--[[https://lovr.org/docs/Collider:isDestroyed  ]]
	--[[Check if the Collider has been destroyed.  ]]
	--[[### See also]]
	--[[* [`Collider:destroy`](lua://lovr_collider.destroy)]]
	--[[* [`World:destroy`](lua://lovr_world.destroy)]]
	--[[* [`Shape:destroy`](lua://lovr_shape.destroy)]]
	--[[* [`Joint:destroy`](lua://lovr_joint.destroy)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return boolean destroyed]]
	function Collider_class:isDestroyed() return false end

	--[[https://lovr.org/docs/Collider:isEnabled  ]]
	--[[Check if the Collider is enabled.  ]]
	--[[### See also]]
	--[[* [`Collider:destroy`](lua://lovr_collider.destroy)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return boolean enabled]]
	function Collider_class:isEnabled() return false end

	--[[https://lovr.org/docs/Collider:isGravityIgnored  ]]
	--[[Check if the Collider ignores gravity.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return boolean ignored]]
	--[[@deprecated]]
	function Collider_class:isGravityIgnored() return false end

	--[[https://lovr.org/docs/Collider:isKinematic  ]]
	--[[Check if the Collider is kinematic.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return boolean kinematic]]
	function Collider_class:isKinematic() return false end

	--[[https://lovr.org/docs/Collider:isSensor  ]]
	--[[Check if the Collider is a sensor.  ]]
	--[[### See also]]
	--[[* [`Collider:setKinematic`](lua://lovr_collider.setKinematic)]]
	--[[* [`Collider:setEnabled`](lua://lovr_collider.setEnabled)]]
	--[[* [`World:overlapShape`](lua://lovr_world.overlapShape)]]
	--[[* [`World:setCallbacks`](lua://lovr_world.setCallbacks)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return boolean sensor]]
	function Collider_class:isSensor() return false end

	--[[https://lovr.org/docs/Collider:isSleepingAllowed  ]]
	--[[Check if the Collider is allowed to sleep.  ]]
	--[[### See also]]
	--[[* [`Collider:isAwake`](lua://lovr_collider.isAwake)]]
	--[[* [`Collider:setAwake`](lua://lovr_collider.setAwake)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@return boolean sleepy]]
	function Collider_class:isSleepingAllowed() return false end

	--[[https://lovr.org/docs/Collider:removeShape  ]]
	--[[Remove a Shape from the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:addShape`](lua://lovr_collider.addShape)]]
	--[[* [`Collider:getShapes`](lua://lovr_collider.getShapes)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param shape lovr_shape]]
	function Collider_class:removeShape(shape) end

	--[[https://lovr.org/docs/Collider:resetMassData  ]]
	--[[Reset mass properties.  ]]
	--[[### See also]]
	--[[* [`Collider:getAutomaticMass`](lua://lovr_collider.getAutomaticMass)]]
	--[[* [`Collider:setAutomaticMass`](lua://lovr_collider.setAutomaticMass)]]
	--[[* [`Collider:getMass`](lua://lovr_collider.getMass)]]
	--[[* [`Collider:setMass`](lua://lovr_collider.setMass)]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Collider:setInertia`](lua://lovr_collider.setInertia)]]
	--[[* [`Collider:getCenterOfMass`](lua://lovr_collider.getCenterOfMass)]]
	--[[* [`Collider:setCenterOfMass`](lua://lovr_collider.setCenterOfMass)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	function Collider_class:resetMassData() end

	--[[https://lovr.org/docs/Collider:setAngularDamping  ]]
	--[[Set the angular damping of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getLinearDamping`](lua://lovr_collider.getLinearDamping)]]
	--[[* [`Collider:setLinearDamping`](lua://lovr_collider.setLinearDamping)]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Collider:setInertia`](lua://lovr_collider.setInertia)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param damping number]]
	function Collider_class:setAngularDamping(damping) end

	--[[https://lovr.org/docs/Collider:setAngularVelocity  ]]
	--[[Set the angular velocity of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyTorque`](lua://lovr_collider.applyTorque)]]
	--[[* [`Collider:applyAngularImpulse`](lua://lovr_collider.applyAngularImpulse)]]
	--[[* [`Collider:getLinearVelocity`](lua://lovr_collider.getLinearVelocity)]]
	--[[* [`Collider:setLinearVelocity`](lua://lovr_collider.setLinearVelocity)]]
	--[[* [`Collider:getOrientation`](lua://lovr_collider.getOrientation)]]
	--[[* [`Collider:setOrientation`](lua://lovr_collider.setOrientation)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param vx number]]
	--[[@param vy number]]
	--[[@param vz number]]
	--[[@overload fun(self: lovr_collider, velocity: lovr_vec3)]]
	function Collider_class:setAngularVelocity(vx, vy, vz) end

	--[[https://lovr.org/docs/Collider:setAutomaticMass  ]]
	--[[Enable or disable automatic mass.  ]]
	--[[### See also]]
	--[[* [`Collider:resetMassData`](lua://lovr_collider.resetMassData)]]
	--[[* [`Collider:getMass`](lua://lovr_collider.getMass)]]
	--[[* [`Collider:setMass`](lua://lovr_collider.setMass)]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Collider:setInertia`](lua://lovr_collider.setInertia)]]
	--[[* [`Collider:getCenterOfMass`](lua://lovr_collider.getCenterOfMass)]]
	--[[* [`Collider:setCenterOfMass`](lua://lovr_collider.setCenterOfMass)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param enable boolean]]
	function Collider_class:setAutomaticMass(enable) end

	--[[https://lovr.org/docs/Collider:setAwake  ]]
	--[[Put the Collider to sleep or wake it up.  ]]
	--[[### See also]]
	--[[* [`Collider:isSleepingAllowed`](lua://lovr_collider.isSleepingAllowed)]]
	--[[* [`Collider:setSleepingAllowed`](lua://lovr_collider.setSleepingAllowed)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param awake boolean]]
	function Collider_class:setAwake(awake) end

	--[[https://lovr.org/docs/Collider:setCenterOfMass  ]]
	--[[Set the Collider's center of mass.  ]]
	--[[### See also]]
	--[[* [`Shape:getCenterOfMass`](lua://lovr_shape.getCenterOfMass)]]
	--[[* [`Collider:getMass`](lua://lovr_collider.getMass)]]
	--[[* [`Collider:setMass`](lua://lovr_collider.setMass)]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Collider:setInertia`](lua://lovr_collider.setInertia)]]
	--[[* [`Collider:getAutomaticMass`](lua://lovr_collider.getAutomaticMass)]]
	--[[* [`Collider:setAutomaticMass`](lua://lovr_collider.setAutomaticMass)]]
	--[[* [`Collider:resetMassData`](lua://lovr_collider.resetMassData)]]
	--[[* [`Shape:getOffset`](lua://lovr_shape.getOffset)]]
	--[[* [`Shape:setOffset`](lua://lovr_shape.setOffset)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(self: lovr_collider, center: lovr_vec3)]]
	function Collider_class:setCenterOfMass(x, y, z) end

	--[[https://lovr.org/docs/Collider:setContinuous  ]]
	--[[Set whether the Collider uses continuous collision detection.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param continuous boolean]]
	function Collider_class:setContinuous(continuous) end

	--[[https://lovr.org/docs/Collider:setDegreesOfFreedom  ]]
	--[[Set the enabled translation/rotation axes.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param translation string]]
	--[[@param rotation string]]
	function Collider_class:setDegreesOfFreedom(translation, rotation) end

	--[[https://lovr.org/docs/Collider:setEnabled  ]]
	--[[Enable or disable the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:destroy`](lua://lovr_collider.destroy)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param enable boolean]]
	function Collider_class:setEnabled(enable) end

	--[[https://lovr.org/docs/Collider:setFriction  ]]
	--[[Set the friction of the Collider.  ]]
	--[[### See also]]
	--[[* [`Contact:getFriction`](lua://lovr_contact.getFriction)]]
	--[[* [`Contact:setFriction`](lua://lovr_contact.setFriction)]]
	--[[* [`Collider:getRestitution`](lua://lovr_collider.getRestitution)]]
	--[[* [`Collider:setRestitution`](lua://lovr_collider.setRestitution)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param friction number]]
	function Collider_class:setFriction(friction) end

	--[[https://lovr.org/docs/Collider:setGravityIgnored  ]]
	--[[Set whether the Collider ignores gravity.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param ignored boolean]]
	--[[@deprecated]]
	function Collider_class:setGravityIgnored(ignored) end

	--[[https://lovr.org/docs/Collider:setGravityScale  ]]
	--[[Set the gravity scale of the Collider.  ]]
	--[[### See also]]
	--[[* [`World:getGravity`](lua://lovr_world.getGravity)]]
	--[[* [`World:setGravity`](lua://lovr_world.setGravity)]]
	--[[* [`Collider:getLinearDamping`](lua://lovr_collider.getLinearDamping)]]
	--[[* [`Collider:setLinearDamping`](lua://lovr_collider.setLinearDamping)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param scale number]]
	function Collider_class:setGravityScale(scale) end

	--[[https://lovr.org/docs/Collider:setInertia  ]]
	--[[Set the inertia of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getMass`](lua://lovr_collider.getMass)]]
	--[[* [`Collider:setMass`](lua://lovr_collider.setMass)]]
	--[[* [`Collider:getCenterOfMass`](lua://lovr_collider.getCenterOfMass)]]
	--[[* [`Collider:setCenterOfMass`](lua://lovr_collider.setCenterOfMass)]]
	--[[* [`Collider:getAutomaticMass`](lua://lovr_collider.getAutomaticMass)]]
	--[[* [`Collider:setAutomaticMass`](lua://lovr_collider.setAutomaticMass)]]
	--[[* [`Collider:resetMassData`](lua://lovr_collider.resetMassData)]]
	--[[* [`Shape:getInertia`](lua://lovr_shape.getInertia)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param dx number]]
	--[[@param dy number]]
	--[[@param dz number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_collider, diagonal: lovr_vec3, rotation: lovr_quat)]]
	function Collider_class:setInertia(dx, dy, dz, angle, ax, ay, az) end

	--[[https://lovr.org/docs/Collider:setKinematic  ]]
	--[[Set whether the Collider is kinematic.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param kinematic boolean]]
	function Collider_class:setKinematic(kinematic) end

	--[[https://lovr.org/docs/Collider:setLinearDamping  ]]
	--[[Set the linear damping of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getAngularDamping`](lua://lovr_collider.getAngularDamping)]]
	--[[* [`Collider:setAngularDamping`](lua://lovr_collider.setAngularDamping)]]
	--[[* [`Collider:getGravityScale`](lua://lovr_collider.getGravityScale)]]
	--[[* [`Collider:setGravityScale`](lua://lovr_collider.setGravityScale)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param damping number]]
	function Collider_class:setLinearDamping(damping) end

	--[[https://lovr.org/docs/Collider:setLinearVelocity  ]]
	--[[Set the linear velocity of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyForce`](lua://lovr_collider.applyForce)]]
	--[[* [`Collider:applyLinearImpulse`](lua://lovr_collider.applyLinearImpulse)]]
	--[[* [`Collider:getLinearVelocityFromLocalPoint`](lua://lovr_collider.getLinearVelocityFromLocalPoint)]]
	--[[* [`Collider:getLinearVelocityFromWorldPoint`](lua://lovr_collider.getLinearVelocityFromWorldPoint)]]
	--[[* [`Collider:getAngularVelocity`](lua://lovr_collider.getAngularVelocity)]]
	--[[* [`Collider:setAngularVelocity`](lua://lovr_collider.setAngularVelocity)]]
	--[[* [`Collider:getPosition`](lua://lovr_collider.getPosition)]]
	--[[* [`Collider:setPosition`](lua://lovr_collider.setPosition)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param vx number]]
	--[[@param vy number]]
	--[[@param vz number]]
	--[[@overload fun(self: lovr_collider, velocity: lovr_vec3)]]
	function Collider_class:setLinearVelocity(vx, vy, vz) end

	--[[https://lovr.org/docs/Collider:setMass  ]]
	--[[Set the mass of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Collider:setInertia`](lua://lovr_collider.setInertia)]]
	--[[* [`Collider:getCenterOfMass`](lua://lovr_collider.getCenterOfMass)]]
	--[[* [`Collider:setCenterOfMass`](lua://lovr_collider.setCenterOfMass)]]
	--[[* [`Collider:getAutomaticMass`](lua://lovr_collider.getAutomaticMass)]]
	--[[* [`Collider:setAutomaticMass`](lua://lovr_collider.setAutomaticMass)]]
	--[[* [`Collider:resetMassData`](lua://lovr_collider.resetMassData)]]
	--[[* [`Shape:getDensity`](lua://lovr_shape.getDensity)]]
	--[[* [`Shape:setDensity`](lua://lovr_shape.setDensity)]]
	--[[* [`Shape:getVolume`](lua://lovr_shape.getVolume)]]
	--[[* [`Shape:getMass`](lua://lovr_shape.getMass)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param mass number]]
	function Collider_class:setMass(mass) end

	--[[https://lovr.org/docs/Collider:setOrientation  ]]
	--[[Set the orientation of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyTorque`](lua://lovr_collider.applyTorque)]]
	--[[* [`Collider:getAngularVelocity`](lua://lovr_collider.getAngularVelocity)]]
	--[[* [`Collider:setAngularVelocity`](lua://lovr_collider.setAngularVelocity)]]
	--[[* [`Collider:getPosition`](lua://lovr_collider.getPosition)]]
	--[[* [`Collider:setPosition`](lua://lovr_collider.setPosition)]]
	--[[* [`Collider:getPose`](lua://lovr_collider.getPose)]]
	--[[* [`Collider:setPose`](lua://lovr_collider.setPose)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_collider, orientation: lovr_quat)]]
	function Collider_class:setOrientation(angle, ax, ay, az) end

	--[[https://lovr.org/docs/Collider:setPose  ]]
	--[[Set the pose of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:setPosition`](lua://lovr_collider.setPosition)]]
	--[[* [`Collider:setOrientation`](lua://lovr_collider.setOrientation)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_collider, position: lovr_vec3, orientation: lovr_quat)]]
	function Collider_class:setPose(x, y, z, angle, ax, ay, az) end

	--[[https://lovr.org/docs/Collider:setPosition  ]]
	--[[Set the position of the Collider.  ]]
	--[[### See also]]
	--[[* [`Collider:applyForce`](lua://lovr_collider.applyForce)]]
	--[[* [`Collider:getLinearVelocity`](lua://lovr_collider.getLinearVelocity)]]
	--[[* [`Collider:setLinearVelocity`](lua://lovr_collider.setLinearVelocity)]]
	--[[* [`Collider:getOrientation`](lua://lovr_collider.getOrientation)]]
	--[[* [`Collider:setOrientation`](lua://lovr_collider.setOrientation)]]
	--[[* [`Collider:getPose`](lua://lovr_collider.getPose)]]
	--[[* [`Collider:setPose`](lua://lovr_collider.setPose)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(self: lovr_collider, position: lovr_vec3)]]
	function Collider_class:setPosition(x, y, z) end

	--[[https://lovr.org/docs/Collider:setRestitution  ]]
	--[[Set the bounciness of the Collider.  ]]
	--[[### See also]]
	--[[* [`Contact:getRestitution`](lua://lovr_contact.getRestitution)]]
	--[[* [`Contact:setRestitution`](lua://lovr_contact.setRestitution)]]
	--[[* [`Collider:getFriction`](lua://lovr_collider.getFriction)]]
	--[[* [`Collider:setFriction`](lua://lovr_collider.setFriction)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param restitution number]]
	function Collider_class:setRestitution(restitution) end

	--[[https://lovr.org/docs/Collider:setSensor  ]]
	--[[Set whether the Collider should be a sensor.  ]]
	--[[### See also]]
	--[[* [`Collider:setKinematic`](lua://lovr_collider.setKinematic)]]
	--[[* [`Collider:setEnabled`](lua://lovr_collider.setEnabled)]]
	--[[* [`World:overlapShape`](lua://lovr_world.overlapShape)]]
	--[[* [`World:setCallbacks`](lua://lovr_world.setCallbacks)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param sensor boolean]]
	function Collider_class:setSensor(sensor) end

	--[[https://lovr.org/docs/Collider:setSleepingAllowed  ]]
	--[[Set whether the Collider is allowed to sleep.  ]]
	--[[### See also]]
	--[[* [`Collider:isAwake`](lua://lovr_collider.isAwake)]]
	--[[* [`Collider:setAwake`](lua://lovr_collider.setAwake)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param sleepy boolean]]
	function Collider_class:setSleepingAllowed(sleepy) end

	--[[https://lovr.org/docs/Collider:setTag  ]]
	--[[Set the Collider's tag.  ]]
	--[[### See also]]
	--[[* [`World:getTags`](lua://lovr_world.getTags)]]
	--[[* [`World:disableCollisionBetween`](lua://lovr_world.disableCollisionBetween)]]
	--[[* [`World:enableCollisionBetween`](lua://lovr_world.enableCollisionBetween)]]
	--[[* [`World:isCollisionEnabledBetween`](lua://lovr_world.isCollisionEnabledBetween)]]
	--[[* [`lovr.physics.newWorld`](lua://lovr.physics.newWorld)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param tag string]]
	--[[@overload fun(self: lovr_collider)]]
	function Collider_class:setTag(tag) end

	--[[https://lovr.org/docs/Collider:setUserData  ]]
	--[[Associate a Lua value with the Collider.  ]]
	--[[### See also]]
	--[[* [`Shape:getUserData`](lua://lovr_shape.getUserData)]]
	--[[* [`Shape:setUserData`](lua://lovr_shape.setUserData)]]
	--[[* [`Joint:getUserData`](lua://lovr_joint.getUserData)]]
	--[[* [`Joint:setUserData`](lua://lovr_joint.setUserData)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[@param data unknown]]
	function Collider_class:setUserData(data) end

	--[[https://lovr.org/docs/ConeJoint  ]]
	--[[TODO  ]]
	--[[@class lovr_cone_joint: lovr_object]]

	--[[https://lovr.org/docs/ConeJoint:getAxis  ]]
	--[[Get the axis of the cone.  ]]
	--[[### See also]]
	--[[* [`ConeJoint`](lua://lovr_coneJoint)]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function ConeJoint_class:getAxis() return 0, 0, 0 end

	--[[https://lovr.org/docs/ConeJoint:getLimit  ]]
	--[[Get the angle limit of the ConeJoint.  ]]
	--[[### See also]]
	--[[* [`ConeJoint`](lua://lovr_coneJoint)]]
	--[[@return number limit]]
	function ConeJoint_class:getLimit() return 0 end

	--[[https://lovr.org/docs/ConeJoint:setLimit  ]]
	--[[Set the angle limit of the ConeJoint.  ]]
	--[[### See also]]
	--[[* [`ConeJoint`](lua://lovr_coneJoint)]]
	--[[@param limit number]]
	function ConeJoint_class:setLimit(limit) end

	--[[https://lovr.org/docs/Contact  ]]
	--[[TODO  ]]
	--[[@class lovr_contact: lovr_object]]

	--[[https://lovr.org/docs/Contact:getColliders  ]]
	--[[Get the two Colliders that are in contact.  ]]
	--[[### See also]]
	--[[* [`Contact:getShapes`](lua://lovr_contact.getShapes)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@return lovr_collider first]]
	--[[@return lovr_collider second]]
	function Contact_class:getColliders() return Collider_class, Collider_class end

	--[[https://lovr.org/docs/Contact:getFriction  ]]
	--[[Get the friction of the Contact.  ]]
	--[[### See also]]
	--[[* [`Collider:getFriction`](lua://lovr_collider.getFriction)]]
	--[[* [`Collider:setFriction`](lua://lovr_collider.setFriction)]]
	--[[* [`Contact:getRestitution`](lua://lovr_contact.getRestitution)]]
	--[[* [`Contact:setRestitution`](lua://lovr_contact.setRestitution)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@return number friction]]
	function Contact_class:getFriction() return 0 end

	--[[https://lovr.org/docs/Contact:getNormal  ]]
	--[[Get the normal vector of the Contact.  ]]
	--[[### See also]]
	--[[* [`Contact:getOverlap`](lua://lovr_contact.getOverlap)]]
	--[[* [`Contact:getPoints`](lua://lovr_contact.getPoints)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Contact_class:getNormal() return 0, 0, 0 end

	--[[https://lovr.org/docs/Contact:getOverlap  ]]
	--[[Get the amount of overlap between the colliders.  ]]
	--[[### See also]]
	--[[* [`Contact:getNormal`](lua://lovr_contact.getNormal)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@return number overlap]]
	function Contact_class:getOverlap() return 0 end

	--[[https://lovr.org/docs/Contact:getPoints  ]]
	--[[Get the contact points of the Contact.  ]]
	--[[### See also]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@return number ...]]
	function Contact_class:getPoints() return 0 end

	--[[https://lovr.org/docs/Contact:getRestitution  ]]
	--[[Get the bounciness of the Contact.  ]]
	--[[### See also]]
	--[[* [`Collider:getRestitution`](lua://lovr_collider.getRestitution)]]
	--[[* [`Collider:setRestitution`](lua://lovr_collider.setRestitution)]]
	--[[* [`Contact:getFriction`](lua://lovr_contact.getFriction)]]
	--[[* [`Contact:setFriction`](lua://lovr_contact.setFriction)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@return number restitution]]
	function Contact_class:getRestitution() return 0 end

	--[[https://lovr.org/docs/Contact:getShapes  ]]
	--[[Get the two Shapes that are in contact.  ]]
	--[[### See also]]
	--[[* [`Contact:getColliders`](lua://lovr_contact.getColliders)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@return lovr_shape first]]
	--[[@return lovr_shape second]]
	function Contact_class:getShapes() return Shape_class, Shape_class end

	--[[https://lovr.org/docs/Contact:getSurfaceVelocity  ]]
	--[[Get the surface velocity of the Contact.  ]]
	--[[### See also]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Contact_class:getSurfaceVelocity() return 0, 0, 0 end

	--[[https://lovr.org/docs/Contact:isEnabled  ]]
	--[[Check if the Contact is enabled.  ]]
	--[[### See also]]
	--[[* [`Collider:isEnabled`](lua://lovr_collider.isEnabled)]]
	--[[* [`Collider:setEnabled`](lua://lovr_collider.setEnabled)]]
	--[[* [`World:setCallbacks`](lua://lovr_world.setCallbacks)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@return boolean enabled]]
	function Contact_class:isEnabled() return false end

	--[[https://lovr.org/docs/Contact:setEnabled  ]]
	--[[Enable or disable the Contact.  ]]
	--[[### See also]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@param enable boolean]]
	function Contact_class:setEnabled(enable) end

	--[[https://lovr.org/docs/Contact:setFriction  ]]
	--[[Set the friction of the Contact.  ]]
	--[[### See also]]
	--[[* [`Collider:getFriction`](lua://lovr_collider.getFriction)]]
	--[[* [`Collider:setFriction`](lua://lovr_collider.setFriction)]]
	--[[* [`Contact:getRestitution`](lua://lovr_contact.getRestitution)]]
	--[[* [`Contact:setRestitution`](lua://lovr_contact.setRestitution)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@param friction number]]
	function Contact_class:setFriction(friction) end

	--[[https://lovr.org/docs/Contact:setRestitution  ]]
	--[[Set the bounciness of the Contact.  ]]
	--[[### See also]]
	--[[* [`Collider:getRestitution`](lua://lovr_collider.getRestitution)]]
	--[[* [`Collider:setRestitution`](lua://lovr_collider.setRestitution)]]
	--[[* [`Contact:getFriction`](lua://lovr_contact.getFriction)]]
	--[[* [`Contact:setFriction`](lua://lovr_contact.setFriction)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@param restitution number]]
	function Contact_class:setRestitution(restitution) end

	--[[https://lovr.org/docs/Contact:setSurfaceVelocity  ]]
	--[[Set the surface velocity of the Contact.  ]]
	--[[### See also]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@overload fun(self: lovr_contact, velocity: lovr_vec3)]]
	function Contact_class:setSurfaceVelocity(x, y, z) end

	--[[https://lovr.org/docs/ConvexShape  ]]
	--[[TODO  ]]
	--[[@class lovr_convex_shape: lovr_object]]

	--[[https://lovr.org/docs/ConvexShape:getFaceCount  ]]
	--[[Get the number of faces in the convex hull.  ]]
	--[[### See also]]
	--[[* [`ConvexShape:getFace`](lua://lovr_convexShape.getFace)]]
	--[[* [`ConvexShape`](lua://lovr_convexShape)]]
	--[[@return number count]]
	function ConvexShape_class:getFaceCount() return 0 end

	--[[https://lovr.org/docs/ConvexShape:getFace  ]]
	--[[Get the point indices of one of the faces of the convex hull.  ]]
	--[[### See also]]
	--[[* [`ConvexShape:getPoint`](lua://lovr_convexShape.getPoint)]]
	--[[* [`ConvexShape:getFaceCount`](lua://lovr_convexShape.getFaceCount)]]
	--[[* [`ConvexShape`](lua://lovr_convexShape)]]
	--[[@param index number]]
	--[[@return table<string,string|number> points]]
	function ConvexShape_class:getFace(index) return {} end

	--[[https://lovr.org/docs/ConvexShape:getPointCount  ]]
	--[[Get the number of points in the convex hull.  ]]
	--[[### See also]]
	--[[* [`ConvexShape:getPoint`](lua://lovr_convexShape.getPoint)]]
	--[[* [`ConvexShape`](lua://lovr_convexShape)]]
	--[[@return number count]]
	function ConvexShape_class:getPointCount() return 0 end

	--[[https://lovr.org/docs/ConvexShape:getPoint  ]]
	--[[Get one of the points in the convex hull.  ]]
	--[[### See also]]
	--[[* [`ConvexShape:getPointCount`](lua://lovr_convexShape.getPointCount)]]
	--[[* [`ConvexShape`](lua://lovr_convexShape)]]
	--[[@param index number]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function ConvexShape_class:getPoint(index) return 0, 0, 0 end

	--[[https://lovr.org/docs/CylinderShape  ]]
	--[[A cylinder Shape.  ]]
	--[[@class lovr_cylinder_shape: lovr_object]]

	--[[https://lovr.org/docs/CylinderShape:getLength  ]]
	--[[Get the length of the CylinderShape.  ]]
	--[[### See also]]
	--[[* [`CylinderShape:getRadius`](lua://lovr_cylinderShape.getRadius)]]
	--[[* [`CylinderShape:setRadius`](lua://lovr_cylinderShape.setRadius)]]
	--[[* [`CylinderShape`](lua://lovr_cylinderShape)]]
	--[[@return number length]]
	function CylinderShape_class:getLength() return 0 end

	--[[https://lovr.org/docs/CylinderShape:getRadius  ]]
	--[[Get the radius of the CylinderShape.  ]]
	--[[### See also]]
	--[[* [`CylinderShape:getLength`](lua://lovr_cylinderShape.getLength)]]
	--[[* [`CylinderShape:setLength`](lua://lovr_cylinderShape.setLength)]]
	--[[* [`CylinderShape`](lua://lovr_cylinderShape)]]
	--[[@return number radius]]
	function CylinderShape_class:getRadius() return 0 end

	--[[https://lovr.org/docs/CylinderShape:setLength  ]]
	--[[Set the length of the CylinderShape.  ]]
	--[[### See also]]
	--[[* [`CylinderShape:getRadius`](lua://lovr_cylinderShape.getRadius)]]
	--[[* [`CylinderShape:setRadius`](lua://lovr_cylinderShape.setRadius)]]
	--[[* [`CylinderShape`](lua://lovr_cylinderShape)]]
	--[[@param length number]]
	function CylinderShape_class:setLength(length) end

	--[[https://lovr.org/docs/CylinderShape:setRadius  ]]
	--[[Set the radius of the CylinderShape.  ]]
	--[[### See also]]
	--[[* [`CylinderShape:getLength`](lua://lovr_cylinderShape.getLength)]]
	--[[* [`CylinderShape:setLength`](lua://lovr_cylinderShape.setLength)]]
	--[[* [`CylinderShape`](lua://lovr_cylinderShape)]]
	--[[@param radius number]]
	function CylinderShape_class:setRadius(radius) end

	--[[https://lovr.org/docs/DistanceJoint  ]]
	--[[A fixed distance joint.  ]]
	--[[@class lovr_distance_joint: lovr_object]]

	--[[https://lovr.org/docs/DistanceJoint:getLimits  ]]
	--[[Get the minimum and maximum distance.  ]]
	--[[### See also]]
	--[[* [`DistanceJoint`](lua://lovr_distanceJoint)]]
	--[[@return number min]]
	--[[@return number max]]
	function DistanceJoint_class:getLimits() return 0, 0 end

	--[[https://lovr.org/docs/DistanceJoint:getSpring  ]]
	--[[Get the spring parameters of the joint.  ]]
	--[[### See also]]
	--[[* [`DistanceJoint`](lua://lovr_distanceJoint)]]
	--[[@return number frequency]]
	--[[@return number damping]]
	function DistanceJoint_class:getSpring() return 0, 0 end

	--[[https://lovr.org/docs/DistanceJoint:setLimits  ]]
	--[[Set the minimum and maximum distance.  ]]
	--[[### See also]]
	--[[* [`DistanceJoint`](lua://lovr_distanceJoint)]]
	--[[@param min? number default=`0`]]
	--[[@param max? number default=`min`]]
	--[[@overload fun(self: lovr_distance_joint)]]
	function DistanceJoint_class:setLimits(min, max) end

	--[[https://lovr.org/docs/DistanceJoint:setSpring  ]]
	--[[Set the spring parameters of the joint.  ]]
	--[[### See also]]
	--[[* [`DistanceJoint`](lua://lovr_distanceJoint)]]
	--[[@param frequency? number default=`0.0`]]
	--[[@param damping? number default=`1.0`]]
	function DistanceJoint_class:setSpring(frequency, damping) end

	--[[https://lovr.org/docs/HingeJoint  ]]
	--[[A hinge joint.  ]]
	--[[@class lovr_hinge_joint: lovr_object]]

	--[[https://lovr.org/docs/HingeJoint:getAngle  ]]
	--[[Get the current angle of the HingeJoint.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getAxis`](lua://lovr_hingeJoint.getAxis)]]
	--[[* [`HingeJoint:getLimits`](lua://lovr_hingeJoint.getLimits)]]
	--[[* [`HingeJoint:setLimits`](lua://lovr_hingeJoint.setLimits)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return number angle]]
	function HingeJoint_class:getAngle() return 0 end

	--[[https://lovr.org/docs/HingeJoint:getAxis  ]]
	--[[Get the rotation axis of the HingeJoint.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getAngle`](lua://lovr_hingeJoint.getAngle)]]
	--[[* [`Joint:getAnchors`](lua://lovr_joint.getAnchors)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function HingeJoint_class:getAxis() return 0, 0, 0 end

	--[[https://lovr.org/docs/HingeJoint:getFriction  ]]
	--[[Get the friction of the HingeJoint.  ]]
	--[[### See also]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return number friction]]
	function HingeJoint_class:getFriction() return 0 end

	--[[https://lovr.org/docs/HingeJoint:getLimits  ]]
	--[[Get the angle limits of the HingeJoint.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getAngle`](lua://lovr_hingeJoint.getAngle)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return number min]]
	--[[@return number max]]
	function HingeJoint_class:getLimits() return 0, 0 end

	--[[https://lovr.org/docs/HingeJoint:getMaxMotorTorque  ]]
	--[[Get the maximum amount of torque the motor can use.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getMotorTorque`](lua://lovr_hingeJoint.getMotorTorque)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return number positive]]
	--[[@return number negative]]
	function HingeJoint_class:getMaxMotorTorque() return 0, 0 end

	--[[https://lovr.org/docs/HingeJoint:getMotorMode  ]]
	--[[Get the motor mode of the HingeJoint.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getMotorTarget`](lua://lovr_hingeJoint.getMotorTarget)]]
	--[[* [`HingeJoint:setMotorTarget`](lua://lovr_hingeJoint.setMotorTarget)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return lovr_motor_mode mode]]
	function HingeJoint_class:getMotorMode() return MotorMode_class end

	--[[https://lovr.org/docs/HingeJoint:getMotorSpring  ]]
	--[[Get the spring parameters of the motor target.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getSpring`](lua://lovr_hingeJoint.getSpring)]]
	--[[* [`HingeJoint:setSpring`](lua://lovr_hingeJoint.setSpring)]]
	--[[* [`HingeJoint:getMotorTarget`](lua://lovr_hingeJoint.getMotorTarget)]]
	--[[* [`HingeJoint:setMotorTarget`](lua://lovr_hingeJoint.setMotorTarget)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return number frequency]]
	--[[@return number damping]]
	function HingeJoint_class:getMotorSpring() return 0, 0 end

	--[[https://lovr.org/docs/HingeJoint:getMotorTarget  ]]
	--[[Get the target of the hinge motor.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getMotorMode`](lua://lovr_hingeJoint.getMotorMode)]]
	--[[* [`HingeJoint:setMotorMode`](lua://lovr_hingeJoint.setMotorMode)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return number target]]
	function HingeJoint_class:getMotorTarget() return 0 end

	--[[https://lovr.org/docs/HingeJoint:getMotorTorque  ]]
	--[[Get the current motor torque.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getMaxMotorTorque`](lua://lovr_hingeJoint.getMaxMotorTorque)]]
	--[[* [`HingeJoint:setMaxMotorTorque`](lua://lovr_hingeJoint.setMaxMotorTorque)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return number torque]]
	function HingeJoint_class:getMotorTorque() return 0 end

	--[[https://lovr.org/docs/HingeJoint:getSpring  ]]
	--[[Get the spring parameters of the HingeJoint limits.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getMotorSpring`](lua://lovr_hingeJoint.getMotorSpring)]]
	--[[* [`HingeJoint:setMotorSpring`](lua://lovr_hingeJoint.setMotorSpring)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@return number frequency]]
	--[[@return number damping]]
	function HingeJoint_class:getSpring() return 0, 0 end

	--[[https://lovr.org/docs/HingeJoint:setFriction  ]]
	--[[Set the friction of the HingeJoint.  ]]
	--[[### See also]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@param friction number]]
	function HingeJoint_class:setFriction(friction) end

	--[[https://lovr.org/docs/HingeJoint:setLimits  ]]
	--[[Set the angle limits of the HingeJoint.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getAngle`](lua://lovr_hingeJoint.getAngle)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@param min number]]
	--[[@param max number]]
	--[[@overload fun(self: lovr_hinge_joint)]]
	function HingeJoint_class:setLimits(min, max) end

	--[[https://lovr.org/docs/HingeJoint:setMaxMotorTorque  ]]
	--[[Set the maximum amount of torque the motor can use.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getMotorTorque`](lua://lovr_hingeJoint.getMotorTorque)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@param positive? number default=`math.huge`]]
	--[[@param negative? number default=`positive`]]
	function HingeJoint_class:setMaxMotorTorque(positive, negative) end

	--[[https://lovr.org/docs/HingeJoint:setMotorMode  ]]
	--[[Set the motor mode of the HingeJoint.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getMotorTarget`](lua://lovr_hingeJoint.getMotorTarget)]]
	--[[* [`HingeJoint:setMotorTarget`](lua://lovr_hingeJoint.setMotorTarget)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@param mode lovr_motor_mode]]
	--[[@overload fun(self: lovr_hinge_joint)]]
	function HingeJoint_class:setMotorMode(mode) end

	--[[https://lovr.org/docs/HingeJoint:setMotorSpring  ]]
	--[[Set the spring parameters of the motor target.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getSpring`](lua://lovr_hingeJoint.getSpring)]]
	--[[* [`HingeJoint:setSpring`](lua://lovr_hingeJoint.setSpring)]]
	--[[* [`HingeJoint:getMotorTarget`](lua://lovr_hingeJoint.getMotorTarget)]]
	--[[* [`HingeJoint:setMotorTarget`](lua://lovr_hingeJoint.setMotorTarget)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@param frequency? number default=`0.0`]]
	--[[@param damping? number default=`1.0`]]
	function HingeJoint_class:setMotorSpring(frequency, damping) end

	--[[https://lovr.org/docs/HingeJoint:setMotorTarget  ]]
	--[[Set the target of the hinge motor.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getMotorMode`](lua://lovr_hingeJoint.getMotorMode)]]
	--[[* [`HingeJoint:setMotorMode`](lua://lovr_hingeJoint.setMotorMode)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@param target number]]
	function HingeJoint_class:setMotorTarget(target) end

	--[[https://lovr.org/docs/HingeJoint:setSpring  ]]
	--[[Set the spring parameters of the HingeJoint limits.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:getMotorSpring`](lua://lovr_hingeJoint.getMotorSpring)]]
	--[[* [`HingeJoint:setMotorSpring`](lua://lovr_hingeJoint.setMotorSpring)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[@param frequency? number default=`0.0`]]
	--[[@param damping? number default=`1.0`]]
	function HingeJoint_class:setSpring(frequency, damping) end

	--[[https://lovr.org/docs/Joint  ]]
	--[[Joins two Colliders together.  ]]
	--[[@class lovr_joint: lovr_object]]

	--[[https://lovr.org/docs/Joint:destroy  ]]
	--[[Destroy the Joint.  ]]
	--[[### See also]]
	--[[* [`Joint:isDestroyed`](lua://lovr_joint.isDestroyed)]]
	--[[* [`Joint:setEnabled`](lua://lovr_joint.setEnabled)]]
	--[[* [`Collider:destroy`](lua://lovr_collider.destroy)]]
	--[[* [`Shape:destroy`](lua://lovr_shape.destroy)]]
	--[[* [`World:destroy`](lua://lovr_world.destroy)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	function Joint_class:destroy() end

	--[[https://lovr.org/docs/Joint:getAnchors  ]]
	--[[Get the anchor points of the Joint.  ]]
	--[[### See also]]
	--[[* [`Joint:getColliders`](lua://lovr_joint.getColliders)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@return number x1]]
	--[[@return number y1]]
	--[[@return number z1]]
	--[[@return number x2]]
	--[[@return number y2]]
	--[[@return number z2]]
	function Joint_class:getAnchors() return 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Joint:getColliders  ]]
	--[[Get the Colliders the Joint is attached to.  ]]
	--[[### See also]]
	--[[* [`Collider:getJoints`](lua://lovr_collider.getJoints)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@return lovr_collider colliderA]]
	--[[@return lovr_collider colliderB]]
	function Joint_class:getColliders() return Collider_class, Collider_class end

	--[[https://lovr.org/docs/Joint:getForce  ]]
	--[[Get the force used to satisfy the Joint's constraint.  ]]
	--[[### See also]]
	--[[* [`Joint:getTorque`](lua://lovr_joint.getTorque)]]
	--[[* [`SliderJoint:getMotorForce`](lua://lovr_sliderJoint.getMotorForce)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@return number force]]
	function Joint_class:getForce() return 0 end

	--[[https://lovr.org/docs/Joint:getPriority  ]]
	--[[Get the priority of the Joint.  ]]
	--[[### See also]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@return number priority]]
	function Joint_class:getPriority() return 0 end

	--[[https://lovr.org/docs/Joint:getTorque  ]]
	--[[Get the torque used to satisfy the Joint's constraint.  ]]
	--[[### See also]]
	--[[* [`Joint:getForce`](lua://lovr_joint.getForce)]]
	--[[* [`HingeJoint:getMotorTorque`](lua://lovr_hingeJoint.getMotorTorque)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@return number torque]]
	function Joint_class:getTorque() return 0 end

	--[[https://lovr.org/docs/Joint:getType  ]]
	--[[Get the type of the Joint.  ]]
	--[[### See also]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@return lovr_joint_type type]]
	function Joint_class:getType() return JointType_class end

	--[[https://lovr.org/docs/Joint:getUserData  ]]
	--[[Get the Lua value associated with the Joint.  ]]
	--[[### See also]]
	--[[* [`Collider:getUserData`](lua://lovr_collider.getUserData)]]
	--[[* [`Collider:setUserData`](lua://lovr_collider.setUserData)]]
	--[[* [`Shape:getUserData`](lua://lovr_shape.getUserData)]]
	--[[* [`Shape:setUserData`](lua://lovr_shape.setUserData)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@return unknown data]]
	function Joint_class:getUserData() return nil end

	--[[https://lovr.org/docs/Joint:isDestroyed  ]]
	--[[Check if a Joint is destroyed.  ]]
	--[[### See also]]
	--[[* [`Joint:destroy`](lua://lovr_joint.destroy)]]
	--[[* [`Joint:isEnabled`](lua://lovr_joint.isEnabled)]]
	--[[* [`Joint:setEnabled`](lua://lovr_joint.setEnabled)]]
	--[[* [`Collider:destroy`](lua://lovr_collider.destroy)]]
	--[[* [`Shape:destroy`](lua://lovr_shape.destroy)]]
	--[[* [`World:destroy`](lua://lovr_world.destroy)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@return boolean destroyed]]
	function Joint_class:isDestroyed() return false end

	--[[https://lovr.org/docs/Joint:isEnabled  ]]
	--[[Check if the Joint is enabled.  ]]
	--[[### See also]]
	--[[* [`Joint:destroy`](lua://lovr_joint.destroy)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@return boolean enabled]]
	function Joint_class:isEnabled() return false end

	--[[https://lovr.org/docs/Joint:setEnabled  ]]
	--[[Enable or disable the Joint.  ]]
	--[[### See also]]
	--[[* [`Joint:destroy`](lua://lovr_joint.destroy)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@param enabled boolean]]
	function Joint_class:setEnabled(enabled) end

	--[[https://lovr.org/docs/Joint:setPriority  ]]
	--[[Set the priority of the Joint.  ]]
	--[[### See also]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@param priority number]]
	function Joint_class:setPriority(priority) end

	--[[https://lovr.org/docs/Joint:setUserData  ]]
	--[[Associate a Lua value with the Joint.  ]]
	--[[### See also]]
	--[[* [`Collider:getUserData`](lua://lovr_collider.getUserData)]]
	--[[* [`Collider:setUserData`](lua://lovr_collider.setUserData)]]
	--[[* [`Shape:getUserData`](lua://lovr_shape.getUserData)]]
	--[[* [`Shape:setUserData`](lua://lovr_shape.setUserData)]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[@param data unknown]]
	function Joint_class:setUserData(data) end

	--[[https://lovr.org/docs/JointType  ]]
	--[[Types of physics joints.  ]]
	--[[### See also]]
	--[[* [`Joint`](lua://lovr_joint)]]
	--[[* [`BallJoint`](lua://lovr_ballJoint)]]
	--[[* [`DistanceJoint`](lua://lovr_distanceJoint)]]
	--[[* [`HingeJoint`](lua://lovr_hingeJoint)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@enum lovr_joint_type]]
	local lovr_joint_type = {
		--[[A BallJoint.  ]]
		ball = "ball",
		--[[A DistanceJoint.  ]]
		distance = "distance",
		--[[A HingeJoint.  ]]
		hinge = "hinge",
		--[[A SliderJoint.  ]]
		slider = "slider",
	}

	--[[https://lovr.org/docs/MeshShape  ]]
	--[[A mesh Shape.  ]]
	--[[@class lovr_mesh_shape: lovr_object]]

	--[[https://lovr.org/docs/MotorMode  ]]
	--[[The different states for joint motors.  ]]
	--[[### See also]]
	--[[* [`HingeJoint:setMotorMode`](lua://lovr_hingeJoint.setMotorMode)]]
	--[[* [`SliderJoint:setMotorMode`](lua://lovr_sliderJoint.setMotorMode)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@enum lovr_motor_mode]]
	local lovr_motor_mode = {
		--[[The motor drives to a particular value.  ]]
		position = "position",
		--[[The motor drives to a particular speed.  ]]
		velocity = "velocity",
	}

	--[[https://lovr.org/docs/lovr.physics.newBallJoint  ]]
	--[[Create a new BallJoint.  ]]
	--[[### See also]]
	--[[* [`lovr.physics.newDistanceJoint`](lua://lovr.physics.newDistanceJoint)]]
	--[[* [`lovr.physics.newHingeJoint`](lua://lovr.physics.newHingeJoint)]]
	--[[* [`lovr.physics.newSliderJoint`](lua://lovr.physics.newSliderJoint)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param colliderA lovr_collider]]
	--[[@param colliderB lovr_collider]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@return lovr_ball_joint ball]]
	--[[@overload fun(colliderA: lovr_collider, colliderB: lovr_collider, anchor: lovr_vec3): lovr_ball_joint]]
	function lovr.physics.newBallJoint(colliderA, colliderB, x, y, z) return BallJoint_class end

	--[[https://lovr.org/docs/lovr.physics.newBoxShape  ]]
	--[[Create a new BoxShape.  ]]
	--[[### See also]]
	--[[* [`BoxShape`](lua://lovr_boxShape)]]
	--[[* [`lovr.physics.newCapsuleShape`](lua://lovr.physics.newCapsuleShape)]]
	--[[* [`lovr.physics.newCylinderShape`](lua://lovr.physics.newCylinderShape)]]
	--[[* [`lovr.physics.newMeshShape`](lua://lovr.physics.newMeshShape)]]
	--[[* [`lovr.physics.newSphereShape`](lua://lovr.physics.newSphereShape)]]
	--[[* [`lovr.physics.newTerrainShape`](lua://lovr.physics.newTerrainShape)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param width? number default=`1`]]
	--[[@param height? number default=`width`]]
	--[[@param depth? number default=`width`]]
	--[[@return lovr_box_shape box]]
	function lovr.physics.newBoxShape(width, height, depth) return BoxShape_class end

	--[[https://lovr.org/docs/lovr.physics.newCapsuleShape  ]]
	--[[Create a new CapsuleShape.  ]]
	--[[### See also]]
	--[[* [`CapsuleShape`](lua://lovr_capsuleShape)]]
	--[[* [`lovr.physics.newBoxShape`](lua://lovr.physics.newBoxShape)]]
	--[[* [`lovr.physics.newCylinderShape`](lua://lovr.physics.newCylinderShape)]]
	--[[* [`lovr.physics.newMeshShape`](lua://lovr.physics.newMeshShape)]]
	--[[* [`lovr.physics.newSphereShape`](lua://lovr.physics.newSphereShape)]]
	--[[* [`lovr.physics.newTerrainShape`](lua://lovr.physics.newTerrainShape)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param radius? number default=`1`]]
	--[[@param length? number default=`1`]]
	--[[@return lovr_capsule_shape capsule]]
	function lovr.physics.newCapsuleShape(radius, length) return CapsuleShape_class end

	--[[https://lovr.org/docs/lovr.physics.newConeJoint  ]]
	--[[Create a new ConeJoint.  ]]
	--[[### See also]]
	--[[* [`lovr.physics.newWeldJoint`](lua://lovr.physics.newWeldJoint)]]
	--[[* [`lovr.physics.newBallJoint`](lua://lovr.physics.newBallJoint)]]
	--[[* [`lovr.physics.newDistanceJoint`](lua://lovr.physics.newDistanceJoint)]]
	--[[* [`lovr.physics.newHingeJoint`](lua://lovr.physics.newHingeJoint)]]
	--[[* [`lovr.physics.newSliderJoint`](lua://lovr.physics.newSliderJoint)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param colliderA lovr_collider]]
	--[[@param colliderB lovr_collider]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@return lovr_cone_joint cone]]
	--[[@overload fun(colliderA: lovr_collider, colliderB: lovr_collider, anchor: lovr_vec3, axis: lovr_vec3): lovr_cone_joint]]
	function lovr.physics.newConeJoint(colliderA, colliderB, x, y, z, ax, ay, az) return ConeJoint_class end

	--[[https://lovr.org/docs/lovr.physics.newCylinderShape  ]]
	--[[Create a new CylinderShape.  ]]
	--[[### See also]]
	--[[* [`CylinderShape`](lua://lovr_cylinderShape)]]
	--[[* [`lovr.physics.newBoxShape`](lua://lovr.physics.newBoxShape)]]
	--[[* [`lovr.physics.newCapsuleShape`](lua://lovr.physics.newCapsuleShape)]]
	--[[* [`lovr.physics.newMeshShape`](lua://lovr.physics.newMeshShape)]]
	--[[* [`lovr.physics.newSphereShape`](lua://lovr.physics.newSphereShape)]]
	--[[* [`lovr.physics.newTerrainShape`](lua://lovr.physics.newTerrainShape)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param radius? number default=`1`]]
	--[[@param length? number default=`1`]]
	--[[@return lovr_cylinder_shape cylinder]]
	function lovr.physics.newCylinderShape(radius, length) return CylinderShape_class end

	--[[https://lovr.org/docs/lovr.physics.newDistanceJoint  ]]
	--[[Create a new DistanceJoint.  ]]
	--[[### See also]]
	--[[* [`lovr.physics.newBallJoint`](lua://lovr.physics.newBallJoint)]]
	--[[* [`lovr.physics.newHingeJoint`](lua://lovr.physics.newHingeJoint)]]
	--[[* [`lovr.physics.newSliderJoint`](lua://lovr.physics.newSliderJoint)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param colliderA lovr_collider]]
	--[[@param colliderB lovr_collider]]
	--[[@param x1 number]]
	--[[@param y1 number]]
	--[[@param z1 number]]
	--[[@param x2 number]]
	--[[@param y2 number]]
	--[[@param z2 number]]
	--[[@return lovr_distance_joint joint]]
	--[[@overload fun(colliderA: lovr_collider, colliderB: lovr_collider, first: lovr_vec3, second: lovr_vec3): lovr_distance_joint]]
	function lovr.physics.newDistanceJoint(colliderA, colliderB, x1, y1, z1, x2, y2, z2) return DistanceJoint_class end

	--[[https://lovr.org/docs/lovr.physics.newHingeJoint  ]]
	--[[Create a new HingeJoint.  ]]
	--[[### See also]]
	--[[* [`lovr.physics.newBallJoint`](lua://lovr.physics.newBallJoint)]]
	--[[* [`lovr.physics.newDistanceJoint`](lua://lovr.physics.newDistanceJoint)]]
	--[[* [`lovr.physics.newSliderJoint`](lua://lovr.physics.newSliderJoint)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param colliderA lovr_collider]]
	--[[@param colliderB lovr_collider]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@return lovr_hinge_joint hinge]]
	--[[@overload fun(colliderA: lovr_collider, colliderB: lovr_collider, anchor: lovr_vec3, axis: lovr_vec3): lovr_hinge_joint]]
	function lovr.physics.newHingeJoint(colliderA, colliderB, x, y, z, ax, ay, az) return HingeJoint_class end

	--[[https://lovr.org/docs/lovr.physics.newMeshShape  ]]
	--[[Create a new MeshShape.  ]]
	--[[### See also]]
	--[[* [`MeshShape`](lua://lovr_meshShape)]]
	--[[* [`lovr.physics.newBoxShape`](lua://lovr.physics.newBoxShape)]]
	--[[* [`lovr.physics.newCapsuleShape`](lua://lovr.physics.newCapsuleShape)]]
	--[[* [`lovr.physics.newCylinderShape`](lua://lovr.physics.newCylinderShape)]]
	--[[* [`lovr.physics.newSphereShape`](lua://lovr.physics.newSphereShape)]]
	--[[* [`lovr.physics.newTerrainShape`](lua://lovr.physics.newTerrainShape)]]
	--[[* [`Model:getTriangles`](lua://lovr_model.getTriangles)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param vertices table<string,string|number>]]
	--[[@param indices table<string,string|number>]]
	--[[@return lovr_mesh_shape mesh]]
	--[[@overload fun(model: lovr_model): lovr_mesh_shape]]
	function lovr.physics.newMeshShape(vertices, indices) return MeshShape_class end

	--[[https://lovr.org/docs/lovr.physics.newSliderJoint  ]]
	--[[Create a new SliderJoint.  ]]
	--[[### See also]]
	--[[* [`lovr.physics.newBallJoint`](lua://lovr.physics.newBallJoint)]]
	--[[* [`lovr.physics.newDistanceJoint`](lua://lovr.physics.newDistanceJoint)]]
	--[[* [`lovr.physics.newHingeJoint`](lua://lovr.physics.newHingeJoint)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param colliderA lovr_collider]]
	--[[@param colliderB lovr_collider]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@return lovr_slider_joint slider]]
	--[[@overload fun(colliderA: lovr_collider, colliderB: lovr_collider, axis: lovr_vec3): lovr_slider_joint]]
	function lovr.physics.newSliderJoint(colliderA, colliderB, ax, ay, az) return SliderJoint_class end

	--[[https://lovr.org/docs/lovr.physics.newSphereShape  ]]
	--[[Create a new SphereShape.  ]]
	--[[### See also]]
	--[[* [`SphereShape`](lua://lovr_sphereShape)]]
	--[[* [`lovr.physics.newBoxShape`](lua://lovr.physics.newBoxShape)]]
	--[[* [`lovr.physics.newCapsuleShape`](lua://lovr.physics.newCapsuleShape)]]
	--[[* [`lovr.physics.newCylinderShape`](lua://lovr.physics.newCylinderShape)]]
	--[[* [`lovr.physics.newMeshShape`](lua://lovr.physics.newMeshShape)]]
	--[[* [`lovr.physics.newTerrainShape`](lua://lovr.physics.newTerrainShape)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param radius? number default=`1`]]
	--[[@return lovr_sphere_shape sphere]]
	function lovr.physics.newSphereShape(radius) return SphereShape_class end

	--[[https://lovr.org/docs/lovr.physics.newTerrainShape  ]]
	--[[Create a new TerrainShape.  ]]
	--[[### See also]]
	--[[* [`TerrainShape`](lua://lovr_terrainShape)]]
	--[[* [`lovr.physics.newBoxShape`](lua://lovr.physics.newBoxShape)]]
	--[[* [`lovr.physics.newCapsuleShape`](lua://lovr.physics.newCapsuleShape)]]
	--[[* [`lovr.physics.newCylinderShape`](lua://lovr.physics.newCylinderShape)]]
	--[[* [`lovr.physics.newMeshShape`](lua://lovr.physics.newMeshShape)]]
	--[[* [`lovr.physics.newSphereShape`](lua://lovr.physics.newSphereShape)]]
	--[[* [`lovr.data.newImage`](lua://lovr.data.newImage)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param scale number]]
	--[[@return lovr_terrain_shape terrain]]
	--[[@overload fun(scale: number, heightmap: lovr_image, stretch?: number): lovr_terrain_shape]]
	--[[@overload fun(scale: number, callback: function, samples?: number): lovr_terrain_shape]]
	function lovr.physics.newTerrainShape(scale) return TerrainShape_class end

	--[[https://lovr.org/docs/lovr.physics.newWeldJoint  ]]
	--[[Create a new WeldJoint.  ]]
	--[[### See also]]
	--[[* [`lovr.physics.newBallJoint`](lua://lovr.physics.newBallJoint)]]
	--[[* [`lovr.physics.newConeJoint`](lua://lovr.physics.newConeJoint)]]
	--[[* [`lovr.physics.newDistanceJoint`](lua://lovr.physics.newDistanceJoint)]]
	--[[* [`lovr.physics.newHingeJoint`](lua://lovr.physics.newHingeJoint)]]
	--[[* [`lovr.physics.newSliderJoint`](lua://lovr.physics.newSliderJoint)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param colliderA lovr_collider]]
	--[[@param colliderB lovr_collider]]
	--[[@return lovr_weld_joint joint]]
	function lovr.physics.newWeldJoint(colliderA, colliderB) return WeldJoint_class end

	--[[https://lovr.org/docs/lovr.physics.newWorld  ]]
	--[[Create a new World.  ]]
	--[[### See also]]
	--[[* [`World:update`](lua://lovr_world.update)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@param settings lovr_physics_new_world_settings]]
	--[[@return lovr_world world]]
	function lovr.physics.newWorld(settings) return World_class end

	--[[https://lovr.org/docs/lovr.physics.newWorld  ]]
	--[[see also:  ]]
	--[[[`lovr.physics.newWorld`](lua://lovr.physics.newWorld)  ]]
	--[[@class lovr_physics_new_world_settings]]
	--[[@field tags? table<string,string|number> default=`{}`]]
	--[[@field staticTags? table<string,string|number> default=`{}`]]
	--[[@field tickRate? number default=`60`]]
	--[[@field tickLimit? number default=`0`]]
	--[[@field maxColliders? number default=`16384`]]
	--[[@field deterministic? boolean default=`true`]]
	--[[@field threadSafe? boolean default=`true`]]
	--[[@field allowSleep? boolean default=`true`]]
	--[[@field stabilization? number default=`0.2`]]
	--[[@field maxPenetration? number default=`.01`]]
	--[[@field minBounceVelocity? number default=`1.0`]]
	--[[@field velocitySteps? number default=`10`]]
	--[[@field positionSteps? number default=`2`]]

	--[[https://lovr.org/docs/Shape  ]]
	--[[Defines the shape of Colliders.  ]]
	--[[@class lovr_shape: lovr_object]]

	--[[https://lovr.org/docs/Shape:destroy  ]]
	--[[Destroy the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:isDestroyed`](lua://lovr_shape.isDestroyed)]]
	--[[* [`Collider:destroy`](lua://lovr_collider.destroy)]]
	--[[* [`Joint:destroy`](lua://lovr_joint.destroy)]]
	--[[* [`World:destroy`](lua://lovr_world.destroy)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	function Shape_class:destroy() end

	--[[https://lovr.org/docs/Shape:getAABB  ]]
	--[[Get the Shape's axis aligned bounding box.  ]]
	--[[### See also]]
	--[[* [`Collider:getAABB`](lua://lovr_collider.getAABB)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number minx]]
	--[[@return number maxx]]
	--[[@return number miny]]
	--[[@return number maxy]]
	--[[@return number minz]]
	--[[@return number maxz]]
	function Shape_class:getAABB() return 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Shape:getCenterOfMass  ]]
	--[[Get the center of mass of the Shape.  ]]
	--[[### See also]]
	--[[* [`Collider:getCenterOfMass`](lua://lovr_collider.getCenterOfMass)]]
	--[[* [`Shape:getOffset`](lua://lovr_shape.getOffset)]]
	--[[* [`Shape:setOffset`](lua://lovr_shape.setOffset)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Shape_class:getCenterOfMass() return 0, 0, 0 end

	--[[https://lovr.org/docs/Shape:getCollider  ]]
	--[[Get the Collider the Shape is attached to.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[* [`Collider:getShape`](lua://lovr_collider.getShape)]]
	--[[* [`Collider:getShapes`](lua://lovr_collider.getShapes)]]
	--[[* [`Collider:addShape`](lua://lovr_collider.addShape)]]
	--[[* [`Collider:removeShape`](lua://lovr_collider.removeShape)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return lovr_collider collider]]
	function Shape_class:getCollider() return Collider_class end

	--[[https://lovr.org/docs/Shape:getDensity  ]]
	--[[Get the density of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:getVolume`](lua://lovr_shape.getVolume)]]
	--[[* [`Shape:getMass`](lua://lovr_shape.getMass)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number density]]
	function Shape_class:getDensity() return 0 end

	--[[https://lovr.org/docs/Shape:getInertia  ]]
	--[[Get the inertia of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:getMass`](lua://lovr_shape.getMass)]]
	--[[* [`Shape:getCenterOfMass`](lua://lovr_shape.getCenterOfMass)]]
	--[[* [`Collider:getInertia`](lua://lovr_collider.getInertia)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number dx]]
	--[[@return number dy]]
	--[[@return number dz]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Shape_class:getInertia() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Shape:getMass  ]]
	--[[Get the mass of the Shape.  ]]
	--[[### See also]]
	--[[* [`Collider:getMass`](lua://lovr_collider.getMass)]]
	--[[* [`Collider:setMass`](lua://lovr_collider.setMass)]]
	--[[* [`Collider:resetMassData`](lua://lovr_collider.resetMassData)]]
	--[[* [`Shape:getVolume`](lua://lovr_shape.getVolume)]]
	--[[* [`Shape:getDensity`](lua://lovr_shape.getDensity)]]
	--[[* [`Shape:setDensity`](lua://lovr_shape.setDensity)]]
	--[[* [`Shape:getInertia`](lua://lovr_shape.getInertia)]]
	--[[* [`Shape:getCenterOfMass`](lua://lovr_shape.getCenterOfMass)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number mass]]
	function Shape_class:getMass() return 0 end

	--[[https://lovr.org/docs/Shape:getOffset  ]]
	--[[Get the local offset of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:getPosition`](lua://lovr_shape.getPosition)]]
	--[[* [`Shape:getOrientation`](lua://lovr_shape.getOrientation)]]
	--[[* [`Shape:getPose`](lua://lovr_shape.getPose)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Shape_class:getOffset() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Shape:getOrientation  ]]
	--[[Get the orientation of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:getPosition`](lua://lovr_shape.getPosition)]]
	--[[* [`Shape:getPose`](lua://lovr_shape.getPose)]]
	--[[* [`Shape:getOffset`](lua://lovr_shape.getOffset)]]
	--[[* [`Shape:setOffset`](lua://lovr_shape.setOffset)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Shape_class:getOrientation() return 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Shape:getPose  ]]
	--[[Get the pose of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:getPosition`](lua://lovr_shape.getPosition)]]
	--[[* [`Shape:getOrientation`](lua://lovr_shape.getOrientation)]]
	--[[* [`Shape:getOffset`](lua://lovr_shape.getOffset)]]
	--[[* [`Shape:setOffset`](lua://lovr_shape.setOffset)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	--[[@return number angle]]
	--[[@return number ax]]
	--[[@return number ay]]
	--[[@return number az]]
	function Shape_class:getPose() return 0, 0, 0, 0, 0, 0, 0 end

	--[[https://lovr.org/docs/Shape:getPosition  ]]
	--[[Get the position of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:getOrientation`](lua://lovr_shape.getOrientation)]]
	--[[* [`Shape:getPose`](lua://lovr_shape.getPose)]]
	--[[* [`Shape:getOffset`](lua://lovr_shape.getOffset)]]
	--[[* [`Shape:setOffset`](lua://lovr_shape.setOffset)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function Shape_class:getPosition() return 0, 0, 0 end

	--[[https://lovr.org/docs/Shape:getType  ]]
	--[[Get the type of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return lovr_shape_type type]]
	function Shape_class:getType() return ShapeType_class end

	--[[https://lovr.org/docs/Shape:getUserData  ]]
	--[[Get the Lua value associated with the Shape.  ]]
	--[[### See also]]
	--[[* [`Collider:getUserData`](lua://lovr_collider.getUserData)]]
	--[[* [`Collider:setUserData`](lua://lovr_collider.setUserData)]]
	--[[* [`Joint:getUserData`](lua://lovr_joint.getUserData)]]
	--[[* [`Joint:setUserData`](lua://lovr_joint.setUserData)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return unknown data]]
	function Shape_class:getUserData() return nil end

	--[[https://lovr.org/docs/Shape:getVolume  ]]
	--[[Get the volume of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:getDensity`](lua://lovr_shape.getDensity)]]
	--[[* [`Shape:setDensity`](lua://lovr_shape.setDensity)]]
	--[[* [`Shape:getMass`](lua://lovr_shape.getMass)]]
	--[[* [`Shape:getAABB`](lua://lovr_shape.getAABB)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return number volume]]
	function Shape_class:getVolume() return 0 end

	--[[https://lovr.org/docs/Shape:isDestroyed  ]]
	--[[Check if the Shape is destroyed.  ]]
	--[[### See also]]
	--[[* [`Shape:destroy`](lua://lovr_shape.destroy)]]
	--[[* [`Collider:isDestroyed`](lua://lovr_collider.isDestroyed)]]
	--[[* [`Joint:isDestroyed`](lua://lovr_joint.isDestroyed)]]
	--[[* [`World:isDestroyed`](lua://lovr_world.isDestroyed)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@return boolean destroyed]]
	function Shape_class:isDestroyed() return false end

	--[[https://lovr.org/docs/Shape:setDensity  ]]
	--[[Set the density of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:getVolume`](lua://lovr_shape.getVolume)]]
	--[[* [`Shape:getMass`](lua://lovr_shape.getMass)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@param density number]]
	function Shape_class:setDensity(density) end

	--[[https://lovr.org/docs/Shape:setOffset  ]]
	--[[Set the local offset of the Shape.  ]]
	--[[### See also]]
	--[[* [`Shape:getPosition`](lua://lovr_shape.getPosition)]]
	--[[* [`Shape:getOrientation`](lua://lovr_shape.getOrientation)]]
	--[[* [`Shape:getPose`](lua://lovr_shape.getPose)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@overload fun(self: lovr_shape, position: lovr_vec3, rotation: lovr_quat)]]
	function Shape_class:setOffset(x, y, z, angle, ax, ay, az) end

	--[[https://lovr.org/docs/Shape:setUserData  ]]
	--[[Associate a Lua value with the Shape.  ]]
	--[[### See also]]
	--[[* [`Collider:getUserData`](lua://lovr_collider.getUserData)]]
	--[[* [`Collider:setUserData`](lua://lovr_collider.setUserData)]]
	--[[* [`Joint:getUserData`](lua://lovr_joint.getUserData)]]
	--[[* [`Joint:setUserData`](lua://lovr_joint.setUserData)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[@param data unknown]]
	function Shape_class:setUserData(data) end

	--[[https://lovr.org/docs/ShapeType  ]]
	--[[Types of physics shapes.  ]]
	--[[### See also]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[* [`BoxShape`](lua://lovr_boxShape)]]
	--[[* [`SphereShape`](lua://lovr_sphereShape)]]
	--[[* [`CapsuleShape`](lua://lovr_capsuleShape)]]
	--[[* [`CylinderShape`](lua://lovr_cylinderShape)]]
	--[[* [`ConvexShape`](lua://lovr_convexShape)]]
	--[[* [`MeshShape`](lua://lovr_meshShape)]]
	--[[* [`TerrainShape`](lua://lovr_terrainShape)]]
	--[[* [`lovr.physics`](lua://lovr.physics)]]
	--[[@enum lovr_shape_type]]
	local lovr_shape_type = {
		--[[A box.  ]]
		box = "box",
		--[[A sphere.  ]]
		sphere = "sphere",
		--[[A capsule (cylinder with rounded ends).  ]]
		capsule = "capsule",
		--[[A cylinder.  ]]
		cylinder = "cylinder",
		--[[A convex hull.  ]]
		convex = "convex",
		--[[A triangle mesh.  Colliders with this shape can not move.  ]]
		mesh = "mesh",
		--[[A heightfield.  Colliders with this shape can not move.  ]]
		terrain = "terrain",
	}

	--[[https://lovr.org/docs/SliderJoint  ]]
	--[[A slider joint.  ]]
	--[[@class lovr_slider_joint: lovr_object]]

	--[[https://lovr.org/docs/SliderJoint:getAxis  ]]
	--[[Get the axis of the SliderJoint.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getPosition`](lua://lovr_sliderJoint.getPosition)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return number x]]
	--[[@return number y]]
	--[[@return number z]]
	function SliderJoint_class:getAxis() return 0, 0, 0 end

	--[[https://lovr.org/docs/SliderJoint:getFriction  ]]
	--[[Get the friction of the SliderJoint.  ]]
	--[[### See also]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return number friction]]
	function SliderJoint_class:getFriction() return 0 end

	--[[https://lovr.org/docs/SliderJoint:getLimits  ]]
	--[[Get the position limits of the SliderJoint.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getPosition`](lua://lovr_sliderJoint.getPosition)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return number min]]
	--[[@return number max]]
	function SliderJoint_class:getLimits() return 0, 0 end

	--[[https://lovr.org/docs/SliderJoint:getMaxMotorForce  ]]
	--[[Get the maximum amount of force the motor can use.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getMotorForce`](lua://lovr_sliderJoint.getMotorForce)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return number positive]]
	--[[@return number negative]]
	function SliderJoint_class:getMaxMotorForce() return 0, 0 end

	--[[https://lovr.org/docs/SliderJoint:getMotorForce  ]]
	--[[Get the current motor force.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getMaxMotorForce`](lua://lovr_sliderJoint.getMaxMotorForce)]]
	--[[* [`SliderJoint:setMaxMotorForce`](lua://lovr_sliderJoint.setMaxMotorForce)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return number force]]
	function SliderJoint_class:getMotorForce() return 0 end

	--[[https://lovr.org/docs/SliderJoint:getMotorMode  ]]
	--[[Get the motor mode of the SliderJoint.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getMotorTarget`](lua://lovr_sliderJoint.getMotorTarget)]]
	--[[* [`SliderJoint:setMotorTarget`](lua://lovr_sliderJoint.setMotorTarget)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return lovr_motor_mode mode]]
	function SliderJoint_class:getMotorMode() return MotorMode_class end

	--[[https://lovr.org/docs/SliderJoint:getMotorSpring  ]]
	--[[Get the spring parameters of the motor target.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getSpring`](lua://lovr_sliderJoint.getSpring)]]
	--[[* [`SliderJoint:setSpring`](lua://lovr_sliderJoint.setSpring)]]
	--[[* [`SliderJoint:getMotorTarget`](lua://lovr_sliderJoint.getMotorTarget)]]
	--[[* [`SliderJoint:setMotorTarget`](lua://lovr_sliderJoint.setMotorTarget)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return number frequency]]
	--[[@return number damping]]
	function SliderJoint_class:getMotorSpring() return 0, 0 end

	--[[https://lovr.org/docs/SliderJoint:getMotorTarget  ]]
	--[[Get the target of the slider motor.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getMotorMode`](lua://lovr_sliderJoint.getMotorMode)]]
	--[[* [`SliderJoint:setMotorMode`](lua://lovr_sliderJoint.setMotorMode)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return number target]]
	function SliderJoint_class:getMotorTarget() return 0 end

	--[[https://lovr.org/docs/SliderJoint:getPosition  ]]
	--[[Get how far the SliderJoint is extended.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getAxis`](lua://lovr_sliderJoint.getAxis)]]
	--[[* [`SliderJoint:setLimits`](lua://lovr_sliderJoint.setLimits)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return number position]]
	function SliderJoint_class:getPosition() return 0 end

	--[[https://lovr.org/docs/SliderJoint:getSpring  ]]
	--[[Get the spring parameters of the SliderJoint limits.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getMotorSpring`](lua://lovr_sliderJoint.getMotorSpring)]]
	--[[* [`SliderJoint:setMotorSpring`](lua://lovr_sliderJoint.setMotorSpring)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@return number frequency]]
	--[[@return number damping]]
	function SliderJoint_class:getSpring() return 0, 0 end

	--[[https://lovr.org/docs/SliderJoint:setFriction  ]]
	--[[Set the friction of the SliderJoint.  ]]
	--[[### See also]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@param friction number]]
	function SliderJoint_class:setFriction(friction) end

	--[[https://lovr.org/docs/SliderJoint:setLimits  ]]
	--[[Set the position limits of the SliderJoint.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getPosition`](lua://lovr_sliderJoint.getPosition)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@param min number]]
	--[[@param max number]]
	--[[@overload fun(self: lovr_slider_joint)]]
	function SliderJoint_class:setLimits(min, max) end

	--[[https://lovr.org/docs/SliderJoint:setMaxMotorForce  ]]
	--[[Set the maximum amount of force the motor can use.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getMotorForce`](lua://lovr_sliderJoint.getMotorForce)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@param positive? number default=`math.huge`]]
	--[[@param negative? number default=`positive`]]
	function SliderJoint_class:setMaxMotorForce(positive, negative) end

	--[[https://lovr.org/docs/SliderJoint:setMotorMode  ]]
	--[[Set the motor mode of the SliderJoint.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getMotorTarget`](lua://lovr_sliderJoint.getMotorTarget)]]
	--[[* [`SliderJoint:setMotorTarget`](lua://lovr_sliderJoint.setMotorTarget)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@param mode lovr_motor_mode]]
	--[[@overload fun(self: lovr_slider_joint)]]
	function SliderJoint_class:setMotorMode(mode) end

	--[[https://lovr.org/docs/SliderJoint:setMotorSpring  ]]
	--[[Set the spring parameters of the motor target.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getSpring`](lua://lovr_sliderJoint.getSpring)]]
	--[[* [`SliderJoint:setSpring`](lua://lovr_sliderJoint.setSpring)]]
	--[[* [`SliderJoint:getMotorTarget`](lua://lovr_sliderJoint.getMotorTarget)]]
	--[[* [`SliderJoint:setMotorTarget`](lua://lovr_sliderJoint.setMotorTarget)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@param frequency? number default=`0.0`]]
	--[[@param damping? number default=`1.0`]]
	function SliderJoint_class:setMotorSpring(frequency, damping) end

	--[[https://lovr.org/docs/SliderJoint:setMotorTarget  ]]
	--[[Set the target of the slider motor.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getMotorMode`](lua://lovr_sliderJoint.getMotorMode)]]
	--[[* [`SliderJoint:setMotorMode`](lua://lovr_sliderJoint.setMotorMode)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@param target number]]
	function SliderJoint_class:setMotorTarget(target) end

	--[[https://lovr.org/docs/SliderJoint:setSpring  ]]
	--[[Set the spring parameters of the SliderJoint limits.  ]]
	--[[### See also]]
	--[[* [`SliderJoint:getMotorSpring`](lua://lovr_sliderJoint.getMotorSpring)]]
	--[[* [`SliderJoint:setMotorSpring`](lua://lovr_sliderJoint.setMotorSpring)]]
	--[[* [`SliderJoint`](lua://lovr_sliderJoint)]]
	--[[@param frequency? number default=`0.0`]]
	--[[@param damping? number default=`1.0`]]
	function SliderJoint_class:setSpring(frequency, damping) end

	--[[https://lovr.org/docs/SphereShape  ]]
	--[[A sphere Shape.  ]]
	--[[@class lovr_sphere_shape: lovr_object]]

	--[[https://lovr.org/docs/SphereShape:getRadius  ]]
	--[[Get the radius of the SphereShape.  ]]
	--[[### See also]]
	--[[* [`SphereShape`](lua://lovr_sphereShape)]]
	--[[@return number radius]]
	function SphereShape_class:getRadius() return 0 end

	--[[https://lovr.org/docs/SphereShape:setRadius  ]]
	--[[Set the radius of the SphereShape.  ]]
	--[[### See also]]
	--[[* [`SphereShape`](lua://lovr_sphereShape)]]
	--[[@param radius number]]
	function SphereShape_class:setRadius(radius) end

	--[[https://lovr.org/docs/TerrainShape  ]]
	--[[A terrain Shape.  ]]
	--[[@class lovr_terrain_shape: lovr_object]]

	--[[https://lovr.org/docs/WeldJoint  ]]
	--[[A joint that welds two colliders together.  ]]
	--[[@class lovr_weld_joint: lovr_object]]

	--[[https://lovr.org/docs/World  ]]
	--[[An object holding all the colliders and joints in a physics simulation.  ]]
	--[[@class lovr_world: lovr_object]]

	--[[https://lovr.org/docs/World:destroy  ]]
	--[[Destroy the World!!  Muahaha!  ]]
	--[[### See also]]
	--[[* [`Collider:destroy`](lua://lovr_collider.destroy)]]
	--[[* [`Shape:destroy`](lua://lovr_shape.destroy)]]
	--[[* [`Joint:destroy`](lua://lovr_joint.destroy)]]
	--[[* [`World`](lua://lovr_world)]]
	function World_class:destroy() end

	--[[https://lovr.org/docs/World:disableCollisionBetween  ]]
	--[[Disable collision between two tags.  ]]
	--[[### See also]]
	--[[* [`World:enableCollisionBetween`](lua://lovr_world.enableCollisionBetween)]]
	--[[* [`World:isCollisionEnabledBetween`](lua://lovr_world.isCollisionEnabledBetween)]]
	--[[* [`lovr.physics.newWorld`](lua://lovr.physics.newWorld)]]
	--[[* [`World:getTags`](lua://lovr_world.getTags)]]
	--[[* [`Collider:setTag`](lua://lovr_collider.setTag)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param tag1 string]]
	--[[@param tag2 string]]
	function World_class:disableCollisionBetween(tag1, tag2) end

	--[[https://lovr.org/docs/World:enableCollisionBetween  ]]
	--[[Enable collision between two tags.  ]]
	--[[### See also]]
	--[[* [`World:disableCollisionBetween`](lua://lovr_world.disableCollisionBetween)]]
	--[[* [`World:isCollisionEnabledBetween`](lua://lovr_world.isCollisionEnabledBetween)]]
	--[[* [`lovr.physics.newWorld`](lua://lovr.physics.newWorld)]]
	--[[* [`World:getTags`](lua://lovr_world.getTags)]]
	--[[* [`Collider:setTag`](lua://lovr_collider.setTag)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param tag1 string]]
	--[[@param tag2 string]]
	function World_class:enableCollisionBetween(tag1, tag2) end

	--[[https://lovr.org/docs/World:getAngularDamping  ]]
	--[[Get the angular damping of the World.  ]]
	--[[### See also]]
	--[[* [`Collider:getAngularDamping`](lua://lovr_collider.getAngularDamping)]]
	--[[* [`Collider:setAngularDamping`](lua://lovr_collider.setAngularDamping)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return number damping]]
	--[[@return number threshold]]
	--[[@deprecated]]
	function World_class:getAngularDamping() return 0, 0 end

	--[[https://lovr.org/docs/World:getCallbacks  ]]
	--[[Get the World's collision callbacks.  ]]
	--[[### See also]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return lovr_physics_world_get_callbacks_callbacks callbacks]]
	function World_class:getCallbacks() return {} end

	--[[https://lovr.org/docs/World:getColliderCount  ]]
	--[[Get the number of colliders in the world.  ]]
	--[[### See also]]
	--[[* [`World:getColliders`](lua://lovr_world.getColliders)]]
	--[[* [`World:getJointCount`](lua://lovr_world.getJointCount)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return number count]]
	function World_class:getColliderCount() return 0 end

	--[[https://lovr.org/docs/World:getColliders  ]]
	--[[Get a list of colliders in the World.  ]]
	--[[### See also]]
	--[[* [`World:getColliderCount`](lua://lovr_world.getColliderCount)]]
	--[[* [`World:getJoints`](lua://lovr_world.getJoints)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return table<string,string|number> colliders]]
	function World_class:getColliders() return {} end

	--[[https://lovr.org/docs/World:getGravity  ]]
	--[[Get the gravity of the World.  ]]
	--[[### See also]]
	--[[* [`Collider:getGravityScale`](lua://lovr_collider.getGravityScale)]]
	--[[* [`Collider:setGravityScale`](lua://lovr_collider.setGravityScale)]]
	--[[* [`Collider:getLinearDamping`](lua://lovr_collider.getLinearDamping)]]
	--[[* [`Collider:setLinearDamping`](lua://lovr_collider.setLinearDamping)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return number gx]]
	--[[@return number gy]]
	--[[@return number gz]]
	function World_class:getGravity() return 0, 0, 0 end

	--[[https://lovr.org/docs/World:getJointCount  ]]
	--[[Get the number of joints in the world.  ]]
	--[[### See also]]
	--[[* [`World:getJoints`](lua://lovr_world.getJoints)]]
	--[[* [`World:getColliderCount`](lua://lovr_world.getColliderCount)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return number count]]
	function World_class:getJointCount() return 0 end

	--[[https://lovr.org/docs/World:getJoints  ]]
	--[[Get a list of joints in the World.  ]]
	--[[### See also]]
	--[[* [`World:getJointCount`](lua://lovr_world.getJointCount)]]
	--[[* [`World:getColliders`](lua://lovr_world.getColliders)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return table<string,string|number> joints]]
	function World_class:getJoints() return {} end

	--[[https://lovr.org/docs/World:getLinearDamping  ]]
	--[[Get the linear damping of the World.  ]]
	--[[### See also]]
	--[[* [`Collider:getLinearDamping`](lua://lovr_collider.getLinearDamping)]]
	--[[* [`Collider:setLinearDamping`](lua://lovr_collider.setLinearDamping)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return number damping]]
	--[[@return number threshold]]
	--[[@deprecated]]
	function World_class:getLinearDamping() return 0, 0 end

	--[[https://lovr.org/docs/World:getResponseTime  ]]
	--[[Get the response time of the World.  ]]
	--[[### See also]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return number responseTime]]
	--[[@deprecated]]
	function World_class:getResponseTime() return 0 end

	--[[https://lovr.org/docs/World:getStepCount  ]]
	--[[Get the step count of the World.  ]]
	--[[### See also]]
	--[[* [`World:update`](lua://lovr_world.update)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return number steps]]
	--[[@deprecated]]
	function World_class:getStepCount() return 0 end

	--[[https://lovr.org/docs/World:getTags  ]]
	--[[Get the World's list of collision tags.  ]]
	--[[### See also]]
	--[[* [`lovr.physics.newWorld`](lua://lovr.physics.newWorld)]]
	--[[* [`Collider:getTag`](lua://lovr_collider.getTag)]]
	--[[* [`Collider:setTag`](lua://lovr_collider.setTag)]]
	--[[* [`World:enableCollisionBetween`](lua://lovr_world.enableCollisionBetween)]]
	--[[* [`World:disableCollisionBetween`](lua://lovr_world.disableCollisionBetween)]]
	--[[* [`World:isCollisionEnabledBetween`](lua://lovr_world.isCollisionEnabledBetween)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return table<string,string|number> tags]]
	function World_class:getTags() return {} end

	--[[https://lovr.org/docs/World:getTightness  ]]
	--[[Get the tightness of joints in the World.  ]]
	--[[### See also]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return number tightness]]
	--[[@deprecated]]
	function World_class:getTightness() return 0 end

	--[[https://lovr.org/docs/World:isCollisionEnabledBetween  ]]
	--[[Check if two tags can collide.  ]]
	--[[### See also]]
	--[[* [`World:disableCollisionBetween`](lua://lovr_world.disableCollisionBetween)]]
	--[[* [`World:enableCollisionBetween`](lua://lovr_world.enableCollisionBetween)]]
	--[[* [`lovr.physics.newWorld`](lua://lovr.physics.newWorld)]]
	--[[* [`World:getTags`](lua://lovr_world.getTags)]]
	--[[* [`Collider:setTag`](lua://lovr_collider.setTag)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param tag1 string]]
	--[[@param tag2 string]]
	--[[@return boolean enabled]]
	function World_class:isCollisionEnabledBetween(tag1, tag2) return false end

	--[[https://lovr.org/docs/World:isDestroyed  ]]
	--[[Check if the World has been destroyed.  ]]
	--[[### See also]]
	--[[* [`World:destroy`](lua://lovr_world.destroy)]]
	--[[* [`Collider:isDestroyed`](lua://lovr_collider.isDestroyed)]]
	--[[* [`Shape:isDestroyed`](lua://lovr_shape.isDestroyed)]]
	--[[* [`Joint:isDestroyed`](lua://lovr_joint.isDestroyed)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return boolean destroyed]]
	function World_class:isDestroyed() return false end

	--[[https://lovr.org/docs/World:isSleepingAllowed  ]]
	--[[Check if colliders can go to sleep.  ]]
	--[[### See also]]
	--[[* [`Collider:isSleepingAllowed`](lua://lovr_collider.isSleepingAllowed)]]
	--[[* [`Collider:setSleepingAllowed`](lua://lovr_collider.setSleepingAllowed)]]
	--[[* [`Collider:isAwake`](lua://lovr_collider.isAwake)]]
	--[[* [`Collider:setAwake`](lua://lovr_collider.setAwake)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@return boolean allowed]]
	--[[@deprecated]]
	function World_class:isSleepingAllowed() return false end

	--[[https://lovr.org/docs/World:newBoxCollider  ]]
	--[[Add a Collider with a BoxShape to the World.  ]]
	--[[### See also]]
	--[[* [`BoxShape`](lua://lovr_boxShape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[* [`World:newCollider`](lua://lovr_world.newCollider)]]
	--[[* [`World:newSphereCollider`](lua://lovr_world.newSphereCollider)]]
	--[[* [`World:newCapsuleCollider`](lua://lovr_world.newCapsuleCollider)]]
	--[[* [`World:newCylinderCollider`](lua://lovr_world.newCylinderCollider)]]
	--[[* [`World:newConvexCollider`](lua://lovr_world.newConvexCollider)]]
	--[[* [`World:newMeshCollider`](lua://lovr_world.newMeshCollider)]]
	--[[* [`World:newTerrainCollider`](lua://lovr_world.newTerrainCollider)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param width? number default=`1`]]
	--[[@param height? number default=`width`]]
	--[[@param depth? number default=`width`]]
	--[[@return lovr_collider collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, size: lovr_vec3): lovr_collider]]
	function World_class:newBoxCollider(x, y, z, width, height, depth) return Collider_class end

	--[[https://lovr.org/docs/World:newCapsuleCollider  ]]
	--[[Add a Collider with a CapsuleShape to the World.  ]]
	--[[### See also]]
	--[[* [`CapsuleShape`](lua://lovr_capsuleShape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[* [`World:newCollider`](lua://lovr_world.newCollider)]]
	--[[* [`World:newBoxCollider`](lua://lovr_world.newBoxCollider)]]
	--[[* [`World:newSphereCollider`](lua://lovr_world.newSphereCollider)]]
	--[[* [`World:newCylinderCollider`](lua://lovr_world.newCylinderCollider)]]
	--[[* [`World:newConvexCollider`](lua://lovr_world.newConvexCollider)]]
	--[[* [`World:newMeshCollider`](lua://lovr_world.newMeshCollider)]]
	--[[* [`World:newTerrainCollider`](lua://lovr_world.newTerrainCollider)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param radius? number default=`1`]]
	--[[@param length? number default=`1`]]
	--[[@return lovr_collider collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, radius?: number, length?: number): lovr_collider]]
	function World_class:newCapsuleCollider(x, y, z, radius, length) return Collider_class end

	--[[https://lovr.org/docs/World:newCollider  ]]
	--[[Add a Collider to the World.  ]]
	--[[### See also]]
	--[[* [`World:newBoxCollider`](lua://lovr_world.newBoxCollider)]]
	--[[* [`World:newSphereCollider`](lua://lovr_world.newSphereCollider)]]
	--[[* [`World:newCapsuleCollider`](lua://lovr_world.newCapsuleCollider)]]
	--[[* [`World:newCylinderCollider`](lua://lovr_world.newCylinderCollider)]]
	--[[* [`World:newConvexCollider`](lua://lovr_world.newConvexCollider)]]
	--[[* [`World:newMeshCollider`](lua://lovr_world.newMeshCollider)]]
	--[[* [`World:newTerrainCollider`](lua://lovr_world.newTerrainCollider)]]
	--[[* [`Collider:addShape`](lua://lovr_collider.addShape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[* [`Shape`](lua://lovr_shape)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@return lovr_collider collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3): lovr_collider]]
	function World_class:newCollider(x, y, z) return Collider_class end

	--[[https://lovr.org/docs/World:newConvexCollider  ]]
	--[[Add a Collider with a ConvexShape to the World.  ]]
	--[[### See also]]
	--[[* [`ConvexShape`](lua://lovr_convexShape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[* [`World:newCollider`](lua://lovr_world.newCollider)]]
	--[[* [`World:newBoxCollider`](lua://lovr_world.newBoxCollider)]]
	--[[* [`World:newSphereCollider`](lua://lovr_world.newSphereCollider)]]
	--[[* [`World:newCapsuleCollider`](lua://lovr_world.newCapsuleCollider)]]
	--[[* [`World:newCylinderCollider`](lua://lovr_world.newCylinderCollider)]]
	--[[* [`World:newMeshCollider`](lua://lovr_world.newMeshCollider)]]
	--[[* [`World:newTerrainCollider`](lua://lovr_world.newTerrainCollider)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param points table<string,string|number>]]
	--[[@return lovr_collider collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, points: table<string,string|number>): lovr_collider]]
	--[[@overload fun(self: lovr_world, x?: number, y?: number, z?: number, modelData: lovr_model_data): lovr_collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, modelData: lovr_model_data): lovr_collider]]
	--[[@overload fun(self: lovr_world, x?: number, y?: number, z?: number, model: lovr_model): lovr_collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, model: lovr_model): lovr_collider]]
	--[[@overload fun(self: lovr_world, x?: number, y?: number, z?: number, mesh: lovr_mesh): lovr_collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, mesh: lovr_mesh): lovr_collider]]
	--[[@overload fun(self: lovr_world, x?: number, y?: number, z?: number, template: lovr_convex_shape): lovr_collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, template: lovr_convex_shape): lovr_collider]]
	function World_class:newConvexCollider(x, y, z, points) return Collider_class end

	--[[https://lovr.org/docs/World:newCylinderCollider  ]]
	--[[Add a Collider with a CylinderShape to the World.  ]]
	--[[### See also]]
	--[[* [`CylinderShape`](lua://lovr_cylinderShape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[* [`World:newCollider`](lua://lovr_world.newCollider)]]
	--[[* [`World:newBoxCollider`](lua://lovr_world.newBoxCollider)]]
	--[[* [`World:newSphereCollider`](lua://lovr_world.newSphereCollider)]]
	--[[* [`World:newCapsuleCollider`](lua://lovr_world.newCapsuleCollider)]]
	--[[* [`World:newConvexCollider`](lua://lovr_world.newConvexCollider)]]
	--[[* [`World:newMeshCollider`](lua://lovr_world.newMeshCollider)]]
	--[[* [`World:newTerrainCollider`](lua://lovr_world.newTerrainCollider)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param radius? number default=`1`]]
	--[[@param length? number default=`1`]]
	--[[@return lovr_collider collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, radius?: number, length?: number): lovr_collider]]
	function World_class:newCylinderCollider(x, y, z, radius, length) return Collider_class end

	--[[https://lovr.org/docs/World:newMeshCollider  ]]
	--[[Add a Collider with a MeshShape to the World.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[* [`MeshShape`](lua://lovr_meshShape)]]
	--[[* [`World:newCollider`](lua://lovr_world.newCollider)]]
	--[[* [`World:newBoxCollider`](lua://lovr_world.newBoxCollider)]]
	--[[* [`World:newSphereCollider`](lua://lovr_world.newSphereCollider)]]
	--[[* [`World:newCapsuleCollider`](lua://lovr_world.newCapsuleCollider)]]
	--[[* [`World:newCylinderCollider`](lua://lovr_world.newCylinderCollider)]]
	--[[* [`World:newConvexCollider`](lua://lovr_world.newConvexCollider)]]
	--[[* [`World:newTerrainCollider`](lua://lovr_world.newTerrainCollider)]]
	--[[* [`Model:getTriangles`](lua://lovr_model.getTriangles)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param vertices table<string,string|number>]]
	--[[@param indices table<string,string|number>]]
	--[[@return lovr_collider collider]]
	--[[@overload fun(self: lovr_world, modelData: lovr_model_data): lovr_collider]]
	--[[@overload fun(self: lovr_world, model: lovr_model): lovr_collider]]
	--[[@overload fun(self: lovr_world, mesh: lovr_mesh): lovr_collider]]
	--[[@overload fun(self: lovr_world, template: lovr_mesh_shape): lovr_collider]]
	function World_class:newMeshCollider(vertices, indices) return Collider_class end

	--[[https://lovr.org/docs/World:newSphereCollider  ]]
	--[[Add a Collider with a SphereShape to the World.  ]]
	--[[### See also]]
	--[[* [`SphereShape`](lua://lovr_sphereShape)]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[* [`World:newCollider`](lua://lovr_world.newCollider)]]
	--[[* [`World:newBoxCollider`](lua://lovr_world.newBoxCollider)]]
	--[[* [`World:newCapsuleCollider`](lua://lovr_world.newCapsuleCollider)]]
	--[[* [`World:newCylinderCollider`](lua://lovr_world.newCylinderCollider)]]
	--[[* [`World:newConvexCollider`](lua://lovr_world.newConvexCollider)]]
	--[[* [`World:newMeshCollider`](lua://lovr_world.newMeshCollider)]]
	--[[* [`World:newTerrainCollider`](lua://lovr_world.newTerrainCollider)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x? number default=`0`]]
	--[[@param y? number default=`0`]]
	--[[@param z? number default=`0`]]
	--[[@param radius? number default=`1`]]
	--[[@return lovr_collider collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, radius?: number): lovr_collider]]
	function World_class:newSphereCollider(x, y, z, radius) return Collider_class end

	--[[https://lovr.org/docs/World:newTerrainCollider  ]]
	--[[Add a Collider with a TerrainShape to the World.  ]]
	--[[### See also]]
	--[[* [`Collider`](lua://lovr_collider)]]
	--[[* [`TerrainShape`](lua://lovr_terrainShape)]]
	--[[* [`World:newCollider`](lua://lovr_world.newCollider)]]
	--[[* [`World:newBoxCollider`](lua://lovr_world.newBoxCollider)]]
	--[[* [`World:newCapsuleCollider`](lua://lovr_world.newCapsuleCollider)]]
	--[[* [`World:newCylinderCollider`](lua://lovr_world.newCylinderCollider)]]
	--[[* [`World:newSphereCollider`](lua://lovr_world.newSphereCollider)]]
	--[[* [`World:newMeshCollider`](lua://lovr_world.newMeshCollider)]]
	--[[* [`lovr.data.newImage`](lua://lovr.data.newImage)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param scale number]]
	--[[@return lovr_collider collider]]
	--[[@overload fun(self: lovr_world, scale: number, heightmap: lovr_image, stretch?: number): lovr_collider]]
	--[[@overload fun(self: lovr_world, scale: number, callback: function, samples?: number): lovr_collider]]
	function World_class:newTerrainCollider(scale) return Collider_class end

	--[[https://lovr.org/docs/World:overlapShape  ]]
	--[[Find colliders that overlap a shape.  ]]
	--[[### See also]]
	--[[* [`World:shapecast`](lua://lovr_world.shapecast)]]
	--[[* [`World:raycast`](lua://lovr_world.raycast)]]
	--[[* [`World:queryBox`](lua://lovr_world.queryBox)]]
	--[[* [`World:querySphere`](lua://lovr_world.querySphere)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param shape lovr_shape]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@param filter? string default=`nil`]]
	--[[@param callback function]]
	--[[@overload fun(self: lovr_world, shape: lovr_shape, position: lovr_vec3, orientation: lovr_quat, filter?: string, callback: function)]]
	--[[@overload fun(self: lovr_world, shape: lovr_shape, x: number, y: number, z: number, angle: number, ax: number, ay: number, az: number, filter?: string): lovr_collider, lovr_shape, number, number, number, number, number, number]]
	--[[@overload fun(self: lovr_world, shape: lovr_shape, position: lovr_vec3, orientation: lovr_quat, filter?: string): lovr_collider, lovr_shape, number, number, number, number, number, number]]
	function World_class:overlapShape(shape, x, y, z, angle, ax, ay, az, filter, callback) end

	--[[https://lovr.org/docs/World:queryBox  ]]
	--[[Find colliders that intersect an axis-aligned box.  ]]
	--[[### See also]]
	--[[* [`World:querySphere`](lua://lovr_world.querySphere)]]
	--[[* [`World:overlapShape`](lua://lovr_world.overlapShape)]]
	--[[* [`World:shapecast`](lua://lovr_world.shapecast)]]
	--[[* [`World:raycast`](lua://lovr_world.raycast)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param width number]]
	--[[@param height number]]
	--[[@param depth number]]
	--[[@param filter? string default=`nil`]]
	--[[@param callback function]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, size: lovr_vec3, filter?: string, callback: function)]]
	--[[@overload fun(self: lovr_world, x: number, y: number, z: number, width: number, height: number, depth: number, filter?: string): lovr_collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, size: lovr_vec3, filter?: string): lovr_collider]]
	function World_class:queryBox(x, y, z, width, height, depth, filter, callback) end

	--[[https://lovr.org/docs/World:querySphere  ]]
	--[[Find colliders that intersect a sphere.  ]]
	--[[### See also]]
	--[[* [`World:queryBox`](lua://lovr_world.queryBox)]]
	--[[* [`World:overlapShape`](lua://lovr_world.overlapShape)]]
	--[[* [`World:shapecast`](lua://lovr_world.shapecast)]]
	--[[* [`World:raycast`](lua://lovr_world.raycast)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x number]]
	--[[@param y number]]
	--[[@param z number]]
	--[[@param radius number]]
	--[[@param filter? string default=`nil`]]
	--[[@param callback function]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, radius: number, filter?: string, callback: function)]]
	--[[@overload fun(self: lovr_world, x: number, y: number, z: number, radius: number, filter?: string): lovr_collider]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, radius: number, filter?: string): lovr_collider]]
	function World_class:querySphere(x, y, z, radius, filter, callback) end

	--[[https://lovr.org/docs/World:raycast  ]]
	--[[Find colliders that intersect a line.  ]]
	--[[### See also]]
	--[[* [`World:shapecast`](lua://lovr_world.shapecast)]]
	--[[* [`World:overlapShape`](lua://lovr_world.overlapShape)]]
	--[[* [`World:queryBox`](lua://lovr_world.queryBox)]]
	--[[* [`World:querySphere`](lua://lovr_world.querySphere)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x1 number]]
	--[[@param y1 number]]
	--[[@param z1 number]]
	--[[@param x2 number]]
	--[[@param y2 number]]
	--[[@param z2 number]]
	--[[@param filter? string default=`nil`]]
	--[[@param callback function]]
	--[[@overload fun(self: lovr_world, origin: lovr_vec3, endpoint: lovr_vec3, filter?: string, callback: function)]]
	--[[@overload fun(self: lovr_world, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number, filter?: string): lovr_collider, lovr_shape, number, number, number, number, number, number]]
	--[[@overload fun(self: lovr_world, origin: lovr_vec3, endpoint: lovr_vec3, filter?: string): lovr_collider, lovr_shape, number, number, number, number, number, number]]
	function World_class:raycast(x1, y1, z1, x2, y2, z2, filter, callback) end

	--[[https://lovr.org/docs/World:setAngularDamping  ]]
	--[[Set the angular damping of the World.  ]]
	--[[### See also]]
	--[[* [`Collider:getAngularDamping`](lua://lovr_collider.getAngularDamping)]]
	--[[* [`Collider:setAngularDamping`](lua://lovr_collider.setAngularDamping)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param damping number]]
	--[[@param threshold? number default=`0`]]
	--[[@deprecated]]
	function World_class:setAngularDamping(damping, threshold) end

	--[[https://lovr.org/docs/World:setCallbacks  ]]
	--[[Set the World's collision callbacks.  ]]
	--[[### See also]]
	--[[* [`World:update`](lua://lovr_world.update)]]
	--[[* [`Contact`](lua://lovr_contact)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param callbacks lovr_physics_world_set_callbacks_callbacks]]
	function World_class:setCallbacks(callbacks) end

	--[[https://lovr.org/docs/World:setGravity  ]]
	--[[Set the gravity of the World.  ]]
	--[[### See also]]
	--[[* [`Collider:getGravityScale`](lua://lovr_collider.getGravityScale)]]
	--[[* [`Collider:setGravityScale`](lua://lovr_collider.setGravityScale)]]
	--[[* [`Collider:getLinearDamping`](lua://lovr_collider.getLinearDamping)]]
	--[[* [`Collider:setLinearDamping`](lua://lovr_collider.setLinearDamping)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param xg number]]
	--[[@param yg number]]
	--[[@param zg number]]
	--[[@overload fun(self: lovr_world, gravity: lovr_vec3)]]
	function World_class:setGravity(xg, yg, zg) end

	--[[https://lovr.org/docs/World:setLinearDamping  ]]
	--[[Set the linear damping of the World.  ]]
	--[[### See also]]
	--[[* [`Collider:getLinearDamping`](lua://lovr_collider.getLinearDamping)]]
	--[[* [`Collider:setLinearDamping`](lua://lovr_collider.setLinearDamping)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param damping number]]
	--[[@param threshold? number default=`0`]]
	--[[@deprecated]]
	function World_class:setLinearDamping(damping, threshold) end

	--[[https://lovr.org/docs/World:setResponseTime  ]]
	--[[Set the response time of the World.  ]]
	--[[### See also]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param responseTime number]]
	--[[@deprecated]]
	function World_class:setResponseTime(responseTime) end

	--[[https://lovr.org/docs/World:setSleepingAllowed  ]]
	--[[Set whether colliders can go to sleep.  ]]
	--[[### See also]]
	--[[* [`Collider:isSleepingAllowed`](lua://lovr_collider.isSleepingAllowed)]]
	--[[* [`Collider:setSleepingAllowed`](lua://lovr_collider.setSleepingAllowed)]]
	--[[* [`Collider:isAwake`](lua://lovr_collider.isAwake)]]
	--[[* [`Collider:setAwake`](lua://lovr_collider.setAwake)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param allowed boolean]]
	--[[@deprecated]]
	function World_class:setSleepingAllowed(allowed) end

	--[[https://lovr.org/docs/World:setStepCount  ]]
	--[[Set the step count of the World.  ]]
	--[[### See also]]
	--[[* [`World:update`](lua://lovr_world.update)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param steps number]]
	--[[@deprecated]]
	function World_class:setStepCount(steps) end

	--[[https://lovr.org/docs/World:setTightness  ]]
	--[[Set the tightness of joints in the World.  ]]
	--[[### See also]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param tightness number]]
	--[[@deprecated]]
	function World_class:setTightness(tightness) end

	--[[https://lovr.org/docs/World:shapecast  ]]
	--[[Move a shape through the world and return any colliders it touches.  ]]
	--[[### See also]]
	--[[* [`World:raycast`](lua://lovr_world.raycast)]]
	--[[* [`World:overlapShape`](lua://lovr_world.overlapShape)]]
	--[[* [`World:queryBox`](lua://lovr_world.queryBox)]]
	--[[* [`World:querySphere`](lua://lovr_world.querySphere)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param x1 number]]
	--[[@param y1 number]]
	--[[@param z1 number]]
	--[[@param x2 number]]
	--[[@param y2 number]]
	--[[@param z2 number]]
	--[[@param angle number]]
	--[[@param ax number]]
	--[[@param ay number]]
	--[[@param az number]]
	--[[@param filter? string default=`nil`]]
	--[[@param callback function]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, destination: lovr_vec3, orientation: lovr_quat, filter?: string, callback: function)]]
	--[[@overload fun(self: lovr_world, x1: number, y1: number, z1: number, x2: number, y2: number, z2: number, angle: number, ax: number, ay: number, az: number, filter?: string): lovr_collider, lovr_shape, number, number, number, number, number, number]]
	--[[@overload fun(self: lovr_world, position: lovr_vec3, destination: lovr_vec3, orientation: lovr_quat, filter?: string): lovr_collider, lovr_shape, number, number, number, number, number, number]]
	function World_class:shapecast(x1, y1, z1, x2, y2, z2, angle, ax, ay, az, filter, callback) end

	--[[https://lovr.org/docs/World:update  ]]
	--[[Advance the physics simulation.  ]]
	--[[### See also]]
	--[[* [`lovr.physics.newWorld`](lua://lovr.physics.newWorld)]]
	--[[* [`World`](lua://lovr_world)]]
	--[[@param dt number]]
	function World_class:update(dt) end


	--[[https://lovr.org/docs/lovr.system  ]]
	--[[@class lovr_system]]
	lovr.system = {}

	--[[https://lovr.org/docs/lovr.system.getCoreCount  ]]
	--[[Get the number of logical cores.  ]]
	--[[### See also]]
	--[[* [`lovr.thread`](lua://lovr.thread)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return number cores]]
	function lovr.system.getCoreCount() return 0 end

	--[[https://lovr.org/docs/World:getCallbacks  ]]
	--[[see also:  ]]
	--[[[`World:getCallbacks`](lua://World:getCallbacks)  ]]
	--[[@class lovr_physics_world_get_callbacks_callbacks]]
	--[[@field filter function ]]
	--[[@field enter function ]]
	--[[@field exit function ]]
	--[[@field contact function ]]

	--[[https://lovr.org/docs/World:setCallbacks  ]]
	--[[see also:  ]]
	--[[[`World:setCallbacks`](lua://World:setCallbacks)  ]]
	--[[@class lovr_physics_world_set_callbacks_callbacks]]
	--[[@field filter function ]]
	--[[@field enter function ]]
	--[[@field exit function ]]
	--[[@field contact function ]]

	--[[https://lovr.org/docs/lovr.system.getMousePosition  ]]
	--[[Get the position of the mouse.  ]]
	--[[### See also]]
	--[[* [`lovr.system.getMouseX`](lua://lovr.system.getMouseX)]]
	--[[* [`lovr.system.getMouseY`](lua://lovr.system.getMouseY)]]
	--[[* [`lovr.mousemoved`](lua://lovr.mousemoved)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return number x]]
	--[[@return number y]]
	function lovr.system.getMousePosition() return 0, 0 end

	--[[https://lovr.org/docs/lovr.system.getMouseX  ]]
	--[[Get the x position of the mouse.  ]]
	--[[### See also]]
	--[[* [`lovr.system.getMouseY`](lua://lovr.system.getMouseY)]]
	--[[* [`lovr.system.getMousePosition`](lua://lovr.system.getMousePosition)]]
	--[[* [`lovr.mousemoved`](lua://lovr.mousemoved)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return number x]]
	function lovr.system.getMouseX() return 0 end

	--[[https://lovr.org/docs/lovr.system.getMouseY  ]]
	--[[Get the y position of the mouse.  ]]
	--[[### See also]]
	--[[* [`lovr.system.getMouseX`](lua://lovr.system.getMouseX)]]
	--[[* [`lovr.system.getMousePosition`](lua://lovr.system.getMousePosition)]]
	--[[* [`lovr.mousemoved`](lua://lovr.mousemoved)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return number y]]
	function lovr.system.getMouseY() return 0 end

	--[[https://lovr.org/docs/lovr.system.getOS  ]]
	--[[Get the current operating system.  ]]
	--[[### See also]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return string os]]
	function lovr.system.getOS() return "" end

	--[[https://lovr.org/docs/lovr.system.getWindowDensity  ]]
	--[[Get the window pixel density.  ]]
	--[[### See also]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return number density]]
	function lovr.system.getWindowDensity() return 0 end

	--[[https://lovr.org/docs/lovr.system.getWindowDimensions  ]]
	--[[Get the dimensions of the window.  ]]
	--[[### See also]]
	--[[* [`lovr.system.getWindowWidth`](lua://lovr.system.getWindowWidth)]]
	--[[* [`lovr.system.getWindowHeight`](lua://lovr.system.getWindowHeight)]]
	--[[* [`lovr.system.isWindowOpen`](lua://lovr.system.isWindowOpen)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return number width]]
	--[[@return number height]]
	function lovr.system.getWindowDimensions() return 0, 0 end

	--[[https://lovr.org/docs/lovr.system.getWindowHeight  ]]
	--[[Get the height of the window.  ]]
	--[[### See also]]
	--[[* [`lovr.system.getWindowWidth`](lua://lovr.system.getWindowWidth)]]
	--[[* [`lovr.system.getWindowDimensions`](lua://lovr.system.getWindowDimensions)]]
	--[[* [`lovr.system.isWindowOpen`](lua://lovr.system.isWindowOpen)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return number width]]
	function lovr.system.getWindowHeight() return 0 end

	--[[https://lovr.org/docs/lovr.system.getWindowWidth  ]]
	--[[Get the width of the window.  ]]
	--[[### See also]]
	--[[* [`lovr.system.getWindowHeight`](lua://lovr.system.getWindowHeight)]]
	--[[* [`lovr.system.getWindowDimensions`](lua://lovr.system.getWindowDimensions)]]
	--[[* [`lovr.system.isWindowOpen`](lua://lovr.system.isWindowOpen)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return number width]]
	function lovr.system.getWindowWidth() return 0 end

	--[[https://lovr.org/docs/lovr.system.hasKeyRepeat  ]]
	--[[Check if key repeat is enabled.  ]]
	--[[### See also]]
	--[[* [`lovr.keypressed`](lua://lovr.keypressed)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return boolean enabled]]
	function lovr.system.hasKeyRepeat() return false end

	--[[https://lovr.org/docs/lovr.system.isKeyDown  ]]
	--[[Get the state of a key.  ]]
	--[[### See also]]
	--[[* [`lovr.system.wasKeyPressed`](lua://lovr.system.wasKeyPressed)]]
	--[[* [`lovr.system.wasKeyReleased`](lua://lovr.system.wasKeyReleased)]]
	--[[* [`lovr.keypressed`](lua://lovr.keypressed)]]
	--[[* [`lovr.keyreleased`](lua://lovr.keyreleased)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@param ... lovr_key_code]]
	--[[@return boolean down]]
	function lovr.system.isKeyDown(...) return false end

	--[[https://lovr.org/docs/lovr.system.isMouseDown  ]]
	--[[Check if a mouse button is pressed.  ]]
	--[[### See also]]
	--[[* [`lovr.mousepressed`](lua://lovr.mousepressed)]]
	--[[* [`lovr.mousereleased`](lua://lovr.mousereleased)]]
	--[[* [`lovr.system.getMouseX`](lua://lovr.system.getMouseX)]]
	--[[* [`lovr.system.getMouseY`](lua://lovr.system.getMouseY)]]
	--[[* [`lovr.system.getMousePosition`](lua://lovr.system.getMousePosition)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@param button number]]
	--[[@return boolean down]]
	function lovr.system.isMouseDown(button) return false end

	--[[https://lovr.org/docs/lovr.system.isWindowOpen  ]]
	--[[Check if the desktop window is open.  ]]
	--[[### See also]]
	--[[* [`lovr.system.openWindow`](lua://lovr.system.openWindow)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@return boolean open]]
	function lovr.system.isWindowOpen() return false end

	--[[https://lovr.org/docs/lovr.system.openWindow  ]]
	--[[Open the desktop window.  ]]
	--[[### See also]]
	--[[* [`lovr.system.isWindowOpen`](lua://lovr.system.isWindowOpen)]]
	--[[* [`lovr.conf`](lua://lovr.conf)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@param options? lovr_system_open_window_options]]
	function lovr.system.openWindow(options) end

	--[[https://lovr.org/docs/lovr.system.openWindow  ]]
	--[[see also:  ]]
	--[[[`lovr.system.openWindow`](lua://lovr.system.openWindow)  ]]
	--[[@class lovr_system_open_window_options]]
	--[[@field width? number default=`720`]]
	--[[@field height? number default=`800`]]
	--[[@field fullscreen boolean ]]
	--[[@field resizable boolean ]]
	--[[@field title string ]]
	--[[@field icon string ]]

	--[[https://lovr.org/docs/Permission  ]]
	--[[Application permissions.  ]]
	--[[### See also]]
	--[[* [`lovr.system.requestPermission`](lua://lovr.system.requestPermission)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@enum lovr_permission]]
	local lovr_permission = {
		--[[Requests microphone access.  ]]
		audiocapture = "audiocapture",
	}

	--[[https://lovr.org/docs/lovr.system.pollEvents  ]]
	--[[Poll the OS for new window events.  ]]
	--[[### See also]]
	--[[* [`lovr.event.poll`](lua://lovr.event.poll)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	function lovr.system.pollEvents() end

	--[[https://lovr.org/docs/lovr.system.requestPermission  ]]
	--[[Request permission to use a feature.  ]]
	--[[### See also]]
	--[[* [`lovr.permission`](lua://lovr.permission)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@param permission lovr_permission]]
	function lovr.system.requestPermission(permission) end

	--[[https://lovr.org/docs/lovr.system.setKeyRepeat  ]]
	--[[Enable or disable key repeat.  ]]
	--[[### See also]]
	--[[* [`lovr.keypressed`](lua://lovr.keypressed)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@param enable boolean]]
	function lovr.system.setKeyRepeat(enable) end

	--[[https://lovr.org/docs/lovr.system.wasKeyPressed  ]]
	--[[Check if a key was pressed this frame.  ]]
	--[[### See also]]
	--[[* [`lovr.system.isKeyDown`](lua://lovr.system.isKeyDown)]]
	--[[* [`lovr.system.wasKeyReleased`](lua://lovr.system.wasKeyReleased)]]
	--[[* [`lovr.keypressed`](lua://lovr.keypressed)]]
	--[[* [`lovr.keyreleased`](lua://lovr.keyreleased)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@param ... lovr_key_code]]
	--[[@return boolean pressed]]
	function lovr.system.wasKeyPressed(...) return false end

	--[[https://lovr.org/docs/lovr.system.wasKeyReleased  ]]
	--[[Check if a key was released this frame.  ]]
	--[[### See also]]
	--[[* [`lovr.system.isKeyDown`](lua://lovr.system.isKeyDown)]]
	--[[* [`lovr.system.wasKeyPressed`](lua://lovr.system.wasKeyPressed)]]
	--[[* [`lovr.keypressed`](lua://lovr.keypressed)]]
	--[[* [`lovr.keyreleased`](lua://lovr.keyreleased)]]
	--[[* [`lovr.system`](lua://lovr.system)]]
	--[[@param ... lovr_key_code]]
	--[[@return boolean released]]
	function lovr.system.wasKeyReleased(...) return false end


	--[[https://lovr.org/docs/lovr.thread  ]]
	--[[@class lovr_thread]]
	lovr.thread = {}

	--[[https://lovr.org/docs/Channel  ]]
	--[[A message channel for communicating between threads.  ]]
	--[[@class lovr_channel: lovr_object]]

	--[[https://lovr.org/docs/Channel:clear  ]]
	--[[Clear all messages from the Channel.  ]]
	--[[### See also]]
	--[[* [`Channel`](lua://lovr_channel)]]
	function Channel_class:clear() end

	--[[https://lovr.org/docs/Channel:getCount  ]]
	--[[Get the number of messages in the Channel.  ]]
	--[[### See also]]
	--[[* [`Channel`](lua://lovr_channel)]]
	--[[@return number count]]
	function Channel_class:getCount() return 0 end

	--[[https://lovr.org/docs/Channel:hasRead  ]]
	--[[Get whether a message has been read.  ]]
	--[[### See also]]
	--[[* [`Channel:push`](lua://lovr_channel.push)]]
	--[[* [`Channel`](lua://lovr_channel)]]
	--[[@param id number]]
	--[[@return boolean read]]
	function Channel_class:hasRead(id) return false end

	--[[https://lovr.org/docs/Channel:peek  ]]
	--[[Look at a message from the Channel without popping it.  ]]
	--[[### See also]]
	--[[* [`Channel:pop`](lua://lovr_channel.pop)]]
	--[[* [`Channel`](lua://lovr_channel)]]
	--[[@return unknown message]]
	--[[@return boolean present]]
	function Channel_class:peek() return nil, false end

	--[[https://lovr.org/docs/Channel:pop  ]]
	--[[Pop a message from the Channel.  ]]
	--[[### See also]]
	--[[* [`Channel:peek`](lua://lovr_channel.peek)]]
	--[[* [`Channel:push`](lua://lovr_channel.push)]]
	--[[* [`Channel`](lua://lovr_channel)]]
	--[[@param wait? number default=`false`]]
	--[[@return unknown message]]
	function Channel_class:pop(wait) return nil end

	--[[https://lovr.org/docs/Channel:push  ]]
	--[[Push a message onto the Channel.  ]]
	--[[### See also]]
	--[[* [`Channel:pop`](lua://lovr_channel.pop)]]
	--[[* [`Channel:hasRead`](lua://lovr_channel.hasRead)]]
	--[[* [`Channel`](lua://lovr_channel)]]
	--[[@param message unknown]]
	--[[@param wait? number default=`false`]]
	--[[@return number id]]
	--[[@return boolean read]]
	function Channel_class:push(message, wait) return 0, false end

	--[[https://lovr.org/docs/lovr.thread.getChannel  ]]
	--[[Get a Channel for communicating between threads.  ]]
	--[[### See also]]
	--[[* [`Channel`](lua://lovr_channel)]]
	--[[* [`lovr.thread`](lua://lovr.thread)]]
	--[[@param name string]]
	--[[@return lovr_channel channel]]
	function lovr.thread.getChannel(name) return Channel_class end

	--[[https://lovr.org/docs/lovr.thread.newThread  ]]
	--[[Create a new Thread.  ]]
	--[[### See also]]
	--[[* [`Thread:start`](lua://lovr_thread.start)]]
	--[[* [`lovr.threaderror`](lua://lovr.threaderror)]]
	--[[* [`lovr.thread`](lua://lovr.thread)]]
	--[[@param code string]]
	--[[@return lovr_thread thread]]
	--[[@overload fun(filename: string): lovr_thread]]
	--[[@overload fun(blob: lovr_blob): lovr_thread]]
	function lovr.thread.newThread(code) return Thread_class end

	--[[https://lovr.org/docs/Thread  ]]
	--[[A separate thread of execution that can run code in parallel with other threads.  ]]
	--[[@class lovr_thread: lovr_object]]

	--[[https://lovr.org/docs/Thread:getError  ]]
	--[[Get the Thread's error message.  ]]
	--[[### See also]]
	--[[* [`lovr.threaderror`](lua://lovr.threaderror)]]
	--[[* [`Thread`](lua://lovr_thread)]]
	--[[@return string error]]
	function Thread_class:getError() return "" end

	--[[https://lovr.org/docs/Thread:isRunning  ]]
	--[[Check if the Thread is running.  ]]
	--[[### See also]]
	--[[* [`Thread:start`](lua://lovr_thread.start)]]
	--[[* [`Thread`](lua://lovr_thread)]]
	--[[@return boolean running]]
	function Thread_class:isRunning() return false end

	--[[https://lovr.org/docs/Thread:start  ]]
	--[[Start the Thread.  ]]
	--[[### See also]]
	--[[* [`Thread`](lua://lovr_thread)]]
	--[[@param ... unknown]]
	function Thread_class:start(...) end

	--[[https://lovr.org/docs/Thread:wait  ]]
	--[[Wait for the Thread to complete.  ]]
	--[[### See also]]
	--[[* [`Thread:isRunning`](lua://lovr_thread.isRunning)]]
	--[[* [`Thread`](lua://lovr_thread)]]
	function Thread_class:wait() end


	--[[https://lovr.org/docs/lovr.timer  ]]
	--[[@class lovr_timer]]
	lovr.timer = {}

	--[[https://lovr.org/docs/lovr.timer.getAverageDelta  ]]
	--[[Get the average delta over the last second.  ]]
	--[[### See also]]
	--[[* [`lovr.timer.getDelta`](lua://lovr.timer.getDelta)]]
	--[[* [`lovr.update`](lua://lovr.update)]]
	--[[* [`lovr.timer`](lua://lovr.timer)]]
	--[[@return number delta]]
	function lovr.timer.getAverageDelta() return 0 end

	--[[https://lovr.org/docs/lovr.timer.getDelta  ]]
	--[[Get the time elapsed since the last update.  ]]
	--[[### See also]]
	--[[* [`lovr.timer.getTime`](lua://lovr.timer.getTime)]]
	--[[* [`lovr.update`](lua://lovr.update)]]
	--[[* [`lovr.timer`](lua://lovr.timer)]]
	--[[@return number dt]]
	function lovr.timer.getDelta() return 0 end

	--[[https://lovr.org/docs/lovr.timer.getFPS  ]]
	--[[Get the current frames per second.  ]]
	--[[### See also]]
	--[[* [`lovr.timer`](lua://lovr.timer)]]
	--[[@return number fps]]
	function lovr.timer.getFPS() return 0 end

	--[[https://lovr.org/docs/lovr.timer.getTime  ]]
	--[[Get the current time.  ]]
	--[[### See also]]
	--[[* [`lovr.headset.getTime`](lua://lovr.headset.getTime)]]
	--[[* [`lovr.timer`](lua://lovr.timer)]]
	--[[@return number time]]
	function lovr.timer.getTime() return 0 end

	--[[https://lovr.org/docs/lovr.timer.sleep  ]]
	--[[Go to sleep.  ]]
	--[[### See also]]
	--[[* [`lovr.timer`](lua://lovr.timer)]]
	--[[@param duration number]]
	function lovr.timer.sleep(duration) end

	--[[https://lovr.org/docs/lovr.timer.step  ]]
	--[[Steps the internal clock.  ]]
	--[[### See also]]
	--[[* [`lovr.timer`](lua://lovr.timer)]]
	--[[@return number delta]]
	function lovr.timer.step() return 0 end


	--[[https://lovr.org/docs/lovr.headset.getHands  ]]
	--[[### See also]]
	--[[* [`lovr.headset`](lua://lovr.headset)]]
	--[[@enum lovr_hand]]
	local lovr_hand = {
		left = "hand/left",
		right = "hand/right",
	}

	--[[https://lovr.org/docs/http  ]]
	--[[@class lovr_http]]
	local http = {}

	--[[https://lovr.org/docs/http  ]]
	--[[requires libcurl to be installed if on linux  ]]
	--[[@param url string]]
	--[[@param options? lovr_http_options]]
	--[[@return integer? status]]
	--[[@return string data response if status is present, else error]]
	--[[@return table<string,string>? headers]]
	function http.request(url, options) return nil, "" end

	--[[https://lovr.org/docs/http  ]]
	--[[https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods  ]]
	--[[@enum lovr_http_method]]
	local lovr_http_method = {
		get = "GET",
		head = "HEAD",
		post = "POST",
		put = "PUT",
		delete = "DELETE",
		connect = "CONNECT",
		options = "OPTIONS",
		trace = "TRACE",
		patch = "PATCH",
	}

	--[[https://lovr.org/docs/http  ]]
	--[[@class lovr_http_options]]
	--[[@field method? lovr_http_method default "POST" if data is present, else "GET"]]
	--[[@field data? string|table<string,string|number>|lightuserdata]]
	--[[@field datasize? integer size of the payload in bytes, if the payload is a lightuserdata]]
	--[[@field headers? table<string,string|number>]]
end
