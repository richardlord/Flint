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

package org.flintparticles.threeD.renderers.controllers.mxml 
{
	import org.flintparticles.threeD.renderers.controllers.KeyboardControllerBase;

	import mx.core.IMXMLObject;

	import flash.display.DisplayObject;
	import flash.events.Event;

	/**
	 * Sets keyboard input to make a renderer's camera orbit around a point in response to 
	 * keyboard input.
	 * 
	 * <p>After assigning a camera to an instance of this class, the camera responds to the
	 * following keyboard input</p>
	 * 
	 * <ul>
	 * <li>W or Up arrow keys - track towards the target.</li>
	 * <li>S or Down arrow keys - track away from the target.</li>
	 * <li>A or Left arrow keys - orbit left around the target.</li>
	 * <li>D or Right arrow keys - orbit right around the target.</li>
	 * </ul>
	 */
	public class KeyboardControllerMxml extends KeyboardControllerBase implements IMXMLObject
	{		
		public function initialized( document:Object, id:String ):void
		{
			var displayObj:DisplayObject = document as DisplayObject;
			if( displayObj )
			{
				if( displayObj.stage )
				{
					this.stage = displayObj.stage;
				}
				else
				{
					displayObj.addEventListener( Event.ADDED_TO_STAGE, addedToStage );
				}
			}
			if( autoStart )
			{
				start();
			}
		}
		
		private function addedToStage( ev:Event ):void
		{
			this.stage = DisplayObject( ev.target ).stage;
		}
	}
}
