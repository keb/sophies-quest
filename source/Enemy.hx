package;

import flixel.math.FlxVelocity;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;

class Enemy extends FlxSprite
{
    private var SPEED:Float = 60;
    private var DRAG:Float  = 320;

    public var target:FlxSprite;
    public var isSeeking:Bool = false;

    public var timer:FlxTimer;

    public function new(x:Float, y:Float, target:FlxSprite)
    {
        super(x, y);
        loadGraphic(AssetPaths.rob__png, true, 32, 32);

        animation.add('idle', [0]);
        animation.add('to_seeking', [0, 1, 2], 4);
        animation.add('seeking', [2]);
        animation.add('from_seeking', [2, 1, 0], 4);

        this.target = target;

        drag.x = DRAG;
        drag.y = DRAG;

        // Seek Timer
		var outerInterval = () -> FlxG.random.float(4.0, 8.0);
		var seekDuration = () -> FlxG.random.float(1.2, 5.0);

        animation.play('idle');

		timer = new FlxTimer().start(outerInterval(), function(first) {
            FlxG.sound.play(AssetPaths.seeking__wav, 0.8);
            // Play Flash Warning
            FlxG.camera.flash(FlxColor.RED, 0.18, function() {
                // Begin Seeking
                toggleSeek();
                animation.play('seeking');

                // Then time when to end seeking
                new FlxTimer().start(seekDuration(), function(second) {
                    toggleSeek();
                    animation.play('idle');
                    first.reset(outerInterval());
                }, 1);
            });
		}, 1);
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    private function gravitate():Void
    {
        FlxVelocity.moveTowardsPoint(this, target.getPosition(), SPEED);
    }

	private function toggleSeek():Void
	{
		if (isSeeking) {
			isSeeking = false;
		} else {
			isSeeking = true;
		}
	}

    public function cancelSeekTimer():Void
    {
        timer.cancel();
        timer.destroy();
    }
}