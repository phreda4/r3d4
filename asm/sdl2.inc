struct SDL_Point
        x               dd ?
        y               dd ?
ends

struct SDL_Rect
        x               dd ?
        y               dd ?
        w               dd ?
        h               dd ?
ends

struct SDL_Color
        r               db ?
        g               db ?
        b               db ?
        a               db ?
ends

struct SDL_Colour SDL_Color
ends

struct SDL_Palette
        ncolors         dd ?
                        dd ?
        colors          dq ?
        version         dd ?
        refcount        dd ?
ends

struct SDL_DisplayMode
       ?format          dd ?
        w               dd ?
        h               dd ?
        refresh_rate    dd ?
        driverdata      dq ?
ends

struct SDL_PixelFormat
       ?format          dd ?
                        dd ?
        palette         dq ?
        BitsPerPixel    db ?
        BytesPerPixel   db ?
                        rb 2
        Rmask           dd ?
        Gmask           dd ?
        Bmask           dd ?
        Amask           dd ?
        Rloss           db ?
        Gloss           db ?
        Bloss           db ?
        Aloss           db ?
        Rshift          db ?
        Gshift          db ?
        Bshift          db ?
        Ashift          db ?
        refcount        dd ?
        next            dq ?
ends

struct SDL_Surface
        flags           dd ?
                        dd ?
       ?format          dq ?
        w               dd ?
        h               dd ?
        pitch           dd ?
                        dd ?
        pixels          dq ?
        userdata        dq ?
        locked          dd ?
                        dd ?
        lock_data       dq ?
        clip_rect       SDL_Rect
        map             dq ?
        refcount        dd ?
                        dd ?
ends

struct SDL_Keysym
        scancode        dd ?
        sym             dd ?
        mod             dw ?
                        dw ?
        unused          dd ?
ends

struct SDL_CommonEvent
        type            dd ?
        timestamp       dd ?
ends

struct SDL_WindowEvent
        type            dd ?
        timestamp       dd ?
        windowID        dd ?
        event           db ?
                        db ?
                        db ?
                        db ?
        data1           dd ?
        data2           dd ?
ends

struct SDL_KeyboardEvent
        type            dd ?
        timestamp       dd ?
        windowID        dd ?
        state           db ?
       ?repeat          db ?
                        db ?
                        db ?
        keysym          SDL_Keysym
ends

SDL_TEXTEDITINGEVENT_TEXT_SIZE = 32

struct SDL_TextEditingEvent
        type            dd ?
        timestamp       dd ?
        windowID        dd ?
        text            rb SDL_TEXTEDITINGEVENT_TEXT_SIZE
        start           dd ?
        length          dd ?
ends

SDL_TEXTINPUTEVENT_TEXT_SIZE = 32
struct SDL_TextInputEvent
        type            dd ?
        timestamp       dd ?
        windowID        dd ?
        text            rb SDL_TEXTINPUTEVENT_TEXT_SIZE
ends

struct SDL_MouseMotionEvent
        type            dd ?
        timestamp       dd ?
        windowID        dd ?
        which           dd ?
        state           dd ?
        x               dd ?
        y               dd ?
        xrel            dd ?
        yrel            dd ?
ends

struct SDL_MouseButtonEvent
        type            dd ?
        timestamp       dd ?
        windowID        dd ?
        which           dd ?
        button          db ?
        state           db ?
        clicks          db ?
        padding1        db ?
        x               dd ?
        y               dd ?
ends

struct SDL_MouseWheelEvent
       type             dd ?
       timestamp        dd ?
       windowID         dd ?
       which            dd ?
       x                dd ?
       y                dd ?
ends

struct SDL_JoyAxisEvent
        type            dd ?
        timestamp       dd ?
        which           dd ?
        axis            db ?
        padding1        db ?
        padding2        db ?
        padding3        db ?
        value           dw ?
        padding4        dw ?
ends

struct SDL_JoyBallEvent
        type            dd ?
        timestamp       dd ?
        which           dd ?
        ball            db ?
        padding1        db ?
        padding2        db ?
        padding3        db ?
        xrel            dw ?
        yrel            dw ?
ends

struct SDL_JoyHatEvent
        type            dd ?
        timestamp       dd ?
        which           dd ?
        hat             db ?
        value           db ?
        padding1        db ?
        padding2        db ?
ends

struct SDL_JoyButtonEvent
        type            dd ?
        timestamp       dd ?
        which           dd ?
        button          db ?
        state           db ?
        padding1        db ?
        padding2        db ?
ends

struct SDL_JoyDeviceEvent
        type            dd ?
        timestamp       dd ?
        which           dd ?
ends

struct SDL_ControllerAxisEvent
        type            dd ?
        timestamp       dd ?
        which           dd ?
        axis            db ?
        padding1        db ?
        padding2        db ?
        padding3        db ?
        value           dw ?
        padding4        dw ?
ends

struct SDL_ControllerButtonEvent
        type            dd ?
        timestamp       dd ?
        which           dd ?
        button          db ?
        state           db ?
        padding1        db ?
        padding2        db ?
ends

struct SDL_ControllerDeviceEvent
        type            dd ?
        timestamp       dd ?
        which           dd ?
ends

struct SDL_TouchFingerEvent
        type            dd ?
        timestamp       dd ?
        touchId         dd ?
        fingerId        dd ?
        x               dd ?
        y               dd ?
        dx              dd ?
        dy              dd ?
        pressure        dd ?
ends

struct SDL_MultiGestureEvent
        type            dd ?
        timestamp       dd ?
        touchId         dd ?
        dTheta          dd ?
        dDist           dd ?
        x               dd ?
        y               dd ?
        numFingers      dw ?
        padding         dw ?
ends

struct SDL_DollarGestureEvent
        type            dd ?
        timestamp       dd ?
        touchId         dd ?
        gestureId       dd ?
        numFingers      dd ?
        error           dd ?
        x               dd ?
        y               dd ?
ends

struct SDL_DropEvent
        type            dd ?
        timestamp       dd ?
        file.           dd ?
ends

struct SDL_QuitEvent
        type            dd ?
        timestamp       dd ?
ends

struct SDL_OSEvent
        type            dd ?
        timestamp       dd ?
ends

struct SDL_UserEvent
        type            dd ?
        timestamp       dd ?
        windowID        dd ?
        code            dd ?
        data1           dd ?
        data2           dd ?
ends

struct SDL_SysWMEvent
        type            dd ?
        timestamp       dd ?
        msg             dd ?
ends

struct SDL_Event
    union
        type            dd ?
        common          SDL_CommonEvent
        window          SDL_WindowEvent
        key             SDL_KeyboardEvent
        edit            SDL_TextEditingEvent
        text            SDL_TextInputEvent
        motion          SDL_MouseMotionEvent
        button          SDL_MouseButtonEvent
        wheel           SDL_MouseWheelEvent
        jaxis           SDL_JoyAxisEvent
        jball           SDL_JoyBallEvent
        jhat            SDL_JoyHatEvent
        jbutton         SDL_JoyButtonEvent
        jdevice         SDL_JoyDeviceEvent
        caxis           SDL_ControllerAxisEvent
        cbutton         SDL_ControllerButtonEvent
        cdevice         SDL_ControllerDeviceEvent
        quit            SDL_QuitEvent
        user            SDL_UserEvent
        syswm           SDL_SysWMEvent
        tfinger         SDL_TouchFingerEvent
        mgesture        SDL_MultiGestureEvent
        dgesture        SDL_DollarGestureEvent
        drop            SDL_DropEvent
        padding         rb 56
    ends
ends

struct SDL_RWops
        size    dq ?
        seek    dq ?
        read    dq ?
        write   dq ?
        close   dq ?
        type    dq ?
        hidden  dq ?
ends

; These are the flags which may be passed to SDL_Init().  You should
; specify the subsystems which you will be using in your application.

SDL_INIT_TIMER          = 0x00000001
SDL_INIT_AUDIO          = 0x00000010
SDL_INIT_VIDEO          = 0x00000020  ; SDL_INIT_VIDEO implies SDL_INIT_EVENTS
SDL_INIT_JOYSTICK       = 0x00000200  ; SDL_INIT_JOYSTICK implies SDL_INIT_EVENTS
SDL_INIT_HAPTIC         = 0x00001000
SDL_INIT_GAMECONTROLLER = 0x00002000  ; SDL_INIT_GAMECONTROLLER implies SDL_INIT_JOYSTICK
SDL_INIT_EVENTS         = 0x00004000
SDL_INIT_NOPARACHUTE    = 0x00100000  ; Don't catch fatal signals
SDL_INIT_EVERYTHING     = \
                          SDL_INIT_TIMER or SDL_INIT_AUDIO or SDL_INIT_VIDEO or SDL_INIT_EVENTS or \
                          SDL_INIT_JOYSTICK or SDL_INIT_HAPTIC or SDL_INIT_GAMECONTROLLER

; The flags on a window

SDL_WINDOW_FULLSCREEN         = 0x00000001      ; fullscreen window
SDL_WINDOW_OPENGL             = 0x00000002      ; window usable with OpenGL context
SDL_WINDOW_SHOWN              = 0x00000004      ; window is visible
SDL_WINDOW_HIDDEN             = 0x00000008      ; window is not visible
SDL_WINDOW_BORDERLESS         = 0x00000010      ; no window decoration
SDL_WINDOW_RESIZABLE          = 0x00000020      ; window can be resized
SDL_WINDOW_MINIMIZED          = 0x00000040      ; window is minimized
SDL_WINDOW_MAXIMIZED          = 0x00000080      ; window is maximized
SDL_WINDOW_INPUT_GRABBED      = 0x00000100      ; window has grabbed input focus
SDL_WINDOW_INPUT_FOCUS        = 0x00000200      ; window has input focus
SDL_WINDOW_MOUSE_FOCUS        = 0x00000400      ; window has mouse focus
SDL_WINDOW_FULLSCREEN_DESKTOP = SDL_WINDOW_FULLSCREEN or 0x00001000
SDL_WINDOW_FOREIGN            = 0x00000800      ; window not created by SDL
SDL_WINDOW_ALLOW_HIGHDPI      = 0x00002000      ; window should be created

; Used to indicate that you don't care what the window position is.

SDL_WINDOWPOS_UNDEFINED_MASK  = 0x1FFF0000
SDL_WINDOWPOS_UNDEFINED       = SDL_WINDOWPOS_UNDEFINED_MASK or 0

; Used to indicate that the window position should be centered.

SDL_WINDOWPOS_CENTERED_MASK   = 0x2FFF0000
SDL_WINDOWPOS_CENTERED        = SDL_WINDOWPOS_CENTERED_MASK or 0

; Flags used when creating a rendering context

SDL_RENDERER_SOFTWARE      = 0x00000001 ; The renderer is a software fallback
SDL_RENDERER_ACCELERATED   = 0x00000002 ; The renderer uses hardware acceleration
SDL_RENDERER_PRESENTVSYNC  = 0x00000004 ; Present is synchronized with the refresh rate
SDL_RENDERER_TARGETTEXTURE = 0x00000008 ; The renderer supports rendering to texture


; The access pattern allowed for a texture.

SDL_TEXTUREACCESS_STATIC    = 0     ; Changes rarely, not lockable
SDL_TEXTUREACCESS_STREAMING = 1     ; Changes frequently, lockable
SDL_TEXTUREACCESS_TARGET    = 2     ; Texture can be used as a render target

; The texture channel modulation used in SDL_RenderCopy().

SDL_TEXTUREMODULATE_NONE  = 0x00000000  ; No modulation
SDL_TEXTUREMODULATE_COLOR = 0x00000001  ; srcC = srcC * color
SDL_TEXTUREMODULATE_ALPHA = 0x00000002  ; srcA = srcA * alpha

; Flip constants for SDL_RenderCopyEx

SDL_FLIP_NONE       = 0x00000000        ; Do not flip
SDL_FLIP_HORIZONTAL = 0x00000001        ; flip horizontally
SDL_FLIP_VERTICAL   = 0x00000002        ; flip vertically

; The blend mode used in SDL_RenderCopy() and drawing operations.

SDL_BLENDMODE_NONE = 0x00000000         ; no blending
                                        ; dstRGBA = srcRGBA
SDL_BLENDMODE_BLEND = 0x00000001        ; alpha blending
                                        ; dstRGB = (srcRGB * srcA) + (dstRGB * (1-srcA))
                                        ; dstA = srcA + (dstA * (1-srcA))
SDL_BLENDMODE_ADD = 0x00000002          ; additive blending
                                        ; dstRGB = (srcRGB * srcA) + dstRGB
                                        ; dstA = dstA
SDL_BLENDMODE_MOD = 0x00000004          ; color modulate
                                        ; dstRGB = srcRGB * dstRGB
                                        ; dstA = dstA */

; Surface flags

SDL_SWSURFACE = 0           ; Just here for compatibility
SDL_PREALLOC  = 0x00000001  ; Surface uses preallocated memory
SDL_RLEACCEL  = 0x00000002  ; Surface is RLE encoded
SDL_DONTFREE  = 0x00000004  ; Surface is referenced internally

; Transparency definitions

SDL_ALPHA_OPAQUE      = 255
SDL_ALPHA_TRANSPARENT = 0

; Pixel type

SDL_PIXELTYPE_UNKNOWN  = 0
SDL_PIXELTYPE_INDEX1   = 1
SDL_PIXELTYPE_INDEX4   = 2
SDL_PIXELTYPE_INDEX8   = 3
SDL_PIXELTYPE_PACKED8  = 4
SDL_PIXELTYPE_PACKED16 = 5
SDL_PIXELTYPE_PACKED32 = 6
SDL_PIXELTYPE_ARRAYU8  = 7
SDL_PIXELTYPE_ARRAYU16 = 8
SDL_PIXELTYPE_ARRAYU32 = 9
SDL_PIXELTYPE_ARRAYF16 = 10
SDL_PIXELTYPE_ARRAYF32 = 11

; Bitmap pixel order, high bit -> low bit

SDL_BITMAPORDER_NONE = 0
SDL_BITMAPORDER_4321 = 1
SDL_BITMAPORDER_1234 = 2

; Packed component order high bit -> low bit

SDL_PACKEDORDER_NONE = 0
SDL_PACKEDORDER_XRGB = 1
SDL_PACKEDORDER_RGBX = 2
SDL_PACKEDORDER_ARGB = 3
SDL_PACKEDORDER_RGBA = 4
SDL_PACKEDORDER_XBGR = 5
SDL_PACKEDORDER_BGRX = 6
SDL_PACKEDORDER_ABGR = 7
SDL_PACKEDORDER_BGRA = 8

; Array component order low byte -> high byte

SDL_ARRAYORDER_NONE = 0
SDL_ARRAYORDER_RGB  = 1
SDL_ARRAYORDER_RGBA = 2
SDL_ARRAYORDER_ARGB = 3
SDL_ARRAYORDER_BGR  = 4
SDL_ARRAYORDER_BGRA = 5
SDL_ARRAYORDER_ABGR = 6

; Packed component layout

SDL_PACKEDLAYOUT_NONE    = 0
SDL_PACKEDLAYOUT_332     = 1
SDL_PACKEDLAYOUT_4444    = 2
SDL_PACKEDLAYOUT_1555    = 3
SDL_PACKEDLAYOUT_5551    = 4
SDL_PACKEDLAYOUT_565     = 5
SDL_PACKEDLAYOUT_8888    = 6
SDL_PACKEDLAYOUT_2101010 = 7
SDL_PACKEDLAYOUT_1010102 = 8

SDL_PIXELFORMAT_UNKNOWN   = 0

SDL_PIXELFORMAT_YV12 = 'YV12'
SDL_PIXELFORMAT_IYUV = 'IYUV'
SDL_PIXELFORMAT_YUY2 = 'YUY2'
SDL_PIXELFORMAT_UYVY = 'UYVY'
SDL_PIXELFORMAT_YVYU = 'YVYU'

; Audio format flags

AUDIO_U8     = 0x0008           ; Unsigned 8-bit samples */
AUDIO_S8     = 0x8008           ; Signed 8-bit samples */
AUDIO_U16LSB = 0x0010           ; Unsigned 16-bit samples */
AUDIO_S16LSB = 0x8010           ; Signed 16-bit samples */
AUDIO_U16MSB = 0x1010           ; As above, but big-endian byte order */
AUDIO_S16MSB = 0x9010           ; As above, but big-endian byte order */
AUDIO_U16    = AUDIO_U16LSB
AUDIO_S16    = AUDIO_S16LSB
AUDIO_S32LSB = 0x8020           ; 32-bit integer samples */
AUDIO_S32MSB = 0x9020           ; As above, but big-endian byte order */
AUDIO_S32    = AUDIO_S32LSB
AUDIO_F32LSB = 0x8120           ; 32-bit floating point samples */
AUDIO_F32MSB = 0x9120           ; As above, but big-endian byte order */
AUDIO_F32    = AUDIO_F32LSB
AUDIO_U16SYS = AUDIO_U16LSB
AUDIO_S16SYS = AUDIO_S16LSB
AUDIO_S32SYS = AUDIO_S32LSB
AUDIO_F32SYS = AUDIO_F32LSB

; The types of events that can be delivered

SDL_FIRSTEVENT               = 0
SDL_QUIT                     = 0x100     ; User-requested quit
SDL_APP_TERMINATING          = 0x101     ; The application is being terminated by the OS
                                         ; Called on iOS in applicationWillTerminate()
                                         ; Called on Android in onDestroy()
SDL_APP_LOWMEMORY            = 0x102     ; The application is low on memory free memory if possible.
                                         ; Called on iOS in applicationDidReceiveMemoryWarning()
                                         ; Called on Android in onLowMemory()
SDL_APP_WILLENTERBACKGROUND  = 0x103     ; The application is about to enter the background
                                         ; Called on iOS in applicationWillResignActive()
                                         ; Called on Android in onPause()
SDL_APP_DIDENTERBACKGROUND   = 0x104     ; The application did enter the background and may not get CPU for some time
                                         ; Called on iOS in applicationDidEnterBackground()
                                         ; Called on Android in onPause()
SDL_APP_WILLENTERFOREGROUND  = 0x105     ; The application is about to enter the foreground
                                         ; Called on iOS in applicationWillEnterForeground()
                                         ; Called on Android in onResume()
SDL_APP_DIDENTERFOREGROUND   = 0x106     ; The application is now interactive
                                         ; Called on iOS in applicationDidBecomeActive()
                                         ; Called on Android in onResume()
SDL_WINDOWEVENT              = 0x200     ; Window state change
SDL_SYSWMEVENT               = 0x201     ; System specific event
SDL_KEYDOWN                  = 0x300     ; Key pressed
SDL_KEYUP                    = 0x301     ; Key released
SDL_TEXTEDITING              = 0x302     ; Keyboard text editing (composition)
SDL_TEXTINPUT                = 0x303     ; Keyboard text input
SDL_MOUSEMOTION              = 0x400     ; Mouse moved
SDL_MOUSEBUTTONDOWN          = 0x401     ; Mouse button pressed
SDL_MOUSEBUTTONUP            = 0x402     ; Mouse button released
SDL_MOUSEWHEEL               = 0x403     ; Mouse wheel motion
SDL_JOYAXISMOTION            = 0x600     ; Joystick axis motion
SDL_JOYBALLMOTION            = 0x601     ; Joystick trackball motion
SDL_JOYHATMOTION             = 0x602     ; Joystick hat position change
SDL_JOYBUTTONDOWN            = 0x603     ; Joystick button pressed
SDL_JOYBUTTONUP              = 0x604     ; Joystick button released
SDL_JOYDEVICEADDED           = 0x605     ; A new joystick has been inserted into the system
SDL_JOYDEVICEREMOVED         = 0x606     ; An opened joystick has been removed
SDL_CONTROLLERAXISMOTION     = 0x650     ; Game controller axis motion
SDL_CONTROLLERBUTTONDOWN     = 0x651     ; Game controller button pressed
SDL_CONTROLLERBUTTONUP       = 0x652     ; Game controller button released
SDL_CONTROLLERDEVICEADDED    = 0x653     ; A new Game controller has been inserted into the system
SDL_CONTROLLERDEVICEREMOVED  = 0x654     ; An opened Game controller has been removed
SDL_CONTROLLERDEVICEREMAPPED = 0x655     ; The controller mapping was updated
SDL_FINGERDOWN               = 0x700
SDL_FINGERUP                 = 0x701
SDL_FINGERMOTION             = 0x702
SDL_DOLLARGESTURE            = 0x800
SDL_DOLLARRECORD             = 0x801
SDL_MULTIGESTURE             = 0x802
SDL_CLIPBOARDUPDATE          = 0x900     ; The clipboard changed
SDL_DROPFILE                 = 0x1000    ; The system requests a file open
SDL_RENDER_TARGETS_RESET     = 0x2000    ; The render targets have been reset
SDL_USEREVENT                = 0x8000
SDL_LASTEVENT                = 0xFFFF

; Keyboard scancodes

SDL_SCANCODE_UNKNOWN = 0
SDL_SCANCODE_A = 4
SDL_SCANCODE_B = 5
SDL_SCANCODE_C = 6
SDL_SCANCODE_D = 7
SDL_SCANCODE_E = 8
SDL_SCANCODE_F = 9
SDL_SCANCODE_G = 10
SDL_SCANCODE_H = 11
SDL_SCANCODE_I = 12
SDL_SCANCODE_J = 13
SDL_SCANCODE_K = 14
SDL_SCANCODE_L = 15
SDL_SCANCODE_M = 16
SDL_SCANCODE_N = 17
SDL_SCANCODE_O = 18
SDL_SCANCODE_P = 19
SDL_SCANCODE_Q = 20
SDL_SCANCODE_R = 21
SDL_SCANCODE_S = 22
SDL_SCANCODE_T = 23
SDL_SCANCODE_U = 24
SDL_SCANCODE_V = 25
SDL_SCANCODE_W = 26
SDL_SCANCODE_X = 27
SDL_SCANCODE_Y = 28
SDL_SCANCODE_Z = 29
SDL_SCANCODE_1 = 30
SDL_SCANCODE_2 = 31
SDL_SCANCODE_3 = 32
SDL_SCANCODE_4 = 33
SDL_SCANCODE_5 = 34
SDL_SCANCODE_6 = 35
SDL_SCANCODE_7 = 36
SDL_SCANCODE_8 = 37
SDL_SCANCODE_9 = 38
SDL_SCANCODE_0 = 39
SDL_SCANCODE_RETURN = 40
SDL_SCANCODE_ESCAPE = 41
SDL_SCANCODE_BACKSPACE = 42
SDL_SCANCODE_TAB = 43
SDL_SCANCODE_SPACE = 44
SDL_SCANCODE_MINUS = 45
SDL_SCANCODE_EQUALS = 46
SDL_SCANCODE_LEFTBRACKET = 47
SDL_SCANCODE_RIGHTBRACKET = 48
SDL_SCANCODE_BACKSLASH = 49
SDL_SCANCODE_NONUSHASH = 50
SDL_SCANCODE_SEMICOLON = 51
SDL_SCANCODE_APOSTROPHE = 52
SDL_SCANCODE_GRAVE = 53
SDL_SCANCODE_COMMA = 54
SDL_SCANCODE_PERIOD = 55
SDL_SCANCODE_SLASH = 56
SDL_SCANCODE_CAPSLOCK = 57
SDL_SCANCODE_F1 = 58
SDL_SCANCODE_F2 = 59
SDL_SCANCODE_F3 = 60
SDL_SCANCODE_F4 = 61
SDL_SCANCODE_F5 = 62
SDL_SCANCODE_F6 = 63
SDL_SCANCODE_F7 = 64
SDL_SCANCODE_F8 = 65
SDL_SCANCODE_F9 = 66
SDL_SCANCODE_F10 = 67
SDL_SCANCODE_F11 = 68
SDL_SCANCODE_F12 = 69
SDL_SCANCODE_PRINTSCREEN = 70
SDL_SCANCODE_SCROLLLOCK = 71
SDL_SCANCODE_PAUSE = 72
SDL_SCANCODE_INSERT = 73
SDL_SCANCODE_HOME = 74
SDL_SCANCODE_PAGEUP = 75
SDL_SCANCODE_DELETE = 76
SDL_SCANCODE_END = 77
SDL_SCANCODE_PAGEDOWN = 78
SDL_SCANCODE_RIGHT = 79
SDL_SCANCODE_LEFT = 80
SDL_SCANCODE_DOWN = 81
SDL_SCANCODE_UP = 82
SDL_SCANCODE_NUMLOCKCLEAR = 83
SDL_SCANCODE_KP_DIVIDE = 84
SDL_SCANCODE_KP_MULTIPLY = 85
SDL_SCANCODE_KP_MINUS = 86
SDL_SCANCODE_KP_PLUS = 87
SDL_SCANCODE_KP_ENTER = 88
SDL_SCANCODE_KP_1 = 89
SDL_SCANCODE_KP_2 = 90
SDL_SCANCODE_KP_3 = 91
SDL_SCANCODE_KP_4 = 92
SDL_SCANCODE_KP_5 = 93
SDL_SCANCODE_KP_6 = 94
SDL_SCANCODE_KP_7 = 95
SDL_SCANCODE_KP_8 = 96
SDL_SCANCODE_KP_9 = 97
SDL_SCANCODE_KP_0 = 98
SDL_SCANCODE_KP_PERIOD = 99
SDL_SCANCODE_NONUSBACKSLASH = 100
SDL_SCANCODE_APPLICATION = 101
SDL_SCANCODE_POWER = 102
SDL_SCANCODE_KP_EQUALS = 103
SDL_SCANCODE_F13 = 104
SDL_SCANCODE_F14 = 105
SDL_SCANCODE_F15 = 106
SDL_SCANCODE_F16 = 107
SDL_SCANCODE_F17 = 108
SDL_SCANCODE_F18 = 109
SDL_SCANCODE_F19 = 110
SDL_SCANCODE_F20 = 111
SDL_SCANCODE_F21 = 112
SDL_SCANCODE_F22 = 113
SDL_SCANCODE_F23 = 114
SDL_SCANCODE_F24 = 115
SDL_SCANCODE_EXECUTE = 116
SDL_SCANCODE_HELP = 117
SDL_SCANCODE_MENU = 118
SDL_SCANCODE_SELECT = 119
SDL_SCANCODE_STOP = 120
SDL_SCANCODE_AGAIN = 121
SDL_SCANCODE_UNDO = 122
SDL_SCANCODE_CUT = 123
SDL_SCANCODE_COPY = 124
SDL_SCANCODE_PASTE = 125
SDL_SCANCODE_FIND = 126
SDL_SCANCODE_MUTE = 127
SDL_SCANCODE_VOLUMEUP = 128
SDL_SCANCODE_VOLUMEDOWN = 129
SDL_SCANCODE_KP_COMMA = 133
SDL_SCANCODE_KP_EQUALSAS400 = 134
SDL_SCANCODE_INTERNATIONAL1 = 135
SDL_SCANCODE_INTERNATIONAL2 = 136
SDL_SCANCODE_INTERNATIONAL3 = 137
SDL_SCANCODE_INTERNATIONAL4 = 138
SDL_SCANCODE_INTERNATIONAL5 = 139
SDL_SCANCODE_INTERNATIONAL6 = 140
SDL_SCANCODE_INTERNATIONAL7 = 141
SDL_SCANCODE_INTERNATIONAL8 = 142
SDL_SCANCODE_INTERNATIONAL9 = 143
SDL_SCANCODE_LANG1 = 144
SDL_SCANCODE_LANG2 = 145
SDL_SCANCODE_LANG3 = 146
SDL_SCANCODE_LANG4 = 147
SDL_SCANCODE_LANG5 = 148
SDL_SCANCODE_LANG6 = 149
SDL_SCANCODE_LANG7 = 150
SDL_SCANCODE_LANG8 = 151
SDL_SCANCODE_LANG9 = 152
SDL_SCANCODE_ALTERASE = 153
SDL_SCANCODE_SYSREQ = 154
SDL_SCANCODE_CANCEL = 155
SDL_SCANCODE_CLEAR = 156
SDL_SCANCODE_PRIOR = 157
SDL_SCANCODE_RETURN2 = 158
SDL_SCANCODE_SEPARATOR = 159
SDL_SCANCODE_OUT = 160
SDL_SCANCODE_OPER = 161
SDL_SCANCODE_CLEARAGAIN = 162
SDL_SCANCODE_CRSEL = 163
SDL_SCANCODE_EXSEL = 164
SDL_SCANCODE_KP_00 = 176
SDL_SCANCODE_KP_000 = 177
SDL_SCANCODE_THOUSANDSSEPARATOR = 178
SDL_SCANCODE_DECIMALSEPARATOR = 179
SDL_SCANCODE_CURRENCYUNIT = 180
SDL_SCANCODE_CURRENCYSUBUNIT = 181
SDL_SCANCODE_KP_LEFTPAREN = 182
SDL_SCANCODE_KP_RIGHTPAREN = 183
SDL_SCANCODE_KP_LEFTBRACE = 184
SDL_SCANCODE_KP_RIGHTBRACE = 185
SDL_SCANCODE_KP_TAB = 186
SDL_SCANCODE_KP_BACKSPACE = 187
SDL_SCANCODE_KP_A = 188
SDL_SCANCODE_KP_B = 189
SDL_SCANCODE_KP_C = 190
SDL_SCANCODE_KP_D = 191
SDL_SCANCODE_KP_E = 192
SDL_SCANCODE_KP_F = 193
SDL_SCANCODE_KP_XOR = 194
SDL_SCANCODE_KP_POWER = 195
SDL_SCANCODE_KP_PERCENT = 196
SDL_SCANCODE_KP_LESS = 197
SDL_SCANCODE_KP_GREATER = 198
SDL_SCANCODE_KP_AMPERSAND = 199
SDL_SCANCODE_KP_DBLAMPERSAND = 200
SDL_SCANCODE_KP_VERTICALBAR = 201
SDL_SCANCODE_KP_DBLVERTICALBAR = 202
SDL_SCANCODE_KP_COLON = 203
SDL_SCANCODE_KP_HASH = 204
SDL_SCANCODE_KP_SPACE = 205
SDL_SCANCODE_KP_AT = 206
SDL_SCANCODE_KP_EXCLAM = 207
SDL_SCANCODE_KP_MEMSTORE = 208
SDL_SCANCODE_KP_MEMRECALL = 209
SDL_SCANCODE_KP_MEMCLEAR = 210
SDL_SCANCODE_KP_MEMADD = 211
SDL_SCANCODE_KP_MEMSUBTRACT = 212
SDL_SCANCODE_KP_MEMMULTIPLY = 213
SDL_SCANCODE_KP_MEMDIVIDE = 214
SDL_SCANCODE_KP_PLUSMINUS = 215
SDL_SCANCODE_KP_CLEAR = 216
SDL_SCANCODE_KP_CLEARENTRY = 217
SDL_SCANCODE_KP_BINARY = 218
SDL_SCANCODE_KP_OCTAL = 219
SDL_SCANCODE_KP_DECIMAL = 220
SDL_SCANCODE_KP_HEXADECIMAL = 221
SDL_SCANCODE_LCTRL = 224
SDL_SCANCODE_LSHIFT = 225
SDL_SCANCODE_LALT = 226
SDL_SCANCODE_LGUI = 227
SDL_SCANCODE_RCTRL = 228
SDL_SCANCODE_RSHIFT = 229
SDL_SCANCODE_RALT = 230
SDL_SCANCODE_RGUI = 231
SDL_SCANCODE_MODE = 257
SDL_SCANCODE_AUDIONEXT = 258
SDL_SCANCODE_AUDIOPREV = 259
SDL_SCANCODE_AUDIOSTOP = 260
SDL_SCANCODE_AUDIOPLAY = 261
SDL_SCANCODE_AUDIOMUTE = 262
SDL_SCANCODE_MEDIASELECT = 263
SDL_SCANCODE_WWW = 264
SDL_SCANCODE_MAIL = 265
SDL_SCANCODE_CALCULATOR = 266
SDL_SCANCODE_COMPUTER = 267
SDL_SCANCODE_AC_SEARCH = 268
SDL_SCANCODE_AC_HOME = 269
SDL_SCANCODE_AC_BACK = 270
SDL_SCANCODE_AC_FORWARD = 271
SDL_SCANCODE_AC_STOP = 272
SDL_SCANCODE_AC_REFRESH = 273
SDL_SCANCODE_AC_BOOKMARKS = 274
SDL_SCANCODE_BRIGHTNESSDOWN = 275
SDL_SCANCODE_BRIGHTNESSUP = 276
SDL_SCANCODE_DISPLAYSWITCH = 277
SDL_SCANCODE_KBDILLUMTOGGLE = 278
SDL_SCANCODE_KBDILLUMDOWN = 279
SDL_SCANCODE_KBDILLUMUP = 280
SDL_SCANCODE_EJECT = 281
SDL_SCANCODE_SLEEP = 282
SDL_SCANCODE_APP1 = 283
SDL_SCANCODE_APP2 = 284
SDL_NUM_SCANCODES = 512

; SDL_MessageBox flags

SDL_MESSAGEBOX_ERROR        = 0x00000010
SDL_MESSAGEBOX_WARNING      = 0x00000020
SDL_MESSAGEBOX_INFORMATION  = 0x00000040    