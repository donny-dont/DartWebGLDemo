/**
 * \file index_buffer.dart
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

class IndexBuffer extends GraphicsResource
{
  WebGLBuffer _buffer;
  bool _dirty;
  int _indexCount;
  Uint16Array _array;

  IndexBuffer(GraphicsDevice device, int indexCount)
    : super(device)
    , _dirty = true
    , _indexCount = indexCount
    , _array = new Uint16Array(indexCount)
  {
    _device._bindIndexBuffer(this);
    _device._setDataIndexBuffer(this);
  }

  int operator[] (int index)
  {
    return _array[index];
  }

  int operator[]= (int index, int value)
  {
    _array[index] = value;

    _dirty = true;
  }

  int get indexCount() => _indexCount;
  bool get isDirty() => _dirty;
}
