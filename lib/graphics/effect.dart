/**
 * \file effect.dart
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

class EffectTechnique
{
  List<EffectPass> _passes;
  String _name;

  EffectTechnique(String name)
    : _passes = new List<EffectPass>()
    , _name = name;

  List<EffectPass> get passes() => _passes;
  String get name() => _name;
}

class EffectParameter
{
  String _name;
  Effect _effect;

  EffectParameter(Effect this._effect, String this._name);

  String get name() => _name;

  void setInt(int value)
  {
    _effect._setInt(this, value);
  }

  void setFloat(double value)
  {
    _effect._setFloat(this, value);
  }

  void setMatrix3x3(mat3x3 value)
  {
    _effect._setMatrix3x3(this, value);
  }

  void setMatrix4x4(mat4x4 value)
  {
    _effect._setMatrix4x4(this, value);
  }
}

class Effect extends GraphicsResource
{
  Map<String, EffectTechnique> _techniques;
  Map<String, EffectParameter> _parameters;

  Effect(GraphicsDevice device)
    : super(device)
    , _techniques = new Map<String, EffectTechnique>()
    , _parameters = new Map<String, EffectParameter>();

  Map<String, EffectTechnique> get techniques() => _techniques;
  Map<String, EffectParameter> get parameters() => _parameters;

  void _setInt(EffectParameter parameter, int value)
  {
    Collection techniques = _techniques.getValues();

    for (EffectTechnique technique in techniques)
    {
      List<EffectPass> passes = technique.passes;
      for (EffectPass pass in passes)
      {
        pass._setInt(parameter.name, value);
      }
    }
  }

  void _setFloat(EffectParameter parameter, double value)
  {
    Collection techniques = _techniques.getValues();

    for (EffectTechnique technique in techniques)
    {
      List<EffectPass> passes = technique.passes;
      for (EffectPass pass in passes)
      {
        pass._setFloat(parameter.name, value);
      }
    }
  }

  void _setMatrix3x3(EffectParameter parameter, mat3x3 value)
  {
    Collection techniques = _techniques.getValues();

    for (EffectTechnique technique in techniques)
    {
      List<EffectPass> passes = technique.passes;
      for (EffectPass pass in passes)
      {
        pass._setMatrix3x3(parameter.name, value);
      }
    }
  }

  void _setMatrix4x4(EffectParameter parameter, mat4x4 value)
  {
    Collection techniques = _techniques.getValues();

    for (EffectTechnique technique in techniques)
    {
      List<EffectPass> passes = technique.passes;
      for (EffectPass pass in passes)
      {
        pass._setMatrix4x4(parameter.name, value);
      }
    }
  }

  void _setData(String data)
  {
    Map parsedData = JSON.parse(data);

    // Parse the uniforms
    List uniforms = parsedData['uniforms'];

    if (uniforms != null)
    {
      for (String uniform in uniforms)
      {
        EffectParameter parameter = new EffectParameter(this, uniform);
        _parameters[uniform] = parameter;
      }
    }

    // Parse the techniques
    List techniques = parsedData['techniques'];

    for (Map technique in techniques)
    {
      String name = technique['name'];
      EffectTechnique effectTechnique = new EffectTechnique(name);

      List passes = technique['passes'];

      for (Map pass in passes)
      {
        String vertexSource = Strings.join(pass['vertex'], '\n');
        String pixelSource = Strings.join(pass['pixel'], '\n');

        EffectPass effectPass = new EffectPass.fromSource(_device, vertexSource, pixelSource);

        // Initialize the uniforms
        if (uniforms != null)
        {
          for (String uniform in uniforms)
            effectPass._getAttribute(uniform);
        }

        effectTechnique.passes.add(effectPass);
      }

      _techniques[name] = effectTechnique;
    }
  }
}

class EffectPass extends GraphicsResource
{
  WebGLProgram _program;
  Map<String, WebGLUniformLocation> _locations;

  EffectPass(GraphicsDevice device)
    : super(device)
    , _locations = new Map<String, WebGLUniformLocation>()
  {
    _device._bindEffectPass(this);
  }

  EffectPass.fromSource(GraphicsDevice device, String vertexSource, String pixelSource)
    : super(device)
    , _locations = new Map<String, WebGLUniformLocation>()
  {
    _device._bindEffectPass(this);
    _device._setEffectPassSource(this, vertexSource, pixelSource);
  }

  void apply()
  {
    _device._applyEffectPass(this);
  }

  void _getAttribute(String name)
  {
    WebGLUniformLocation location = _device._getUniformLocation(this, name);

    if (location != null)
    {
      _locations[name] = location;
    }
  }

  void _setInt(String name, int value)
  {
    if (_locations.containsKey(name))
    {
      apply();

      _device._bindUniform1i(_locations[name], value);
    }
  }

  void _setFloat(String name, double value)
  {
    if (_locations.containsKey(name))
    {
      apply();

      _device._bindUniform1f(_locations[name], value);
    }
  }

  void _setMatrix3x3(String name, mat3x3 value)
  {
    if (_locations.containsKey(name))
    {
      apply();

      _device._bindUniformMatrix3x3(_locations[name], value);
    }
  }

  void _setMatrix4x4(String name, mat4x4 value)
  {
    if (_locations.containsKey(name))
    {
      apply();

      _device._bindUniformMatrix4x4(_locations[name], value);
    }
  }
}
