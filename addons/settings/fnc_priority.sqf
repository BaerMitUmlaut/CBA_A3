/* ----------------------------------------------------------------------------
Internal Function: CBA_settings_fnc_priority

Description:
    Check which source of the setting is set to the highest priority.

Parameters:
    _setting - Name of the setting <STRING>

Returns:
    _source - Highest priority source <STRING>

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"

params [["_setting", "", [""]]];

["server", "mission", "client"] select selectMax [
    GVAR(serverSettings)  getVariable [_setting, [nil, 0]] select 1,
    GVAR(missionSettings) getVariable [_setting, [nil, 0]] select 1,
    GVAR(clientSettings)  getVariable [_setting, [nil, 0]] select 1
] // return
