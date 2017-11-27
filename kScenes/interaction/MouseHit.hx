package kScenes.interaction;
import kha.input.Mouse;
class MouseHit{
    public var x: Int = -1;
    public var y: Int = -1;
    public var change:      Int->Int->Void;
    public var down:        Int->Int->Void;
    public var up:          Int->Int->Void;
    public var rightDown:   Int->Int->Void;
    public var rightUp:     Int->Int->Void;
    public var enable:      Bool = true;
    public function new(){
       Mouse.get().notify( onMouseDown, onMouseUp, onMouseMove, null, null );// wheelListener, leaveListener );
    }
    public function onMouseDown( button: Int, x: Int, y: Int ): Void {
        if( !enable ) return;
        if( button == 0 && down      != null ) down( x, y );
        if (button == 1 && rightDown != null ) rightDown( x, y );
    }
    public function onMouseUp( button: Int, x: Int, y: Int ): Void {
        //trace('mouse button UP');
        if( !enable ) return;
        if (button == 0 && up != null ) up( x, y );
        if (button == 1 && rightUp != null ) rightUp( x, y );
    }
    public function onMouseMove( x: Int, y: Int, cx: Int, cy: Int ): Void {
        if( !enable ) return;
        if( x > 0 && y > 0 && change != null ) change( x, y );
    }
    /*
    public function wheelListener( val: Int ){
        //
    }
    public function leaveListener( x: Int, y: Int ){
        //
    }*/
}