/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_set

Description:
    Set the value of a setting.

Parameters:
    _setting - Name of the setting <STRING>
    _value   - Value of the setting <ANY>
    _forced  - Force setting? <BOOLEAN>
    _source  - Can be "client", "mission" or "server" (optional, default: "client") <STRING>

Returns:
    _return - Error code <NUMBER>
        0: success
        1: invalid value for setting
        2: new setting and forced state are the same as the previous ones
        10: invalid source
        12: server source, but no access
        13: mission source, but not in 3DEN editor

Examples:
    (begin example)
        ["CBA_TestSetting", 1] call CBA_settings_fnc_set
    (end)

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]], "_value", ["_forced", nil, [false, 0]], ["_source", "client", [""]]];

if (!isNil "_value" && {!([_setting, _value] call FUNC(check))}) exitWith {
    WARNING_2("Value %1 is invalid for setting %2.",_value,str _setting);
    1
};

private _currentValue = [_setting, _source] call FUNC(get);
private _currentForced = [_setting, _source] call FUNC(getForced);

if (isNil "_forced") then {
    _forced = _currentForced;
};

if (!isNil "_currentValue" && {_value isEqualTo _currentValue} && {_forced isEqualTo _currentForced}) exitWith {2};

private _return = 0;

switch (toLower _source) do {
    case "client": {
        // flag is used for server settings exclusively, keep previous state
        _forced = [_setting, _source] call FUNC(isForced);

        GVAR(clientSettings) setVariable [_setting, [_value, _forced]];

        private _settingsHash = profileNamespace getVariable [QGVAR(hash), HASH_NULL];
        [_settingsHash, toLower _setting, [_value, _forced]] call CBA_fnc_hashSet;
        profileNamespace setVariable [QGVAR(hash), _settingsHash];

        [QGVAR(refreshSetting), _setting] call CBA_fnc_localEvent;
    };
    case "mission": {
        if (!is3DEN) exitWith {
            _return = 13;
        };

        GVAR(missionSettings) setVariable [_setting, [_value, _forced]];

        private _settingsHash = "Scenario" get3DENMissionAttribute QGVAR(hash);
        [_settingsHash, toLower _setting, [_value, _forced]] call CBA_fnc_hashSet;
        set3DENMissionAttributes [["Scenario", QGVAR(hash), _settingsHash]];

        [QGVAR(refreshSetting), _setting] call CBA_fnc_localEvent;
    };
    case "server": {
        if (isServer) then {
            GVAR(clientSettings) setVariable [_setting, [_value, _forced]];

            if (isMultiplayer) then {
                GVAR(serverSettings) setVariable [_setting, [_value, _forced], true];
            } else {
                GVAR(serverSettings) setVariable [_setting, [_value, _forced]];
            };

            private _settingsHash = profileNamespace getVariable [QGVAR(hash), HASH_NULL];
            [_settingsHash, toLower _setting, [_value, _forced]] call CBA_fnc_hashSet;
            profileNamespace setVariable [QGVAR(hash), _settingsHash];

            [QGVAR(refreshSetting), _setting] call CBA_fnc_globalEvent;
        } else {
            if (IS_ADMIN_LOGGED) then {
                [QGVAR(setSettingServer), [_setting, _value, _forced]] call CBA_fnc_serverEvent;
            } else {
                _return = 12;
            };
        };
    };
    default {
        _return = 10;
    };
};

_return
