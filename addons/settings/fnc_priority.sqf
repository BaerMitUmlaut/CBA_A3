/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_priority

Description:
    Check which source of the setting is set to the highest priority.

Parameters:
    _setting - Name of the setting <STRING>
    _temp    - Use temporary value if available (optional, default: false) <BOOL>

Returns:
    _source - Highest priority source <STRING>

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]], ["_temp", false, [false]]];

if (_temp) then {
    ["server", "mission", "client"] select selectMax [
        (GVAR(serverSettingsTemp) getVariable [_setting, GVAR(serverSettings) getVariable [_setting, []]]) param [1,0],
        (GVAR(missionSettingsTemp) getVariable [_setting, GVAR(missionSettings) getVariable [_setting, []]]) param [1,0],
        (GVAR(clientSettingsTemp) getVariable [_setting, GVAR(clientSettings) getVariable [_setting, []]]) param [1,0]
    ];
} else {
    ["server", "mission", "client"] select selectMax [
        (GVAR(serverSettings) getVariable [_setting, []]) param [1,0],
        (GVAR(missionSettings) getVariable [_setting, []]) param [1,0],
        (GVAR(clientSettings) getVariable [_setting, []]) param [1,0]
    ];
};
