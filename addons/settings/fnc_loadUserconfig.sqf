#include "script_component.hpp"

params ["_display"];

private _fileExists = false;

if (!isNull _display) then {
    private _control = _display ctrlCreate ["RscHTML", -1];

    _control htmlLoad PATH_SETTINGS_FILE;
    _fileExists = ctrlHTMLLoaded _control;
};

if (_fileExists || !hasInterface) then {
    uiNamespace setVariable [QGVAR(userconfig), loadFile PATH_SETTINGS_FILE];
};
