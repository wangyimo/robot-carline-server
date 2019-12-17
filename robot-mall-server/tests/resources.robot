*** Settings ***
Documentation   This is documentation for this test suite.
...             This kind of documentation can often be get quite long...
Resource        resources/resources-${VERSION}.robot
Library         JSONSchemaLibrary  tests
Library         utils_library.BaseUtilsLibrary
Library         robot.libraries.Collections


*** Variables ***
@{422list}   ImRobotTest1  ImRobotTest2  ImRobotTest3


*** Keywords ***
Status Should be
    [Documentation]     检测响应状态是否符合预期值。
    ...                 {resp}: 响应实体。
    ...                 {status_code}: 预期的响应状态。
    [Arguments]         ${resp}  ${status_code}
    # 跑全局需注释掉log
#    log                 ${resp.content}
    log                 ${resp.url}
    Should Be Equal As Integers    ${resp.status_code}  ${status_code}
    [Teardown]          run keyword if  '${KEYWORD_STATUS}'=='FAIL'  log  ${SUITE_NAME}模块中的接口：${resp.url[36:]} 错误。test_case：${TEST_NAME}:应返回${status_code}，但返回${resp.status_code}。  WARN
    [Return]            ${KEYWORD_STATUS}

To Validate Json
    [Documentation]     检测响应状态是否符合预期值。
    ...                 {schema}:JsonSchema验证。
    ...                 {resp}:响应实体。
    [Arguments]         ${schema}  ${resp}
    pass execution if  '${schema}'=='NoSchema'  Json:无需验证Json，通过。
    run keyword and continue on failure  validate json       ${schema}  ${resp.json()}
    [Teardown]          run keyword if  '${KEYWORD_STATUS}'=='FAIL'  Log  ${SUITE_NAME}模块中的接口：${resp.url[36:]}错误。test_case：${TEST_NAME}:Json验证错误。  ERROR
    [Return]            ${KEYWORD_STATUS}

Expect Status is 200
    [Documentation]     期待响应状态是否为200 OK，返回的json格式是否符合验证。
    ...                 {resp}: 响应实体。
    ...                 {schema}: 对应的jsonschema校验文件。
    [Arguments]         ${resp}  ${schema}
    ${bug_level}=       auto create bug level tag  ${resp.status_code}  200
    set tags            ${bug_level}
    ${status_tag}=      auto create status tag  ${resp.status_code}  200
    set tags            ${status_tag}
    ${re}=              status should be    ${resp}  200
    ${js}=              to validate json    ${schema}  ${resp}
    auto creat jsonerror tag  ${re}  ${js}
    log  ${resp.elapsed.microseconds/1000}
    ${elapsed}    convert to integer   ${resp.elapsed.microseconds/1000}
    Auto Elapsed   ${elapsed}

Expect Status is 201
    [Documentation]     检测响应状态是否为201 Created，返回的json格式是否符合验证。
    ...                 {resp}: 响应实体。
    ...                 {schema}: 对应的jsonschema校验文件。
    [Arguments]         ${resp}  ${schema}
    ${bug_level}=       auto create bug level tag  ${resp.status_code}  201
    set tags            ${bug_level}
    ${status_tag}=      auto create status tag  ${resp.status_code}  201
    set tags            ${status_tag}
    ${re}=              status should be    ${resp}  201
    ${js}=              to validate json    ${schema}  ${resp}
    auto creat jsonerror tag  ${re}  ${js}
    log  ${resp.elapsed.microseconds/1000}
    ${elapsed}    convert to integer   ${resp.elapsed.microseconds/1000}
    Auto Elapsed   ${elapsed}

Expect Status is 204
    [Documentation]     检测响应状态是否为204 No Content。
    ...                 {resp}: 响应实体。
    [Arguments]         ${resp}
    ${bug_level}=       auto create bug level tag  ${resp.status_code}  204
    set tags            ${bug_level}
    ${status_tag}=      auto create status tag  ${resp.status_code}  204
    set tags            ${status_tag}
    Status Should be    ${resp}  204
    log  ${resp.elapsed.microseconds/1000}
    ${elapsed}    convert to integer   ${resp.elapsed.microseconds/1000}
    Auto Elapsed   ${elapsed}

Expect Status is 403
    [Documentation]     检测响应状态是否为403 Forbidden。
    ...                 {resp}: 响应实体。
    [Arguments]         ${resp}
    ${bug_level}=       auto create bug level tag  ${resp.status_code}  403
    set tags            ${bug_level}
    ${status_tag}=      auto create status tag  ${resp.status_code}  403
    set tags            ${status_tag}
    Status Should be    ${resp}  403
    log  ${resp.elapsed.microseconds/1000}
    ${elapsed}    convert to integer   ${resp.elapsed.microseconds/1000}
    Auto Elapsed   ${elapsed}

Expect Status is 404
    [Documentation]     检测响应状态是否为404 Not Found。
    ...                 {resp}: 响应实体。
    [Arguments]         ${resp}
    ${bug_level}=       auto create bug level tag  ${resp.status_code}  404
    set tags            ${bug_level}
    ${status_tag}=      auto create status tag  ${resp.status_code}  404
    set tags            ${status_tag}
    Status Should be    ${resp}  404
    log  ${resp.elapsed.microseconds/1000}
    ${elapsed}    convert to integer   ${resp.elapsed.microseconds/1000}
    Auto Elapsed   ${elapsed}

Expect Status is 422
    [Documentation]     检测响应状态是否为422 Unprocessable Entity，返回的json格式是否符合验证。
    ...                 {resp}: 响应实体。
    [Arguments]         ${resp}
    ${bug_level}=       auto create bug level tag  ${resp.status_code}  422
    set tags            ${bug_level}
    ${status_tag}=      auto create status tag  ${resp.status_code}  422
    set tags            ${status_tag}
    ${re}=              Status Should be    ${resp}  422
    ${js}=              to validate json    common/error_422.schema.json  ${resp}
    auto creat jsonerror tag  ${re}  ${js}
    log  ${resp.elapsed.microseconds/1000}
    ${elapsed}    convert to integer   ${resp.elapsed.microseconds/1000}
    Auto Elapsed   ${elapsed}

Auto Creat JsonError Tag
    [Documentation]     根据状态自动生成’Json返回错误‘类提示Tag。
    ...                 {re}:状态码判断keyword状态。
    ...                 {js}:json判断keyword状态。
    [Arguments]         ${re}  ${js}
    run keyword if  '${re}'=='PASS' and '${js}'=='FAIL'  set tags  BugLevel:Minor  JsonReturnError

Auto Elapsed
    [Arguments]         ${elapsed}
    ${elapsed}    convert to integer  ${elapsed}
    run keyword if  ${elapsed} <= 100  set tags  RespTime:100ms
    ...    ELSE IF   100 < ${elapsed} <= 200  set tags  RespTime:100ms~200ms
    ...    ELSE IF   200 < ${elapsed} <= 500  set tags  RespTime:200ms~500ms
    ...    ELSE IF   500 < ${elapsed} <= 2000  set tags  RespTime:500ms~2000ms
    ...    ELSE IF   ${elapsed} > 2000   set tags  RespTime:2000ms

Run Every Case By Params
    [Documentation]     解析传入的参数并以规定方式运行各种情况。
    ...                 {case_name}:测试用例名字。
    ...                 {essential_params}:必传参数。
    ...                 {unessential_params}:非必传参数。
    ...                 {success}:默认为True，当需要运行422情况时填入success=False。
    ...                 {url_parttern}:当需要向方法中传入url时填写
    [Arguments]  ${case_name}  ${essential_params}  ${unessential_params}  ${success}=True  &{url_parttern}
    ${results}  auto params  ${essential_params}  ${unessential_params}  ${success}
    :FOR  ${kwargs}  IN  @{results}
    \  run keyword and continue on failure  ${case_name}  &{url_parttern}  &{kwargs}

Select Id In Json
    [Arguments]  ${resp.json()}  ${x_name}  ${x_id}
    ${x_id}                set variable if  ${resp.json()}!=[]  ${resp.json()[0]["x_id"]}
    :FOR  ${i}  IN RANGE  0  ${a}
    \  log  ${resp.json()}[${i}]
    \  ${b}  set variable  ${resp.json()[${i}]['x_name']}
    \  ${coupon_id}  run keyword if  '${b}'=="自动兑换别删"  set variable  ${resp.json()[${i}]['x_id']}
    \  exit for loop if    '${b}'=="自动兑换别删"
