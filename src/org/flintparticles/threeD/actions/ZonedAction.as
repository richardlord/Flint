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

package org.flintparticles.threeD.actions 
{
	import org.flintparticles.common.actions.Action;
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.particles.Particle3D;
	import org.flintparticles.threeD.zones.Zone3D;	

	/**
	 * The ZonedAction Action applies an action to the particle only if it is in the specified zone. 
	 */

	public class ZonedAction extends ActionBase
	{
		private var _action:Action;
		private var _zone:Zone3D;
		private var _invert:Boolean;
		
		/**
		 * The constructor creates a ZonedAction action for use by 
		 * an emitter. To add a ZonedAction to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.emitters.Emitter#addAction()
		 * 
		 * @param action The action to apply when inside the zone.
		 * @param zone The zone in which to apply the action.
		 * @param invertZone If false (the default) the action is applied only to particles inside 
		 * the zone. If true the action is applied only to particles outside the zone.
		 */
		public function ZonedAction( action:Action = null, zone:Zone3D = null, invertZone:Boolean = false )
		{
			this.action = action;
			this.zone = zone;
			this.invertZone = invertZone;
		}
		
		/**
		 * The action to apply when inside the zone.
		 */
		public function get action():Action
		{
			return _action;
		}
		public function set action( value:Action ):void
		{
			_action = value;
		}
		
		/**
		 * The zone in which to apply the acceleration.
		 */
		public function get zone():Zone3D
		{
			return _zone;
		}
		public function set zone( value:Zone3D ):void
		{
			_zone = value;
		}
		
		/**
		 * If false (the default), the action is applied to particles inside the zone.
		 * If true, the action is applied to particles outside the zone.
		 */
		public function get invertZone():Boolean
		{
			return _invert;
		}
		public function set invertZone( value:Boolean ):void
		{
			_invert = value;
		}
		
		/**
		 * Provides access to the priority of the action being used.
		 * 
		 * @inheritDoc
		 */
		override public function get priority():int
		{
			return _action.priority;
		}
		override public function set priority( value:int ):void
		{
			_action.priority = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addedToEmitter( emitter:Emitter ):void
		{
			_action.addedToEmitter( emitter );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removedFromEmitter( emitter:Emitter ):void
		{
			_action.removedFromEmitter( emitter );
		}

		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Particle3D = Particle3D( particle );
			if( _zone.contains( p.position ) )
			{
				if( !_invert )
				{
					_action.update( emitter, p, time );
				}
			}
			else
			{
				if( _invert )
				{
					_action.update( emitter, p, time );
				}
			}
		}
	}
}
