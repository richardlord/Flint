package org.flintparticles.integration.away3d.v4.initializers
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.entities.Sprite3D;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.construct;
	
	public class BufferInitializer extends InitializerBase
	{
		private var _imageClass:Class;
		private var _parameters:Array;
		private var _buffer:Vector.<Object3D>=new Vector.<Object3D>();
		private var _bufferLength:uint=0;
		/**
		 * imageClass -is a regular Away3D object Class 
		 * bufferLength- is the number of the image instance we want to hold in the buffer,
		 * make sure that you take into account the life length of th particle when calculating 
		 * buffer length.So that if your particles should live between 1 and 3 seconds and you spawn 
		 * steady 300 per second the buffer should be around 900 objects in total.
		 * parameters-are the rest of image Class constructor arguments
		 * */
		
		
		public function BufferInitializer(imageClass:Class,bufferLength:uint, parameters:Array)
		{
			//TODO: implement function
			_imageClass=imageClass;
			_parameters=parameters;
			_bufferLength=bufferLength;
			init();
		
		}
		private function init():void{
			
			var obj3d:Object3D=construct(_imageClass,_parameters);//new _imageClass(null,0,0);
		
			
			initBuffer(obj3d);
		
			
		}
		private function initBuffer(obj3d:Object3D):void{
			for(var i:uint=0;i<_bufferLength;++i){
				_buffer.push(obj3d.clone()as Object3D);
			}
		}
		private var _firstTime:Boolean=true;
		override public function initialize( emitter:Emitter, particle:Particle):void
		{
			if(_firstTime){
				emitter.addEventListener(ParticleEvent.PARTICLE_DEAD,onParticleDead,false,0,true);
				_firstTime=false;
			}
			if(_buffer.length>0){
				particle.image=_buffer.shift();
			//	trace(particle.image);
			}
			if(_buffer.length==0){
			//	do nothing
			}
		}
		override public function removedFromEmitter(emitter:Emitter) : void{
			if(emitter.hasEventListener(ParticleEvent.PARTICLE_DEAD)){
			
				emitter.removeEventListener(ParticleEvent.PARTICLE_DEAD,onParticleDead);
			}
		}
		private function onParticleDead(e:ParticleEvent):void{
		//	e.particle.isDead=false;
		//	trace(e.particle.image);
			
			_buffer.push(e.particle.image);
		//	trace(e.particle.image);
		}
		
		////////////////getters/setters//////////////////////
		/**
		 * The class to use when creating
		 * the particles' DisplayObjects.
		 */
		public function get imageClass():Class
		{
			return _imageClass;
		}
		public function set imageClass( value:Class ):void
		{
			_imageClass = value;
		}
		
		/**
		 * The parameters to pass to the constructor
		 * for the image class.
		 */
		public function get parameters():Array
		{
			return _parameters;
		}
		public function set parameters( value:Array ):void
		{
			_parameters = value;
		}
		
	}
}