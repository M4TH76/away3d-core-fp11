﻿package away3d.primitives{	import away3d.arcane;	import away3d.core.base.SubGeometry;	import away3d.materials.MaterialBase;	use namespace arcane;	/**	 * A Plane primitive mesh.	 */	public class Plane extends PrimitiveBase	{		private var _segmentsW : uint;		private var _segmentsH : uint;		private var _yUp : Boolean;		private var _width : Number;		private var _height : Number;		/**		 * Creates a new Plane object.		 * @param material The material with which to render the object.		 * @param width The width of the plane.		 * @param height The height of the plane.		 * @param segmentsW The number of segments that make up the plane along the X-axis. Defaults to 1.		 * @param segmentsH The number of segments that make up the plane along the Y or Z-axis. Defaults to 1.		 * @param yUp Defines whether or not the plane should be upright (on the XY plane) or lay flat (on the XZ plane).		 */		public function Plane(material : MaterialBase = null, width : Number = 100, height : Number = 100, segmentsW : uint = 1, segmentsH : uint = 1, yUp : Boolean = true)		{			super(material);						_segmentsW = segmentsW;			_segmentsH = segmentsH;			_yUp = yUp;			_width = width;			_height = height;		}		/**		 * The number of segments that make up the plane along the X-axis. Defaults to 1.		 */		public function get segmentsW() : uint		{			return _segmentsW;		}		public function set segmentsW(value : uint) : void		{			_segmentsW = value;			invalidateGeometry();			invalidateUVs();		}		/**		 * The number of segments that make up the plane along the Y or Z-axis, depending on whether yUp is true or		 * false, respectively. Defaults to 1.		 */		public function get segmentsH() : uint		{			return _segmentsH;		}		public function set segmentsH(value : uint) : void		{			_segmentsH = value;			invalidateGeometry();			invalidateUVs();		}		/**		 * Defines whether or not the plane should be upright (on the XY plane) or lay flat (on the XZ plane).		 */		public function get yUp() : Boolean		{			return _yUp;		}		public function set yUp(value : Boolean) : void		{			_yUp = value;			invalidateGeometry();		}		/**		 * The width of the plane.		 */		public function get width() : Number		{			return _width;		}		public function set width(value : Number) : void		{			_width = value;			invalidateGeometry();		}		/**		 * The height of the plane.		 */		public function get height() : Number		{			return _height;		}		public function set height(value : Number) : void		{			_height = value;			invalidateGeometry();		}		/**		 * @inheritDoc		 */		protected override function buildGeometry(target : SubGeometry) : void		{			var vertices : Vector.<Number>;			var normals : Vector.<Number>;			var tangents : Vector.<Number>;			var indices : Vector.<uint>;			var x : Number, y : Number;			var numInds : uint;			var base : uint;			var tw : uint = _segmentsW+1;			var numVerts : uint = (_segmentsH + 1) * tw;			if (numVerts == target.numVertices) {				vertices = target.vertexData;				normals = target.vertexNormalData;				tangents = target.vertexTangentData;				indices = target.indexData;			}			else {				vertices = new Vector.<Number>(numVerts * 3, true);				normals = new Vector.<Number>(numVerts * 3, true);				tangents = new Vector.<Number>(numVerts * 3, true);				indices = new Vector.<uint>(_segmentsH * _segmentsW * 6, true);			}			numVerts = 0;			for (var yi : uint = 0; yi <= _segmentsH; ++yi) {				for (var xi : uint = 0; xi <= _segmentsW; ++xi) {					x = (xi/_segmentsW-.5)*_width;					y = (yi/_segmentsH-.5)*_height;					vertices[numVerts] = x;					normals[numVerts] = 0;					tangents[numVerts++] = 1;					if (_yUp) {						vertices[numVerts] = 0;						normals[numVerts] = 1;						tangents[numVerts++] = 0;						vertices[numVerts] = y;						normals[numVerts] = 0;						tangents[numVerts++] = 0;					}					else {						vertices[numVerts] = y;						normals[numVerts] = 0;						tangents[numVerts++] = 0;						vertices[numVerts] = 0;						normals[numVerts] = -1;						tangents[numVerts++] = 0;					}					if (xi != _segmentsW && yi != _segmentsH) {						base = xi + yi*tw;						indices[numInds++] = base;						indices[numInds++] = base + tw;						indices[numInds++] = base + tw + 1;						indices[numInds++] = base;						indices[numInds++] = base + tw + 1;						indices[numInds++] = base + 1;					}				}			}			target.updateVertexData(vertices);			target.updateVertexNormalData(normals);			target.updateVertexTangentData(tangents);			target.updateIndexData(indices);		}		/**		 * @inheritDoc		 */		override protected function buildUVs(target : SubGeometry) : void		{			var uvs : Vector.<Number> = new Vector.<Number>();			var numUvs : uint = (_segmentsH + 1) * (_segmentsW + 1) * 2;			if (target.UVData && numUvs == target.UVData.length)				uvs = target.UVData;			else				uvs = new Vector.<Number>(numUvs, true);			numUvs = 0;			for (var yi : uint = 0; yi <= _segmentsH; ++yi) {				for (var xi : uint = 0; xi <= _segmentsW; ++xi) {					uvs[numUvs++] = xi/_segmentsW;					uvs[numUvs++] = 1 - yi/_segmentsH;				}			}			target.updateUVData(uvs);		}	}}