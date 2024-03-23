params ["_index"];
private _name = "";
switch (_index) do {
    case 0: {
        _name = "Head";
        _name
    };
    case 1: {
        _name = "Neck";
        _name
    };
    case 2: {
        _name = "Chest";
        _name
    };
    case 3: {
        _name = "Abdomen";
        _name
    };
    case 4: {
        _name = "Pelvis";
        _name
    };
    case 5: {
        _name = "Left Arm";
        _name
    };
    case 6: {
        _name = "Right Arm";
        _name
    };
    case 7: {
        _name = "Left Hand";
        _name
    };
    case 8: {
        _name = "Right Hand";
        _name
    };
    case 9: {
        _name = "Left Leg";
        _name
    };
    case 10: {
        _name = "Right Leg";
        _name
    };
    case 11: {
        _name = "Left Foot";
        _name
    };
    case 12: {
        _name = "Right Foot";
        _name
    };
};
systemChat str _name;
_name
