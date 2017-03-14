#include "script_component.hpp"

#include "XEH_PREP.sqf"

PREP(gui_initDisplay);
PREP(gui_initDisplay_disabled);
PREP(init3DEN);
PREP(loadUserconfig);

if (!hasInterface) then {
    [displayNull] call FUNC(loadUserconfig);
};
