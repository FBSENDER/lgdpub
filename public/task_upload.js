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
        suffix = filename.substring(pos).toLocaleLowerCase();
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

function set_upload_param(up, filename, ret, file)
{
    g_object_name = 'task/';
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
    if(file != null)
      $("#file_" + file.id).data("img", g_object_name);
    up.start();
}

var uploader = new plupload.Uploader({
  runtimes : 'html5,flash,silverlight,html4',
  browse_button : 'selectfiles', 
  multi_selection: true,
  container: document.getElementById('container'),
  flash_swf_url : '/lib/plupload-2.1.2/js/Moxie.swf',
  silverlight_xap_url : '/lib/plupload-2.1.2/js/Moxie.xap',
  url : 'http://oss.aliyuncs.com',
  filters: {
    mime_types : [
      { title : "Image files", extensions : "jpg,gif,png" }
    ],
    prevent_duplicates: true
  },
  resize: {
    width: 600,
    crop: false,
    preserve_headers: true
  },
  
  init: {
    PostInit: function() {
      $("#ossfile").html('');
      $("#postfiles").click(function(){
        if($("#files > p").size() > 5){
          alert("最多选择5张图片");
          return false;
        }
        set_upload_param(uploader, '', false, null);
        return false;
      });
    },
    
    FilesAdded: function(up, files) {
      plupload.each(files, function(file) {
        $("#files").append('<p id="file_'+ file.id +'" data-id="' + file.id + '"class="text-center text-gray my-2 py-2" data-img=""><small>' + file.name + '('+ plupload.formatSize(file.size) + ')  未上传</small><button class="btn btn-default btn-action btn-sm float-right" onclick="file_remove(this);"><i class="icon icon-cross"></i></button></p>');
      });
      $("#pro").removeClass('hide');
      $("#file_progress").css("width", '0');
    },
    
    BeforeUpload: function(up, file) {
      set_upload_param(up, file.name, true, file);
    },
    
    UploadProgress: function(up, file) {
      $("#pro").removeClass('hide');
      $("#file_progress").css("width", file.percent + '%');
    },
    
    FileUploaded: function(up, file, info) {
          if (info.status == 200)
          {
            $("#file_" + file.id + " > small").html(file.name + '('+ plupload.formatSize(file.size) + ")  上传完成");
            file_list.push($("#file_" + file.id).data("img"));
            $("#in_imgs").val(file_list.join(','));
          }
          else
          {
          } 
    },
    
    Error: function(up, err) {
      $("#message").html(err.response);
      $("#message").removeClass('hide');
      $("#in_avatar").val('');
    }
  }
});

var file_list = [];
uploader.init();
function file_remove(e){
  file_list = jQuery.grep(file_list, function(value) {
      return value != $(e).parent().data("img");
  });
  $("#in_imgs").val(file_list.join(','));
  uploader.removeFile(uploader.getFile($(e).parent().data("id")));
  $(e).parent().remove();
  if($("#files > p").size() == 0){
    $("#pro").addClass('hide');
  }
}
