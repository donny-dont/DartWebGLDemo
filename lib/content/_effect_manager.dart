/**
 * \file _effect_manager.dart
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

class _EffectManager
{
  GraphicsDevice _device;
  List<_EffectRequest> _dispatched;
  List<_EffectRequest> _pending;

  _EffectManager(GraphicsDevice device)
    : _device = device
    , _dispatched = new List<_EffectRequest>()
    , _pending = new List<_EffectRequest>();

  Effect load(String path)
  {
    _EffectRequest request = new _EffectRequest(_device);
    request.load(path);
    _dispatched.add(request);

    return request.effect;
  }

  void update()
  {
    int count = _dispatched.length;

    for (int i = 0; i < count; ++i)
    {
      _EffectRequest request = _dispatched[i];
      _ContentRequestStatus status = request.status;

      if (status == _ContentRequestStatus.Complete)
      {
        Effect effect = request.effect;
        effect._setData(request.response);

        _dispatched.removeRange(i, 1);
      }
      else if (status == _ContentRequestStatus.Error)
      {
        // Use default effect

        _dispatched.removeRange(i, 1);
      }
    }
  }
}

class _EffectRequest
{
  _ContentRequestStatus _status;
  String _response;
  Effect _effect;

  _EffectRequest(GraphicsDevice device)
    : _status = _ContentRequestStatus.Pending
    , _response = ""
    , _effect = new Effect(device);

  _ContentRequestStatus get status() => _status;
  Effect get effect() => _effect;
  String get response() => _response;

  Effect load(String path)
  {
    // Verify that its a json
    if (path.endsWith('.json'))
    {
      loadJson(this, path);
    }
    else
    {
      // Unknown effect type
      _status = _ContentRequestStatus.Error;
    }
  }

  static void loadJson(_EffectRequest effectRequest, String path)
  {
    XMLHttpRequest request = new XMLHttpRequest();

    request.on.loadEnd.add((d) {
      if (request.status == 200)
      {
        effectRequest._response = request.responseText;
        effectRequest._status = _ContentRequestStatus.Complete;
      }
      else
      {
        effectRequest._status = _ContentRequestStatus.Error;
      }
    });

    request.open("GET", path);
    request.send();
  }
}
