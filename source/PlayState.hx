package;

import flixel.FlxSprite;
import flixel.ui.FlxButton;
import flixel.tile.FlxTilemap;
import flixel.FlxState;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.math.FlxRandom;
import flixel.util.FlxColor;

import Player;
import Enemy;
import LevelLoader;

class PlayState extends FlxState
{
	public var map:FlxTilemap;
	public var player:Player;
	public var enemy:Enemy;
	public var pooProgress:Float = 0;
	public var playTime:Int    = 0;
	public var isSeeking:Bool  = false;

	public var pooText:FlxText;
	public var timeText:FlxText;

	public var loseState:Bool = false;
	public var winState:Bool = false;
	public var restartBtn:FlxButton;

	override public function create():Void
	{
		// Play music
		FlxG.sound.playMusic(AssetPaths.dogpark__wav, 0.5, true);

		player = new Player();
		LevelLoader.loadLevel(this, 'room');
		add(player);

		pooText = new FlxText(70, 2, 150, "poo progress: " + pooProgress + "%");
		add(pooText);

		timeText = new FlxText(10, 2, 100, "time: " + playTime);
		add(timeText);

		enemy = new Enemy(50, 29, player);
		add(enemy);

		// Playtime
		new FlxTimer().start(1, function(timer) {
			playTime += 1;
			timeText.text = "time: " + playTime;
		}, 0);

		// Timer to reduce pooProgress over time
		new FlxTimer().start(0.8, function(timer) {
			if (pooProgress > 0) {
				if (pooProgress - 1 <= 0) pooProgress = 0;
				else pooProgress -= 1;

				pooProgress = fixedFloat(pooProgress, 1);
				pooText.text = "poo progress: " + pooProgress + "%";
			}
		}, 0);

		restartBtn = new FlxButton(0, 90, "Retry", function() {
			FlxG.resetState();
		});

		restartBtn.visible = false;

		add(restartBtn);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (!loseState && !winState) {
			pooAction();
		}

		// Collisions
		FlxG.collide(map, player);
		FlxG.collide(player, enemy);
	}

	private function pooAction():Void
	{
		var pressed:Bool = FlxG.keys.anyJustPressed([Z]);

		if (pressed) {
			FlxG.camera.shake(0.01, 0.1);
			FlxG.sound.play(AssetPaths.push__wav, 0.8);

			if (enemy.isSeeking) {
				toggleLoseState();
			} else {
				pooProgress += 1.2;
				pooProgress = fixedFloat(pooProgress, 1);
				pooText.text = "poo progress: " + pooProgress + "%";

				if (pooProgress >= 100) toggleWinState();
			}
		}
	}

	private function toggleLoseState():Void
	{
		loseState = true;
		restartBtn.visible = true;
		disableAndHideUI();

		// var color = FlxColor.fromRGB(0, 0, 0, 100);
		var loseText = new FlxText(0, 20, 0, "You got caught. :(", 8);
		loseText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		add(loseText);
	}

	private function toggleWinState():Void
	{
		createPoo();
		winState = true;
		restartBtn.visible = true;
		disableAndHideUI();

		FlxG.sound.play(AssetPaths.success__wav, 0.8);

		var winText = new FlxText(0, 20, 178, "You did it! You took a dump in Rob's room!", 8);
		var yourTimeText = new FlxText(0, 40, 178, "Your time was: " + playTime + " seconds", 8);
		winText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		yourTimeText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);

		add(winText);
		add(yourTimeText);
	}

	private function disableAndHideUI():Void
	{
		enemy.cancelSeekTimer();
		pooText.visible = false;
		timeText.visible = false;
	}

	private function createPoo():Void
	{
		var y = player.y - 42;
		var x = player.x - 42;

		var poo = new FlxSprite(x, y, AssetPaths.poo__png);
		add(poo);
	}

    private function fixedFloat(v:Float, ?precision:Int = 2):Float
	{
		return Math.round( v * Math.pow(10, precision) ) / Math.pow(10, precision);
	}
}
