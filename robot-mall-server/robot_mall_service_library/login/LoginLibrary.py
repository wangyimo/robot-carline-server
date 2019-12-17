from robot_mall_service_library.common import CommonLibrary


class LoginLibrary(CommonLibrary):
    def login(self, username, password, **kwargs):
        return super(LoginLibrary, self).login(username, password)

    def logout(self):
        return super(LoginLibrary, self).logout()
