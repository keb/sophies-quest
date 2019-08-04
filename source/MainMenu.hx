package;

import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxColor;

class MainMenu extends FlxState
{
    public var page:Int = 0;
    public var nextBtn:FlxButton;
    public var t:FlxText;
    public var sophie:FlxSprite;
    public var instructions:FlxText;

    override public function create():Void
    {
        FlxG.sound.playMusic(AssetPaths.dogpark__wav, 0.5, true);

        var t = new FlxText(10, 10, 160, "Sophie's Quest", 16);
        var sophie = new FlxSprite(130, 70);

        var instructionText = "Sophie needs to use the bathroom, but Rob is too busy on the computer to take her for a walk! Press Z on the keyboard repeatedly to take a dump in Rob's room. But be careful not to get caught! The red flash means Rob is about to turn around.";

        var instructions = new FlxText(2, 2, 160, instructionText, 8);
        instructions.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

        var nextBtn = new FlxButton(2, 100, "Start", function() {
            if (page == 0) {
                t.visible = false;
                instructions.visible = true;
                page = 1;
            } else {
                FlxG.switchState(new PlayState());
            }
        });

        sophie.loadGraphic(AssetPaths.sophie__png, true, 32, 32);
        sophie.animation.add('idle', [0, 1, 2, 3], 4);
        sophie.animation.play('idle');
        sophie.scale.set(4, 4);

        instructions.visible = false;

        add(t);
        add(sophie);
        add(nextBtn);
        add(instructions);
    }
}