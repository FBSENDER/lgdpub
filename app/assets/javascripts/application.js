// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require_tree .

function create_other_reset(){
  $("#in_phone").removeClass("is-error");
  $("#in_phone_p").html("").addClass("hide");
  $("#message").addClass("hide");
}

function create_ershou_reset(){
  $("#in_phone").removeClass("is-error");
  $("#in_phone_p").html("").addClass("hide");
  $("#message").addClass("hide");
}

function create_jianzhi_reset(){
  $("#in_phone").removeClass("is-error");
  $("#in_phone_p").html("").addClass("hide");
  $("#message").addClass("hide");
}
function create_daike_reset(){
  $("#in_phone").removeClass("is-error");
  $("#in_phone_p").html("").addClass("hide");
  $("#in_class_date").removeClass("is-error");
  $("#in_class_date_p").html("").addClass("hide");
  $("#message").addClass("hide");
}
function create_kuaidi_reset(){
  $("#in_phone").removeClass("is-error");
  $("#in_phone_p").html("").addClass("hide");
  $("#in_company").removeClass("is-error");
  $("#in_company_p").html("").addClass("hide");
  $("#in_from").removeClass("is-error");
  $("#in_from_p").html("").addClass("hide");
  $("#in_to").removeClass("is-error");
  $("#in_to_p").html("").addClass("hide");
  $("#message").addClass("hide");
}
function sign_up_reset(){
  $("#in_phone").removeClass("is-error");
  $("#in_phone_p").html("").addClass("hide");
  $("#in_password").removeClass("is-error");
  $("#in_password_p").html("").addClass("hide");
  $("#in_password_confirm").removeClass("is-error");
  $("#in_password_confirm_p").html("").addClass("hide");
  $("#in_code").removeClass("is-error");
  $("#in_code_p").html("").addClass("hide");
  $("#message").html("").addClass("hide");
}
function sign_in_reset(){
  $("#in_phone").removeClass("is-error");
  $("#in_phone_p").html("").addClass("hide");
  $("#in_password").removeClass("is-error");
  $("#in_password_p").html("").addClass("hide");
  $("#message").html("").addClass("hide");
}
function send_check_code(phone_input){
  var $phone = $("#"+phone_input);
  var phone = $.trim($phone.val());
  var r = check_phone(phone);
  if(r != ""){
    $phone.addClass("is-error");
    $("#" + phone_input + "_p").html(r).removeClass("hide");
    return false;
  }
  else{
    $phone.removeClass("is-error");
    $("#" + phone_input + "_p").html("").addClass("hide");
  }
  var c = get_check_code();
  $("#in_code_confirm").val(c);
  $("#sending_code").removeClass("hide");
  $("#send_code").addClass("hide");
  send_check_code_count_down(60);
  $.get("/account/send_code",{phone: phone, code: c}, function(data){
  });
}
function send_check_code_count_down(num){
  $("#sending_code").html("重新发送" + num + "秒");
  if(num == 0){
    $("#send_code").removeClass("hide");
    $("#sending_code").addClass("hide");
    return;
  }
  setTimeout("send_check_code_count_down(" + (num -1) + ")", 1000);
}
function sign_up(){
  sign_up_reset();
  var phone = $.trim($("#in_phone").val());
  var password = $.trim($("#in_password").val());
  var password_confirm = $.trim($("#in_password_confirm").val());
  var code = $.trim($("#in_code").val());
  var code_confirm = $.trim($("#in_code_confirm").val());
  var r = check_phone(phone);
  if(r != ""){
    $("#in_phone").addClass("is-error");
    $("#in_phone_p").html(r).removeClass("hide");
    return false;
  }
  r = check_password(password);
  if(r != ""){
    $("#in_password").addClass("is-error");
    $("#in_password_p").html(r).removeClass("hide");
    return false;
  }
  r = check_password_confirm(password,password_confirm);
  if(r != ""){
    $("#in_password_confirm").addClass("is-error");
    $("#in_password_confirm_p").html(r).removeClass("hide");
    return false;
  }
  r = check_code(code, code_confirm);
  if(r != ""){
    $("#in_code").addClass("is-error");
    $("#in_code_p").html(r).removeClass("hide");
    return false;
  }
  return true;
}

function sign_in(){
  sign_in_reset();
  var phone = $.trim($("#in_phone").val());
  var password = $.trim($("#in_password").val());
  var r = check_phone(phone);
  if(r != ""){
    $("#in_phone").addClass("is-error");
    $("#in_phone_p").html(r).removeClass("hide");
    return false;
  }
  r = check_password(password);
  if(r != ""){
    $("#in_password").addClass("is-error");
    $("#in_password_p").html(r).removeClass("hide");
    return false;
  }
  return true;
}

function create_other(){
  create_other_reset();
  var title = $.trim($("#in_title").val());
  var subtitle = $.trim($("#in_subtitle").val());
  var phone = $.trim($("#in_phone").val());
  var qq = $.trim($("#in_qq").val());
  var wx = $.trim($("#in_wx").val());
  if(title == ""){
    $("#message").children("p").html("请输入任务概要");
    $("#message").removeClass("hide");
    return false;
  }
  if(subtitle == ""){
    $("#message").children("p").html("请输入任务详情");
    $("#message").removeClass("hide");
    return false;
  }
  if(phone == "" && qq == "" && wx == ""){
    $("#message").children("p").html("至少留一种联系方式");
    $("#message").removeClass("hide");
    return false;
  }
  if(phone != ""){
    var r = check_phone(phone);
    if(r != ""){
      $("#in_phone").addClass("is-error");
      $("#in_phone_p").html(r).removeClass("hide");
      return false;
    }
  }
  return true;
}
function create_ershou(){
  create_ershou_reset();
  var content = $.trim($("#in_content").val());
  var price = $.trim($("#in_price").val());
  var detail = $.trim($("#in_detail").val());
  var imgs = $.trim($("#in_imgs").val());
  var phone = $.trim($("#in_phone").val());
  var qq = $.trim($("#in_qq").val());
  var wx = $.trim($("#in_wx").val());
  if(imgs == ""){
    $("#message").children("p").html("请上传图片");
    $("#message").removeClass("hide");
    return false;
  }
  if(content == ""){
    $("#message").children("p").html("请输入二手物品");
    $("#message").removeClass("hide");
    return false;
  }
  if(price == ""){
    $("#message").children("p").html("请输入价格");
    $("#message").removeClass("hide");
    return false;
  }
  if(detail == ""){
    $("#message").children("p").html("请输入物品描述");
    $("#message").removeClass("hide");
    return false;
  }
  if(phone == "" && qq == "" && wx == ""){
    $("#message").children("p").html("至少留一种联系方式");
    $("#message").removeClass("hide");
    return false;
  }
  if(phone != ""){
    var r = check_phone(phone);
    if(r != ""){
      $("#in_phone").addClass("is-error");
      $("#in_phone_p").html(r).removeClass("hide");
      return false;
    }
  }
  return true;
}

function create_jianzhi(){
  create_jianzhi_reset();
  var content = $.trim($("#in_content").val());
  var price = $.trim($("#in_price").val());
  var place = $.trim($("#in_place").val());
  var work_time = $.trim($("#in_work_time").val());
  var phone = $.trim($("#in_phone").val());
  var qq = $.trim($("#in_qq").val());
  var wx = $.trim($("#in_wx").val());
  if(content == ""){
    $("#message").children("p").html("请输入兼职类型");
    $("#message").removeClass("hide");
    return false;
  }
  if(place == ""){
    $("#message").children("p").html("请输入工作地点");
    $("#message").removeClass("hide");
    return false;
  }
  if(work_time == ""){
    $("#message").children("p").html("请输入工作时段");
    $("#message").removeClass("hide");
    return false;
  }
  if(price == ""){
    $("#message").children("p").html("请输入薪资");
    $("#message").removeClass("hide");
    return false;
  }
  if(phone == "" && qq == "" && wx == ""){
    $("#message").children("p").html("至少留一种联系方式");
    $("#message").removeClass("hide");
    return false;
  }
  if(phone != ""){
    var r = check_phone(phone);
    if(r != ""){
      $("#in_phone").addClass("is-error");
      $("#in_phone_p").html(r).removeClass("hide");
      return false;
    }
  }
  return true;
}
function create_kuaidi(){
  create_kuaidi_reset();
  var company = $.trim($("#in_company").val());
  var from = $.trim($("#in_from").val());
  var to = $.trim($("#in_to").val());
  var phone = $.trim($("#in_phone").val());
  var qq = $.trim($("#in_qq").val());
  var wx = $.trim($("#in_wx").val());
  if(company == ""){
    $("#in_company").addClass("is-error");
    $("#in_company_p").html("请输入快递公司").removeClass("hide");
    return false;
  }
  if(from == ""){
    $("#in_from").addClass("is-error");
    $("#in_from_p").html("请输入取件地点").removeClass("hide");
    return false;
  }
  if(to == ""){
    $("#in_to").addClass("is-error");
    $("#in_to_p").html("请输入送件地点").removeClass("hide");
    return false;
  }
  if(phone == "" && qq == "" && wx == ""){
    $("#message").children("p").html("至少留一种联系方式");
    $("#message").removeClass("hide");
    return false;
  }
  if(phone != ""){
    var r = check_phone(phone);
    if(r != ""){
      $("#in_phone").addClass("is-error");
      $("#in_phone_p").html(r).removeClass("hide");
      return false;
    }
  }
  return true;
}

function create_daike(){
  create_daike_reset();
  var class_date = $.trim($("#in_class_date").val());
  var class_time = $.trim($("#in_class_time").val());
  var class_count = $.trim($("#in_class_count").val());
  var phone = $.trim($("#in_phone").val());
  var qq = $.trim($("#in_qq").val());
  var wx = $.trim($("#in_wx").val());
  if(class_date == ""){
    $("#in_class_date").addClass("is-error");
    $("#in_class_date_p").html("请输入代课日期").removeClass("hide");
    return false;
  }
  if(phone == "" && qq == "" && wx == ""){
    $("#message").children("p").html("至少留一种联系方式");
    $("#message").removeClass("hide");
    return false;
  }
  if(phone != ""){
    var r = check_phone(phone);
    if(r != ""){
      $("#in_phone").addClass("is-error");
      $("#in_phone_p").html(r).removeClass("hide");
      return false;
    }
  }
  return true;
}

function do_feedback(){
  var content = $.trim($("#content").val());
  if(content == ""){
    return false;
  }
  return true;
}
$(function(){
  $(document).on('scroll', function(){
    var _top = $(document).scrollTop();
    if(_top >= 100){
      $("div.filter-nav").addClass('fixed');
    }
    else{
      $("div.filter-nav").removeClass('fixed');
    }
  });
});
