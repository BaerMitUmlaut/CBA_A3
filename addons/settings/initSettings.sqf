// inline function, don't include script_component.hpp

if (isNil QGVAR(defaultSettings)) then {
    GVAR(defaultSettings) = [] call CBA_fnc_createNamespace;
    GVAR(allSettings) = [];

    GVAR(clientSettings) = [] call CBA_fnc_createNamespace;

    if (isMultiplayer) then {
        if (isServer) then {
            GVAR(serverSettings) = true call CBA_fnc_createNamespace;
            publicVariable QGVAR(serverSettings);
        };
    } else {
        GVAR(serverSettings) = false call CBA_fnc_createNamespace;
    };

    GVAR(missionSettings) = [] call CBA_fnc_createNamespace;

    // temp namespaces for settings menu
    GVAR(clientSettingsTemp) = [] call CBA_fnc_createNamespace;
    GVAR(serverSettingsTemp) = [] call CBA_fnc_createNamespace;
    GVAR(missionSettingsTemp) = [] call CBA_fnc_createNamespace;

    #include "initMissionSettings.sqf"
};
