*** Settings ***
Documentation  admin_commodity
Resource  ../resources.robot
Library  robot_mall_service_library.commodity.CommodityLibrary
Force Tags  model:admin_commodity   Respcode:403



*** Variables ***
${admin_username}  admin
${admin_password}  admin123
${commodity_id}     7eecb0d80a9211eaa4890242ac15000a
${name}
${commodity_images}
${commodity_videos}


*** Test Cases ***
Get Admin Commodities Without Login
    [Documentation]  接口名:获取检车线列表${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Get Admin Commodities Fail403

Post Admin Commodities Without Login
    [Documentation]  接口名:创建商品${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    ${name}   faker name
    set global variable  ${name}
    ${commodity_images}  create list  https://uustorage-t.uucin.com/media/park/1a2886ee676cc5206acc526a12fa8ec1.jpg
    ${commodity_videos}  create list  https://uustorage-t.uucin.com/media/video/mall/20191113_8963df239bf54e35b297fb8cccd9a450.mp4
    set global variable  ${commodity_images}
    set global variable  ${commodity_videos}
    Post Admin Commodity Fail403  commodity_name=${name}的商品  subtitle=商品
    ...    commodity_images=${commodity_images}  commodity_videos=${commodity_videos}  commodity_description=test

Put Admin Commodities Without Login
    [Documentation]  接口名:修改商品${\n}
    ...              请求方式:Put${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    ${essential_params}  create dictionary  commodity_name=${name}的商品  commodity_images=${commodity_images}
    ...           commodity_description=robottest
    ${unessential_params}  create dictionary  subtitle=商品  commodity_videos=${commodity_videos}
    run every case by params   Put Admin Commodity Fail403   ${essential_params}  ${unessential_params}  commodity_id=${commodity_id}

Patch Admin Commodities Operation Without Login
    [Documentation]  接口名:商品上架下架接口${\n}
    ...              请求方式:Patch${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Patch Admin Commodities Operation Fail403  commodity_id=${commodity_id}  operation=1

Get Admin Commodity Detail Without Login
    [Documentation]  接口名:获取商品详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Get Admin Commodity Detail Fail403  commodity_id=${commodity_id}

Post Admin Commodity Specification Without Login
    [Documentation]  接口名:创建/修改规格${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Post Admin Commodity Specification Fail403  commodity_id=${commodity_id}  specification_objs=
    ...   delete_specification_ids=

Delete Admin Commodities Without Login
    [Documentation]  接口名:删除商品${\n}
    ...              请求方式:Delete${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Delete Admin Commodities Fail403  commodity_id=${commodity_id}


*** Keywords ***
Get Admin Commodities Fail403
    [Arguments]  &{kwargs}
    ${resp}=  get admin commodities  &{kwargs}
    expect status is 403  ${resp}

Get Admin Commodity Detail Fail403
    [Arguments]  &{kwargs}
    ${resp}=  get admin commodity detail  &{kwargs}
    expect status is 403  ${resp}

Post Admin Commodity Fail403
    [Arguments]  &{kwargs}
    ${resp}=  post admin commodities  &{kwargs}
    expect status is 403  ${resp}

Put Admin Commodity Fail403
    [Arguments]  &{kwargs}
    ${resp}=  put admin commodities  &{kwargs}
    expect status is 403  ${resp}

Patch Admin Commodities Operation Fail403
    [Arguments]  &{kwargs}
    ${resp}=  patch admin commodities operation  &{kwargs}
    expect status is 403  ${resp}

Post Admin Commodity Specification Fail403
    [Arguments]  &{kwargs}
    ${resp}=   post admin commodity specification  &{kwargs}
    expect status is 403  ${resp}

Delete Admin Commodities Fail403
    [Arguments]  &{kwargs}
    ${resp}=  delete admin commodities  &{kwargs}
    expect status is 403  ${resp}
