local publicRead = include("publicRead")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local KingdomBattleTargetBoxDetailPanel = class("KingdomBattleTargetBoxDetailPanel", baseFguiPanel)
function KingdomBattleTargetBoxDetailPanel:ctor(...)
	self.super.ctor(self, ...)
	print("KingdomBattleTargetBoxDetailPanel:ctor", self.viewName)
end
function KingdomBattleTargetBoxDetailPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function KingdomBattleTargetBoxDetailPanel:onInit()
	print("=======KingdomBattleTargetBoxDetailPanel:onInit")
	self.fields.List_reward:setItemRenderer(handler(self, self.onRewardItemRenderer))
end
function KingdomBattleTargetBoxDetailPanel:onShow()
	print("=======KingdomBattleTargetBoxDetailPanel:onShow")
	if not self.proxy or not self.proxy.param then
		local _ENV, data = self.proxy.param, self.proxy.param
	end
	local index = data.index
	if data.alliance then
		_ENV = nil
		;(nil).num = index
		self.fields.Panel_bg:setString(i18n("common_text_3147", nil))
	else
		_ENV = i18n("common_text_3147", nil)
		i18n("common_text_3147", nil).num = index
		self.fields.Panel_bg:setString(i18n("common_text_3146", i18n("common_text_3147", nil)))
	end
	_ENV = i18n("common_text_3146", i18n("common_text_3147", nil))
	_ENV, _ENV, i18n("common_text_3146", i18n("common_text_3147", nil)).score = i18n("common_text_3146", i18n("common_text_3147", nil))
	data.goal.score, i18n("common_text_3146", i18n("common_text_3147", nil)).color = i18n("common_text_3146", i18n("common_text_3147", nil))
	local scoreStr = i18n_html("common_text_3199", i18n("common_text_3146", i18n("common_text_3147", nil)))
	self.fields.Text_score:setString(scoreStr)
	local goldField = fguiHelper.get_fields(self.fields.Text_gold)
	_ENV = i18n("common_text_3146", i18n("common_text_3147", nil))
	i18n("common_text_3146", i18n("common_text_3147", nil)).price = ""
	goldField.title:setString(i18n("common_text_3044", i18n("common_text_3146", i18n("common_text_3147", nil))))
	goldField.value:setString(data.data.totalPrice)
	_UPVALUE2_ = data.data.totalPrice
	data.data.totalPrice[1] = "itemid"
	data.data.totalPrice[2] = "count"
	self.rewards = serviceFunctions.tableFormat(data.data.reward, data.data.totalPrice)
	self.fields.List_reward:setNumItems(#self.rewards)
end
function KingdomBattleTargetBoxDetailPanel:onRewardItemRenderer(index, obj)
	local data = self.rewards[index + 1]
	if not obj.objFields then
		obj:fixChildrenPos()
		obj.objFields = fguiHelper.get_fields(obj)
	end
	local objFields = obj.objFields
	objFields.Image_color:setVisible(index % 2 == 0)
	objFields.Com_item:initData(data.itemid)
	objFields.Text_name:setString(publicRead.getName(data.itemid))
	objFields.Text_count:setString("x" .. string.formatnumberthousands(data.count))
end
return KingdomBattleTargetBoxDetailPanel
