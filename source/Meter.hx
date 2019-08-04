package;

import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;

class Meter extends FlxSpriteGroup
{
    private var current:Int;
    private var max:Int;
    private var min:Int = 0;
    private var meterHeight:Int = 12;

    private var top:FlxSprite;
    private var bot:FlxSprite;

    public function new(x:Float = 0, y:Float = 0, current:Int = 50, max:Int = 50)
    {
        super(x, y);

        // Set current & max
        this.current = current < 1 ? 1 : current;
        this.max = current > max ? current : max;

        bot = new FlxSprite(0, 0);
        bot.makeGraphic(max, meterHeight, FlxColor.WHITE);

        top = new FlxSprite(0, 0);
        top.makeGraphic(current, meterHeight, FlxColor.RED);

        this.add(this.bot);
        this.add(this.top);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);
    }

    public function addToMeter(diff:Int)
    {
        if (current > 0) {
            current = Std.int(Math.max(0, (current + diff) ));
            var newCurrent:Float = current / max;

            FlxTween.tween(top.scale, { x: newCurrent }, 0.2, {
                ease: FlxEase.cubeInOut,
                onUpdate: function(tween:FlxTween) {
                    top.updateHitbox();
                },
                onComplete: function(tween:FlxTween) {
                    trace('diff');
                    trace(current);
                    trace(top.width);
                }
            });
        }
    }
}