var DisplayCanvas, DisplayWebGl, ImgServer;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
DisplayWebGl = (function() {
  function DisplayWebGl(canvas) {
    this.w = canvas.width;
    this.h = canvas.height;
    this.ctx = this.create_3D_context(canvas);
    this.shader_program = void 0;
    this.pos_buf = this.make_square_buf();
    this.tex_rgba = void 0;
    this.tex_zzzz = void 0;
    this.tex_rgba_id = this.ctx.createTexture();
    this.tex_zzzz_id = this.ctx.createTexture();
    this.ctx.clearColor(0, 0, 0, 1);
    this.init_shaders("            precision highp float;            attribute vec3 pos;                        void main( void ) {                gl_Position = vec4( pos, 1.0 );            }            ", "            precision highp float;            uniform sampler2D tex, zzz;            uniform float z_min, z_max;                        /* old */            uniform vec3 old_X, old_Y, old_Z, old_O;            uniform float old_p, old_o_x, old_o_y;            /* new */            uniform vec3 new_X, new_Y, new_Z, new_O;            uniform float new_p, new_o_x, new_o_y;                        vec4 bg( float y ) {                return vec4( 0, 0, pow( y, 2.0 ) * 150.0 / 256.0, 1 );            }                        vec3 new_eye_pos( float x, float y ) {                return new_O + ( x + new_o_x ) * new_X + ( y + new_o_y ) * new_Y;            }                        vec3 new_eye_dir( float x, float y ) {                return normalize( ( ( x + new_o_x ) * new_X + ( y + new_o_y ) * new_Y ) * new_p + new_Z );            }                        vec3 old_buf_proj( vec3 P ) {                vec3 d = P - old_O;                float x = dot( d, old_X );                float y = dot( d, old_Y );                float z = dot( d, old_Z );                float m = 1.0 / ( 1.0 + old_p * z );                return vec3( old_o_x + m * x, old_o_y + m * y, z );            }                        float p1i0( float x ) { return x + float( x == 0.0 ); }            void main( void ) {                float w = 512.0, h = 512.0;                vec2 p; p.x = gl_FragCoord.x / w; p.y = ( h - 1.0 - gl_FragCoord.y ) / h;                /*                vec4 c = texture2D( tex, p );                float z = texture2D( zzz, p ).r;                gl_FragColor = z != 1.0 ? c : bg( p.y );                return;                */                vec3 new_P = new_eye_pos( gl_FragCoord.x, h - 1.0 - gl_FragCoord.y );                vec3 new_D = new_eye_dir( gl_FragCoord.x, h - 1.0 - gl_FragCoord.y );                vec3 oz_dir = normalize( old_Z );                /* intersection of the ray / z planes */                float div_m = 1.0 / p1i0( dot( new_D, oz_dir ) );                float d_mir = ( z_min - dot( new_P - old_O, oz_dir ) ) * div_m;                float d_mar = ( z_max - dot( new_P - old_O, oz_dir ) ) * div_m;                                /* position of the rays in the 2 z planes */                vec3 P_mis = old_buf_proj( new_P + d_mir * new_D );                vec3 P_mas = old_buf_proj( new_P + d_mar * new_D );                float x_mis = P_mis[ 0 ], y_mis = P_mis[ 1 ];                float x_mas = P_mas[ 0 ], y_mas = P_mas[ 1 ];                /* totally out of the (old) screen ? */                if ( x_mis <  0.0 && x_mas <  0.0 ) { gl_FragColor = bg( p.y ); return; }                if ( x_mis >=   w && x_mas >=   w ) { gl_FragColor = bg( p.y ); return; }                if ( y_mis <  0.0 && y_mas <  0.0 ) { gl_FragColor = bg( p.y ); return; }                if ( y_mis >=   h && y_mas >=   h ) { gl_FragColor = bg( p.y ); return; }                                /* bounds for the ray */                float b_mm = 0.0, e_mm = 1.0, w_m = w - 1.0, h_m = h - 1.0;                if ( x_mis < x_mas ) {                    if ( x_mis < 0.0 ) { b_mm = max( b_mm, (     - x_mis ) / p1i0( x_mas - x_mis ) ); }                    if ( x_mas > w_m ) { e_mm = min( e_mm, ( w_m - x_mis ) / p1i0( x_mas - x_mis ) ); }                } else {                    if ( x_mas < 0.0 ) { e_mm = min( e_mm, ( x_mis       ) / p1i0( x_mis - x_mas ) ); }                    if ( x_mis > w_m ) { b_mm = max( b_mm, ( x_mis - w_m ) / p1i0( x_mis - x_mas ) ); }                }                                if ( y_mis < y_mas ) {                    if ( y_mis < 0.0 ) { b_mm = max( b_mm, (     - y_mis ) / p1i0( y_mas - y_mis ) ); }                    if ( y_mas > h_m ) { e_mm = min( e_mm, ( h_m - y_mis ) / p1i0( y_mas - y_mis ) ); }                } else {                    if ( y_mas < 0.0 ) { e_mm = min( e_mm, ( y_mis       ) / p1i0( y_mis - y_mas ) ); }                    if ( y_mis > h_m ) { b_mm = max( b_mm, ( y_mis - h_m ) / p1i0( y_mis - y_mas ) ); }                }                int n_mm = int( max( abs( x_mas - x_mis ), abs( y_mas - y_mis ) ) );                float i_mm = ( e_mm - b_mm ) / p1i0( float( n_mm ) );                float s_mm = 1.0 / p1i0( float( n_mm ) );                for( int n = 0; n <= 150; ++n ) {                    if ( n > n_mm )                        break;                    float i = b_mm + i_mm * float( n );                    vec2 md;                     md.x = ( x_mis + i * ( x_mas - x_mis ) ) / w;                    md.y = ( y_mis + i * ( y_mas - y_mis ) ) / h;                    float zu = texture2D( zzz, md ).r;                    if ( zu != 1.0 ) {                        float z = z_min + zu * ( z_max - z_min ) * 255.0 / 254.0; /* screen space */                        float z_md_0 = z_min + ( i - 2.0 * s_mm ) * ( z_max - z_min );                        float z_md_1 = z_min + ( i + 3.0 * s_mm ) * ( z_max - z_min );                        if ( z <= z_md_1 && z >= z_md_0 ) {                            gl_FragColor = texture2D( tex, md );                            return;                        }                    }                }                gl_FragColor = bg( p.y );            }            ");
  }
  DisplayWebGl.prototype.draw = function(disp) {
    var new_eye, old_buf;
    this.ctx.viewport(0, 0, this.w, this.h);
    old_buf = disp.new_TransBuf(disp.RP, this.w, this.h);
    new_eye = disp.new_TransEye(disp.IP, this.w, this.h);
    this.ctx.uniform3f(this.ctx.getUniformLocation(this.shader_program, "old_X"), old_buf.X[0], old_buf.X[1], old_buf.X[2]);
    this.ctx.uniform3f(this.ctx.getUniformLocation(this.shader_program, "old_Y"), old_buf.Y[0], old_buf.Y[1], old_buf.Y[2]);
    this.ctx.uniform3f(this.ctx.getUniformLocation(this.shader_program, "old_Z"), old_buf.Z[0], old_buf.Z[1], old_buf.Z[2]);
    this.ctx.uniform3f(this.ctx.getUniformLocation(this.shader_program, "old_O"), old_buf.O[0], old_buf.O[1], old_buf.O[2]);
    this.ctx.uniform3f(this.ctx.getUniformLocation(this.shader_program, "new_X"), new_eye.X[0], new_eye.X[1], new_eye.X[2]);
    this.ctx.uniform3f(this.ctx.getUniformLocation(this.shader_program, "new_Y"), new_eye.Y[0], new_eye.Y[1], new_eye.Y[2]);
    this.ctx.uniform3f(this.ctx.getUniformLocation(this.shader_program, "new_Z"), new_eye.Z[0], new_eye.Z[1], new_eye.Z[2]);
    this.ctx.uniform3f(this.ctx.getUniformLocation(this.shader_program, "new_O"), new_eye.O[0], new_eye.O[1], new_eye.O[2]);
    this.ctx.uniform1f(this.ctx.getUniformLocation(this.shader_program, "z_min"), disp.z_min);
    this.ctx.uniform1f(this.ctx.getUniformLocation(this.shader_program, "z_max"), disp.z_max);
    this.tex_rgba = this.get_tex(this.tex_rgba_id, disp.img_rgba, "tex", 0);
    this.tex_zzzz = this.get_tex(this.tex_zzzz_id, disp.img_zzzz, "zzz", 1);
    this.ctx.bindBuffer(this.ctx.ARRAY_BUFFER, this.pos_buf);
    return this.ctx.drawArrays(this.ctx.TRIANGLE_STRIP, 0, 4);
  };
  DisplayWebGl.prototype.get_tex = function(tex_id, img, name, n) {
    var res;
    res = this.load_texture(tex_id, img, n);
    this.ctx.uniform1i(this.ctx.getUniformLocation(this.shader_program, name), n);
    this.ctx.activeTexture([this.ctx.TEXTURE0, this.ctx.TEXTURE1][n]);
    this.ctx.bindTexture(this.ctx.TEXTURE_2D, res);
    return res;
  };
  DisplayWebGl.prototype.create_3D_context = function(canvas, opt_attribs) {
    var context, t, _i, _len, _ref, _results;
    _ref = ["experimental-webgl", "webgl", "webkit-3d", "moz-webgl"];
    _results = [];
    for (_i = 0, _len = _ref.length; _i < _len; _i++) {
      t = _ref[_i];
      try {
        context = canvas.getContext(t, opt_attribs);
        if (context != null) {
          return context;
        }
      } catch (error) {
        continue;
      }
    }
    return _results;
  };
  DisplayWebGl.prototype.init_shaders = function(vert_src, frag_src) {
    var attr, frag_shader, vert_shader;
    vert_shader = this.make_shader(this.ctx.VERTEX_SHADER, vert_src);
    frag_shader = this.make_shader(this.ctx.FRAGMENT_SHADER, frag_src);
    this.shader_program = this.ctx.createProgram();
    this.ctx.attachShader(this.shader_program, vert_shader);
    this.ctx.attachShader(this.shader_program, frag_shader);
    this.ctx.linkProgram(this.shader_program);
    if (!this.ctx.getProgramParameter(this.shader_program, this.ctx.LINK_STATUS)) {
      alert("unable to initialize shader");
    }
    this.ctx.useProgram(this.shader_program);
    attr = this.ctx.getAttribLocation(this.shader_program, "pos");
    this.ctx.enableVertexAttribArray(attr);
    return this.ctx.vertexAttribPointer(attr, 3, this.ctx.FLOAT, false, 0, 0);
  };
  DisplayWebGl.prototype.make_shader = function(kind, src) {
    var shader;
    shader = this.ctx.createShader(kind);
    this.ctx.shaderSource(shader, src);
    this.ctx.compileShader(shader);
    if (!this.ctx.getShaderParameter(shader, this.ctx.COMPILE_STATUS)) {
      alert(this.ctx.getShaderInfoLog(shader));
    }
    return shader;
  };
  DisplayWebGl.prototype.make_square_buf = function() {
    var pos_buf;
    pos_buf = this.ctx.createBuffer();
    this.ctx.bindBuffer(this.ctx.ARRAY_BUFFER, pos_buf);
    this.ctx.bufferData(this.ctx.ARRAY_BUFFER, new Float32Array([1.0, 1.0, 0.0, -1.0, 1.0, 0.0, 1.0, -1.0, 0.0, -1.0, -1.0, 0.0]), this.ctx.STATIC_DRAW);
    pos_buf.itemSize = 3;
    pos_buf.numItems = 4;
    return pos_buf;
  };
  DisplayWebGl.prototype.load_texture = function(texture, image, n) {
    this.ctx.activeTexture([this.ctx.TEXTURE0, this.ctx.TEXTURE1][n]);
    this.ctx.bindTexture(this.ctx.TEXTURE_2D, texture);
    this.ctx.texParameteri(this.ctx.TEXTURE_2D, this.ctx.TEXTURE_MIN_FILTER, this.ctx.NEAREST);
    this.ctx.texParameteri(this.ctx.TEXTURE_2D, this.ctx.TEXTURE_MAG_FILTER, this.ctx.NEAREST);
    this.ctx.texImage2D(this.ctx.TEXTURE_2D, 0, this.ctx.RGBA, this.ctx.RGBA, this.ctx.UNSIGNED_BYTE, image);
    return texture;
  };
  return DisplayWebGl;
})();
DisplayCanvas = (function() {
  function DisplayCanvas(canvas) {
    this.ctx = canvas.getContext('2d');
    this.want_fps = 50;
    this.size_disp_rect = 5;
  }
  DisplayCanvas.prototype.draw = function(disp) {
    var P_mas, P_mis, b, b_mm, d_mar, d_mir, div_m, e_mm, g, h, i, inv_z, lineargradient, new_D, new_P, new_eye, o, off_loc_image_data, old_buf, oz_dir, p1i0, r, r_x, r_y, rgba_data, rh, rw, s_mm, t0, t1, w, x_b, x_mas, x_md, x_mis, x_s, y_b, y_mas, y_md, y_mis, y_s, z, z_md_0, z_md_1, zu, zzzz_data, _ref, _ref2;
    w = disp.canvas.width;
    h = disp.canvas.height;
    lineargradient = this.ctx.createLinearGradient(0, 0, 0, h);
    lineargradient.addColorStop(0.0, "rgb( 0, 0, 0 )");
    lineargradient.addColorStop(0.5, "rgb( 0, 0, 40 )");
    lineargradient.addColorStop(1.0, "rgb( 0, 0, 150 )");
    this.ctx.fillStyle = lineargradient;
    this.ctx.fillRect(0, 0, w, h);
    if (disp.equal_obj(disp.IP, disp.RP)) {
      this.ctx.drawImage(disp.img_rgba, 0, 0, w, h);
      if (disp.nb_alt_contexts) {
        this.ctx.globalAlpha = disp.alpha_altc;
        this.ctx.drawImage(this.img_altc, 0, 0, w, h);
        return this.ctx.globalAlpha = 1.0;
      }
    } else {
      rgba_data = this.get_img_data(disp.img_rgba);
      zzzz_data = this.get_img_data(disp.img_zzzz);
      t0 = new Date().getTime();
      old_buf = disp.new_TransBuf(disp.RP, w, h);
      new_eye = disp.new_TransEye(disp.IP, w, h);
      inv_z = disp.dot_3(old_buf.Z, new_eye.Z) < 0;
      rw = w / this.size_disp_rect;
      rh = h / this.size_disp_rect;
      oz_dir = disp.nor_3(old_buf.Z);
      p1i0 = function(x) {
        return x + (x === 0);
      };
      off_loc_image_data = -4;
      for (r_y = 0, _ref = rh - 1; (0 <= _ref ? r_y <= _ref : r_y >= _ref); (0 <= _ref ? r_y += 1 : r_y -= 1)) {
        y_b = this.size_disp_rect * r_y;
        y_s = y_b + 0.5 * this.size_disp_rect;
        for (r_x = 0, _ref2 = rw - 1; (0 <= _ref2 ? r_x <= _ref2 : r_x >= _ref2); (0 <= _ref2 ? r_x += 1 : r_x -= 1)) {
          x_b = this.size_disp_rect * r_x;
          x_s = x_b + 0.5 * this.size_disp_rect;
          off_loc_image_data += 4;
          new_P = new_eye.pos(x_s, y_s);
          new_D = new_eye.dir(x_s, y_s);
          div_m = 1 / p1i0(disp.dot_3(new_D, oz_dir));
          d_mir = (disp.z_min - disp.dot_3(disp.sub_3(new_P, old_buf.O), oz_dir)) * div_m;
          d_mar = (disp.z_max - disp.dot_3(disp.sub_3(new_P, old_buf.O), oz_dir)) * div_m;
          P_mis = old_buf.proj([new_P[0] + d_mir * new_D[0], new_P[1] + d_mir * new_D[1], new_P[2] + d_mir * new_D[2]]);
          P_mas = old_buf.proj([new_P[0] + d_mar * new_D[0], new_P[1] + d_mar * new_D[1], new_P[2] + d_mar * new_D[2]]);
          x_mis = P_mis[0];
          y_mis = P_mis[1];
          x_mas = P_mas[0];
          y_mas = P_mas[1];
          if (x_mis < 0 && x_mas < 0) {
            continue;
          }
          if (x_mis >= w && x_mas >= w) {
            continue;
          }
          if (y_mis < 0 && y_mas < 0) {
            continue;
          }
          if (y_mis >= h && y_mas >= h) {
            continue;
          }
          s_mm = 3.0 / (Math.max(Math.abs(x_mas - x_mis), Math.abs(y_mas - y_mis)) + 1e-40);
          b_mm = 0.0;
          e_mm = 1.0;
          if (x_mis < x_mas) {
            if (x_mis < 0) {
              b_mm = Math.max(b_mm, (0 - x_mis) / p1i0(x_mas - x_mis));
            }
            if (x_mas > w - 1) {
              e_mm = Math.min(e_mm, (w - 1 - x_mis) / p1i0(x_mas - x_mis));
            }
          } else {
            if (x_mas < 0) {
              e_mm = Math.min(e_mm, (x_mis - 0) / p1i0(x_mis - x_mas));
            }
            if (x_mis > w - 1) {
              b_mm = Math.max(b_mm, (x_mis - w + 1) / p1i0(x_mis - x_mas));
            }
          }
          if (y_mis < y_mas) {
            if (y_mis < 0) {
              b_mm = Math.max(b_mm, (0 - y_mis) / p1i0(y_mas - y_mis));
            }
            if (y_mas > h - 1) {
              e_mm = Math.min(e_mm, (h - 1 - y_mis) / p1i0(y_mas - y_mis));
            }
          } else {
            if (y_mas < 0) {
              e_mm = Math.min(e_mm, (y_mis - 0) / p1i0(y_mis - y_mas));
            }
            if (y_mis > h - 1) {
              b_mm = Math.max(b_mm, (y_mis - h + 1) / p1i0(y_mis - y_mas));
            }
          }
          i = b_mm;
          while (i <= e_mm) {
            x_md = Math.ceil(x_mis + i * (x_mas - x_mis));
            y_md = Math.ceil(y_mis + i * (y_mas - y_mis));
            b = y_md * w + x_md;
            o = 4 * b;
            zu = zzzz_data[o];
            if (zu !== 255) {
              z = disp.z_min + zu * (disp.z_max - disp.z_min) / 254.0;
              z_md_0 = disp.z_min + (i - 2 * s_mm) * (disp.z_max - disp.z_min);
              z_md_1 = disp.z_min + (i + 3 * s_mm) * (disp.z_max - disp.z_min);
              if (z <= z_md_1 && z >= z_md_0) {
                r = rgba_data[o + 0];
                g = rgba_data[o + 1];
                b = rgba_data[o + 2];
                this.ctx.fillStyle = "rgb( " + r + ", " + g + ", " + b + " )";
                this.ctx.fillRect(x_b, y_b, this.size_disp_rect, this.size_disp_rect);
                break;
              }
            }
            i += s_mm;
          }
        }
      }
      return t1 = new Date().getTime() - t0;
    }
  };
  DisplayCanvas.prototype.get_img_data = function(img) {
    var ctx, src_pix;
    if (!(img.data != null)) {
      if (!(img.hc != null)) {
        img.hc = document.createElement("canvas");
        img.hc.style.display = "none";
        document.body.appendChild(img.hc);
      }
      img.hc.width = img.width;
      img.hc.height = img.height;
      ctx = img.hc.getContext('2d');
      ctx.drawImage(img, 0, 0);
      src_pix = ctx.getImageData(0, 0, img.width, img.height);
      img.data = src_pix.data;
    }
    return img.data;
  };
  return DisplayCanvas;
})();
ImgServer = (function() {
  var TransBuf, TransEye;
  ImgServer.prototype.session_id = 0;
  ImgServer.prototype.canvas_id = void 0;
  ImgServer.prototype.canvas = void 0;
  ImgServer.prototype.display = void 0;
  ImgServer.prototype.cmd_list = "";
  ImgServer.prototype.img_rgba = new Image();
  ImgServer.prototype.img_zzzz = new Image();
  ImgServer.prototype.img_ngrp = new Image();
  ImgServer.prototype.img_altc = new Image();
  ImgServer.prototype.z_min = 0;
  ImgServer.prototype.z_max = 0;
  ImgServer.prototype.IP = {};
  ImgServer.prototype.RP = {};
  ImgServer.prototype.delay_send = 100;
  function ImgServer(canvas_id, port, t) {
    var _base;
    this.canvas_id = canvas_id;
    this.port = port;
    if (t == null) {
      t = "...";
    }
    this.canvas = document.getElementById(this.canvas_id);
    this.canvas.img_server = this;
    if (t === "WebGl") {
      this.display = new DisplayWebGl(this.canvas);
    } else {
      this.display = new DisplayCanvas(this.canvas);
    }
    this.queue_img_server_cmd('set_session ' + this.canvas_id + '\n');
    this.queue_img_server_cmd('set_wh ' + this.canvas.width + ' ' + this.canvas.height + '\n');
    this.img_rgba.onload = __bind(function() {
      return this.img_rgba.data = void 0;
    }, this);
    this.img_zzzz.onload = __bind(function() {
      this.img_zzzz.data = void 0;
      return this.draw_img_on_canvas();
    }, this);
    this.canvas.onmousedown = __bind(function(evt) {
      return this.img_mouse_down(evt);
    }, this);
    this.canvas.onmousewheel = __bind(function(evt) {
      return this.img_mouse_wheel(evt);
    }, this);
    this.canvas.onmouseup = function(evt) {
      return this.onmousemove = null;
    };
    this.canvas.onmouseout = function(evt) {
      return this.onmousemove = null;
    };
    if (typeof (_base = this.canvas).addEventListener == "function") {
      _base.addEventListener("DOMMouseScroll", this.canvas.onmousewheel, false);
    }
  }
  ImgServer.prototype.render = function() {
    this.queue_img_server_cmd('render\n');
    return this.flush_img_server_cmd();
  };
  ImgServer.prototype.load_vtu = function(m) {
    return this.queue_img_server_cmd('load_vtu ' + m + '\n');
  };
  ImgServer.prototype.load_hdf = function(file, mesh) {
    return this.queue_img_server_cmd('load_hdf ' + file + ' ' + mesh + '\n');
  };
  ImgServer.prototype.fit = function() {
    return this.queue_img_server_cmd('fit\n');
  };
  ImgServer.prototype.set_XY = function(X, Y) {
    this.queue_img_server_cmd('set_X ' + X[0] + ' ' + X[1] + ' ' + X[2] + '\n');
    return this.queue_img_server_cmd('set_Y ' + Y[0] + ' ' + Y[1] + ' ' + Y[2] + '\n');
  };
  ImgServer.prototype.shrink = function(s) {
    return this.queue_img_server_cmd('shrink ' + s + '\n');
  };
  ImgServer.prototype.get_num_group_info = function(name) {
    return this.queue_img_server_cmd('get_num_group_info ' + name + '\n');
  };
  ImgServer.prototype.set_elem_filter = function(filter) {
    return this.queue_img_server_cmd('set_elem_filter ' + filter + '\n');
  };
  ImgServer.prototype.my_xml_http_request = function() {
    if (window.XMLHttpRequest) {
      return new XMLHttpRequest();
    }
    if (window.ActiveXObject) {
      return new ActiveXObject("Microsoft.XMLHTTP");
    }
    return alert("Votre navigateur ne supporte pas les objets XMLHTTPRequest...");
  };
  ImgServer.prototype.send_async_xml_http_request = function(url, data, func) {
    var xhr_object;
    xhr_object = this.my_xml_http_request();
    xhr_object.open("POST", url + "?" + this.session_id, true);
    xhr_object.onreadystatechange = function() {
      if (this.readyState === 4 && this.status === 200) {
        return func(this.responseText);
      }
    };
    return xhr_object.send(data);
  };
  ImgServer.prototype.queue_img_server_cmd = function(cmd) {
    return this.cmd_list += cmd;
  };
  ImgServer.prototype.flush_img_server_cmd = function() {
    this.send_async_xml_http_request("/img_server_" + this.port + "?" + this.session_id, this.cmd_list, (function(rep) {
      var c;
      c = {};
      eval(rep);
      if (c.err && c.err.length) {
        return alert(c.err);
      }
    }));
    return this.cmd_list = "";
  };
  TransEye = (function() {
    TransEye.prototype.X = [];
    TransEye.prototype.Y = [];
    TransEye.prototype.Z = [];
    TransEye.prototype.O = [];
    TransEye.prototype.p = void 0;
    TransEye.prototype.o_x = 0;
    TransEye.prototype.o_y = 0;
    function TransEye(d, w, h) {
      var c, mwh, sm3;
      mwh = Math.min(w, h);
      c = d.d / mwh;
      sm3 = function(x, t) {
        return [x[0] * t, x[1] * t, x[2] * t];
      };
      this.X = sm3(ImgServer.prototype.nor_3(d.X), c);
      this.Y = sm3(ImgServer.prototype.nor_3(d.Y), -c);
      this.Z = sm3(ImgServer.prototype.nor_3(ImgServer.prototype.cro_3(d.X, d.Y)), c);
      this.p = Math.tan(d.a / 2 * 3.14159265358979323846 / 180) / (mwh / 2);
      this.O = d.O;
      this.o_x = -w / 2;
      this.o_y = -h / 2;
    }
    TransEye.prototype.dir = function(x, y) {
      return ImgServer.prototype.nor_3([((x + this.o_x) * this.X[0] + (y + this.o_y) * this.Y[0]) * this.p + this.Z[0], ((x + this.o_x) * this.X[1] + (y + this.o_y) * this.Y[1]) * this.p + this.Z[1], ((x + this.o_x) * this.X[2] + (y + this.o_y) * this.Y[2]) * this.p + this.Z[2]]);
    };
    TransEye.prototype.pos = function(x, y) {
      return [this.O[0] + (x + this.o_x) * this.X[0] + (y + this.o_y) * this.Y[0], this.O[1] + (x + this.o_x) * this.X[1] + (y + this.o_y) * this.Y[1], this.O[2] + (x + this.o_x) * this.X[2] + (y + this.o_y) * this.Y[2]];
    };
    return TransEye;
  })();
  TransBuf = (function() {
    function TransBuf(d, w, h) {
      var c, mwh, sm3;
      mwh = Math.min(w, h);
      c = mwh / d.d;
      sm3 = function(x, t) {
        return [x[0] * t, x[1] * t, x[2] * t];
      };
      this.X = sm3(ImgServer.prototype.nor_3(d.X), c);
      this.Y = sm3(ImgServer.prototype.nor_3(d.Y), -c);
      this.Z = sm3(ImgServer.prototype.nor_3(ImgServer.prototype.cro_3(d.X, d.Y)), c);
      this.p = Math.tan(d.a / 2 * 3.14159265358979323846 / 180) / (mwh / 2);
      this.O = d.O;
      this.o_x = w / 2;
      this.o_y = h / 2;
    }
    TransBuf.prototype.proj = function(P) {
      var d, x, y, z;
      d = ImgServer.prototype.sub_3(P, this.O);
      x = ImgServer.prototype.dot_3(d, this.X);
      y = ImgServer.prototype.dot_3(d, this.Y);
      z = ImgServer.prototype.dot_3(d, this.Z);
      d = 1 / (1 + this.p * z);
      return [this.o_x + d * x, this.o_y + d * y, z];
    };
    return TransBuf;
  })();
  ImgServer.prototype.new_TransBuf = function(rp, w, h) {
    return new TransBuf(rp, w, h);
  };
  ImgServer.prototype.new_TransEye = function(rp, w, h) {
    return new TransEye(rp, w, h);
  };
  ImgServer.prototype.rotate_cam = function(x, y, z) {
    var R;
    R = this.s_to_w_vec(this.IP, [x, y, z]);
    if (!(this.C != null)) {
      this.C = [this.IP.O[0], this.IP.O[1], this.IP.O[2]];
    }
    this.IP.X = this.rot_3(this.IP.X, R);
    this.IP.Y = this.rot_3(this.IP.Y, R);
    return this.IP.O = this.add_3(this.C, this.rot_3(this.sub_3(this.IP.O, this.C), R));
  };
  ImgServer.prototype.img_mouse_down = function(evt) {
    var canvas;
    if (!(evt != null)) {
      evt = window.event;
    }
    canvas = document.getElementById(this.canvas_id);
    this.old_button = evt.which != null ? evt.which < 2 ? "LEFT" : (evt.which === 2 ? "MIDDLE" : "RIGHT") : evt.button < 2 ? "LEFT" : (evt.button === 4 ? "MIDDLE" : "RIGHT");
    this.canvas.onmousemove = __bind(function(evt) {
      return this.img_mouse_move(evt);
    }, this);
    this.old_x = evt.clientX - this.canvas.offsetLeft;
    this.old_y = evt.clientY - this.canvas.offsetTop;
    if (evt.ctrlKey) {
      document.getElementById("com").firstChild.data = this.get_num_group(evt.clientX, evt.clientY);
    }
    if (typeof evt.preventDefault == "function") {
      evt.preventDefault();
    }
    evt.returnValue = false;
    return false;
  };
  ImgServer.prototype.getLeft = function(l) {
    if (l.offsetParent != null) {
      return l.offsetLeft + this.getLeft(l.offsetParent);
    } else {
      return l.offsetLeft;
    }
  };
  ImgServer.prototype.getTop = function(l) {
    if (l.offsetParent != null) {
      return l.offsetTop + this.getTop(l.offsetParent);
    } else {
      return l.offsetTop;
    }
  };
  ImgServer.prototype.img_mouse_wheel = function(evt) {
    var O, P, X, Y, canvas, coeff, d, delta, mwh, x, y;
    if (!(evt != null)) {
      evt = window.event;
    }
    canvas = document.getElementById(this.canvas_id);
    delta = 0;
    if (evt.wheelDelta != null) {
      delta = evt.wheelDelta / 120.0;
      if (window.opera) {
        delta = -delta;
      }
    } else if (evt.detail) {
      delta = -evt.detail / 3.0;
    }
    coeff = Math.pow(1.2, delta);
    mwh = Math.min(this.canvas.width, this.canvas.height);
    x = (evt.clientX - this.getLeft(this.canvas) - this.canvas.width / 2) * this.IP.d / mwh;
    y = (this.canvas.height / 2 - evt.clientY + this.getTop(this.canvas)) * this.IP.d / mwh;
    O = this.IP.O;
    X = this.IP.X;
    Y = this.IP.Y;
    P = [O[0] + x * X[0] + y * Y[0], O[1] + x * X[1] + y * Y[1], O[2] + x * X[2] + y * Y[2]];
    this.IP.d /= coeff;
    for (d = 0; d <= 2; d++) {
      this.IP.O[d] = P[d] + (O[d] - P[d]) / coeff;
    }
    this.draw_img_on_canvas();
    if (typeof evt.preventDefault == "function") {
      evt.preventDefault();
    }
    evt.returnValue = false;
    return false;
  };
  ImgServer.prototype.img_mouse_move = function(evt) {
    var a, canvas, d, h, mwh, new_x, new_y, w, x, y;
    if (!(evt != null)) {
      evt = window.event;
    }
    canvas = document.getElementById(this.canvas_id);
    new_x = evt.clientX - this.canvas.offsetLeft;
    new_y = evt.clientY - this.canvas.offsetTop;
    if (new_x === this.old_x && new_y === this.old_y) {
      return false;
    }
    mwh = Math.min(this.canvas.width, this.canvas.height);
    if (this.old_button === "LEFT") {
      if (evt.shiftKey) {
        w = this.canvas.width;
        h = this.canvas.height;
        a = Math.atan2(new_y - h / 2.0, new_x - w / 2.0) - Math.atan2(this.old_y - h / 2.0, this.old_x - w / 2.0);
        this.rotate_cam(0.0, 0.0, -a);
      } else {
        x = 2.0 * (new_x - this.old_x) / mwh;
        y = 2.0 * (new_y - this.old_y) / mwh;
        this.rotate_cam(y, x, 0.0);
      }
    } else if (this.old_button === "MIDDLE") {
      x = this.IP.d * (new_x - this.old_x) / mwh;
      y = this.IP.d * (this.old_y - new_y) / mwh;
      for (d = 0; d <= 2; d++) {
        this.IP.O[d] -= x * this.IP.X[d] + y * this.IP.Y[d];
      }
    }
    this.draw_img_on_canvas();
    this.old_x = new_x;
    return this.old_y = new_y;
  };
  ImgServer.prototype.draw_img_on_canvas = function() {
    this.display.draw(this);
    if (!this.equal_obj(this.IP, this.RP)) {
      return this.restart_timer_for_src_update();
    }
  };
  ImgServer.prototype.restart_timer_for_src_update = function() {
    if (this.timer_for_src_update != null) {
      clearTimeout(this.timer_for_src_update);
    }
    return this.timer_for_src_update = setTimeout((__bind(function() {
      return this.update_img_src();
    }, this)), this.delay_send);
  };
  ImgServer.prototype.update_img_src = function() {
    this.queue_img_server_cmd('set_O ' + this.IP.O[0] + ' ' + this.IP.O[1] + ' ' + this.IP.O[2] + '\n');
    this.queue_img_server_cmd('set_X ' + this.IP.X[0] + ' ' + this.IP.X[1] + ' ' + this.IP.X[2] + '\n');
    this.queue_img_server_cmd('set_Y ' + this.IP.Y[0] + ' ' + this.IP.Y[1] + ' ' + this.IP.Y[2] + '\n');
    this.queue_img_server_cmd('set_d ' + this.IP.d + '\n');
    this.queue_img_server_cmd('set_a ' + this.IP.a + '\n');
    this.queue_img_server_cmd('render\n');
    return this.flush_img_server_cmd();
  };
  ImgServer.prototype.equal_obj = function( a, b ) { // return true if objects are deeply equal
        if( typeof( a ) != 'object' || a == null )
            return a == b;
        for( i in a )
            if ( ! ImgServer.prototype.equal_obj( a[ i ], b[ i ] ) )
                return 0;
        return 1;
    };
  ImgServer.prototype.sub_3 = function(a, b) {
    return [a[0] - b[0], a[1] - b[1], a[2] - b[2]];
  };
  ImgServer.prototype.add_3 = function(a, b) {
    return [a[0] + b[0], a[1] + b[1], a[2] + b[2]];
  };
  ImgServer.prototype.mus_3 = function(a, b) {
    return [a * b[0], a * b[1], a * b[2]];
  };
  ImgServer.prototype.dot_3 = function(a, b) {
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
  };
  ImgServer.prototype.cro_3 = function(a, b) {
    return [a[1] * b[2] - a[2] * b[1], a[2] * b[0] - a[0] * b[2], a[0] * b[1] - a[1] * b[0]];
  };
  ImgServer.prototype.len_3 = function(a) {
    return Math.sqrt(a[0] * a[0] + a[1] * a[1] + a[2] * a[2]);
  };
  ImgServer.prototype.nor_3 = function(a) {
    var l;
    l = this.len_3(a) + 1e-40;
    return [a[0] / l, a[1] / l, a[2] / l];
  };
  ImgServer.prototype.rot_3 = function(V, R) {
    var a, c, s, x, y, z;
    a = this.len_3(R) + 1e-40;
    x = R[0] / a;
    y = R[1] / a;
    z = R[2] / a;
    c = Math.cos(a);
    s = Math.sin(a);
    return [(x * x + (1 - x * x) * c) * V[0] + (x * y * (1 - c) - z * s) * V[1] + (x * z * (1 - c) + y * s) * V[2], (y * x * (1 - c) + z * s) * V[0] + (y * y + (1 - y * y) * c) * V[1] + (y * z * (1 - c) - x * s) * V[2], (z * x * (1 - c) - y * s) * V[0] + (z * y * (1 - c) + x * s) * V[1] + (z * z + (1 - z * z) * c) * V[2]];
  };
  ImgServer.prototype.s_to_w_vec = function(cd, V) {
    var Z;
    Z = this.cro_3(cd.Y, cd.X);
    return [V[0] * cd.X[0] + V[1] * cd.Y[0] + V[2] * Z[0], V[0] * cd.X[1] + V[1] * cd.Y[1] + V[2] * Z[1], V[0] * cd.X[2] + V[1] * cd.Y[2] + V[2] * Z[2]];
  };
  return ImgServer;
})();