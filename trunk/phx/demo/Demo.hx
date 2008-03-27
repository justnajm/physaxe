package phx.demo;

class Demo {

	var world : phx.World;
	var floor : Float;
	var size : phx.Vector;
	public var steps : Int;

	public function new() {
		size = new phx.Vector(600,600);
		floor = 580;
		steps = 3;
	}

	public function start( world ) {
		this.world = world;
		init();
	}

	public function init() {
	}

	public function step( dt :Float) {
	}

	public function addRectangle(x,y,w,h,?mat) {
		return addBody(x,y,phx.Shape.makeBox(w,h,null,null,mat));
	}

	public function addBody( x, y, shape, ?props ) {
		var b = new phx.Body(x,y);
		b.addShape(shape);
		if( props != null ) b.properties = props;
		world.addBody(b);
		return b;
	}

	public function createWord( str : String, xp, yp, size, spacing, ?mat ) : Void {
		for( i in 0...str.length ) {
			var letter = str.charCodeAt(i);
			if( letter == 32 ) {
				xp += size;
				continue;
			}
			var datas = FontArray.lowerCase[letter - 97];
			if( datas == null )
				continue;
			var xmax = 0;
			for( y in 0...FontArray.HEIGHT ) {
				for( x in 0...FontArray.WIDTH ) {
					if( datas[ x + y * FontArray.WIDTH] == 1 ) {
						if( x > xmax ) xmax = x;
						addRectangle( xp + x * (size + spacing), yp + y * (size + spacing), size, size, mat );
					}
				}
			}
			xp += (xmax + 1) * (size + spacing) + size;
		}
	}

	public function createConvexPoly( nverts : Int, radius : Float, rotation : Float, ?mat ) {
		var vl = new Array();
		for( i in 0...nverts ) {
			var angle = ( -2 * Math.PI * i ) / nverts;
			angle += rotation;
			vl.push( new phx.Vector(radius * Math.cos(angle), radius * Math.sin(angle)) );
		}
		return new phx.Polygon(vl,new phx.Vector(0,0),mat);
	}

	public function createPoly( x, y, a, shape : phx.Polygon, ?props ) {
		var b = new phx.Body(x,y);
		var vl = new Array();
		var v = shape.verts;
		while( v != null ) {
			vl.push(v);
			v = v.next;
		}
		b.addShape( new phx.Polygon(vl,new phx.Vector(0,0),shape.material) );
		b.setAngle(a);
		if( props != null )
			b.properties = props;
		world.addBody(b);
		return b;
	}

	public function createFloor( ?mat ) {
		var s = phx.Shape.makeBox(600,40,0,floor,mat);
		world.addStaticShape(s);
	}

	public function rand( min : Float, max : Float ) {
		return Math.round(Math.random() * (max - min + 1)) + min;
	}

}
