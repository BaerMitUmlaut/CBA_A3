// inline function, don't include script_component.hpp

if (isNil QGVAR(defaultSettings)) then {
    GVAR(allSettings) = [];
    GVAR(defaultSettings) = [] call CBA_fnc_createNamespace;

    // --- main setting sources
    if (isServer) then {
        missionNamespace setVariable [QGVAR(serverSettings), true call CBA_fnc_createNamespace, true];
    };

    GVAR(missionSettings) = NAMESPACE_NULL;
    GVAR(clientSettings) = [] call CBA_fnc_createNamespace;

    // --- temp setting sources for settings menu
    GVAR(serverSettingsTemp) = [] call CBA_fnc_createNamespace;
    GVAR(missionSettingsTemp) = [] call CBA_fnc_createNamespace;
    GVAR(clientSettingsTemp) = [] call CBA_fnc_createNamespace;

    #include "initMissionSettings.sqf"
};
