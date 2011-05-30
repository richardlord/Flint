package
{
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.AnimSprite;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import com.bit101.components.ComboBox;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	
	import org.flintparticles.common.actions.Age;
	import org.flintparticles.common.actions.ColorChange;
	import org.flintparticles.common.counters.Steady;
	import org.flintparticles.common.initializers.Lifetime;
	import org.flintparticles.threeD.Alternativa8x.ALT3DRenderer;
	import org.flintparticles.threeD.Alternativa8x.initializers.ALT3DObjectClass;
	import org.flintparticles.threeD.Alternativa8x.initializers.ALT3DObjectClasses;
	import org.flintparticles.threeD.actions.Accelerate;
	import org.flintparticles.threeD.actions.Move;
	import org.flintparticles.threeD.actions.RandomDrift;
	import org.flintparticles.threeD.actions.Rotate;
	import org.flintparticles.threeD.emitters.Emitter3D;
	import org.flintparticles.threeD.initializers.Position;
	import org.flintparticles.threeD.initializers.RotateVelocity;
	import org.flintparticles.threeD.initializers.Velocity;
	import org.flintparticles.threeD.zones.SphereZone;

	[SWF(backgroundColor="#000000", frameRate="100", width="800", height="600")]
	public class A3DFlintDemo extends Sprite
	{
		[Embed(source="explosion.png")] static private const EmbedTexture:Class;
		private var rootContainer:Object3D = new Object3D();		
		private var camera:Camera3D;
		private var stage3D:Stage3D;
		private var box:Box;
		private var _emiter:Emitter3D;
		private var _flintRender:ALT3DRenderer;
		public function A3DFlintDemo()
		{
			init();
			initGUI();
		}
		private function init():void{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			camera = new Camera3D(0.1, 10000);
			camera.view = new View(stage.stageWidth, stage.stageHeight);
			camera.view.backgroundColor=0x229944;
			addChild(camera.view);
			addChild(camera.diagram);
			

			camera.rotationX =0;
			camera.y = 0;
			camera.z = -1000;
			rootContainer.addChild(camera);
			
			// Primitive box
			// Создание примитива
		
		
			
		//	box.setMaterialToAllSurfaces(material);
			//rootContainer.addChild(box);
			
			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
		}
		private var _animSprite:AnimSprite;
		private  var materials:Vector.<Material>;
		private function initAnimSprite():void{
			var phases:BitmapData = new EmbedTexture().bitmapData;
			materials = new Vector.<Material>();
			for (var i:int = 0; i < phases.width; i += 128) {
				var bmp:BitmapData = new BitmapData(128, 128, true, 0);
				bmp.copyPixels(phases, new Rectangle(i, 0, 128, 128), new Point());
				materials.push(new TextureMaterial(new BitmapTextureResource(bmp)));
			}
		}

		private function onContextCreate(e:Event):void {
			
			// Listeners
			// Подписка на события
		
			initFlint();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
			camera.render(stage3D);
		//	trace(material.color);
			for each (var resource:Resource in rootContainer.getResources(true)) {
				resource.upload(stage3D.context3D);
			}
		}
		private var material:FillMaterial;
		private var bitMat:TextureMaterial;
		private function initFlint():void{
			_emiter=new Emitter3D();
			_flintRender=new ALT3DRenderer(rootContainer);
			_emiter.counter=new Steady(5);
			
			_flintRender.addEmitter(_emiter);
			/////different particles type////
		
			material = new FillMaterial(0xFF7700);
			bitMat=new TextureMaterial(new BitmapTextureResource(bitmapMat));
			var bb:Box=new Box(400,400,400);
			initAnimSprite();
			
				
			
			var altParticle1:ALT3DObjectClass=new ALT3DObjectClass(Sprite3D,{width:12,height:12,material: material});
			var altParticle2:ALT3DObjectClass=new ALT3DObjectClass(Box,{width:40,height:40,length:40,material:bitMat});
			var altParticle3:ALT3DObjectClass=new ALT3DObjectClass(GeoSphere,{radius:10,material:bitMat,segmentsH:3,segmentsW:3});
			var altParticle4:ALT3DObjectClass=new ALT3DObjectClass(AnimSprite,{width:100,height:100,materials:materials,loop:true,frame:0});
			var particles:ALT3DObjectClasses=new ALT3DObjectClasses([Box,GeoSphere,Sprite3D],
				    [
					{width:40,height:40,length:40,material:bitMat},
					{radius:10,material:bitMat,segmentsH:3,segmentsW:3},
					{width:12,height:12,material: material}
					]);
			
		
			
			//new ColorMaterial(
	//		var appMat:A3D4ApplyMaterial=new A3D4ApplyMaterial(ColorMaterial,0xFF0000);
			
		//	_emiter.addInitializer();
			_emiter.addInitializer(particles);
		//	_emiter.addInitializer(new AlphaInit(0,1)	);
			_emiter.addInitializer(new RotateVelocity(new Vector3D(1,1,1),5,20));
			_emiter.addInitializer(new Position(new SphereZone(new Vector3D(0,0,900),100,20)));
			_emiter.addInitializer(new Velocity(new SphereZone(new Vector3D(0,0,0),500,50)));
			_emiter.addInitializer(new Lifetime(1,3));
			_emiter.addAction(new ColorChange(0xFFFF0000,0x000000ff));
			_emiter.addAction(new Move);
			_emiter.addAction(new Age());
			_emiter.addAction(new Rotate);
			_emiter.addAction(new Accelerate(new Vector3D(7,7,7)));
			_emiter.addAction(new RandomDrift(1500,1500,1500));
			_emiter.start();	
			
		}
		private function initGUI():void{
			var particlesRate:ComboBox=new ComboBox(this,50,20,"Emit rate(per frame)",["50","100","150","200","250","300","350","400","500","600","800","1000"]);
			particlesRate.width=120;
			particlesRate.addEventListener(Event.SELECT,onComboSelect);
			
		}
		private function onComboSelect(e:Event):void{
		Steady(_emiter.counter).rate=(e.target).selectedItem;
			//trace(ComboBox(e.target).selectedItem);
		}
		private function get bitmapMat():BitmapData{
			var bdata:BitmapData=new BitmapData(128,128);
			bdata.perlinNoise(13,14,12,12234,true,true);
			return bdata;
		}
	}
}
