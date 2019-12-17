*** Settings ***
Documentation  wxmp_order
Resource  ../resources.robot
Library  robot_mall_user_library.order.OrderLibrary
Library  robot_mall_service_library.commodity.CommodityLibrary  WITH NAME  server
Library  robot_mall_user_library.commodity.CommodityLibrary  WITH NAME  commodity
Suite Setup  commodity.login_by_open_id  ${open_id}
Force Tags  model:wxmp_order


*** Variables ***
${mobile}  18604015383
${open_id}  oaGjU5DBUe1U2suItQ8QPXG2PoSU
${commodity_id}
${specification_id}
${order_id}

*** Test Cases ***
Post User Order
    [Documentation]  接口名:用户创建订单${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入正确参数,订单创建成功,http响应码返回 201${\n}
    ...              url:POST /user/orders
    [Tags]           Respcode:201
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
    run every case by params  Post User Order Success  ${essential_params}  ${unessential_params}

Post User Order Fail 422
    [Documentation]  接口名:用户创建订单422${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入错误参数,订单创建失败,http响应码返回 422${\n}
    ...              url:POST /user/orders
    [Tags]           Respcode:422
    ${number}  generate num  4
    ${name}  faker name
    server.login  admin  admin123
    ${arr1}=           get admin commodities
    log  ${arr1.json()}
    ${commodity_id}  set variable if   ${arr1.json()}!=[]  ${arr1.json()[0]["commodity_id"]}
    log  ${commodity_id}
    ${specification_id}  set variable if   ${arr1.json()}!=[]  ${arr1.json()[0]['specifications'][0]["specification_id"]}
    ${essential_params}  create dictionary
    ${unessential_params}  create dictionary  commodity_id=${commodity_id}  amount=5
    ...  specification_id=${specification_id}  contact=Robot${name}  mobile=13000000000
    ...  delivery_region=沈阳市浑南区${number}  delivery_address=远航西路IT国际201${number}
    run every case by params  Post User Order Fail 422  ${essential_params}  ${unessential_params}

Post User Order Pay
    [Documentation]  接口名:订单支付${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入正确参数,订单支付成功,http响应码返回 200${\n}
    ...              url:POST /user/orders/:order_id/pay
    [Tags]           Respcode:201
    log  ${open_id}
    ${essential_params}  create dictionary  pay_type=WX_XCX_SL  open_id=${open_id}
    ${unessential_params}  create dictionary
    run every case by params  Post User Order Pay Success   ${essential_params}  ${unessential_params}
    ...  order_id=${order_id}
    log  ${order_id}

Post User Order Pay Fail 404
    [Documentation]  接口名:订单支付404${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入错误url,http响应码返回 404${\n}
    ...              url:POST /user/orders/:order_id/pay
    [Tags]           Respcode:404
    ${essential_params}  create dictionary  pay_type=WX_XCX_SL
    ${unessential_params}  create dictionary  open_id=${open_id}
    run every case by params  Post User Order Pay Fail 404   ${essential_params}  ${unessential_params}
    ...  order_id=aaa

Post User Order Pay Fail 422
    [Documentation]  接口名:订单支付422${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入错误url,http响应码返回 404${\n}
    ...              url:POST /user/orders/:order_id/pay
    [Tags]           Respcode:422
    ${essential_params}  create dictionary
    ${unessential_params}  create dictionary  open_id=${open_id}  pay_type=WX_XCX_SL
    run every case by params  Post User Order Pay Fail 422   ${essential_params}  ${unessential_params}
    ...  order_id=${order_id}

Get User Order
    [Documentation]  接口名:用户查看订单详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,看订单详情成功,http响应码返回 200${\n}
    ...              url:GET /user/orders/:order_id
    [Tags]           Respcode:200
    Get User Order Success  order_id=${order_id}

Get User Order Fail 404
    [Documentation]  接口名:用户查看订单详情404${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,看订单详情成功,http响应码返回 404 ${\n}
    ...              url:GET /user/orders/:order_id
    [Tags]           Respcode:404
    Get User Order Fail 404  order_id=444444

Put User Order Success
    [Documentation]  接口名:取消订单${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,看订单详情成功,http响应码返回 204${\n}
    ...              url:PUT /user/orders/:order_id/cancel
    [Tags]           Respcode:204
    Put User Order Success  order_id=${order_id}

Put User Order Fail 404
    [Documentation]  接口名:取消订单404${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:未登录,http响应码返回 404${\n}
    ...              url:PUT /user/orders/:order_id/cancel
    [Tags]           Respcode:404
    Put User Order Fail 404  order_id=444444

Put Accept Order Success
    [Documentation]  接口名:用户确认收货${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,看订单详情成功,http响应码返回 204${\n}
    ...              url:PUT /user/orders/:order_id/delivery_status
    [Tags]           Respcode:204
    log  ${order_id}
    Put Accept Order Success  order_id=${order_id}

Put Accept Order Fail 404
    [Documentation]  接口名:用户确认收货404${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入错误的Url,http响应码返回 404${\n}
    ...              url:PUT /user/orders/:order_id/delivery_status
    [Tags]           Respcode:404
    Put Accept Order Fail 404  order_id=444444

*** Keywords ***
Post User Order Success
    [Arguments]  &{kwargs}
    ${resp}=    post user order  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 201  ${resp}  user_order/post_user_order_200.schema.json
    ${order_id}  set variable  ${resp.json()["order_id"]}
    set global variable  ${order_id}

Post User Order Fail 422
    [Arguments]  &{kwargs}
    ${resp}=    post user order  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 422  ${resp}

Post User Order Pay Success
    [Arguments]  &{kwargs}
    ${resp}=    post user order pay  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 201  ${resp}   user_order/post_user_order_pay_200.schema.json

Post User Order Pay Fail 404
    [Arguments]  &{kwargs}
    ${resp}=    post user order pay  &{kwargs}
    expect status is 404  ${resp}

Post User Order Pay Fail 422
    [Arguments]  &{kwargs}
    ${resp}=    post user order pay  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 422  ${resp}

Get User Order Success
    [Arguments]  &{kwargs}
    ${resp}=    get order by order id  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 200  ${resp}   user_order/get_user_order_200.schema.json

Get User Order Fail 404
    [Arguments]  &{kwargs}
    ${resp}=    get order by order id  &{kwargs}
    expect status is 404  ${resp}

Put User Order Success
    [Arguments]  &{kwargs}
    ${resp}=  put cancel order   &{kwargs}
    expect status is 204  ${resp}

Put User Order Fail 404
    [Arguments]  &{kwargs}
    ${resp}=  put cancel order   &{kwargs}
    expect status is 404  ${resp}

Put Accept Order Success
    [Arguments]  &{kwargs}
    ${resp}=  put accept order   &{kwargs}
    expect status is 204  ${resp}

Put Accept Order Fail 404
    [Arguments]  &{kwargs}
    ${resp}=  put accept order    &{kwargs}
    expect status is 404  ${resp}