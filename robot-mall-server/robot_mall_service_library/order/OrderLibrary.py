from robot_mall_service_library.common import CommonLibrary


class OrderLibrary(CommonLibrary):
    def get_admin_orders(self, **kwargs):
        """
        订单列表
        """
        url = '{SERVER_DOMAIN}/admin/orders'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        data = {}
        for k, v in kwargs.items():
            if k in ('pay_status', 'delivery_status', 'mobile',
                     'contact', 'order_id', 'commodity_name', 'order_time',
                     'pay_time', 'page_size', 'page_num'):
                data[k] = v
        return self.client.get(url, params=data)

    def get_admin_order_detail(self, order_id):
        """
        订单详情
        """
        url = '{SERVER_DOMAIN}/admin/orders/{order_id}'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, order_id=order_id)
        return self.client.get(url)

    def put_admin_order(self, order_id, **kwargs):
        """
        修改订单
        """
        url = '{SERVER_DOMAIN}/admin/orders/{order_id}'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, order_id=order_id)
        data = {}
        for k, v in kwargs.items():
            if k in ('delivery_company', 'delivery_order', 'postage'):
                data[k] = v
        return self.client.put(url, json=data)

    def patch_admin_order_delivery(self, order_id):
        """
        确认收货
        """
        url = '{SERVER_DOMAIN}/admin/orders/{order_id}/delivery'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, order_id=order_id)
        return self.client.patch(url)

    def get_orders_export(self, **kwargs):
        """
        订单导出
        """
        url = '{SERVER_DOMAIN}/admin/orders'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        data = {}
        for k, v in kwargs.items():
            if k in ('pay_status', 'delivery_status', 'mobile',
                     'contact', 'order_id', 'commodity_name', 'order_time',
                     'pay_time', 'page_size', 'page_num'):
                data[k] = v
        return self.client.get(url, params=data)
