from robot_mall_user_library.common import CommonLibrary


class OrderLibrary(CommonLibrary):
    def post_user_order(self, **kwargs):
        """
        用户创建订单
        """
        url = "{SERVER_DOMAIN}/user/orders".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        data = {}
        for k, v in kwargs.items():
            if k in ("commodity_id", "specification_id", "delivery_region", "delivery_address",
                     "contact", "mobile", "amount"):
                data[k] = v
        return self.client.post(url, json=data)

    def post_user_order_pay(self, order_id, **kwargs):
        """
        订单支付
        """
        url = "{SERVER_DOMAIN}/user/orders/{order_id}/pay".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, order_id=order_id)
        data = {}
        for k, v in kwargs.items():
            if k in ("pay_type", "open_id"):
                data[k] = v
        return self.client.post(url, json=data)

    def get_order_by_order_id(self, order_id):
        """
        查看订单
        """
        url = "{SERVER_DOMAIN}/user/orders/{order_id}".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, order_id=order_id)
        return self.client.get(url)

    def put_cancel_order(self, order_id):
        """
        取消订单
        """
        url = "{SERVER_DOMAIN}/user/orders/{order_id}/cancel".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, order_id=order_id)
        return self.client.put(url)

    def put_accept_order(self, order_id):
        """
        用户确认收货
        """
        url = "{SERVER_DOMAIN}/user/orders/{order_id}/delivery_status".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, order_id=order_id)
        return self.client.put(url)
