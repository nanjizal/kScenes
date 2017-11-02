package kScenes;
import kha.graphics2.Graphics;
import kha.input.Keyboard;
import kha.input.Mouse;
import kha.input.KeyCode;
class SceneDirector{
    var sceneCount: Int = 0;
    var sceneTotal: Int;
    var scenes: Array<Scene> = new Array<Scene>();
    public function new(){

    }
    public function enableKeyControl(){
        Keyboard.get().notify( keyDown, keyUp );
    }
    function keyDown(keyCode:Int):Void{
        switch( keyCode ){
            case KeyCode.Left:  
                sceneBack();
            case KeyCode.Right: 
                sceneForward();
            case KeyCode.Up:    
                
            case KeyCode.Down:  
                
            default: 
                
        }
    }
    function keyUp(keyCode:Int  ):Void{ 
        switch( keyCode ){
            case KeyCode.Left:  
                
            case KeyCode.Right: 
                
            case KeyCode.Up:    
                
            case KeyCode.Down:  
                
            default: 
                
        }
    }
    public function empty(){
        var scene = new Scene( 'Start' );
        add( scene );
        return scene;
    }
    public function add( scene: Scene ){
        scenes[ scenes.length ] = scene;
        sceneTotal++;
    }
    public function sceneForward(){
        changeScene( sceneCount + 1 );
    }
    public function sceneBack(){
        changeScene( sceneCount - 1 );
    }
    public function changeScene( i: Int ){
        if( i < 0 ){
            i = 0;
            if( i == sceneCount ) return;
        } 
        if( i > sceneTotal - 1 ){
            i = sceneTotal - 1;
            if( i == ( sceneTotal - 1) ) return;
        }
        if( i == sceneCount ) return;
        scenes[ i ].show( 0.15 );
        //createLinkButton( i );
        scenes[sceneCount].hide( 0. );
        sceneCount = i;
    }
    public function render( g2: Graphics ){
        for( scene in scenes ){
            scene.render( g2 );
        }
    }
}