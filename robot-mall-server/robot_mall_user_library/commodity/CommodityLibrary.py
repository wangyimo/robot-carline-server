from robot_mall_user_library.common import CommonLibrary


class CommodityLibrary(CommonLibrary):
    def get_user_commodity_by_commodity_id(self, commodity_id):
        """
        获取商品详情
        """
        url = "{SERVER_DOMAIN}/users/commodities/{commodity_id}".format(
            SERVER_DOMAIN=self.SERVER_DOMAIN, commodity_id=commodity_id)
        return self.client.get(url)
