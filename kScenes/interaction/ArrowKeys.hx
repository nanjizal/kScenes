package kScenes.interaction;
import kha.input.Keyboard;
import kha.input.KeyCode;
class ArrowKeys{
    public var downLeft:    Void->Void;
    public var downRight:   Void->Void;
    public var downUp:      Void->Void;
    public var downDown:    Void->Void;
    public var upLeft:      Void->Void;
    public var upRight:     Void->Void;
    public var upUp:        Void->Void;
    public var upDown:      Void->Void;
    public var enable:      Bool = true;
    public function new(){
        Keyboard.get().notify( keyDown, keyUp );
    }
    function keyDown( keyCode: Int ):Void{
        if( !enable ) return;
        switch( keyCode ){
            case KeyCode.Left:  
                if( downLeft != null )  downLeft();
            case KeyCode.Right: 
                if( downRight != null ) downRight();
            case KeyCode.Up:    
                if( downUp != null )    downUp();
            case KeyCode.Down:  
                if( downDown != null )  downDown();
            default: 
                
        }
    }
    function keyUp( keyCode: Int  ):Void{ 
        if( !enable ) return;
        switch( keyCode ){
            case KeyCode.Left:  
                if( upLeft != null )    upLeft();
            case KeyCode.Right: 
                if( upRight != null )   upRight();
            case KeyCode.Up:    
                if( upUp != null )      upUp();
            case KeyCode.Down:  
                if( upDown != null )    upDown();
            default: 
                
        }
    }
}