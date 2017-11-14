# kScenes
Tool for simplifying Scene transitions in Kha, now support navigation and masks.
dependancy 'tweenx', 'justTriangles'

You can use it like this:
```haxe
  function loadAll(){
  
    // create a sceneDirector
    sceneDirector = new SceneDirector();
    sceneDirector.enableKeyControl(); // allows you to use <- keys -> to navigate scenes( fades between )

    // add Scenes
    var home = new Scene( 'home' );
    var img = new ImageWrapper( Assets.images.MyImage, 100, 100 ); // support for text with variable letter spacing.
    img.offSide = Compass.NORTH_SMALL; // Animates in from slightly to the north and out same way.
    home.addImage( img );
    // add other scenes here
    // ...
    sceneDirector.add( home );
    home.show();
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

You can install it 
```haxelib git kScenes https://github.com/nanjizal/kScenes.git```

Then to your **khafile.js** just add
``` js
project.addLibrary('tweenx'); 
project.addLibrary('kScenes');
project.addLibrary('justTriangles');// for ImageShaderWrapper.
project.addShaders('src/Shaders/**');
```

## For drawing and masks, gradients and custom shaders.
now has ImageShaderWrapper work in progress but powerful as you can animate it same as other WrapperImages

Using this technique to add shader generated Image content over the background image.

<img width="325" alt="curve" src="https://user-images.githubusercontent.com/20134338/32640503-db519af0-c5c0-11e7-8f54-1ad87e4374ec.png">
<img width="328" alt="maskcurve" src="https://user-images.githubusercontent.com/20134338/32640501-d83bed66-c5c0-11e7-898c-940f6ae2d026.png">
<img width="203" alt="custom" src="https://user-images.githubusercontent.com/20134338/32640752-0ff80e14-c5c2-11e7-8120-66e7b3c80fee.png">


This is the test scene I used, have added a Shaders folder you need to drag into your source folder, and need to add imports and quadTest_d svg string from justTriangles project.

``` haxe
// minimal scene.
	public function test(){
		var scene = new Scene( 'test' );
		scene.addImage( new ImageWrapper( Assets.images.westCountryHome ));
		var img: ImageShaderWrapper;
		var testShaders: ShaderKind = ShaderKind.TEXTURED; // use to set the test
		switch( testShaders ){
			case NONE:
				//simple gradient
				img = ImageShaderWrapper.fromDimensions( 500, 500 );
				img.setShaders( kha.Shaders.quad_frag, kha.Shaders.quad_vert, true, ShaderKind.NONE, false );
				img.justBackground();
			case COLOURED:
				img = ImageShaderWrapper.fromDimensions( 500, 500 );
				drawQuadTest();	
				img.setShaders( kha.Shaders.color_frag, kha.Shaders.color_vert, false, ShaderKind.COLOURED, true );
				img.fromTriangles( 1, 1, 0.25, Triangle.triangles, rainbow );
			case GRADIENT:
				var gradImg = ImageShaderWrapper.fromDimensions( 400, 400 );
				gradientTest();
				gradImg.setShaders( kha.Shaders.color_frag, kha.Shaders.color_vert, false, ShaderKind.GRADIENT, true );
				gradImg.fromTriangles( 0, 0, 1, Triangle.triangles, rainbow );
				// use gradient as texture for shape
				img = new ImageShaderWrapper( gradImg.image, 100, 100 );
				img.offSide = WEST;
				drawQuadTest();
				img.setShaders( kha.Shaders.texture_frag, kha.Shaders.texture_vert, false, ShaderKind.TEXTURED, true );
				img.fromTriangles( 1, 1, 0.25, Triangle.triangles, rainbow );
			case TEXTURED:
				img = new ImageShaderWrapper( Assets.images.pubStairs, 70, 70 );
				img.offSide = WEST; // this will animate it in from the west when going into Scene.
				drawQuadTest();
				img.setShaders( kha.Shaders.texture_frag, kha.Shaders.texture_vert, false, ShaderKind.TEXTURED, true );
				img.fromTriangles( 1, 1, 0.25, Triangle.triangles, rainbow );
		}
		scene.addImage( img );
		add( scene );
		return scene;
	}
	function gradientTest(){
		Draw.drawTri = Triangle.drawTri;
		Triangle.triangles = new Array<Triangle>();
		TriangleGradient.multiGradient( 0, true, 0, -1, 1, 2, [ 1,2,3,4,5,6,7], 0., 0., 0. );
	}
	function drawQuadTest(){
		Draw.drawTri = Triangle.drawTri;
		Triangle.triangles = new Array<Triangle>();
		var thick = 30;
		var ctx = new PathContext( 1, 500, 0, 0 );
		ctx.setColor( 2, 2 );
		ctx.setThickness( thick*5 );
		ctx.lineType = TriangleJoinCurve; // - default
		//var pathTrace = new PathContextTrace();
		var p = new SvgPath( ctx );
		for( dy in 0...10 ){
			p.parse( quadtest_d, 1, 1 + dy * 250, 3, 3 ); // quadtest_d   is svg string see justTriangles examples.
		}
		ctx.render( thick, false );
	}
```
