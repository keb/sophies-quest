package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		addChild(new FlxGame(176, 128, MainMenu, 2, 60, 60, true));
		// addChild(new FlxGame(176, 128, PlayState, 2, 60, 60, true));
	}
}
