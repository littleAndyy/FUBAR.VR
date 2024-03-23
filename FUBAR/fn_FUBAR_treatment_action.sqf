params ["_unit", "_index", "_bodyPartName", "_severity"];

if (_severity == "NORMAL") exitWith {};

private _array = _unit getVariable "ANDY1_FUBAR_actions";
private _var = [
    _unit,
    (format ["Treat %1 | CONDITION: %2", _bodyPartName, _severity]),
    "", "",
    "_this distance _target < 3",
    "_caller distance _target < 3",
    {},
    {},
    {
        //TODO: ADD CODE HERE - CHANCE TO SUCCEED. _caller HAS MEDICAL EQUIPMENT? (BASIC FOR NOW)
        params ["_target", "_caller", "_actionId", "_arguments"];
        private _bodyPartsHP = (_target getVariable "ANDY1_FUBAR_bodyPartsHP");
        _bodyPartsHP set [(_this#3#0), 0];
        [_target, -1] remoteExecCall ["ANDY1_FUBAR_dmgCheck", _target];
        //_target setVariable ["ANDY1_FUBAR_bodyPartsHP", _bodyPartsHP, true]; //update bodyparts hp array
    },
    {},
    [_index],
    (3+round random 5),
    0,
    true,
    false
] call BIS_fnc_holdActionAdd;
_array pushBack _var;