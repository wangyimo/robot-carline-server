from robot_mall_service_library.common import CommonLibrary


class UserLibrary(CommonLibrary):
    def get_user(self):
        """
        获取员工本身信息
        """
        return super(UserLibrary, self).get_user()

    def update_password(self, **kwargs):
        """
        修改密码
        """
        url = "{SERVER_DOMAIN}/user/password".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        params = {}
        for k, v in kwargs.items():
            if k in ('old_password', 'new_password'):
                params[k] = v
        return self.client.patch(url, json=params)
