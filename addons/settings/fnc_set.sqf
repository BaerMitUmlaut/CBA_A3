/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_set

Description:
    Set the value of a setting.

Parameters:
    _setting  - Name of the setting <STRING>
    _value    - Value of the setting <ANY>
    _priority - New setting priority <NUMBER, BOOLEAN>
    _source   - Can be "server", "mission" or "client" (optional, default: "client") <STRING>

Returns:
    _return - Success <BOOL>

Examples:
    (begin example)
        ["CBA_TestSetting", 1] call CBA_settings_fnc_set
    (end)

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]], "_value", ["_priority", nil, [false, 0]], ["_source", "client", [""]]];

if (!isNil "_value" && {!([_setting, _value] call FUNC(check))}) exitWith {
    WARNING_2("Value %1 is invalid for setting %2.",_value,str _setting);
    false
};

private _currentValue = [_setting, _source] call FUNC(get);
private _currentPriority = [_setting, _source] call FUNC(priority);

if (isNil "_priority") then {
    _priority = _currentPriority;
};

if (!isNil "_currentValue" && {_value isEqualTo _currentValue} && {_priority isEqualTo _currentPriority}) exitWith {
    WARNING_3("Value %1 and priority %2 are the same as previous for setting %3",_value,_priority,str _setting);
    false
};

private _return = true;

switch (toLower _source) do {
    case "server": {
        if (isServer) then {
            GVAR(clientSettings) setVariable [_setting, [_value, _priority]];
            GVAR(serverSettings) setVariable [_setting, [_value, _priority], true];

            private _settingsHash = profileNamespace getVariable [QGVAR(hash), HASH_NULL];
            [_settingsHash, toLower _setting, [_value, _priority]] call CBA_fnc_hashSet;
            profileNamespace setVariable [QGVAR(hash), _settingsHash];

            [QGVAR(refreshSetting), _setting] call CBA_fnc_globalEvent;
        } else {
            if (IS_ADMIN_LOGGED) then {
                [QGVAR(setSettingServer), [_setting, _value, _priority]] call CBA_fnc_serverEvent;
            } else {
                WARNING_2("Source is server, but no admin access. Setting: %2",_source,str _setting);
                _return = false;
            };
        };
    };
    case "mission": {
        if (!is3DEN) exitWith {
            WARNING_2("Source is mission, but not in 3DEN editor. Setting: %2",_source,str _setting);
            _return = false;
        };

        GVAR(missionSettings) setVariable [_setting, [_value, _priority]];

        private _settingsHash = "Scenario" get3DENMissionAttribute QGVAR(hash);
        [_settingsHash, toLower _setting, [_value, _priority]] call CBA_fnc_hashSet;
        set3DENMissionAttributes [["Scenario", QGVAR(hash), _settingsHash]];

        [QGVAR(refreshSetting), _setting] call CBA_fnc_localEvent;
    };
    case "client": {
        GVAR(clientSettings) setVariable [_setting, [_value, _priority]];

        private _settingsHash = profileNamespace getVariable [QGVAR(hash), HASH_NULL];
        [_settingsHash, toLower _setting, [_value, _priority]] call CBA_fnc_hashSet;
        profileNamespace setVariable [QGVAR(hash), _settingsHash];

        [QGVAR(refreshSetting), _setting] call CBA_fnc_localEvent;
    };
    default {
        WARNING_2("Invalid source %1 for setting %2",_source,str _setting);
        _return = false;
    };
};

_return
