/**
 * \file content_manager.dart
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

class _ContentRequestStatus
{
  static final Pending = const _ContentRequestStatus(0);
  static final Complete = const _ContentRequestStatus(1);
  static final Error = const _ContentRequestStatus(2);

  final int value;

  const _ContentRequestStatus(int this.value);
}

class ContentManager
{
  GraphicsDevice _graphicsDevice;
  _TextureManager _textureManager;
  _EffectManager _effectManager;

  ContentManager(GraphicsDevice device)
    : _graphicsDevice = device
    , _textureManager = new _TextureManager(device)
    , _effectManager = new _EffectManager(device);

  Texture2D loadTexture(String path)
  {
    return _textureManager.load(path);
  }

  Effect loadEffect(String path)
  {
    return _effectManager.load(path);
  }

  void update()
  {
    _textureManager.update();
    _effectManager.update();
  }

}
