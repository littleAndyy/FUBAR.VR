// function for unconscious chance based on multipler given (usually increase multiplier + limit in more serious conditions)
params ["_unit", "_multiplier", "_unconsciousLimit"];
private _unconsciousChance = ((round random 100) * _multiplier); //25/80 = not unconscious. 60/50 = unconscious.
if (_unconsciousChance > _unconsciousLimit) then {
    _unit setUnconscious true;
} else {
    _unit spawn {
        if (!alive _this) exitWith {};
        sleep 1;
        _unit = _this;
        _unit setUnconscious false;
        sleep 3;
        [_unit, ""] remoteExec ["playMoveNow", 0];
    };
};
// dead asf
if (_unconsciousChance >= 110) then {
    _unit setDamage 1;
};
