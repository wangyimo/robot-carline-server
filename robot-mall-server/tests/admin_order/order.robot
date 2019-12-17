*** Settings ***
Documentation  admin_order
Resource  ../resources.robot
Library  robot_mall_service_library.order.OrderLibrary
Suite Setup  Login  ${admin_username}   ${admin_password}
Suite Teardown  Logout
Force Tags  model:admin_order



*** Variables ***
${admin_username}  admin
${admin_password}  admin123
${order_id}
${delivery_company}
${delivery_order}
${postage}


*** Test Cases ***
Get Admin Orders
    [Documentation]  接口名:订单列表${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,http响应码返回 200,返回的Json数据为 Order 列表。
    [Tags]           Respcode:200
    ${essential_params}  create dictionary
    ${unessential_params}  create dictionary  pay_status=1  delivery_status=1
    ...        mobile=13188676566  contact=wy  order_id=7e60145c0b5511ea9dbb0242ac15000a
    ...   commodity_name=走过路过不要错过，走过路过不要错过-再见  order_time=0,155555  pay_time=0,155555
    ...   page_size=20  page_num=1
    run every case by params   Get Admin Orders Success   ${essential_params}  ${unessential_params}
    Get Admin Orders Success

Get Admin Orders Fail422
    [Documentation]  接口名:订单列表${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入错误参数,http响应码返回 422,返回的Json数据符合验证。
    [Tags]           Respcode:422
    ${essential_params}  create dictionary
    ${unessential_params}  create dictionary  pay_status=aaa  delivery_status=aaa
    ...        mobile=dsadsadasdas  contact=/  order_id=.
    ...   commodity_name=/  order_time=a  pay_time=a
    ...   page_size=aa  page_num=a
    run every case by params   Get Admin Orders Fail422   ${essential_params}  ${unessential_params}  success=False

Get Admin Order Detail
    [Documentation]  接口名:订单详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,http响应码返回 200,返回的Json数据为 Order 对象。
    [Tags]           Respcode:200
    Get Admin Order Detail Success  order_id=${order_id}

Get Admin Order Detail Fail404
    [Documentation]  接口名:订单详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入错误order_id,http响应码返回 404。
    [Tags]           Respcode:404
    Get Admin Order Detail Fail404  order_id=sdsadadadewqe4313213

Put Admin Order
    [Documentation]  接口名:修改订单${\n}
    ...              请求方式:Put${\n}
    ...              预期结果:输入正确order_id,正确参数,http响应码返回 204。
    [Tags]           Respcode:204
    Put Admin Order Success  order_id=${order_id}  delivery_company=123  delivery_order=123  postage=2

Put Admin Order Fail404
    [Documentation]  接口名:修改订单${\n}
    ...              请求方式:Put${\n}
    ...              预期结果:输入错误order_id,正确参数,http响应码返回 404。
    [Tags]           Respcode:404
    Put Admin Order Fail404  order_id=sdsadadadewqe4313213  delivery_company=123  delivery_order=123  postage=2

Put Admin Order Fail422
    [Documentation]  接口名:修改订单${\n}
    ...              请求方式:Put${\n}
    ...              预期结果:输入正确order_id,错误参数,http响应码返回 422。
    [Tags]           Respcode:422
    Put Admin Order Fail422  order_id=${order_id}

Get Admin Orders Export
    [Documentation]  接口名:订单导出${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,http响应码返回 200,返回的Json数据为 Order 列表。
    [Tags]           Respcode:200
    ${essential_params}  create dictionary
    ${unessential_params}  create dictionary  pay_status=1  delivery_status=1
    ...        mobile=13188676566  contact=wy  order_id=7e60145c0b5511ea9dbb0242ac15000a
    ...   commodity_name=走过路过不要错过，走过路过不要错过-再见  order_time=0,155555  pay_time=0,155555
    run every case by params   Get Admin Orders Export Success   ${essential_params}  ${unessential_params}
    Get Admin Orders Export Success

Get Admin Orders Export Fail422
    [Documentation]  接口名:订单导出${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入错误参数,http响应码返回 422。
    [Tags]           Respcode:422
    ${essential_params}  create dictionary
    ${unessential_params}  create dictionary  pay_status=a  delivery_status=a
    ...        mobile=dsadsadasdas  contact=/  order_id=.
    ...   commodity_name=/  order_time=a  pay_time=a
    run every case by params   Get Admin Orders Export Fail422   ${essential_params}  ${unessential_params}  success=False

Patch Admin Order Delivery
    [Documentation]  接口名:确认收货${\n}
    ...              请求方式:Patch${\n}
    ...              预期结果:输入正确参数,http响应码返回 204。
    [Tags]           Respcode:204
    Patch Admin Order Delivery Success  order_id=${order_id}

Patch Admin Order Delivery Fail404
    [Documentation]  接口名:确认收货${\n}
    ...              请求方式:Patch${\n}
    ...              预期结果:输入错误order_id,http响应码返回 404。
    [Tags]           Respcode:404
    Patch Admin Order Delivery Fail404  order_id=sdsadadadewqe4313213


*** Keywords ***
Get Admin Orders Success
    [Arguments]  &{kwargs}
    ${resp}=  get admin orders  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 200  ${resp}  admin_order/get_200.schema.json
    ${order_id}  set variable if  ${resp.json()}!=[]  ${resp.json()[0]["order_id"]}
    set global variable  ${order_id}
#    ${delivery_company}  set variable if  ${resp.json()}!=[]  ${resp.json()[0]["delivery_company"]}
#    set global variable  ${delivery_company}
#    ${delivery_order}  set variable if  ${resp.json()}!=[]  ${resp.json()[0]["delivery_order"]}
#    set global variable  ${delivery_order}
#    ${postage}  set variable if  ${resp.json()}!=[]  ${resp.json()[0]["postage"]}
#    set global variable  ${postage}

Get Admin Orders Fail422
    [Arguments]  &{kwargs}
    ${resp}=  get admin orders  &{kwargs}
    expect status is 422  ${resp}

Get Admin Order Detail Success
    [Arguments]  &{kwargs}
    ${resp}=  get admin order detail  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 200  ${resp}  admin_order/get_detail_200.schema.json

Get Admin Order Detail Fail404
    [Arguments]  &{kwargs}
    ${resp}=  get admin order detail  &{kwargs}
    expect status is 404  ${resp}

Put Admin Order Success
    [Arguments]  &{kwargs}
    ${resp}=  put admin order  &{kwargs}
    expect status is 204  ${resp}

Put Admin Order Fail422
    [Arguments]  &{kwargs}
    ${resp}=  put admin order  &{kwargs}
    expect status is 422  ${resp}

Put Admin Order Fail404
    [Arguments]  &{kwargs}
    ${resp}=  put admin order  &{kwargs}
    expect status is 404  ${resp}

Get Admin Orders Export Success
    [Arguments]  &{kwargs}
    ${resp}=  get orders export  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 200  ${resp}  admin_order/get_200.schema.json

Get Admin Orders Export Fail422
    [Arguments]  &{kwargs}
    ${resp}=  get orders export  &{kwargs}
    expect status is 422  ${resp}

Patch Admin Order Delivery Success
    [Arguments]  &{kwargs}
    ${resp}=   patch admin order delivery  &{kwargs}
    expect status is 204  ${resp}

Patch Admin Order Delivery Fail404
    [Arguments]  &{kwargs}
    ${resp}=   patch admin order delivery  &{kwargs}
    expect status is 404  ${resp}