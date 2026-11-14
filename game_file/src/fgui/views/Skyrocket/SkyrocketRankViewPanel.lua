local rocketRushRead = include("rocketRushRead")
local rocketRushCtrl = SoraDGetCtrl("rocketRushCtrl")
local lordInfoCtrl = SoraDGetCtrl("lordInfoCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local SkyrocketRankViewPanel = class("SkyrocketRankViewPanel", baseFguiPanel)
function SkyrocketRankViewPanel:ctor(...)
	self.super.ctor(self, ...)
	print("SkyrocketRankViewPanel:ctor", self.viewName)
end
function SkyrocketRankViewPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function SkyrocketRankViewPanel:onInit()
	print("=======SkyrocketRankViewPanel:onInit")
	self.fields.Com_title:initData(i18n("RocketRush_text_03"), handler(self, self.onClickClose))
	self.fields.Text_tip:setString(i18n("EidalAdha_King_text_1"))
	self.fields.Text_none:setString(i18n("herobattle_text_05"))
	self.fields.Text_none:setVisible(false)
	self.fields.Com_self:setVisible(false)
	self.fields.List:setVirtual()
	self.fields.List:setItemRenderer(handler(self, self.onListRenderer))
end
function SkyrocketRankViewPanel:onListRenderer(index, obj)
	obj:initData(self.rankList[index + 1], self.group, index + 1)
end
function SkyrocketRankViewPanel:onShow()
	print("=======SkyrocketRankViewPanel:onShow")
	self.group = self.param.group
	SoraDShowLoading(self)
	rocketRushCtrl:sendRank()
end
function SkyrocketRankViewPanel:updateView(target, data)
	SoraDCloseLoading(self)
	local selfInfo = lordInfoCtrl:getBaseInfo()
	if not data.myInfo then
		_ENV = data.myInfo
		data.myInfo.avatar = selfInfo.avatar
		data.myInfo.headid = selfInfo.imageId
		data.myInfo.name = selfInfo.nickName
		data.myInfo.score = rocketRushCtrl:getCurAllianceScore()
		data.myInfo.uid = lordInfoCtrl:getLordInfo().base.uid
		data.myInfo.rank = 0
	end
	self.myInfo = data.myInfo
	self.rankList = data.rank
	self.fields.List:setNumItems(#self.rankList)
	self.fields.Text_none:setVisible(#self.rankList == 0)
	self.fields.Com_self:initData(self.myInfo, self.group, self.myInfo.rank)
	self.fields.Com_self:setVisible(true)
end
return SkyrocketRankViewPanel
