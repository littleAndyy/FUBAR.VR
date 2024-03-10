if (isNil "ANDY1_FUBAR_projectiles") then {
    ANDY1_FUBAR_projectiles = [];
};

addMissionEventHandler ["ProjectileCreated", {
	params ["_projectile"];
    if (_projectile distance player < 3000) then {
        ANDY1_FUBAR_projectiles pushBack _projectile;
    };
    findDisplay 12 displayCtrl 51 ctrlAddEventHandler ["Draw", {
        {
            if (isNull _x) then {
                ANDY1_FUBAR_projectiles = ANDY1_FUBAR_projectiles - [_x];
            } else {
                _this select 0 drawIcon [
                    "\A3\ui_f\data\map\markers\military\box_CA.paa",
                    [1, 0.8, 0.2, 0.9],
                    getPosASLVisual _x,
                    4,
                    24,
                    getDirVisual _x,
                    "",
                    0
                ]
            };
        }
        forEach ANDY1_FUBAR_projectiles;
    }];
}];