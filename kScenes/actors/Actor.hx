package kScenes.actors;
import tweenx909.TweenX;
import tweenx909.EaseX;
import kha.math.*;
import kha.math.FastMatrix3;
import kha.FastFloat;
import kScenes.interaction.Compass;
class Actor {
    public var windowWid: Float = 1024;
    public var windowHi:  Float = 768;
    public var alpha:     Float = 0.;
    public var x:         Float = 0.;
    public var y:         Float = 0.;
    public var ex:        Float = 0.;
    public var ey:        Float = 0.;
    public var id:        Int;
    public var width:     Float;
    public var height:    Float;
    public var small:     Float = 40.;
    public var offSide:   Compass = CENTRE;
    public var hitable:   Bool = false;
    public var matrix:    FastMatrix3;
    public var hasMatrix: Bool = false;
    public var hideSpeed: Float = .55;
    public var showSpeed: Float = .75;
    public var moveSpeed: Float = .75;
    public function new(  width_:   Float,      height_: Float
                        , ?x_:      Float = 0., ?y_:     Float = 0. ){
        width = width_;
        height = height_;
        ex = x_;
        ey = y_;
        matrix = FastMatrix3.identity();
        off();
    }
    function off(){
        switch( offSide ){
            case NORTH:
                y = -1.5*height;
                x = ex;
            case WEST:
                x = -1.5*width; 
                y = ey;
            case SOUTH:
                y = windowHi + 1.5*height;
                x = ex;
            case EAST:
                x = windowWid + 1.5*width;
                y = ey;
            case NORTH_SMALL:
                y = ey - small;
                x = ex;
            case WEST_SMALL:
                x = ex - small; 
                y = ey;
            case SOUTH_SMALL:
                y = ey + small;
                x = ex;
            case EAST_SMALL:
                x = ex + small;
                y = ey;
            case NORTH_WEST_SMALL:
                x = ex - small;
                y = ey - small;
            case SOUTH_WEST_SMALL:
                x = ex - small; 
                y = ey + small;
            case SOUTH_EAST_SMALL:
                x = ex + small;
                y = ey + small;
            case NORTH_EAST_SMALL:
                x = ex + small;
                y = ey - small;
            case CENTRE:
                x = ex;
                y = ey;
        }
    }
    function tweenOff( delay: Float){
        switch( offSide ){
            case NORTH:
                moveTo( ex, -1.5*height, delay  );
            case WEST:
                moveTo( -1.5*width, ey, delay );
            case SOUTH:
                moveTo( ex, 768 + 1.5*height, delay );
            case EAST:
                moveTo( 1024 + 1.5*width, ey, delay );
            case NORTH_SMALL:
                moveTo( ex, ey - small, delay  );
            case WEST_SMALL:
                moveTo( ex - small, ey, delay );
            case SOUTH_SMALL:
                moveTo( ex, ey + small, delay );
            case EAST_SMALL:
                moveTo( ex + small, ey, delay );
            case NORTH_WEST_SMALL:
                moveTo( ex - small, ey - small, delay  );
            case SOUTH_WEST_SMALL:
                moveTo( ex - small, ey + small, delay );
            case SOUTH_EAST_SMALL:
                moveTo( ex + small, ey + small, delay );
            case NORTH_EAST_SMALL:
                moveTo( ex + small, ey - small, delay );
            case CENTRE:
            
        }
    }
    public function hitTest( x_: Float, y_: Float ){
        return ( x_ > x && y_ > y && x_ < ( x + width ) && y_ < ( y + height ) );
    }
    public function show( delay: Float ){
        TweenX.to( this, { alpha :1.0 }).delay( delay ).time( showSpeed ).ease( EaseX.quadIn ).ease( EaseX.quadIn );
        off();
        moveTo( ex, ey, delay );
    }
    public function hide( delay: Float ){
        TweenX.to( this, { alpha :0.0 }).delay( delay ).time( hideSpeed ).ease( EaseX.quadOut );
        tweenOff( delay );
    }
    public function moveTo( x_: Float, y_: Float, delay: Float ){
        TweenX.to( this, { x: x_, y: y_ }).delay( delay ).time( moveSpeed ).ease( EaseX.quadIn ).ease( EaseX.quadIn );
    }
}
