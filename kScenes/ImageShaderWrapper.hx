package kScenes;
import kha.Framebuffer;
import kha.Scheduler;
import kha.System;
import kha.Image;
import kha.Color;
import kha.math.*;
import kha.graphics4.*;
import justTriangles.Triangle;
import kha.Framebuffer;
import kha.graphics4.TextureUnit;
enum ShaderKind {
    NONE;
    COLOURED;
    TEXTURED;
}
class ImageShaderWrapper extends ImageWrapper {
    var pipe:       PipelineState;
    var vb:         VertexBuffer;
    var ib:         IndexBuffer;
    var iTime:      ConstantLocation;
    var textureID:  TextureUnit;
    var mvpID:      ConstantLocation;
    var structure:  VertexStructure;
    var mvp:        FastMatrix4;
    var model:      FastMatrix4;
    var projection: FastMatrix4;
    var view:       FastMatrix4;
    var hasShaders: Bool = false;
    var hasTime:    Bool = false;
    var shaderKind: ShaderKind;
    var hasMVP:     Bool = false;
    var vertices:   Array<Float> = [];
    var colors:     Array<Float> = [];
    var uvs:        Array<Float> = [];
    var z: Float = 1;
    public function new( image_, ?x_: Float = 0., ?y_: Float = 0. ){
        super( image_, x_, y_ );
    }
    public static function fromDimensions( width: Float, height: Float, ?x_: Float = 0., ?y_: Float = 0. ): ImageShaderWrapper {
        var image_ = Image.createRenderTarget( Math.ceil( width ), Math.ceil( height ), TextureFormat.RGBA32, DepthStencilFormat.DepthOnly, 4 );
        return new ImageShaderWrapper( image_, x_, y_ );
    }
    public function render( ?time: Float, ?framebuffer_: Framebuffer ): Void { // pass framebuffer if you want to render on main
        if( !hasShaders ) return;
        if( hasTime ) if( time != null ) time = Scheduler.time();
        var g = ( framebuffer_ == null )?image.g4: framebuffer_.g4;
        var currImage = image;
        if( shaderKind == TEXTURED ) {
            image = Image.createRenderTarget( Math.ceil( width ), Math.ceil( height ), TextureFormat.RGBA32, DepthStencilFormat.DepthOnly, 4 );
            g = image.g4;
        }
        g.begin();
        g.clear(Color.fromValue(0x00000000));
        g.setPipeline( pipe );
        if( hasTime ) g.setFloat( iTime, time );
        g.setVertexBuffer( vb );
        g.setIndexBuffer(  ib );
        if( framebuffer_ == null && hasMVP ) setModel( FastMatrix4.identity().multmat( FastMatrix4.translation( x, y, 0 ) ) );
        if( hasMVP ) g.setMatrix( mvpID, FastMatrix4.identity() );//mvp );
        if( shaderKind == TEXTURED ) {
            g.setTexture( textureID, currImage );// Set texture
            currImage = null;
        }
        g.drawIndexedVertices();
        g.end();
    }
    public function justBackground( ?time: Float = 0.0 ){
        var data    = [ -1.0, -1.0, 3.0, -1.0, -1.0, 3.0 ];
        var indices = [ 0, 1, 2 ];
        vb = new VertexBuffer( Std.int( data.length / (structure.byteSize() / 4) ), structure, Usage.StaticUsage );
        var vertices = vb.lock();
        for( i in 0...vertices.length ) vertices.set( i, data[ i ] );
        vb.unlock();
        ib = new IndexBuffer( indices.length, Usage.StaticUsage );
        var id = ib.lock();
        for( i in 0...id.length ) id[ i ] = indices[ i ];
        ib.unlock();
        if( hasShaders ) render( time );
    }
    public function fromTriangles( x_: Float, y_: Float, scale_: Float, triangles: Array<Triangle>, colorPallet: Array<Int>, ?time: Float = 0.0 ){
        for( i in 0...vertices.length )     vertices.pop();
        var tri: Triangle;
        var s = scale_;
        var offX = x_;
        var offY = y_;
        var toRGBs = toRGB;
        switch( shaderKind ){
            case COLOURED:
                for( i in 0...colors.length ) colors.pop();
                for( i in 0...triangles.length ){
                    tri = triangles[ i ];
                    vertices.push( s * tri.ax - offX );
                    vertices.push( s * tri.ay - offY );
                    vertices.push( -z );
                    vertices.push( s * tri.bx - offX );
                    vertices.push( s * tri.by - offY );
                    vertices.push( -z );
                    vertices.push( s * tri.cx - offX );
                    vertices.push( s * tri.cy - offY );
                    vertices.push( -z );
                    var rgb = toRGBs( colorPallet[ tri.colorID ] );
                    colors.push( rgb.r );
                    colors.push( rgb.g );
                    colors.push( rgb.b );
                    colors.push( rgb.r );
                    colors.push( rgb.g );
                    colors.push( rgb.b );
                    colors.push( rgb.r );
                    colors.push( rgb.g );
                    colors.push( rgb.b );
                }
            case TEXTURED:
                for( i in 0...uvs.length ) uvs.pop();
                for( i in 0...triangles.length ){
                    tri = triangles[ i ];
                    vertices.push( s * tri.ax - offX );
                    uvs.push( s * tri.ax );
                    vertices.push( s * tri.ay - offY );
                    uvs.push( s * tri.ay );
                    vertices.push( -z );
                    vertices.push( s * tri.bx - offX );
                    uvs.push( s * tri.bx );
                    vertices.push( s * tri.by - offY );
                    uvs.push( s * tri.by );
                    vertices.push( -z );
                    vertices.push( s * tri.cx - offX );
                    uvs.push( s * tri.cx );
                    vertices.push( s * tri.cy - offY );
                    uvs.push( s * tri.cy );
                    vertices.push( -z );
                } 
            case NONE:
                
        }
        createTriangles( vertices, colors, uvs, time );
    }
    public function createTriangles( vertices_: Array<Float>, ?colors_: Array<Float>, ?uvs_: Array<Float>, ?time: Float = 0.0 ){
        vertices = vertices_;
        colors   = colors_;
        uvs      = uvs_;
        if( vb == null ){
            // vertexBufferLen = Std.int(vertices.length / 3)
            // Create vertex buffer
            vb = new VertexBuffer(
                300000, // Vertex count - 3 floats per vertex
                structure, // Vertex structure
                Usage.DynamicUsage // Vertex data will stay the same
            );
            // indicesLen = indices.length;
            // Create index buffer
            ib = new IndexBuffer(
                300000, // Number of indices for our cube
                Usage.DynamicUsage // Index data will stay the same
            );
        }
        // Copy vertices and colors to vertex buffer
        var structureLength: Int = 0;
        switch( shaderKind ){
            case COLOURED:
                structureLength = 6;
            case TEXTURED:
                structureLength = 5;
            case NONE:
            
        }
        var vbData = vb.lock();
        for( i in 0...Std.int( vbData.length / structureLength ) ) {
            vbData.set( i * structureLength, vertices[ i * 3 ] );
            vbData.set( i * structureLength + 1, vertices[ i * 3 + 1 ] );
            vbData.set( i * structureLength + 2, vertices[ i * 3 + 2 ] );
            switch( shaderKind ){
                case COLOURED:
                    vbData.set( i * structureLength + 3, colors[ i * 3 ] );
                    vbData.set( i * structureLength + 4, colors[ i * 3 + 1 ] );
                    vbData.set( i * structureLength + 5, colors[ i * 3 + 2 ] );
                case TEXTURED:
                    vbData.set(i * structureLength + 3, uvs[ i * 2 ]);
                    vbData.set(i * structureLength + 4, uvs[ i * 2 + 1 ]);
                case NONE:
                
            }
        }
        vb.unlock();
        // A 'trick' to create indices for a non-indexed vertex data
        var indices:Array<Int> = [];
        for( i in 0...Std.int( vertices.length / 3 ) ) {
            indices.push( i );
        }
        // Copy indices to index buffer
        var iData= ib.lock();
        for (i in 0...iData.length) {
            iData[ i ] = indices[ i ];
        }
        ib.unlock();
        if( hasShaders ) render( time );
    }
    public function setShaders(  fragmentShader: FragmentShader, vertexShader: VertexShader
                            ,    hasTime_: Bool = true, shaderKind_: ShaderKind, hasMVP_: Bool = false ){
        hasMVP      = hasMVP_;
        hasTime     = hasTime_;
        shaderKind  = shaderKind_;
        structure   = new VertexStructure();
        switch( shaderKind ){
            case COLOURED:
                structure.add( "pos", VertexData.Float3 );
                structure.add( "col", VertexData.Float3 );
            case NONE:
                structure.add( "pos", VertexData.Float2 );
            case TEXTURED:
                structure.add( "pos", VertexData.Float3 );
                structure.add( "uv", VertexData.Float2 );
        }
        pipe                = new PipelineState();
        pipe.inputLayout    = [ structure ];
        pipe.fragmentShader = fragmentShader;
        pipe.vertexShader   = vertexShader;
        if( hasMVP ){
            pipe.depthWrite = false;
            pipe.depthMode = CompareMode.Less;
            
        }
        if( hasTime ) iTime = pipe.getConstantLocation( "iTime" );
        pipe.compile();
        if( shaderKind == TEXTURED ){
            textureID = pipe.getTextureUnit("myTextureSampler");
        }
        if( hasMVP ){
            mvpID = pipe.getConstantLocation( "MVP" );
            initProjection();
        }
        
        hasShaders = true;
    }
    public function initProjection(){
        // Projection matrix: 45° Field of View, 4:3 ratio, display range : 0.1 unit <-> 100 units
        projection = FastMatrix4.perspectiveProjection( 45.0, 16.0 / 9.0, 0.1, 100.0 );
        // Or, for an ortho camera
        //var projection = FastMatrix4.orthogonalProjection(-10.0, 10.0, -10.0, 10.0, 0.0, 100.0); // In world coordinates
        
        // Camera matrix
        view = FastMatrix4.lookAt(  new FastVector3( 0, 0, 10 ), // Camera is at (4, 3, 3), in World Space
                                    new FastVector3( 0, 0, 0 ), // and looks at the origin
                                    new FastVector3( 0, 1, 0 ) // Head is up (set to (0, -1, 0) to look upside-down)
        );

        // Model matrix: an identity matrix (model will be at the origin)
        model = FastMatrix4.identity();
        // Our ModelViewProjection: multiplication of our 3 matrices
        // Remember, matrix multiplication is the other way around
        setMPV();
    }
    public function setModel( model_: FastMatrix4 ){
        model = model_;
        setMPV();
    }
    public function setMPV(){
        mvp = FastMatrix4.identity();
        mvp = mvp.multmat( projection );
        mvp = mvp.multmat( view );
        mvp = mvp.multmat( model );
    }
    public static inline function toRGB( int: Int ) : { r: Float, g: Float, b: Float } {
        return {
            r: ((int >> 16) & 255) / 255,
            g: ((int >> 8) & 255) / 255,
            b: (int & 255) / 255,
        }
    }
    
}