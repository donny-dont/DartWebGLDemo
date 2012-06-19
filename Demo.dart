/**
 * \file Demo.dart
 *
 * \section COPYRIGHT
 *
 * Copyright (c) 2012 Don Olmstead
 *
 * This software is provided 'as-is', without any express or implied
 * warranty. In no event will the authors be held liable for any damages
 * arising from the use of this software.
 *
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 *
 *   1. The origin of this software must not be misrepresented; you must not
 *   claim that you wrote the original software. If you use this software
 *   in a product, an acknowledgment in the product documentation would be
 *   appreciated but is not required.
 *
 *   2. Altered source versions must be plainly marked as such, and must not be
 *   misrepresented as being the original software.
 *
 *   3. This notice may not be removed or altered from any source
 *   distribution.
 */

#library('lithium');
#import('dart:html');
#import('dart:core');
#import('dart:json');
#import('third_party/VectorMath/VectorMath.dart');
#source('lib/application/game.dart');
#source('lib/content/content_manager.dart');
#source('lib/content/_effect_manager.dart');
#source('lib/content/_texture_manager.dart');
#source('lib/graphics/arrays.dart');
#source('lib/graphics/effect.dart');
#source('lib/graphics/graphics_device.dart');
#source('lib/graphics/index_buffer.dart');
#source('lib/graphics/texture.dart');
#source('lib/graphics/vertex_buffer.dart');
#source('lib/graphics/vertex_definitions.dart');
#source('lib/scene/components.dart');
#source('lib/scene/entity.dart');
#source('lib/scene/meshes.dart');

ContentManager manager;
GameWindow gameWindow;
GraphicsDevice __device;
EffectPass __effectPass;
Effect __effect;
Texture2D __texture;
Camera __camera;

String techniqueName = 'SimpleTexture';
String effectFilename = 'effects/texture_effect.json';

PositionNormalTextureBuffer __vertexBuffer;
IndexBuffer __indexBuffer;

class Transform extends Component
{
  Transform _parent;
  mat4x4 _local;
  mat4x4 _world;

  Transform()
    : _parent = null
    , _local = new mat4x4()
    , _world = new mat4x4();

  mat4x4 get local() => _local;
  mat4x4 get world() => _world;

  static void updateTree(Transform root)
  {

  }
}

class RotationController extends Component
{

}

class Camera extends Component
{
  mat4x4 _projectionMatrix;
  mat4x4 _viewMatrix;

  Camera()
    : _projectionMatrix = new mat4x4()
    , _viewMatrix = new mat4x4();

  mat4x4 get projectionMatrix() => _projectionMatrix;
  mat4x4 get viewMatrix() => _viewMatrix;

  void setPerspective(double fov, double aspectRatio, double near, double far)
  {
    _projectionMatrix = makePerspective(fov, aspectRatio, near, far);
  }

  void setOrthographic(double left, double right, double bottom, double top, double near, double far)
  {
    _projectionMatrix = makeOrthographic(left, right, bottom, top, near, far);
  }

  void update()
  {
    if (_entity != null)
    {
      Transform transform = _entity.transform;
      assert(transform != null);

      mat4x4 world = transform.world;


    }
  }
}

class Light extends Component
{

}

class Visual extends Component
{
  VertexBuffer _vertexBuffer;
  IndexBuffer _indexBuffer;

  Visual()
    : _vertexBuffer = null
    , _indexBuffer = null;

  VertexBuffer get vertexBuffer() => _vertexBuffer;
  IndexBuffer get indexBuffer() => _indexBuffer;
}

void loadEditorContents(String url)
{
  TextAreaElement editor = document.query('#editor-text');

  // Send the request
  XMLHttpRequest request = new XMLHttpRequest();

  request.on.loadEnd.add((d) {
    if (request.status == 200)
      editor.text = request.responseText;
  });

  request.open('GET', url);
  request.send();
}

void setupEditor()
{
  Document document = window.document;

  // Setup the run events
  DivElement runButton = document.query('#run-button');
  TextAreaElement editor = document.query('#editor-text');

  runButton.on.mouseDown.add((e) {
    runButton.classes.remove('button-up');
    runButton.classes.add('button-down');
  });

  runButton.on.mouseUp.add((e) {
    // Create a new scene
    print(editor.value);

    runButton.classes.remove('button-down');
    runButton.classes.add('button-up');
  });

  runButton.on.mouseOut.add((e) {
    runButton.classes.remove('button-down');
    runButton.classes.add('button-up');
  });

  // Setup the fullscreen events
  DivElement fullscreenButton = document.query('#fullscreen-button');
  CanvasElement canvas = document.query('#game');

  fullscreenButton.on.mouseDown.add((e) {
    fullscreenButton.classes.remove('button-up');
    fullscreenButton.classes.add('button-down');
  });

  fullscreenButton.on.mouseUp.add((e) {
    canvas.webkitRequestFullScreen(Element.ALLOW_KEYBOARD_INPUT);

    fullscreenButton.classes.remove('button-down');
    fullscreenButton.classes.add('button-up');
  });

  fullscreenButton.on.mouseOut.add((e) {
    fullscreenButton.classes.remove('button-down');
    fullscreenButton.classes.add('button-up');
  });

  // Setup the select events
  SelectElement select = document.query('#example-select');
  select.on.change.add((e) {
    loadEditorContents(select.value);
  });

  // Set initial value for textarea
  loadEditorContents(select.value);
}

void main()
{
  setupEditor();

  gameWindow = new GameWindow('#game', 800, 600);
  __device = gameWindow.graphicsDevice;

  manager = new ContentManager(__device);
  __texture = manager.loadTexture('textures/dart_tex.png');

  __effect = manager.loadEffect(effectFilename);
  PositionTextureBuffer.createDeclaration();
  PositionNormalTextureBuffer.createDeclaration();

  BoxVisual box = new BoxVisual(__device, 0.5, 0.5, 0.5);
  //PlaneVisual plane = new PlaneVisual(__device, 0.5, 0.5, 128, 128);
  __vertexBuffer = box._vertexBuffer;
  __indexBuffer = box._indexBuffer;

  __camera = new Camera();
  __camera.setPerspective(0.785398163, 800 / 600, 0.01, 100.0);

  update(0);
}

bool update(int time) {
  __device.clear();
  manager.update();

  if (__effect.techniques.containsKey(techniqueName))
  {
    // Set the uniform should really only be done once
    mat4x4 rot1 = new mat4x4.rotationY(time * 0.0005);
    rot1.col3.w = 1.0;
    mat4x4 rot2 = new mat4x4.rotationX(time * 0.0005);
    rot2.col3.w = 1.0;
    mat4x4 m = rot1 * rot2;
    m.col3 = new vec4(0.0, 0.0, 2.5, 1.0);
    vec3 eye = new vec3(0.0, 0.0, 0.1);
    vec3 lookAt = new vec3(0.0, 0.0, 0.0);
    vec3 upVec = new vec3(0.0, 1.0, 0.0);
    mat4x4 v = makeLookAt(eye, lookAt, upVec);
    mat4x4 mv = v * m;
    __effect.parameters['uMVMatrix'].setMatrix4x4(mv);
    mat4x4 p = __camera.projectionMatrix;
    mat4x4 mvp =  p * mv;
    __effect.parameters['uMVPMatrix'].setMatrix4x4(mvp);

    __effect.parameters['uSampler'].setInt(0);

    EffectPass pass = __effect.techniques[techniqueName].passes[0];
    pass.apply();

    __device.setTexture(__texture, 0);
    __device.setVertexBuffer(__vertexBuffer);
    __device.setIndexBuffer(__indexBuffer);

    // draw it!
    __device.drawIndexedPrimitives(PrimitiveType.TriangleList, 0, __indexBuffer.indexCount);
  }

  window.requestAnimationFrame(update);
}
