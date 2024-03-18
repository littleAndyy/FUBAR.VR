// ? https://forums.bohemia.net/forums/topic/205515-handledamage-event-handler-explained/

// ? https://community.bistudio.com/wiki/Arma_3:_Event_Handlers#HandleDamage

if (isMultiplayer) then {
    if ((isPlayer _this) && isNil {_this getVariable "ANDY1_FUBAR_status"}) then {
        _this setVariable ["ANDY1_FUBAR_status", "NORMAL", true];
    };
} else {
    if (isNil {_this getVariable "ANDY1_FUBAR_status"}) then {
        _this setVariable ["ANDY1_FUBAR_status", "NORMAL", true];
    };
};

_this addEventHandler ["HitPart", {
	(_this select 0) params ["_unit", "_shooter", "_projectile", "_position", "_velocity", "_selection", "_ammo", "_vector", "_radius", "_surfaceType", "_isDirect", "_instigator"];
    systemChat format ["_selection: %1", _selection];
    switch (_selection#0) do {
        case "face_hub":
        {
            _unit remoteExecCall ["ANDY1_fnc_FUBAR_dmgHead", _unit];
        };
        case "head":
        {
            _unit remoteExecCall ["ANDY1_fnc_FUBAR_dmgHead", _unit];
        };
        case "neck":
        {

        };
        case "pelvis":
        {

        };
        case "spine1":
        {

        };
        case "spine2":
        {

        };
        case "spine3":
        {

        };
        case "body":
        {

        };
        case "arms":
        {

        };
        case "hands":
        {

        };
        case "legs":
        {

        };
    };
    systemChat format ["_vecDir: %1", _velocity];
    _vecDir = _velocity;
    _hitpos = _unit selectionPosition (_selection select 0);
    _force = _vecDir vectorMultiply 0.6;
    [_unit, [_force, _hitPos]] remoteExec ["addForce", _unit];
}];

_this addEventHandler ["HandleDamage", {
	params ["_unit", "_selection", "_damage", "_source", "_projectile", "_hitIndex", "_instigator", "_hitPoint", "_directHit", "_context"];
    if (isPlayer _unit) then {_damage = _damage * 0.1};
    _damage;
}];