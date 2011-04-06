var ImgServer;
var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };
ImgServer = (function() {
  var TransBuf, TransEye;
  ImgServer.prototype.session_id = 0;
  ImgServer.prototype.canvas_id = "";
  ImgServer.prototype.canvas = void 0;
  ImgServer.prototype.port = "00";
  ImgServer.prototype.cmd_list = "";
  ImgServer.prototype.mesh_list = [];
  ImgServer.prototype.want_fps = 50;
  ImgServer.prototype.size_disp_rect = 5;
  ImgServer.prototype.delay_send = 100;
  ImgServer.prototype.old_x = 0;
  ImgServer.prototype.old_y = 0;
  ImgServer.prototype.old_button = "";
  ImgServer.prototype.img_rgba = new Image();
  ImgServer.prototype.img_zzzz = new Image();
  ImgServer.prototype.img_ngrp = new Image();
  ImgServer.prototype.img_altc = new Image();
  ImgServer.prototype.hidden_src_canvas = [];
  ImgServer.prototype.z_min = 0;
  ImgServer.prototype.z_max = 0;
  ImgServer.prototype.IP = {};
  ImgServer.prototype.RP = {};
  function ImgServer(canvas_id, port) {
    var hc, i, _base;
    this.canvas_id = canvas_id;
    this.port = port;
    this.canvas = document.getElementById(this.canvas_id);
    this.canvas.img_server = this;
    this.queue_img_server_cmd('set_session ' + this.canvas_id + '\n');
    this.queue_img_server_cmd('set_wh ' + this.canvas.width + ' ' + this.canvas.height + '\n');
    this.img_rgba.onload = __bind(function() {
      this.img_rgba.data = void 0;
      this.get_img_data(this.img_rgba, this.hidden_src_canvas[0]);
      return this.draw_img_on_canvas();
    }, this);
    this.img_zzzz.onload = __bind(function() {
      this.img_zzzz.data = void 0;
      return this.get_img_data(this.img_zzzz, this.hidden_src_canvas[1]);
    }, this);
    this.img_ngrp.onload = __bind(function() {
      this.img_ngrp.data = void 0;
      return this.get_img_data(this.img_ngrp, this.hidden_src_canvas[2]);
    }, this);
    this.img_altc.onload = __bind(function() {
      return this.img_altc.data = void 0;
    }, this);
    this.alpha_altc = 0.5;
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
    if (typeof (_base = this.canvas).addEventListener === "function") {
      _base.addEventListener("DOMMouseScroll", this.canvas.onmousewheel, false);
    }
    for (i = 0; i <= 3; i++) {
      hc = document.createElement("canvas");
      hc.style.display = "none";
      document.body.appendChild(hc);
      this.hidden_src_canvas.push(hc);
    }
    this.hc_tmp = this.hidden_src_canvas[3];
    this.hc_tmp.width = 0;
  }
  ImgServer.prototype.render = function() {
    this.queue_img_server_cmd('render\n');
    return this.flush_img_server_cmd();
  };
  ImgServer.prototype.color_by_field = function(name, num_comp) {
    if (num_comp == null) {
      num_comp = 0;
    }
    this.queue_img_server_cmd('set_num_comp ' + num_comp + "\n");
    return this.queue_img_server_cmd("color_by " + name + "\n");
  };
  ImgServer.prototype.get_num_group_info = function(name) {
    return this.queue_img_server_cmd('get_num_group_info ' + name + '\n');
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
  ImgServer.prototype.rot_img = function(x, y, z) {
    this.rotate_cam(x, y, z);
    return this.update_img_src();
  };
  ImgServer.prototype.set_elem_filter = function(filter) {
    return this.queue_img_server_cmd('set_elem_filter ' + filter + '\n');
  };
  ImgServer.prototype.num_context_next_cmd = function(num) {
    return this.queue_img_server_cmd('num_context_next_cmd ' + num + '\n');
  };
  TransEye = (function() {
    TransEye.prototype.X = [];
    TransEye.prototype.Y = [];
    TransEye.prototype.Z = [];
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
  ImgServer.prototype.get_num_group = function(x, y) {
    var ngrp_data, o;
    x -= this.getLeft(this.canvas);
    y -= this.getTop(this.canvas);
    o = 4 * (y * this.canvas.width + x);
    ngrp_data = this.get_img_data(this.img_ngrp, this.hidden_src_canvas[2]);
    return ngrp_data[o + 0] + 256 * ngrp_data[o + 1] + 256 * 256 * ngrp_data[o + 2];
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
      alert(this.get_num_group(evt.clientX, evt.clientY));
    }
    if (typeof evt.preventDefault === "function") {
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
    if (typeof evt.preventDefault === "function") {
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
  ImgServer.prototype.get_img_data = function(img, hc) {
    var ctx, src_pix;
    if (!(img.data != null)) {
      hc.width = img.width;
      hc.height = img.height;
      ctx = hc.getContext('2d');
      ctx.drawImage(img, 0, 0);
      src_pix = ctx.getImageData(0, 0, img.width, img.height);
      img.data = src_pix.data;
    }
    return img.data;
  };
  ImgServer.prototype.draw_img_on_canvas = function() {
    var P_mas, P_mis, b, b_mm, ctx, d_mar, d_mir, div_m, e_mm, h, i, inv_z, lineargradient, mwh, new_D, new_P, new_eye, o, off_loc_image_data, old_buf, oz_dir, p1i0, rgba_data, rh, rw, rx, ry, s_mm, t0, t1, w, x_mas, x_md, x_mis, x_s, y_mas, y_md, y_mis, y_s, z, z_md_0, z_md_1, zu, zzzz_data, _ref, _ref2, _ref3;
    w = this.canvas.width;
    h = this.canvas.height;
    mwh = Math.min(w, h);
    ctx = this.canvas.getContext('2d');
    lineargradient = ctx.createLinearGradient(0, 0, 0, h);
    lineargradient.addColorStop(0.0, "rgb( 0, 0, 0 )");
    lineargradient.addColorStop(0.5, "rgb( 0, 0, 40 )");
    lineargradient.addColorStop(1.0, "rgb( 0, 0, 150 )");
    ctx.fillStyle = lineargradient;
    ctx.fillRect(0, 0, w, h);
    if (this.equal_obj(this.IP, this.RP)) {
      ctx.drawImage(this.img_rgba, 0, 0, w, h);
      if (this.nb_alt_contexts) {
        ctx.globalAlpha = this.alpha_altc;
        ctx.drawImage(this.img_altc, 0, 0, w, h);
        return ctx.globalAlpha = 1.0;
      }
    } else {
      rgba_data = this.get_img_data(this.img_rgba, this.hidden_src_canvas[0]);
      zzzz_data = this.get_img_data(this.img_zzzz, this.hidden_src_canvas[1]);
      t0 = new Date().getTime();
      old_buf = new TransBuf(this.RP, w, h);
      new_eye = new TransEye(this.IP, w, h);
      inv_z = this.dot_3(old_buf.Z, new_eye.Z) < 0;
      rw = w / this.size_disp_rect;
      rh = h / this.size_disp_rect;
      if (this.hc_tmp.width !== rw || this.hc_tmp.height !== rh) {
        this.hc_tmp.width = rw;
        this.hc_tmp.height = rh;
        this.ctx_tmp = this.hc_tmp.getContext('2d');
        this.loc_img = this.ctx_tmp.createImageData(rw, rh);
        this.loc_img_dat = this.loc_img.data;
      } else {
        for (i = 0, _ref = rw * rh; (0 <= _ref ? i <= _ref : i >= _ref); (0 <= _ref ? i += 1 : i -= 1)) {
          this.loc_img_dat[4 * i + 3] = 0;
        }
      }
      oz_dir = this.nor_3(old_buf.Z);
      p1i0 = function(x) {
        return x + (x === 0);
      };
      off_loc_image_data = -4;
      for (ry = 0, _ref2 = rh - 1; (0 <= _ref2 ? ry <= _ref2 : ry >= _ref2); (0 <= _ref2 ? ry += 1 : ry -= 1)) {
        y_s = this.size_disp_rect * (ry + 0.5);
        for (rx = 0, _ref3 = rw - 1; (0 <= _ref3 ? rx <= _ref3 : rx >= _ref3); (0 <= _ref3 ? rx += 1 : rx -= 1)) {
          x_s = this.size_disp_rect * (rx + 0.5);
          off_loc_image_data += 4;
          new_P = new_eye.pos(x_s, y_s);
          new_D = new_eye.dir(x_s, y_s);
          div_m = 1 / p1i0(this.dot_3(new_D, oz_dir));
          d_mir = (this.z_min - this.dot_3(this.sub_3(new_P, old_buf.O), oz_dir)) * div_m;
          d_mar = (this.z_max - this.dot_3(this.sub_3(new_P, old_buf.O), oz_dir)) * div_m;
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
              z = this.z_min + zu * (this.z_max - this.z_min) / 254.0;
              z_md_0 = this.z_min + (i - 2 * s_mm) * (this.z_max - this.z_min);
              z_md_1 = this.z_min + (i + 3 * s_mm) * (this.z_max - this.z_min);
              if (z <= z_md_1 && z >= z_md_0) {
                this.loc_img_dat[off_loc_image_data + 0] = rgba_data[o + 0];
                this.loc_img_dat[off_loc_image_data + 1] = rgba_data[o + 1];
                this.loc_img_dat[off_loc_image_data + 2] = rgba_data[o + 2];
                this.loc_img_dat[off_loc_image_data + 3] = rgba_data[o + 3];
                break;
              }
            }
            i += s_mm;
          }
        }
      }
      this.ctx_tmp.putImageData(this.loc_img, 0, 0);
      ctx.drawImage(this.hc_tmp, 0, 0, w, h);
      t1 = new Date().getTime() - t0;
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
  return ImgServer;
})();