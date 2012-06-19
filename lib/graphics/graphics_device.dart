/**
 * \file graphics_device.dart
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

class PrimitiveType
{
  static final PrimitiveType TriangleList = const PrimitiveType(WebGLRenderingContext.TRIANGLES);
  static final PrimitiveType TriangleStrip = const PrimitiveType(WebGLRenderingContext.TRIANGLE_STRIP);

  final int value;

  const PrimitiveType(int this.value);
}

class GraphicsResource
{
  GraphicsDevice _device;

  GraphicsResource(GraphicsDevice this._device);
}

class Viewport
{
  int _x;
  int _y;
  int _width;
  int _height;

  Viewport(this._x, this._y, this._width, this._height);

  int get x() => _x;
  int get y() => _y;
  int get width() => _width;
  int get height() => _height;
}

class GraphicsDevice
{
  WebGLRenderingContext _gl;
  vec4 _clearColor;
  Viewport _viewport;
  Float32Array _matrix3x3Array;
  Float32Array _matrix4x4Array;

  //---------------------------------------------------------------------
  // Constructor
  //---------------------------------------------------------------------

  GraphicsDevice(WebGLRenderingContext gl)
    : _gl = gl
    , _matrix3x3Array = new Float32Array(9)
    , _matrix4x4Array = new Float32Array(16)
  {
    clearColor = new vec4(0.0, 0.0, 0.0, 1.0);

    _gl.enable(WebGLRenderingContext.DEPTH_TEST);
    _gl.frontFace(WebGLRenderingContext.CCW);
    _gl.cullFace(WebGLRenderingContext.BACK);
  }

  //---------------------------------------------------------------------
  // Properties
  //---------------------------------------------------------------------

  vec4 get clearColor() => _clearColor;

  void set clearColor(vec4 value)
  {
    _clearColor = value;

    _gl.clearColor(_clearColor.r, _clearColor.g, _clearColor.b, _clearColor.a);
  }

  Viewport get viewport() => _viewport;

  void set viewport(Viewport value)
  {
    _viewport = value;

    _gl.viewport(_viewport.x, _viewport.y, _viewport.width, _viewport.height);
  }

  //---------------------------------------------------------------------
  // Clear methods
  //---------------------------------------------------------------------

  void clear()
  {
    _gl.clear(WebGLRenderingContext.COLOR_BUFFER_BIT | WebGLRenderingContext.DEPTH_BUFFER_BIT);
  }

  //---------------------------------------------------------------------
  // Draw methods
  //---------------------------------------------------------------------

  void drawPrimitives(PrimitiveType type, int startVertex, int primitiveCount)
  {
    _gl.drawArrays(type.value, startVertex, primitiveCount);
  }

  void drawIndexedPrimitives(PrimitiveType type, int startVertex, int indexCount)
  {
    _gl.drawElements(type.value, indexCount, WebGLRenderingContext.UNSIGNED_SHORT, startVertex);
  }

  //---------------------------------------------------------------------
  // EffectParameter methods
  //---------------------------------------------------------------------

  WebGLUniformLocation _getUniformLocation(EffectPass pass, String name)
  {
    return _gl.getUniformLocation(pass._program, name);
  }

  void _bindUniform1i(WebGLUniformLocation location, int value)
  {
    _gl.uniform1i(location, value);
  }

  void _bindUniform1f(WebGLUniformLocation location, double value)
  {
    _gl.uniform1f(location, value);
  }

  void _bindUniformMatrix3x3(WebGLUniformLocation location, mat3x3 value)
  {
    value.copyIntoArray(_matrix3x3Array);

    _gl.uniformMatrix3fv(location, false, _matrix3x3Array);
  }

  void _bindUniformMatrix4x4(WebGLUniformLocation location, mat4x4 value)
  {
    // mat4x4 should probably be backed by an array
    // just copy it over to our array
    value.copyIntoArray(_matrix4x4Array);

    _gl.uniformMatrix4fv(location, false, _matrix4x4Array);
  }

  //---------------------------------------------------------------------
  // EffectPass methods
  //---------------------------------------------------------------------

  void _applyEffectPass(EffectPass pass)
  {
    _gl.useProgram(pass._program);
  }

  void _bindEffectPass(EffectPass pass)
  {
    pass._program = _gl.createProgram();
  }

  void _releaseEffectPass(EffectPass pass)
  {
    _gl.deleteProgram(pass._program);
    pass._program = null;
  }

  void _setEffectPassSource(EffectPass pass, String vertexSource, String pixelSource)
  {
    // Create the vertex shader
    WebGLShader vertexShader = _gl.createShader(WebGLRenderingContext.VERTEX_SHADER);

    _gl.shaderSource(vertexShader, vertexSource);
    _gl.compileShader(vertexShader);

    bool vertexCompiled = _gl.getShaderParameter(vertexShader, WebGLRenderingContext.COMPILE_STATUS);

    if (!vertexCompiled)
    {
      print(_gl.getShaderInfoLog(vertexShader));
    }

    // Create the fragment shader
    WebGLShader fragmentShader = _gl.createShader(WebGLRenderingContext.FRAGMENT_SHADER);

    _gl.shaderSource(fragmentShader, pixelSource);
    _gl.compileShader(fragmentShader);

    bool fragmentCompiled = _gl.getShaderParameter(fragmentShader, WebGLRenderingContext.COMPILE_STATUS);

    if (!fragmentCompiled)
    {
      print(_gl.getShaderInfoLog(fragmentShader));
    }

    // Attach the shaders
    WebGLProgram program = pass._program;
    _gl.attachShader(program, vertexShader);
    _gl.attachShader(program, fragmentShader);

    // Bind the standard locations
    _gl.bindAttribLocation(program, VertexElementUsage.Position.value, 'position');
    _gl.bindAttribLocation(program, VertexElementUsage.Normal.value, 'normal');
    _gl.bindAttribLocation(program, VertexElementUsage.TextureCoordinate.value, 'texCoord0');
    _gl.bindAttribLocation(program, VertexElementUsage.TextureCoordinate.value, 'texCoord1');

    // Link the program
    _gl.linkProgram(program);

    bool programLinked = _gl.getProgramParameter(program, WebGLRenderingContext.LINK_STATUS);

    // Delete the shaders
    _gl.deleteShader(vertexShader);
    _gl.deleteShader(fragmentShader);
  }

  //---------------------------------------------------------------------
  // VertexBuffer methods
  //---------------------------------------------------------------------

  void setVertexBuffer(VertexBuffer buffer)
  {
    if (buffer.isDirty)
    {
      // Update the buffer
      _setDataVertexBuffer(buffer);
    }
    else
    {
      // Bind the buffer
      _gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, buffer._buffer);
    }

    // Get the vertex declaration
    VertexDeclaration declaration = buffer.vertexDeclaration;
    int stride = declaration.vertexStride;

    // Enable each vertex attribute
    for (VertexElement element in declaration.elements)
    {
      int index = element.usage.value + element.usageIndex;
      int offset = element.offset;
      int size = element.format.value >> 2;

      _gl.enableVertexAttribArray(index);
      _gl.vertexAttribPointer(
        index,
        size,
        WebGLRenderingContext.FLOAT,
        false,
        stride,
        offset);
    }
  }

  void _bindVertexBuffer(VertexBuffer buffer)
  {
    buffer._buffer = _gl.createBuffer();
  }

  void _releaseVertexBuffer(VertexBuffer buffer)
  {
    _gl.deleteBuffer(buffer._buffer);
    buffer._buffer = null;
  }

  void _setDataVertexBuffer(VertexBuffer buffer)
  {
    _gl.bindBuffer(WebGLRenderingContext.ARRAY_BUFFER, buffer._buffer);
    _gl.bufferData(
      WebGLRenderingContext.ARRAY_BUFFER,
      buffer._vertices,
      WebGLRenderingContext.STATIC_DRAW);
  }

  //---------------------------------------------------------------------
  // IndexBuffer methods
  //---------------------------------------------------------------------

  void setIndexBuffer(IndexBuffer buffer)
  {
    if (buffer.isDirty)
    {
      _setDataIndexBuffer(buffer);
    }
    else
    {
      _gl.bindBuffer(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, buffer._buffer);
    }
  }

  void _bindIndexBuffer(IndexBuffer buffer)
  {
    buffer._buffer = _gl.createBuffer();
  }

  void _releaseIndexBuffer(IndexBuffer buffer)
  {
    _gl.deleteBuffer(buffer._buffer);
  }

  void _setDataIndexBuffer(IndexBuffer buffer)
  {
    _gl.bindBuffer(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, buffer._buffer);
    _gl.bufferData(WebGLRenderingContext.ELEMENT_ARRAY_BUFFER, buffer._array, WebGLRenderingContext.STATIC_DRAW);
  }

  //---------------------------------------------------------------------
  // Texture methods
  //---------------------------------------------------------------------

  void setTexture(Texture2D texture, int index)
  {
    assert(index < 32);

    _gl.activeTexture(WebGLRenderingContext.TEXTURE0 + index);
    _gl.bindTexture(WebGLRenderingContext.TEXTURE_2D, texture._binding);
  }

  void _bindTexture2D(Texture2D texture)
  {
    texture._binding = _gl.createTexture();
  }

  void _releaseTexture2D(Texture2D texture)
  {
    _gl.deleteTexture(texture._binding);
    texture._binding = null;
  }

  void _setDataTexture2D(Texture2D texture, ImageElement element)
  {
    _gl.pixelStorei(WebGLRenderingContext.UNPACK_FLIP_Y_WEBGL, 1);

    _gl.bindTexture(WebGLRenderingContext.TEXTURE_2D, texture._binding);
    _gl.texParameteri(WebGLRenderingContext.TEXTURE_2D, WebGLRenderingContext.TEXTURE_MAG_FILTER, WebGLRenderingContext.NEAREST);
    _gl.texParameteri(WebGLRenderingContext.TEXTURE_2D, WebGLRenderingContext.TEXTURE_MIN_FILTER, WebGLRenderingContext.NEAREST);

    _gl.texImage2D(
      WebGLRenderingContext.TEXTURE_2D,
      0,
      WebGLRenderingContext.RGBA,
      WebGLRenderingContext.RGBA,
      WebGLRenderingContext.UNSIGNED_BYTE,
      element);
  }
}
