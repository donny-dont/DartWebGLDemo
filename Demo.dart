/**
 * \file arrays.dart
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

ContentManager manager;
GameWindow gameWindow;
GraphicsDevice device;
EffectPass __effectPass;
Effect __effect;
Texture2D __texture;

String techniqueName = 'SimpleEffect';
String effectFilename = 'effects/test_effect.json';

PositionTextureBuffer __vertexBuffer;

class GameWindow
{
  GraphicsDevice _graphicsDevice;
  CanvasElement _canvas;
  int _windowedWidth;
  int _windowedHeight;

  GameWindow(String canvasId, int width, int height)
  {
    _canvas = document.query(canvasId);
    _canvas.width = width;
    _canvas.height = height;
    _windowedWidth = _canvas.width;
    _windowedHeight = _canvas.height;

    // Create the graphics device
    _graphicsDevice = new GraphicsDevice(_canvas.getContext('experimental-webgl'));

    // Add callback for when fullscreen is toggled
    _canvas.on.fullscreenChange.add((e) {
      if (document.webkitIsFullScreen)
      {
        Screen screen = window.screen;
        _canvas.width = screen.width;
        _canvas.height = screen.height;
      }
      else
      {
        _canvas.width = _windowedWidth;
        _canvas.height = _windowedHeight;
      }

      _resetViewport();

      // Notify that the viewport has changed
    });

    _resetViewport();
  }

  GraphicsDevice get graphicsDevice() => _graphicsDevice;
  int get width() => _canvas.width;
  int get height() => _canvas.height;

  void _resetViewport()
  {
    Viewport viewport = new Viewport(0, 0, _canvas.width, _canvas.height);
    _graphicsDevice.viewport = viewport;
  }
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

void main() {
  setupEditor();

  gameWindow = new GameWindow('#game', 800, 600);
  device = gameWindow.graphicsDevice;

  manager = new ContentManager(device);
  __texture = manager.loadTexture('textures/test.jpg');

  __effect = manager.loadEffect(effectFilename);
  PositionTextureBuffer.createDeclaration();

  __vertexBuffer = new PositionTextureBuffer(device, 6);


  Vector3fArray positions = __vertexBuffer.positions;
  Vector2fArray texCoords = __vertexBuffer.textureCoords;

  positions[0] = new vec3(-0.5,  0.5, 0.0); texCoords[0] = new vec2(0.0, 0.0);
  positions[1] = new vec3( 0.5,  0.5, 0.0); texCoords[1] = new vec2(1.0, 0.0);
  positions[2] = new vec3( 0.5, -0.5, 0.0); texCoords[2] = new vec2(1.0, 1.0);
  positions[3] = new vec3( 0.5, -0.5, 0.0); texCoords[3] = new vec2(1.0, 1.0);
  positions[4] = new vec3(-0.5, -0.5, 0.0); texCoords[4] = new vec2(0.0, 1.0);
  positions[5] = new vec3(-0.5,  0.5, 0.0); texCoords[5] = new vec2(0.0, 0.0);

  update(0);
}

bool update(int time) {
  device.clear();
  manager.update();

  if (__effect.techniques.containsKey(techniqueName))
  {
    // Set the uniform should really only be done once
    __effect.parameters['uSampler'].setInt(0);

    EffectPass pass = __effect.techniques[techniqueName].passes[0];
    pass.apply();

    device.setTexture(__texture, 0);
    device.setVertexBuffer(__vertexBuffer);

    // draw it!
    device.drawPrimitives(PrimitiveType.TriangleList, 0, __vertexBuffer.vertexCount);
  }

  window.requestAnimationFrame(update);
}
