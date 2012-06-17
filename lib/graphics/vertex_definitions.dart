/**
 * \file vertex_definitions.dart
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

class PositionTextureBuffer extends VertexBuffer
{
  static VertexDeclaration _vertexDeclaration;

  int _vertexCount;
  Vector3fArray _positions;
  Vector2fArray _textureCoords;

  PositionTextureBuffer(GraphicsDevice device, int vertexCount)
    : super(device, new Float32Array(vertexCount * (_vertexDeclaration.vertexStride >> 2)))
    , _vertexCount = vertexCount
  {
    int stride = _vertexDeclaration.vertexStride;
    _positions = new Vector3fArray.fromArray(_vertices, 0, stride);
    _textureCoords = new Vector2fArray.fromArray(_vertices, 12, stride);
  }

  VertexDeclaration get vertexDeclaration() => _vertexDeclaration;

  bool get isDirty()
  {
    return _positions.isDirty || _textureCoords.isDirty;
  }

  int get vertexCount() => _vertexCount;
  Vector3fArray get positions() => _positions;
  Vector2fArray get textureCoords() => _textureCoords;

  static void createDeclaration()
  {
    _vertexDeclaration = new VertexDeclaration([
      new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.Position, 0),
      new VertexElement(12, VertexElementFormat.Vector2, VertexElementUsage.TextureCoordinate, 0)
    ]);
  }
}

class PositionNormalTextureBuffer extends VertexBuffer
{
  static VertexDeclaration _vertexDeclaration;

  int _vertexCount;
  Vector3fArray _positions;
  Vector3fArray _normals;
  Vector2fArray _textureCoords;

  PositionNormalTextureBuffer(GraphicsDevice device, int vertexCount)
    : super(device, new Float32Array(vertexCount * (_vertexDeclaration.vertexStride >> 2)))
    , _vertexCount = vertexCount
  {
    int stride = _vertexDeclaration.vertexStride;
    _positions = new Vector3fArray.fromArray(_vertices, 0, stride);
    _normals = new Vector3fArray.fromArray(_vertices, 12, stride);
    _textureCoords = new Vector2fArray.fromArray(_vertices, 24, stride);
  }

  VertexDeclaration get vertexDeclaration() => _vertexDeclaration;

  bool get isDirty()
  {
    return _positions.isDirty || _normals.isDirty || _textureCoords.isDirty;
  }

  int get vertexCount() => _vertexCount;
  Vector3fArray get positions() => _positions;
  Vector3fArray get normals() => _normals;
  Vector2fArray get textureCoords() => _textureCoords;

  static void createDeclaration()
  {
    _vertexDeclaration = new VertexDeclaration([
      new VertexElement(0, VertexElementFormat.Vector3, VertexElementUsage.Position, 0),
      new VertexElement(12, VertexElementFormat.Vector3, VertexElementUsage.Normal, 0),
      new VertexElement(24, VertexElementFormat.Vector2, VertexElementUsage.TextureCoordinate, 0)
    ]);
  }
}
