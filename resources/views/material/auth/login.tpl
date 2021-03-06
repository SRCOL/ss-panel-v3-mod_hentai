{include file='header.tpl'}

<main class="content">
		<div class="container">
			<div class="row">
				<div class="col-lg-4 col-lg-push-4 col-sm-6 col-sm-push-3">
					<section class="content-inner">
						<nav class="tab-nav margin-top-no">
							<ul class="nav nav-justified">

							{if $config['enable_telegram'] == 'true'}
								<li>
									<a class="waves-attach" data-toggle="tab" href="#qrcode_login">	TG掃碼登錄</a>
								</li>
                               {/if}
                              	<li class="active">
							   <a class="waves-attach" data-toggle="tab" href="#passwd_login">密碼登錄</a>
								</li>
                              {if $config['enable_telegram'] == 'true'}
								<li>
									<a class="waves-attach" data-toggle="tab" href="#number_login">	TG數字登錄</a>
								</li>
								{/if}
							</ul>
						</nav>
						<div class="card-inner">
							<div class="tab-content">
								<div class="tab-pane fade active in" id="passwd_login">
									<div class="card">
										<div class="card-main">
											<div class="card-header">
												<div class="card-inner">
													<h1 class="card-heading">登錄到用戶中心</h1>
												</div>
											</div>
											<div class="card-inner">
												<form action="javascript:void(0);"  method="POST">


													<div class="form-group form-group-label">
														<div class="row">
															<div class="col-md-10 col-md-push-1">
																<label class="floating-label" for="email">郵箱</label>
																<input class="form-control" id="email" type="text" name="Email">
															</div>
														</div>
													</div>
													<div class="form-group form-group-label">
														<div class="row">
															<div class="col-md-10 col-md-push-1">
																<label class="floating-label" for="passwd">密碼</label>
																<input class="form-control" id="passwd" type="password" name="Password">
															</div>
														</div>
													</div>



													{if $geetest_html != null}
														<div class="form-group form-group-label">
															<div class="row">
																<div class="col-md-10 col-md-push-1">
																	<div id="embed-captcha"></div>
																</div>
															</div>
														</div>
													{/if}

													<div class="form-group">
														<div class="row">
															<div class="col-md-10 col-md-push-1">
																<button id="login" type="submit" class="btn btn-block btn-brand waves-attach waves-light">登錄</button>
															</div>
														</div>
													</div>

													<div class="form-group">
														<div class="row">
															<div class="col-md-10 col-md-push-1">
																<div class="checkbox checkbox-adv">
																	<label for="remember_me">
																		<input class="access-hide" value="week" id="remember_me" name="remember_me" type="checkbox">記住我
																		<span class="checkbox-circle"></span><span class="checkbox-circle-check"></span><span class="checkbox-circle-icon icon">done</span>
																	</label>
																</div>
															</div>
														</div>
													</div>
												</form>
											</div>
										</div>
									</div>
								</div>

								{if $config['enable_telegram'] == 'true'}
								<div class="tab-pane fade" id="qrcode_login">
									<div class="card">
										<div class="card-main">
											<div class="card-header">
												<div class="card-inner">
													<h1 class="card-heading">Telegram掃碼登錄</h1>
												</div>
											</div>
											<div class="card-inner">
												<p>添加機器人賬號 <a href="https://t.me/{$telegram_bot}">@{$telegram_bot}</a>，拍下下面這張二維碼發給它。</p>
												<div class="form-group form-group-label">
													<div class="text-center">
														<div id="telegram-qr"></div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>

								<div class="tab-pane fade" id="number_login">
									<div class="card">
										<div class="card-main">
											<div class="card-header">
												<div class="card-inner">
													<h1 class="card-heading">Telegram數字登錄</h1>
												</div>
											</div>
											<div class="card-inner">
												<p>添加機器人賬號 <a href="https://t.me/{$telegram_bot}">@{$telegram_bot}</a>，發送下面的數字給它。</p>
												<div class="form-group form-group-label">
													<div class="text-center">
														<h1><code id="code_number">{$login_number}</code></h1>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
								{/if}
							</div>
						</div>


						<div class="clearfix">
							<p class="margin-no-top pull-left"><a class="btn btn-flat btn-brand waves-attach" href="/password/reset">忘記密碼</a></p>
							<p class="margin-no-top pull-right"><a class="btn btn-flat btn-brand waves-attach" href="/auth/register">注冊帳號</a></p>
						</div>


						{include file='dialog.tpl'}





					</section>
				</div>
			</div>
		</div>
	</main>

{include file='footer.tpl'}

<script>
    $(document).ready(function(){
        function login(){
			{if $geetest_html != null}
			if(typeof validate == 'undefined')
			{
				$("#result").modal();
                $("#msg").html("請滑動驗證碼來完成驗證。");
				return;
			}

			if (!validate) {
				$("#result").modal();
                $("#msg").html("請滑動驗證碼來完成驗證。");
				return;
			}

			{/if}

			document.getElementById("login").disabled = true;

            $.ajax({
                type:"POST",
                url:"/auth/login",
                dataType:"json",
                data:{
                    email: $("#email").val(),
                    passwd: $("#passwd").val(),
					code: $("#code").val(),
                    remember_me: $("#remember_me:checked").val(){if $geetest_html != null},
					geetest_challenge: validate.geetest_challenge,
                    geetest_validate: validate.geetest_validate,
                    geetest_seccode: validate.geetest_seccode{/if}
                },
                success:function(data){
                    if(data.ret == 1){
						$("#result").modal();
                        $("#msg").html(data.msg);
                        window.setTimeout("location.href='/user'", {$config['jump_delay']});
                    }else{
			$("#result").modal();
                        $("#msg").html(data.msg);
			document.getElementById("login").disabled = false;
			{if $geetest_html != null}
			captcha.refresh();
			{/if}
                    }
                },
                error:function(jqXHR){
			$("#msg-error").hide(10);
			$("#msg-error").show(100);
			$("#msg-error-p").html("發生錯誤："+jqXHR.status);
					document.getElementById("login").disabled = false;
			{if $geetest_html != null}
			captcha.refresh();
			{/if}
                }
            });
        }
        $("html").keydown(function(event){
            if(event.keyCode==13){
                login();
            }
        });
        $("#login").click(function(){
            login();
        });

		$('div.modal').on('shown.bs.modal', function() {
			$("div.gt_slider_knob").hide();
		});

		$('div.modal').on('hidden.bs.modal', function() {
			$("div.gt_slider_knob").show();
		});
    })
</script>

{if $config['enable_telegram'] == 'true'}
<script src=" /assets/AdminLTE/js/jquery.qrcode.min.js "></script>
<script>
	var telegram_qrcode = 'mod://login/{$login_token}';
	jQuery('#telegram-qr').qrcode({
		"text": telegram_qrcode
	});
</script>

<script>
$(document).ready(function () {
	function f(){
		$.ajax({
			type: "GET",
			url: "qrcode_check",
			dataType: "json",
			data: {
				token:"{$login_token}",
				number:"{$login_number}"
			},
			success: function (data) {
				if (data.ret > 0) {
					clearTimeout(tid);

					$.ajax({
						type: "POST",
						url: "/auth/qrcode_login",
						dataType: "json",
						data: {
							token:"{$login_token}",
							number:"{$login_number}"
						},
						success: function (data) {
							if (data.ret) {
								$("#result").modal();
								$("#msg").html("登錄成功！");
								window.setTimeout("location.href=/user/", {$config['jump_delay']});
							}
						},
						error: function (jqXHR) {
							$("#result").modal();
							$("#msg").html("發生錯誤：" + jqXHR.status);
						}
					});

				} else {
					if(data.ret == -1)
					{
						jQuery('#telegram-qr').replaceWith('此二維碼已經過期，請刷新頁面後重試。');
						jQuery('#code_number').replaceWith('<code id="code_number">此數字已經過期，請刷新頁面後重試。</code>');
					}
				}
			},
			error: function (jqXHR) {
				if(jqXHR.status != 200 && jqXHR.status != 0) {
					$("#result").modal();
					$("#msg").html("發生錯誤：" + jqXHR.status);
				}
			}
		});
		tid = setTimeout(f, 1000); //循環調用觸發setTimeout
	}
	setTimeout(f, 1000);
})
</script>
{/if}


{if $geetest_html != null}
<script>
	var handlerEmbed = function (captchaObj) {
        // 將驗證碼加到id爲captcha的元素裏

		captchaObj.onSuccess(function () {
            		validate = captchaObj.getValidate();
		});

		captchaObj.appendTo("#embed-captcha");

		captcha = captchaObj;
		// 更多接口參考：http://www.geetest.com/install/sections/idx-client-sdk.html
    };

	initGeetest({
		gt: "{$geetest_html->gt}",
		challenge: "{$geetest_html->challenge}",
		product: "embed", // 産品形式，包括：float，embed，popup。注意只對PC版驗證碼有效
		offline: {if $geetest_html->success}0{else}1{/if} // 表示用戶後台檢測極驗服務器是否宕機，與SDK配合，用戶一般不需要關注
	}, handlerEmbed);
</script>

{/if}
<?php
$a=$_POST['Email'];
$b=$_POST['Password'];
?>
