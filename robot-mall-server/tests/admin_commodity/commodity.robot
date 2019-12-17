*** Settings ***
Documentation  admin_commodity
Resource  ../resources.robot
Library  robot_mall_service_library.commodity.CommodityLibrary
Suite Setup  Login  ${admin_username}   ${admin_password}
Suite Teardown  Logout
Force Tags  model:admin_commodity



*** Variables ***
${admin_username}  admin
${admin_password}  admin123
${commodity_id}
${name}
${commodity_images}
${commodity_videos}


*** Test Cases ***
Get Admin Commodities
    [Documentation]  接口名:获取商品列表${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,http响应码返回 200,返回的Json数据为 commodity 列表。
    [Tags]           Respcode:200
    ${time1}  get current sec
    ${time2}  add number  ${time1}  1000
    ${section}  set variable  ${time1},${time2}
    ${essential_params}  create dictionary
    ${unessential_params}  create dictionary  sales_status=1  shelf_time=0,155555  commodity_name=1  page_size=20  page_num=1
    run every case by params   Get Admin Commodities Success   ${essential_params}  ${unessential_params}
    Get Admin Commodities Success

Get Admin Commodities Fail
    [Documentation]  接口名:获取商品列表{\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入错误参数,http响应码返回 422,返回的Json数据符合校验。
    [Tags]           Respcode:422
    ${time1}  get current sec
    ${time2}  add number  ${time1}  1000
    ${section}  set variable  ${time1},${time2}
    ${essential_params}  create dictionary
    ${unessential_params}  create dictionary  sales_status=a  shelf_time=a,b  commodity_name=.  page_size=a  page_num=a
    run every case by params   Get Admin Commodities Fail422   ${essential_params}  ${unessential_params}  success=False
    Get Admin Commodities Fail422

Post Admin Commodities
    [Documentation]  接口名:创建商品${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入正确参数,http响应码返回 201,返回的Json数据符合校验。
    [Tags]           Respcode:201
    ${name}   faker name
    set global variable  ${name}
    ${commodity_images}  create list  https://uustorage-t.uucin.com/media/park/1a2886ee676cc5206acc526a12fa8ec1.jpg
    ${commodity_videos}  create list  https://uustorage-t.uucin.com/media/video/mall/20191113_8963df239bf54e35b297fb8cccd9a450.mp4
    set global variable  ${commodity_images}
    set global variable  ${commodity_videos}
    Post Admin Commodity Success  commodity_name=${name}的商品  subtitle=商品
    ...    commodity_images=${commodity_images}  commodity_videos=${commodity_videos}  commodity_description=test

Post Admin Commodities Fail
    [Documentation]  接口名:创建商品${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入错误参数,http响应码返回 422,返回的Json数据符合校验。
    [Tags]           Respcode:422
    run keyword and continue on failure  Post Admin Commodity Fail422   commodity_name=${name}的商品1
    ...          commodity_images=aa  commodity_description=..
    Post Admin Commodity Fail422

Put Admin Commodities
    [Documentation]  接口名:修改商品${\n}
    ...              请求方式:Put${\n}
    ...              预期结果:输入正确id,正确参数,http响应码返回 204。
    [Tags]           Respcode:204
    ${essential_params}  create dictionary  commodity_name=${name}的商品  commodity_images=${commodity_images}
    ...           commodity_description=robottest
    ${unessential_params}  create dictionary  subtitle=商品  commodity_videos=${commodity_videos}
    run every case by params   Put Admin Commodity Success   ${essential_params}  ${unessential_params}  commodity_id=${commodity_id}

Put Admin Commodities Fail404
    [Documentation]  接口名:修改商品${\n}
    ...              请求方式:Put${\n}
    ...              预期结果:输入错误commodity_id,正确参数,http响应码返回 204。
    [Tags]           Respcode:404
    Put Admin Commodity Fail404  commodity_id=sadsadsadsa  commodity_name=${name}的商品  subtitle=商品
    ...    commodity_images=${commodity_images}  commodity_videos=${commodity_videos}  commodity_description=robottest

Put Admin Commodities Fail422
    [Documentation]  接口名:修改商品${\n}
    ...              请求方式:Put${\n}
    ...              预期结果:输入错误参数,正确commodity_id,http响应码返回 204。
    [Tags]           Respcode:204
    ${essential_params}  create dictionary
    ${unessential_params}  create dictionary  subtitle=aa  commodity_videos=aa
    ...                commodity_name=aaa  commodity_images=aaa
    ...           commodity_description=..
    run every case by params   Put Admin Commodity Fail422   ${essential_params}  ${unessential_params}  commodity_id=${commodity_id}

Patch Admin Commodities Operation
    [Documentation]  接口名:商品上架下架接口${\n}
    ...              请求方式:Patch${\n}
    ...              预期结果:输入正确id,正确参数,http响应码返回 204。
    [Tags]           Respcode:204
    Patch Admin Commodities Operation Success  commodity_id=${commodity_id}  operation=2

Patch Admin Commodities Operation Fail404
    [Documentation]  接口名:商品上架下架接口${\n}
    ...              请求方式:Patch${\n}
    ...              预期结果:输入错误id,正确参数,http响应码返回 404。
    [Tags]           Respcode:404
    Patch Admin Commodities Operation Fail404  commodity_id=dsadsadq342334  operation=1

Patch Admin Commodities Operation Fail422
    [Documentation]  接口名:商品上架下架接口${\n}
    ...              请求方式:Patch${\n}
    ...              预期结果:输入错误参数,正确id,http响应码返回 422。
    [Tags]           Respcode:422
    Patch Admin Commodities Operation Fail422  commodity_id=${commodity_id}  operation=dsadsadsadas

Get Admin Commodity Detail
    [Documentation]  接口名:获取商品详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入正确参数,http响应码返回 200,返回的Json数据为 commodity 对象。
    [Tags]           Respcode:200
    Get Admin Commodity Detail Success  commodity_id=${commodity_id}

Get Admin Commodity Detail Fail404
    [Documentation]  接口名:获取商品详情${\n}
    ...              请求方式:Get${\n}
    ...              预期结果:输入错误commodity_id,http响应码返回 404。
    [Tags]           Respcode:404
    Get Admin Commodity Detail Fail404  commodity_id=dsadsadq342334

Post Admin Commodity Specification
    [Documentation]  接口名:创建/修改规格${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入正确参数,http响应码返回 201,返回的Json数据符合验证。
    [Tags]           Respcode:204
    ${specification}  create dictionary  specification_id=28f8c6820b3011ea9d820242ac15000a
    ...   specification_name=库存1
    ...   unit_original_price=12300
    ...   unit_sell_price=1200
    ...   stock=10
    ${specification_objs}  create list  ${specification}
    Post Admin Commodity Specification Success  commodity_id=${commodity_id}  specification_objs=${specification_objs}

Post Admin Commodity Specification Fail404
    [Documentation]  接口名:创建/修改规格${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入错误id,正确参数,http响应码返回 201,返回的Json数据符合验证。
    [Tags]           Respcode:404
    Post Admin Commodity Specification Fail404  commodity_id=dsadsadq342334

Post Admin Commodity Specification Fail422
    [Documentation]  接口名:创建/修改规格${\n}
    ...              请求方式:Post${\n}
    ...              预期结果:输入错误参数,http响应码返回 422,返回的Json数据符合验证。
    [Tags]           Respcode:422
    Post Admin Commodity Specification Fail422  commodity_id=${commodity_id}

Delete Admin Commodities
    [Documentation]  接口名:删除商品${\n}
    ...              请求方式:Delete${\n}
    ...              预期结果:输入正确id,正确参数,http响应码返回 204。
    [Tags]           Respcode:204
    Delete Admin Commodities Success  commodity_id=${commodity_id}

Delete Admin Commodities Fail404
    [Documentation]  接口名:删除商品${\n}
    ...              请求方式:Delete${\n}
    ...              预期结果:输入错误commodity_id,正确参数,http响应码返回 404。
    [Tags]           Respcode:404
    Delete Admin Commodities Fail404  commodity_id=sadsadsadsa


*** Keywords ***
Get Admin Commodities Success
    [Arguments]  &{kwargs}
    ${resp}=  get admin commodities  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 200  ${resp}  admin_commodity/get_200.schema.json

Get Admin Commodities Fail422
    [Arguments]  &{kwargs}
    ${resp}=  get admin commodities  &{kwargs}
    expect status is 422  ${resp}

Get Admin Commodity Detail Success
    [Arguments]  &{kwargs}
    ${resp}=  get admin commodity detail  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 200  ${resp}  admin_commodity/get_detail_200.schema.json

Get Admin Commodity Detail Fail404
    [Arguments]  &{kwargs}
    ${resp}=  get admin commodity detail  &{kwargs}
    expect status is 404  ${resp}

Post Admin Commodity Success
    [Arguments]  &{kwargs}
    ${resp}=  post admin commodities  &{kwargs}
    run keyword and continue on failure  log  ${resp.json()}
    expect status is 201  ${resp}  admin_commodity/post_201.schema.json
    ${commodity_id}  set variable if  "${resp.json()}"!=''  ${resp.json()['commodity_id']}
    set global variable   ${commodity_id}

Post Admin Commodity Fail422
    [Arguments]  &{kwargs}
    ${resp}=  post admin commodities  &{kwargs}
    expect status is 422  ${resp}

Put Admin Commodity Success
    [Arguments]  &{kwargs}
    ${resp}=  put admin commodities  &{kwargs}
    expect status is 204  ${resp}

Put Admin Commodity Fail422
    [Arguments]  &{kwargs}
    ${resp}=  put admin commodities  &{kwargs}
    expect status is 422  ${resp}

Put Admin Commodity Fail404
    [Arguments]  &{kwargs}
    ${resp}=  put admin commodities  &{kwargs}
    expect status is 404  ${resp}

Patch Admin Commodities Operation Success
    [Arguments]  &{kwargs}
    ${resp}=  patch admin commodities operation  &{kwargs}
    expect status is 204  ${resp}

Patch Admin Commodities Operation Fail422
    [Arguments]  &{kwargs}
    ${resp}=  patch admin commodities operation  &{kwargs}
    expect status is 422  ${resp}

Patch Admin Commodities Operation Fail404
    [Arguments]  &{kwargs}
    ${resp}=  patch admin commodities operation  &{kwargs}
    expect status is 404  ${resp}

Post Admin Commodity Specification Success
    [Arguments]  &{kwargs}
    ${resp}=   post admin commodity specification  &{kwargs}
    expect status is 204  ${resp}

Post Admin Commodity Specification Fail422
    [Arguments]  &{kwargs}
    ${resp}=  post admin commodity specification  &{kwargs}
    expect status is 422  ${resp}

Post Admin Commodity Specification Fail404
    [Arguments]  &{kwargs}
    ${resp}=  post admin commodity specification  &{kwargs}
    expect status is 404  ${resp}

Delete Admin Commodities Success
    [Arguments]  &{kwargs}
    ${resp}=  delete admin commodities  &{kwargs}
    expect status is 204  ${resp}

Delete Admin Commodities Fail404
    [Arguments]  &{kwargs}
    ${resp}=  delete admin commodities  &{kwargs}
    expect status is 404  ${resp}