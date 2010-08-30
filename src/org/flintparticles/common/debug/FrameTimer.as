/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2010
 * http://flintparticles.org
 * 
 * 
 * Licence Agreement
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package org.flintparticles.common.debug 
{
	import flash.events.Event;
	import flash.text.TextField;
	import flash.utils.getTimer;	

	/**
	 * Displays the current framerate. The framerate displayed is an average of 
	 * the last ten frames. Simply create an instance of this class and place it 
	 * on the stage.
	 */

	public class FrameTimer extends TextField
	{
	    private var _times:Array;
	    
	    /**
	     * Creates a FrameTimer.
	     * 
	     * @param color The color to use for the text display.
	     */
	    public function FrameTimer( color:uint = 0xFFFFFF )
	   	{
				textColor = color;
				_times = new Array();
				addEventListener( Event.ENTER_FRAME, onEnterFrame1, false, 0, true );
	    }

		private function onEnterFrame1( ev:Event ):void
		{
			if ( _times.push( getTimer() ) > 9 )
			{
				removeEventListener( Event.ENTER_FRAME, onEnterFrame1 );
				addEventListener( Event.ENTER_FRAME, onEnterFrame2, false, 0, true );
			}
		}
	
		private function onEnterFrame2( ev:Event ):void
		{
			var t:Number;
			_times.push( t = getTimer() );
			text = ( Math.round( 10000 / ( t - Number( _times.shift() ) ) ) ).toString() + " fps";
		}
	}
}
