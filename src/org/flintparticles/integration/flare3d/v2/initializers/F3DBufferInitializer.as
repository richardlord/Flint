package org.flintparticles.integration.flare3d.v2.initializers
{

	
	import flare.core.Mesh3D;
	import flare.materials.Shader3D;
	
	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.events.ParticleEvent;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;
	import org.flintparticles.common.utils.construct;
	import org.flintparticles.integration.flare3d.v2.flare3dutils.FlareMatConstructor;
	
	public class F3DBufferInitializer extends InitializerBase
	{
		private var _imageClass:Class;
		private var _parameters:Array;
		private var _buffer:Vector.<Mesh3D>
		private var _bufferLength:uint=0;
		/**
		 * imageClass -is a regular Away3D object Class 
		 * bufferLength- is the number of the image instance we want to hold in the buffer,
		 * make sure that you take into account the life length of th particle when calculating 
		 * buffer length.So that if your particles should live between 1 and 3 seconds and you spawn 
		 * steady 300 per second the buffer should be around 900 objects in total.
		 * parameters-are the rest of image Class constructor arguments
		 * */
		
		private var _filters:Array;
		private var _uniqueMats:Boolean=false;
		public function F3DBufferInitializer(imageClass:Class,bufferLength:uint,uniqueMats:Boolean=false,...parameters)
		{
			_buffer=new Vector.<Mesh3D>();
			//TODO: implement function
			_imageClass=imageClass;
			_parameters=parameters;
			_bufferLength=bufferLength;
		_uniqueMats=uniqueMats;
			init();
			
		}
		private function init():void{
			
			var obj3d:Mesh3D=construct(_imageClass,_parameters[0]);//new _imageClass(null,0,0);
		
			
			initBuffer(obj3d);
			
			
		}
		private function initBuffer(obj3d:Mesh3D):void{
			for(var i:uint=0;i<_bufferLength;++i){
				var clone:Mesh3D=obj3d.clone() as Mesh3D;
				if(_uniqueMats){
					var material:Shader3D=FlareMatConstructor.flareMaterialConstruct(Shader3D, _parameters[1] );
					material.build();
					clone.setMaterial(material,true);
				}
			
				_buffer.push(clone);
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
			for (var i:uint=0;i<_buffer.length;++i){
				//////clean up of the buffer
			  ////	_buffer[i].dispose(); still not implemented
				_buffer[i]=null;
				
			}
			_buffer=null;
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