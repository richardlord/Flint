/**
 * By MichaelIV
 * This utility is needed to clone Flare3D filters for materials.The problem:Currently Flare3D implements clone() for materials,but
 * this clone is not deep and the filters that contains the given material are not cloned.Also Filters don't have clone() method.
 * The solution:cloning of each filter for every material.Falre3D allows to stack multiple filters in one material.Thefore we should 
 * loop through filters classes array passed by the user ,instantiate new filters and pass params to them.
 * In the high level (the user ) the constructor of F3DApplyMaterialClass MUST receive a third parameter (filters array parameter) in the following form:
 * 
 * [{filter:ColorFilter,params:[0xFFFFFF,0.2,"add"]}]  -which is array of objects.The object MUST have one property called filter that accepts a filter class
 * and the second property called params which contains an array of the constructor parameters for a given filter.
 * Several filters can be grouped in one stack:
 * 
 * var filters:Array=new Array(
 * {filter:ColorFilter,params:[0xFFFFFF,0.2,"add"]},
 * {filter:ColorFilter,params:[0x00FFFF,1,"normal"]},
 * {filter:FogFilter,params:[0x00FFFF,1,300,"normal","perVertex"]}
 * );
 * 
 * 
 * 
 */ 
package org.flintparticles.integration.flare3d.v2.flare3dutils
{
	

	
	public class FlareMatConstructor {
		private static function assembleFilters(params:Array):Array{
			var filters:Array=[];
			for(var i:uint=0;i<params.length;++i){
				var FilterClass:Class=params[i].filter;
				var filterParams:Array=params[i].params;
				switch(filterParams.length){
					case 0:
						filters.push(new FilterClass());
						break;
					case 1:
						filters.push(new FilterClass(filterParams[0]));
						break;
					case 2:
						filters.push(new FilterClass(filterParams[0],filterParams[1]));
						break;
					case 3:
						filters.push(new FilterClass(filterParams[0],filterParams[1],filterParams[2]));
						break;
					case 4:
						filters.push(new FilterClass(filterParams[0],filterParams[1],filterParams[2],filterParams[3]));
						break;
					case 5:
						filters.push(new FilterClass(filterParams[0],filterParams[1],filterParams[2],filterParams[3],filterParams[4]));
						break;
					case 6:
						filters.push(new FilterClass(filterParams[0],filterParams[1],filterParams[2],filterParams[3],filterParams[4],filterParams[5]));
						break;
					case 7:
						filters.push(new FilterClass(filterParams[0],filterParams[1],filterParams[2],filterParams[3],filterParams[4],filterParams[5],filterParams[6]));
						break;
					case 8:
						filters.push(new FilterClass(filterParams[0],filterParams[1],filterParams[2],filterParams[3],filterParams[4],filterParams[5],filterParams[6],filterParams[7]));
						break;
					case 9:
						filters.push(new FilterClass(filterParams[0],filterParams[1],filterParams[2],filterParams[3],filterParams[4],filterParams[5],filterParams[6],filterParams[7],filterParams[8]));
						break;
				}
				
			}
			return filters;
		}
		public static function flareMaterialConstruct( type:Class, parameters:Array ):*
		{
			switch( parameters.length )
			{
				
				case 0:
				return new type();
				case 1:
				return new type( parameters[0] );
				case 2:
				
				return new type( parameters[0], assembleFilters(parameters[1]) );
				case 3:
				return new type( parameters[0],assembleFilters(parameters[1]), parameters[2] );
				case 4:
				return new type( parameters[0],assembleFilters(parameters[1]), parameters[2], parameters[3] );
				case 5:
				return new type( parameters[0],assembleFilters(parameters[1]), parameters[2], parameters[3], parameters[4] );
				case 6:
				return new type( parameters[0], assembleFilters(parameters[1]), parameters[2], parameters[3], parameters[4], parameters[5] );
				case 7:
				return new type( parameters[0],assembleFilters(parameters[1]), parameters[2], parameters[3], parameters[4], parameters[5], parameters[6] );
				case 8:
				return new type( parameters[0], assembleFilters(parameters[1]), parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7] );
				case 9:
				return new type( parameters[0], assembleFilters(parameters[1]), parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8] );
				case 10:
				return new type( parameters[0], assembleFilters(parameters[1]), parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9] );
				default:
				return null;
			}
			
			
		}
		
	}
}
