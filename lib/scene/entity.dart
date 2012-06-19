/**
 * \file entity.dart
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

class GameEntity
{
  List<Component> _components;
  Transform _transform;
  Visual _visual;
  Camera _camera;
  Light _light;

  GameEntity()
    : _components = new List<Component>()
    , _transform = null
    , _visual = null
    , _camera = null
    , _light = null;

  Transform get transform() => _transform;
  Visual get visual() => _visual;
  Camera get camera() => _camera;
  Light get light() => _light;

  void addComponent(Component component)
  {
    component._setEntity(this);

    _components.add(component);

    // Provide accessors for specific
    // Component types
    if (component is Transform)
      _transform = component;
    else if (component is Visual)
      _visual = component;
    else if (component is Light)
      _light = component;
    else if (component is Camera)
      _camera = component;
  }

  void removeComponent(Component component)
  {
    int index = _components.indexOf(component);

    if (index != -1)
    {
      component._setEntity(null);

      _components.removeRange(index, 1);

      if (component is Transform)
        _transform = null;
      else if (component is Visual)
        _visual = null;
      else if (component is Light)
        _light = null;
      else if (component is Camera)
        _camera = null;
    }
  }
}
