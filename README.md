# kScenes
Tool for simplifying Scene transitions in Kha, not yet added button support.
dependancy 'tweenx'.

```haxe
  function loadAll(){
  
    // create a sceneDirector
    sceneDirector = new SceneDirector();
    sceneDirector.enableKeyControl(); // allows you to use <- keys -> to navigate scenes 

    // add Scenes
    var scene = new Scene( 'home' );
    var img = new ImageWrapper( Assets.images.MyImage, 100, 100 ); // support for text with variable letter spacing.
    img.offSide = Compass.NORTH_SMALL; // Animates in from slightly to the north and out same way.
    scene.addImage( img );
    // and other scenes
    sceneDirector.add( scene );
    System.notifyOnRender(render);
    
  }
  
  // render scenes
  function render(framebuffer: Framebuffer): Void {
    var g2 = framebuffer.g2;
    g2.begin();
    g2.clear( Color.Black );
    sceneDirector.render( g2 );
    g2.end();
  }

```
