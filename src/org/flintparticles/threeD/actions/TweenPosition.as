/*
 * FLINT PARTICLE SYSTEM
 * .....................
 * 
 * Author: Richard Lord
 * Copyright (c) Richard Lord 2008-2011
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
	import org.flintparticles.common.actions.ActionBase;
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.threeD.geom.Vector3DUtils;
	import org.flintparticles.threeD.particles.Particle3D;

	import flash.geom.Vector3D;

	/**
	 * The TweenPosition action adjusts the particle's position between two
	 * locations as it ages. This action
	 * should be used in conjunction with the Age action.
	 */

	public class TweenPosition extends ActionBase
	{
		private var _start:Vector3D;
		private var _end:Vector3D;
		private var _diff:Vector3D;
		
		/**
		 * The constructor creates a TweenPosition action for use by 
		 * an emitter. To add a TweenPosition to all particles created by an emitter, use the
		 * emitter's addAction method.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addAction()
		 * 
		 * @param startX The x value for the particle at the
		 * start of its life.
		 * @param startY The y value for the particle at the
		 * start of its life.
		 * @param endX The x value of the particle at the end of its
		 * life.
		 * @param endY The y value of the particle at the end of its
		 * life.
		 */
		public function TweenPosition( start:Vector3D = null, end:Vector3D = null )
		{
			this.start = start ? start : new Vector3D();
			this.end = end ? end : new Vector3D();
		}
		
		/**
		 * The x position for the particle at the start of its life.
		 */
		public function get start():Vector3D
		{
			return _start;
		}
		public function set start( value:Vector3D ):void
		{
			_start = Vector3DUtils.clonePoint( value );
			if( _end )
			{
				_diff = _start.subtract( _end );
			}
		}
		
		/**
		 * The X value for the particle at the end of its life.
		 */
		public function get end():Vector3D
		{
			return _end;
		}
		public function set end( value:Vector3D ):void
		{
			_end = Vector3DUtils.clonePoint( value );
			if( _start )
			{
				_diff = _start.subtract( _end );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update( emitter:Emitter, particle:Particle, time:Number ):void
		{
			var p:Vector3D = Particle3D( particle ).position;
			var r:Number = particle.energy;
			p.x = _diff.x * r + _end.x;
			p.y = _diff.y * r + _end.y;
			p.z = _diff.z * r + _end.z;
		}
	}
}
