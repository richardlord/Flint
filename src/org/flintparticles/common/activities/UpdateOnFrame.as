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

package org.flintparticles.common.activities
{
	import org.flintparticles.common.emitters.Emitter;		

	/**
	 * The UpdateOnFrame activity is used to call a frameUpdate method of an object 
	 * that implements the FrameUpdatable interface. The frameUpdate method is called
	 * once every frame.
	 * 
	 * <p>This activity is most often used to update an action once every frame.
	 * Because the update method of an action is called once for every particle, 
	 * every frame, there is no obvious point for an action to implement code
	 * that should be called once only every frame, irrespective of the number
	 * of particles. If the action implements FrameUpdatable and adds an 
	 * UpdateOnFrame activity to the emitter in its addedToEmitter method, the
	 * frameUpdate method will be called once every frame.</p>
	 * 
	 * <p>See the Explosion Action for an example of an action that uses this 
	 * activity.</p>
	 * 
	 * @see org.flintparticles.twoD.actions.Explosion
	 */
	public class UpdateOnFrame extends ActivityBase
	{
		private var action:FrameUpdatable;
		/**
		 * The constructor creates an UpdateOnFrame activity.
		 * 
		 * @param fu The object that shouldbe updated every frame.
		 */
		public function UpdateOnFrame( frameUpdatable:FrameUpdatable )
		{
			action = frameUpdatable;
		}
		
		/**
		 * Calls the frameUpdate method of the FrameUpdatable object associated
		 * with this activity.
		 * 
		 * <p>This method is called by the emitter and need not be called by the 
		 * user</p>
		 * 
		 * @param emitter The Emitter.
		 * @param time The duration of the frame - used for time based updates.
		 * 
		 * @see org.flintparticles.common.actions.Activity#update()
		 */
		override public function update( emitter:Emitter, time:Number ):void
		{
			action.frameUpdate( emitter, time );
		}
	}
}