import Vue from 'vue/dist/vue.esm.js'
import $ from 'jquery'
import Swal from 'sweetalert2'

import './样式.sass'


服务器地址 = 'https://librian-center.azurewebsites.net/api/ember?code=vspk07OGnowc/DJiueZ96F/4mtXbGGj1qpnS0m03mgiwznVx/91gJg=='
存储地址 = 'https://rimosto-cdn.azureedge.net'
window.太阳交换 = ->
    console.log '「太阳交换」'
    服务器地址 = 'http://localhost:7071/api/ember?'
if window.location.protocol=='file:'
    太阳交换()

同调呼唤 = new Proxy({} ,
    get: (_, f) ->
        q = (data) ->
            aj = (callback) ->
                if data==undefined
                    data = {}
                data.f = f
                if 本地存储.灵牌
                    data.灵牌 = 本地存储.灵牌
                $.ajax(
                    method: 'post'
                    url: 服务器地址
                    data: JSON.stringify(data)
                    complete: (result, _) ->
                        console.log '「result」', result.responseText
                        if result.responseText != undefined
                            r = JSON.parse(result.responseText)
                        status_code = result.status
                        callback([r, status_code])
                )
            [r, status_code] = await new Promise (resolve) ->
                aj(resolve)
            return [r, status_code]
        return q
)


window.同调融合 = new Proxy({} ,
    get: (_, f) ->
        q = (d) ->
            console.log "<同调融合>(#{f})", d
            [r, status_code] = await 同调呼唤[f](d)
            if status_code==200
                return r
            else
                Swal.fire
                    title: '坏了'
                    text: "[#{status_code}]#{r}"
                    icon: 'error'
                throw '坏了'
                return 
        return q
)


window.本地存储 = new Proxy({} ,
    get: (_, key) ->
        return JSON.parse(localStorage.getItem(key))
    set: (_, key, value) ->
        value = JSON.stringify(value)
        localStorage.setItem(key, value)
        return true
)


同步用户信息 = ->
    if not 本地存储.灵牌
        本地存储.用户信息 = null
        v.用户信息 = null
        return
    RowKey = 本地存储.灵牌['RowKey']
    v.用户信息 = await 同调融合.查询详细信息({RowKey})
    本地存储.用户信息 = v.用户信息

按钮表 =
    登录: ->
        Swal.fire
            title: '登录'
            html: '''
                <input id="swal-input1" class="swal2-input" placeholder="用户名">
                <input id="swal-input2" class="swal2-input" placeholder="密码" type="password">
            '''
            allowOutsideClick: false
            backdrop: false
            showCloseButton: true
            preConfirm: ->
                RowKey = $('#swal-input1').val()
                密码 = $('#swal-input2').val()
                邮箱 = $('#swal-input3').val()
                [信息, status_code] = await 同调呼唤.登录({RowKey, 密码})
                if status_code == 200
                    return 信息
                else
                    Swal.showValidationMessage(信息)
        .then (result) ->
            if result.value
                本地存储.灵牌 = result.value
                同步用户信息()

    注册: ->
        Swal.fire
            title: '注册'
            html: '''
                <input id="swal-input1" class="swal2-input" placeholder="用户名">
                <input id="swal-input2" class="swal2-input" placeholder="密码">
                <input id="swal-input3" class="swal2-input" placeholder="邮箱">
            '''
            allowOutsideClick: false
            backdrop: false
            showCloseButton: true
            preConfirm: ->
                RowKey = $('#swal-input1').val()
                密码 = $('#swal-input2').val()
                邮箱 = $('#swal-input3').val()
                [信息, status_code] = await 同调呼唤.注册({RowKey, 密码, 邮箱})
                if status_code == 200
                    return 信息
                else
                    Swal.showValidationMessage(信息)
        .then (result) ->
            if result.value
                本地存储.灵牌 = result.value
                同步用户信息()
                Swal.fire(
                    icon: 'success'
                    title: '注册好了'
                )

    加载更多动态: ->
        计数 = 0
        for 事件, i in v.查看的用户动态
            if 事件.事件类型 == undefined
                计数 += 1
                if 计数 > 5
                    break
                v.查看的用户动态[i] = await 同调融合.查询事件详细({
                    PartitionKey: 事件.PartitionKey,
                    RowKey: 事件.RowKey
                })
        t = v.查看的用户动态
        v.查看的用户动态 = []
        v.查看的用户动态 = t

    修改头像: ->
        $("#头像文件上传").change ->
            if $(this).val() == ''
               return
            文件 = $('#头像文件上传')[0].files[0]
            imgSize = this.files[0].size
            if imgSize > 1024 * 1024
                Swal.fire
                    text: '不要上传大于1MB的图片。'
                    icon: 'warning'
                return
            Swal.fire
                title: '正在上传中……',
                onBeforeOpen: ->
                    Swal.showLoading()
            reader = new FileReader()
            reader.onload = (e) ->
                await 同调融合.修改头像({流: e.target.result})
                Swal.fire
                    text: '好了。'
                    icon: 'success'
                同步用户信息()
            reader.readAsBinaryString(文件)
            $(this).val('')
        $('#头像文件上传')[0].click()

    退出: ->
        本地存储.灵牌 = null
        同步用户信息()

    发布文章: ->
        Swal.fire
            title: '正在上传中……',
            onBeforeOpen: ->
                Swal.showLoading()
        await 同调融合.写文章({
            文件类型: 'md'
            标题: $('.写文章 .标题 input').val()
            摘要: $('.写文章 .摘要 input').val()
            内容: window.vditor.getValue()
            键: [v.当前页参数表.人, v.当前页参数表.事件] if v.当前页参数表.人
        })
        Swal.fire
            text: '好了。'
            icon: 'success'
        .then ->
            翻页('个人中心', {rk: v.用户信息.RowKey})

    进入个人中心: ->
        翻页('个人中心', {rk: v.用户信息.RowKey})

    删除文章: ->
        await 同调融合.删除事件({
            PartitionKey: v.当前页参数表.人
            RowKey: v.当前页参数表.事件
        })
        Swal.fire
            text: '好了。'
            icon: 'success'
        .then ->
            翻页('个人中心', {rk: v.用户信息.RowKey})

翻页处理器 = 
    首页: () ->
        v.推荐用户 = []
        v.推荐用户 = await 同调融合.获得推荐用户()
    个人中心: ({rk}) ->
        $('title').text(rk + ' - 个人中心')
        v.查看的用户动态 = null
        v.查看的用户信息 = await 同调融合.查询基本信息(RowKey: rk)
        v.查看的用户动态 = await 同调融合.查询用户事件({用户rk: v.查看的用户信息['RowKey']})
        按钮表.加载更多动态()
    写文章: ({人, 事件}) ->
        if 人!=undefined
            v.写的文章 = await 同调融合.查询事件究极({
                PartitionKey: 人
                RowKey: 事件
            })
        v.$nextTick ->
            vditor启动(v.写的文章.关联文件内容)
    读文章: ({人, 事件}) ->
        信息 = await 同调融合.查询事件究极({
            PartitionKey: 人
            RowKey: 事件
        })
        v.读的文章 = 信息
        $('title').text(信息.标题)
        v.$nextTick ->
            Vditor.preview(document.getElementById('读文章内容'),
                信息.关联文件内容,
                {
                    anchor: 1
                }
            )

获取当前url = ->
    base = window.location.origin + window.location.pathname
    
    # firefox从file协议运行时有奇怪的问题
    if window.location.origin=='null'
        base = window.location.protocol + '//' + window.location.pathname
        
    问 = window.location.search
    井 = decodeURI(window.location.hash).slice(1)
    return [base, 问, 井]

翻页 = (目标页, 参数表={}, push=true) ->
    console.log '「翻页」', 目标页, 参数表
    $('title').text('Librian会所')
    查询字符串 = ''
    if Object.keys(参数表).length > 0
        查询参数 = new URLSearchParams()
        for key, value of 参数表
            查询参数.set(key, value)
        查询字符串 = '?' + 查询参数.toString()
    [url, 问, 井] = 获取当前url()
    if push
        history.pushState(null, null, url +  查询字符串 + '#' + 目标页)
    v.当前页 = 目标页
    v.当前页参数表 = 参数表
    if 目标页 of 翻页处理器
        翻页处理器[目标页](参数表)

回光返照 = ->
    console.log '「回光返照」'
    [url, 问, 井] = 获取当前url()
    查询参数 = {}
    new URLSearchParams(window.location.search).forEach (value, key)->
        查询参数[key] = value
    翻页(井, 查询参数, false)


window.addEventListener('popstate', (e) ->
    回光返照()
, false)


vditor启动 = (markdown) ->
    toolbar = [
        'headings', 'bold', 'italic', 'strike', 'link', 'upload', '|',
        'list', 'ordered-list', 'check', 'outdent', 'indent', '|',
        'quote', 'line', 'code', 'inline-code', 'insert-before', 'insert-after', '|',
        'table', '|',
        'undo', 'redo', '|', 
        'edit-mode', 'content-theme', 'code-theme', 'export'
        {
            name: 'more'
            toolbar: [
                'fullscreen'
                'both'
                'format'
                'preview'
                'info'
                'help'
            ]
        }]
    window.vditor = new Vditor('vditor', {
        toolbar
        height: window.innerHeight
        outline: true
        typewriterMode: true
        placeholder: '一起来嫖娼吧！'
        preview:
            markdown:
                toc: true
        counter:
            enable: true
            type: 'text'
        tab: '\t'
        cache: 
            enable: false
        upload:
            accept: 'image/*'
            max: 5 * 1024 * 1024
            url: "#{服务器地址}&f=上传图片"
            extraData: 
                '灵牌': JSON.stringify(本地存储.灵牌)
            format: (files, responseText) ->
                md5 = JSON.parse(responseText)
                return JSON.stringify({  
                    "msg": "",
                    "code": 0,
                    "data": 
                        "errFiles": [],
                        "succMap":
                            "我是图.webp": "#{存储地址}/image/#{md5}",
                })
        after: ->
            if markdown
                window.vditor.setValue(markdown)
    })
    


$ ->
    console.log 'nya!'
    window.v = new Vue
        el: '#all'
        data:
            头像容器: 存储地址 + '/avatar/'
            当前页: null
            当前页参数表: {}
            用户信息: null
            查看的用户信息: null
            查看的用户动态: null
            写的文章: 
                标题: ''
                摘要: ''
            读的文章: null
            推荐用户: []
        methods:
            时间格式化: (t) ->
                return new Date(t*1000) + ''
            相对时间: (t) ->
                时间差 = Date.now() / 1000 - t
                if 时间差 < 60
                    return '刚刚'
                if 时间差 < 3600
                    return Math.floor(时间差 / 60) + ' 分钟前'
                if 时间差 < 3600 * 24
                    return Math.floor(时间差 / 3600) + ' 小时前'
                return Math.floor(时间差/3600/24) + ' 天前'

    $('body').on 'click','a', (event) ->
        目标页 = $(this).attr('翻页')
        if 目标页 != undefined
            翻页(目标页)

    $('body').on 'click','a', (event) ->
        id = $(this).attr('id')
        if id and id of 按钮表
            按钮表[id]()
    
    if 本地存储.用户信息
        v.用户信息 = 本地存储.用户信息
    
    [url, 问, 井] = 获取当前url()
    if 井!=''
        回光返照()
    if 问=='' and 井==''
        翻页('警告')
    if 问!='' and 井==''
        alert '这你也能上？？？'
    
    同步用户信息()
