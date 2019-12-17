*** Settings ***
Documentation  wxmp_commodity
Resource  ../resources.robot
Library  robot_mall_user_library.commodity.CommodityLibrary  WITH NAME  commodity
Force Tags  model:wxmp_commodity


*** Variables ***
${mobile}  18604015383
${openid}  oaGjU5DBUe1U2suItQ8QPXG2PoSU
${commodity_id}  2fca72b405c011eaaf850242ac15000a


*** Test Cases ***
Get User Commodity By commodity_id Fail 403
    [Documentation]  接口名:获取商品详情403${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,http响应码返回 403(授权无效或已过期)${\n}
    ...              url:GET /users/commodities/:commodity_id
    [Tags]           Respcode:403
    Get User Commodity By commodity_id Success Fail 403  commodity_id=${commodity_id}

*** Keywords ***
Get User Commodity By commodity_id Success Fail 403
    [Arguments]  &{kwargs}
    ${resp}=    get_user_commodity_by_commodity_id  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 403  ${resp}