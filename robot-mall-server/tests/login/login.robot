*** Settings ***
Documentation   用户登录
Resource        ../resources.robot
Library         robot_mall_service_library.login.LoginLibrary
Force Tags      login

*** Variables ***


*** Test Cases ***
Login Test
    [Documentation]     接口名：帐号登录
    ...                 请求方式:Post
    ...                 预期结果：登录成功。
    [Tags]                  RespCode:204
    Login Success           admin  admin123

Login Failures
    [Documentation]     接口名：帐号登录
    ...                 请求方式:Post
    ...                 预期结果：登录失败。
    [Tags]                  RespCode:422
    Login Failure           admin  admin
    Login Failure           ad  admin123

Logout Test
    [Documentation]     接口名：帐号注销
    ...                 请求方式:Post
    ...                 预期结果：注销成功。
    [Tags]                  RespCode:204
    ${resp} =               Logout
    Status Should be        ${resp}  204


*** Keywords ***
Login Success
    [Arguments]             ${username}  ${password}
    ${resp} =               Login  ${username}  ${password}
    expect status is 204    ${resp}


Login Failure
    [Arguments]             ${username}  ${password}
    ${resp} =               Login  ${username}  ${password}
    expect status is 422    ${resp}
