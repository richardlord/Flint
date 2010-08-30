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

	[DefaultProperty("initializers")]
	
	/**
	 * The ChooseInitializer initializer selects one of multiple initializers, using 
	 * optional weighting values to produce an uneven distribution for the choice, 
	 * and applies it to the particle. This is often used with the InitializerGroup 
	 * initializer to apply a randomly chosen group of initializers to the particle.
	 * 
	 * @see org.flintparticles.common.initializers.InitializerGroup
	 */

	public class ChooseInitializer extends InitializerBase
	{
		private var _initializers:WeightedArray;
		private var _mxmlInitializers:Array;
		private var _mxmlWeights:Array;
		
		/**
		 * The constructor creates a ChooseInitializer initializer for use by 
		 * an emitter. To add a ChooseInitializer to 
		 * an emitter, use the emitter's addInitializer method.
		 * 
		 * @param colors An array containing the Initializers to use.
		 * @param weights The weighting to apply to each initializer. If no weighting
		 * values are passed, the initializers are all assigned a weighting of 1.
		 * 
		 * @see org.flintparticles.common.emitters.Emitter#addInitializer()
		 */
		public function ChooseInitializer( initializers:Array = null, weights:Array = null )
		{
			_initializers = new WeightedArray();
			if( initializers == null )
			{
				return;
			}
			init( initializers, weights );
		}
		
		override public function addedToEmitter( emitter:Emitter ):void
		{
			if( _mxmlInitializers )
			{
				init( _mxmlInitializers, _mxmlWeights );
				_mxmlInitializers = null;
				_mxmlWeights = null;
			}
		}
		
		private function init( initializers:Array = null, weights:Array = null ):void
		{
			_initializers.clear();
			var len:int = initializers.length;
			var i:int;
			if( weights != null && weights.length == len )
			{
				for( i = 0; i < len; ++i )
				{
					_initializers.add( initializers[i], weights[i] );
				}
			}
			else
			{
				for( i = 0; i < len; ++i )
				{
					_initializers.add( initializers[i], 1 );
				}
			}
		}
		
		public function addInitializer( initializer:Initializer, weight:Number = 1 ):void
		{
			_initializers.add( initializer, weight );
		}
		
		public function removeInitializer( initializer:Initializer ):void
		{
			_initializers.remove( initializer );
		}
		
		public function set initializers( value:Array ):void
		{
			_mxmlInitializers = value;
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
			if( _mxmlInitializers && _mxmlWeights )
			{
				init( _mxmlInitializers, _mxmlWeights );
				_mxmlInitializers = null;
				_mxmlWeights = null;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function initialize( emitter:Emitter, particle:Particle ):void
		{
			var initializer:Initializer = _initializers.getRandomValue();
			initializer.initialize( emitter, particle );
		}
	}
}
