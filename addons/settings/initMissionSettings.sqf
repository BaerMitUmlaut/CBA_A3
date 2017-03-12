// inline function, don't include script_component.hpp

// delay a frame, necause 3den attributes are unavailable at frame 0
// cannot use CBA_fnc_execNextFrame, because we need this to run before postInit
addMissionEventHandler ["EachFrame", {
    // --- read previous setting values from mission
    private _settingsHash = getMissionConfigValue [QGVAR(hash), HASH_NULL];
    GVAR(missionSettings) call CBA_fnc_deleteNamespace;
    GVAR(missionSettings) = [_settingsHash] call CBA_fnc_deserializeNamespace;

    // --- refresh all settings now
    QGVAR(refreshAllSettings) call CBA_fnc_localEvent;

    removeMissionEventHandler ["EachFrame", _thisEventHandler];
}];
