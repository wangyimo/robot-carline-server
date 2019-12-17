*** Settings ***
Documentation  admin_order
Resource  ../resources.robot
Library  robot_mall_service_library.order.OrderLibrary
Force Tags  model:admin_order  Respcode:403


*** Variables ***
${order_id}  7e60145c0b5511ea9dbb0242ac15000a


*** Test Cases ***
Get Admin Orders Without Login
    [Documentation]  接口名:订单列表${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Get Admin Orders Fail403

Get Admin Order Detail Without Login
    [Documentation]  接口名:订单详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Get Admin Order Detail Fail403  order_id=${order_id}

Put Admin Order Without Login
    [Documentation]  接口名:修改订单${\n}
    ...              请求方式:Put${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Put Admin Order Fail403  order_id=${order_id}  delivery_company=123  delivery_order=123  postage=2

Get Admin Orders Export Without Login
    [Documentation]  接口名:订单导出${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Get Admin Orders Export Fail403

Patch Admin Order Delivery Without Login
    [Documentation]  接口名:确认收货${\n}
    ...              请求方式:Patch${\n}
    ...              预期结果:未登录,输入正确参数,http响应码返回 403。
    Patch Admin Order Delivery Fail403  order_id=${order_id}


*** Keywords ***
Get Admin Orders Fail403
    [Arguments]  &{kwargs}
    ${resp}=  get admin orders  &{kwargs}
    expect status is 403  ${resp}

Get Admin Order Detail Fail403
    [Arguments]  &{kwargs}
    ${resp}=  get admin order detail  &{kwargs}
    expect status is 403  ${resp}

Put Admin Order Fail403
    [Arguments]  &{kwargs}
    ${resp}=  put admin order  &{kwargs}
    expect status is 403  ${resp}

Get Admin Orders Export Fail403
    [Arguments]  &{kwargs}
    ${resp}=  get orders export  &{kwargs}
    expect status is 403  ${resp}

Patch Admin Order Delivery Fail403
    [Arguments]  &{kwargs}
    ${resp}=   patch admin order delivery  &{kwargs}
    expect status is 403  ${resp}
