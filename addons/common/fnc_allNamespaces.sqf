/* ----------------------------------------------------------------------------
Function: CBA_fnc_allNamespaces

Description:
    Reports namespaces created with CBA_fnc_createNamespace.

Parameters:
    None

Returns:
    _namespace - all custom namespaces <ARRAY>

Examples:
    (begin example)
        _namespaces = call CBA_fnc_allNamespaces;
    (end)

Author:
    commy2
---------------------------------------------------------------------------- */
#include "script_component.hpp"
SCRIPT(allNamespaces);

nearestLocations [DUMMY_POSITION, ["CBA_NamespaceDummy"], 1] + nearestObjects [DUMMY_POSITION, ["CBA_NamespaceDummy"], 1]
