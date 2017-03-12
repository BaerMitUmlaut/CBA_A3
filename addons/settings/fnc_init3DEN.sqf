#include "script_component.hpp"

private _fnc_resetMissionSettings = {
    // --- initialize settings of new mission
    #include "initMissionSettings.sqf"
};

add3DENEventHandler ["onMissionNew", _fnc_resetMissionSettings];
add3DENEventHandler ["onMissionLoad", _fnc_resetMissionSettings];
