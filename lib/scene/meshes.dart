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
    generatePositions(vertexBuffer.positions, xExtent, yExtent, xSamples, ySamples);
    generateTextureCoords(vertexBuffer.textureCoords, xSamples, ySamples);
    generateNormals(vertexBuffer.normals, vertexCount);

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

  static void generatePositions(Vector3fArray positions, double xExtent, double yExtent, int xSamples, int ySamples)
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

  static void generateTextureCoords(Vector2fArray textureCoords, int xSamples, int ySamples)
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

  static void generateNormals(Vector3fArray normals, int vertexCount)
  {
    vec3 normal = new vec3(0.0, 0.0, 1.0);

    for (int i = 0; i < vertexCount; ++i)
    {
      normals[i] = normal;
    }
  }
}
