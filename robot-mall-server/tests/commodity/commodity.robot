*** Settings ***
Documentation  wxmp_commodity
Resource  ../resources.robot
Library  robot_mall_user_library.commodity.CommodityLibrary  WITH NAME  commodity
Suite Setup  commodity.login_by_openid  ${openid}
Force Tags  model:wxmp_commodity


*** Variables ***
${mobile}  18604015383
${openid}  oaGjU5DBUe1U2suItQ8QPXG2PoSU
${commodity_id}  2fca72b405c011eaaf850242ac15000a


*** Test Cases ***
Get User Commodity By commodity_id
    [Documentation]  接口名:获取商品详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,http响应码返回 200${\n}
    ...              url:GET /users/commodities/:commodity_id
    [Tags]           Respcode:200
    Get User Commodity By commodity_id Success  commodity_id=${commodity_id}

Get User Commodity By commodity_id Fail 404
    [Documentation]  接口名:获取商品详情404${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入错误url，http响应吗返回404${\n}
    ...              url:GET /users/commodities/:commodity_id
    [Tags]           Respcode:404
    Get User Commodity By commodity_id Fail 404  commodity_id=1234567489

Get User Commodity By commodity_id Fail 422
    [Documentation]  接口名:获取商品详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入错误参数,http响应码返回 422 ${\n}
    ...              url:GET /users/commodities/:commodity_id
    [Tags]           Respcode:422
    Get User Commodity By commodity_id Fail 422  commodity_id=e728104c05c011eaacef0242ac15000a

*** Keywords ***
Get User Commodity By commodity_id Success
    [Arguments]  &{kwargs}
    ${resp}=    get_user_commodity_by_commodity_id  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 200  ${resp}  commodity/get_commodity_200.schema.json

Get User Commodity By commodity_id Fail 404
    [Arguments]  &{kwargs}
    ${resp}=    get_user_commodity_by_commodity_id  &{kwargs}
#    run keyword and continue on failure  log  ${resp.json()}
    expect status is 404   ${resp}

Get User Commodity By commodity_id Fail 422
    [Arguments]  &{kwargs}
    ${resp}=    get_user_commodity_by_commodity_id  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 422  ${resp}