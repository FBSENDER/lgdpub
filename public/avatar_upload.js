accessid= $("#aid").data("id");
accesskey= $("#asecrete").data("id");
host = 'http://lgdpub.oss-cn-beijing.aliyuncs.com';

now = timestamp = Date.parse(new Date()) / 1000; 

var policyText = {
    "expiration": "2020-01-01T12:00:00.000Z", //设置该Policy的失效时间，超过这个失效时间之后，就没有办法通过这个policy上传文件了
    "conditions": [
    ["content-length-range", 0, 1048576000] // 设置上传文件的大小限制
    ]
};

var policyBase64 = Base64.encode(JSON.stringify(policyText))
message = policyBase64
var bytes = Crypto.HMAC(Crypto.SHA1, message, accesskey, { asBytes: true }) ;
var signature = Crypto.util.bytesToBase64(bytes);

function random_string(len) {
　　len = len || 32;
　　var chars = 'ABCDEFGHJKMNPQRSTWXYZabcdefhijkmnprstwxyz2345678';   
　　var maxPos = chars.length;
　　var pwd = '';
　　for (i = 0; i < len; i++) {
    　　pwd += chars.charAt(Math.floor(Math.random() * maxPos));
    }
    return pwd;
}

function get_suffix(filename) {
    pos = filename.lastIndexOf('.')
    suffix = ''
    if (pos != -1) {
        suffix = filename.substring(pos)
    }
    return suffix;
}

function calculate_object_name(filename)
{
    suffix = get_suffix(filename)
    return (random_string(10) + suffix);
}

function get_uploaded_object_name(filename)
{
        return g_object_name
}

function set_upload_param(up, filename, ret)
{
    g_object_name = 'avatar/';
    if (filename != '') {
        g_object_name += $("#account").data("id") + "_" + calculate_object_name(filename);
    }
    new_multipart_params = {
        'key' : g_object_name,
        'policy': policyBase64,
        'OSSAccessKeyId': accessid, 
        'success_action_status' : '200', //让服务端返回200,不然，默认会返回204
        'signature': signature,
    };

    up.setOption({
        'url': host,
        'multipart_params': new_multipart_params
    });

    $("#in_avatar").val('http://lgdpub.oss-cn-beijing.aliyuncs.com/' + g_object_name);
    up.start();
}

var uploader = new plupload.Uploader({
  runtimes : 'html5,flash,silverlight,html4',
  browse_button : 'selectfiles', 
  //multi_selection: false,
  container: document.getElementById('container'),
  flash_swf_url : '/lib/plupload-2.1.2/js/Moxie.swf',
  silverlight_xap_url : '/lib/plupload-2.1.2/js/Moxie.xap',
  url : 'http://oss.aliyuncs.com',
  
  init: {
    PostInit: function() {
      $("#ossfile").html('');
      $("#postfiles").click(function(){
        set_upload_param(uploader, '', false);
        return false;
      });
    },
    
    FilesAdded: function(up, files) {
      plupload.each(files, function(file) {
        $("#ossfile").html(file.name + '('+ plupload.formatSize(file.size) + ')');
        $("#ossfile").removeClass('hide');
        $("#pro").removeClass('hide');
      });
    },
    
    BeforeUpload: function(up, file) {
      set_upload_param(up, file.name, true);
    },
    
    UploadProgress: function(up, file) {
      $("#file_progress").css("width", file.percent + '%');
    },
    
    FileUploaded: function(up, file, info) {
          if (info.status == 200)
          {
            $("#ossfile").html('上传完成');
            $("#avatar").attr("src", $("#in_avatar").val());
          }
          else
          {
            $("#ossfile").html(info.response);
            $("#in_avatar").val('');
          } 
    },
    
    Error: function(up, err) {
      $("#message").html(err.response);
      $("#message").removeClass('hide');
      $("#in_avatar").val('');
    }
  }
});

uploader.init();
