import requests
import time

from robot.api import logger
from robot.errors import VariableError
from robot.running import EXECUTION_CONTEXTS


class _CommonLibrary(object):
    def __init__(self):
        super(_CommonLibrary, self).__init__()

    @property
    def ctx(self):
        return EXECUTION_CONTEXTS.current

    @property
    def client(self):
        if hasattr(self.ctx, 'client'):
            return getattr(self.ctx, 'client')
        else:
            client = requests.session()
            setattr(self.ctx, 'client', client)
            return client

    @property
    def variables(self):
        return self.ctx.variables

    def get_variable(self, name, default=None):
        try:
            return self.variables[name]
        except VariableError:
            return default


class CommonLibrary(_CommonLibrary):
    def __init__(self):
        self.SERVER_DOMAIN = self.get_variable('${SERVER_DOMAIN}')
        super(CommonLibrary, self).__init__()

    def user(self):
        resp = self._get_user()
        if resp.status_code == 200:
            return resp.json()
        else:
            return None

    def login(self, username, password):
        data = {
            'username': username,
            'password': password,
        }
        url = "https://operation-server-d.parkone.cn/login".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        resp = self.client.post(url, data=data)
        return resp

    def logout(self):
        url = "https://operation-server-d.parkone.cn/logout".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        resp = self.client.get(url)
        return resp

    def get_user(self):
        url = "{SERVER_DOMAIN}/users".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        resp = self.client.get(url)
        return resp
