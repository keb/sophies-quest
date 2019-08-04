package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
// import flixel.addons.effects.chainable.FlxShakeEffect;

class Player extends FlxSprite
{
    private var SPEED:Float = 100;
    private var DRAG:Float  = 320;

    private var pooMode:Bool = false;

    // private var effect:FlxShakeEffect;

    public function new()
    {
        super(x, y);
        loadGraphic(AssetPaths.sophie__png, true, 32, 32);

        animation.add('idle', [0, 1, 2, 3], 4);
        animation.add('poo', [4], 4);

        setSize(19, 5);
        offset.set(8, 24);

        drag.x = DRAG;
        drag.y = DRAG;

        // Routinely turn off pooMode
        new FlxTimer().start(1.0, timer -> pooMode = false, 0);

        // effect = new FlxShakeEffect(0.02, 0.2);
    }

    override public function update(elapsed:Float):Void
    {
        // move();
        animate();
        super.update(elapsed);
    }

    private function move():Void
    {
        var up:Bool    = false;
        var down:Bool  = false;
        var left:Bool  = false;
        var right:Bool = false;

        up    = FlxG.keys.anyPressed([UP, W]);
        down  = FlxG.keys.anyPressed([DOWN, S]);
        left  = FlxG.keys.anyPressed([LEFT, A]);
        right = FlxG.keys.anyPressed([RIGHT, D]);

        if (up && down)
            up = down = false;
        if (left && right)
            left = right = false;

        if (left) {
            this.velocity.x = -SPEED;
            this.flipX = false;
        } else if (right) {
            this.velocity.x = SPEED;
            this.flipX = true;
        } else {
            this.velocity.x = 0;
        }

        if (up)
            this.velocity.y = -SPEED;
        else if (down)
            this.velocity.y = SPEED;
        else
            this.velocity.y = 0;

        // Prevent Player from going off map
        if (this.x < 0)
            this.x = 0;
        if (this.y < 0)
            this.y = 0;
    }

    private function animate():Void
    {
		var pressed:Bool = FlxG.keys.anyJustPressed([Z]);

		if (pressed) {
			animation.play('poo');
            pooMode = true;
		} else {
            if (!pooMode) animation.play('idle');
            else animation.play('poo');
        }
    }
}