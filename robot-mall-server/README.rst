=====================
robot car line server
=====================

`Robot Framework`_ is a generic open source test automation framework.

.. _Robot Framework: http://robotframework.org/

Running
-------

::

    #创建虚拟环境
    virtualenv -p python3 /usr/local/envs/mall
    #进入虚拟环境
    source /usr/local/envs/mall/bin/activate
    #退出虚拟环境
    deactivate
    #保存虚拟环境
    file-settings-project:xx-project Interpreter

    # 依赖安装
    pip install -r requirements.txt

    # 测试所有
    robot -d results --pythonpath . -v VERSION:d tests/

    # 测试所有--除了login
    robot -d results --pythonpath . -v VERSION:d -e login tests/

    # 测试所有--除了login,不登录
    robot -d results --pythonpath . -v VERSION:d -e login -e WithoutLogin tests/

    # 测试login
    robot -d results --pythonpath . -v VERSION:d -i login tests/

    # 测试不登录
    robot -d results --pythonpath . -v VERSION:d -i WithoutLogin tests/

    # 自动生成robot和libarary已知缺陷：
    1.文档中多个开关在一个url中的无法拆分
    2.登录功能生成错误需要手写，并删除错误文件
    3.参数赋值可能不同需要人工校验
    4.jsonschema无法自动生成
    5.有些无法测试的功能，在生成后需要删除
    6.多模块引用需要手动添加
    7.取url中的id时取不到

