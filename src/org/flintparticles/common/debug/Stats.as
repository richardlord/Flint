package org.flintparticles.common.debug
{
	import flash.events.Event;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;

	/**
	 * A simple stats display object showing the frame-rate, the memory usage and the number of particles in use.
	 */
	public class Stats extends TextField
	{
		private const FACTOR : Number = 1 / ( 1024 * 1024 );
		private var timer : uint;
		private var fps : uint;
		private var next : uint;
		private var mem : Number;
		private var max : Number;

		public function Stats( color : uint = 0xFFFFFF, bgColor : uint = 0 ) : void
		{
			max = 0;

			var tf : TextFormat = new TextFormat();
			tf.color = color;
			tf.font = '_sans';
			tf.size = 9;
			tf.leading = -1;

			backgroundColor = bgColor;
			background = true;
			defaultTextFormat = tf;
			multiline = true;
			selectable = false;
			mouseEnabled = false;
			autoSize = TextFieldAutoSize.LEFT;

			addEventListener( Event.ADDED_TO_STAGE, start );
			addEventListener( Event.REMOVED_FROM_STAGE, stop );
		}

		private function start( e : Event ) : void
		{
			addEventListener( Event.ENTER_FRAME, update );
			text = "";
			next = timer + 1000;
		}

		private function stop( e : Event ) : void
		{
			removeEventListener( Event.ENTER_FRAME, update );
		}

		private function update( e : Event ) : void
		{
			timer = getTimer();

			if ( timer > next )
			{
				next = timer + 1000;
				mem = Number( (System.totalMemory * FACTOR).toFixed( 3 ) );
				if ( max < mem )
				{
					max = mem;
				}

				text = "FPS: " + fps + " / " + stage.frameRate + "\nMEMORY: " + mem + "\nMAX MEM: " + max + "\nPARTICLES: " + ParticleFactoryStats.numParticles;

				fps = 0;
			}

			fps++;
		}
	}
}
