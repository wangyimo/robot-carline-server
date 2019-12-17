# -*- coding: utf-8 -*-
import shutil
import uuid
import random
import time
import os
import xlwt
import xlsxwriter
import math
from faker import Faker
from robot.api import logger


def deprecated(reason):
    def _decorator(func):
        def _wrapper(*args, **kwargs):
            warn_str = '警告:%s 这个方法已经过期! 原因: %s' % (func.__name__, reason)
            logger.console('\033[0;31m\n%s\033[0m' % warn_str)
            return func(*args, **kwargs)

        return _wrapper

    return _decorator


class BaseUtilsLibrary(object):
    """
    自定义功能类
    """

    @classmethod
    def faker_telephone_num(cls):
        """
        生成虚假手机号
        :return: 虚假手机号
        """
        fake = Faker("zh_CN")
        telephone_num = fake.phone_number()
        return telephone_num

    @classmethod
    def faker_car_id(cls):
        """
        生成虚假车牌号
        :return: 虚假车牌号
        """
        fake = Faker("zh_CN")
        car_id = fake.license_plate()
        return car_id

    @classmethod
    def faker_name(cls):
        """
        生成虚假测试名字
        :return: 虚假测试名字
        """
        fake = Faker(locale='zh_CN')
        fake_name = fake.name()
        return fake_name

    @classmethod
    # @deprecated('方法已经弃用,请使用 BaseUtilsLibrary.generate_car_id')
    def get_car_id(cls):
        """
        生成随机车牌号
        :return: 随机车牌号
        """
        # fake1 = Factory.create()
        # data = fake1.license_plate()
        data = "辽A"
        for index in range(0, 5):
            num = random.randint(0, 9)
            chars = chr(random.randint(65, 91))
            if (random.randint(0, 9)) % 2 == 0:
                data = data + str(num)
            else:
                data = data + str(chars)
        print(data)
        return data

    @classmethod
    # @deprecated('方法已经弃用,请使用 BaseUtilsLibrary.generate_phone_num或BaseUtilsLibrary.generate_num')
    def make_num(cls, start='', end=11):
        """
        生成纯数字字符串,默认为生成131-189开头的手机号
        :param start: 当传入start属性时会以此属性指定的字符串作为字符串的开头
        :param end: 当传入end属性时会随机生成end属性指定长度的字符串
        :return: 纯数字字符串或start开头的纯数字字符串
        """
        if end == 11:
            num_str = start + str(random.randint(131, 189))
        else:
            num_str = start + ''
        for i in range(len(num_str), int(end)):
            num = random.randint(0, 9)
            num_str = num_str + str(num)
        return num_str

    @classmethod
    # @deprecated('方法已经弃用,请使用 BaseUtilsLibrary.generate_uuid_to_string')
    def get_uuid(cls):
        """
        生成uuid并处理为32位无"-"连接格式字符串
        :return:32位无"-"连接字符串形式UUID
        """
        ids = uuid.uuid1()
        ids = str(ids)
        ids = ids.replace("-", "")
        return ids

    @classmethod
    # @deprecated('方法已经弃用,请使用 BaseUtilsLibrary.generate_time_as_string')
    def make_time(cls):
        """
        获取当前时间戳的字符串形式
        :return: 时间戳的字符串形式
        """
        return str(time.time())

    @classmethod
    # @deprecated('方法已经弃用,请使用 BaseUtilsLibrary.generate_time_as_string,allow_symbol参数设为False')
    def make_time_as_string(cls):
        """
        生成字符串形式时间戳,并把"."去掉
        :return: 字符串形式时间戳
        """
        time_str = str(time.time())
        time_str = time_str.replace(".", "")
        return time_str

    @classmethod
    # @deprecated('方法已经弃用,请使用 BaseUtilsLibrary.get_current_sec')
    def make_now_second(cls):
        """
        获取北京时间的从当天00:00:00到此时的秒数
        :return: 秒数
        """
        return int(str(time.time())[0:10]) % (24 * 60 * 60) + (8 * 60 * 60)

    @classmethod
    def generate_random_string(cls, length, prefix=None, suffix=None, allow_number=False, allow_caps_letter=False,
                               allow_lower_letter=False):
        """
        生成随机字符串
        :param length: 长度
        :type length: int
        :param prefix: 前缀
        :type prefix: str
        :param suffix: 后缀
        :type suffix: str
        :param allow_number:允许数字
        :type allow_number:bool
        :param allow_caps_letter:允许大写字母
        :type allow_caps_letter:bool
        :param allow_lower_letter:允许小写字母
        :type allow_lower_letter:bool
        :return:随机字符串
        :rtype:str
        """
        num_chars = '0123456789'
        caps_letter_chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
        lower_letter_chars = 'abcdefghijklmnopqrstuvwxyz'
        random_chars = ''
        if allow_number:
            random_chars += num_chars
        if allow_caps_letter:
            random_chars += caps_letter_chars
        if allow_lower_letter:
            random_chars += lower_letter_chars
        if prefix is None:
            prefix = ''
        if suffix is None:
            suffix = ''
        random_string = prefix
        for _ in range(int(length) - (len(prefix) + len(suffix))):
            random_string += random.choice(random_chars)
        random_string += suffix
        return random_string

    @classmethod
    def generate_phone_num(cls, length=11, prefix=None, suffix=None):
        """
        生成随机手机号
        :param length: 长度
        :type length: int
        :param prefix: 前缀
        :type prefix: str
        :param suffix: 后缀
        :type  suffix: str
        :return: 随机手机号
        :rtype: str
        """
        if prefix is None:
            prefix = str(random.randint(131, 189))
        if suffix is None:
            suffix = ''
        phone_num = cls.generate_random_string(length, prefix=prefix, suffix=suffix, allow_number=True)
        return phone_num

    @classmethod
    def generate_num(cls, length, prefix=None, suffix=None):
        """
        生成随机手机号
        :param length: 长度
        :type length: int
        :param prefix: 前缀
        :type prefix: str
        :param suffix: 后缀
        :type  suffix: str
        :return: 随机手机号
        :rtype: str
        """
        if prefix is None:
            prefix = ''
        if suffix is None:
            suffix = ''
        num = cls.generate_random_string(length, prefix=prefix, suffix=suffix, allow_number=True)
        return num

    @classmethod
    def generate_car_id(cls, length=7, prefix=None, suffix=None):
        """
        生成随机车牌号
        :param length: 长度
        :type length: int
        :param prefix: 前缀
        :type prefix: str
        :param suffix: 后缀
        :type  suffix: str
        :return: 随机手机号
        :rtype: str
        """
        province_list = ['辽', '豫', '鄂', '琼', '桂', '湘', '皖', '云', '陕', '蒙', '京', '冀', '黑', '新', '苏', '甘', '晋',
                         '浙', '闽', '渝', '吉', '贵', '粤', '川', '鲁', '津', '沪']
        city_list = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'J', 'K', 'L', 'M', 'N', 'P', 'Q', 'R', 'S']
        if prefix is None:
            prefix = random.choice(province_list) + random.choice(city_list)
        if suffix is None:
            suffix = ''
        car_id = cls.generate_random_string(length, prefix=prefix, suffix=suffix, allow_number=True,
                                            allow_caps_letter=True)
        return car_id

    @classmethod
    def generate_url(cls, length=23, prefix=None, suffix=None):
        """
        生成随机url
        :param length: 长度>=16
        :type length: int
        :param prefix: 前缀
        :type prefix: str
        :param suffix: 后缀
        :type  suffix: str
        :return: 随机url
        :rtype: str
        """
        if prefix is None:
            prefix = 'http://www.'
        if suffix is None:
            suffix = '.com'
        url = cls.generate_random_string(length, prefix=prefix, suffix=suffix, allow_caps_letter=True,
                                         allow_lower_letter=True, allow_number=True)
        return url

    @classmethod
    def generate_uuid_to_string(cls, allow_symbol=False):
        """
        生成uuid字符串,可以选择是否用'-'符号分割
        :param allow_symbol: 允许‘-’
        :type allow_symbol:bool
        :return: uuid字符串
        :rtype:str
        """
        uuid_str = str(uuid.uuid1())
        if not allow_symbol:
            uuid_str = uuid_str.replace("-", '')
        return uuid_str

    @classmethod
    def generate_time_as_string(cls, allow_symbol=True, only_int=False):
        """
        获取当前时间戳的字符串形式
        :param only_int: 只为整数
        :type only_int: bool
        :param allow_symbol: 允许‘.’
        :type allow_symbol: bool
        :return: 时间戳的字符串
        :rtype: str
        """
        time_str = str(time.time())
        if only_int:
            time_str = time_str.split('.')[0]
        if not allow_symbol:
            time_str = time_str.replace(".", "")
        return time_str

    @classmethod
    def get_current_sec(cls, only_today=True, timezone=8):
        """
        获取此时的秒数,
        :param only_today:是否从当天00:00:00开始
        :type only_today:bool
        :param timezone:时区(默认为北京时间)
        :type timezone:int
        :return:秒数
        :rtype:int
        """
        sec = int(str(time.time())[0:10])
        if only_today:
            sec = sec % (24 * 60 * 60)
        sec = sec + (int(timezone) * 60 * 60)
        return sec

    @classmethod
    def add_number(cls, *args):
        """
        提供了数字相加的方式,如果是字符串会转成数字
        :param args: 需要相加的数字
        :return: 总和
        :rtype: int
        """
        plus_num = 0
        for i in args:
            plus_num = plus_num + int(i)
        return plus_num

    @classmethod
    def move_file(cls, old_file_path, new_dir_path):
        """
        检查并转移文件到指定文件夹
        :param old_file_path:文件在系统中的路径(例：/home/xxx/下载/filename)
        :type old_file_path:str
        :param new_dir_path: 要放到的项目中的路径(例：tests/server_project)
        :type new_dir_path:str
        """
        if os.path.isfile(old_file_path):
            file_name = old_file_path.split('/')[-1]
            shutil.move(old_file_path, '%s/%s/%s' % (os.getcwd(), new_dir_path, file_name))
        else:
            print('文件%s不存在' % old_file_path)

    @classmethod
    def write_xls(cls, rows, cols_name, cols_value, sheet_name, file_name):
        """
        生成xls文件
        :param rows:行数
        :type rows: int
        :param cols_name:每行的表头(逗号分割)
        :type cols_name: str
        :param cols_value:每行的值(逗号分割)
        :type cols_value: str
        :param sheet_name:表名
        :type sheet_name: str
        :param file_name:文件名
        :type sheet_name: str
        """
        rows = int(rows)
        cols_name = cols_name.split(",")
        cols_value = cols_value.split(",")
        times = int(math.ceil(rows / 65535))
        this_rows = 0
        work_book = xlwt.Workbook(encoding='utf-8')
        for _ in range(0, times):
            sheet = work_book.add_sheet(str(sheet_name) + str(_))
            if rows <= 65534:
                this_rows = rows + 1
            elif rows > 65534:
                this_rows = 65535
                rows -= 65534
            for i in range(0, this_rows):
                for j in range(0, len(cols_name)):
                    if i == 0:
                        sheet.write(i, j, str(cols_name[j]))
                    else:
                        if j in (0, 1):
                            cols_value[j] = int(cols_value[j]) + 1
                        sheet.write(i, j, str(cols_value[j]))
        work_book.save(str(file_name))

    def parsedata(self, dictdata, columns=[]):
        result = []
        if columns == []:
            keys = dictdata.keys()
        else:
            keys = columns
        result.append([key for key in keys])
        values = []
        for key in keys:
            values.append(dictdata[key])
        values = zip(*values)
        for value in values:
            result.append(list(value))
        return result

    @classmethod
    def auto_write_xls(cls, sheet_name, file_name, row, col, data, dictdata, bugnum_terminal):
        workbook = xlsxwriter.Workbook(file_name)
        worksheet = workbook.add_worksheet(sheet_name)
        worksheet.write_row(row, col, data, cell_format=None)
        worksheet.write_column(row, col, data, cell_format=None)
        # worksheet.write_row("A1", 一行数据, 样式（非必填项）)
        # worksheet.write('A1', '大类')
        # worksheet.write('B1', '项目')
        # worksheet.write('C1', '项目ID')
        # worksheet.write('D1', '关联')
        # worksheet.write('E1', '类型')
        # worksheet.write('A2', '1')
        # worksheet.write('B2', '发动机机油')
        # worksheet.write('C2', '555')
        # worksheet.write('D2', '556')
        # worksheet.write('E2', '100')
        # expenses = (
        #     ['大类', '项目', '项目ID', '关联', '类型'],
        #     ['1', '发动机机油', 555, 556, 100],
        # )
        # row = 0
        # col = 0
        # for item, cost in (expenses):
        #     worksheet.write(row, col, item)
        #     worksheet.write(row, col + 1, cost)
        #     row += 1
        workbook.close()

    @classmethod
    def auto_create_bug_level_tag(cls, resp_code, status_code):
        """
        生成状态码错误等级标签
        :param resp_code:实际返回的状态码
        :type resp_code:int
        :param status_code:预期的状态码
        :type status_code:int
        :return:标签内容
        :rtype:str
        """
        bug_level = None
        resp_code = int(resp_code)
        status_code = int(status_code)
        if status_code == 200 and resp_code in (201, 204):
            bug_level = 'Major'
        if status_code == 200 and resp_code == 202:
            bug_level = 'Critical'
        if status_code in (201, 204) and resp_code == 200:
            bug_level = 'Major'
        if status_code == 201 and resp_code in (202, 204):
            bug_level = 'Critical'
        if status_code == 204 and resp_code == 201:
            bug_level = 'Major'
        if status_code == 204 and resp_code == 202:
            bug_level = 'Critical'
        if status_code in (200, 201, 202, 204) and resp_code in (400, 401, 403, 404, 405, 410, 422):
            bug_level = 'Critical'
        if status_code in (301, 302, 304) and resp_code in (301, 302, 304) and status_code != resp_code:
            bug_level = 'Major'
        if status_code == 400 and resp_code in (200, 201, 202, 204):
            bug_level = 'Major'
        if status_code == 400 and resp_code in (301, 302, 304):
            bug_level = 'Major'
        if status_code == 400 and resp_code in (401, 403, 404, 405, 410, 422):
            bug_level = 'Minor'
        if status_code in (401, 403) and resp_code in (200, 201, 202, 204):
            bug_level = 'Critical'
        if status_code in (401, 403) and resp_code in (400, 404, 405, 410, 422):
            bug_level = 'Minor'
        if status_code in (404, 410) and resp_code in (200, 201, 202, 204):
            bug_level = 'Major'
        if status_code in (404, 410) and resp_code in (400, 401, 405, 403, 422):
            bug_level = 'Major'
        if status_code == 405 and resp_code in (200, 201, 202, 204):
            bug_level = 'Major'
        if status_code == 405 and resp_code in (400, 401, 403, 404, 410, 422):
            bug_level = 'Minor'
        if status_code == 422 and resp_code in (200, 201, 202, 204):
            bug_level = 'Critical'
        if status_code == 422 and resp_code in (400, 401, 403, 404, 405, 410):
            bug_level = 'Major'
        if resp_code == 500:
            bug_level = 'Blocker'
        if resp_code == 502:
            bug_level = 'Minor'
        if resp_code == 504:
            bug_level = 'Minor'
        if status_code == 405 and resp_code in (301, 302, 304):
            bug_level = 'Major'
        if bug_level is not None:
            bug_level = 'BugLevel:' + bug_level
        return bug_level

    @classmethod
    def auto_create_status_tag(cls, resp_code, status_code):
        """
        生成状态码动态标签
        :param resp_code:实际返回的状态码
        :type resp_code:int
        :param status_code:预期的状态码
        :type status_code:int
        :return:标签内容
        :rtype:str
        """
        status_tag = None
        if str(resp_code) != str(status_code):
            status_tag = 'ShouldBe:' + str(status_code) + 'But:' + str(resp_code)
        return status_tag

    @classmethod
    def auto_params(cls, essential_params, unessential_params, success=True):
        """
        将必传参数与每个非必传参数依次组合并返回结果集
        :param essential_params:必传参数
        :type essential_params:dict
        :param unessential_params:非必传参数
        :type unessential_params:dict
        :param success:是否多种情况
        :type success:bool
        :return:参数组合的结果集
        :rtype:list
        """
        results = []
        if len(essential_params) != 0:
            params = essential_params.copy()
        else:
            params = {}
        if success is True:
            if len(unessential_params) != 0:
                for k, v in unessential_params.items():
                    data = params.copy()
                    data[k] = v
                    results.append(data)
                print(results)
            else:
                results.append(params)
        else:
            if len(unessential_params) != 0:
                for k, v in unessential_params.items():
                    data = params.copy()
                    data[k] = v
                    results.append(data)
            else:
                results.append(params)
        return results


if __name__ == '__main__':
    bu = BaseUtilsLibrary()
    pass
