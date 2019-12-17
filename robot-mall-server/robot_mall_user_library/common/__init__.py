import requests

from robot.errors import VariableError
from robot.running import EXECUTION_CONTEXTS
import base64


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
    refresh_token = 0
    access_token = 0

    def __init__(self):
        self.SERVER_DOMAIN = self.get_variable('${SERVER_DOMAIN}')
        self.AUTH_CLIENT_ID = self.get_variable('${AUTH_CLIENT_ID}')
        self.AUTH_CLIENT_SECRET = self.get_variable('${AUTH_CLIENT_SECRET}')
        self.UU_CLIENT_ID = self.get_variable('${UU_CLIENT_ID}')
        self.UU_SECRET = self.get_variable('${UU_SECRET}')
        super(CommonLibrary, self).__init__()

    def get_auth_token(self, uu_token):
        global access_token
        global refresh_token
        data = {
            'grant_type': 'uu_token',
            'client_id': 'a6b59882137a47fc8cda27d871d75afe',
            'client_secret': '8ba89220284d42bd99b8f125f7891314',
            'token': uu_token,
        }
        url = "https://auth-d.parkone.cn/oauth/2.0/token"
        resp = self.client.post(url, data=data)
        print(resp.json())
        print(resp.status_code)
        return resp

    def login_by_openid(self, mp_openid):
        global access_token
        global refresh_token
        print(mp_openid)
        data = {
            'grant_type': 'wechat',
            'client_id': 'b865a5a273f249af85693bb20e1a707b',
            'client_secret': 'fe1f00466c1d4c858ba6abc4dc200809',
            'app_code': 'sy_wxmp',
            'mp_openid': mp_openid,
        }
        url = "https://uu-wxmp-d.parkone.cn/mp/oauth/2.0/token"
        resp = self.client.post(url, data=data)
        print(resp.status_code)
        if resp.status_code == 200:
            access_token1 = resp.json()["access_token"]
            print(access_token1)
            resp = self.get_auth_token(access_token1)
            access_token = resp.json()["access_token"]
            print(access_token)
            self.client.headers.update({
                "Authorization": "token "+access_token,
                "X-UU-TOKEN": "token "+access_token1
            })
        return resp

    # def login_by_unionid(self, unionid):
    #     global access_token
    #     global refresh_token
    #     print(unionid)
    #     data = {
    #         'client_id': self.UU_CLIENT_ID,
    #         'secret': self.UU_SECRET,
    #         'unionid': unionid,
    #     }
    #     url = "{SERVER_DOMAIN}/login_by_unionid".format(
    #         SERVER_DOMAIN=self.SERVER_DOMAIN)
    #     resp = self.client.post(url, data=data)
    #     print(resp.status_code)
    #     if resp.status_code == 200:
    #         access_token = resp.json()["access_token"]
    #         print(access_token)
    #         resp = self.get_auth_token(access_token)
    #         access_token = resp.json()["access_token"]
    #         print(access_token)
    #         self.client.headers.update({
    #             "Authorization": "token "+access_token,
    #         })
    #     return resp

    #
    # def login_by_mobile(self, openid, mobile, captcha):
    #     global access_token
    #     global refresh_token
    #     index = self.send_login_mobile_captcha(mobile)
    #     serie = index.json()['serie']
    #     print("serie:"+serie)
    #     data = {
    #         'client_id': self.UU_CLIENT_ID,
    #         'secret': self.UU_SECRET,
    #         'mobile': mobile,
    #         'serie': serie,
    #         'captcha': captcha,
    #         'openid': openid
    #     }
    #     url = "{SERVER_DOMAIN}/login_by_mobile".format(
    #         SERVER_DOMAIN=self.SERVER_DOMAIN)
    #     resp = self.client.post(url, data=data)
    #     if resp.status_code == 200:
    #         access_token = resp.json()["access_token"]
    #         refresh_token = resp.json()["refresh_token"]
    #         self.client.headers.update({
    #             "Authorization": "token "+access_token,
    #         })
    #     return resp
    #
    # def send_login_mobile_captcha(self, mobile):
    #     data = {"mobile": mobile}
    #     print(mobile)
    #     url = "http://passport-t.uucin.com/accounts/send_login_mobile_captcha"
    #     client_id = self.UU_CLIENT_ID
    #     client_id = bytes(client_id, encoding='utf-8')
    #     x_clinent_id = base64.urlsafe_b64encode(client_id)
    #     x_clinent_id = str(x_clinent_id, encoding='utf-8')
    #     self.client.headers.update({"X-CLIENT-ID": x_clinent_id})
    #     resp = self.client.post(url, data=data)
    #     print("captcha:"+str(resp.json()))
    #     return resp
    #
    # def get_openid(self, token):
    #     data = {
    #         'tokenid': token
    #     }
    #     url = '{SERVER_DOMAIN}/openid_by_tokenid'.format(
    #         SERVER_DOMAIN=self.SERVER_DOMAIN)
    #     resp = self.client.get(url, params=data)
    #     return resp

    def logout(self):
        url = '{SERVER_DOMAIN}/logout'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        resp = self.client.post(url)
        return resp
