/**
 * \file meshes.dart
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

class BoxVisual extends Visual
{
  BoxVisual(GraphicsDevice device, double xExtent, double yExtent, double zExtent)
  {
    // Create vertex buffer
    int vertexCount = 24;
    PositionNormalTextureBuffer vertexBuffer = new PositionNormalTextureBuffer(device, vertexCount);

    // Generate vertices
    _generatePositions(vertexBuffer.positions, xExtent, yExtent, zExtent);
    _generateTextureCoords(vertexBuffer.textureCoords);
    _generateNormals(vertexBuffer.normals);

    _vertexBuffer = vertexBuffer;

    // Generate indices
    int indexCount = 36;
    _indexBuffer = new IndexBuffer(device, indexCount);

    _indexBuffer[ 0] =  0;  _indexBuffer[ 1] =  1;  _indexBuffer[ 2] =  2;
    _indexBuffer[ 3] =  1;  _indexBuffer[ 4] =  3;  _indexBuffer[ 5] =  2;
    _indexBuffer[ 6] = 10;  _indexBuffer[ 7] = 11;  _indexBuffer[ 8] =  4;
    _indexBuffer[ 9] = 11;  _indexBuffer[10] =  5;  _indexBuffer[11] =  4;
    _indexBuffer[12] = 12;  _indexBuffer[13] = 13;  _indexBuffer[14] =  6;
    _indexBuffer[15] = 13;  _indexBuffer[16] =  7;  _indexBuffer[17] =  6;
    _indexBuffer[18] = 14;  _indexBuffer[19] = 15;  _indexBuffer[20] =  8;
    _indexBuffer[21] = 15;  _indexBuffer[22] =  9;  _indexBuffer[23] =  8;
    _indexBuffer[24] = 22;  _indexBuffer[25] = 16;  _indexBuffer[26] = 20;
    _indexBuffer[27] = 16;  _indexBuffer[28] = 18;  _indexBuffer[29] = 20;
    _indexBuffer[30] = 17;  _indexBuffer[31] = 23;  _indexBuffer[32] = 19;
    _indexBuffer[33] = 23;  _indexBuffer[34] = 21;  _indexBuffer[35] = 19;
  }

  static void _generatePositions(Vector3fArray positions, double xExtent, double yExtent, double zExtent)
  {
    List<vec3> positionValues = [
      new vec3(-xExtent,  yExtent,  zExtent),
      new vec3(-xExtent, -yExtent,  zExtent),
      new vec3( xExtent,  yExtent,  zExtent),
      new vec3( xExtent, -yExtent,  zExtent),
      new vec3( xExtent,  yExtent, -zExtent),
      new vec3( xExtent, -yExtent, -zExtent),
      new vec3(-xExtent,  yExtent, -zExtent),
      new vec3(-xExtent, -yExtent, -zExtent)
    ];

    positions[ 0] = positionValues[0];
    positions[ 1] = positionValues[1];
    positions[ 2] = positionValues[2];
    positions[ 3] = positionValues[3];
    positions[ 4] = positionValues[4];
    positions[ 5] = positionValues[5];
    positions[ 6] = positionValues[6];
    positions[ 7] = positionValues[7];

    positions[ 8] = positionValues[0];
    positions[ 9] = positionValues[1];
    positions[10] = positionValues[2];
    positions[11] = positionValues[3];
    positions[12] = positionValues[4];
    positions[13] = positionValues[5];
    positions[14] = positionValues[6];
    positions[15] = positionValues[7];

    positions[16] = positionValues[0];
    positions[17] = positionValues[1];
    positions[18] = positionValues[2];
    positions[19] = positionValues[3];
    positions[20] = positionValues[4];
    positions[21] = positionValues[5];
    positions[22] = positionValues[6];
    positions[23] = positionValues[7];
  }

  static void _generateTextureCoords(Vector2fArray textureCoords)
  {
    List<vec2> textureCoordValues = [
      new vec2(0.0, 1.0),
      new vec2(0.0, 0.0),
      new vec2(1.0, 1.0),
      new vec2(1.0, 0.0)
    ];

    textureCoords[ 0] = textureCoordValues[0];
    textureCoords[ 1] = textureCoordValues[1];
    textureCoords[ 2] = textureCoordValues[2];
    textureCoords[ 3] = textureCoordValues[3];
    textureCoords[ 4] = textureCoordValues[2];
    textureCoords[ 5] = textureCoordValues[3];
    textureCoords[ 6] = textureCoordValues[2];
    textureCoords[ 7] = textureCoordValues[3];

    textureCoords[ 8] = textureCoordValues[2];
    textureCoords[ 9] = textureCoordValues[3];
    textureCoords[10] = textureCoordValues[0];
    textureCoords[11] = textureCoordValues[1];
    textureCoords[12] = textureCoordValues[0];
    textureCoords[13] = textureCoordValues[1];
    textureCoords[14] = textureCoordValues[0];
    textureCoords[15] = textureCoordValues[1];

    textureCoords[16] = textureCoordValues[1];
    textureCoords[17] = textureCoordValues[0];
    textureCoords[18] = textureCoordValues[3];
    textureCoords[19] = textureCoordValues[2];
    textureCoords[20] = textureCoordValues[2];
    textureCoords[21] = textureCoordValues[3];
    textureCoords[22] = textureCoordValues[0];
    textureCoords[23] = textureCoordValues[1];
  }

  static void _generateNormals(Vector3fArray normals)
  {
    List<vec3> normalValues = [
      new vec3( 0.0,  0.0,  1.0),
      new vec3( 1.0,  0.0,  0.0),
      new vec3( 0.0,  0.0, -1.0),
      new vec3(-1.0,  0.0,  0.0),
      new vec3( 0.0,  1.0,  0.0),
      new vec3( 0.0, -1.0,  0.0)
    ];

    normals[ 0] = normalValues[0];
    normals[ 1] = normalValues[0];
    normals[ 2] = normalValues[0];
    normals[ 3] = normalValues[0];
    normals[ 4] = normalValues[1];
    normals[ 5] = normalValues[1];
    normals[ 6] = normalValues[2];
    normals[ 7] = normalValues[2];

    normals[ 8] = normalValues[3];
    normals[ 9] = normalValues[3];
    normals[10] = normalValues[1];
    normals[11] = normalValues[1];
    normals[12] = normalValues[2];
    normals[13] = normalValues[2];
    normals[14] = normalValues[3];
    normals[15] = normalValues[3];

    normals[16] = normalValues[4];
    normals[17] = normalValues[5];
    normals[18] = normalValues[4];
    normals[19] = normalValues[5];
    normals[20] = normalValues[4];
    normals[21] = normalValues[5];
    normals[22] = normalValues[4];
    normals[23] = normalValues[5];
  }
}

class PlaneVisual extends Visual
{
  PlaneVisual(
    GraphicsDevice device,
    double xExtent,
    double yExtent,
    int xSamples,
    int ySamples
  )
  {
    // Create vertex buffer
    int vertexCount = xSamples * ySamples;
    PositionNormalTextureBuffer vertexBuffer = new PositionNormalTextureBuffer(device, vertexCount);

    // Generate vertices
    _generatePositions(vertexBuffer.positions, xExtent, yExtent, xSamples, ySamples);
    _generateTextureCoords(vertexBuffer.textureCoords, xSamples, ySamples);
    _generateNormals(vertexBuffer.normals, vertexCount);

    _vertexBuffer = vertexBuffer;

    // Generate indices
    int xSamplesMinus1 = xSamples - 1;
    int ySamplesMinus1 = ySamples - 1;

    int indexCount = 6 * xSamplesMinus1 * ySamplesMinus1;
    _indexBuffer = new IndexBuffer(device, indexCount);
    int i = 0;

    for (int y = 0; y < ySamplesMinus1; ++y)
    {
      for (int x = 0; x < xSamplesMinus1; ++x)
      {
        int index0 = x + xSamples * y;
        int index1 = index0 + 1;
        int index2 = index1 + xSamples;
        int index3 = index0 + xSamples;

        _indexBuffer[i++] = index3;
        _indexBuffer[i++] = index0;
        _indexBuffer[i++] = index2;
        _indexBuffer[i++] = index0;
        _indexBuffer[i++] = index1;
        _indexBuffer[i++] = index2;
      }
    }
  }

  static void _generatePositions(Vector3fArray positions, double xExtent, double yExtent, int xSamples, int ySamples)
  {
    int xSamplesMinus1 = xSamples - 1;
    int ySamplesMinus1 = ySamples - 1;

    double xIncrement = (2.0 * xExtent) / xSamplesMinus1;
    double yIncrement = (2.0 * yExtent) / ySamplesMinus1;
    int i = 0;

    vec3 position = new vec3(0.0, -yExtent, 0.0);

    for (int y = 0; y < ySamples; ++y)
    {
      position.x = -xExtent;

      for (int x = 0; x < xSamples; ++x)
      {
        positions[i] = position;

        position.x += xIncrement;
        i++;
      }

      position.y += yIncrement;
    }
  }

  static void _generateTextureCoords(Vector2fArray textureCoords, int xSamples, int ySamples)
  {
    int xSamplesMinus1 = xSamples - 1;
    int ySamplesMinus1 = ySamples - 1;

    double xIncrement = 1.0 / xSamplesMinus1;
    double yIncrement = 1.0 / ySamplesMinus1;
    int i = 0;

    vec2 textureCoord = new vec2(0.0, 0.0);

    for (int y = 0; y < ySamples; ++y)
    {
      textureCoord.x = 0.0;

      for (int x = 0; x < xSamples; ++x)
      {
        textureCoords[i] = textureCoord;

        textureCoord.x += xIncrement;
        i++;
      }

      textureCoord.y += yIncrement;
    }
  }

  static void _generateNormals(Vector3fArray normals, int vertexCount)
  {
    vec3 normal = new vec3(0.0, 0.0, 1.0);

    for (int i = 0; i < vertexCount; ++i)
    {
      normals[i] = normal;
    }
  }
}

class SphereVisual
{

}
