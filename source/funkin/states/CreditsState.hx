package funkin.states;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

import funkin.objects.*;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = -1;
	
	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];
	private var creditsStuff:Array<Array<String>> = [];
	
	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;
	var descBox:AttachedSprite;
	var fadeTimer:Float = 0;
	var fadeDuration:Float = 1;
	
	var offsetThing:Float = -75;
	
	override function create()
	{
		#if DISCORD_ALLOWED
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		
		FlxG.sound.playMusic(Paths.music('credits'), 0.9, true);
		FlxG.sound.music.fadeIn(4, 0, 0.7);

		persistentUpdate = true;
		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);
		bg.screenCenter();
		
		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);
		
		#if MODS_ALLOWED
		var path:String = 'modsList.txt';
		if (FileSystem.exists(path))
		{
			var leMods:Array<String> = CoolUtil.coolTextFile(path);
			for (i in 0...leMods.length)
			{
				if (leMods.length > 1 && leMods[0].length > 0)
				{
					var modSplit:Array<String> = leMods[i].split('|');
					if (!Mods.ignoreModFolders.contains(modSplit[0].toLowerCase()) && !modsAdded.contains(modSplit[0]))
					{
						if (modSplit[1] == '1') pushModCreditsToList(modSplit[0]);
						else modsAdded.push(modSplit[0]);
					}
				}
			}
		}
		
		var arrayOfFolders:Array<String> = Mods.getModDirectories();
		arrayOfFolders.push('');
		for (folder in arrayOfFolders)
		{
			pushModCreditsToList(folder);
		}
		#end
		
		// were gonna need to update these credits later lol //data todo //still todo lol
		var pisspoop:Array<Array<String>> = [
			// Name - Icon name - Description - Link - BG Color
			['Crimson Requiem'],
			[
				'ReddyForefer', 'reddy', 'Owner/Director, VA of MY5TCrimson Sonic.EXE for Tyranny\n Chrom for Fallen To Fakery', '','#ab0022'
			],
			[	'SLTIWX','iwx','BG & Icon Artist Tyranny','','0x2090e0'
			],
			[	'CassidyWasHere', 'thanks', 'BG for Fallen to Fakery', '', '0x00ff00'
			],
			[	'Lolq', 'lolq', 'Inst for Tyranny',	'', '0xffffff'
			],
			[	'_DatBoiHere',	'datboi', 'add Vocals for Tyranny\n Fallen to Fakey creator\n Propher',	'', '0xffffff'
			],
			[	'Coral',	'coral',	'Charted Tyranny', '', '0xffffff'
			],
			[	'QRDM', 'thanks', 'Ported this to Nightmare Vision Engine\n + custom events\n Fallen to Fakery chart', '', '0Xffffff'
			],
			[''],
			
			[	'guy', 'missing_icon', 'cock lover', '', '0xffffff'
			],

		];
		
		creditsStuff = creditsStuff.concat(pisspoop);
		
		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			optionText.yAdd -= 70;
			if (isSelectable)
			{
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			// optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);
			
			if (isSelectable)
			{
				if (creditsStuff[i][5] != null)
				{
					Mods.currentModDirectory = creditsStuff[i][5];
				}
				
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.setGraphicSize(130);
				icon.updateHitbox();
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
				
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
				Mods.currentModDirectory = '';
				
				if (curSelected == -1) curSelected = i;
			}
		}
		
		descBox = new AttachedSprite();
		descBox.makeGraphic(1, 1, FlxColor.BLACK);
		descBox.xAdd = -10;
		descBox.yAdd = -10;
		descBox.alphaMult = 0.6;
		descBox.alpha = 0.6;
		add(descBox);
		
		descText = new FlxText(50, FlxG.height + offsetThing - 25, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER /*, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK*/);
		descText.scrollFactor.set();
		descBox.sprTracker = descText;
		add(descText);
		
		bg.color = FlxColor.fromString(creditsStuff[curSelected][4]);
		intendedColor = bg.color;
		changeSelection();
		super.create();
	}
	
	var quitting:Bool = false;
	var holdTime:Float = 0;
	
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}
		
		if (!quitting)
		{
			if (creditsStuff.length > 1)
			{
				var shiftMult:Int = 1;
				if (FlxG.keys.pressed.SHIFT) shiftMult = 3;
				
				var upP = controls.UI_UP_P;
				var downP = controls.UI_DOWN_P;
				
				if (upP)
				{
					changeSelection(-1 * shiftMult);
					holdTime = 0;
				}
				if (downP)
				{
					changeSelection(1 * shiftMult);
					holdTime = 0;
				}
				
				if (controls.UI_DOWN || controls.UI_UP)
				{
					var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
					holdTime += elapsed;
					var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);
					
					if (holdTime > 0.5 && checkNewHold - checkLastHold > 0)
					{
						changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					}
				}
			}
			
			if (controls.ACCEPT && (creditsStuff[curSelected][3] == null || creditsStuff[curSelected][3].length > 4))
			{
				CoolUtil.browserLoad(creditsStuff[curSelected][3]);
			}
			if (controls.BACK)
			{
				colorTween?.cancel();
				
				FlxG.sound.music.stop();
				FlxG.sound.music.fadeIn(10, 10, 0.7);
				FlxG.sound.play(Paths.sound('cancelMenu'));
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0.8, true);
				FlxG.switchState(MainMenuState.new);
				quitting = true;
			}
		}
		
		for (item in grpOptions.members)
		{
			if (!item.isBold)
			{
				var lerpVal:Float = FlxMath.bound(elapsed * 12, 0, 1);
				if (item.targetY == 0)
				{
					var lastX:Float = item.x;
					item.screenCenter(X);
					item.x = FlxMath.lerp(lastX, item.x - 70, lerpVal);
					item.forceX = item.x;
				}
				else
				{
					item.x = FlxMath.lerp(item.x, 200 + -40 * Math.abs(item.targetY), lerpVal);
					item.forceX = item.x;
				}
			}
		}
		super.update(elapsed);
	}
	
	var moveTween:FlxTween = null;
	
	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do
			(curSelected = FlxMath.wrap(curSelected + change, 0, creditsStuff.length - 1))
		while (unselectableCheck(curSelected));
		
		final newColor:FlxColor = FlxColor.fromString(creditsStuff[curSelected][4]);
		if (newColor != intendedColor)
		{
			colorTween?.cancel();
			intendedColor = newColor;
			
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor,
				{
					onComplete: function(twn:FlxTween) {
						colorTween = null;
					}
				});
		}
		
		for (k => item in grpOptions.members)
		{
			item.targetY = k - curSelected;
			
			if (!unselectableCheck(k))
			{
				item.alpha = 0.6;
				if (item.targetY == 0)
				{
					item.alpha = 1;
				}
			}
		}
		
		descText.text = creditsStuff[curSelected][2];
		descText.y = FlxG.height - descText.height + offsetThing - 60;
		
		if (moveTween != null) moveTween.cancel();
		moveTween = FlxTween.tween(descText, {y: descText.y + 75}, 0.25, {ease: FlxEase.sineOut});
		
		descBox.setGraphicSize(Std.int(descText.width + 20), Std.int(descText.height + 25));
		descBox.updateHitbox();
	}
	
	#if MODS_ALLOWED
	private var modsAdded:Array<String> = [];
	
	function pushModCreditsToList(folder:String)
	{
		if (modsAdded.contains(folder)) return;
		
		var creditsFile:String = null;
		if (folder != null && folder.trim().length > 0) creditsFile = Paths.mods(folder + '/data/credits.txt');
		else creditsFile = Paths.mods('data/credits.txt');
		
		if (FileSystem.exists(creditsFile))
		{
			var firstarray:Array<String> = File.getContent(creditsFile).split('\n');
			for (i in firstarray)
			{
				var arr:Array<String> = i.replace('\\n', '\n').split("::");
				if (arr.length >= 5) arr.push(folder);
				creditsStuff.push(arr);
			}
			creditsStuff.push(['']);
		}
		modsAdded.push(folder);
	}
	#end
	
	function unselectableCheck(num:Int):Bool return creditsStuff[num].length <= 1;
}
