package kScenes.story;
import kha.graphics2.Graphics;
import kha.Framebuffer;
import kha.Canvas;
import kScenes.interaction.*;
class Director{
    var sceneCount: Int = 0;
    var sceneTotal: Int;
    var boolItem = false;
    var scenes: Array<Scene> = new Array<Scene>();
    public var buttonPress: Scene->Int->Void;
    public var buttonOver:  Scene->Int->Void;
    public function new(){
        
    }
    public function enableKeyControl(){
        var arrowKeys = new ArrowKeys();
        arrowKeys.downLeft  = sceneBack;
        arrowKeys.downRight = sceneForward;
    }
    public function enableMouseInteraction(){
        var mouseHit    = new MouseHit();
        mouseHit.down   = mouseDown;
        mouseHit.change = moveOver;
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
    inline function mouseDown( x: Int, y: Int ){
        var current = currentScene();
        var id = current.checkHit( x, y );
        if( id != -1 && buttonPress != null ) buttonPress( current, id );
    }
    inline function moveOver( x: Int, y: Int ){
        var current = currentScene();
        var id = current.checkHit( x, y );
        if( id != -1 && buttonOver != null ) buttonOver( current, id );
    }
    public inline function currentScene(): Scene {
        return scenes[ sceneCount ];
    }
    public function gotoSceneByName( str: String ){
        var target = -1;
        for( i in 0...scenes.length ){
            if( scenes[ i ].sceneName == str ) {
                target = i; 
                break;
            }
        }
        if( target != -1 ) changeScene( target );
    }
    public function gotoScene( scene: Scene ){
        var target = -1;
        for( i in 0...scenes.length ){
            if( scenes[ i ] == scene ) {
                target = i; 
                break;
            }
        }
        if( target != -1 ) changeScene( target );
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
        currentScene().hide( 0. );
        sceneCount = i;
    }
    public function render( canvas: Canvas ){
        for( scene in scenes ){
            scene.render( canvas );
        }
    }
}