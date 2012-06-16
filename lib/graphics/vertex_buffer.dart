/**
 * \file vertex_buffer.dart
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

class VertexElementFormat
{
  static final VertexElementFormat Single = const VertexElementFormat(4);
  static final VertexElementFormat Vector2 = const VertexElementFormat(8);
  static final VertexElementFormat Vector3 = const VertexElementFormat(12);
  static final VertexElementFormat Vector4 = const VertexElementFormat(14);

  final int value;

  const VertexElementFormat(int this.value);
}

class VertexElementUsage
{
  static final VertexElementUsage Position = const VertexElementUsage(0);
  static final VertexElementUsage Normal = const VertexElementUsage(1);
  static final VertexElementUsage TextureCoordinate = const VertexElementUsage(2);

  final int value;

  const VertexElementUsage(int this.value);
}

class VertexElement
{
  int _offset;
  VertexElementFormat _format;
  VertexElementUsage _usage;
  int _usageIndex;

  VertexElement(int offset, VertexElementFormat format, VertexElementUsage usage, int usageIndex)
    : _offset = offset
    , _format = format
    , _usage = usage
    , _usageIndex = usageIndex;

  int get offset() => _offset;
  VertexElementFormat get format() => _format;
  VertexElementUsage get usage() => _usage;
  int get usageIndex() => _usageIndex;
}

class VertexDeclaration
{
  List<VertexElement> _elements;
  int _vertexStride;

  VertexDeclaration(List<VertexElement> elements)
    : _elements = elements
  {
    _vertexStride = 0;

    for (VertexElement element in _elements)
    {
      _vertexStride += element.format.value;
    }
  }

  List<VertexElement> get elements() => _elements;
  int get vertexStride() => _vertexStride;
}

abstract class VertexBuffer extends GraphicsResource
{
  WebGLBuffer _buffer;
  Float32Array _vertices;

  VertexBuffer(GraphicsDevice device, Float32Array vertices)
    : super(device)
    , _vertices = vertices
  {
    _device._bindVertexBuffer(this);
    _device._setDataVertexBuffer(this);
  }

  abstract int get vertexCount();
  abstract bool get isDirty();
  abstract VertexDeclaration get vertexDeclaration();
}
