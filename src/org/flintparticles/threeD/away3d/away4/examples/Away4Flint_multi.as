package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Sprite3D;
	import away3d.materials.BitmapMaterial;
	import away3d.primitives.Cube;
	import away3d.primitives.Sphere;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.initializers.AlphaInit;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.threeD.actions.Accelerate;
	import org.flintparticles.threeD.actions.Move;
	import org.flintparticles.threeD.actions.RandomDrift;
	import org.flintparticles.threeD.actions.Rotate;
	import org.flintparticles.threeD.away3d.away4.Away3D4Renderer;
	import org.flintparticles.threeD.away3d.away4.initializers.A3D4ApplyMaterial;
	import org.flintparticles.threeD.away3d.away4.initializers.A3D4ObjectClass;
	import org.flintparticles.threeD.away3d.away4.initializers.A3D4ObjectClasses;
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.initializers.Position;
	import org.flintparticles.threeD.initializers.RotateVelocity;
	import org.flintparticles.threeD.initializers.Velocity;
	import org.flintparticles.threeD.zones.SphereZone;

	[SWF(backgroundColor="#677999", frameRate="30", quality="LOW", width="800", height="600")]
	public class Away4Flint_multi extends Sprite
	{
		private var _view:View3D;
		private var _emiter:Emitter3D;
		private var _renderer:Away3D4Renderer;
		private var _particleContainer:ObjectContainer3D=new ObjectContainer3D();
		public function Away4Flint_multi()
		{
			init();
			initFlint();
		}
		private function init():void{
			_view=new View3D();
			_view.width=800;
			_view.height=600;
			this.addChild(_view);
			_view.scene.addChild(_particleContainer);
			_particleContainer.z=-400;
			this.addChild(new AwayStats(_view));
			addEventListener(Event.ENTER_FRAME,onEnterFrame);
		}
		private function onEnterFrame(e:Event):void{
			_view.render();
		}
		private function initFlint():void{
			_emiter=new Emitter3D();
			_renderer=new Away3D4Renderer(_particleContainer);
			_emiter.counter=new Steady(10);
			_renderer.addEmitter(_emiter);
			var awayParticle:A3D4ObjectClass=new A3D4ObjectClass(Sphere,{radius:10,material:null,segmentsH:6,segmentsW:6});
			
			var awayParticle1:A3D4ObjectClass=new A3D4ObjectClass(Sprite3D,{width:20,height:20});
			var awayParticle2:A3D4ObjectClass=new A3D4ObjectClass(Cube,{width:40,height:40,depth:40});
			var diffObject:A3D4ObjectClasses=new A3D4ObjectClasses([Cube,Sphere,Sprite3D],[{width:40,height:40,depth:40},{radius:10,material:null,segmentsH:6,segmentsW:6},{width:20,height:20}]);
          
			
			var appMat:A3D4ApplyMaterial=new A3D4ApplyMaterial(BitmapMaterial,bitmapMat.clone(),true,true);
			
			_emiter.addInitializer(diffObject);
			_emiter.addInitializer(appMat);
			_emiter.addInitializer(new AlphaInit(0,1)	);
		    _emiter.addInitializer(new RotateVelocity(new Vector3D(1,1,1),5,20));
			_emiter.addInitializer(new Position(new SphereZone(new Vector3D(0,0,900),100,20)));
			_emiter.addInitializer(new Velocity(new SphereZone(new Vector3D(0,0,0),500,50)));
			_emiter.addInitializer(new Lifetime(1,2));
		//	_emiter.addAction(new ColorChange(0x330022ff,0x992211ff));
			_emiter.addAction(new Move);
			_emiter.addAction(new Age());
			_emiter.addAction(new Rotate());
			_emiter.addAction(new Accelerate(new Vector3D(7,7,7)));
			_emiter.addAction(new RandomDrift(1500,1500,1500));
			_emiter.start();	
			
		}
		private function get bitmapMat():BitmapData{
			var bdata:BitmapData=new BitmapData(128,128);
			bdata.perlinNoise(13,14,12,12234,true,true);
			return bdata;
		}
	}
}