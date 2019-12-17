*** Settings ***
Documentation  wxmp_order
Resource  ../resources.robot
Library  robot_mall_user_library.order.OrderLibrary
Library  robot_mall_user_library.commodity.CommodityLibrary  WITH NAME  commodity
Library  robot_mall_service_library.commodity.CommodityLibrary  WITH NAME  server
Force Tags  model:wxmp_order


*** Variables ***
${mobile}  18604015383
${openid}  oaGjU5DBUe1U2suItQ8QPXG2PoSU
${commodity_id}
${specification_id}
${order_id}

*** Test Cases ***
Post User Order Fail 403
    [Documentation]  接口名:用户创建订单${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:未登录,http响应码返回 403${\n}
    ...              url:POST /user/orders
    [Tags]           Respcode:403
    ${number}  generate num  4
    ${name}  faker name
    server.login  admin  admin123
    ${arr1}=           get admin commodities
    log  ${arr1.json()}
    ${commodity_id}  set variable if   ${arr1.json()}!=[]  ${arr1.json()[0]["commodity_id"]}
    log  ${commodity_id}
    ${specification_id}  set variable if   ${arr1.json()}!=[]  ${arr1.json()[0]['specifications'][0]["specification_id"]}
    ${essential_params}  create dictionary  commodity_id=${commodity_id}  amount=5
    ...  specification_id=${specification_id}  contact=Robot${name}  mobile=13000000000
    ...  delivery_region=沈阳市浑南区${number}  delivery_address=远航西路IT国际201${number}
    ${unessential_params}  create dictionary
    run every case by params  Post User Order Fail 403  ${essential_params}  ${unessential_params}

Post User Order Pay Fail 403
    [Documentation]  接口名:订单支付403${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:未登录,http响应码返回 403${\n}
    ...              url:POST /user/orders/:order_id/pay
    [Tags]           Respcode:403
    ${essential_params}  create dictionary  pay_type=WX_XCX_SL
    ${unessential_params}  create dictionary  open_id=${open_id}
    run every case by params  Post User Order Pay Fail 403   ${essential_params}  ${unessential_params}
    ...  order_id=aaa

Get User Order Fail 403
    [Documentation]  接口名:用户查看订单详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:未登录,http响应码返回 403${\n}
    ...              url:GET /user/orders/:order_id
    [Tags]           Respcode:403
    Get User Order Fail 403  order_id=aaa

Put User Order Fail 403
    [Documentation]  接口名:取消订单403${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:未登录,http响应码返回 403${\n}
    ...              url:PUT /user/orders/:order_id/cancel
    [Tags]           Respcode:403
    Put User Order Fail 403  order_id=444444

Put Accept Order Fail 403
    [Documentation]  接口名:用户确认收货403${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:未登录,http响应码返回 403${\n}
    ...              url:PUT /user/orders/:order_id/delivery_status
    [Tags]           Respcode:403
    Put Accept Order Fail 403  order_id=444444

*** Keywords ***
Post User Order Fail 403
    [Arguments]  &{kwargs}
    ${resp}=    post user order  &{kwargs}
    expect status is 403  ${resp}

Post User Order Pay Fail 403
    [Arguments]  &{kwargs}
    ${resp}=    post user order pay  &{kwargs}
    expect status is 403  ${resp}

Get User Order Fail 403
    [Arguments]  &{kwargs}
    ${resp}=    get order by order id  &{kwargs}
    expect status is 403  ${resp}
    
Put User Order Fail 403
    [Arguments]  &{kwargs}
    ${resp}=  put cancel order   &{kwargs}
    expect status is 403  ${resp}

Put Accept Order Fail 403
    [Arguments]  &{kwargs}
    ${resp}=  put accept order   &{kwargs}
    expect status is 403  ${resp}