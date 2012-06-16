/**
 * \file _texture_manager.dart
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

class _TextureManager
{
  GraphicsDevice  _device;
  List<_TextureRequest> _dispatched;
  List<_TextureRequest> _pending;

  _TextureManager(GraphicsDevice device)
    : _device = device
    , _dispatched = new List<_TextureRequest>()
    , _pending = new List<_TextureRequest>();

  Texture2D load(String path)
  {
    _TextureRequest request = new _TextureRequest(_device);
    request.load(path);
    _dispatched.add(request);

    return request._texture;
  }

  void update()
  {
    int count = _dispatched.length;

    for (int i = 0; i < count; ++i)
    {
      _TextureRequest request = _dispatched[i];
      _ContentRequestStatus status = request.status;

      if (status == _ContentRequestStatus.Complete)
      {
        _device._setDataTexture2D(request.texture, request.element);
        _dispatched.removeRange(i, 1);
      }
      else if (status == _ContentRequestStatus.Error)
      {
        // Use default image

        _dispatched.removeRange(i, 1);
      }
    }
  }
}

class _TextureRequest
{
  _ContentRequestStatus _status;
  ImageElement _element;
  Texture2D _texture;

  _TextureRequest(GraphicsDevice device)
    : _status = _ContentRequestStatus.Pending
    , _element = new ImageElement()
    , _texture = new Texture2D(device);

  ImageElement get element() => _element;
  _ContentRequestStatus get status() => _status;
  Texture2D get texture() => _texture;

  Texture2D load(String path)
  {
    // Determine the image type
    if (path.endsWith('.png'))
    {
      loadNative(this, path);
    }
    else if ((path.endsWith('.jpg')) || (path.endsWith('.jpeg')))
    {
      loadNative(this, path);
    }
    else
    {
      // Unknown image type
      _status = _ContentRequestStatus.Error;
    }

    return _texture;
  }

  static void loadNative(_TextureRequest request, String path)
  {
    ImageElement img = request._element;

    // Notify that the request was completed
    img.on.load.add((e) {
      request._status = _ContentRequestStatus.Complete;
    });

    // Notify that there was an error during the request
    img.on.error.add((e) {
      request._status = _ContentRequestStatus.Error;
    });

    // Start the load
    img.src = path;
  }
}
