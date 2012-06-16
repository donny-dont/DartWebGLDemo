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

class Vector2fArray
{
  static final BYTES_PER_ELEMENT = 8;
  static final _itemCount = 2;

  int _offset;
  int _stride;
  bool _dirty;
  Float32Array _array;

  Vector2fArray(int length)
    : _offset = 0
    , _stride = _itemCount
    , _dirty = true
    , _array = new Float32Array(length * _itemCount);

  Vector2fArray.fromArray(Float32Array array, [int byteOffset=0, int byteStride=_itemCount])
    : _offset = byteOffset >> 2
    , _stride = byteStride >> 2
    , _dirty = true
    , _array = array
  {
    assert(byteOffset % 4 == 0);
    assert(byteStride % 4 == 0);
  }

  bool get isDirty() => _dirty;
  void set _isDirty(bool value) { _dirty = value; }

  Float32Array get array() => _array;

  vec2 operator[] (int index)
  {
    int arrayIndex = _getArrayIndex(index);

    double x = _array[arrayIndex++];
    double y = _array[arrayIndex];

    return new vec2(x, y);
  }

  void operator[]= (int index, vec2 value)
  {
    int arrayIndex = _getArrayIndex(index);

    _array[arrayIndex++] = value.x;
    _array[arrayIndex]   = value.y;

    _dirty = true;
  }

  void getAt(int index, vec2 value)
  {
    int arrayIndex = _getArrayIndex(index);

    value.x = _array[arrayIndex++];
    value.y = _array[arrayIndex];
  }

  int _getArrayIndex(int index)
  {
    return _offset + (index * _stride);
  }
}

class Vector3fArray
{
  static final BYTES_PER_ELEMENT = 12;
  static final _itemCount = 3;

  int _offset;
  int _stride;
  bool _dirty;
  Float32Array _array;

  Vector3fArray(int length)
    : _offset = 0
    , _stride = _itemCount
    , _dirty = true
    , _array = new Float32Array(length * _itemCount);

  Vector3fArray.fromArray(Float32Array array, [int byteOffset=0, int byteStride=_itemCount])
    : _offset = byteOffset >> 2
    , _stride = byteStride >> 2
    , _dirty = true
    , _array = array
  {
    assert(byteOffset % 4 == 0);
    assert(byteStride % 4 == 0);
  }

  bool get isDirty() => _dirty;
  void set _isDirty(bool value) { _dirty = value; }

  Float32Array get array() => _array;

  vec3 operator[] (int index)
  {
    int arrayIndex = _getArrayIndex(index);

    double x = _array[arrayIndex++];
    double y = _array[arrayIndex++];
    double z = _array[arrayIndex];

    return new vec3(x, y, z);
  }

  void operator[]= (int index, vec3 value)
  {
    int arrayIndex = _getArrayIndex(index);

    _array[arrayIndex++] = value.x;
    _array[arrayIndex++] = value.y;
    _array[arrayIndex]   = value.z;

    _dirty = true;
  }

  void getAt(int index, vec3 value)
  {
    int arrayIndex = _getArrayIndex(index);

    value.x = _array[arrayIndex++];
    value.y = _array[arrayIndex++];
    value.z = _array[arrayIndex];
  }

  int _getArrayIndex(int index)
  {
    return _offset + (index * _stride);
  }
}

class Vector4fArray
{
  static final BYTES_PER_ELEMENT = 16;
  static final _itemCount = 4;

  int _offset;
  int _stride;
  bool _dirty;
  Float32Array _array;

  Vector4fArray(int length)
    : _offset = 0
    , _stride = _itemCount
    , _dirty = true
    , _array = new Float32Array(length * _itemCount);

  Vector4fArray.fromArray(Float32Array array, [int byteOffset=0, int byteStride=_itemCount])
    : _offset = byteOffset >> 2
    , _stride = byteStride >> 2
    , _dirty = true
    , _array = array
  {
    assert(byteOffset % 4 == 0);
    assert(byteStride % 4 == 0);
  }

  bool get isDirty() => _dirty;
  void set _isDirty(bool value) { _dirty = value; }

  Float32Array get array() => _array;

  vec4 operator[] (int index)
  {
    int arrayIndex = _getArrayIndex(index);

    double x = _array[arrayIndex++];
    double y = _array[arrayIndex++];
    double z = _array[arrayIndex++];
    double w = _array[arrayIndex];

    return new vec4(x, y, z, w);
  }

  void operator[]= (int index, vec4 value)
  {
    int arrayIndex = _getArrayIndex(index);

    _array[arrayIndex++] = value.x;
    _array[arrayIndex++] = value.y;
    _array[arrayIndex++] = value.z;
    _array[arrayIndex]   = value.w;

    _dirty = true;
  }

  void getAt(int index, vec4 value)
  {
    int arrayIndex = _getArrayIndex(index);

    value.x = _array[arrayIndex++];
    value.y = _array[arrayIndex++];
    value.z = _array[arrayIndex++];
    value.w = _array[arrayIndex];
  }

  int _getArrayIndex(int index)
  {
    return _offset + (index * _stride);
  }
}
