package org.flintparticles.integration.flare3d.initializers
{
	import flare.core.Pivot3D;
	import flare.materials.Material3D;

	import org.flintparticles.common.emitters.Emitter;
	import org.flintparticles.common.initializers.InitializerBase;
	import org.flintparticles.common.particles.Particle;

	/**
	 * @author Richard
	 */
	public class F3DCloneMaterial extends InitializerBase
	{
		private var _material : Material3D;

		public function F3DCloneMaterial( material : Material3D )
		{
			_material = material;
			_priority = -10;
		}
		
		public function get material() : Material3D
		{
			return _material;
		}
		
		public function set material( value:Material3D ):void
		{
			_material = material;
		}
		
		override public function initialize( emitter:Emitter, particle:Particle ) : void
		{
			if( particle.image && particle.image is Pivot3D )
			{
				Pivot3D( particle.image ).setMaterial( _material.clone() );
			}
		}
	}
}
