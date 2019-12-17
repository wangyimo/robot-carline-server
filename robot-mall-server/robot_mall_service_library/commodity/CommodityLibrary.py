from robot_mall_service_library.common import CommonLibrary


class CommodityLibrary(CommonLibrary):
    def post_admin_commodities(self, **kwargs):
        """
        创建商品
        """
        url = '{SERVER_DOMAIN}/admin/commodities'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        data = {}
        for k, v in kwargs.items():
            if k in ('commodity_name', 'subtitle', 'commodity_images',
                     'commodity_videos', 'commodity_description'):
                data[k] = v
        return self.client.post(url, json=data)

    def put_admin_commodities(self, commodity_id, **kwargs):
        """
        修改商品
        """
        url = '{SERVER_DOMAIN}/admin/commodities/{commodity_id}'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, commodity_id=commodity_id)
        data = {}
        for k, v in kwargs.items():
            if k in ('commodity_name', 'subtitle', 'commodity_images',
                     'commodity_videos', 'commodity_description'):
                data[k] = v
        return self.client.put(url, json=data)

    def delete_admin_commodities(self, commodity_id):
        """
        删除商品
        """
        url = '{SERVER_DOMAIN}/admin/commodities/{commodity_id}'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, commodity_id=commodity_id)
        return self.client.delete(url)

    def patch_admin_commodities_operation(self, commodity_id, **kwargs):
        """
        商品上架下架接口
        """
        url = '{SERVER_DOMAIN}/admin/commodities/{commodity_id}'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, commodity_id=commodity_id)
        data = {}
        for k, v in kwargs.items():
            if k in ('operation',):
                data[k] = v
        return self.client.patch(url, json=data)

    def get_admin_commodities(self, **kwargs):
        """
        获取商品列表
        """
        url = '{SERVER_DOMAIN}/admin/commodities'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN)
        data = {}
        for k, v in kwargs.items():
            if k in ('sales_status', 'commodity_name', 'shelf_time',
                     'page_size', 'page_num'):
                data[k] = v
        return self.client.get(url, params=data)

    def get_admin_commodity_detail(self, commodity_id):
        """
        获取商品详情
        """
        url = '{SERVER_DOMAIN}/admin/commodities/{commodity_id}'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, commodity_id=commodity_id)
        return self.client.get(url)

    def post_admin_commodity_specification(self, commodity_id, **kwargs):
        """
        创建/修改规格
        """
        url = '{SERVER_DOMAIN}//admin/commodities/{commodity_id}/specification'.format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, commodity_id=commodity_id)
        data = {}
        for k, v in kwargs.items():
            if k in ('specification_objs', 'delete_specification_ids'):
                data[k] = v
        return self.client.post(url, json=data)
