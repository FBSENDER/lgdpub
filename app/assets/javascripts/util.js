function check_phone(phone){
  if(phone == ''){
    return "请输入手机号";
  }
  if (!/^(14[0-9]|13[0-9]|15[0-9]|17[0-9]|18[0-9])\d{8}$$/.test(phone)) {
    return "请输入正确的手机号码";
  }
  return "";
}

function check_password(password){
  if(password.length < 6 || password.length > 12)
    return "请输入6-12位密码";
  return "";
}

function check_password_confirm(p1, p2){
  if(p1 != p2)
    return "两次密码输入不一致";
  return "";
}
function check_code(c1, c2){
  if(c1.length != 4)
    return "验证码不正确";
  if(c1 != c2)
    return "验证码不正确";
  return "";
}
function get_check_code(){
  var c = Math.floor(Math.random() * 10000);
  if(c < 1000)
    c += 1000;
  return c;
}
function toast_hide(e){
  $(e).parent(".toast").addClass("hide");
}
