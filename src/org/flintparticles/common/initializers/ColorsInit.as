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

package org.flintparticles.common.initializers 
{
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.WeightedArray;	

	/**
	 * The ColorsInit initializer sets the color of the particle. It selects 
	 * one of multiple colors, using optional weighting values to produce an uneven
	 * distribution for the colors.
	 */

	public class ColorsInit extends InitializerBase
	{
		private var _colors:WeightedArray;
		private var _mxmlColors:Array;
		private var _mxmlWeights:Array;
		
		/**
		 * The constructor creates a ColorsInit initializer for use by 
		 * an emitter. To add a ColorsInit to all particles created by 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param colors An array containing the Colors to use for 
		 * each particle created by the emitter, as 32bit ARGB values.
		 * @param weights The weighting to apply to each color. If no weighting
		 * values are passed, the colors are all assigned a weighting of 1.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function ColorsInit( colors:Array = null, weights:Array = null )
		{
			_colors = new WeightedArray();
			if( colors == null )
			{
				return;
			}
			init( colors, weights );
		}
		
		override public function addedToEmitter( emitter:Emitter ):void
		{
			if( _mxmlColors )
			{
				init( _mxmlColors, _mxmlWeights );
				_mxmlColors = null;
				_mxmlWeights = null;
			}
		}
		
		private function init( colors:Array = null, weights:Array = null ):void
		{
			_colors.clear();
			var len:int = colors.length;
			var i:int;
			if( weights != null && weights.length == len )
			{
				for( i = 0; i < len; ++i )
				{
					_colors.add( colors[i], weights[i] );
				}
			}
			else
			{
				for( i = 0; i < len; ++i )
				{
					_colors.add( colors[i], 1 );
				}
			}
		}
		
		public function addColor( color:uint, weight:Number = 1 ):void
		{
			_colors.add( color, weight );
		}
		
		public function removeColor( color:uint ):void
		{
			_colors.remove( color );
		}
		
		public function set colors( value:Array ):void
		{
			if( value.length == 1 && value[0] is String )
			{
				_mxmlColors = String( value[0] ).split( "," );
			}
			else
			{
				_mxmlColors = value;
			}
			checkStartValues();
		}
		
		public function set weights( value:Array ):void
		{
			if( value.length == 1 && value[0] is String )
			{
				_mxmlWeights = String( value[0] ).split( "," );
			}
			else
			{
				_mxmlWeights = value;
			}
			checkStartValues();
		}
		
		private function checkStartValues():void
		{
			if( _mxmlColors && _mxmlWeights )
			{
				init( _mxmlColors, _mxmlWeights );
				_mxmlColors = null;
				_mxmlWeights = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			particle.color = _colors.getRandomValue();
		}
	}
}
