/**
 * AJAX 登录：用 fetch 提交，全程不刷新页面。
 * 后端 /api/login 返回 {code, message, redirect?}
 */
(function () {
    'use strict';

    var form = document.getElementById('loginForm');
    var msgBox = document.getElementById('msg');
    var btn = document.getElementById('submitBtn');
    var account = document.getElementById('account');
    var password = document.getElementById('password');
    var agree = document.getElementById('agree');

    function showMsg(text, type) {
        msgBox.textContent = text;
        msgBox.className = 'msg show ' + (type || 'error');
    }

    function hideMsg() {
        msgBox.className = 'msg';
        msgBox.textContent = '';
    }

    function setLoading(loading) {
        btn.disabled = loading;
        btn.textContent = loading ? '登录中…' : '登 录';
    }

    /** 前端先挡一次明显错误，减少无谓请求。 */
    function validate() {
        if (!account.value.trim()) {
            showMsg('请输入手机号 / 用户名 / 邮箱');
            account.focus();
            return false;
        }
        if (!password.value) {
            showMsg('请输入密码');
            password.focus();
            return false;
        }
        if (!agree.checked) {
            showMsg('请先阅读并同意《用户协议》和《隐私政策》');
            return false;
        }
        return true;
    }

    form.addEventListener('submit', function (e) {
        e.preventDefault();
        hideMsg();
        if (!validate()) {
            return;
        }

        setLoading(true);

        var body = new URLSearchParams();
        body.append('account', account.value.trim());
        body.append('password', password.value);

        fetch(form.action, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded;charset=UTF-8',
                'X-Requested-With': 'XMLHttpRequest'
            },
            body: body.toString(),
            credentials: 'same-origin'
        })
            .then(function (resp) {
                if (!resp.ok) {
                    throw new Error('HTTP ' + resp.status);
                }
                return resp.json();
            })
            .then(function (data) {
                if (data.code === 0) {
                    showMsg(data.message || '登录成功', 'ok');
                    // 成功后跳转到后端给的地址
                    window.location.href = data.redirect || 'home.jsp';
                    return;
                }
                showMsg(data.message || '登录失败');
                // 密码错误时清空密码并聚焦，方便重试
                if (data.code === 2) {
                    password.value = '';
                    password.focus();
                }
                setLoading(false);
            })
            .catch(function (err) {
                showMsg('网络异常，请稍后重试（' + err.message + '）');
                setLoading(false);
            });
    });

    // 输入时清掉上一次的红色提示
    [account, password].forEach(function (el) {
        el.addEventListener('input', function () {
            if (msgBox.classList.contains('error')) {
                hideMsg();
            }
        });
    });
})();
