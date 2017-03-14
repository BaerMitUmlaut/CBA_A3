#define COMPONENT settings
#include "\x\cba\addons\main\script_mod.hpp"

#include "\a3\ui_f\hpp\defineDIKCodes.inc"
#include "\a3\ui_f\hpp\defineCommonGrids.inc"

//#define DEBUG_ENABLED_SETTINGS

#ifdef DEBUG_ENABLED_SETTINGS
    #define DEBUG_MODE_FULL
#endif

#ifdef DEBUG_SETTINGS_SETTINGS
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SETTINGS
#endif

#include "\x\cba\addons\main\script_macros.hpp"

#define IDC_ADDONS_GROUP 4301
#define IDC_BTN_CONFIGURE_ADDONS 4302
#define IDC_BTN_CLIENT 9001
#define IDC_BTN_MISSION 9002
#define IDC_BTN_SERVER 9003
#define IDC_BTN_IMPORT 9010
#define IDC_BTN_EXPORT 9011
#define IDC_BTN_SAVE 9020
#define IDC_BTN_LOAD 9021
#define IDC_TXT_FORCE 327
#define IDC_OFFSET_SETTING 10000
#define IDC_BTN_SETTINGS 7000

#define IDC_PRESETS_GROUP 8000
#define IDC_PRESETS_TITLE 8001
#define IDC_PRESETS_NAME 8002
#define IDC_PRESETS_EDIT 8003
#define IDC_PRESETS_VALUE 8004
#define IDC_PRESETS_OK 8005
#define IDC_PRESETS_CANCEL 8006
#define IDC_PRESETS_DELETE 8007

#define POS_X(N) ((N) * GUI_GRID_W + GUI_GRID_CENTER_X)
#define POS_Y(N) ((N) * GUI_GRID_H + GUI_GRID_CENTER_Y)
#define POS_W(N) ((N) * GUI_GRID_W)
#define POS_H(N) ((N) * GUI_GRID_H)

#define POS_X_LOW(N) ((N) * GUI_GRID_W + GUI_GRID_X)
#define POS_Y_LOW(N) ((N) * GUI_GRID_H + GUI_GRID_Y)

#define COLOR_TEXT_DISABLED [1,1,1,0.3]
#define COLOR_TEXT_OVERWRITTEN COLOR_TEXT_DISABLED
#define COLOR_BUTTON_ENABLED [1,1,1,1]
#define COLOR_BUTTON_DISABLED [0,0,0,1]

#define SLIDER_TYPES ["CBA_Rsc_Slider_R", "CBA_Rsc_Slider_G", "CBA_Rsc_Slider_B"]
#define SLIDER_COLORS [[1,0,0,1], [0,1,0,1], [0,0,1,1], [1,1,1,1]]

#define MENU_OFFSET_INITIAL 0.3
#define MENU_OFFSET_SPACING 1.4
#define MENU_OFFSET_COLOR 1.0
#define MENU_OFFSET_COLOR_NEG -0.7

#define CAN_SET_SERVER_SETTINGS (isServer || {IS_ADMIN_LOGGED}) // in singleplayer, as host (local server) or as logged in (not voted) admin connected to a dedicated server
#define CAN_SET_CLIENT_SETTINGS !isServer // in multiplayer as dedicated client
#define CAN_SET_MISSION_SETTINGS is3den // duh

#ifndef DEBUG_MODE_FULL
    #define CAN_VIEW_SERVER_SETTINGS true // everyone can peak at those in multiplayer
    #define CAN_VIEW_CLIENT_SETTINGS !isServer // in multiplayer as dedicated client
    #define CAN_VIEW_MISSION_SETTINGS (is3den || missionVersion >= 15) // can view those in 3den or 3den missions
#else
    #define CAN_VIEW_SERVER_SETTINGS true
    #define CAN_VIEW_CLIENT_SETTINGS true
    #define CAN_VIEW_MISSION_SETTINGS true
#endif

#define HASH_NULL ([] call CBA_fnc_hashCreate)
#define NAMESPACE_NULL locationNull

#define GET_TEMP_NAMESPACE(source) ([GVAR(serverSettingsTemp), GVAR(missionSettingsTemp), GVAR(clientSettingsTemp)] param [['server', 'mission', 'client'] find toLower source, NAMESPACE_NULL])
#define GET_TEMP_NAMESPACE_VALUE(setting,source)    (GET_TEMP_NAMESPACE(source) getVariable [setting, [nil, nil]] select 0)
#define GET_TEMP_NAMESPACE_PRIORITY(setting,source) (GET_TEMP_NAMESPACE(source) getVariable [setting, [nil, nil]] select 1)

#define SET_TEMP_NAMESPACE_VALUE(setting,value,source)       GET_TEMP_NAMESPACE(source) setVariable [setting, [value, GET_TEMP_NAMESPACE_PRIORITY(setting,source)]]
#define SET_TEMP_NAMESPACE_PRIORITY(setting,priority,source) GET_TEMP_NAMESPACE(source) setVariable [setting, [GET_TEMP_NAMESPACE_VALUE(setting,source), priority]]

#define TEMP_PRIORITY(setting) (['server', 'mission', 'client'] select selectMax [\
    GVAR(serverSettingsTemp)  getVariable [setting, [nil, GVAR(serverSettings)  getVariable [setting, [nil, 0]] select 1]] select 1,\
    GVAR(missionSettingsTemp) getVariable [setting, [nil, GVAR(missionSettings) getVariable [setting, [nil, 0]] select 1]] select 1,\
    GVAR(clientSettingsTemp)  getVariable [setting, [nil, GVAR(clientSettings)  getVariable [setting, [nil, 0]] select 1]] select 1\
])

#define TEMP_VALUE(setting) ([\
    GVAR(serverSettingsTemp)  getVariable [setting, [[setting,  'server'] call FUNC(get), nil]] select 0,\
    GVAR(missionSettingsTemp) getVariable [setting, [[setting, 'mission'] call FUNC(get), nil]] select 0,\
    GVAR(clientSettingsTemp)  getVariable [setting, [[setting,  'client'] call FUNC(get), nil]] select 0\
] select (['server', 'mission', 'client'] find TEMP_PRIORITY(setting)))

#define ASCII_NEWLINE 10
#define ASCII_CARRIAGE_RETURN 13
#define ASCII_TAB 9
#define ASCII_SPACE 32
#define WHITE_SPACE [ASCII_NEWLINE, ASCII_CARRIAGE_RETURN, ASCII_TAB, ASCII_SPACE]

#define ICON_ON  "a3\ui_f\data\IGUI\Cfg\Actions\ico_ON_ca.paa"
#define ICON_OFF "a3\ui_f\data\IGUI\Cfg\Actions\ico_OFF_ca.paa"

#define PATH_SETTINGS_FILE "userconfig\cba\cba_settings.sqf"

#define SETTING_ROW_WIDTH         (POS_W(37))
#define SETTING_ROW_HEIGHT        (pixelGrid * pixelH * 20)
#define SETTING_ROW_PADDING_INNER (pixelGrid * pixelH * 2)
#define SETTING_ROW_PADDING_OUTER (pixelGrid * pixelH * 4)

#define SETTING_COLUMN_WIDTH      (1/3 * SETTING_ROW_WIDTH)
#define SETTING_COLUMN_PADDING    (pixelGrid * pixelW * 2)

#define SETTING_SIZE_TEXT         (pixelGrid * pixelH * 18)

#define H_TO_W(height) (round (height / pixelH) * pixelW)
#define W_TO_H(height) (round (height / pixelW) * pixelH)
