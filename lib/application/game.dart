/**
 * \file game.dart
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
