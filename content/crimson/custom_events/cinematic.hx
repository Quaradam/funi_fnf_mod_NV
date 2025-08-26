import haxe.ds.Vector;
import haxe.ds.StringMap;

class Main {
    var hudItems:Dynamic = { opaque: [], nonOpaque: [] };
    var orderCheck:Dynamic = { underNotes: "", overNotes: "" };
    var initialStrumY:Int = 0;
    var hpOpacity:Float;

    var fadeHUD:Bool = true;
    var fadeNotes:Bool = false;
    var moveNotes:Bool = true;

    public function new() {
        onCreatePost();
    }

    function onCreatePost() {
        luaDebugMode = true;

        luaGraphic("topBar", 0, -1);
        luaGraphic("bottomBar", 0, screenHeight);

        if (StringTools.startsWith(version, "0.7") || StringTools.startsWith(version, "1.")) {
            hpOpacity = getPropertyFromClass("backend.ClientPrefs", "data.healthBarAlpha");
            hudItems.opaque = ["scoreTxt", "timeBar", "timeTxt"];
            hudItems.nonOpaque = ["healthBar", "iconP1", "iconP2"];
            orderCheck.underNotes = "uiGroup";
            orderCheck.overNotes = "uiGroup";
            if (version == "0.7" || version == "0.7.1" || version == "0.7.1h") {
                orderCheck.underNotes = "timeBar";
                orderCheck.overNotes = "scoreTxt";
            }
        } else {
            hpOpacity = getPropertyFromClass("ClientPrefs", "healthBarAlpha");
            hudItems.opaque = ["scoreTxt", "timeBar", "timeBarBG", "timeTxt"];
            hudItems.nonOpaque = ["healthBarBG", "healthBar", "iconP1", "iconP2"];
            orderCheck.underNotes = "timeBarBG";
            orderCheck.overNotes = "scoreTxt";
        }
    }

    function onCountdownStarted() {
        initialStrumY = getPropertyFromGroup("strumLineNotes", 0, "y");
    }

    function onEvent(eventName:String, value1:String, value2:String) {
        if (eventName == "Cinematics") {
            var barProperties:Array<String> = value1.split(",");
            var cinematicType:Int = Std.parseInt(value2);

            doTweenY("moveTopBar", "topBar", (Std.parseFloat(barProperties[0]) * 0.5) - 1, Std.parseFloat(barProperties[1]), "quadOut");
            doTweenY("scaleTopBar", "topBar.scale", Std.parseFloat(barProperties[0]), Std.parseFloat(barProperties[1]), "quadOut");
            doTweenY("moveBottomBar", "bottomBar", screenHeight - (Std.parseFloat(barProperties[0]) * 0.5), Std.parseFloat(barProperties[1]), "quadOut");
            doTweenY("scaleBottomBar", "bottomBar.scale", Std.parseFloat(barProperties[0]), Std.parseFloat(barProperties[1]), "quadOut");

            if (Std.parseFloat(barProperties[0]) > 0) {
                setObjectOrder("topBar", cinematicType == 2 ? getObjectOrder(orderCheck.overNotes) + 1 : getObjectOrder(orderCheck.underNotes) - 2);
                setObjectOrder("bottomBar", cinematicType == 2 ? getObjectOrder(orderCheck.overNotes) + 1 : getObjectOrder(orderCheck.underNotes) - 2);

                fadeHUD = cinematicType != 3;
                fadeNotes = cinematicType == 4;
                moveNotes = cinematicType != 5;

                if (fadeHUD) {
                    for (i in 0...hudItems.opaque.length) {
                        doTweenAlpha("opaqueFade" + i, hudItems.opaque[i], 0, Std.parseFloat(barProperties[1]), "quadOut");
                    }

                    for (i in 0...hudItems.nonOpaque.length) {
                        doTweenAlpha("nonOpaqueFade" + i, hudItems.nonOpaque[i], 0, Std.parseFloat(barProperties[1]), "quadOut");
                    }
                }

                for (i in 0...8) {
                    if (fadeNotes) {
                        noteTweenAlpha("noteFade" + i, i, 0, Std.parseFloat(barProperties[1]), "quadOut");
                    }

                    if (moveNotes) {
                        noteTweenY("noteY" + i, i, downscroll ? (screenHeight - Std.parseFloat(barProperties[0])) - (getPropertyFromGroup("strumLineNotes", i, "height") + 45) : Std.parseFloat(barProperties[0]) + initialStrumY, Std.parseFloat(barProperties[1]), "quadOut");
                    }
                }
            }
        }
    }
}