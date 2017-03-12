/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_get

Description:
    Returns the value of a setting.

Parameters:
    _setting - Name of the setting <STRING>
    _source  - Can be "server", "mission", "client", "priority" or "default" (optional, default: "priority") <STRING>
    _temp    - Use temporary value if available (optional, default: false) <BOOL>

Returns:
    Value of the setting <ANY>

Examples:
    (begin example)
        _result = "CBA_TestSetting" call CBA_settings_fnc_get
    (end)

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]], ["_source", "priority", [""]], ["_temp", false, [false]]];

private _value = switch (toLower _source) do {
    case "client": {
        if (_temp) then {
            (GVAR(clientSettingsTemp) getVariable [_setting, GVAR(clientSettings) getVariable _setting]) select 0
        } else {
            (GVAR(clientSettings) getVariable _setting) select 0
        };
    };
    case "mission": {
        if (_temp) then {
            (GVAR(missionSettingsTemp) getVariable [_setting, GVAR(missionSettings) getVariable _setting]) select 0
        } else {
            (GVAR(missionSettings) getVariable _setting) select 0
        };
    };
    case "server": {
        if (_temp) then {
            (GVAR(serverSettingsTemp) getVariable [_setting, GVAR(serverSettings) getVariable _setting]) select 0
        } else {
            (GVAR(serverSettings) getVariable _setting) select 0
        };
    };
    case "priority": {
        private _source = [_setting, _temp] call FUNC(priority);
        [_setting, _source, _temp] call FUNC(get)
    };
    case "default": {
        (GVAR(defaultSettings) getVariable _setting) select 0
    };
    default {
        _source = "default"; // exit
        nil
    };
};

if (isNil "_value") exitWith {
    // setting does not seem to exist
    if (_source == "default") exitWith {nil};

    [_setting, "default", _temp] call FUNC(get);
};

// copy array to prevent accidental overwriting
if (_value isEqualType []) then {+_value} else {_value}
